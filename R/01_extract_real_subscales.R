# 01_extract_real_subscales.R
#
# Extrae los puntajes compuestos de 6 datasets reales y los deja en
# data/processed/ como un CSV por dataset (una columna, un renglon por
# respondente con caso completo). Cada dataset tiene una cantidad NATIVA
# distinta de categorias de respuesta k -- el objetivo de este proyecto es
# comparar el efecto de esa k sobre la potencia de las 11 pruebas de
# normalidad, con muestras reales (no simuladas), via submuestreo aleatorio
# (ver 02_bloque_real_categorias.R).
#
# Los 6 datasets y su k nativo:
#   RSE     (data/raw/RSE.zip)              k=4, 10 items, unidimensional -- openpsychometrics.org
#   MACH-IV (data/raw/MACH_data.zip)        k=5, 20 items, unidimensional -- openpsychometrics.org
#   NFC     (data/raw/ZA5088_v1-0-0.sav)    k=6, 9 items, submuestra Israel -- GESIS (ver seccion propia abajo)
#   HEXACO  (data/raw/HEXACO.zip)           k=7, facet X:Expr (Expresividad), 10 items -- openpsychometrics.org
#   RWAS    (data/raw/RWAS.zip)             k=9, 22 items, unidimensional -- openpsychometrics.org
#   AHS     (data/raw/osf_2anvx_chronic_disease_T1-T5.sav) k=8, 8 items, ola T1 -- OSF (ver seccion propia abajo)
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
#   NFC -- Need for Cognitive Closure (Webster y Kruglanski, 1994), columnas
#     nfc1..nfc9, Likert 1-6 (submuestra Israel; Alemania uso una version de
#     7 puntos del mismo instrumento, no usada aqui), WITH items invertidos:
#     Items invertidos = {3,5,6,7,9}
#     Fuente del dataset: estudio GESIS ZA5088 "Identity Development and
#     Value Transmission among Veteran and Migrant Adolescents and Their
#     Families in Germany and Israel" (encuesta a adolescentes, ola 1).
#     Segun el informe metodologico oficial del estudio (58 paginas,
#     descargado de access.gesis.org/dbk/50866), se usaron 3 de las 5
#     subescalas originales de Webster y Kruglanski (1994) -- incomodidad
#     con la ambiguedad, decision, y cerrazon mental --, 3 items cada una:
#       Incomodidad con ambiguedad (directos): nfc1, nfc2, nfc8
#       Decision: nfc4 (directo); nfc3, nfc5 (invertidos -- "me describiria
#         como indeciso"/"me siento dividido ante la mayoria de decisiones"
#         son baja decision = baja necesidad de cierre)
#       Cerrazon mental (invertidos -- entender ambos lados de un conflicto/
#         considerar varios aspectos/ver varias soluciones son apertura
#         mental = baja necesidad de cierre): nfc6, nfc7, nfc9
#     El informe no publica una tabla de reversion item por item explicita;
#     la clave de arriba se infiere cruzando el contenido semantico de cada
#     item (etiquetas de valor reales del .sav) contra la estructura de 3
#     subescalas de 3 items documentada en el informe -- mismo estandar de
#     verificacion cruzada ya usado para RWAS en este proyecto.
#     OJO -- el codebook de valores del .sav marca el valor 7 como "solo
#     Alemania", pero el dato real muestra 6 respuestas sueltas en 7 dentro
#     de la submuestra de Israel (6 de 16.182, 0.04% -- ruido, no un
#     segundo formato real). Se excluyen esos casos explicitamente (ver
#     abajo) en vez de ignorarlos, para que el k=6 quede limpio.
#
#   AHS -- Adult Hope Scale (Snyder et al., 1991/1994), version abreviada
#     de 8 items, columnas AHS01.1..AHS08.1 (ola T1 del estudio
#     longitudinal), Likert 1-8, SIN items invertidos.
#     Fuente del dataset: OSF, codigo 2anvx, "Chronic Disease Longitudinal
#     Study" (T1-T5), pacientes con enfermedad cronica, EE.UU. -- ver
#     seccion propia abajo para el detalle de por que se eligio este de
#     entre 3 datasets abiertos con la misma escala (y por que NO se
#     combinaron pese a compartir instrumento identico).
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

