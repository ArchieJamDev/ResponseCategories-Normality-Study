# Método (borrador v1) — segundo paper

Prosa continua, sin marcado LaTeX de plantilla todavía. Numeración de subsecciones provisional (2.1, 2.2...), a ajustar cuando se una con la plantilla real.

---

## 2.1. Diseño general

El estudio combina dos componentes complementarios, ambos evaluados con la misma batería de once pruebas de normalidad (§2.5) y, cuando aplica, la misma grilla de tamaño de muestra *n* ∈ {10, 25, 50, 100, 250, 500, 1000, 1500}. El primer componente es puramente simulado (§2.3): cinco niveles ordenados de severidad de no-normalidad, cruzados sistemáticamente con *k* ∈ {3, ..., 9} y con *n*, aíslan el efecto de la cantidad de categorías de respuesta de la forma específica de la distribución subyacente. El segundo componente ancla ese resultado a la práctica psicométrica real (§2.4): cuatro instrumentos de acceso abierto que difieren en su cantidad nativa de categorías de respuesta se someten a submuestreo aleatorio repetido sobre la misma grilla de *n*.

## 2.2. Instrumentos psicométricos reales

Los cuatro instrumentos usados en el componente de datos reales, todos provenientes del catálogo de datos abiertos de openpsychometrics.org, se resumen en la Tabla 1. Se seleccionaron específicamente por su cantidad nativa de categorías de respuesta —no colapsada ni modificada post-hoc—, buscando cubrir el rango más amplio posible de *k* disponible en datos abiertos. Una búsqueda exhaustiva en ese catálogo, complementada con Open Science Framework, Kaggle y candidatos específicos de la literatura psicométrica, no encontró ningún instrumento con exactamente *k*=6 ni *k*=8; estos valores parecen ser genuinamente infrecuentes en la práctica psicométrica publicada (§4, Limitaciones).

**Tabla 1**
*Instrumentos reales usados y su cantidad nativa de categorías de respuesta*

| Instrumento | *k* | Ítems | *N* | Ítems invertidos |
|---|---|---|---|---|
| Escala de Autoestima de Rosenberg (Rosenberg, 1965) | 4 | 10 | 46.546 | {3,5,8,9,10} |
| MACH-IV (Christie y Geis, 1970) | 5 | 20 | 73.486 | {3,4,6,7,9,10,11,14,16,17} |
| HEXACO, faceta Expresividad (Ashton, Lee y Goldberg, 2007) | 7 | 10 | 22.783 | {6,7,8,9,10} |
| Escala de Autoritarismo de Derecha — RWAS (Altemeyer, 1981) | 9 | 22 | 9.680 | {4,6,8,9,11,13,15,18,20,21} |

*Nota.* Las claves de reversión de MACH-IV y RSE se confirmaron contra checkpsych.com/tests/mach-iv/ y Rosenberg (1965), respectivamente; la de HEXACO, contra la clave oficial de puntuación del IPIP (ipip.ori.org/newHEXACO_PI_key.htm), verificada ítem por ítem; la de RWAS, contra la lista de ítems invertidos reportada independientemente en una base de datos de escalas psicológicas (db.arabpsychology.com/scales/right-wing-authoritarianism-scale/), coincidente con la lectura semántica directa del contenido de cada ítem. El puntaje compuesto de cada instrumento se calculó como la suma de sus ítems (con reversión donde correspondía), exigiendo caso completo: un caso solo entra al puntaje total si todos sus ítems tienen respuesta válida en rango.

Los cuatro instrumentos se eligieron conjuntamente para cubrir el rango de *k* más amplio posible disponible en datos abiertos: RSE y MACH-IV cubren el extremo bajo (*k*=4 y *k*=5), mientras que HEXACO y RWAS extienden el rango hacia valores más altos (*k*=7 y *k*=9, respectivamente).

## 2.3. Bloque de niveles: simulación de la severidad de no-normalidad

Cada nivel simula un compuesto de *m*=10 ítems generados a partir de un factor común θ ~ *N*(0,1) con carga factorial λ: cada ítem = λθ + √(1−λ²)ε_j, con ε_j ~ *N*(0,1) iid, discretizado en *k* categorías ordenadas mediante *k*−1 umbrales sobre la variable latente continua; el puntaje compuesto es la suma de los *m* ítems ya discretizados —la misma lógica generativa que un puntaje tipo Likert-suma real—.

La carga factorial λ se trata aquí como un parámetro libre de la calibración, junto con los umbrales, en vez de fijarse a un valor constante. Esta decisión responde a un chequeo de factibilidad previo: fijar λ a un valor constante limita el mecanismo factor-común más umbrales discretizados a combinaciones de asimetría/curtosis platicúrticas o cercanas a la normal; dejando λ libre, el espacio alcanzable se amplía sustancialmente e incluye curtosis positiva, necesaria para reproducir el nivel más extremo del diseño (véase más abajo).

Se definieron cinco niveles ordenados de severidad de no-normalidad, con objetivos de asimetría y curtosis en exceso elegidos para cubrir de forma aproximadamente equiespaciada el rango observado entre instrumentos psicométricos reales, desde una forma cercana a la normal hasta una marcadamente asimétrica y leptocúrtica (Tabla 2).

**Tabla 2**
*Niveles de severidad de no-normalidad y sus objetivos de calibración*

| Nivel | Asimetría objetivo | Curtosis en exceso objetivo |
|---|---|---|
| bajo | 0.00 | −0.70 |
| bajo-moderado | 0.20 | −0.55 |
| moderado | 0.70 | −0.15 |
| alto | 1.00 | 0.40 |
| muy alto | 1.35 | 1.17 |

