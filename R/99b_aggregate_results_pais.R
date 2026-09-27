# 99b_aggregate_results_pais.R
#
# Consolida el chequeo de robustez EE.UU. vs. resto del mundo (ver
# R/01b_extract_real_subscales_pais.R: RSE, MACH-IV, HEXACO, SPS-10 y RWAS,
# cada uno partido en dos submuestras) y lo compara con dos referencias que
# ya existian en el proyecto:
#   "todos"    -- el N completo del dataset real (bloque_real_<instrumento>.csv,
#                 el resultado ya reportado en el cuerpo del manuscrito).
#   "simulado" -- la celda simulada equivalente (mismo k, nivel de severidad
#                 mas cercano por distancia euclidiana asignado en la
#                 validacion §3.3, Tabla 6b de notes/resultados_borrador.md:
#                   RSE (k=4)     -> bajo_moderado
#                   MACH-IV (k=5) -> bajo_moderado
#                   SPS-10 (k=6)  -> alto
#                   HEXACO (k=7)  -> bajo_moderado
#                   RWAS (k=9)    -> alto
#                 No se recalibra nada aca -- se reusa la asignacion ya
#                 validada, para no introducir un segundo criterio de
#                 severidad paralelo al ya usado en el manuscrito.
# AHS no participa en ninguno de los 4 grupos (excluido desde 01b por ser
# 100% EE.UU., sin grupo "resto_mundo" posible).
#
# La comparacion principal (data/results/comparacion_n250.csv) es a n=250 --
# el tamaño de muestra que motivo todo este chequeo (ver notes/DESIGN.md):
# EE.UU. y resto del mundo se calcularon deliberadamente solo hasta n=250
# (RWAS-EEUU tiene apenas N=676 conocido), asi que ese es el unico punto
# donde los 4 grupos son comparables sin extrapolar. Como bono, EE.UU./resto/
# todos tambien quedan disponibles en la grilla completa {10,25,50,100,250}
# en data/results/consolidado_pais.csv, por si la brecha aparece antes de
# n=250 (dato ya calculado en el mismo submuestreo, sin costo adicional).
#
# No hace source("R/00_setup.R") -- solo necesita readr, dplyr y tidyr,
# igual que R/99_aggregate_results.R.
#
# Uso: Rscript R/99b_aggregate_results_pais.R

cols_pruebas <- c(
  "shapiro_wilk", "anderson_darling", "lilliefors", "jarque_bera",
  "dagostino_pearson", "cramer_von_mises", "shapiro_francia",
  "pearson_chi2", "curtosis", "epps_pulley", "sstn"
)
cols_comunes <- c("instrumento", "pais", "k", "N", "n", "R", cols_pruebas)

n_grid_pais <- c(10, 25, 50, 100, 250)

# Mapa instrumento -> (k, nivel simulado asignado), tal como en Tabla 6b.
mapa_nivel <- data.frame(
  instrumento = c("rse_k4", "mach_k5", "sps_k6", "hexaco_k7", "rwas_k9"),
  k = c(4L, 5L, 6L, 7L, 9L),
  nivel = c("bajo_moderado", "bajo_moderado", "alto", "bajo_moderado", "alto"),
  stringsAsFactors = FALSE
)

# --- Grupos EE.UU. / resto del mundo (grilla reducida, ya en esa grilla) ---

archivos_pais <- sort(Sys.glob("data/results/bloque_real_*_n10-25-50-100-250.csv"))
if (length(archivos_pais) != 10) {
  stop(sprintf("Se esperaban 10 archivos EE.UU./resto, se encontraron %d.", length(archivos_pais)))
}
consolidado_pais <- do.call(rbind, lapply(archivos_pais, readr::read_csv, show_col_types = FALSE))
consolidado_pais$pais <- ifelse(
  grepl("_nous$", sub("\\.csv$", "", consolidado_pais$dataset)),
  "resto_mundo", "eeuu"
)
consolidado_pais$instrumento <- sub("_(us|nous)$", "", sub("\\.csv$", "", consolidado_pais$dataset))
consolidado_pais <- consolidado_pais[, cols_comunes]

if (nrow(consolidado_pais) != 50) {
  stop(sprintf("Se esperaban 50 filas EE.UU./resto (5 instrumentos x 2 grupos x 5 n), se encontraron %d.", nrow(consolidado_pais)))
}

# --- Grupo "todos" (N completo, ya commiteado) filtrado a la misma grilla ---

archivos_todos <- file.path("data/results", sprintf("bloque_real_%s.csv", mapa_nivel$instrumento))
faltantes <- archivos_todos[!file.exists(archivos_todos)]
if (length(faltantes) > 0) {
  stop(sprintf("Faltan archivos 'todos' ya commiteados: %s", paste(faltantes, collapse = ", ")))
}
consolidado_todos <- do.call(rbind, lapply(archivos_todos, readr::read_csv, show_col_types = FALSE))
consolidado_todos <- consolidado_todos[consolidado_todos$n %in% n_grid_pais, ]
consolidado_todos$pais <- "todos"
# dataset trae el nombre con extension (ej. "rse_k4.csv", tal como se paso a
# 02_bloque_real_categorias.R como argumento) -- quitarla para que calce con
# el nombre de instrumento usado en los otros 3 grupos (sin extension).
consolidado_todos$instrumento <- sub("\\.csv$", "", consolidado_todos$dataset)
consolidado_todos <- consolidado_todos[, cols_comunes]

