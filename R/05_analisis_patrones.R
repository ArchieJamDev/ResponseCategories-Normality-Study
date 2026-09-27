# 05_analisis_patrones.R
#
# Reconstruye el analisis estadistico detras de los "patrones" reportados en
# la seccion de Resultados que compara el bloque real contra el bloque
# simulado (k_paper.tex, "Reproduccion en datos reales de los patrones del
# bloque simulado"). Ese analisis se habia hecho ad hoc en una sesion previa
# (el resultado quedo transcrito en notes/DESIGN.md, seccion sobre "H1
# reevaluado con la nueva estructura") pero nunca se guardo como script --
# un hueco de reproducibilidad senalado en una revision externa (ver
# notes/prompt_revision_julius.md, punto #9). Este script cierra ese hueco:
# corre sobre datos ya commiteados en data/results/ (no requiere GitHub
# Actions, no es una "corrida real" nueva -- ver notes/DESIGN.md).
#
# Modelo (reconstruido a partir de la descripcion en prosa del manuscrito,
# no hay codigo original que reproducir exactamente):
#
#   Para cada tamano de muestra n de la grilla, dentro de un nivel de
#   severidad simulado (bajo_moderado: RSE k=4, MACH-IV k=5, HEXACO k=7;
#   alto: SPS-10 k=6, RWAS k=9; moderado: solo AHS k=8, sin regresion
#   posible con un solo instrumento), se arma un data frame con las 11
#   pruebas de normalidad como pseudo-replicas de cada instrumento (3
#   instrumentos x 11 pruebas = 33 filas en bajo_moderado; 2 x 11 = 22 en
#   alto) y se ajusta:
#
#     potencia ~ k                              (lm, un predictor continuo)
#
#   extrayendo el coeficiente de k, su error estandar, t, df residual y p.
#
#   Para la paridad de k, se pool-ean los 6 instrumentos (6 x 11 = 66 filas
#   por n, sin distinguir nivel) y se ajusta:
#
#     potencia ~ es_par                         (es_par = 1 si k es par)
#
#   con el mismo chequeo de sensibilidad ya reportado (excluir SPS-10 o
# RWAS en n=25).
#
# Los numeros que produce este script son la fuente de verdad para la
# seccion de patrones del manuscrito -- si difieren de lo que ya esta
# escrito en k_paper.tex, el texto se actualiza para igualar lo que este
# script reproduce, no al reves.
#
# Uso: Rscript R/05_analisis_patrones.R

cols_pruebas <- c(
  "shapiro_wilk", "anderson_darling", "lilliefors", "jarque_bera",
  "dagostino_pearson", "cramer_von_mises", "shapiro_francia",
  "pearson_chi2", "curtosis", "epps_pulley", "sstn"
)

archivos <- list(
  rse_k4 = list(archivo = "data/results/bloque_real_rse_k4.csv", k = 4),
  mach_k5 = list(archivo = "data/results/bloque_real_mach_k5.csv", k = 5),
  sps_k6 = list(archivo = "data/results/bloque_real_sps_k6.csv", k = 6),
  hexaco_k7 = list(archivo = "data/results/bloque_real_hexaco_k7.csv", k = 7),
  ahs_k8 = list(archivo = "data/results/bloque_real_ahs_k8_n10-25-50-100-250-500-1000.csv", k = 8),
  rwas_k9 = list(archivo = "data/results/bloque_real_rwas_k9.csv", k = 9)
)

niveles <- list(
  bajo_moderado = c("rse_k4", "mach_k5", "hexaco_k7"),
  alto = c("sps_k6", "rwas_k9"),
  moderado = c("ahs_k8")
)

# --- Cargar y poner en formato largo: una fila por instrumento x n x prueba

largo <- do.call(rbind, lapply(names(archivos), function(instr) {
  info <- archivos[[instr]]
  df <- readr::read_csv(info$archivo, show_col_types = FALSE)
  out <- tidyr::pivot_longer(df, all_of(cols_pruebas), names_to = "prueba", values_to = "potencia")
  out$instrumento <- instr
  out$k <- info$k
  out[, c("instrumento", "k", "n", "prueba", "potencia")]
}))
largo <- largo[!is.na(largo$potencia), ]

