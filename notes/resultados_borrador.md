# Resultados (borrador v1) — segundo paper

Prosa continua, sin marcado LaTeX de plantilla todavía.

---

## 3.1. Bloque de niveles: efecto de *k*, *n* y severidad de no-normalidad

**Efecto de *k*.** Promediando sobre las 11 pruebas y los ocho tamaños de muestra, la potencia decae al aumentar *k* en los cinco niveles de severidad (Tabla 3), con una excepción real que se explica más abajo. Desde el nivel bajo-moderado en adelante, la brecha decae de forma monótona (0.045→0.036→0.016→0.012) —una razón de aproximadamente 4 a 1 entre bajo-moderado y muy alto—. El nivel bajo (el más cercano a la normalidad en asimetría) queda por debajo de bajo-moderado en vez de ser el máximo: su objetivo de curtosis (−1.28, el percentil 5 de asimetría/curtosis observado en 1.567 distribuciones psicológicas reales; Cain, Zhang y Yuan, 2017) es una desviación de la normalidad no trivial, no un punto cercano a cero en ambas dimensiones.

**Tabla 3**
*Brecha de potencia media entre k=3 y k=9, por nivel de severidad (promediada sobre los 8 tamaños de muestra)*

| Nivel | Percentil (asimetría / curtosis) | Asimetría / curtosis objetivo | Brecha *k*=3 − *k*=9 |
|---|---|---|---|
| bajo | 5º / 5º | 0.053 / −1.28 | 0.027 |
| bajo-moderado | 25º / 25º | 0.276 / −0.57 | 0.045 |
| moderado | 50º / 50º | 0.688 / 0.07 | 0.036 |
| alto | 75º / 75º | 1.332 / 1.62 | 0.016 |
| muy alto | 90º / 90º | 2.401 / 7.52 | 0.012 |

**Efecto de *n*.** Promediando sobre los cinco niveles y los siete valores de *k*, la potencia crece monotónicamente con *n*, como es esperable de cualquier prueba consistente: de 0.238 en *n*=10 a 0.984 en *n*=1500 (Tabla 4).

**Tabla 4**
*Potencia media (11 pruebas, 5 niveles, 7 valores de k) por tamaño de muestra*

| *n* | 10 | 25 | 50 | 100 | 250 | 500 | 1000 | 1500 |
|---|---|---|---|---|---|---|---|---|
| Potencia media | 0.238 | 0.441 | 0.626 | 0.799 | 0.949 | 0.981 | 0.984 | 0.984 |

**La interacción de los tres factores.** La brecha de potencia entre *k*=3 y *k*=9 no solo se achica al aumentar la severidad de la no-normalidad —como muestra la Tabla 3—, sino que el tamaño de muestra en el que esa brecha alcanza su punto máximo **se desplaza hacia valores de *n* cada vez más pequeños** a medida que la severidad aumenta (Tabla 5 y Figura 1, `notes/figuras/brecha_k3_k9_por_n_y_nivel.svg`) — con la misma excepción del nivel bajo que en la Tabla 3.

**Tabla 5**
*Brecha de potencia entre k=3 y k=9 por nivel de severidad y tamaño de muestra*

| *n* | bajo | bajo-moderado | moderado | alto | muy alto |
|---|---|---|---|---|---|
| 10 | 0.015 | 0.008 | 0.014 | 0.055 | **0.099** |
| 25 | 0.056 | 0.017 | 0.046 | **0.066** | −0.001 |
| 50 | **0.097** | 0.051 | **0.117** | 0.011 | −0.001 |
| 100 | 0.050 | **0.149** | 0.105 | −0.001 | −0.001 |
| 250 | 0.000 | 0.132 | 0.002 | −0.002 | 0.000 |
| 500 | 0.000 | 0.006 | 0.000 | 0.000 | 0.000 |
| 1000 | 0.000 | 0.000 | 0.001 | 0.000 | 0.000 |
| 1500 | 0.000 | 0.000 | 0.001 | 0.000 | 0.000 |

*Nota.* En negrita, el *n* donde la brecha alcanza su máximo dentro de cada nivel.

Desde moderado en adelante (moderado→alto→muy alto), el pico se desplaza de forma monótona a *n* cada vez más chico (*n*=50→25→10) y de magnitud cada vez menor, la misma historia que en el diseño original. La excepción es bajo→bajo-moderado: el pico se desplaza en la dirección contraria (de *n*=50 a *n*=100) antes de retomar la tendencia en moderado — refleja la misma particularidad del nivel bajo señalada en la Tabla 3 (su curtosis objetivo, −1.28, no es un punto cercano a la normalidad). En ningún nivel la dirección del efecto de *k* se invierte de forma sostenida: *k*=3 iguala o supera a *k*=9 en la enorme mayoría de la grilla, salvo diferencias de milésimas (ruido Monte Carlo) en celdas donde la brecha ya es prácticamente cero.

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

