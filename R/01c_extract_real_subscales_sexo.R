# 01c_extract_real_subscales_sexo.R
#
# Segundo chequeo de robustez, analogo a 01b_extract_real_subscales_pais.R
# pero particionando por sexo (hombres vs. mujeres) en vez de por pais --
# misma logica: agrupar un N heterogeneo (aca, por sexo en vez de por
# pais) puede inflar la no-normalidad aparente del puntaje compuesto por
# mezcla de subpoblaciones con formas/medias distintas, no solo por la
# severidad "propia" del constructo. Hay literatura sustantiva de
# diferencias por sexo en 4 de estos 5 constructos (autoestima, RSE;
# maquiavelismo, MACH-IV; soporte social, SPS-10; autoritarismo, RWAS es
# menos consistente) y el propio diseño del estudio ya habia considerado
# esto: un candidato de k=6 restringido a un solo sexo fue descartado en
# la seleccion de datasets precisamente por ese motivo (ver comentario en
# R/01_extract_real_subscales.R, seccion AHS).
#
# 5 de los 6 instrumentos tienen campo de sexo utilizable:
#   RSE, MACH-IV, RWAS (openpsychometrics.org): columna "gender",
#     1=Male, 2=Female, 3=Other, 0=ninguno elegido (confirmado contra el
#     codebook.txt de cada zip). Se excluyen 3 y 0 de este chequeo (N muy
#     chico y sin una interpretacion binaria clara).
#   SPS-10 (COVIDiSTRESS): columna "Dem_gender", valores "Male"/"Female"/
#     "Other/would rather not say"/NA. Se excluyen las ultimas dos.
#   AHS (OSF 2anvx): columna "gender.1" (SPSS labelled), niveles Male/
#     Female/Transgender/Other (498/535/2/1) -- se excluyen Transgender y
#     Other por N despreciable (3 casos en total).
#
# HEXACO (k=7) NO tiene este script: su dataset (openpsychometrics.org) no
# incluye NINGUNA columna de sexo/genero (confirmado contra su
# codebook.txt -- solo trae los 10 items x 24 facetas, dos items de
# atencion V1/V2, country y elapse). Exclusion estructural, no descarte de
# conveniencia -- igual que Adult Hope Scale quedo fuera del chequeo por
# pais (ver R/01b_extract_real_subscales_pais.R) por ser 100% EE.UU.
#
# Reusa la logica de puntuacion EXACTA de R/01_extract_real_subscales.R
# (items, reversion, rango valido, caso completo) -- ver ese archivo para
# el detalle y las fuentes de cada clave.

source("R/00_setup.R")

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

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

#' Puntua un dataset separado en hombres/mujeres (excluyendo otras
#' categorias/missing de sexo) y escribe ambos CSV, mismo formato (k,
#' puntaje) que R/01_extract_real_subscales.R.
puntuar_y_guardar_por_sexo <- function(raw, sexo_col, valor_hombre, valor_mujer,
                                        items, reverse_items, min_val, max_val,
                                        k_nativo, nombre_base) {
  sexo <- raw[[sexo_col]]
  es_hombre <- sexo == valor_hombre
  es_mujer <- sexo == valor_mujer
  n_excluido <- sum(!es_hombre & !es_mujer)
  cat(sprintf(
    "  %s: %d de %d casos excluidos (sexo no binario/no declarado, %.1f%%)\n",
    nombre_base, n_excluido, nrow(raw), 100 * n_excluido / nrow(raw)
  ))

  total_hombres <- score_composite(raw[es_hombre, , drop = FALSE], items, reverse_items, min_val, max_val)
  total_mujeres <- score_composite(raw[es_mujer, , drop = FALSE], items, reverse_items, min_val, max_val)

  cat(sprintf("  %s: N_hombres=%d, N_mujeres=%d\n", nombre_base, length(total_hombres), length(total_mujeres)))

  readr::write_csv(data.frame(k = k_nativo, puntaje = total_hombres),
                    sprintf("data/processed/%s_hombres.csv", nombre_base))
  readr::write_csv(data.frame(k = k_nativo, puntaje = total_mujeres),
                    sprintf("data/processed/%s_mujeres.csv", nombre_base))
}

