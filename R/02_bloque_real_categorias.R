# 02_bloque_real_categorias.R
#
# Bloque real -- analogo al bloque de niveles simulado (efecto de la
# cantidad de categorias de respuesta k sobre la potencia de las 11 pruebas
# de normalidad), pero sobre datos reales en vez de un factor comun
# simulado. Submuestreo aleatorio sin reemplazo tipo "m-out-of-N": no hay
# una nula verdadera conocida en datos reales, asi que se extraen R
# submuestras aleatorias SIN reemplazo a cada tamaño n de la MISMA grilla
# usada en la simulacion, y se calcula la tasa de rechazo empirica por
# prueba usando el N completo del dataset como poblacion de referencia.
#
# Los 6 datasets (ver R/01_extract_real_subscales.R para las claves de
# puntuacion) cubren 6 valores REALES de k, eligiendo deliberadamente los
# valores mas cercanos a los extremos disponibles en datos abiertos
# (ver notes/DESIGN.md):
#   rse_k4.csv     k=4  (Rosenberg Self-Esteem Scale, N=46.546)
#   mach_k5.csv    k=5  (MACH-IV, N=73.486)
#   sps_k6.csv     k=6  (Social Provisions Scale SPS-10, COVIDiSTRESS, N=91.658)
#   hexaco_k7.csv  k=7  (HEXACO facet X:Expr, N=22.783)
#   ahs_k8.csv     k=8  (Adult Hope Scale, ola T1, pacientes cronicos OSF 2anvx, N=1.036)
#   rwas_k9.csv    k=9  (Right-Wing Authoritarianism Scale, N=9.680)
#
# Grilla de n IDENTICA a la del bloque de niveles simulado (mismo criterio
# de comparabilidad directa entre el hallazgo simulado y su contraparte
# real): {10,25,50,100,250,500,1000,1500}. El N minimo de los 5 datasets
# de la grilla completa (RWAS, 9.680) es muy superior a 1500, asi que el
# submuestreo sin reemplazo es valido sin ajuste para esos 5.
#
# EXCEPCION -- ahs_k8 (N=1.036) NO alcanza el maximo de la grilla (1500),
# asi que corre con una grilla reducida {10,25,50,100,250,500,1000} (ver
# .github/workflows/simulate.yml, que le pasa un tercer argumento distinto
# solo a este dataset). Se evaluo combinar ahs_k8 con otros 2 datasets
# abiertos que usan el mismo instrumento (Adult Hope Scale, misma escala
# 1-8) para llegar a N>1500, pero se descarto: las 3 poblaciones (pacientes
# cronicos, poblacion general, hombres gay/bisexuales) difieren
# significativamente en el puntaje total (ANOVA F(2,2033)=48.44, p<.001,
# eta2=.045), lo que violaria el supuesto de que el N completo representa
# una sola poblacion de referencia -- ver R/01_extract_real_subscales.R
# para el detalle completo de esta decision.
#
# Uso: Rscript R/02_bloque_real_categorias.R <dataset> [R] [n_list]
#   <dataset>: nombre de archivo tal como aparece en data/processed/ (ej.
#              "rwas_k9.csv"), producido por R/01_extract_real_subscales.R
#   [R]: numero de submuestras por celda (default 10000)
#   [n_list]: lista de tamaños de muestra separados por coma. Default: grid
#             completo de arriba. Si se pasa un grid distinto, el archivo de
#             salida queda con sufijo _nXXX para no pisar la corrida
#             canonica.

source("R/00_setup.R")
source("R/08_run_battery.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Uso: Rscript R/02_bloque_real_categorias.R <dataset> [R] [n_list]")
}
dataset_elegido <- args[1]
R_replicas <- if (length(args) >= 2) as.integer(args[2]) else 10000L

n_grid_default <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
n_grid <- if (length(args) >= 3) {
  as.integer(strsplit(args[3], ",")[[1]])
} else {
  n_grid_default
}
es_grid_default <- identical(sort(n_grid), sort(n_grid_default))

ruta_datos <- file.path("data/processed", dataset_elegido)
if (!file.exists(ruta_datos)) {
  stop(sprintf("No se encontro '%s' (esperado en data/processed/, correr R/01_extract_real_subscales.R primero).", ruta_datos))
}
tabla_datos <- readr::read_csv(ruta_datos, show_col_types = FALSE)
k_nativo <- tabla_datos$k[1]
x_completo <- tabla_datos$puntaje
x_completo <- x_completo[!is.na(x_completo)]
N <- length(x_completo)

if (max(n_grid) >= N) {
  stop(sprintf(
    "n maximo del grid (%d) >= N del dataset (%d) -- submuestreo sin reemplazo invalido.",
    max(n_grid), N
  ))
}

cat(sprintf(
  "Bloque real -- dataset='%s' (k=%d, N=%d), R=%d submuestras, %d tamaños de muestra\n\n",
  dataset_elegido, k_nativo, N, R_replicas, length(n_grid)
))

# Misma semilla fija que el resto del proyecto hermano, por consistencia de
# convencion (cada dataset corre en su propio proceso R como shard
# independiente del workflow).
set.seed(20260918)

filas <- list()
idx <- 1
for (n in n_grid) {
  # Numero de pruebas de la bateria detectado en la primera replica (11) --
  # NO hardcodeado, mismo criterio que SSTN-Normality-Study.
  rechazos <- NULL
  nombres_pruebas <- NULL
  t0 <- Sys.time()
  for (r in seq_len(R_replicas)) {
    x <- sample(x_completo, size = n, replace = FALSE)
    pvals <- run_battery(x)
    if (is.null(rechazos)) {
      nombres_pruebas <- names(pvals)
      rechazos <- matrix(NA, nrow = R_replicas, ncol = length(pvals))
    }
    rechazos[r, ] <- pvals < 0.05
  }
  tasas <- colMeans(rechazos, na.rm = TRUE)
  n_na <- colSums(is.na(rechazos))
  names(tasas) <- nombres_pruebas
  names(n_na) <- paste0(nombres_pruebas, "_na")
  segundos <- as.numeric(Sys.time() - t0, units = "secs")

  fila <- c(
    list(dataset = dataset_elegido, k = k_nativo, N = N, n = n, R = R_replicas),
    as.list(tasas), as.list(n_na),
    list(segundos = segundos)
  )
  filas[[idx]] <- as.data.frame(fila, stringsAsFactors = FALSE)
  idx <- idx + 1

  cat(sprintf(
    "%-14s k=%d n=%4d -> %7.1fs total (%.2fms/replica)\n",
    dataset_elegido, k_nativo, n, segundos, 1000 * segundos / R_replicas
  ))
}

tabla <- do.call(rbind, filas)

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
dataset_base <- sub("\\.csv$", "", dataset_elegido)
out_path <- if (es_grid_default) {
  sprintf("data/results/bloque_real_%s.csv", dataset_base)
} else {
  sprintf("data/results/bloque_real_%s_n%s.csv", dataset_base, paste(n_grid, collapse = "-"))
}
readr::write_csv(tabla, out_path)
cat(sprintf("\nGuardado %s\n", out_path))
cat("Listo.\n")
