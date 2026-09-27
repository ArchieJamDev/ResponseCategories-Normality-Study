# 06_ocupacion_categorias.R
#
# Calcula la probabilidad marginal de cada una de las k categorias de
# respuesta, por celda (nivel x k), a partir de los umbrales ya calibrados
# (data/results/calibracion_niveles.csv y calibracion_nivel_normal.csv).
# Cada item tiene distribucion marginal N(0,1) (theta~N(0,1), eps~N(0,1) y
# item = lambda*theta + sqrt(1-lambda^2)*eps con lambda^2+(1-lambda^2)=1),
# asi que las probabilidades de categoria se obtienen directo de pnorm() en
# los umbrales -- no hace falta simular nada nuevo.
#
# Responde el punto #18 de una revision externa (ver
# notes/prompt_revision_julius.md): si hay celdas donde alguna categoria de
# respuesta queda casi vacia (lo que puede degradar el comportamiento de
# las pruebas de normalidad sobre el compuesto, ver la seccion de
# calibracion de las 11 pruebas del manuscrito).
#
# Uso: Rscript R/06_ocupacion_categorias.R

calcular_probs <- function(umbrales) {
  bounds <- c(-Inf, sort(umbrales), Inf)
  diff(pnorm(bounds))
}

archivos <- c("data/results/calibracion_niveles.csv", "data/results/calibracion_nivel_normal.csv")
filas <- list()
idx <- 1
for (archivo in archivos) {
  tabla <- readr::read_csv(archivo, show_col_types = FALSE)
  for (i in seq_len(nrow(tabla))) {
    fila <- tabla[i, ]
    k <- fila$k
    cols_umbral <- sprintf("umbral_%d", seq_len(k - 1))
    umbrales <- as.numeric(fila[1, cols_umbral])
    probs <- calcular_probs(umbrales)
    filas[[idx]] <- data.frame(
      nivel = fila$nivel, k = k, categoria = seq_len(k), prob = probs,
      prob_min = min(probs), prob_max = max(probs)
    )
    idx <- idx + 1
  }
}

resultado <- do.call(rbind, filas)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(resultado, "data/results/ocupacion_categorias.csv")

resumen <- unique(resultado[, c("nivel", "k", "prob_min", "prob_max")])
resumen <- resumen[order(resumen$prob_min), ]
cat("Celdas con la categoria menos ocupada (prob_min mas chica primero):\n")
print(head(resumen, 10))
cat(sprintf(
  "\n%d de %d celdas tienen al menos una categoria con probabilidad < 1%%.\n",
  sum(resumen$prob_min < 0.01), nrow(resumen)
))
cat("Guardado data/results/ocupacion_categorias.csv\n")
cat("Listo.\n")
