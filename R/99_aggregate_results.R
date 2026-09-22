# 99_aggregate_results.R
#
# Consolida los 4 CSV del bloque real (uno por dataset: RSE k=4, MACH-IV
# k=5, HEXACO k=7, RWAS k=9) en un solo dataset en formato largo, listo para
# comparar directamente contra el Bloque 5 simulado de SSTN-Normality-Study
# (misma grilla de n, mismas 11 pruebas).
#
# No hace source("R/00_setup.R") -- solo necesita readr, igual que el
# aggregate-results del proyecto hermano.
#
# Uso: Rscript R/99_aggregate_results.R

archivos <- sort(Sys.glob("data/results/bloque_real_*.csv"))
if (length(archivos) != 4) {
  stop(sprintf("Se esperaban 4 archivos del bloque real, se encontraron %d.", length(archivos)))
}

consolidado <- do.call(rbind, lapply(archivos, readr::read_csv, show_col_types = FALSE))

conteos_reales <- table(consolidado$k)
cat("Filas por k:\n")
print(conteos_reales)

# 4 datasets x 8 tamaños de muestra = 32 filas esperadas
if (nrow(consolidado) != 32) {
  stop(sprintf("Se esperaban 32 filas (4 datasets x 8 n), se encontraron %d.", nrow(consolidado)))
}

cols_pruebas <- c(
  "shapiro_wilk", "anderson_darling", "lilliefors", "jarque_bera",
  "dagostino_pearson", "cramer_von_mises", "shapiro_francia",
  "pearson_chi2", "curtosis", "epps_pulley", "sstn"
)
tasas <- as.matrix(consolidado[, cols_pruebas])
if (any(tasas < 0 | tasas > 1, na.rm = TRUE)) {
  stop("Hay tasas de rechazo fuera de [0,1] en el dataset consolidado.")
}

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(consolidado, "data/results/consolidado.csv")

cat(sprintf("\nConsolidado: %d filas (4 datasets x 8 n)\n", nrow(consolidado)))
cat("Guardado data/results/consolidado.csv\n")
cat("Listo.\n")
