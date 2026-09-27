# 99c_aggregate_results_sexo.R
#
# Analogo a R/99b_aggregate_results_pais.R pero para el chequeo de robustez
# hombres vs. mujeres (ver R/01c_extract_real_subscales_sexo.R: RSE,
# MACH-IV, SPS-10, RWAS y AHS, cada uno partido en dos submuestras; HEXACO
# excluido por no tener columna de sexo). Mismos 4 grupos comparables a
# n=250:
#   "hombres" / "mujeres" -- las dos submuestras por sexo.
#   "todos"    -- el N completo del dataset real, ya commiteado (el
#                 resultado reportado en el cuerpo del manuscrito).
#   "simulado" -- la celda simulada equivalente (mismo k, nivel de
#                 severidad asignado en la validacion §3.3, Tabla 6b):
#                   RSE (k=4)     -> bajo_moderado
#                   MACH-IV (k=5) -> bajo_moderado
#                   SPS-10 (k=6)  -> alto
#                   AHS (k=8)     -> moderado
#                   RWAS (k=9)    -> alto
#
# Uso: Rscript R/99c_aggregate_results_sexo.R

cols_pruebas <- c(
  "shapiro_wilk", "anderson_darling", "lilliefors", "jarque_bera",
  "dagostino_pearson", "cramer_von_mises", "shapiro_francia",
  "pearson_chi2", "curtosis", "epps_pulley", "sstn"
)
cols_comunes <- c("instrumento", "sexo", "k", "N", "n", "R", cols_pruebas)

n_grid_sexo <- c(10, 25, 50, 100, 250)

# Mapa instrumento -> (k, nivel simulado asignado, archivo "todos") -- AHS
# usa un nombre de archivo distinto porque corrio con grilla reducida
# (N=1.036 < 1.500, ver R/02_bloque_real_categorias.R).
mapa_nivel <- data.frame(
  instrumento = c("rse_k4", "mach_k5", "sps_k6", "rwas_k9", "ahs_k8"),
  k = c(4L, 5L, 6L, 9L, 8L),
  nivel = c("bajo_moderado", "bajo_moderado", "alto", "alto", "moderado"),
  archivo_todos = c(
    "bloque_real_rse_k4.csv", "bloque_real_mach_k5.csv", "bloque_real_sps_k6.csv",
    "bloque_real_rwas_k9.csv", "bloque_real_ahs_k8_n10-25-50-100-250-500-1000.csv"
  ),
  stringsAsFactors = FALSE
)

# --- Grupos hombres / mujeres (grilla reducida, ya en esa grilla) ---------

archivos_sexo <- sort(Sys.glob("data/results/bloque_real_*_n10-25-50-100-250.csv"))
archivos_sexo <- archivos_sexo[grepl("_(hombres|mujeres)_n10-25-50-100-250\\.csv$", archivos_sexo)]
if (length(archivos_sexo) != 10) {
  stop(sprintf("Se esperaban 10 archivos hombres/mujeres, se encontraron %d.", length(archivos_sexo)))
}
consolidado_sexo <- do.call(rbind, lapply(archivos_sexo, readr::read_csv, show_col_types = FALSE))
consolidado_sexo$sexo <- ifelse(
  grepl("_mujeres$", sub("\\.csv$", "", consolidado_sexo$dataset)),
  "mujeres", "hombres"
)
consolidado_sexo$instrumento <- sub("_(hombres|mujeres)$", "", sub("\\.csv$", "", consolidado_sexo$dataset))
consolidado_sexo <- consolidado_sexo[, cols_comunes]

if (nrow(consolidado_sexo) != 50) {
  stop(sprintf("Se esperaban 50 filas hombres/mujeres (5 instrumentos x 2 grupos x 5 n), se encontraron %d.", nrow(consolidado_sexo)))
}

# --- Grupo "todos" (N completo, ya commiteado) filtrado a la misma grilla --

archivos_todos <- file.path("data/results", mapa_nivel$archivo_todos)
faltantes <- archivos_todos[!file.exists(archivos_todos)]
if (length(faltantes) > 0) {
  stop(sprintf("Faltan archivos 'todos' ya commiteados: %s", paste(faltantes, collapse = ", ")))
}
consolidado_todos <- do.call(rbind, Map(function(archivo, instrumento) {
  df <- readr::read_csv(archivo, show_col_types = FALSE)
  df$instrumento <- instrumento
  df
}, archivos_todos, mapa_nivel$instrumento))
consolidado_todos <- consolidado_todos[consolidado_todos$n %in% n_grid_sexo, ]
consolidado_todos$sexo <- "todos"
consolidado_todos <- consolidado_todos[, cols_comunes]