Para cada combinación de nivel y *k* (7 valores, 3 a 9), λ y los *k*−1 umbrales se calibraron simultáneamente mediante optimización Nelder-Mead multi-arranque (8 puntos de partida por celda, barriendo λ y el corrimiento de los umbrales), minimizando la distancia cuadrática entre los momentos empíricos del compuesto simulado (*N*=150.000 réplicas, números aleatorios comunes reusados en las 35 celdas para evitar que el ruido Monte Carlo contamine las comparaciones entre celdas) y los objetivos de la Tabla 2. Las 35 celdas calibraron con una distancia residual máxima de 3.8 × 10⁻¹¹, prácticamente exacta.

Con los parámetros calibrados, cada celda (nivel × *k*) se simuló de forma independiente sobre la grilla completa de *n*, con *R*=10.000 réplicas por celda (280 celdas: 5 niveles × 7 valores de *k* × 8 tamaños de muestra).

## 2.4. Bloque de datos reales: submuestreo aleatorio *m-out-of-N*

Sobre cada uno de los cuatro instrumentos de la Tabla 1 se aplicó submuestreo aleatorio sin reemplazo tipo *m-out-of-N* (Politis, Romano y Wolf, 1999): para cada tamaño de muestra *n* de la grilla, se extrajeron *R*=10.000 submuestras aleatorias del puntaje compuesto completo del instrumento, y se calculó la tasa de rechazo empírica de cada prueba de normalidad frente al *N* completo del instrumento como población de referencia. El *N* mínimo entre los cuatro instrumentos (RWAS, 9.680) es muy superior al *n* máximo de la grilla (1.500), por lo que el submuestreo sin reemplazo es válido para los cuatro sin necesidad de ajuste.

A diferencia del componente de niveles (§2.3), en este componente la cantidad de categorías de respuesta *k* viene naturalmente confundida con la cantidad de ítems del instrumento y con la asimetría/curtosis real del constructo medido —tal como ocurre siempre en la práctica psicométrica aplicada—; el componente de niveles existe precisamente para poder separar esos factores de forma que el componente de datos reales no puede.

## 2.5. Pruebas de normalidad evaluadas

Se evaluó la siguiente batería de once pruebas de normalidad: Shapiro-Wilk (Shapiro y Wilk, 1965), Anderson-Darling (Anderson y Darling, 1954), Lilliefors (Lilliefors, 1967), Jarque-Bera (Jarque y Bera, 1980), D'Agostino-Pearson (D'Agostino y Pearson, 1973), Cramér-von Mises (Csörgő y Faraway, 1996), Shapiro-Francia (Shapiro y Francia, 1972), χ² de Pearson (Pearson, 1900), la prueba de curtosis de Anscombe-Glynn (Anscombe y Glynn, 1983), Epps-Pulley (basada en la función característica empírica) y el SSTN (Anarat y Schwender, 2026) —una prueba de normalidad reciente basada en la autosimilitud bajo convolución—. Ninguna de las once ocupa un rol protagónico en este estudio: el objeto de estudio es el efecto de *k*, *n* y la severidad de la no-normalidad sobre la potencia comparada de la batería completa, no el desempeño relativo de una prueba en particular.

## 2.6. Implementación y reproducibilidad

Todas las simulaciones y el submuestreo se ejecutaron en R (v4.6.1), sobre la infraestructura de GitHub Actions (*runners* ubuntu-latest, paralelización por celda mediante `strategy: matrix`), con `r-lib/actions/setup-r-dependencies` para el cacheo de dependencias. Ninguna corrida real (extracción de datos, calibración, simulación, submuestreo) se ejecutó en una máquina local: los resultados reportados provienen exclusivamente de corridas archivadas en el repositorio de desarrollo, con historial de commits verificable. El código completo, incluida la configuración exacta de la infraestructura de simulación, está disponible en el repositorio citado en la sección de disponibilidad de datos y código.

---

## Notas para revisión

- Falta decidir si el orden de exposición debe ser primero el bloque de niveles o primero el bloque de datos reales — aquí puse niveles primero (§2.3 antes de §2.4) porque es el componente que aísla el mecanismo; en Resultados podría convenir el orden inverso (mostrar primero el dato real "crudo" y su aparente confusión, y luego el bloque de niveles que la resuelve), replicando el arco narrativo real de cómo se llegó al hallazgo. Pendiente de decidir junto con la estructura de Resultados.
- Falta una figura o tabla que muestre visualmente el mecanismo generativo del bloque de niveles (factor común + ítems + umbrales) — el original de SSTN no tenía figuras, solo tablas; revisar si conviene agregar una acá dado que el mecanismo con λ libre es una novedad metodológica del presente estudio.
- Pendiente: decidir si se incluye el detalle completo de las fórmulas (momentos, parametrización de umbrales `primer_umbral + cumsum(exp(log_gaps))`, transformación `plogis`/`qlogis` de λ) en el cuerpo del Método o se relega a un apéndice/material suplementario.
- Confirmado: se eliminaron todas las referencias a "estudio hermano"/trabajo comparado en el texto del Método (instrumentos reales, calibración de λ, submuestreo m-out-of-N, batería de pruebas) — el paper ahora se sostiene sin depender de mencionar trabajo propio no publicado.
- Confirmado: "remuestreo" reemplazado por "submuestreo aleatorio" en todo el documento.
