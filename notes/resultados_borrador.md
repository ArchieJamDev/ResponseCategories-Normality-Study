# Resultados (borrador v1) — segundo paper

Prosa continua, sin marcado LaTeX de plantilla todavía.

---

## 3.1. Bloque de niveles: efecto de *k*, *n* y severidad de no-normalidad

**Efecto de *k*.** Promediando sobre las 11 pruebas y los ocho tamaños de muestra, la potencia decae de forma aproximadamente monotónica al aumentar *k*, en los cinco niveles de severidad (Tabla 3). La magnitud de esa brecha, sin embargo, no es constante: cae de 0.061 en el nivel más cercano a la normalidad a 0.012 en el nivel más severo —una razón de aproximadamente 5 a 1 entre el extremo bajo y el extremo alto de severidad—.

**Tabla 3**
*Brecha de potencia media entre k=3 y k=9, por nivel de severidad (promediada sobre los 8 tamaños de muestra)*

| Nivel | Asimetría / curtosis objetivo | Brecha *k*=3 − *k*=9 |
|---|---|---|
| bajo | 0.00 / −0.70 | 0.061 |
| bajo-moderado | 0.20 / −0.55 | 0.049 |
| moderado | 0.70 / −0.15 | 0.023 |
| alto | 1.00 / 0.40 | 0.017 |
| muy alto | 1.35 / 1.17 | 0.012 |

**Efecto de *n*.** Promediando sobre los cinco niveles y los siete valores de *k*, la potencia crece monotónicamente con *n*, como es esperable de cualquier prueba consistente: de 0.178 en *n*=10 a 0.983 en *n*=1500 (Tabla 4).

**Tabla 4**
*Potencia media (11 pruebas, 5 niveles, 7 valores de k) por tamaño de muestra*

| *n* | 10 | 25 | 50 | 100 | 250 | 500 | 1000 | 1500 |
|---|---|---|---|---|---|---|---|---|
| Potencia media | 0.178 | 0.352 | 0.515 | 0.655 | 0.845 | 0.957 | 0.979 | 0.983 |

**La interacción de los tres factores.** El hallazgo central del estudio surge de cruzar los dos anteriores: la brecha de potencia entre *k*=3 y *k*=9 no solo se achica al aumentar la severidad de la no-normalidad —como muestra la Tabla 3 de forma agregada—, sino que el tamaño de muestra en el que esa brecha alcanza su punto máximo **se desplaza hacia valores de *n* cada vez más pequeños** a medida que la severidad aumenta (Tabla 5 y Figura 1, `notes/figuras/brecha_k3_k9_por_n_y_nivel.svg`).

**Tabla 5**
*Brecha de potencia entre k=3 y k=9 por nivel de severidad y tamaño de muestra*

| *n* | bajo | bajo-moderado | moderado | alto | muy alto |
|---|---|---|---|---|---|
| 10 | 0.008 | 0.005 | 0.013 | 0.027 | **0.064** |
| 25 | 0.015 | 0.008 | 0.040 | **0.066** | 0.035 |
| 50 | 0.038 | 0.026 | **0.088** | 0.043 | 0.000 |
| 100 | 0.125 | 0.102 | 0.041 | 0.003 | −0.001 |
| 250 | **0.258** | **0.227** | 0.000 | 0.000 | −0.001 |
| 500 | 0.044 | 0.023 | 0.000 | −0.001 | 0.000 |
| 1000 | 0.000 | −0.002 | 0.000 | −0.002 | 0.000 |
| 1500 | 0.000 | 0.000 | 0.000 | −0.003 | 0.000 |

*Nota.* En negrita, el *n* donde la brecha alcanza su máximo dentro de cada nivel.