if (nrow(consolidado_todos) != 25) {
  stop(sprintf("Se esperaban 25 filas 'todos' (5 instrumentos x 5 n), se encontraron %d.", nrow(consolidado_todos)))
}

consolidado <- rbind(consolidado_sexo, consolidado_todos)

tasas <- as.matrix(consolidado[, cols_pruebas])
if (any(tasas < 0 | tasas > 1, na.rm = TRUE)) {
  stop("Hay tasas de rechazo fuera de [0,1] en el dataset consolidado.")
}

cat("N por instrumento y grupo:\n")
print(unique(consolidado[, c("instrumento", "sexo", "N")]))

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(consolidado, "data/results/consolidado_sexo.csv")
cat(sprintf("\nGuardado data/results/consolidado_sexo.csv (%d filas, 5 instrumentos x 3 grupos x 5 n)\n", nrow(consolidado)))

# --- Grupo "simulado" (nivel asignado por instrumento, solo n=250) --------

archivos_simulado <- with(mapa_nivel, file.path("data/results", sprintf("nivel_%s_k%d.csv", nivel, k)))
faltantes_sim <- archivos_simulado[!file.exists(archivos_simulado)]
if (length(faltantes_sim) > 0) {
  stop(sprintf("Faltan archivos de nivel simulado ya commiteados: %s", paste(faltantes_sim, collapse = ", ")))
}
consolidado_simulado <- do.call(rbind, Map(function(archivo, instrumento) {
  df <- readr::read_csv(archivo, show_col_types = FALSE)
  df <- df[df$n == 250, ]
  df$instrumento <- instrumento
  df
}, archivos_simulado, mapa_nivel$instrumento))
consolidado_simulado$sexo <- "simulado"
consolidado_simulado$k <- mapa_nivel$k[match(consolidado_simulado$instrumento, mapa_nivel$instrumento)]
consolidado_simulado$N <- NA_integer_
consolidado_simulado <- consolidado_simulado[, cols_comunes]

if (nrow(consolidado_simulado) != 5) {
  stop(sprintf("Se esperaban 5 filas 'simulado' (5 instrumentos x n=250), se encontraron %d.", nrow(consolidado_simulado)))
}

# --- Comparacion principal: 4 grupos a n=250 -------------------------------

comparacion_n250 <- rbind(
  consolidado[consolidado$n == 250, ],
  consolidado_simulado
)

library(dplyr)
anchos_n250 <- comparacion_n250 %>%
  select(instrumento, sexo, all_of(cols_pruebas)) %>%
  tidyr::pivot_longer(all_of(cols_pruebas), names_to = "prueba", values_to = "tasa") %>%
  tidyr::pivot_wider(names_from = sexo, values_from = tasa) %>%
  mutate(
    brecha_hombres_mujeres = abs(hombres - mujeres),
    brecha_hombres_todos = abs(hombres - todos),
    brecha_mujeres_todos = abs(mujeres - todos),
    brecha_todos_simulado = abs(todos - simulado),
    brecha_max = pmax(brecha_hombres_mujeres, brecha_hombres_todos, brecha_mujeres_todos, brecha_todos_simulado)
  )

