# Implementación exacta de las 11 pruebas de normalidad

Documentación de reproducibilidad pedida en una revisión externa (ver
`notes/prompt_revision_julius.md`, punto #16): paquete, versión (la
instalada localmente al escribir esto; las corridas reales en GitHub
Actions usan `any::<paquete>` — la última versión de CRAN disponible en
el momento de cada corrida, no fijada por versión exacta), función y
manejo de fallos/empates de cada prueba. Código fuente único en
`R/08_run_battery.R`.

| Prueba | Paquete | Versión (local) | Función | Argumentos no default | Manejo de fallos |
|---|---|---|---|---|---|
| Shapiro-Wilk | base R (`stats`) | (base) | `stats::shapiro.test()` | ninguno | `NA` si falla o si `n` está fuera de su rango válido (3–5000) |
| Anderson-Darling | nortest | 1.0.4 | `nortest::ad.test()` | ninguno | `NA` si falla (`n<8`) |
| Lilliefors | nortest | 1.0.4 | `nortest::lillie.test()` | ninguno | `NA` si falla (`n<5`) |
| Jarque-Bera | tseries | 0.10-63 | `tseries::jarque.bera.test()` | ninguno | `NA` si falla |
| D'Agostino-Pearson | fBasics | 4052.98 | `fBasics::dagoTest()` | se extrae el componente `Omnibus Test` (ver comentario en el código: el paquete nombra este p-valor con dos espacios, `"Omnibus  Test"`, no uno) | `NA` si falla |
| Cramér-von Mises | nortest | 1.0.4 | `nortest::cvm.test()` | ninguno | `NA` si falla |
| Shapiro-Francia | nortest | 1.0.4 | `nortest::sf.test()` | ninguno | `NA` si falla o da warning fuera de su rango válido de $n$ (5–5000) |
| Pearson $\chi^2$ | nortest | 1.0.4 | `nortest::pearson.test()` | número de clases por defecto del paquete (regla de Moore, $\lceil 2n^{2/5} \rceil$) | `NA` si falla |
| Curtosis (Anscombe-Glynn) | moments | 0.14.1 | `moments::anscombe.test()` | ninguno | `NA` si falla (requiere $n \geq 4$) |
| Epps-Pulley | nortsTest | 1.1.3 | `nortsTest::epps.test()` | `lambda = c(1, 2)` (parámetros de ponderación por defecto del paquete) | `NA` si falla |
| SSTN | sstn | 1.0.2 | `sstn::sstn()` | ninguno (calibra su nula internamente por réplica) | `NA` si falla |

Ninguna de las 11 funciones hace un tratamiento especial de empates más
allá del que implementa internamente cada paquete (ninguna se llamó con
argumentos de corrección de continuidad o de empates no default). Con
$k$ chico y $n$ grande, el puntaje compuesto discretizado tiene un
soporte finito y produce empates frecuentes -- ver el chequeo de error
Tipo I (`R/03_calibrar_niveles.R`, nivel `normal`; resultado en
`data/results/nivel_normal_k*.csv` y discutido en el manuscrito,
sección "Calibración de las 11 pruebas sin severidad inyectada") para
el efecto empírico de esto sobre la calibración de cada prueba.

Todas las funciones se envuelven en `safe_p()` (`R/08_run_battery.R`),
que captura tanto errores como warnings y devuelve `NA` en vez de
propagar la falla -- así una réplica con una prueba fallida no descarta
las otras 10 p-valores de esa misma réplica. El conteo de `NA` por
prueba, $k$ y $n$ se guarda en cada CSV de resultados (columnas
`<prueba>_na`).