Para el nivel más cercano a la normalidad (bajo), el efecto de *k* es prácticamente nulo en muestras pequeñas (*n*≤25), crece hasta un máximo en *n*=250, y solo entonces empieza a decaer. Para el nivel más severo (muy alto, calibrado a la asimetría y curtosis de RWAS), el patrón se comprime hacia el extremo opuesto: el efecto ya es visible en *n*=10, alcanza su máximo ahí mismo, y se ha disipado casi por completo hacia *n*=50 —doscientas muestras antes de que el nivel bajo siquiera alcance su propio pico—. Los tres niveles intermedios se ubican, de forma ordenada, entre ambos extremos. En ningún nivel la dirección del efecto se invierte: *k*=3 iguala o supera a *k*=9 en toda la grilla de *n*, salvo diferencias de milésimas atribuibles a ruido Monte Carlo en las celdas donde la brecha ya es prácticamente cero.

## 3.2. Bloque de datos reales: potencia por instrumento

Sobre los seis instrumentos reales, la potencia media (11 pruebas) crece con *n* en los seis casos, como es esperable (Tabla 6). El patrón entre instrumentos no reproduce directamente el orden de *k*: SPS-10 (*k*=6) y RWAS (*k*=9) alcanzan la potencia más alta en n chicos —0.158 y 0.364 en *n*=10, 0.390 y 0.749 en *n*=25 respectivamente—, seguidos de AHS (*k*=8, 0.099 en *n*=10, 0.217 en *n*=25), mientras que RSE (*k*=4), MACH-IV (*k*=5) y HEXACO (*k*=7) se mantienen agrupados entre sí y muy por debajo de los tres anteriores hasta *n*≈250.

**Tabla 6**
*Potencia media (11 pruebas) por instrumento real y tamaño de muestra*

| Instrumento (*k*) | 10 | 25 | 50 | 100 | 250 | 500 | 1000 | 1500 |
|---|---|---|---|---|---|---|---|---|
| RSE (4) | 0.048 | 0.063 | 0.108 | 0.248 | 0.719 | 0.983 | 1.000 | 1.000 |
| MACH-IV (5) | 0.052 | 0.076 | 0.131 | 0.282 | 0.760 | 0.989 | 1.000 | 1.000 |
| SPS-10 (6) | 0.158 | 0.390 | 0.691 | 0.924 | 0.991 | 0.999 | 1.000 | 1.000 |
| HEXACO (7) | 0.049 | 0.068 | 0.104 | 0.212 | 0.644 | 0.967 | 1.000 | 1.000 |
| AHS (8) | 0.099 | 0.217 | 0.434 | 0.750 | 0.919 | 0.929 | 0.961 | — |
| RWAS (9) | 0.364 | 0.749 | 0.928 | 0.954 | 0.984 | 0.998 | 1.000 | 1.000 |

*Nota.* AHS no tiene celda en *n*=1500 porque su *N* nativo (1.036) no alcanza ese tamaño de submuestra sin reemplazo (ver Método).

Este patrón —potencia mayor en los instrumentos de *k* más alto o más bajo-medio pero severidad real más extrema (RWAS, SPS-10, AHS), no menor como predice el bloque de niveles (§3.1)— tiene una explicación cuantificada, no solo cualitativa: los 6 instrumentos reales difieren simultáneamente en *k* y en la asimetría/curtosis real del constructo medido, dos factores que el bloque de niveles mantiene deliberadamente separados. Asignando a cada instrumento su nivel de severidad simulado más cercano (distancia euclidiana en el espacio asimetría/curtosis, usando |asimetría| para no penalizar el signo), RWAS y SPS-10 caen en el nivel más severo (muy alto), AHS en el nivel alto, mientras RSE, MACH-IV y HEXACO caen en los menos severos (bajo y bajo-moderado) — el orden de potencia de la Tabla 6 sigue el orden de severidad real, no el de *k*. El desarrollo completo de este análisis está en §3.3–§3.5.

## 3.3. Validación de la calibración de niveles contra los 6 instrumentos reales

Para cada instrumento real se comparó la potencia observada (Tabla 6) contra la potencia que predice la celda simulada correspondiente (mismo *k*, nivel de severidad más cercano por distancia euclidiana), *n* por *n* (Tabla 6b).

**Tabla 6b**
*Correlación y error absoluto entre potencia real y potencia simulada, por instrumento*