brecha_n250 <- anchos_n250 %>%
  group_by(instrumento) %>%
  summarise(
    brecha_hombres_mujeres_max = max(brecha_hombres_mujeres, na.rm = TRUE),
    brecha_hombres_todos_max = max(brecha_hombres_todos, na.rm = TRUE),
    brecha_mujeres_todos_max = max(brecha_mujeres_todos, na.rm = TRUE),
    brecha_todos_simulado_max = max(brecha_todos_simulado, na.rm = TRUE),
    brecha_max = max(brecha_max, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(brecha_max))

cat("\nComparacion a n=250, 4 grupos (hombres/mujeres/todos/simulado):\n")
print(comparacion_n250[, c("instrumento", "sexo", "k", "N", cols_pruebas)])
cat("\nBrecha maxima por par de grupos, por instrumento, sobre las 11 pruebas (n=250):\n")
print(brecha_n250)

readr::write_csv(comparacion_n250, "data/results/comparacion_sexo_n250.csv")
readr::write_csv(anchos_n250, "data/results/brecha_sexo_n250_detalle.csv")
readr::write_csv(brecha_n250, "data/results/brecha_sexo_n250.csv")

cat("\nGuardado data/results/comparacion_sexo_n250.csv, brecha_sexo_n250_detalle.csv y brecha_sexo_n250.csv\n")

# --- Prueba estadistica: dos proporciones + h de Cohen (por par) ----------

R_REPLICAS <- 10000L
n_comparaciones_totales <- nrow(anchos_n250) * 4L

test_dos_proporciones <- function(pA, pB, R = R_REPLICAS) {
  xA <- round(pA * R)
  xB <- round(pB * R)
  if (xA == xB && (xA == 0 || xA == R)) {
    return(c(p_valor = 1, cohens_h = 0))
  }
  pt <- suppressWarnings(stats::prop.test(c(xA, xB), c(R, R), correct = TRUE))
  h <- 2 * asin(sqrt(pA)) - 2 * asin(sqrt(pB))
  c(p_valor = unname(pt$p.value), cohens_h = unname(h))
}

pares <- list(
  hombres_mujeres = c("hombres", "mujeres"),
  hombres_todos = c("hombres", "todos"),
  mujeres_todos = c("mujeres", "todos"),
  todos_simulado = c("todos", "simulado")
)

pruebas_estadisticas <- do.call(rbind, lapply(names(pares), function(nombre_par) {
  cols <- pares[[nombre_par]]
  resultados <- mapply(test_dos_proporciones, anchos_n250[[cols[1]]], anchos_n250[[cols[2]]])
  data.frame(
    instrumento = anchos_n250$instrumento,
    prueba = anchos_n250$prueba,
    par = nombre_par,
    tasa_a = anchos_n250[[cols[1]]],
    tasa_b = anchos_n250[[cols[2]]],
    brecha = abs(anchos_n250[[cols[1]]] - anchos_n250[[cols[2]]]),
    p_valor = resultados["p_valor", ],
    cohens_h = resultados["cohens_h", ],
    stringsAsFactors = FALSE
  )
}))

pruebas_estadisticas$p_bonferroni <- pmin(pruebas_estadisticas$p_valor * n_comparaciones_totales, 1)
pruebas_estadisticas$notable <- pruebas_estadisticas$p_bonferroni < 0.05 & abs(pruebas_estadisticas$cohens_h) >= 0.2
pruebas_estadisticas <- pruebas_estadisticas[order(-abs(pruebas_estadisticas$cohens_h)), ]

readr::write_csv(pruebas_estadisticas, "data/results/pruebas_estadisticas_sexo_n250.csv")

cat(sprintf(
  "\n%d de %d comparaciones (instrumento x prueba x par) son 'notables' (p_bonferroni<.05 Y |h de Cohen|>=.2):\n",
  sum(pruebas_estadisticas$notable), nrow(pruebas_estadisticas)
))
print(pruebas_estadisticas[pruebas_estadisticas$notable,
  c("instrumento", "prueba", "par", "tasa_a", "tasa_b", "brecha", "cohens_h", "p_bonferroni")])

cat("\nNotables por par de grupos:\n")
print(table(pruebas_estadisticas$par, pruebas_estadisticas$notable))

cat("\nGuardado data/results/pruebas_estadisticas_sexo_n250.csv\n")

# --- Prueba omnibus (equivalente a un ANOVA de un factor, 4 grupos) -------

anova_grupos <- do.call(rbind, lapply(seq_len(nrow(anchos_n250)), function(i) {
  fila <- anchos_n250[i, ]
  x <- round(c(fila$hombres, fila$mujeres, fila$todos, fila$simulado) * R_REPLICAS)
  chi <- suppressWarnings(stats::prop.test(x, rep(R_REPLICAS, 4)))
  chi2 <- unname(chi$statistic)
  w <- sqrt(chi2 / (4 * R_REPLICAS))
  data.frame(
    instrumento = fila$instrumento, prueba = fila$prueba,
    hombres = fila$hombres, mujeres = fila$mujeres, todos = fila$todos, simulado = fila$simulado,
    chi2 = chi2, df = unname(chi$parameter), p_valor = chi$p.value, cohens_w = w,
    stringsAsFactors = FALSE
  )
}))

n_celdas <- nrow(anova_grupos)  # 55 = 5 instrumentos x 11 pruebas
anova_grupos$p_bonferroni <- pmin(anova_grupos$p_valor * n_celdas, 1)
anova_grupos$notable <- anova_grupos$p_bonferroni < 0.05 & anova_grupos$cohens_w >= 0.1
anova_grupos <- anova_grupos[order(-anova_grupos$cohens_w), ]

readr::write_csv(anova_grupos, "data/results/anova_grupos_sexo_n250.csv")

cat(sprintf(
  "\nPrueba omnibus (chi-cuadrado de homogeneidad, 4 grupos, equivalente a ANOVA de un factor): %d de %d celdas (instrumento x prueba) son notables (p_bonferroni<.05 Y w de Cohen>=.1):\n",
  sum(anova_grupos$notable), n_celdas
))
print(anova_grupos[anova_grupos$notable, c("instrumento", "prueba", "chi2", "cohens_w", "p_bonferroni")])

cat("\nGuardado data/results/anova_grupos_sexo_n250.csv\n")
cat("Listo.\n")