if (nrow(consolidado_todos) != 25) {
  stop(sprintf("Se esperaban 25 filas 'todos' (5 instrumentos x 5 n), se encontraron %d.", nrow(consolidado_todos)))
}

consolidado <- rbind(consolidado_pais, consolidado_todos)

tasas <- as.matrix(consolidado[, cols_pruebas])
if (any(tasas < 0 | tasas > 1, na.rm = TRUE)) {
  stop("Hay tasas de rechazo fuera de [0,1] en el dataset consolidado.")
}

cat("N por instrumento y grupo (eeuu/resto_mundo deberian sumar menos que 'todos' si hay pais desconocido, ej. RWAS):\n")
print(unique(consolidado[, c("instrumento", "pais", "N")]))

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(consolidado, "data/results/consolidado_pais.csv")
cat(sprintf("\nGuardado data/results/consolidado_pais.csv (%d filas, 5 instrumentos x 3 grupos x 5 n)\n", nrow(consolidado)))

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
consolidado_simulado$pais <- "simulado"
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
  select(instrumento, pais, all_of(cols_pruebas)) %>%
  tidyr::pivot_longer(all_of(cols_pruebas), names_to = "prueba", values_to = "tasa") %>%
  tidyr::pivot_wider(names_from = pais, values_from = tasa) %>%
  mutate(
    brecha_eeuu_resto = abs(eeuu - resto_mundo),
    brecha_eeuu_todos = abs(eeuu - todos),
    brecha_resto_todos = abs(resto_mundo - todos),
    brecha_todos_simulado = abs(todos - simulado),
    brecha_max = pmax(brecha_eeuu_resto, brecha_eeuu_todos, brecha_resto_todos, brecha_todos_simulado)
  )

brecha_n250 <- anchos_n250 %>%
  group_by(instrumento) %>%
  summarise(
    brecha_eeuu_resto_max = max(brecha_eeuu_resto, na.rm = TRUE),
    brecha_eeuu_todos_max = max(brecha_eeuu_todos, na.rm = TRUE),
    brecha_resto_todos_max = max(brecha_resto_todos, na.rm = TRUE),
    brecha_todos_simulado_max = max(brecha_todos_simulado, na.rm = TRUE),
    brecha_max = max(brecha_max, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(brecha_max))

cat("\nComparacion a n=250, 4 grupos (EE.UU./resto/todos/simulado):\n")
print(comparacion_n250[, c("instrumento", "pais", "k", "N", cols_pruebas)])
cat("\nBrecha maxima por par de grupos, por instrumento, sobre las 11 pruebas (n=250):\n")
print(brecha_n250)

readr::write_csv(comparacion_n250, "data/results/comparacion_n250.csv")
readr::write_csv(anchos_n250, "data/results/brecha_n250_detalle.csv")
readr::write_csv(brecha_n250, "data/results/brecha_n250.csv")

cat("\nGuardado data/results/comparacion_n250.csv, brecha_n250_detalle.csv y brecha_n250.csv\n")

# --- Prueba estadistica: cuales brechas son notables, no solo grandes -----
#
# Con R=10000 replicas por grupo, un test de diferencia de proporciones por
# si solo declara "significativas" hasta brechas triviales (el error
# estandar de cada tasa es ~0.5pp cerca de p=.5) -- no es informativo dada
# la potencia estadistica tan alta de comparar 10000 vs 10000 replicas. Se
# exige un segundo criterio, tamaño de efecto (h de Cohen, 1988 -- la
# metrica estandar para diferencia de proporciones, estable cerca de 0/1 a
# diferencia de la diferencia cruda), y solo se llama "notable" a una
# brecha que cumple AMBOS: significativa tras correccion de Bonferroni
# (220 comparaciones = 5 instrumentos x 11 pruebas x 4 pares) Y tamaño de
# efecto al menos pequeño (|h|>=0.2).

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
  eeuu_resto = c("eeuu", "resto_mundo"),
  eeuu_todos = c("eeuu", "todos"),
  resto_todos = c("resto_mundo", "todos"),
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

readr::write_csv(pruebas_estadisticas, "data/results/pruebas_estadisticas_n250.csv")

cat(sprintf(
  "\n%d de %d comparaciones (instrumento x prueba x par) son 'notables' (p_bonferroni<.05 Y |h de Cohen|>=.2):\n",
  sum(pruebas_estadisticas$notable), nrow(pruebas_estadisticas)
))
print(pruebas_estadisticas[pruebas_estadisticas$notable,
  c("instrumento", "prueba", "par", "tasa_a", "tasa_b", "brecha", "cohens_h", "p_bonferroni")])

cat("\nNotables por par de grupos:\n")
print(table(pruebas_estadisticas$par, pruebas_estadisticas$notable))

cat("\nGuardado data/results/pruebas_estadisticas_n250.csv\n")
cat("Listo.\n")