| Instrumento (*k*) | Nivel asignado | Distancia de ajuste | *r* (real vs. simulado) | Error absoluto medio |
|---|---|---|---|---|
| RSE (4) | bajo | 0.008 | 0.9995 | 0.009 |
| MACH-IV (5) | bajo-moderado | 0.141 | 0.933 | 0.142 |
| SPS-10 (6) | muy alto | 0.828 | 0.936 | 0.123 |
| HEXACO (7) | bajo-moderado | 0.012 | 0.999 | 0.014 |
| AHS (8) | alto | 0.247 | 0.909 | 0.155 |
| RWAS (9) | muy alto | 0.002 | 1.000 | 0.003 |

Sobre las 47 celdas combinadas, la correlación global entre potencia real y simulada es *r*=0.945 (diferencia absoluta mediana=0.007). El patrón general de la Sección 11 del Método (a peor ajuste de severidad, peor predicción) se mantiene, pero con SPS-10 **ya no es perfectamente monótono**: SPS-10 tiene la peor distancia de ajuste de los 6 (0.828, sustancialmente peor que el resto porque su curtosis real, 1.986, excede el extremo que calibra el nivel muy alto, 1.17 — extrapolación en la dimensión de curtosis), pero su error de predicción (0.123) es menor que el de MACH-IV (0.142) o AHS (0.155), que ajustan mejor en términos de distancia (correlación de Spearman entre distancia y error con los 6 instrumentos: ρ=0.83, no ρ=1.00 como con el instrumento de *k*=6 evaluado anteriormente). La explicación más plausible es un efecto techo: a una severidad tan extrema, la potencia de casi todas las pruebas ya está cerca de 1 tanto en la simulación como en la realidad, así que el error absoluto queda naturalmente acotado por encima, independientemente de qué tan bien calibrada esté la severidad. El patrón general (peor ajuste → más error, en términos relativos) se sostiene con fuerza pero no es una ley perfecta — matiz importante a reportar, no una contradicción del hallazgo original.

Esto valida la calibración por niveles (λ libre, Método §2.4) como una herramienta predictiva confiable *condicionada* a que la severidad real del constructo esté bien representada en el espacio calibrado — no como una predicción universal. La discusión de las hipótesis específicas puestas a prueba con estos 6 instrumentos (efecto de *k*, modulación por *n*, paridad, comparación de las 11 pruebas) se desarrolla en §3.4 y §3.5.

---

## 3.4. Hipótesis puestas a prueba en datos reales (6 instrumentos, k=4..9)

El bloque de niveles (§3.1) genera hipótesis; esta sección resume qué tanto se pudieron confirmar con los 6 instrumentos reales (RSE k=4, MACH-IV k=5, SPS-10 k=6, HEXACO k=7, AHS k=8, RWAS k=9). Ver `notes/DESIGN.md` Secciones 9-15 para el detalle estadístico completo de cada punto, incluida la sustitución de NFC (descartada por recomendación explícita de la fuente de datos de no combinar sus ítems en un puntaje compuesto) por SPS-10.

**H1 — Menos categorías de respuesta (k) → más potencia.** Confirmada, pero solo donde fue evaluable: únicamente en pares de instrumentos con severidad real equivalente se pudo aislar el efecto de *k* de la severidad real. En el par bajo-moderado (MACH-IV k=5 vs HEXACO k=7) la dirección predicha se confirma, significativa en *n*=50 a *n*=500 (t pareado por prueba, p<.05 en 4 de 8 tamaños de muestra). En el par muy alto (SPS-10 k=6 vs RWAS k=9), la dirección va en contra (SPS-10 muestra MENOS potencia que RWAS en *n*=10-50, p<.001) — pero SPS-10 es, de los 6 instrumentos, el que peor ajusta a su nivel de severidad asignado (distancia=0.828, ver §3.3), así que esta comparación no es limpia y no se interpreta como una refutación genuina de H1. El ANCOVA agregado con los 6 instrumentos (potencia ~ nivel + k) da coeficiente de *k* POSITIVO y significativo en *n*=10-50 (dirección contraria a H1) — pero esto es un artefacto de que, en este conjunto específico de 6 instrumentos, los *k* altos (6, 8, 9) coinciden con las severidades más altas (alto, muy alto) mientras los *k* bajos (4, 5, 7) coinciden con las más bajas (bajo, bajo-moderado): el modelo agregado no aísla nada que la Tabla 6 no muestre ya. **Conclusión**: H1 se sostiene únicamente en el único par bien emparejado en severidad (bajo-moderado); no hay una prueba agregada confiable con solo 6 instrumentos, uno por *k*.

