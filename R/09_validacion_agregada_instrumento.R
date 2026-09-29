# 09_validacion_agregada_instrumento.R
#
# Responde el punto #5 de la tercera revision externa (ver
# notes/prompt_revision_julius_v2.md): la validacion real-vs-simulado
# reportada en el manuscrito (r=.977 corregido) se calcula sobre 47 celdas
# (instrumento x n), pero esas 47 celdas no son unidades independientes --
# son 6 instrumentos repetidos a traves de n. Este script reconstruye esa
# correlacion (celda a celda, para verificar que coincide con lo ya escrito
# en k_paper.tex) y ademas la recalcula agregando primero por instrumento
# (promediando sobre n), lo que da 6 puntos genuinamente independientes en
# vez de 47 celdas correlacionadas entre si por compartir instrumento.
#
# Corre sobre datos ya commiteados en data/results/ (nivel_*_corregido.csv,
# bloque_real_*_corregido.csv) -- no requiere GitHub Actions, no es una
# "corrida real" nueva, no hay aleatoriedad involucrada.
#
# Uso: Rscript R/09_validacion_agregada_instrumento.R

instrumentos <- list(
  rse_k4    = list(k = 4, nivel = "bajo_moderado", archivo_real = "data/results/bloque_real_rse_k4_corregido.csv"),
  mach_k5   = list(k = 5, nivel = "bajo_moderado", archivo_real = "data/results/bloque_real_mach_k5_corregido.csv"),
  sps_k6    = list(k = 6, nivel = "alto",          archivo_real = "data/results/bloque_real_sps_k6_corregido.csv"),
  hexaco_k7 = list(k = 7, nivel = "bajo_moderado", archivo_real = "data/results/bloque_real_hexaco_k7_corregido.csv"),
  ahs_k8    = list(k = 8, nivel = "moderado",      archivo_real = "data/results/bloque_real_ahs_k8_corregido.csv"),
  rwas_k9   = list(k = 9, nivel = "alto",          archivo_real = "data/results/bloque_real_rwas_k9_corregido.csv")
)

celdas <- list()
idx <- 1
for (instr in names(instrumentos)) {
  info <- instrumentos[[instr]]
  archivo_sim <- sprintf("data/results/nivel_%s_k%d_corregido.csv", info$nivel, info$k)
  sim <- readr::read_csv(archivo_sim, show_col_types = FALSE)
  real <- readr::read_csv(info$archivo_real, show_col_types = FALSE)

  sim_por_n <- stats::aggregate(tasa_corregida ~ n, data = sim, FUN = mean, na.rm = TRUE)
  real_por_n <- stats::aggregate(tasa_corregida ~ n, data = real, FUN = mean, na.rm = TRUE)
  names(sim_por_n)[2] <- "potencia_sim"
  names(real_por_n)[2] <- "potencia_real"

  m <- merge(sim_por_n, real_por_n, by = "n")
  m$instrumento <- instr
  celdas[[idx]] <- m
  idx <- idx + 1
}

celdas <- do.call(rbind, celdas)
cat(sprintf("Celdas (instrumento x n) combinadas: %d\n", nrow(celdas)))

r_celda <- stats::cor(celdas$potencia_real, celdas$potencia_sim)
cat(sprintf("r celda-a-celda (potencia corregida, %d celdas): %.4f\n", nrow(celdas), r_celda))

# --- Agregado por instrumento (6 puntos independientes) --------------------

por_instrumento <- stats::aggregate(
  cbind(potencia_real, potencia_sim) ~ instrumento, data = celdas, FUN = mean
)
print(por_instrumento)

r_instrumento <- stats::cor(por_instrumento$potencia_real, por_instrumento$potencia_sim)
cat(sprintf(
  "\nr agregado por instrumento (potencia corregida, N=%d instrumentos independientes): %.4f\n",
  nrow(por_instrumento), r_instrumento
))

dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(celdas, "data/results/validacion_celdas_corregida.csv")
readr::write_csv(por_instrumento, "data/results/validacion_por_instrumento_corregida.csv")
cat("\nGuardado data/results/validacion_celdas_corregida.csv y data/results/validacion_por_instrumento_corregida.csv\n")
cat("Listo.\n")
