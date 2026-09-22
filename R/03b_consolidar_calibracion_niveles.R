# 03b_consolidar_calibracion_niveles.R
#
# Concatena los 5 CSV que produce el job de calibracion (uno por nivel, cada
# uno con k=3..9) en uno solo, con chequeo de sanidad de que las 35 celdas
# (5 niveles x 7 k) esten completas.
#
# Uso: Rscript R/03b_consolidar_calibracion_niveles.R

niveles <- c("bajo", "bajo_moderado", "moderado", "alto", "muy_alto")
archivos <- sprintf("data/results/calibracion_nivel_%s.csv", niveles)

faltantes <- archivos[!file.exists(archivos)]
if (length(faltantes) > 0) {
  stop(sprintf("Faltan archivos de calibracion: %s", paste(faltantes, collapse = ", ")))
}

cat("Consolidando 5 archivos:\n")
for (a in archivos) cat(" -", a, "\n")

tabla <- do.call(rbind, lapply(archivos, readr::read_csv, show_col_types = FALSE))

if (nrow(tabla) != 35) {
  stop(sprintf("Se esperaban 35 celdas (5 niveles x 7 k), se encontraron %d.", nrow(tabla)))
}

# Chequeo de calidad de la calibracion: dist2 alto indica que el optimizador
# no encontro una combinacion (lambda, umbrales) que reproduzca bien el
# objetivo -- avisar, no fallar (algunas celdas del Nivel 5 -- muy alto,
# curtosis positiva -- pueden ser mas dificiles, ver notes/DESIGN.md).
umbral_alerta <- 0.01
alerta <- tabla[tabla$dist2 > umbral_alerta, c("nivel", "k", "dist2", "skew_logrado", "kurt_exc_logrado")]
if (nrow(alerta) > 0) {
  cat("\nADVERTENCIA -- celdas con dist2 > ", umbral_alerta, " (calibracion imperfecta, revisar):\n", sep = "")
  print(alerta)
} else {
  cat("\nOK -- las 35 celdas calibraron con dist2 <= ", umbral_alerta, ".\n", sep = "")
}

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(tabla, "data/results/calibracion_niveles.csv")
cat("\nGuardado data/results/calibracion_niveles.csv (35 filas)\n")
cat("Listo.\n")
