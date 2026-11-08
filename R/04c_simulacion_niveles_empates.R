# 04c_simulacion_niveles_empates.R
#
# Sensibilidad de la potencia corregida a los EMPATES en el umbral.
#
# R/11_verificar_umbral.R mostro que, en 48 de 609 combinaciones (k, n, prueba)
# (sobre todo Cramer-von Mises, Anderson-Darling, chi^2 de Pearson y SSTN con k
# chico y n grande), el umbral empirico p05 de R/07 cae sobre un valor al que
# llegan muchos p-valores bajo la referencia (el piso numerico del p-valor: 0,
# 7.37e-10, 3.7e-24...). En esas celdas la regla estricta "p < umbral" rechaza
# 0% (no 5%) y la regla "p <= umbral" rechaza casi 100%, asi que el 5% exacto no
# se alcanza sin aleatorizar. Este script repite la simulacion de R/04b con una
# regla de rechazo ALEATORIZADA que da exactamente 5% bajo la referencia:
#   u = menor p tal que P(p <= u) >= .05 (cuantil inferior de la ECDF);
#   rechazar si p < u; si p == u, rechazar con probabilidad
#   q = (.05 - P(p < u)) / P(p == u).
# Reproduce los umbrales de R/07 re-simulando la celda de referencia con la
# misma semilla (20260922) y reproduce los datos de R/04b con la misma semilla.
# Guarda la tasa corregida estricta (debe coincidir con R/04b), la tasa
# corregida con la regla aleatorizada, u y q.
#
# Uso: Rscript R/04c_simulacion_niveles_empates.R <nivel> <k> [R]
# Salida: data/results/nivel_<nivel>_k<k>_corregido_empates.csv

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("Uso: Rscript R/04c_simulacion_niveles_empates.R <nivel> <k> [R]")
nivel_elegido <- args[1]
k_elegido <- as.integer(args[2])
R_replicas <- if (length(args) >= 3 && nzchar(args[3])) as.integer(args[3]) else 10000L
n_grid <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
m_items <- 10L

leer_celda <- function(ruta_general, nivel, k) {
  calib <- readr::read_csv(ruta_general, show_col_types = FALSE)
  fila <- calib[calib$nivel == nivel & calib$k == k, ]
  stopifnot(nrow(fila) == 1)
  cols <- grep("^umbral_", names(fila), value = TRUE)
  cols <- cols[order(as.integer(sub("umbral_", "", cols)))]
  u <- as.numeric(fila[1, cols]); u <- u[!is.na(u)]
  stopifnot(length(u) == k - 1)
  list(lambda = fila$lambda[1], umbrales = u)
}

# Celda de severidad (misma logica que R/04b)
ruta_niv <- "data/results/calibracion_niveles.csv"
calib_niv <- readr::read_csv(ruta_niv, show_col_types = FALSE)
if (nrow(calib_niv[calib_niv$nivel == nivel_elegido & calib_niv$k == k_elegido, ]) == 1) {
  cel_niv <- leer_celda(ruta_niv, nivel_elegido, k_elegido)
} else {
  cel_niv <- leer_celda(sprintf("data/results/calibracion_nivel_%s.csv", nivel_elegido),
                        nivel_elegido, k_elegido)
}
# Celda de referencia (misma logica que R/07)
cel_ref <- leer_celda("data/results/calibracion_nivel_normal.csv", "normal", k_elegido)

generador <- function(cel) {
  function(n) {
    theta <- rnorm(n)
    eps <- matrix(rnorm(n * m_items), nrow = n, ncol = m_items)
    latente <- cel$lambda * theta + sqrt(1 - cel$lambda^2) * eps
    resp <- matrix(1L, nrow = n, ncol = m_items)
    for (t in cel$umbrales) resp <- resp + (latente > t)
    rowSums(resp)
  }
}
gen_ref <- generador(cel_ref)
gen_niv <- generador(cel_niv)

tabla_umbral <- readr::read_csv(sprintf("data/results/umbral_nulo_k%d.csv", k_elegido),
                                show_col_types = FALSE)

pvals_celda <- function(gen, n) {
  M <- NULL
  for (r in seq_len(R_replicas)) {
    p <- run_battery(gen(n))
    if (is.null(M)) { M <- matrix(NA_real_, R_replicas, length(p)); colnames(M) <- names(p) }
    M[r, ] <- p
  }
  M
}

cat(sprintf("Sensibilidad por empates -- nivel='%s' k=%d, R=%d\n\n", nivel_elegido, k_elegido, R_replicas))

# Paso 1: reproducir la referencia (semilla de R/07) y derivar (u, q) por n y prueba
set.seed(20260922)
regla <- list()
for (n in n_grid) {
  Mref <- pvals_celda(gen_ref, n)
  un <- tabla_umbral[tabla_umbral$n == n, ]
  u_viejo <- setNames(un$umbral_p05_empirico, un$prueba)
  r <- do.call(rbind, lapply(colnames(Mref), function(nm) {
    p <- Mref[, nm]; p <- p[!is.na(p)]
    if (length(p) == 0) return(data.frame(prueba = nm, u = NA_real_, q = NA_real_,
                                           masa_empate = NA_real_, u_r07 = unname(u_viejo[nm])))
    ps <- sort(p)
    u <- ps[ceiling(0.05 * length(ps))]
    p_lt <- mean(p < u); p_eq <- mean(p == u)
    q <- if (p_eq > 0) min(1, max(0, (0.05 - p_lt) / p_eq)) else 0
    data.frame(prueba = nm, u = u, q = q, masa_empate = p_eq, u_r07 = unname(u_viejo[nm]))
  }))
  regla[[as.character(n)]] <- r
}

# Paso 2: severidad con la misma semilla que R/04b. Primero se generan TODOS los
# p-valores (para que el flujo aleatorio de datos sea identico al de R/04b);
# la aleatorizacion de empates usa un flujo aparte despues.
set.seed(20260922)
Mlist <- list()
for (n in n_grid) {
  Mlist[[as.character(n)]] <- pvals_celda(gen_niv, n)
  cat(sprintf("nivel=%s k=%d n=%d simulado\n", nivel_elegido, k_elegido, n))
}

set.seed(20261110)
filas <- list()
for (n in n_grid) {
  M <- Mlist[[as.character(n)]]
  r <- regla[[as.character(n)]]
  for (j in seq_len(ncol(M))) {
    nm <- colnames(M)[j]; rr <- r[r$prueba == nm, ]
    p <- M[, j]; ok <- !is.na(p)
    if (!any(ok)) {
      estricta <- aleat <- NA_real_
    } else {
      estricta <- mean(p[ok] < rr$u_r07)
      amb <- p[ok] == rr$u
      aleat <- mean((p[ok] < rr$u) | (amb & (runif(sum(ok)) < rr$q)))
    }
    filas[[length(filas) + 1]] <- data.frame(
      nivel = nivel_elegido, k = k_elegido, n = n, R = R_replicas, prueba = nm,
      tasa_corregida_estricta = estricta, tasa_corregida_aleatorizada = aleat,
      u = rr$u, q = rr$q, masa_empate_ref = rr$masa_empate, u_r07 = rr$u_r07,
      stringsAsFactors = FALSE)
  }
}

tabla <- do.call(rbind, filas)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/nivel_%s_k%d_corregido_empates.csv", nivel_elegido, k_elegido)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\nListo.\n", out_path))