**H2 — El efecto de *k* se modula por *n* (negligible en extremos, pico en n≈50-250).** Confirmada de forma limpia, sin cambios respecto al instrumento de *k*=6 usado. El par MACH-IV/HEXACO reproduce la misma forma de U invertida que predice la simulación: p=.117 (*n*=10) → .222 (*n*=25) → .026\* (*n*=50) → .011\* (*n*=100) → .011\* (*n*=250) → .012\* (*n*=500) → .211 (*n*=1000).

**H3 — La brecha de potencia entre *k* extremos se achica con la severidad real (Tabla 3).** No evaluable como tendencia con los datos reales disponibles: solo hay 2 pares de instrumentos que comparten nivel de severidad (bajo-moderado, muy alto), insuficiente para trazar una curva de brecha vs. severidad. Ni confirmada ni refutada — sigue siendo evidencia exclusivamente simulada.

**H4 — La paridad de *k* (par/impar) afecta la potencia, independiente de su magnitud, controlando severidad.** Con NFC, esto era estructuralmente inestimable (columna `NA` por singularidad exacta). **Con SPS-10, el modelo `potencia ~ nivel + paridad` sí se vuelve técnicamente estimable** —porque SPS-10 (k=6, par) y RWAS (k=9, impar) comparten el mismo nivel muy alto, algo que no ocurría con ningún par de instrumentos con NFC—, con coeficiente negativo (par<impar) significativo en *n*=10, 25, 50 (p<.0001). Pero un análisis de sensibilidad (excluir cada uno de los otros 4 instrumentos, uno a la vez) muestra que el coeficiente es IDÉNTICO en los 5 casos: toda la estimación proviene exclusivamente del contraste SPS-10-vs-RWAS dentro de muy alto, ningún otro instrumento aporta información al término de paridad. No es un test general de paridad — es la misma comparación pareada de H1 (muy alto) disfrazada de ANCOVA, con el mismo problema de fondo (SPS-10 ajusta mal su severidad). **Ni confirmada ni refutada con datos reales** — la única evidencia válida de paridad sigue siendo la simulación, donde el diseño garantiza ortogonalidad entre paridad y severidad.

**H5 — Un instrumento con severidad mal calibrada distorsiona cualquier análisis agregado que lo incluya.** Confirmada, con evidencia de dos instrumentos distintos en dos momentos del estudio: (a) NFC (descartada, ver DESIGN.md §14) tenía la peor distancia de ajuste registrada en este proyecto (0.958); (b) SPS-10, su reemplazo, tiene la segunda peor (0.828, por una razón distinta: su curtosis real, 1.986, excede el extremo que calibra el nivel muy alto, 1.17). En ambos casos, el instrumento de peor ajuste distorsiona cualquier modelo agregado que lo incluya sin aislarlo (ver H1 y H4) — refuerza que la severidad de ajuste (no solo la etiqueta de nivel asignada) debe reportarse y usarse como criterio de inclusión/exclusión en análisis agregados con datos reales, no solo como nota al pie.

## 3.5. Comparación de las 11 pruebas: potencia bruta y estabilidad frente a *k*

Pregunta práctica: ¿qué prueba conviene usar, y bajo qué condiciones? Se calcularon tres versiones comparables de la misma tabla (potencia media + coeficiente de variación de la potencia a través de *k*, como medida de estabilidad):

1. **Simulada limpia** (280 celdas, severidad aislada de *k* por diseño — verificado: la asimetría/curtosis lograda por la calibración varía menos de 10⁻⁵ entre los 7 valores de *k* dentro de cada nivel).
2. **Real** (6 instrumentos, *k* y severidad inevitablemente confundidos).
3. **Simulada confundida** (mismas 6 combinaciones nivel-*k* que los instrumentos reales, impuestas artificialmente sobre datos simulados, para poder comparar 1 y 2 en igualdad de condiciones).