Este patrón —potencia mayor en los instrumentos de severidad real más extrema (RWAS, SPS-10, AHS), no en un orden simple de *k*— tiene una explicación cuantificada, no solo cualitativa: los 6 instrumentos reales difieren simultáneamente en *k* y en la asimetría/curtosis real del constructo medido, dos factores que el bloque de niveles mantiene deliberadamente separados. Asignando a cada instrumento su nivel de severidad simulado más cercano (distancia euclidiana en el espacio asimetría/curtosis, usando |asimetría| para no penalizar el signo, sobre los niveles anclados a percentiles de Cain et al., 2017 — ver Tabla 3), RSE, MACH-IV y HEXACO caen en bajo-moderado; SPS-10 y RWAS caen en alto; AHS cae en moderado — el orden de potencia de la Tabla 6 sigue de cerca el orden de severidad real, no el de *k*. El desarrollo completo de este análisis está en §3.3–§3.5.

## 3.3. Validación de la calibración de niveles contra los 6 instrumentos reales

Para cada instrumento real se comparó la potencia observada (Tabla 6) contra la potencia que predice la celda simulada correspondiente (mismo *k*, nivel de severidad más cercano por distancia euclidiana), *n* por *n* (Tabla 6b).

**Tabla 6b**
*Correlación y error absoluto entre potencia real y potencia simulada, por instrumento*

| Instrumento (*k*) | Nivel asignado | Distancia de ajuste | *r* (real vs. simulado) | Error absoluto medio |
|---|---|---|---|---|
| RSE (4) | bajo-moderado | 0.299 | 0.986 | 0.058 |
| MACH-IV (5) | bajo-moderado | 0.162 | 0.999 | 0.015 |
| SPS-10 (6) | alto | 0.387 | 0.957 | 0.092 |
| HEXACO (7) | bajo-moderado | 0.066 | 0.994 | 0.034 |
| AHS (8) | moderado | 0.273 | 0.999 | 0.021 |
| RWAS (9) | alto | 0.450 | 0.995 | 0.027 |

Sobre las 47 celdas combinadas, la correlación global entre potencia real y simulada es *r*=0.981 (mediana de diferencia absoluta muy baja). Un punto notable: estos niveles ya no están anclados a instrumentos propios del estudio (a diferencia de una versión anterior del diseño, donde los niveles se calibraban cerca de RSE y RWAS) — son niveles genuinamente independientes, anclados a percentiles de una fuente externa (Cain et al., 2017). Que la validación se sostenga igual de fuerte (r=0.981, incluso mejor que en la versión anterior) bajo esta condición más exigente es una confirmación más sólida de la calibración por niveles que la que ofrecía el diseño original.

La relación entre distancia de ajuste y error de predicción es positiva pero moderada (Spearman ρ=0.37) — más débil que en versiones anteriores del diseño, donde la distancia predecía casi perfectamente el error. Con niveles independientes, la predicción se mantiene fuerte (r≥0.957 en los 6 instrumentos) sin importar tanto la distancia exacta dentro del rango observado (0.066–0.450) — sugiere que, dentro de ese rango, la calibración por niveles generaliza razonablemente bien incluso sin un ajuste casi perfecto.

Esto valida la calibración por niveles (λ libre, Método §2.4) como una herramienta predictiva confiable, ahora demostrada de forma no circular. La discusión de las hipótesis específicas puestas a prueba con estos 6 instrumentos (efecto de *k*, modulación por *n*, paridad, comparación de las 11 pruebas) se desarrolla en §3.4 y §3.5.

---

## 3.4. Hipótesis puestas a prueba en datos reales (6 instrumentos, k=4..9)

El bloque de niveles (§3.1) genera hipótesis; esta sección resume qué tanto se pudieron confirmar con los 6 instrumentos reales (RSE k=4, MACH-IV k=5, SPS-10 k=6, HEXACO k=7, AHS k=8, RWAS k=9). Ver `notes/DESIGN.md` Secciones 9-15 para el detalle estadístico completo de cada punto, incluido el proceso de selección del instrumento de *k*=6.

