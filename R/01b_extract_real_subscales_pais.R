# 01b_extract_real_subscales_pais.R
#
# Chequeo de robustez pedido explicitamente por el usuario (ver
# notes/DESIGN.md): la mayoria de los 6 datasets reales agrupan
# respondentes de paises/culturas muy distintas en un solo N, sin verificar
# invarianza de medicion -- una critica valida y esperable de un revisor,
# dado que la cultura puede afectar como se responde a estos constructos.
# En vez de asumir que eso no importa, este script separa CADA dataset (con
# pais reportado) en dos submuestras -- EE.UU. vs. resto del mundo -- para
# poder comparar despues, dataset por dataset, si la potencia/forma de las
# 11 pruebas difiere entre esos dos grupos.
#
# Reusa EXACTAMENTE la misma logica de puntuacion (items, reversion,
# rango valido, caso completo) que R/01_extract_real_subscales.R -- ver ese
# archivo para el detalle y las fuentes de cada clave de reversion. Este
# script NO la reimplementa de cero, la aplica sobre los mismos datos
# crudos, solo que separados por pais antes de puntuar.
#
# 5 de los 6 instrumentos tienen campo de pais utilizable:
#   RSE, MACH-IV, HEXACO: columna "country" (ISO de 2 letras, autorreportado
#     o por IP -- openpsychometrics.org no documenta cual de los dos).
#   RWAS: columna "IP_country" -- OJO, 87.8% de los casos vienen con este
#     campo VACIO (no es que esos respondentes sean de fuera de EE.UU., es
#     que el campo no se registro). Splitear con esto implica descartar el
#     87.8% de la muestra y quedarse solo con el 12% que si tiene pais
#     conocido -- un subconjunto que podria no ser representativo del resto
#     de RWAS. Se documenta explicitamente como limitacion en el reporte
#     final, no se oculta.
#   SPS-10 (COVIDiSTRESS): columna "Country" (nombre completo, no ISO).
#     Aqui EE.UU. es una fraccion chica de la muestra (1.85%, Finlandia es
#     el pais mas grande con 18.3%) -- lo opuesto al patron de
#     openpsychometrics.org, donde EE.UU. domina (46-66%).
#
# Adult Hope Scale (ola T1, OSF 2anvx) NO tiene este script porque es,
# por diseno, un estudio exclusivamente de EE.UU. (incluye variable de
# estado, no de pais) -- no existe un grupo "resto del mundo" que extraer
# de ahi. Se documenta como exclusion estructural, no un descarte de
# conveniencia.
#
# Grilla de n reducida a {10,25,50,100,250} para este chequeo (no la grilla
# completa de 8 tamaños usada en el bloque real principal): a partir de
# n=250 la brecha de potencia entre k extremos ya es practicamente cero en
# casi todos los niveles de severidad del bloque simulado (ver Resultados,
# Tabla de brecha por n y nivel), asi que n=250 ya cubre la zona donde el
# fenomeno es observable. Ademas, RWAS-EEUU solo tiene N=676 tras el
# filtro de pais conocido -- un n maximo de 1500 (o incluso 500) dejaria
# una razon N/n demasiado ajustada para que el submuestreo sin reemplazo
# tenga variabilidad real entre replicas; con n=250 la razon queda en 2.7,
# razonable. Ver R/02_bloque_real_categorias.R, que ya soporta un grid
# custom via su tercer argumento -- no hizo falta tocar ese script.

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