# --- RSE (k=4) -------------------------------------------------------------

cat("=== RSE (k=4), hombres vs. mujeres ===\n")
rse_raw <- read_zip_csv("data/raw/RSE.zip", delim = "\t")
puntuar_y_guardar_por_sexo(
  rse_raw, sexo_col = "gender", valor_hombre = "1", valor_mujer = "2",
  items = paste0("Q", 1:10), reverse_items = paste0("Q", c(3,5,8,9,10)),
  min_val = 1, max_val = 4, k_nativo = 4L, nombre_base = "rse_k4"
)

# --- MACH-IV (k=5) ----------------------------------------------------------

cat("=== MACH-IV (k=5), hombres vs. mujeres ===\n")
mach_raw <- read_zip_csv("data/raw/MACH_data.zip", delim = "\t")
puntuar_y_guardar_por_sexo(
  mach_raw, sexo_col = "gender", valor_hombre = "1", valor_mujer = "2",
  items = paste0("Q", 1:20, "A"),
  reverse_items = paste0("Q", c(3,4,6,7,9,10,11,14,16,17), "A"),
  min_val = 1, max_val = 5, k_nativo = 5L, nombre_base = "mach_k5"
)

# --- RWAS (k=9) --------------------------------------------------------

cat("=== RWAS (k=9), hombres vs. mujeres ===\n")
rwas_raw <- read_zip_csv("data/raw/RWAS.zip", delim = ",")
puntuar_y_guardar_por_sexo(
  rwas_raw, sexo_col = "gender", valor_hombre = "1", valor_mujer = "2",
  items = paste0("Q", 1:22),
  reverse_items = paste0("Q", c(4,6,8,9,11,13,15,18,20,21)),
  min_val = 1, max_val = 9, k_nativo = 9L, nombre_base = "rwas_k9"
)

# --- SPS-10, COVIDiSTRESS Global Survey (k=6) -------------------------------

cat("=== SPS-10 COVIDiSTRESS (k=6), hombres vs. mujeres ===\n")
sps_items <- paste0("SPS_", 1:10)
sps_raw <- readr::read_csv(
  "data/raw/covidistress_global_survey_2020-05-30.csv.gz",
  col_select = all_of(c(sps_items, "Dem_gender")),
  col_types = readr::cols(.default = readr::col_double(), Dem_gender = readr::col_character()),
  locale = readr::locale(encoding = "ISO-8859-1"),
  show_col_types = FALSE
)
puntuar_y_guardar_por_sexo(
  as.data.frame(sps_raw), sexo_col = "Dem_gender", valor_hombre = "Male", valor_mujer = "Female",
  items = sps_items, reverse_items = character(0),
  min_val = 1, max_val = 6, k_nativo = 6L, nombre_base = "sps_k6"
)

# --- AHS, ola T1 (k=8) -------------------------------------------------

cat("=== AHS ola T1 (k=8), hombres vs. mujeres ===\n")
ahs_items <- paste0("AHS0", 1:8, ".1")
ahs_raw <- haven::read_sav("data/raw/osf_2anvx_chronic_disease_T1-T5.sav",
                            col_select = all_of(c(ahs_items, "gender.1")))
ahs_raw <- as.data.frame(ahs_raw)
ahs_raw$gender.1 <- as.character(haven::as_factor(ahs_raw$`gender.1`))
puntuar_y_guardar_por_sexo(
  ahs_raw, sexo_col = "gender.1", valor_hombre = "Male", valor_mujer = "Female",
  items = ahs_items, reverse_items = character(0),
  min_val = 1, max_val = 8, k_nativo = 8L, nombre_base = "ahs_k8"
)

cat("\nListo.\n")