**Tabla 7**
*Ranking combinado (potencia + estabilidad a k) de las 11 pruebas, en los tres escenarios*

| Prueba | Rank sim. limpia | Rank real | Rank sim. confundida | Desplazamiento confundida↔real |
|---|---|---|---|---|
| D'Agostino-Pearson | 3 | 3 | 6 | 3 |
| Epps-Pulley | 8 | 4 | 7 | 3 |
| Shapiro-Wilk | 7 | 5 | 4 | **1** |
| Anderson-Darling | 10 | 9 | 8 | **1** |
| Lilliefors | 17 | 12 | 15 | 3 |
| Shapiro-Francia | 11 | 13 | 10 | 3 |
| Cramér-von Mises | 15 | 14 | 16 | 2 |
| Pearson χ² | 16 | 15 | 13 | 2 |
| SSTN | 12 | 15 | 19 | 4 |
| Jarque-Bera | 11 | 20 | 21 | **1** |
| Curtosis (Anscombe-Glynn) | 22 | 22 | 13 | **9** |

**Lectura para la Discusión:**

- **D'Agostino-Pearson** es la recomendación por defecto: mejor balance potencia/estabilidad en los tres escenarios, de forma consistente — el único hallazgo de esta tabla que se sostuvo igual tanto con NFC como con SPS-10 como instrumento de *k*=6.
- **Shapiro-Wilk** mantiene la potencia bruta más alta ya documentada en la literatura, y con SPS-10 resulta de las más predecibles entre escenarios (desplazamiento=1).
- **SSTN** no compite en potencia bruta (nunca la más potente); su argumento sigue siendo la estabilidad a *k* cuando la severidad está controlada (escenario simulado limpio, 3ra mejor combinada). Su predictibilidad entre escenarios (desplazamiento) **no es un hallazgo robusto**: con NFC era la 2da más predecible; con SPS-10 pasa a un lugar intermedio (desplazamiento=4). No se recomienda usar la predictibilidad de SSTN como argumento en el paper — solo su estabilidad-a-*k* en el escenario limpio, que sí se sostiene.
- **Curtosis (Anscombe-Glynn)** es la más impredecible por un margen amplio (desplazamiento=9) — un artefacto de que, en el emparejamiento confundido, el par muy alto (SPS-10 y RWAS) comparte curtosis alta, dándole a esta prueba en particular una estabilidad aparente que no se sostiene en el resto de la tabla real. Sigue siendo la peor en potencia bruta en el escenario limpio (§13.1) — recomendable solo cuando se sabe de antemano que la desviación es puramente de curtosis.
- **El cambio de NFC a SPS-10 altera notablemente casi todos los rankings de esta tabla** (comparar con la versión anterior de este documento) pese a mantener los otros 5 instrumentos idénticos — la lectura metodológica más robusta de esta sección no es "cuál prueba gana", sino que ese ranking es frágil frente a qué instrumento particular ocupa cada valor de *k*, y por eso la Tabla de §13.1 (simulación limpia, 7 valores de *k* por nivel, no un instrumento por *k*) es el ancla más estable para las recomendaciones del paper.

---

## Notas para revisión

- Confirmado: el "1.000" de la Tabla 6 en n=1000/1500 es potencia esencialmente perfecta (no redondeo de un valor bajo), verificado contra el consolidado.
- Decisión: no se agrega una tabla adicional de prueba x nivel o prueba x n -- la Tabla 7 (§3.5, potencia + estabilidad de las 11 pruebas en los 3 escenarios) ya cubre el desglose por prueba individual con el nivel de detalle necesario para el Resultados; más desglose saturaría la sección.
- Decisión: la Tabla 5 se mantiene como tabla (valores exactos, útil para reproducibilidad) además de la Figura 1 (patrón visual) -- ambas cumplen roles distintos, no son redundantes.
