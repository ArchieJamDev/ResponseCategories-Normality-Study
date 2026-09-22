# 01_extract_real_subscales.R
#
# Extrae los puntajes compuestos de 4 datasets reales (data/raw/*.zip, todos
# del catalogo de datos crudos de openpsychometrics.org) y los deja en
# data/processed/ como un CSV por dataset (una columna, un renglon por
# respondente con caso completo). Cada dataset tiene una cantidad NATIVA
# distinta de categorias de respuesta k -- el objetivo de este proyecto es
# comparar el efecto de esa k sobre la potencia de las 11 pruebas de
# normalidad, con muestras reales (no simuladas), via submuestreo aleatorio
# (ver 02_bloque_real_categorias.R).
#
# Los 4 datasets y su k nativo:
#   RSE     (data/raw/RSE.zip)          k=4, 10 items, unidimensional
#   MACH-IV (data/raw/MACH_data.zip)    k=5, 20 items, unidimensional
#   HEXACO  (data/raw/HEXACO.zip)       k=7, facet X:Expr (Expresividad), 10 items
#   RWAS    (data/raw/RWAS.zip)         k=9, 22 items, unidimensional
#
# OJO -- formato de archivo NO es uniforme entre los 4 zips: RSE, MACH-IV y
# HEXACO traen data.csv delimitado por TAB (igual que en el proyecto hermano
# SSTN-Normality-Study, confirmado inspeccionando los datos crudos); RWAS
# viene delimitado por COMA (unico caso distinto encontrado hasta ahora en
# el catalogo de openpsychometrics.org) -- confirmado con
# `head -1 data.csv | awk -F',' '{print NF}'` antes de escribir este script.
#
# Claves de puntuacion:
#
#   RSE (columnas Q1-Q10, Likert 1-4, 0 = no contesto, WITH items invertidos):
#     Items invertidos = {3,5,8,9,10}
#     (clave estandar Rosenberg 1965; misma fuente/verificacion que
#     SSTN-Normality-Study/R/03_extract_real_subscales.R -- ver
#     socy.umd.edu/about-us/using-rosenberg-self-esteem-scale)
#
#   MACH-IV (columnas Q1A..Q20A, Likert 1-5, WITH items invertidos):
#     Items invertidos = {3,4,6,7,9,10,11,14,16,17}
#     (misma clave/fuente que SSTN-Normality-Study, confirmada via
#     checkpsych.com/tests/mach-iv/)
#
#   HEXACO, facet X:Expr -- Expressiveness (columnas XExpr1..XExpr10,
#     Likert 1-7, WITH items invertidos):
#     Items invertidos = {6,7,8,9,10}
#     (clave IPIP oficial, confirmada item por item -- texto exacto y orden
#     verificados contra ipip.ori.org/newHEXACO_PI_key.htm el 22 sep 2026:
#     items 1-5 puntuacion directa "Talk a lot"/"Am never at a loss for
#     words"/"Am the life of the party"/"Tell people about it when I'm
#     irritated"/"Have an intense, boisterous laugh"; items 6-10 invertidos
#     "Don't talk a lot"/"Don't like to draw attention to myself"/"Say
#     little"/"Bottle up my feelings"/"Speak softly" -- match exacto,
#     palabra por palabra, contra XExpr1..XExpr10 del codebook.txt real)
#
#   RWAS -- Right-Wing Authoritarianism Scale (columnas Q1-Q22, Likert 1-9,
#     0 = no contesto, WITH items invertidos):
#     Items invertidos = {4,6,8,9,11,13,15,18,20,21}
#     (clave del RWA scale de 22 items de Altemeyer, confirmada por
#     concordancia exacta entre el contenido semantico de cada item del
#     dataset real -- verificado leyendo las 22 afirmaciones tal como las
#     presenta el test interactivo de openpsychometrics.org -- y la lista de
#     items invertidos reportada independientemente en
#     db.arabpsychology.com/scales/right-wing-authoritarianism-scale/,
#     misma lista {4,6,8,9,11,13,15,18,20,21} en ambas fuentes)
#
# NO se modela la presencia de datos faltantes a nivel de item: un caso solo
# entra al puntaje total si todos los items de ese dataset tienen respuesta
# valida en rango -- mismo criterio que SSTN-Normality-Study.