**H1 — Menos categorías de respuesta (k) → más potencia.** Confirmada direccionalmente, pero solo donde fue evaluable. Con los niveles recalibrados (Tabla 3), la asignación de severidad agrupa 3 instrumentos en bajo-moderado (RSE k=4, MACH-IV k=5, HEXACO k=7) y 2 en alto (SPS-10 k=6, RWAS k=9) — una estructura más rica que un solo par. Dentro de bajo-moderado, la regresión de potencia sobre *k* (11 pruebas como pseudo-réplicas) da coeficiente **negativo** (dirección de H1) en 5 de 8 tamaños de muestra (*n*=50, 100, 250, 500, 1000), sin alcanzar significancia individual (3 instrumentos, 1 grado de libertad para *k*, poca potencia estadística). Dentro de alto (SPS-10 vs. RWAS), la dirección se invierte y es significativa en *n*=10, 25, 50 (p<.001) — pero SPS-10 es, de los 6 instrumentos, el segundo peor ajustado a su nivel de severidad (distancia=0.387, ver §3.3), así que esta comparación no es limpia y no se interpreta como una refutación genuina de H1. **Conclusión**: H1 se sostiene direccionalmente en el grupo mejor emparejado (bajo-moderado) y se contradice en el grupo que incluye al instrumento peor ajustado (alto) — mismo patrón cualitativo bajo dos calibraciones distintas de los niveles, lo que fortalece la atribución del problema a SPS-10 específicamente, no a un artefacto de la calibración.

**H2 — El efecto de *k* se modula por *n* (negligible en extremos, pico en n≈50-250).** Confirmada de forma limpia. El grupo bajo-moderado (RSE, MACH-IV, HEXACO) reproduce la misma forma de U invertida que predice la simulación: coeficiente de *k* cercano a cero y no significativo en *n*=10, 25 (p=.99, .92), más negativo en *n*=100–500 (p mínimo=.068 en *n*=500), diluyéndose de nuevo hacia *n*=1000–1500.

**H3 — La brecha de potencia entre *k* extremos se achica con la severidad real (Tabla 3).** No evaluable como tendencia con los datos reales disponibles: aunque ahora hay 3 niveles de severidad ocupados por al menos un instrumento (bajo-moderado, moderado, alto), moderado solo tiene un instrumento (AHS), insuficiente para trazar una curva de brecha vs. severidad con múltiples *k* por nivel salvo en bajo-moderado. Ni confirmada ni refutada — sigue siendo evidencia mayormente simulada.

**H4 — La paridad de *k* (par/impar) afecta la potencia, independiente de su magnitud, controlando severidad.** Con la calibración final, tanto bajo-moderado (2 impar: MACH-IV, HEXACO; 1 par: RSE) como alto (1 par: SPS-10; 1 impar: RWAS) mezclan ambas paridades — el modelo `potencia ~ nivel + paridad` es estimable de forma genuina, no por un solo contraste disfrazado. Da coeficiente negativo (par<impar) significativo en *n*=10, 25, 50 (p≤.01), se diluye desde *n*=100. Pero un análisis de sensibilidad (excluir cada instrumento, uno a la vez, en *n*=25) muestra que excluir *cualquiera* de los dos miembros del par alto (SPS-10 o RWAS) elimina la significancia por completo (coef≈−0.009, p>.75), mientras excluir cualquiera de los tres de bajo-moderado la mantiene o incluso la fortalece (excluir RSE la duplica: coef=−0.359, p<.0001). **Conclusión**: el efecto sigue dependiendo críticamente del par alto (con SPS-10, el instrumento peor ajustado, de por medio) — no es una evidencia robusta de paridad general, aunque ya no es un artefacto matemático puro como con la calibración anterior. La evidencia más confiable de paridad sigue siendo la simulación, donde el diseño garantiza ortogonalidad entre paridad y severidad.

**H5 — Un instrumento con severidad mal calibrada distorsiona cualquier análisis agregado que lo incluya.** Confirmada, con evidencia acumulada en varios momentos del estudio (ver DESIGN.md §14-17): un candidato de *k*=6 se descartó por razones de confiabilidad (no de severidad); SPS-10, el instrumento finalmente usado, tiene la segunda peor distancia de ajuste de los 6 (0.387) bajo la calibración final, y es sistemáticamente el que produce direcciones contrarias a H1 en cualquier nivel donde caiga (antes en muy alto con la calibración intermedia, ahora en alto con la calibración final) — refuerza que la severidad de ajuste de cada instrumento debe reportarse y considerarse al interpretar cualquier análisis agregado con datos reales, no solo como nota al pie.

