# 99b_aggregate_results_pais.R
#
# Consolida el chequeo de robustez EE.UU. vs. resto del mundo (ver
# R/01b_extract_real_subscales_pais.R: RSE, MACH-IV, HEXACO, SPS-10 y RWAS,
# cada uno partido en dos submuestras) y lo compara con el resultado ya
# obtenido usando el N completo de cada dataset (bloque_real_<instrumento>.csv,
# ya commiteado en el repo -- ver R/02_bloque_real_categorias.R). El resultado
# final tiene, por instrumento y tamaño de muestra, TRES grupos comparables:
#   "eeuu"        -- solo respondentes de EE.UU.
#   "resto_mundo" -- solo respondentes fuera de EE.UU. (RWAS: solo con pais
#                    conocido, ver caveat en 01b)
#   "todos"       -- el N completo del dataset (el resultado ya reportado en
#                    el cuerpo del manuscrito), filtrado a la misma grilla
#                    reducida (n<=250) para que los 3 grupos sean comparables
#                    en los mismos tamaños de muestra.
# AHS no participa (excluido desde 01b por ser 100% EE.UU., sin grupo
# "resto_mundo" posible).
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

instrumentos_pais <- unique(consolidado_pais$instrumento)
archivos_todos <- file.path("data/results", sprintf("bloque_real_%s.csv", instrumentos_pais))
faltantes <- archivos_todos[!file.exists(archivos_todos)]
if (length(faltantes) > 0) {
  stop(sprintf("Faltan archivos 'todos' ya commiteados: %s", paste(faltantes, collapse = ", ")))
}
consolidado_todos <- do.call(rbind, lapply(archivos_todos, readr::read_csv, show_col_types = FALSE))
consolidado_todos <- consolidado_todos[consolidado_todos$n %in% n_grid_pais, ]
consolidado_todos$pais <- "todos"
consolidado_todos$instrumento <- consolidado_todos$dataset
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

# Brecha por pares de grupos (eeuu vs resto_mundo, eeuu vs todos, resto_mundo
# vs todos) y la brecha maxima entre los 3, por instrumento/n/prueba -- primer
# vistazo rapido a si el pais importa frente al resultado ya reportado.
library(dplyr)
anchos <- consolidado %>%
  select(instrumento, pais, n, all_of(cols_pruebas)) %>%
  tidyr::pivot_longer(all_of(cols_pruebas), names_to = "prueba", values_to = "tasa") %>%
  tidyr::pivot_wider(names_from = pais, values_from = tasa) %>%
  mutate(
    brecha_eeuu_resto = abs(eeuu - resto_mundo),
    brecha_eeuu_todos = abs(eeuu - todos),
    brecha_resto_todos = abs(resto_mundo - todos),
    brecha_max = pmax(brecha_eeuu_resto, brecha_eeuu_todos, brecha_resto_todos)
  )

brecha <- anchos %>%
  group_by(instrumento, n) %>%
  summarise(
    brecha_eeuu_resto_max = max(brecha_eeuu_resto, na.rm = TRUE),
    brecha_eeuu_todos_max = max(brecha_eeuu_todos, na.rm = TRUE),
    brecha_resto_todos_max = max(brecha_resto_todos, na.rm = TRUE),
    brecha_max = max(brecha_max, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(brecha_max))

cat("\nBrecha maxima por par de grupos (EE.UU./resto/todos), por instrumento y n, sobre las 11 pruebas:\n")
print(brecha)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(consolidado, "data/results/consolidado_pais.csv")
readr::write_csv(anchos, "data/results/brecha_pais_detalle.csv")
readr::write_csv(brecha, "data/results/brecha_pais.csv")

cat(sprintf("\nConsolidado: %d filas (5 instrumentos x 3 grupos x 5 n)\n", nrow(consolidado)))
cat("Guardado data/results/consolidado_pais.csv, brecha_pais_detalle.csv y brecha_pais.csv\n")
cat("Listo.\n")