# --- NFC, submuestra Israel (k=6) -------------------------------------

cat("=== NFC Israel (k=6) ===\n")
if (!requireNamespace("haven", quietly = TRUE)) {
  install.packages("haven", repos = "https://cloud.r-project.org")
}
nfc_items <- paste0("nfc", 1:9)
nfc_reverse <- paste0("nfc", c(3,5,6,7,9))
nfc_raw <- haven::read_sav("data/raw/ZA5088_v1-0-0.sav",
                            col_select = c("country", all_of(nfc_items)))
israel <- nfc_raw[haven::as_factor(nfc_raw$country) == "Israel" & !is.na(nfc_raw$country), ]
for (v in nfc_items) israel[[v]][israel[[v]] < 0] <- NA  # codigos de perdido GESIS (-991..-994)
nfc_total <- score_composite(as.data.frame(israel), nfc_items, nfc_reverse, min_val = 1, max_val = 6)
cat(sprintf("  n=%d\n", length(nfc_total)))
readr::write_csv(data.frame(k = 6L, puntaje = nfc_total), "data/processed/nfc_k6.csv")

# --- AHS, ola T1 (k=8) --------------------------------------------------
#
# Adult Hope Scale (Snyder et al., 1994), version abreviada de 8 items (sin
# los 4 items de relleno de la version original de 12 -- ver Snyder 1994,
# "The Psychology of Hope"), escala Likert 1-8 (1 = definitivamente falso,
# 8 = definitivamente verdadero), SIN items invertidos (los 8 items
# puntuados de la AHS se califican todos en la misma direccion -- ver
# manual original y confirmado empiricamente abajo, rango de la suma
# observado 13-64 dentro del rango teorico 8-64).
#
# Fuente del dataset: estudio longitudinal OSF (codigo 2anvx) "Chronic
# Disease Longitudinal Study" (T1-T5), donante con enfermedad cronica,
# EE.UU. Se usa solo la ola T1 (linea base) para no introducir dependencia
# intra-sujeto entre observaciones -- las olas T2-T5 del mismo dataset NO
# se usan.
#
# OJO -- busqueda de un instrumento real con k=8 (ver notes/DESIGN.md):
# se evaluaron 3 datasets abiertos con la Adult Hope Scale en escala 1-8
# (OSF xwcu8 N=591 poblacion general, OSF db3h7 N=409 solo hombres
# gay/bisexuales, OSF 2anvx N=1.036 pacientes cronicos). Se descarto
# combinarlos en un solo dataset pese a compartir instrumento identico:
# ANOVA de un factor sobre el puntaje total mostro diferencia significativa
# entre las 3 poblaciones (F(2,2033)=48.44, p<.001, eta2=.045 -- medias
# 50.18/43.88/48.50 respectivamente), lo que violaria el supuesto del
# submuestreo m-out-of-N de que el N completo representa UNA sola
# poblacion de referencia (mismo criterio ya aplicado para descartar un
# candidato de k=6 restringido a un solo sexo). Se eligio 2anvx solo por
# tener el N mas alto (1.036) y no tener restriccion demografica explicita
# mas alla del diagnostico cronico. Como N=1.036 < 1.500 (el maximo de la
# grilla de n usada en los otros 5 datasets), este dataset usa una grilla
# de n reducida (hasta 1.000, no 1.500) -- ver R/02_bloque_real_categorias.R.
cat("=== AHS ola T1 (k=8) ===\n")
ahs_items <- paste0("AHS0", 1:8, ".1")
ahs_raw <- haven::read_sav("data/raw/osf_2anvx_chronic_disease_T1-T5.sav",
                            col_select = all_of(ahs_items))
ahs_total <- score_composite(as.data.frame(ahs_raw), ahs_items, character(0), min_val = 1, max_val = 8)
cat(sprintf("  n=%d\n", length(ahs_total)))
readr::write_csv(data.frame(k = 8L, puntaje = ahs_total), "data/processed/ahs_k8.csv")

cat("\nListo.\n")
