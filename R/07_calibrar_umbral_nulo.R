# 07_calibrar_umbral_nulo.R
#
# Paso 1 de la correccion por tamano (size-corrected power) pedida en la
# segunda revision externa (Gemini, punto #2): en vez de usar el umbral
# nominal p<.05 para decidir "rechaza", se calibra un umbral EMPIRICO por
# (prueba, k, n) -- el percentil 5 de la distribucion de p-valores de esa
# prueba bajo el nivel de referencia "normal" (asimetria=curtosis=0, ver
# R/03_calibrar_niveles.R) -- que por construccion da exactamente 5% de
# rechazo bajo H0 para ESTE mecanismo discreto especifico, en vez de confiar
# en la calibracion asintotica de cada prueba (que ya vimos que falla para
# la mayoria de las 11 pruebas con k chico/n grande, ver la seccion
# "Calibracion de las 11 pruebas sin severidad inyectada" del manuscrito).
#
# A diferencia de R/04_simulacion_niveles.R (que descarta los p-valores
# individuales y solo guarda la tasa de rechazo a p<.05), este script
# GUARDA la distribucion completa de p-valores por prueba dentro de la
# corrida (en memoria, no en disco -- serian ~10.000 numeros x 11 pruebas x
# 8 n, manejable) para poder calcular su percentil 5 exacto.
#
# El umbral resultante (data/results/umbral_nulo_k<k>.csv) se usa despues
# en R/04b_simulacion_niveles_corregida.R para recalcular la potencia de
# los 5 niveles de severidad con este umbral en vez de .05 -- eso SI
# requiere volver a correr las 35 celdas desde cero, porque los datos ya
# guardados de esos 5 niveles tampoco tienen los p-valores individuales.
#
# Uso: Rscript R/07_calibrar_umbral_nulo.R <k> [R] [n_list]

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Uso: Rscript R/07_calibrar_umbral_nulo.R <k> [R] [n_list]")
}
k_elegido <- as.integer(args[1])
R_replicas <- if (length(args) >= 2 && nzchar(args[2])) as.integer(args[2]) else 10000L

n_grid_default <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
n_grid <- if (length(args) >= 3 && nzchar(args[3])) {
  as.integer(strsplit(args[3], ",")[[1]])
} else {
  n_grid_default
}

ruta_calib <- "data/results/calibracion_nivel_normal.csv"
if (!file.exists(ruta_calib)) {
  stop(sprintf("No se encontro '%s' -- correr R/03_calibrar_niveles.R normal primero.", ruta_calib))
}
calib <- readr::read_csv(ruta_calib, show_col_types = FALSE)
fila_calib <- calib[calib$nivel == "normal" & calib$k == k_elegido, ]
stopifnot(nrow(fila_calib) == 1)
lambda_nivel <- fila_calib$lambda[1]
cols_umbral <- grep("^umbral_", names(fila_calib), value = TRUE)
cols_umbral <- cols_umbral[order(as.integer(sub("umbral_", "", cols_umbral)))]
umbrales_nivel <- as.numeric(fila_calib[1, cols_umbral])
umbrales_nivel <- umbrales_nivel[!is.na(umbrales_nivel)]
stopifnot(length(umbrales_nivel) == k_elegido - 1)

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
  "Calibrando umbral nulo -- k=%d (lambda=%.4f), R=%d, %d tamaños de muestra\n\n",
  k_elegido, lambda_nivel, R_replicas, length(n_grid)
))

set.seed(20260922)

filas <- list()
idx <- 1
for (n in n_grid) {
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
  # Percentil 5 empirico de cada prueba (el umbral que da exactamente 5% de
  # rechazo bajo H0 en este mecanismo, en vez de asumir que p<.05 lo logra).
  umbral_p05 <- apply(pvals_matriz, 2, stats::quantile, probs = 0.05, na.rm = TRUE, type = 7)
  tasa_05_nominal <- colMeans(pvals_matriz < 0.05, na.rm = TRUE)
  n_na <- colSums(is.na(pvals_matriz))
  segundos <- as.numeric(Sys.time() - t0, units = "secs")

  fila <- data.frame(
    k = k_elegido, n = n, R = R_replicas, prueba = nombres_pruebas,
    umbral_p05_empirico = umbral_p05,
    tasa_rechazo_nominal_05 = tasa_05_nominal,
    n_na = n_na,
    stringsAsFactors = FALSE
  )
  filas[[idx]] <- fila
  idx <- idx + 1

  cat(sprintf("k=%d n=%4d -> %7.1fs (%.2fms/replica)\n", k_elegido, n, segundos, 1000 * segundos / R_replicas))
}

tabla <- do.call(rbind, filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/umbral_nulo_k%d.csv", k_elegido)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
