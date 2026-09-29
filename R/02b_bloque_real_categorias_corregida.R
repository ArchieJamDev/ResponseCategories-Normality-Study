# 02b_bloque_real_categorias_corregida.R
#
# Paso 3 de la correccion por tamano (size-corrected power, Gemini #2):
# repite el submuestreo m-out-of-N de un dataset real (mismo mecanismo que
# R/02_bloque_real_categorias.R) pero calcula la tasa de rechazo con el
# umbral EMPIRICO p05 calibrado en R/07_calibrar_umbral_nulo.R
# (data/results/umbral_nulo_k<k>.csv, matcheado por el k nativo del
# instrumento) ademas de la tasa nominal a p<.05 -- el bloque real tiene
# exactamente la misma vulnerabilidad a la descalibracion por discrecion
# que el bloque simulado (mismo tipo de compuesto discreto), asi que
# corregir solo el bloque simulado y no este dejaria el manuscrito
# inconsistente.
#
# Misma semilla, mismo mecanismo de submuestreo que R/02_bloque_real_categorias.R
# -- la unica diferencia es la regla de decision aplicada al p-valor ya
# generado, para que ambas corridas sean directamente comparables.
#
# Uso: Rscript R/02b_bloque_real_categorias_corregida.R <dataset> [R] [n_list] [m_items]
#
# m_items (opcional, default 10): usa el umbral calibrado con el m nativo
# del instrumento (data/results/umbral_nulo_k<k>_m<m>.csv) en vez del umbral
# generico calibrado con m=10 -- ver R/07_calibrar_umbral_nulo.R. Chequeo de
# robustez pedido en dos rondas de revision externa (notes/prompt_revision_
# julius_v3.md y v4.md): el umbral de referencia con m=10 fijo se aplicaba a
# instrumentos con 8-22 items sin recalibrar por esa diferencia. La salida
# se guarda en un archivo separado (sufijo _m<m>) para poder comparar contra
# la version con el umbral generico, no para reemplazarla.

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Uso: Rscript R/02b_bloque_real_categorias_corregida.R <dataset> [R] [n_list] [m_items]")
}
dataset_elegido <- args[1]
R_replicas <- if (length(args) >= 2 && nzchar(args[2])) as.integer(args[2]) else 10000L

n_grid_default <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
n_grid <- if (length(args) >= 3 && nzchar(args[3])) {
  as.integer(strsplit(args[3], ",")[[1]])
} else {
  n_grid_default
}

m_items_umbral <- if (length(args) >= 4 && nzchar(args[4])) as.integer(args[4]) else 10L
sufijo_m <- if (m_items_umbral == 10L) "" else sprintf("_m%d", m_items_umbral)

ruta_datos <- file.path("data/processed", dataset_elegido)
if (!file.exists(ruta_datos)) {
  stop(sprintf("No se encontro '%s' (esperado en data/processed/, correr R/01_extract_real_subscales.R primero).", ruta_datos))
}
tabla_datos <- readr::read_csv(ruta_datos, show_col_types = FALSE)
k_nativo <- tabla_datos$k[1]
x_completo <- tabla_datos$puntaje
x_completo <- x_completo[!is.na(x_completo)]
N <- length(x_completo)

if (max(n_grid) >= N) {
  stop(sprintf(
    "n maximo del grid (%d) >= N del dataset (%d) -- submuestreo sin reemplazo invalido.",
    max(n_grid), N
  ))
}

ruta_umbral <- sprintf("data/results/umbral_nulo_k%d%s.csv", k_nativo, sufijo_m)
if (!file.exists(ruta_umbral)) {
  stop(sprintf("No se encontro '%s' -- correr R/07_calibrar_umbral_nulo.R primero.", ruta_umbral))
}
tabla_umbral <- readr::read_csv(ruta_umbral, show_col_types = FALSE)

cat(sprintf(
  "Bloque real corregido -- dataset='%s' (k=%d, N=%d), R=%d submuestras, %d tamaños de muestra\n\n",
  dataset_elegido, k_nativo, N, R_replicas, length(n_grid)
))

# Misma semilla que R/02_bloque_real_categorias.R -- misma secuencia de
# submuestras, solo cambia la regla de decision aplicada despues.
set.seed(20260918)

filas <- list()
idx <- 1
for (n in n_grid) {
  umbral_n <- tabla_umbral[tabla_umbral$n == n, ]
  if (nrow(umbral_n) != 11) {
    stop(sprintf("No hay umbral empirico para k=%d, n=%d en %s", k_nativo, n, ruta_umbral))
  }
  umbral_vec <- setNames(umbral_n$umbral_p05_empirico, umbral_n$prueba)

  pvals_matriz <- NULL
  nombres_pruebas <- NULL
  t0 <- Sys.time()
  for (r in seq_len(R_replicas)) {
    x <- sample(x_completo, size = n, replace = FALSE)
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
    dataset = dataset_elegido, k = k_nativo, N = N, n = n, R = R_replicas,
    m_umbral = m_items_umbral,
    prueba = nombres_pruebas,
    tasa_nominal_05 = tasas_nominal,
    tasa_corregida = tasas_corregida,
    n_na = n_na,
    stringsAsFactors = FALSE
  )
  filas[[idx]] <- fila
  idx <- idx + 1

  cat(sprintf(
    "%-14s k=%d n=%4d -> %7.1fs total (%.2fms/replica)\n",
    dataset_elegido, k_nativo, n, segundos, 1000 * segundos / R_replicas
  ))
}

tabla <- do.call(rbind, filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
dataset_base <- sub("\\.csv$", "", dataset_elegido)
out_path <- sprintf("data/results/bloque_real_%s_corregido%s.csv", dataset_base, sufijo_m)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
