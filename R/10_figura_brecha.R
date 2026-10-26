# 10_figura_brecha.R
# Figura 2 del manuscrito: brecha de potencia corregida (k=3 - k=9) por n y
# nivel de severidad. Valores = Tabla 3 del manuscrito (promedio sobre las
# 11 pruebas). Ejes sin cero inicial (APA 7: el valor esta acotado a [-1, 1]).
# Genera la version en espanol y la inglesa (la inglesa se usa en k_paper_en.tex).
# Uso: Rscript R/10_figura_brecha.R
library(ggplot2)

n_grid <- c(10, 25, 50, 100, 250, 500, 1000, 1500)
niveles <- c("Bajo", "Bajo-moderado", "Moderado", "Alto", "Muy alto")
d <- data.frame(
  n = rep(n_grid, 5),
  nivel = factor(rep(niveles, each = 8), levels = niveles),
  brecha = c(
    -0.048, -0.135, -0.270, -0.371, -0.431, -0.416, -0.455, -0.454,
    -0.028, -0.037, -0.061, -0.116, -0.419, -0.574, -0.629, -0.632,
    -0.050, -0.102, -0.211, -0.429, -0.580, -0.579, -0.524, -0.448,
    -0.108, -0.202, -0.203, -0.077, -0.095, -0.182, -0.364, -0.364,
    -0.058, -0.020, -0.045, -0.051, -0.107, -0.182, -0.364, -0.364
  )
)
colores <- c("Bajo" = "#2c6fbb", "Bajo-moderado" = "#33b0c9", "Moderado" = "#8fd0b0",
             "Alto" = "#f5a623", "Muy alto" = "#c0392b")

# APA 7: sin cero inicial en valores acotados a 1; "0" se queda como "0"
sin_cero <- function(x) {
  s <- sprintf("%.1f", x)
  s <- sub("^(-?)0\\.", "\\1.", s)
  s <- sub("^-", "−", s)
  s[x == 0] <- "0"
  s
}

hacer_figura <- function(idioma) {
  if (idioma == "en") {
    levels(d$nivel) <- c("Low", "Low-moderate", "Moderate", "High", "Very high")
    nombres <- c("Low", "Low-moderate", "Moderate", "High", "Very high")
    tit_leyenda <- "Severity level"
    etq_x <- "Sample size (n, log scale)"
    etq_y <- "Corrected power gap (k=3 - k=9)"
    archivo <- "paper/figuras/brecha_k3_k9_por_n_y_nivel_en.pdf"
  } else {
    nombres <- niveles
    tit_leyenda <- "Nivel de severidad"
    etq_x <- "Tama\u00f1o de muestra (n, escala log)"
    etq_y <- "Brecha de potencia corregida (k=3 - k=9)"
    archivo <- "paper/figuras/brecha_k3_k9_por_n_y_nivel.pdf"
  }
  cols <- setNames(unname(colores), nombres)
  p <- ggplot(d, aes(x = n, y = brecha, color = nivel)) +
    geom_hline(yintercept = 0, color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 1) +
    geom_point(size = 2.2) +
    scale_x_log10(breaks = n_grid) +
    scale_y_continuous(labels = sin_cero) +
    scale_color_manual(values = cols, name = tit_leyenda) +
    labs(x = etq_x, y = etq_y) +
    theme_minimal(base_size = 13) +
    theme(panel.grid.minor = element_blank(), legend.position = "right")
  ggsave(archivo, p, width = 7.2, height = 4.4, device = cairo_pdf)
}
d_es <- d
hacer_figura("es")
d <- d_es
hacer_figura("en")