#' Puntua un dataset ya separado en dos grupos por pais (EEUU vs resto) y
#' escribe ambos CSV, con el mismo formato (columnas k, puntaje) que
#' R/01_extract_real_subscales.R para que R/02_bloque_real_categorias.R los
#' pueda usar sin modificacion.
puntuar_y_guardar_por_pais <- function(raw, pais_col, us_values, items,
                                        reverse_items, min_val, max_val,
                                        k_nativo, nombre_base,
                                        excluir_pais_vacio = FALSE) {
  pais <- trimws(raw[[pais_col]])
  if (excluir_pais_vacio) {
    valido <- !is.na(pais) & pais != "" & pais != "NONE"
    n_excluido <- sum(!valido)
    cat(sprintf(
      "  %s: %d de %d casos SIN pais conocido, excluidos de este chequeo (%.1f%%)\n",
      nombre_base, n_excluido, nrow(raw), 100 * n_excluido / nrow(raw)
    ))
    raw <- raw[valido, , drop = FALSE]
    pais <- pais[valido]
  }
  es_us <- pais %in% us_values

  raw_us <- raw[es_us, , drop = FALSE]
  raw_resto <- raw[!es_us, , drop = FALSE]

  total_us <- score_composite(raw_us, items, reverse_items, min_val, max_val)
  total_resto <- score_composite(raw_resto, items, reverse_items, min_val, max_val)

  cat(sprintf("  %s: N_EEUU=%d, N_resto=%d\n", nombre_base, length(total_us), length(total_resto)))

  readr::write_csv(data.frame(k = k_nativo, puntaje = total_us),
                    sprintf("data/processed/%s_us.csv", nombre_base))
  readr::write_csv(data.frame(k = k_nativo, puntaje = total_resto),
                    sprintf("data/processed/%s_nous.csv", nombre_base))
}

# --- RSE (k=4) -------------------------------------------------------------

cat("=== RSE (k=4), EE.UU. vs. resto ===\n")
rse_raw <- read_zip_csv("data/raw/RSE.zip", delim = "\t")
puntuar_y_guardar_por_pais(
  rse_raw, pais_col = "country", us_values = "US",
  items = paste0("Q", 1:10), reverse_items = paste0("Q", c(3,5,8,9,10)),
  min_val = 1, max_val = 4, k_nativo = 4L, nombre_base = "rse_k4"
)

# --- MACH-IV (k=5) ----------------------------------------------------------

cat("=== MACH-IV (k=5), EE.UU. vs. resto ===\n")
mach_raw <- read_zip_csv("data/raw/MACH_data.zip", delim = "\t")
puntuar_y_guardar_por_pais(
  mach_raw, pais_col = "country", us_values = "US",
  items = paste0("Q", 1:20, "A"),
  reverse_items = paste0("Q", c(3,4,6,7,9,10,11,14,16,17), "A"),
  min_val = 1, max_val = 5, k_nativo = 5L, nombre_base = "mach_k5"
)

# --- HEXACO, facet X:Expr (k=7) --------------------------------------------

cat("=== HEXACO X:Expr (k=7), EE.UU. vs. resto ===\n")
hexaco_raw <- read_zip_csv("data/raw/HEXACO.zip", delim = "\t")
puntuar_y_guardar_por_pais(
  hexaco_raw, pais_col = "country", us_values = "US",
  items = paste0("XExpr", 1:10), reverse_items = paste0("XExpr", 6:10),
  min_val = 1, max_val = 7, k_nativo = 7L, nombre_base = "hexaco_k7"
)

# --- RWAS (k=9) --------------------------------------------------------
#
# OJO: IP_country vacio en el 87.8% de los casos (ver cabecera del
# script) -- se excluyen esos casos de este chequeo especifico, quedando
# solo con el 12% de pais conocido.

cat("=== RWAS (k=9), EE.UU. vs. resto (solo pais conocido) ===\n")
rwas_raw <- read_zip_csv("data/raw/RWAS.zip", delim = ",")
puntuar_y_guardar_por_pais(
  rwas_raw, pais_col = "IP_country", us_values = "US",
  items = paste0("Q", 1:22),
  reverse_items = paste0("Q", c(4,6,8,9,11,13,15,18,20,21)),
  min_val = 1, max_val = 9, k_nativo = 9L, nombre_base = "rwas_k9",
  excluir_pais_vacio = TRUE
)

# --- SPS-10, COVIDiSTRESS Global Survey (k=6) -------------------------------

cat("=== SPS-10 COVIDiSTRESS (k=6), EE.UU. vs. resto ===\n")
sps_items <- paste0("SPS_", 1:10)
sps_raw <- readr::read_csv(
  "data/raw/covidistress_global_survey_2020-05-30.csv.gz",
  col_select = all_of(c(sps_items, "Country")),
  col_types = readr::cols(.default = readr::col_double(), Country = readr::col_character()),
  show_col_types = FALSE
)
puntuar_y_guardar_por_pais(
  as.data.frame(sps_raw), pais_col = "Country", us_values = "United States",
  items = sps_items, reverse_items = character(0),
  min_val = 1, max_val = 6, k_nativo = 6L, nombre_base = "sps_k6"
)

cat("\nListo.\n")
