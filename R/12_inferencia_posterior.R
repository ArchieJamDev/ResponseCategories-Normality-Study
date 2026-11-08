# 12_inferencia_posterior.R
#
# Consecuencias para el analisis posterior (observacion externa nov 2026,
# punto 2): el estudio principal mide tasas de rechazo y potencia de pruebas de
# normalidad, pero no evalua si las desviaciones simuladas afectan a las
# pruebas que se eligen despues. Este script compara dos grupos independientes
# de tamano n cada uno, generados con el MISMO mecanismo discreto de cada celda
# (nivel x k) o de la celda de referencia 'normal', y registra:
#   - escenario "nula": ambos grupos con la misma distribucion -> error tipo I
#     de la t de Student, la t de Welch y Mann-Whitney (alpha = .05);
#   - escenario "desplazamiento": el segundo grupo con el factor comun
#     desplazado delta = 0.3 (unidades de theta); se reporta el tamano del efecto
#     realizado d (diferencia de medias / desv. tipica agrupada, estimado con
#     400.000 observaciones por grupo) y la potencia de las tres pruebas.
# Es una simulacion de inferencia posterior, no de pruebas de normalidad: no usa
# R/08_run_battery.R y solo requiere R base.
#
# Uso: Rscript R/12_inferencia_posterior.R <nivel> <k> [R]
# nivel: bajo | bajo_moderado | moderado | alto | muy_alto | normal
# Salida: data/results/inferencia_<nivel>_k<k>.csv

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("Uso: Rscript R/12_inferencia_posterior.R <nivel> <k> [R]")
nivel_elegido <- args[1]
k_elegido <- as.integer(args[2])
R_replicas <- if (length(args) >= 3 && nzchar(args[3])) as.integer(args[3]) else 10000L
n_grid <- c(10, 25, 50, 100, 250, 500, 1000)   # n POR GRUPO
m_items <- 10L
delta_theta <- 0.3

ruta_calib <- "data/results/calibracion_niveles.csv"
calib <- read.csv(ruta_calib)
fila <- calib[calib$nivel == nivel_elegido & calib$k == k_elegido, ]
if (nrow(fila) != 1) {
  calib <- read.csv(sprintf("data/results/calibracion_nivel_%s.csv", nivel_elegido))
  fila <- calib[calib$nivel == nivel_elegido & calib$k == k_elegido, ]
}
stopifnot(nrow(fila) == 1)
lambda_nivel <- fila$lambda[1]
cols <- grep("^umbral_", names(fila), value = TRUE)
cols <- cols[order(as.integer(sub("umbral_", "", cols)))]
umbrales <- as.numeric(fila[1, cols])
umbrales <- umbrales[!is.na(umbrales)]
stopifnot(length(umbrales) == k_elegido - 1)

generar <- function(n, desplazamiento = 0) {
  theta <- rnorm(n) + desplazamiento
  eps <- matrix(rnorm(n * m_items), nrow = n, ncol = m_items)
  latente <- lambda_nivel * theta + sqrt(1 - lambda_nivel^2) * eps
  resp <- matrix(1L, nrow = n, ncol = m_items)
  for (t in umbrales) resp <- resp + (latente > t)
  rowSums(resp)
}

# Tamano del efecto realizado del desplazamiento (poblacional aproximado)
set.seed(20261109)
a <- generar(400000); b <- generar(400000, delta_theta)
d_real <- (mean(b) - mean(a)) / sqrt((var(a) + var(b)) / 2)

pruebas_dos_grupos <- function(x, y, n) {
  m1 <- mean(x); m2 <- mean(y); v1 <- var(x); v2 <- var(y)
  if (v1 + v2 == 0) return(c(NA_real_, NA_real_, NA_real_))
  sp2 <- (v1 + v2) / 2
  t_s <- (m1 - m2) / sqrt(2 * sp2 / n)
  p_s <- 2 * pt(-abs(t_s), df = 2 * n - 2)
  se2 <- (v1 + v2) / n
  df_w <- se2^2 / (((v1 / n)^2 + (v2 / n)^2) / (n - 1))
  p_w <- 2 * pt(-abs((m1 - m2) / sqrt(se2)), df = df_w)
  p_mw <- suppressWarnings(wilcox.test(x, y, exact = FALSE)$p.value)
  c(p_s, p_w, p_mw)
}

cat(sprintf("Inferencia posterior -- nivel='%s' k=%d (lambda=%.4f), R=%d, d_real=%.3f\n\n",
            nivel_elegido, k_elegido, lambda_nivel, R_replicas, d_real))

set.seed(20261109)
nombres <- c("t_student", "t_welch", "mann_whitney")
filas <- list()
for (n in n_grid) {
  t0 <- Sys.time()
  for (esc in c("nula", "desplazamiento")) {
    desp <- if (esc == "nula") 0 else delta_theta
    P <- matrix(NA_real_, nrow = R_replicas, ncol = 3)
    for (r in seq_len(R_replicas)) {
      P[r, ] <- pruebas_dos_grupos(generar(n), generar(n, desp), n)
    }
    filas[[length(filas) + 1]] <- data.frame(
      nivel = nivel_elegido, k = k_elegido, n_por_grupo = n, R = R_replicas,
      escenario = esc, d_real = if (esc == "nula") 0 else d_real,
      prueba = nombres, tasa_rechazo = colMeans(P < 0.05, na.rm = TRUE),
      n_na = colSums(is.na(P)), stringsAsFactors = FALSE
    )
  }
  cat(sprintf("nivel=%-14s k=%d n=%4d -> %6.1fs\n", nivel_elegido, k_elegido, n,
              as.numeric(Sys.time() - t0, units = "secs")))
}

tabla <- do.call(rbind, filas)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/inferencia_%s_k%d.csv", nivel_elegido, k_elegido)
write.csv(tabla, out_path, row.names = FALSE)
cat(sprintf("\nGuardado %s\nListo.\n", out_path))
