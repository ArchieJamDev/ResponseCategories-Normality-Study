# 03_calibrar_niveles.R
#
# Calibra los umbrales Y la carga factorial lambda (a diferencia del Bloque 5
# de SSTN-Normality-Study, que fija lambda=0.8 y solo calibra umbrales) para
# 5 niveles de (asimetria, curtosis exceso) del compuesto simulado, para cada
# k en 3..9. Objetivo: aislar el efecto de k, n y paridad de la forma real de
# la distribucion, variando la forma en un solo eje ordenado en vez de
# confundirla con k como pasaba en el bloque real (ver notes/DESIGN.md).
#
# Por que lambda libre: un chequeo de factibilidad (ver notes/DESIGN.md)
# encontro que con lambda FIJO en 0.8 (diseño original de Bloque 5), el
# mecanismo factor-comun + umbrales solo alcanza curtosis NEGATIVA -- los 12
# escenarios de SSTN-Normality-Study son todos platicurticos. Dejando lambda
# libre (mismo mecanismo, un parametro mas en la optimizacion) el espacio
# alcanzable incluye curtosis positiva -- necesario para el Nivel 5 (muy
# alto, ancla real: RWAS, asimetria=1.35 curtosis=+1.17).
#
# Mismo metodo exacto que R/09b_calibrar_extension_bloque5.R de
# SSTN-Normality-Study salvo por lambda libre: factor comun theta~N(0,1),
# m=10 items, item_j = lambda*theta + sqrt(1-lambda^2)*eps_j; numeros
# aleatorios comunes (N=150.000, semilla 20260922) generados UNA sola vez y
# reusados en todas las celdas, para que las comparaciones entre niveles/k no
# esten contaminadas por ruido Monte Carlo distinto entre celdas.
#
# Parametrizacion sin restricciones: lambda = plogis(params[1]) (mantiene
# lambda en (0,1) sin restringir el optimizador); umbrales = primer_umbral +
# cumsum(exp(log_gaps)) (crecientes), igual que el diseño original.
#
# Uso: Rscript R/03_calibrar_niveles.R <nivel> [k_list] [n_starts]
#   <nivel>: "bajo", "bajo_moderado", "moderado", "alto", "muy_alto"
#   [k_list]: lista de k separados por coma (default 3,4,5,6,7,8,9)
#   [n_starts]: puntos de partida distintos por celda (default 8 -- mas que
#               el original porque ahora hay un parametro adicional (lambda)
#               y el Nivel 5 en particular es una region mas dificil de
#               alcanzar, ver notes/DESIGN.md)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Uso: Rscript R/03_calibrar_niveles.R <nivel> [k_list] [n_starts]")
}
nivel_elegido <- args[1]

objetivos_niveles <- list(
  bajo          = c(skew = 0.0,  kurt_exc = -0.70),
  bajo_moderado = c(skew = 0.2,  kurt_exc = -0.55),
  moderado      = c(skew = 0.7,  kurt_exc = -0.15),
  alto          = c(skew = 1.0,  kurt_exc =  0.40),
  muy_alto      = c(skew = 1.35, kurt_exc =  1.17)
)
if (!nivel_elegido %in% names(objetivos_niveles)) {
  stop(sprintf("Nivel desconocido: '%s'. Debe ser uno de: %s",
               nivel_elegido, paste(names(objetivos_niveles), collapse=", ")))
}
target_skew <- objetivos_niveles[[nivel_elegido]][["skew"]]
target_kurt <- objetivos_niveles[[nivel_elegido]][["kurt_exc"]]

k_list <- if (length(args) >= 2 && nzchar(args[2])) {
  as.integer(strsplit(args[2], ",")[[1]])
} else {
  3:9
}
n_starts <- if (length(args) >= 3) as.integer(args[3]) else 8L

m_items <- 10L
N_calib <- 150000L
semilla_calib <- 20260922L

set.seed(semilla_calib)
theta_comun <- rnorm(N_calib)
eps_comun   <- matrix(rnorm(N_calib * m_items), nrow = N_calib, ncol = m_items)

composite_moments <- function(lambda, umbrales, theta = theta_comun, eps = eps_comun) {
  latente <- lambda * theta + sqrt(1 - lambda^2) * eps
  respuestas <- matrix(1L, nrow = length(theta), ncol = ncol(eps))
  for (t in umbrales) respuestas <- respuestas + (latente > t)
  compuesto <- rowSums(respuestas)
  mu <- mean(compuesto)
  m2 <- mean((compuesto - mu)^2)
  m3 <- mean((compuesto - mu)^3)
  m4 <- mean((compuesto - mu)^4)
  c(skew = m3 / m2^1.5, kurt_exc = m4 / m2^2 - 3)
}