source("R/00_setup.R")

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

#' Lee el data.csv (TAB o coma) que esta dentro de un .zip crudo.
#'
#' OJO: readr::read_delim() ya cierra la conexion que se le pasa despues de
#' leerla -- NO hay que cerrarla de nuevo (ver incidente documentado en
#' SSTN-Normality-Study/R/03_extract_real_subscales.R, notes/DESIGN.md
#' seccion 11).
read_zip_csv <- function(zip_path, delim, csv_name = "data.csv") {
  entries <- utils::unzip(zip_path, list = TRUE)$Name
  target <- entries[basename(entries) == csv_name]
  stopifnot(length(target) == 1)
  con <- unz(zip_path, target)
  readr::read_delim(
    con,
    delim = delim,
    col_types = readr::cols(.default = readr::col_character()),
    na = c("", "NA", "NULL"),
    progress = FALSE
  )
}

#' Puntaje compuesto: suma de items, con reversion opcional, exigiendo caso
#' completo en los items de ese dataset (sin promediar con datos parciales,
#' para no sesgar la forma de la distribucion).
score_composite <- function(df, items, reverse_items = character(0),
                             min_val, max_val) {
  mat <- sapply(items, function(it) {
    v <- suppressWarnings(as.numeric(df[[it]]))
    v[v < min_val | v > max_val] <- NA_real_
    if (it %in% reverse_items) v <- (min_val + max_val) - v
    v
  })
  complete <- stats::complete.cases(mat)
  rowSums(mat[complete, , drop = FALSE])
}

# --- RSE (k=4) -----------------------------------------------------------

cat("=== RSE (k=4) ===\n")
rse_raw <- read_zip_csv("data/raw/RSE.zip", delim = "\t")
rse_items <- paste0("Q", 1:10)
rse_reverse <- paste0("Q", c(3,5,8,9,10))
rse_total <- score_composite(rse_raw, rse_items, rse_reverse, min_val = 1, max_val = 4)
cat(sprintf("  n=%d\n", length(rse_total)))
readr::write_csv(data.frame(k = 4L, puntaje = rse_total), "data/processed/rse_k4.csv")

# --- MACH-IV (k=5) ---------------------------------------------------------

cat("=== MACH-IV (k=5) ===\n")
mach_raw <- read_zip_csv("data/raw/MACH_data.zip", delim = "\t")
mach_items <- paste0("Q", 1:20, "A")
mach_reverse <- paste0("Q", c(3,4,6,7,9,10,11,14,16,17), "A")
mach_total <- score_composite(mach_raw, mach_items, mach_reverse, min_val = 1, max_val = 5)
cat(sprintf("  n=%d\n", length(mach_total)))
readr::write_csv(data.frame(k = 5L, puntaje = mach_total), "data/processed/mach_k5.csv")

# --- HEXACO, facet X:Expr (k=7) --------------------------------------------

cat("=== HEXACO X:Expr (k=7) ===\n")
hexaco_raw <- read_zip_csv("data/raw/HEXACO.zip", delim = "\t")
hexaco_items <- paste0("XExpr", 1:10)
hexaco_reverse <- paste0("XExpr", 6:10)
hexaco_total <- score_composite(hexaco_raw, hexaco_items, hexaco_reverse, min_val = 1, max_val = 7)
cat(sprintf("  n=%d\n", length(hexaco_total)))
readr::write_csv(data.frame(k = 7L, puntaje = hexaco_total), "data/processed/hexaco_k7.csv")

# --- RWAS (k=9) --------------------------------------------------------

cat("=== RWAS (k=9) ===\n")
rwas_raw <- read_zip_csv("data/raw/RWAS.zip", delim = ",")
rwas_items <- paste0("Q", 1:22)
rwas_reverse <- paste0("Q", c(4,6,8,9,11,13,15,18,20,21))
rwas_total <- score_composite(rwas_raw, rwas_items, rwas_reverse, min_val = 1, max_val = 9)
cat(sprintf("  n=%d\n", length(rwas_total)))
readr::write_csv(data.frame(k = 9L, puntaje = rwas_total), "data/processed/rwas_k9.csv")

cat("\nListo.\n")
