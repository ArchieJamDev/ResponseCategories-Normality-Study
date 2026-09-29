# 04b_simulacion_niveles_corregida.R
#
# Paso 2 de la correccion por tamano (size-corrected power, Gemini #2):
# repite la simulacion de UN nivel de severidad x UN k (mismo mecanismo
# generativo que R/04_simulacion_niveles.R) pero usa el umbral de rechazo
# EMPIRICO calibrado en R/07_calibrar_umbral_nulo.R (data/results/
# umbral_nulo_k<k>.csv) en vez de p<.05 nominal. No se puede reusar la
# corrida original (data/results/nivel_<nivel>_k<k>.csv) porque esa solo
# guardo la decision booleana a p<.05, no el p-valor -- hace falta volver a
# generar las R replicas desde cero con la MISMA semilla que la corrida
# original, para que la unica diferencia entre ambos resultados sea el
# umbral de decision, no el ruido Monte Carlo.
#
# Guarda AMBAS tasas (nominal a p<.05, y corregida con el umbral empirico)
# para poder comparar directamente cuanto cambia la potencia reportada.
#
# Uso: Rscript R/04b_simulacion_niveles_corregida.R <nivel> <k> [R] [n_list]

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Uso: Rscript R/04b_simulacion_niveles_corregida.R <nivel> <k> [R] [n_list]")
}
nivel_elegido <- args[1]
k_elegido <- as.integer(args[2])
R_replicas <- if (length(args) >= 3 && nzchar(args[3])) as.integer(args[3]) else 10000L

n_grid_default <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
n_grid <- if (length(args) >= 4 && nzchar(args[4])) {
  as.integer(strsplit(args[4], ",")[[1]])
} else {
  n_grid_default
}

# --- Calibracion del nivel (identica logica que R/04_simulacion_niveles.R) -

ruta_calib <- "data/results/calibracion_niveles.csv"
calib <- readr::read_csv(ruta_calib, show_col_types = FALSE)
fila_calib <- calib[calib$nivel == nivel_elegido & calib$k == k_elegido, ]
if (nrow(fila_calib) != 1) {
  ruta_calib_nivel <- sprintf("data/results/calibracion_nivel_%s.csv", nivel_elegido)
  calib_nivel <- readr::read_csv(ruta_calib_nivel, show_col_types = FALSE)
  fila_calib <- calib_nivel[calib_nivel$nivel == nivel_elegido & calib_nivel$k == k_elegido, ]
  stopifnot(nrow(fila_calib) == 1)
}
lambda_nivel <- fila_calib$lambda[1]
cols_umbral <- grep("^umbral_", names(fila_calib), value = TRUE)
cols_umbral <- cols_umbral[order(as.integer(sub("umbral_", "", cols_umbral)))]
umbrales_nivel <- as.numeric(fila_calib[1, cols_umbral])
umbrales_nivel <- umbrales_nivel[!is.na(umbrales_nivel)]
stopifnot(length(umbrales_nivel) == k_elegido - 1)

# --- Umbral empirico p05 por prueba x n (Paso 1) ---------------------------

ruta_umbral <- sprintf("data/results/umbral_nulo_k%d.csv", k_elegido)
if (!file.exists(ruta_umbral)) {
  stop(sprintf("No se encontro '%s' -- correr R/07_calibrar_umbral_nulo.R primero.", ruta_umbral))
}
tabla_umbral <- readr::read_csv(ruta_umbral, show_col_types = FALSE)

m_items <- 10L

generar_nivel <- function(n) {
  theta <- rnorm(n)
  eps <- matrix(rnorm(n * m_items), nrow = n, ncol = m_items)
  latente <- lambda_nivel * theta + sqrt(1 - lambda_nivel^2) * eps
  respuestas <- matrix(1L, nrow = n, ncol = m_items)
  for (t in umbrales_nivel) respuestas <- respuestas + (latente > t)
  rowSums(respuestas)
}

cat(sprintf(
  "Simulacion corregida -- nivel='%s' k=%d (lambda=%.4f), R=%d, %d tamaños de muestra\n\n",
  nivel_elegido, k_elegido, lambda_nivel, R_replicas, length(n_grid)
))

# Misma semilla que R/04_simulacion_niveles.R: la secuencia de datos
# generada es identica, solo cambia la regla de decision aplicada despues.
set.seed(20260922)

filas <- list()
idx <- 1
for (n in n_grid) {
  umbral_n <- tabla_umbral[tabla_umbral$n == n, ]
  stopifnot(nrow(umbral_n) == 11)
  umbral_vec <- setNames(umbral_n$umbral_p05_empirico, umbral_n$prueba)

  pvals_matriz <- NULL
  nombres_pruebas <- NULL
  t0 <- Sys.time()
  for (r in seq_len(R_replicas)) {
    x <- generar_nivel(n)
    pvals <- run_battery(x)
    if (is.null(pvals_matriz)) {
      nombres_pruebas <- names(pvals)
      pvals_matriz <- matrix(NA_real_, nrow = R_replicas, ncol = length(pvals))
    }
    pvals_matriz[r, ] <- pvals
  }
  umbral_ordenado <- umbral_vec[nombres_pruebas]
  rechazo_nominal <- sweep(pvals_matriz, 2, 0.05, `<`)
  rechazo_corregido <- sweep(pvals_matriz, 2, umbral_ordenado, `<`)

  tasas_nominal <- colMeans(rechazo_nominal, na.rm = TRUE)
  tasas_corregida <- colMeans(rechazo_corregido, na.rm = TRUE)
  n_na <- colSums(is.na(pvals_matriz))
  segundos <- as.numeric(Sys.time() - t0, units = "secs")

  fila <- data.frame(
    nivel = nivel_elegido, k = k_elegido, n = n, R = R_replicas,
    prueba = nombres_pruebas,
    tasa_nominal_05 = tasas_nominal,
    tasa_corregida = tasas_corregida,
    n_na = n_na,
    stringsAsFactors = FALSE
  )
  filas[[idx]] <- fila
  idx <- idx + 1

  cat(sprintf("nivel=%-14s k=%d n=%4d -> %7.1fs (%.2fms/replica)\n",
              nivel_elegido, k_elegido, n, segundos, 1000 * segundos / R_replicas))
}

tabla <- do.call(rbind, filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/nivel_%s_k%d_corregido.csv", nivel_elegido, k_elegido)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