umbrales_desde_params <- function(params) {
  primer <- params[2]
  gaps <- params[-(1:2)]
  if (length(gaps) > 0) {
    c(primer, primer + cumsum(exp(gaps)))
  } else {
    primer
  }
}

objetivo <- function(params, target_skew, target_kurt) {
  lambda <- plogis(params[1])
  umbrales <- umbrales_desde_params(params)
  mom <- composite_moments(lambda, umbrales)
  (mom["skew"] - target_skew)^2 + (mom["kurt_exc"] - target_kurt)^2
}

#' Calibra lambda + los k-1 umbrales de una celda via optim() Nelder-Mead
#' multi-arranque (se queda con el mejor de los n_starts resultados).
calibrar_celda <- function(k, target_skew, target_kurt, n_starts, maxit = 4000) {
  base_simetrica <- qnorm((1:(k - 1)) / k)
  # Puntos de partida: barren lambda bajo/medio/alto y corrimientos de los
  # umbrales hacia el signo del objetivo (asimetria/curtosis alta necesita
  # umbrales corridos, no centrados -- ver chequeo de factibilidad en
  # notes/DESIGN.md).
  set.seed(k * 1000L + round(target_skew * 1e4) + round(target_kurt * 1e4))
  lambdas0 <- seq(0.15, 0.85, length.out = n_starts)
  corrimientos0 <- seq(0, sign(target_skew + 0.01) * 2, length.out = n_starts)

  mejor <- NULL
  mejor_val <- Inf
  for (i in seq_len(n_starts)) {
    umb0 <- sort(base_simetrica + corrimientos0[i] + rnorm(k - 1, sd = 0.15))
    primer0 <- umb0[1]
    gaps0 <- diff(umb0)
    gaps0[gaps0 <= 1e-6] <- 1e-6
    params0 <- c(qlogis(lambdas0[i]), primer0, log(gaps0))
    res <- tryCatch(
      optim(params0, objetivo, target_skew = target_skew, target_kurt = target_kurt,
            method = "Nelder-Mead",
            control = list(maxit = maxit, reltol = 1e-13)),
      error = function(e) NULL
    )
    if (!is.null(res) && res$value < mejor_val) {
      mejor_val <- res$value
      mejor <- res
    }
  }
  lambda <- plogis(mejor$par[1])
  umbrales <- umbrales_desde_params(mejor$par)
  mom <- composite_moments(lambda, umbrales)
  list(lambda = lambda, umbrales = umbrales, skew = unname(mom["skew"]),
       kurt_exc = unname(mom["kurt_exc"]), dist2 = mejor_val)
}

cat(sprintf("Calibrando nivel='%s' (objetivo asimetria=%.4f, curtosis exceso=%.4f), k in {%s}\n",
            nivel_elegido, target_skew, target_kurt, paste(k_list, collapse=",")))

filas <- list()
idx <- 1
for (k in k_list) {
  t0 <- Sys.time()
  r <- calibrar_celda(k, target_skew, target_kurt, n_starts = n_starts)
  segundos <- as.numeric(Sys.time() - t0, units = "secs")
  cat(sprintf("  k=%d -> lambda=%.4f umbrales=[%s] skew=%.4f kurt_exc=%.4f dist2=%.3g (%.1fs)\n",
              k, r$lambda, paste(sprintf("%.4f", r$umbrales), collapse=", "),
              r$skew, r$kurt_exc, r$dist2, segundos))

  fila <- data.frame(
    nivel = nivel_elegido, k = k, lambda = r$lambda,
    skew_objetivo = target_skew, kurt_exc_objetivo = target_kurt,
    skew_logrado = r$skew, kurt_exc_logrado = r$kurt_exc, dist2 = r$dist2,
    stringsAsFactors = FALSE
  )
  for (j in seq_len(k - 1)) fila[[sprintf("umbral_%d", j)]] <- r$umbrales[j]
  filas[[idx]] <- fila
  idx <- idx + 1
}

tabla <- dplyr::bind_rows(filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
out_path <- sprintf("data/results/calibracion_nivel_%s.csv", nivel_elegido)
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
