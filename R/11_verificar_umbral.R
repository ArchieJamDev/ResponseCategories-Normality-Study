# 11_verificar_umbral.R
#
# Verificacion FUERA DE MUESTRA del umbral empirico p05 de R/07_calibrar_umbral_nulo.R
# (observacion externa nov 2026, punto 4: "demostrar que la calibracion
# funciona fuera de la muestra utilizada para construirla").
#
# R/07 estima el umbral como el percentil 5 de 10.000 p-valores simulados bajo
# la celda de referencia (asimetria = curtosis = 0, mismo mecanismo discreto).
# Aplicado a ESAS MISMAS replicas, la tasa de rechazo es 5% por construccion,
# asi que no demuestra nada. Este script:
#   1. simula R replicas NUEVAS de la misma celda de referencia con otra semilla
#      (20261108, distinta de la 20260922 usada para estimar el umbral);
#   2. aplica el umbral ORIGINAL (data/results/umbral_nulo_k<k>.csv) y reporta
#      la tasa de rechazo con p < umbral (la regla usada en el manuscrito) y con
#      p <= umbral, mas la proporcion de p-valores empatados exactamente con el
#      umbral (los empates importan porque la composicion discreta produce
#      p-valores repetidos, sobre todo con n chico);
#   3. re-estima el umbral con las replicas nuevas y su intervalo bootstrap
#      percentil del 95% (B = 1000, remuestreando los p-valores), para
#      cuantificar la incertidumbre Monte Carlo del umbral.
#
# Uso: Rscript R/11_verificar_umbral.R <k> [R] [B]
# Salida: data/results/verificacion_umbral_k<k>.csv

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("Uso: Rscript R/11_verificar_umbral.R <k> [R] [B]")
k_elegido <- as.integer(args[1])
R_replicas <- if (length(args) >= 2 && nzchar(args[2])) as.integer(args[2]) else 10000L
B_boot <- if (length(args) >= 3 && nzchar(args[3])) as.integer(args[3]) else 1000L
n_grid <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
m_items <- 10L

calib <- readr::read_csv("data/results/calibracion_nivel_normal.csv", show_col_types = FALSE)
fila_calib <- calib[calib$nivel == "normal" & calib$k == k_elegido, ]
stopifnot(nrow(fila_calib) == 1)
lambda_nivel <- fila_calib$lambda[1]
cols_umbral <- grep("^umbral_", names(fila_calib), value = TRUE)
cols_umbral <- cols_umbral[order(as.integer(sub("umbral_", "", cols_umbral)))]
umbrales_nivel <- as.numeric(fila_calib[1, cols_umbral])
umbrales_nivel <- umbrales_nivel[!is.na(umbrales_nivel)]
stopifnot(length(umbrales_nivel) == k_elegido - 1)

tabla_umbral <- readr::read_csv(sprintf("data/results/umbral_nulo_k%d.csv", k_elegido),
                                show_col_types = FALSE)

generar_nivel <- function(n) {
  theta <- rnorm(n)
  eps <- matrix(rnorm(n * m_items), nrow = n, ncol = m_items)
  latente <- lambda_nivel * theta + sqrt(1 - lambda_nivel^2) * eps
  respuestas <- matrix(1L, nrow = n, ncol = m_items)
  for (t in umbrales_nivel) respuestas <- respuestas + (latente > t)
  rowSums(respuestas)
}

cat(sprintf("Verificacion del umbral -- k=%d (lambda=%.4f), R=%d, B=%d, semilla 20261108\n\n",
            k_elegido, lambda_nivel, R_replicas, B_boot))

set.seed(20261108)

filas <- list()
for (n in n_grid) {
  umbral_n <- tabla_umbral[tabla_umbral$n == n, ]
  stopifnot(nrow(umbral_n) == 11)
  umbral_vec <- setNames(umbral_n$umbral_p05_empirico, umbral_n$prueba)

  pvals_matriz <- NULL
  nombres_pruebas <- NULL
  t0 <- Sys.time()
  for (r in seq_len(R_replicas)) {
    pvals <- run_battery(generar_nivel(n))
    if (is.null(pvals_matriz)) {
      nombres_pruebas <- names(pvals)
      pvals_matriz <- matrix(NA_real_, nrow = R_replicas, ncol = length(pvals))
    }
    pvals_matriz[r, ] <- pvals
  }

  for (j in seq_along(nombres_pruebas)) {
    p <- pvals_matriz[, j]
    p_ok <- p[!is.na(p)]
    u_orig <- unname(umbral_vec[nombres_pruebas[j]])
    if (length(p_ok) == 0) {
      # Prueba no calculable en este n (p. ej. D'Agostino-Pearson con n = 10)
      filas[[length(filas) + 1]] <- data.frame(
        k = k_elegido, n = n, R = R_replicas, prueba = nombres_pruebas[j],
        umbral_original = u_orig, tasa_rechazo_estricta = NA_real_,
        tasa_rechazo_inclusiva = NA_real_, prop_empate_en_umbral = NA_real_,
        umbral_nuevo = NA_real_, umbral_nuevo_ic_inf = NA_real_,
        umbral_nuevo_ic_sup = NA_real_, umbral_original_dentro_ic = NA,
        n_na = sum(is.na(p)), stringsAsFactors = FALSE)
      next
    }
    u_nuevo <- unname(stats::quantile(p_ok, 0.05, type = 7))
    boot <- replicate(B_boot, stats::quantile(sample(p_ok, replace = TRUE), 0.05, type = 7, names = FALSE))
    filas[[length(filas) + 1]] <- data.frame(
      k = k_elegido, n = n, R = R_replicas, prueba = nombres_pruebas[j],
      umbral_original = u_orig,
      tasa_rechazo_estricta = mean(p_ok < u_orig),
      tasa_rechazo_inclusiva = mean(p_ok <= u_orig),
      prop_empate_en_umbral = mean(p_ok == u_orig),
      umbral_nuevo = u_nuevo,
      umbral_nuevo_ic_inf = unname(stats::quantile(boot, 0.025)),
      umbral_nuevo_ic_sup = unname(stats::quantile(boot, 0.975)),
      umbral_original_dentro_ic = u_orig >= stats::quantile(boot, 0.025) &&
                                  u_orig <= stats::quantile(boot, 0.975),
      n_na = sum(is.na(p)),
      stringsAsFactors = FALSE
    )
  }
  cat(sprintf("k=%d n=%4d -> %7.1fs\n", k_elegido, n, as.numeric(Sys.time() - t0, units = "secs")))
}

tabla <- do.call(rbind, filas)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/verificacion_umbral_k%d.csv", k_elegido)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\nListo.\n", out_path))