## 3.5. Comparación de las 11 pruebas: potencia bruta y estabilidad frente a *k*

Pregunta práctica: ¿qué prueba conviene usar, y bajo qué condiciones? Se calcularon tres versiones comparables de la misma tabla (potencia media + coeficiente de variación de la potencia a través de *k*, como medida de estabilidad):

1. **Simulada limpia** (280 celdas, severidad aislada de *k* por diseño — verificado: la asimetría/curtosis lograda por la calibración varía menos de 10⁻⁵ entre los 7 valores de *k* dentro de cada nivel).
2. **Real** (6 instrumentos, *k* y severidad inevitablemente confundidos).
3. **Simulada confundida** (mismas 6 combinaciones nivel-*k* que los instrumentos reales, impuestas artificialmente sobre datos simulados, para poder comparar 1 y 2 en igualdad de condiciones).

**Tabla 7**
*Ranking combinado (potencia + estabilidad a k) de las 11 pruebas, en los tres escenarios*

| Prueba | Rank sim. limpia | Rank real | Rank sim. confundida | Desplazamiento confundida↔real |
|---|---|---|---|---|
| D'Agostino-Pearson | 3 | 3 | 3 | **0** |
| Epps-Pulley | 9 | 4 | 4 | **0** |
| Shapiro-Wilk | 7 | 5 | 5 | **0** |
| Anderson-Darling | 10 | 9 | 9 | **0** |
| Jarque-Bera | 11 | 20 | 20 | **0** |
| Curtosis (Anscombe-Glynn) | 22 | 22 | 22 | **0** |
| Shapiro-Francia | 10 | 13 | 12 | 1 |
| Cramér-von Mises | 14 | 14 | 15 | 1 |
| Lilliefors | 17 | 12 | 13 | 1 |
| SSTN | 10 | 15 | 17 | 2 |
| Pearson χ² | 19 | 15 | 12 | 3 |

**Lectura para la Discusión:**

- **D'Agostino-Pearson** es la recomendación por defecto: mejor potencia/estabilidad combinada en los tres escenarios, de forma consistente en las tres versiones de este estudio (con el primer candidato de *k*=6, con SPS-10 antes de recalibrar los niveles, y ahora con los niveles anclados a Cain et al.) — el hallazgo más robusto de toda la comparación.
- **Desplazamiento cero en 6 de las 11 pruebas** (D'Agostino-Pearson, Epps-Pulley, Shapiro-Wilk, Anderson-Darling, Jarque-Bera, Curtosis) es una mejora sustancial respecto a versiones anteriores del estudio (donde como máximo 1 prueba lograba desplazamiento cero) — refleja que, una vez corregida la degeneración del nivel muy alto (ver DESIGN.md §17), la correspondencia entre el escenario simulado-confundido y el real es mucho más fiel.
- **SSTN** no compite en potencia bruta (nunca la más potente); su argumento sigue siendo la estabilidad a *k* cuando la severidad está controlada (escenario simulado limpio, 8vo lugar combinado). Su desplazamiento (2) es intermedio — ni de las más predecibles ni de las menos.
- **Curtosis (Anscombe-Glynn)** tiene desplazamiento cero pero es consistentemente la peor en potencia bruta en los tres escenarios (rank 22 en real y sim. confundida) — recomendable solo cuando se sabe de antemano que la desviación es puramente de curtosis, no de asimetría.
- A diferencia de versiones anteriores del estudio, donde el ranking de "cuál prueba es mejor" resultaba frágil frente a qué instrumento ocupaba *k*=6, con la calibración final la correspondencia real-simulado es mucho más estable — sostiene con más fuerza que antes el uso de la Tabla de §13.1 (simulación limpia) como referencia primaria, ahora corroborada de cerca por el escenario confundido y por los datos reales.

---

## Notas para revisión

- Confirmado: el "1.000" de la Tabla 6 en n=1000/1500 es potencia esencialmente perfecta (no redondeo de un valor bajo), verificado contra el consolidado.
- Decisión: no se agrega una tabla adicional de prueba x nivel o prueba x n -- la Tabla 7 (§3.5, potencia + estabilidad de las 11 pruebas en los 3 escenarios) ya cubre el desglose por prueba individual con el nivel de detalle necesario para el Resultados; más desglose saturaría la sección.
- Decisión: la Tabla 5 se mantiene como tabla (valores exactos, útil para reproducibilidad) además de la Figura 1 (patrón visual) -- ambas cumplen roles distintos, no son redundantes.
