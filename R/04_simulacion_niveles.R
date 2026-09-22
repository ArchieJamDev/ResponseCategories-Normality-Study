# 04_simulacion_niveles.R
#
# Simulacion completa (R=10000) de UN nivel de (asimetria, curtosis) x UN k,
# sobre el grid completo de n -- mismo grid que el resto del proyecto
# {10,25,50,100,250,500,1000,1500}. Genera R replicas del compuesto (factor
# comun theta + m=10 items discretizados en k categorias via los umbrales
# calibrados en R/03_calibrar_niveles.R, con la lambda TAMBIEN calibrada por
# celda -- no fija) y corre la bateria completa de 11 pruebas
# (R/08_run_battery.R).
#
# Objetivo: separar el efecto de k, n y paridad (ya explorados con asimetria
# fija en el ancla real de cada dataset) del efecto de la FORMA de la
# distribucion misma -- 5 niveles ordenados de "casi normal" a "muy asimetrica
# y leptocurtica" (ver notes/DESIGN.md), cruzados con el mismo grid de k y n
# que el resto del proyecto.
#
# Requiere que data/results/calibracion_niveles.csv ya este commiteado (ver
# R/03_calibrar_niveles.R y su consolidacion) -- lee lambda y los umbrales de
# ahi, no recalibra.
#
# Uso: Rscript R/04_simulacion_niveles.R <nivel> <k> [R] [n_list]

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Uso: Rscript R/04_simulacion_niveles.R <nivel> <k> [R] [n_list]")
}
nivel_elegido <- args[1]
k_elegido <- as.integer(args[2])
R_replicas <- if (length(args) >= 3) as.integer(args[3]) else 10000L

n_grid_default <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
n_grid <- if (length(args) >= 4) {
  as.integer(strsplit(args[4], ",")[[1]])
} else {
  n_grid_default
}
es_grid_default <- identical(sort(n_grid), sort(n_grid_default))

ruta_calib <- "data/results/calibracion_niveles.csv"
if (!file.exists(ruta_calib)) {
  stop(sprintf("No se encontro '%s' -- correr y consolidar R/03_calibrar_niveles.R primero.", ruta_calib))
}
calib <- readr::read_csv(ruta_calib, show_col_types = FALSE)
fila_calib <- calib[calib$nivel == nivel_elegido & calib$k == k_elegido, ]
if (nrow(fila_calib) != 1) {
  stop(sprintf("No se encontro (o hay mas de una) calibracion para nivel='%s', k=%d en %s",
               nivel_elegido, k_elegido, ruta_calib))
}
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
  "Simulacion niveles -- nivel='%s' k=%d (lambda=%.4f, skew_objetivo=%.3f, kurt_exc_objetivo=%.3f), R=%d, %d tamaños de muestra\n\n",
  nivel_elegido, k_elegido, lambda_nivel, fila_calib$skew_objetivo[1], fila_calib$kurt_exc_objetivo[1],
  R_replicas, length(n_grid)
))

set.seed(20260922)

filas <- list()
idx <- 1
for (n in n_grid) {
  rechazos <- NULL
  nombres_pruebas <- NULL
  t0 <- Sys.time()
  for (r in seq_len(R_replicas)) {
    x <- generar_nivel(n)
    pvals <- run_battery(x)
    if (is.null(rechazos)) {
      nombres_pruebas <- names(pvals)
      rechazos <- matrix(NA, nrow = R_replicas, ncol = length(pvals))
    }
    rechazos[r, ] <- pvals < 0.05
  }
  tasas <- colMeans(rechazos, na.rm = TRUE)
  n_na <- colSums(is.na(rechazos))
  names(tasas) <- nombres_pruebas
  names(n_na) <- paste0(nombres_pruebas, "_na")
  segundos <- as.numeric(Sys.time() - t0, units = "secs")

  fila <- c(
    list(nivel = nivel_elegido, k = k_elegido, n = n, R = R_replicas),
    as.list(tasas), as.list(n_na),
    list(segundos = segundos)
  )
  filas[[idx]] <- as.data.frame(fila, stringsAsFactors = FALSE)
  idx <- idx + 1

  cat(sprintf(
    "nivel=%-14s k=%d n=%4d -> %7.1fs total (%.2fms/replica)\n",
    nivel_elegido, k_elegido, n, segundos, 1000 * segundos / R_replicas
  ))
}

tabla <- do.call(rbind, filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- if (es_grid_default) {
  sprintf("data/results/nivel_%s_k%d.csv", nivel_elegido, k_elegido)
} else {
  sprintf("data/results/nivel_%s_k%d_n%s.csv", nivel_elegido, k_elegido, paste(n_grid, collapse = "-"))
}
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
