# 99b_aggregate_results_pais.R
#
# Consolida los 10 CSV del chequeo de robustez EE.UU. vs. resto del mundo
# (ver R/01b_extract_real_subscales_pais.R: RSE, MACH-IV, HEXACO, SPS-10 y
# RWAS, cada uno partido en dos submuestras) en un solo dataset en formato
# largo, agregando columnas "instrumento" y "pais" (us/nous) extraidas del
# nombre de archivo para facilitar la comparacion dataset por dataset.
#
# No hace source("R/00_setup.R") -- solo necesita readr y dplyr, igual que
# R/99_aggregate_results.R.
#
# Uso: Rscript R/99b_aggregate_results_pais.R

archivos <- sort(Sys.glob("data/results/bloque_real_*_n10-25-50-100-250.csv"))
if (length(archivos) != 10) {
  stop(sprintf("Se esperaban 10 archivos del chequeo por pais, se encontraron %d.", length(archivos)))
}

consolidado <- do.call(rbind, lapply(archivos, readr::read_csv, show_col_types = FALSE))

# dataset viene como "rse_k4_us" / "rse_k4_nous" -- separar en instrumento y
# grupo de pais.
consolidado$pais <- ifelse(grepl("_nous$", sub("\\.csv$", "", consolidado$dataset)), "resto_mundo", "eeuu")
consolidado$instrumento <- sub("_(us|nous)$", "", sub("\\.csv$", "", consolidado$dataset))

# 5 instrumentos x 2 grupos x 5 tamaños de muestra = 50 filas esperadas
if (nrow(consolidado) != 50) {
  stop(sprintf("Se esperaban 50 filas (5 instrumentos x 2 grupos x 5 n), se encontraron %d.", nrow(consolidado)))
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

cat("N por instrumento y grupo (deberian diferir bastante entre eeuu/resto_mundo salvo ambos ser positivos):\n")
print(unique(consolidado[, c("instrumento", "pais", "N")]))

# Brecha absoluta maxima entre eeuu y resto_mundo, por instrumento y n, sobre
# las 11 pruebas -- primer vistazo rapido a si el pais importa.
library(dplyr)
brecha <- consolidado %>%
  select(instrumento, pais, n, all_of(cols_pruebas)) %>%
  tidyr::pivot_longer(all_of(cols_pruebas), names_to = "prueba", values_to = "tasa") %>%
  tidyr::pivot_wider(names_from = pais, values_from = tasa) %>%
  mutate(brecha_abs = abs(eeuu - resto_mundo)) %>%
  group_by(instrumento, n) %>%
  summarise(brecha_max = max(brecha_abs, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(brecha_max))

cat("\nBrecha maxima (EE.UU. vs. resto) por instrumento y n, sobre las 11 pruebas:\n")
print(brecha)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(consolidado, "data/results/consolidado_pais.csv")
readr::write_csv(brecha, "data/results/brecha_pais.csv")

cat(sprintf("\nConsolidado: %d filas (5 instrumentos x 2 grupos x 5 n)\n", nrow(consolidado)))
cat("Guardado data/results/consolidado_pais.csv y data/results/brecha_pais.csv\n")
cat("Listo.\n")