grid_n <- sort(unique(largo$n))

ajustar_k <- function(datos_n) {
  if (length(unique(datos_n$k)) < 2 || nrow(datos_n) < 4) return(NULL)
  modelo <- stats::lm(potencia ~ k, data = datos_n)
  s <- summary(modelo)$coefficients
  if (!"k" %in% rownames(s)) return(NULL)
  list(coef = s["k", "Estimate"], se = s["k", "Std. Error"],
       t = s["k", "t value"], df = modelo$df.residual, p = s["k", "Pr(>|t|)"])
}

cat("=== Patron: menos categorias (k), mas potencia -- y su dependencia de n ===\n\n")
for (nivel in c("bajo_moderado", "alto")) {
  cat(sprintf("--- Nivel: %s (instrumentos: %s) ---\n", nivel, paste(niveles[[nivel]], collapse = ", ")))
  for (n_val in grid_n) {
    datos_n <- largo[largo$instrumento %in% niveles[[nivel]] & largo$n == n_val, ]
    r <- ajustar_k(datos_n)
    if (is.null(r)) {
      cat(sprintf("  n=%5d: sin datos suficientes\n", n_val))
    } else {
      cat(sprintf(
        "  n=%5d: coef_k=%+.4f, SE=%.4f, t(%d)=%.3f, p=%.4f %s\n",
        n_val, r$coef, r$se, r$df, r$t, r$p, if (r$coef < 0) "(negativo)" else "(positivo)"
      ))
    }
  }
  cat("\n")
}

cat("=== Patron: paridad de k afecta la potencia (6 instrumentos pool-eados) ===\n\n")
largo$es_par <- as.integer(largo$k %% 2 == 0)
ajustar_paridad <- function(datos_n) {
  if (length(unique(datos_n$es_par)) < 2 || nrow(datos_n) < 4) return(NULL)
  modelo <- stats::lm(potencia ~ es_par, data = datos_n)
  s <- summary(modelo)$coefficients
  if (!"es_par" %in% rownames(s)) return(NULL)
  list(coef = s["es_par", "Estimate"], se = s["es_par", "Std. Error"],
       t = s["es_par", "t value"], df = modelo$df.residual, p = s["es_par", "Pr(>|t|)"])
}
for (n_val in grid_n) {
  datos_n <- largo[largo$n == n_val, ]
  r <- ajustar_paridad(datos_n)
  if (is.null(r)) {
    cat(sprintf("  n=%5d: sin datos suficientes\n", n_val))
  } else {
    cat(sprintf(
      "  n=%5d: coef_es_par=%+.4f, SE=%.4f, t(%d)=%.3f, p=%.4f\n",
      n_val, r$coef, r$se, r$df, r$t, r$p
    ))
  }
}

cat("\nListo.\n")

# --- Guardar resultados para el manuscrito ---------------------------------

filas <- list()
idx <- 1
for (nivel in c("bajo_moderado", "alto")) {
  for (n_val in grid_n) {
    datos_n <- largo[largo$instrumento %in% niveles[[nivel]] & largo$n == n_val, ]
    r <- ajustar_k(datos_n)
    if (!is.null(r)) {
      filas[[idx]] <- data.frame(analisis = "efecto_k_por_nivel", nivel = nivel, n = n_val,
                                  coef = r$coef, se = r$se, t = r$t, df = r$df, p = r$p)
      idx <- idx + 1
    }
  }
}
for (n_val in grid_n) {
  datos_n <- largo[largo$n == n_val, ]
  r <- ajustar_paridad(datos_n)
  if (!is.null(r)) {
    filas[[idx]] <- data.frame(analisis = "paridad_k", nivel = "todos", n = n_val,
                                coef = r$coef, se = r$se, t = r$t, df = r$df, p = r$p)
    idx <- idx + 1
  }
}
resultados <- do.call(rbind, filas)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(resultados, "data/results/analisis_patrones.csv")
cat("Guardado data/results/analisis_patrones.csv\n")
