# DESIGN.md -- ResponseCategories-Normality-Study

Registro de decisiones metodológicas, en orden cronológico.

## 1. Origen del proyecto (22 sep 2026)

Este proyecto nace de un hallazgo secundario de SSTN-Normality-Study (Bloque 5 ampliado: 12 escenarios simulados x k=3..8, ver ese repo, `notes/DESIGN.md`): la potencia de las 11 pruebas de normalidad evaluadas frente a la cantidad de categorías de respuesta k del instrumento simulado (a) depende en su mayoría de la CANTIDAD de categorías dentro de una misma paridad (no de la paridad par/impar en sí, salvo para SSTN, Jarque-Bera, D'Agostino-Pearson y curtosis, que son robustas a ambos), y (b) esa dependencia está fuertemente modulada por n: negligible en n=10, pico en n≈100-250, casi desaparece en n≥1000.

Decisión: separar esto en un artículo independiente en vez de agregarlo como una sexta sección al manuscrito de SSTN-Normality-Study (que ya está en revisión mayor en Psicothema y convergiendo) -- la pregunta de fondo ("¿cómo interactúan diseño del instrumento y tamaño de muestra en la potencia de CUALQUIER prueba de normalidad?") es distinta a la de ese paper ("¿cómo se compara SSTN contra las clásicas?") y generalizable más allá de SSTN.

Título de trabajo (actualizado 23 sep 2026, tercera revisión): "Cuándo importa la cantidad de categorías de respuesta: un estudio Monte Carlo y de puntaje compuesto de su interacción con el tamaño de muestra y la severidad de la no-normalidad en 11 pruebas".

## 2. Por qué un bloque de datos reales, y por qué estos 4 (22 sep 2026)

El Bloque 5 original (simulado) usa un factor común + m=10 ítems + umbrales calibrados a asimetría/curtosis reales -- pero el instrumento en sí es 100% sintético. Para verificar que el patrón hallado no es un artefacto puro de la simulación, se busca un ancla a datos reales genuinos: instrumentos reales publicados, con su cantidad NATIVA de categorías de respuesta (no colapsada post-hoc), cubriendo el rango más amplio posible de k.

Los 4 datasets ya usados en SSTN-Normality-Study (DASS, RIASEC, MACH-IV, RSE) solo cubren k=4 (DASS, RSE) y k=5 (RIASEC, MACH-IV) -- insuficiente para replicar el rango k=3..8 del diseño simulado. Se buscó explícitamente en openpsychometrics.org (mismo repositorio ya usado, mismo criterio de calidad de datos) instrumentos con k en los extremos:

- **k=6 y k=8**: búsqueda exhaustiva (openpsychometrics.org completo, ~20 datasets candidatos revisados vía codebook.txt real, más OSF/Kaggle/candidatos específicos de la literatura como Need for Cognition) -- NO se encontró ningún dataset real abierto con exactamente k=6 ni k=8. Parecen ser valores genuinamente raros en la práctica psicométrica publicada (las escalas reales se agrupan en 4, 5, 7, 9 o formatos de 100 puntos). Se documenta como limitación del diseño, no como omisión.
- **k=7**: encontrado -- HEXACO (IPIP HEXACO equivalent scales), escala de 7 puntos confirmada en su codebook.txt real ("1 = strongly disagree" ... "7 = strongly agree"). Se usa un solo facet (X:Expr -- Expresividad, 10 ítems) en vez del instrumento completo (240 ítems, 6 dominios), para mantener un tamaño de subescala comparable a los otros 3 datasets.
- **k=9**: encontrado -- RWAS (Right-Wing Authoritarianism Scale), escala de 9 puntos confirmada en el HTML real del test interactivo (value 1-9, "very strongly disagree" ... "feel neutral" ... "very strongly agree"). Excede el rango simulado (k=3..8) -- decisión explícita del usuario (22 sep 2026): se usa igual como extremo real genuino, documentando en el paper que esa comparación específica es extrapolación del patrón simulado, no interpolación dentro del rango ya cubierto.

No se consideró viable colapsar categorías post-hoc sobre los datasets ya usados en SSTN-Normality-Study (ej. RIASEC k=5 -> k=3) como sustituto: fusionar categorías después de la recolección no es equivalente a que el respondiente haya elegido con menos opciones desde el inicio (limitación ya identificada y descartada en la conversación de diseño de este proyecto, antes de decidir buscar datasets con k nativo distinto en su lugar).

## 3. Claves de puntuación verificadas (22 sep 2026)

Ver comentario completo en `R/01_extract_real_subscales.R`. Resumen:

| Dataset | k | Ítems | Invertidos | Fuente de verificación |
|---|---|---|---|---|
| RSE | 4 | 10 | {3,5,8,9,10} | Rosenberg 1965 (misma clave que SSTN-Normality-Study) |
| MACH-IV | 5 | 20 | {3,4,6,7,9,10,11,14,16,17} | checkpsych.com/tests/mach-iv/ (misma clave que SSTN-Normality-Study) |
| HEXACO X:Expr | 7 | 10 | {6,7,8,9,10} | ipip.ori.org/newHEXACO_PI_key.htm -- match exacto palabra por palabra contra XExpr1..XExpr10 del codebook.txt real |
| RWAS | 9 | 22 | {4,6,8,9,11,13,15,18,20,21} | db.arabpsychology.com/scales/right-wing-authoritarianism-scale/ -- misma lista de items invertidos que la lectura semántica independiente del contenido de cada item |

## 4. Formato de archivo no uniforme entre los 4 zips (22 sep 2026)

A diferencia de SSTN-Normality-Study (los 4 zips de ese proyecto son TSV pese a la extensión .csv), en este proyecto **RWAS viene delimitado por COMA**, no por TAB -- único caso distinto encontrado hasta ahora en el catálogo de openpsychometrics.org. Confirmado con `head -1 data.csv | awk -F',' '{print NF}'` antes de escribir `R/01_extract_real_subscales.R`. RSE, MACH-IV y HEXACO sí son TSV, igual que en el proyecto hermano.

## 5. Grilla de n y método de submuestreo (22 sep 2026; actualizado 25 sep 2026 tras agregar SPS-10 y AHS -- ver Secciones 10, 11 y 14)

Se usa la MISMA grilla de n que el Bloque 5 simulado de SSTN-Normality-Study -- {10,25,50,100,250,500,1000,1500} -- para que la comparación entre el hallazgo simulado y su contraparte real sea directa, celda por celda de n, no solo cualitativa. El N mínimo de los 4 datasets originales (RWAS, 9.680) es muy superior al n máximo del grid (1.500), así que el submuestreo sin reemplazo (mismo método "m-out-of-N" del Bloque 4 de SSTN-Normality-Study) es válido para los 4 sin ajuste.

Con los 6 datasets finales (RSE k=4, MACH-IV k=5, SPS-10 k=6, HEXACO k=7, AHS k=8, RWAS k=9), 5 de 6 siguen usando el grid completo -- el N mínimo entre esos 5 (RWAS, 9.680) sigue siendo muy superior a 1.500, con margen amplio para los 5 (SPS-10, en particular, tiene N=91.658, el más alto de los 6). La excepción es **AHS (k=8, N=1.036)**: no alcanza el n máximo de 1.500, así que corre con un grid reducido {10,25,50,100,250,500,1000} -- una asimetría explícita en el diseño, no un dato faltante (ver Sección 11).

## 6. Bloque de niveles: separar el efecto de k/n/paridad de la forma real de la distribución (22 sep 2026)

Al correr el bloque real (Sección 5), surgió un problema de interpretación: RWAS (k=9) domina la potencia sobre los otros 3 datasets no necesariamente por su k, sino porque su asimetría real (1.35) es mucho más fuerte que la de RSE/MACH-IV/HEXACO (entre -0.16 y 0.21) -- k y la forma real del constructo están confundidos en datos reales, y ni siquiera igualar la cantidad de ítems (par RSE k=4 vs HEXACO k=7, ambos m=10) aísla el efecto limpiamente (ver comparación en la conversación de diseño: Shapiro-Wilk y Pearson χ² se invierten respecto a la dirección esperada).

**Decisión**: no forzar una narrativa de "la simulación dice X, el dato real lo confirma/contradice" -- en vez de eso, agregar un bloque de simulación nuevo que aísle explícitamente el efecto de la FORMA de la distribución (asimetría, curtosis), separado de k/n/paridad, para poder decir con evidencia cuánta de la variación observada en el bloque real viene de cada factor.

**Diseño**: 5 niveles ordenados en un solo eje (no una grilla 2D completa asimetría×curtosis, que generaría demasiadas celdas no interpretables), de "casi normal" a "muy asimétrica y leptocúrtica", anclados cerca de la variación real ya observada entre los 12 escenarios de SSTN-Normality-Study y los 4 datasets de este proyecto:

| Nivel | Asimetría objetivo | Curtosis exceso objetivo | Ancla aproximada |
|---|---|---|---|
| bajo | 0.0 | -0.70 | RSE / C9_rse_total |
| bajo_moderado | 0.2 | -0.55 | HEXACO / C6_riasec_enterprising |
| moderado | 0.7 | -0.15 | B1_riasec_realistic |
| alto | 1.0 | 0.40 | punto nuevo, intermedio |
| muy_alto | 1.35 | 1.17 | RWAS |

Cada nivel se calibra y simula en k=3..9 (7 valores, extendido un paso más allá del Bloque 5 de SSTN-Normality-Study para cubrir el k nativo de RWAS) x el mismo grid de n del resto del proyecto -- 5 x 7 = 35 celdas.

**ACTUALIZACIÓN (25 sep 2026): los objetivos de asimetría/curtosis de esta tabla se recalibraron a una fuente empírica publicada -- ver Sección 16.** Esta sección se mantiene como registro histórico del diseño original (anclado a instrumentos propios del estudio, sin respaldo externo citable).

## 7. Por qué lambda libre, no fija en 0.8 (22 sep 2026)

El diseño original de Bloque 5 (SSTN-Normality-Study) fija la carga factorial lambda=0.8 y solo calibra los umbrales -- por eso los 12 escenarios ya calibrados son TODOS platicúrticos (curtosis exceso entre -0.15 y -1.15): con lambda fija, el mecanismo factor-común + umbrales discretizados tiende estructuralmente hacia formas platicúrticas o casi-normales.

Un chequeo de factibilidad (grilla de lambda de 0.1 a 0.95 x umbrales centrados/corridos, N=80.000 réplicas por combinación, sin calibrar -- solo explorar el espacio alcanzable) confirmó que dejando lambda como parámetro LIBRE de la optimización (no fijo), el mecanismo sí alcanza curtosis positiva: con lambda chico (0.10-0.20) y umbrales corridos hacia un extremo, se alcanzan combinaciones como asimetría=1.18, curtosis exceso=1.58 -- en el vecindario del objetivo de RWAS (asimetría=1.35, curtosis exceso=1.17). Rango alcanzado en la grilla completa: asimetría de -9.8 a 9.7, curtosis exceso de -1.5 a 120 (con `lambda` chico y umbrales muy corridos se puede llegar a curtosis extrema, no solo positiva moderada).

Por eso `R/03_calibrar_niveles.R` optimiza sobre (lambda, umbrales) conjuntamente -- vía `plogis()`/`qlogis()` para mantener lambda en (0,1) sin restringir el optimizador -- en vez de reusar el mecanismo de lambda fija de SSTN-Normality-Study. Mismo método de resto (números aleatorios comunes, Nelder-Mead multi-arranque, N=150.000, semilla 20260922).

## 8. Restricción de integridad de investigación (22 sep 2026)

Mismo criterio no negociable que SSTN-Normality-Study: ningún resultado se fabrica ni se estima. Toda corrida real (extracción, submuestreo, batería de 11 pruebas) pasa por GitHub Actions -- nada se corre localmente. La extracción de los 4 datasets sí se corrió una vez localmente como chequeo de sintaxis (confirmar que el script no truena y que los N/momentos resultantes son plausibles), pero ese resultado NO se usa como dato del estudio -- el dato real sale de la corrida de `correr_extraccion` en Actions.

## 9. Hallazgo central: el efecto de k se achica cuanto más extrema es la desviación real de la normalidad (22 sep 2026)

Con las 35 celdas del bloque de niveles (Sección 6) completas, se puede responder la pregunta que motivó el bloque: ¿el efecto de k observado en el Bloque 5 original (calibrado a una asimetría real moderada, tipo B1_riasec_realistic) se sostiene igual cuando la distribución real es mucho más extrema (tipo RWAS)?

Brecha de potencia media (11 pruebas, promediada sobre n) entre k=3 y k=9, por nivel:

| Nivel | Asimetría / curtosis objetivo | Brecha k3−k9 |
|---|---|---|
| bajo | 0.0 / -0.70 | 0.061 |
| bajo_moderado | 0.2 / -0.55 | 0.049 |
| moderado | 0.7 / -0.15 | 0.023 |
| alto | 1.0 / 0.40 | 0.017 |
| muy_alto | 1.35 / 1.17 | 0.012 |

**La dirección del efecto es consistente en los 5 niveles** (siempre k=3 > k=9, menos categorías → más potencia, mismo signo que en el Bloque 5 original) -- no se invierte en ningún nivel. Pero **la magnitud decae monotónicamente** a medida que la distribución real se aleja más de la normalidad: en el nivel más extremo (muy_alto, tipo RWAS) el efecto de k es aproximadamente una quinta parte del que se observa cerca de la normalidad (nivel bajo).

**Esto resuelve, sin necesidad de una reformulación narrativa, la aparente contradicción encontrada antes con el bloque real** (Sección 5): ahí RWAS (k=9) mostraba MÁS potencia que RSE/MACH-IV/HEXACO (k=4,5,7), lo que a primera vista parecía contradecir "menos k → más potencia". La explicación no es que k=9 sea mejor -- es que con una asimetría/curtosis real tan fuerte como la de RWAS, la potencia ya está cerca del techo (~0.88 en la simulación del nivel muy_alto) para CUALQUIER k, así que la elección de k casi no importa ahí. En instrumentos con desviaciones más sutiles de la normalidad (como RSE), en cambio, k sí importa proporcionalmente más. No son dos hallazgos en tensión -- es una interacción de tres vías (k × n × severidad de la no-normalidad real) que el bloque de niveles aísla explícitamente.

Implicación práctica para el paper: el efecto de k sobre la potencia de las pruebas de normalidad no es una propiedad fija del diseño del instrumento -- depende de qué tan cerca de la normalidad está el constructo que se está midiendo. Es más consecuente para constructos con desviaciones sutiles (la mayoría de la práctica psicométrica aplicada) que para constructos con desviaciones extremas y obvias.

**ACTUALIZACIÓN (26 sep 2026): la tabla y los niveles de esta sección son los del diseño original (anclados a instrumentos propios) -- ver Sección 18 para los valores recalculados con los niveles anclados a Cain et al. (2017).** La dirección del hallazgo se sostiene, pero la magnitud ya NO decae de forma perfectamente monótona en los 5 niveles (hay una excepción real en el nivel "bajo", ver Sección 18 y Tabla 3 de `notes/resultados_borrador.md`) -- esta sección se mantiene como registro histórico del hallazgo original.

## 10. Búsqueda de un instrumento real con k=6 (23-25 sep 2026)

La Sección 2 documentó la ausencia de datasets abiertos con k=6 o k=8 tras una búsqueda en openpsychometrics.org, OSF, Kaggle y candidatos específicos de la literatura. Antes de dar la limitación por cerrada, se hizo una segunda búsqueda más intensiva, extendida a repositorios institucionales de ciencias sociales y con la colaboración directa del usuario. Un primer candidato encontrado en esa búsqueda se descartó tras verificación (ver Sección 14 para el criterio de descarte); el instrumento finalmente usado es SPS-10 (Sección 15).

## 11. Hallazgo posterior de un instrumento real con k=8: Adult Hope Scale / OSF (24 sep 2026)

Siguiendo la misma búsqueda intensiva de la Sección 10, el usuario aportó 5 enlaces de OSF con instrumentos de esperanza/bienestar. De esos, 3 datasets independientes usaban la Adult Hope Scale (Snyder et al., 1991/1994) en su escala original de 8 puntos, confirmando los 8 niveles de respuesta en los datos crudos:

| Dataset OSF | N | Población |
|---|---|---|
| xwcu8 (Torales, "Felicidad, Esperanza y Resiliencia") | 591 | Población general |
| db3h7 ("Sexual Orientation Concealment...") | 409 | Solo hombres gay/bisexuales |
| 2anvx ("Chronic Disease Longitudinal Study", T1-T5) | 1.036 (ola T1) | Pacientes con enfermedad crónica |

Se evaluó combinar los 3 en un solo dataset (mismo instrumento exacto, mismos ítems, N combinado = 2.036, suficiente para el grid completo hasta n=1.500) -- pero un ANOVA de un factor sobre el puntaje total mostró diferencia significativa entre las 3 poblaciones (F(2,2033)=48.44, p<.001, η²=.045; medias 50.18/43.88/48.50 respectivamente). Combinar población general, hombres gay/bisexuales y pacientes crónicos bajo una sola etiqueta de "k=8" habría violado el supuesto del submuestreo m-out-of-N de que el N completo representa UNA sola población de referencia -- mismo criterio ya aplicado antes para descartar un candidato de k=6 restringido a un solo sexo (ver conversación de diseño, no registrada en este archivo por no haberse concretado como dataset).

**Decisión**: usar solo 2anvx (N=1.036, el de mayor N y sin restricción demográfica explícita más allá del diagnóstico crónico), solo su ola T1 (línea base, para no introducir dependencia intra-sujeto con T2-T5 del mismo dataset). Como N=1.036 < 1.500, este dataset usa el grid de n reducido documentado en la Sección 5.

Con esto, la Sección 2 queda parcialmente obsoleta: la ausencia de instrumentos reales con k=6 y k=8 NO era total, sino un límite de la búsqueda original -- se mantiene como registro histórico de esa etapa, pero el diseño final del estudio (6 instrumentos, k=4..9) no tiene esa laguna.

## 12. La cantidad de ítems real (8-22) no distorsiona sistemáticamente la validación real-vs-simulada, una vez controlada la severidad (24 sep 2026)

La simulación de niveles (Sección 6) usa siempre m=10 ítems fijos (`R/04_simulacion_niveles.R`, `m_items <- 10L`), independientemente del nivel o k. Los 6 instrumentos reales varían bastante en cantidad de ítems: RSE=10, MACH-IV=20, SPS-10=10, HEXACO X:Expr=10, AHS=8, RWAS=22. Esto es una fuente de confusión candidata adicional a la severidad real (Sección 9): un compuesto de más ítems tiende a una forma más suave por el Teorema Central del Límite, independientemente de k.

**Chequeo de robustez** (1000 subconjuntos aleatorios de 10 ítems, sin selección por calidad psicométrica para no introducir un sesgo de selección nuevo) sobre los 2 instrumentos con más de 10 ítems:

| | MACH-IV (m=20) | RWAS (m=22) |
|---|---|---|
| α con todos los ítems | 0.888 | 0.964 |
| α medio de subconjuntos de 10 | 0.797 | 0.924 |
| skew con todos los ítems / medio de subconjuntos | -0.164 / -0.179 | 1.352 / 1.331 |
| kurt_exc con todos los ítems / medio de subconjuntos | -0.686 / -0.649 | 1.170 / 1.137 |

La FORMA del compuesto (asimetría, curtosis) se mantiene estable entre el compuesto completo y el promedio de subconjuntos de 10 ítems en ambos casos -- la confiabilidad sí cae con menos ítems (esperado por Spearman-Brown), más en MACH-IV (escala multifacética) que en RWAS (escala muy homogénea), pero eso es un hecho psicométrico esperado, no evidencia de que la forma del compuesto esté distorsionada por tener más ítems que la simulación.

**Prueba cuantitativa directa** (¿los datasets con más ítems predicen sistemáticamente mejor la potencia real, más allá de lo que ya explica el ajuste de severidad?): usando los 6 instrumentos como unidad de análisis (`m_items`, `dist_severidad` y el error absoluto medio real-vs-simulado de §3.3 del Resultados).

**ACTUALIZACIÓN (26 sep 2026): recalculado con las distancias de severidad de la calibración final (Sección 18), que ya no son las mismas que cuando se hizo este análisis por primera vez** (los niveles ya no están anclados a instrumentos propios, así que ninguna distancia es artificialmente cercana a cero):

```
                dist_severidad  dif_abs_media  m_items
rse_k4          0.299           0.058          10
mach_k5         0.162           0.015          20
sps_k6          0.387           0.092          10
hexaco_k7       0.066           0.034          10
ahs_k8          0.273           0.021          8
rwas_k9         0.450           0.027          22
```

Regresión múltiple `error_abs ~ dist_severidad + m_items` (N=6, 3 gl residuales):

```
dist_severidad:  coef=0.109,  p=.307  (ya no significativo)
m_items:         coef=-0.0028, p=.277  (tampoco significativo)
modelo completo: F=1.32, p=.388
```

**Conclusión actualizada**: con las distancias no circulares, NI la severidad de ajuste NI la cantidad de ítems alcanzan significancia individual en esta regresión de 6 puntos -- el mensaje central se mantiene (no hay evidencia de que la cantidad de ítems distorsione sistemáticamente la validación), pero ahora es un resultado de potencia baja en ambos predictores, no una demostración limpia de que la severidad domina y los ítems no. Con solo 6 datasets (3 gl residuales) esta regresión nunca tuvo mucha potencia -- es evidencia de ausencia de un efecto GRANDE de cualquiera de los dos predictores, no prueba definitiva de que ninguno tenga efecto. Sigue respaldando usar los 6 instrumentos reales tal como están, sin necesidad de reconstruir compuestos artificiales de 10 ítems.

## 13. Comparación de las 11 pruebas: potencia bruta, estabilidad a k, y qué tan predecible es su comportamiento real desde la simulación (24-25 sep 2026)

Pregunta práctica para el paper: ¿cuál de las 11 pruebas conviene usar, bajo qué criterios de k, n y severidad? Se necesitan tres tablas distintas, no comparables directamente entre sí salvo con el cuidado que se explica abajo.

### 13.1 Tabla simulada LIMPIA (severidad aislada de k por diseño)

Usando las 280 filas del bloque de niveles (5 niveles × k=3..9 × 8 n), donde la calibración mantiene la severidad constante dentro de cada nivel con precisión de 5-6 decimales (ver verificación abajo), se calculó potencia media por prueba y el coeficiente de variación (CV) de su potencia a través de k=3..9 (promediando sobre n), dentro de cada nivel y luego promediado entre los 5 niveles:

| Prueba | Potencia media | CV estabilidad a k | Rank combinado |
|---|---|---|---|
| D'Agostino-Pearson | 0.759 | 0.019 | 3 |
| Shapiro-Wilk | 0.755 | 0.050 | 7 |
| Epps-Pulley | 0.731 | 0.040 | 8 |
| Anderson-Darling | 0.731 | 0.057 | 10 |
| Jarque-Bera | 0.612 | 0.010 | 11 |
| Shapiro-Francia | 0.725 | 0.056 | 11 |
| SSTN | 0.698 | 0.034 | 12 |
| Cramér-von Mises | 0.708 | 0.061 | 15 |
| Pearson χ² | 0.719 | 0.073 | 16 |
| Lilliefors | 0.700 | 0.066 | 17 |
| Curtosis (Anscombe-Glynn) | 0.447 | 0.078 | 22 |

**Verificación de que la severidad SÍ está aislada de k en esta tabla**: los valores de asimetría/curtosis logrados por la calibración (`data/results/calibracion_niveles.csv`) varían menos de 10⁻⁵ entre los 7 valores de k dentro de cada nivel (ej. nivel "moderado": asimetría lograda en [0.699998, 0.700004], curtosis lograda en [-0.150004, -0.149999], dist² máxima 3.78e-11) -- cuatro a cinco órdenes de magnitud más chico que la diferencia ENTRE niveles (0.15 a 1.35). El CV de esta tabla mide sensibilidad a k pura.

D'Agostino-Pearson gana el balance general (potencia casi máxima + muy estable a k). SSTN no es la más potente (9no lugar en potencia) pero es la 3ra más estable a k -- su argumento no es "detecta mejor", es "su conclusión no depende de cuántas categorías tiene la escala". Curtosis es errática porque solo detecta desviaciones de curtosis, y la curtosis objetivo de los niveles NO sube monótonamente con la severidad etiquetada (bajo=-0.70, moderado=-0.15 casi mesocúrtica, alto=0.40, muy_alto=1.17).

### 13.2 Tabla real (k y severidad confundidos, inevitable con instrumentos ya existentes)

Mismo cálculo sobre los 6 datasets reales (`consolidado.csv`), sin poder aislar severidad -- cada k real trae su propio nivel de severidad pegado:

| Prueba | Potencia media (real) | CV k (real, confundido) | Rank combinado |
|---|---|---|---|
| D'Agostino-Pearson | 0.732 | 0.203 | 3 |
| Epps-Pulley | 0.664 | 0.154 | 4 |
| Shapiro-Wilk | 0.688 | 0.242 | 5 |
| Anderson-Darling | 0.662 | 0.260 | 9 |
| Lilliefors | 0.641 | 0.246 | 12 |
| Shapiro-Francia | 0.658 | 0.286 | 13 |
| Cramér-von Mises | 0.641 | 0.278 | 14 |
| Pearson χ² | 0.630 | 0.267 | 15 |
| SSTN | 0.648 | 0.288 | 15 |
| Jarque-Bera | 0.582 | 0.304 | 20 |
| Curtosis | 0.539 | 0.334 | 22 |

D'Agostino-Pearson se sostiene como la mejor combinación también aquí (coincide con 13.1). Epps-Pulley destaca en 4to lugar gracias a su CV muy bajo (0.154, el más bajo de los 11). SSTN queda en la mitad de la tabla (rank 15, empatado con Pearson χ²).

### 13.3 Tabla simulada CONFUNDIDA (mismo emparejamiento nivel-k que los reales, a propósito)

Para que 13.1 y 13.2 sean comparables sin el "ruido" de que una está limpia y la otra no, se repitió el cálculo sobre SOLO 6 celdas simuladas, las que comparten nivel y k con los 6 datasets reales (bajo/k4, bajo_moderado/k5, **muy_alto/k6**, bajo_moderado/k7, alto/k8, muy_alto/k9) -- el mismo confound de los reales, impuesto artificialmente sobre datos simulados. Nota: como SPS-10 se asigna a "muy_alto" (igual que RWAS, ver Sección 15), el nivel "muy_alto" aparece DOS veces en este emparejamiento (k=6 y k=9):

| Prueba | Potencia (sim. confundido) | CV k (sim. confundido) | Rank combinado |
|---|---|---|---|
| Shapiro-Wilk | 0.791 | 0.209 | 4 |
| D'Agostino-Pearson | 0.772 | 0.215 | 6 |
| Epps-Pulley | 0.743 | 0.205 | 7 |
| Anderson-Darling | 0.764 | 0.238 | 8 |
| Shapiro-Francia | 0.762 | 0.243 | 10 |
| Pearson χ² | 0.750 | 0.255 | 13 |
| Curtosis | 0.550 | 0.207 | 13 |
| Lilliefors | 0.721 | 0.248 | 15 |
| Cramér-von Mises | 0.734 | 0.274 | 16 |
| SSTN | 0.715 | 0.297 | 19 |
| Jarque-Bera | 0.615 | 0.327 | 21 |

Curtosis tiene un CV bajo aquí (0.207, casi tan bajo como Shapiro-Wilk) pero su potencia sigue siendo la más baja de las 11 (0.550) -- por eso su rank combinado (13, empatado con Pearson χ²) es solo mediocre, no el mejor. El CV bajo es plausible: tanto SPS-10 (kurt=1.986) como RWAS (kurt=1.17), el par que forma "muy_alto" aquí, tienen curtosis alta, así que curtosis (que solo reacciona a eso) ve un cambio menor entre esos dos extremos de k que en el resto de la tabla -- coincidencia de diseño del emparejamiento, no una propiedad general (en 13.1, con los 5 niveles limpios, curtosis sigue siendo la peor en ambos criterios).

### 13.4 Desplazamiento (13.3 vs 13.2): qué tan predecible es cada prueba desde la simulación

Diferencia absoluta de rank combinado entre la tabla simulada-confundida (13.3) y la real (13.2):

| Prueba | Rank (sim. confundido) | Rank (real) | Desplazamiento |
|---|---|---|---|
| Shapiro-Wilk | 4 | 5 | **1** |
| Anderson-Darling | 8 | 9 | **1** |
| Jarque-Bera | 21 | 20 | **1** |
| Cramér-von Mises | 16 | 14 | 2 |
| Pearson χ² | 13 | 15 | 2 |
| Lilliefors | 15 | 12 | 3 |
| D'Agostino-Pearson | 6 | 3 | 3 |
| Shapiro-Francia | 10 | 13 | 3 |
| Epps-Pulley | 7 | 4 | 3 |
| SSTN | 19 | 15 | 4 |
| Curtosis | 13 | 22 | **9** (la más impredecible) |

Shapiro-Wilk, Anderson-Darling y Jarque-Bera son las más predecibles (desplazamiento=1 cada una) -- ninguna llega a desplazamiento cero. SSTN queda en un lugar intermedio (desplazamiento=4, ni de las mejores ni de las peores). Curtosis es la más impredecible por un margen amplio (9, casi el doble que la siguiente) -- consecuencia directa de la coincidencia de diseño señalada en 13.3: su CV bajo en el par muy_alto (SPS-10 y RWAS, ambos con curtosis alta) no se sostiene en el resto de la tabla real, donde los demás pares no comparten esa propiedad. Esto confirma que la métrica de "predictibilidad" depende fuertemente de qué par de instrumentos ocupa cada nivel de severidad en el emparejamiento confundido, no es una propiedad fija de cada prueba -- se comprobó comparando dos instrumentos distintos de k=6 evaluados en momentos separados de este estudio, uno de los cuales fue descartado (Sección 14) y reemplazado por el otro (Sección 15). Reportar esta tabla en el paper exige esa advertencia explícita.

### 13.5 Síntesis para el paper (actualizada 25 sep 2026)

- **Si hay que recomendar una sola prueba por defecto**: D'Agostino-Pearson -- mejor balance potencia/estabilidad en las tres tablas (13.1, 13.2, 13.3), consistentemente -- es el hallazgo más robusto de toda la Sección 13 (se verificó estable frente a un cambio de instrumento real en k=6, ver Secciones 14-15).
- **Shapiro-Wilk**: máxima potencia bruta en casi todos los escenarios (hallazgo ya conocido en la literatura, no novedoso), pero más sensible a k que D'Agostino-Pearson; además, de las más predecibles entre escenarios.
- **SSTN**: su valor agregado no es potencia bruta (nunca es la más potente) -- es estabilidad-a-k cuando la severidad está controlada (13.1, 3er lugar). Su predictibilidad entre escenarios (13.4) NO es un hallazgo robusto -- cambió de posición notablemente al cambiar el instrumento de k=6 (ver Secciones 14-15). Reportar solo la ventaja de 13.1 (robusta a ese cambio), no la de 13.4 (sensible a qué instrumento ocupa k=6).
- **El hecho de que casi todos los rankings de las Secciones 13.2-13.4 cambien de forma no trivial al cambiar un solo instrumento real (k=6, ver Secciones 14-15) es evidencia metodológica en sí misma**: ilustra cuán frágiles son las conclusiones sobre "qué prueba es mejor" cuando se basan en un solo conjunto de instrumentos reales, y refuerza la necesidad de la Tabla 13.1 (simulación limpia, con 7 valores de k por nivel) como ancla más estable para las recomendaciones del paper.
- **Curtosis (Anscombe-Glynn)**: peor en el escenario limpio (13.1) y la más impredecible entre escenarios (13.4) -- útil solo si se sabe de antemano que la desviación es puramente de curtosis, no de asimetría.

## 14. Se descarta el primer candidato de instrumento real de k=6 (25 sep 2026)

Al preparar la Tabla 1 del método (confiabilidad por instrumento), se calculó por primera vez el alfa de Cronbach del primer candidato de k=6 directamente sobre los datos: **α=0.043** -- esencialmente cero, muy por debajo de cualquier umbral aceptable, con la clave de reversión inferida cruzando el contenido semántico de cada ítem contra la estructura de subescalas de su instrumento de origen.

Investigación del problema, en orden:

1. **Sin ninguna reversión**, las 9 correlaciones entre ítems ya son todas positivas (0.02-0.47) -- α sube a 0.69, pero esto por sí solo no prueba que "no reversión" sea la clave correcta (podría ser aquiescencia, ver punto 3).
2. **Verificación contra el codebook oficial de la fuente de datos** (199 páginas, texto completo de los 9 ítems en inglés confirmado): la dirección de reversión semánticamente correcta (según el contenido literal de cada ítem) coincide EXACTAMENTE con la que ya se había inferido antes en este proyecto -- no era un error de la clave.
3. **El problema real, encontrado en el mismo codebook**: la documentación oficial de la fuente de datos recomienda explícitamente NO combinar estos ítems en subescalas ni en un puntaje total en este dataset.
4. **Confirmación empírica de por qué**: con la reversión semánticamente correcta, las 3 subescalas del instrumento (3 ítems cada una) tienen alfa razonable por separado (0.57, 0.36, 0.65) pero correlacionan NEGATIVAMENTE entre sí (-0.145, -0.379, 0.033) -- deberían correlacionar positivamente si midieran el mismo constructo subyacente. Explicación más plausible: aquiescencia en ítems redactados en sentido inverso, un problema bien documentado en muestras de niños/adolescentes (la muestra de origen era de 9-18 años) -- los respondientes probablemente no invirtieron mentalmente el sentido de las frases al responder.
5. **Se descartaron dos posibles arreglos**: (a) usar una sola subescala de 3 ítems -- introduce discretización severa (solo 16 valores distintos posibles en escala 1-6) y las 3 subescalas dan severidades reales distintas entre sí (asimetría de -0.86 a +0.88, incluso de signo opuesto), no hay una elección no arbitraria; (b) transformar el puntaje compuesto (multiplicar por constante, o transformación no lineal) -- no cambia la cantidad de valores distintos (transformación monótona conserva cardinalidad) ni resuelve el problema real (validez de constructo, no de escala), y una transformación no lineal para "mejorar" la forma constituiría manipular el resultado en vez de medirlo, violando la Sección 8.

**Decisión**: descartar ese candidato del estudio. No es un error de codificación corregible -- es una propiedad documentada del instrumento en ese dataset específico, corroborada independientemente por la fuente de datos y por el análisis propio (incoherencia entre subescalas). Se retiran sus archivos del repositorio y se busca un nuevo candidato de k=6 (ver Sección 15).

## 15. Instrumento real de k=6: Social Provisions Scale (SPS-10) / COVIDiSTRESS Global Survey (25 sep 2026)

Búsqueda de un reemplazo para k=6, esta vez explorando datasets de encuestas grandes con formato de respuesta uniforme de 6 puntos (a diferencia de instrumentos psicométricos individuales, que rara vez usan k=6 -- ver Sección 2). Se encontró **COVIDiSTRESS Global Survey** (OSF, código z39us; Lieberoth et al., encuesta global durante la pandemia de COVID-19, marzo-mayo 2020, N=173.426 respondientes), cuyo archivo final limpio (`COVIDiSTRESS global survey May 30 2020 (***final cleaned file***).csv`, guid `f8h9w`) contiene varios bloques de ítems en escala 1-6 nativa.

De los candidatos de ese dataset con escala 1-6 (PSS-10/UCLA usa 1-5, no 1-6; OECD trust usa 0-10; Corona_concerns y Compliance sí son 1-6 pero son escalas ad-hoc del estudio, no instrumentos validados publicados; BFF-15, Big Five, es 1-6 pero mide 5 rasgos DISTINTOS que no se pueden sumar en un solo puntaje, mismo problema categórico que el candidato descartado en la Sección 14), se eligió la **Social Provisions Scale, forma corta de 10 ítems (SPS-10; Cutrona y Russell, 1987)**, columnas `SPS_1`..`SPS_10`.

Verificación antes de usarla (aprendiendo la lección de la Sección 14):
- **Confiabilidad**: α=0.92 sin ninguna reversión aplicada, N=91.658 casos completos (el mayor de los 6 instrumentos reales).
- **Coherencia entre ítems**: las 10 correlaciones son todas positivas y fuertes (0.39-0.77), sin ninguna cercana a cero.
- **Confirmación por fuente publicada**: la validación de la SPS-10 (búsqueda web, ver referencias) documenta que la forma corta retiene DELIBERADAMENTE solo los ítems redactados en sentido positivo de la escala original de 24 ítems (que sí tenía ítems negativos por subescala) -- confirma, con evidencia externa, que la ausencia de reversión no es un accidente sino el diseño publicado de este instrumento.
- **Estructura unidimensional**: a diferencia del candidato de la Sección 14 (3 subescalas distintas) y de BFF-15 (5 rasgos distintos), la SPS-10 mide un solo constructo (apoyo social percibido) y se reporta históricamente como puntaje único, sin problema categórico de "qué subescala elegir".

Severidad real: asimetría=-1.208, curtosis exceso=1.986 -- la más extrema de los 6 instrumentos reales (incluso más que RWAS). Por distancia euclidiana (|asimetría|, ver Sección 11), el nivel más cercano es **muy_alto** (dist=0.828) -- un ajuste notablemente peor que el de RWAS al mismo nivel (dist=0.002), porque la curtosis de SPS-10 (1.986) EXCEDE el extremo calibrado (muy_alto=1.17): es extrapolación en la dimensión de curtosis, mismo tipo de limitación ya documentada para RWAS respecto al rango k=3..9 de la simulación.

**Validación real-vs-simulado con los 6 instrumentos actualizados**: correlación global r=0.945, y la relación entre distancia de ajuste y error de predicción no es perfectamente monótona (Spearman ρ=0.83) -- SPS-10 tiene la peor distancia de ajuste (0.828) de los 6, pero su error de predicción (dif. abs. media=0.123) es menor que el de MACH-IV (0.142) o AHS (0.155), que ajustan mejor. Explicación plausible: a un nivel de severidad tan extremo, la potencia de casi todas las pruebas ya está cerca del techo (1.0) tanto en la simulación como en la realidad, así que el error absoluto queda naturalmente acotado por el efecto techo, independientemente de qué tan bien calibrada esté la severidad -- el patrón general (peor ajuste → más error) se mantiene fuerte pero no es una ley perfecta.

**Reevaluación de paridad (H4, ver `notes/resultados_borrador.md`)**: con SPS-10 asignada a "muy_alto" -- el mismo nivel que RWAS (k=9, impar) --, el nivel "muy_alto" pasa a tener un dataset par (SPS-10) y uno impar (RWAS), y el modelo `potencia ~ nivel + paridad` se vuelve técnicamente estimable (coeficiente negativo, par<impar, significativo en n=10,25,50; p<.0001; no significativo en n≥100). Pero un chequeo leave-one-out muestra que el coeficiente es IDÉNTICO sin importar cuál de los otros 4 datasets se excluya -- es decir, toda la identificación de "paridad" viene enteramente del contraste SPS-10 vs RWAS dentro de "muy_alto", ningún otro dataset aporta información. No es un test general de paridad, es una comparación pareada SPS-10-vs-RWAS disfrazada de ANCOVA, y como SPS-10 tiene el peor ajuste de severidad de los 6 (dist=0.828), ese contraste sigue estando confundido con severidad residual. **Conclusión**: la paridad de k solo tiene evidencia válida en el bloque simulado (diseño ortogonal a propósito), no en datos reales.

**ACTUALIZACIÓN (26 sep 2026): los objetivos de los 5 niveles se recalibraron a percentiles de Cain et al. (2017) -- ver Secciones 16-18 para los números finales.** Todos los números de esta sección (asignación de SPS-10 a "muy_alto", distancia=0.828, r=0.945, etc.) se calcularon contra una calibración intermedia, ya superada -- con la calibración final, SPS-10 se asigna a "alto" (dist=0.387, ver Sección 18), no a "muy_alto".

## 16. Recalibración de los 5 niveles con respaldo empírico publicado (25 sep 2026)

**Motivación**: los objetivos de asimetría/curtosis de los 5 niveles (Secciones 6-9) estaban anclados a instrumentos propios del estudio (RSE, RWAS) o a puntos intermedios elegidos sin una fuente externa citable. Al revisar la solidez de las categorías "bajo/bajo-moderado/moderado/alto/muy alto" frente a una posible objeción de revisor ("¿de dónde salen estos números?"), se buscó una fuente empírica publicada que respaldara los cortes.

**Fuente**: Cain, M. K., Zhang, Z., y Yuan, K.-H. (2017). Univariate and multivariate skewness and kurtosis for measuring nonnormality: Prevalence, influence and estimation. *Behavior Research Methods*, 49(5), 1716-1735. Los autores recolectaron asimetría y curtosis de 1.567 distribuciones univariadas de estudios publicados en *Psychological Science* (2013-2014) y *American Education Research Journal* (2010-2014), y reportan una tabla de percentiles (su Tabla 1a):

| Percentil | Asimetría | Curtosis (exceso) |
|---|---|---|
| Mínimo | −10.87 | −2.20 |
| 1º | −2.08 | −1.70 |
| 5º | −1.17 | −1.28 |
| 25º | −0.33 | −0.57 |
| Mediana | 0.20 | 0.07 |
| 75º | 0.94 | 1.62 |
| 95º | 2.77 | 9.48 |
| 99º | 6.32 | 95.75 |
| Máximo | 25.54 | 1093.48 |

**Decisión de diseño (curtosis vs. asimetría, tratamiento distinto y justificado)**:
- **Curtosis**: se usa el percentil CON SIGNO tal cual lo publican. La dirección importa -- leptocúrtica (colas pesadas) y platicúrtica (colas livianas) son formas de no-normalidad genuinamente distintas, no un reflejo una de la otra, y las 11 pruebas pueden responder de forma distinta a cada una.
- **Asimetría**: se usa el percentil de |asimetría|, no el valor con signo. La dirección del sesgo no importa para la potencia de las 11 pruebas (son estructuralmente simétricas al signo, por reflexión x → −x) -- de hecho, así es como el estudio ya venía asignando severidad a los instrumentos reales desde la Sección 11. Usar el percentil CON SIGNO habría sido incorrecto: el percentil 5º con signo (−1.17) no representa "poco sesgo", representa "sesgo negativo fuerte" (porque la distribución de asimetría real no es simétrica alrededor de 0 -- su mediana ya está en 0.20, no en 0). Tomar |−1.17| como objetivo de "bajo" habría hecho que ese nivel fuera MÁS severo que "moderado", rompiendo el orden creciente de severidad que da sentido a los 5 niveles.

**Cálculo de percentiles de |asimetría|** (Cain et al. no los publican directamente, y los datos individuales de las 1.567 distribuciones no están disponibles públicamente): se interpoló linealmente la función de distribución acumulada empírica implícita en la tabla publicada (usando los 9 puntos conocidos: mínimo, 1º, 5º, 25º, mediana, 75º, 95º, 99º, máximo), y se resolvió P(|asimetría| ≤ m) = F(m) − F(−m) = p para p = .05, .25, .50, .75, .95, vía búsqueda de raíz (`uniroot`). Código completo en el commit que introduce esta sección (`R/03_calibrar_niveles.R`, comentario de cabecera). Resultado:

| Percentil deseado | |Asimetría| interpolada |
|---|---|
| 5º | 0.053 |
| 25º | 0.276 |
| 50º | 0.688 |
| 75º | 1.332 |
| 95º | 3.521 |

**Advertencia de precisión**: esto es una aproximación sobre datos agregados publicados (la tabla de percentiles), no un cálculo directo sobre las 1.567 observaciones crudas -- la interpolación lineal entre puntos conocidos es una simplificación, especialmente en la cola alta (95º), donde hay pocos puntos de referencia y la verdadera forma de la distribución podría no ser lineal entre ellos. Se reporta así explícitamente en el método, distinguiendo esta derivación (interpolada) de la de curtosis (percentil directo, sin transformación).

**Nueva Tabla 2 (niveles recalibrados)**:

| Nivel | Percentil (asimetría / curtosis) | Asimetría objetivo | Curtosis exceso objetivo |
|---|---|---|---|
| bajo | 5º / 5º | 0.053 | −1.28 |
| bajo_moderado | 25º / 25º | 0.276 | −0.57 |
| moderado | 50º / 50º | 0.688 | 0.07 |
| alto | 75º / 75º | 1.332 | 1.62 |
| muy_alto | 95º / 95º | 3.521 | 9.48 |

**Chequeo de factibilidad antes de correr las 35 celdas en Actions**: una prueba local (no oficial, solo para verificar que el mecanismo puede alcanzar el objetivo más extremo antes de comprometer cómputo de Actions) calibró muy_alto en k=5 con 4 arranques: tardó 430 segundos y NO convergió bien (asimetría lograda=3.11 vs objetivo 3.52, curtosis lograda=9.55 vs objetivo 9.48, dist²=0.174 -- muy por encima del dist² ≈ 10⁻¹¹ que lograban los niveles originales, menos extremos). Esto confirma que el nuevo objetivo "muy_alto" está cerca del límite de lo alcanzable con el mecanismo actual (factor común + m=10 ítems discretizados), y que hacen falta más arranques que el default (8) para converger razonablemente.

**Decisión**: correr la calibración completa en GitHub Actions (no localmente, por la Sección 8) con `n_starts=16` (el doble del default) en vez de aumentar la cantidad de ítems o relajar el objetivo -- ver commit que actualiza `.github/workflows/simulate.yml`.

**Resultado de la corrida completa** (run 36136389635, 55m29s): con 16 arranques, muy_alto mejoró 10x respecto a la prueba local con 4 arranques -- dist²=0.0173 en las 7 celdas de k (vs. 0.174 con 4 arranques), asimetría lograda=3.39 (objetivo 3.52, diferencia ~4%), curtosis lograda=9.50 (objetivo 9.48, prácticamente exacta). Los otros 4 niveles (bajo, bajo_moderado, moderado, alto) calibraron prácticamente exactos, dist²≈10⁻¹⁵.

**CORRECCIÓN (25-26 sep 2026): la aceptación de este ajuste fue prematura -- ver Sección 17.** Un dist² bajo NO garantiza una solución no degenerada; se encontró que muy_alto convergió a un mecanismo generativo inválido (ver Sección 17 para el detalle completo y la solución).

## 17. El objetivo "muy_alto" al percentil 95 produce un mecanismo generativo degenerado -- se usa el percentil 90 en su lugar (26 sep 2026)

Al recalcular las tablas de resultados con los niveles recalibrados (Sección 16), la comparación de las 11 pruebas mostró algo imposible: Epps-Pulley con potencia≈0 en el nivel muy_alto en TODOS los tamaños de muestra, incluso n=1500 -- matemáticamente implausible para una desviación tan extrema de la normalidad (cualquier prueba razonable debería tener potencia cercana a 1 ahí).

**Investigación**: revisando los conteos de NA por prueba y n en `nivel_muy_alto_k5.csv`, se encontró que no era un problema exclusivo de Epps-Pulley -- prácticamente TODAS las pruebas (excepto Pearson χ², que no depende de la varianza muestral de la misma forma) tenían ~50% de réplicas con NA en n=10 (4.978 a 5.746 de 10.000), y D'Agostino-Pearson el 100%.

**Causa raíz**: los parámetros calibrados para muy_alto (`data/results/calibracion_niveles.csv`, run 36136389635) eran degenerados: λ=1.0 (sin ruido idiosincrático en ningún ítem -- los 10 ítems quedan perfectamente correlacionados, copias exactas unas de otras) y umbrales `[1.48, 365.03, 365.04, 365.04]` para k=5 -- solo el primer umbral es alcanzable por una normal estándar; los demás están a ~365 desviaciones estándar, inalcanzables en la práctica. Con k=5 categorías nominales, el compuesto solo puede tomar 2 valores reales (10 o 20), con P(compuesto=10)≈0.93. La probabilidad de que una muestra de n=10 caiga TODA en el mismo valor es 0.93¹⁰≈49.2% -- coincide exactamente con el ~50% de NA observado. Cuando eso ocurre, la varianza muestral es cero y cualquier estadístico que divida por ella (la mayoría de las 11 pruebas) queda indefinido.

El optimizador encontró una "solución barata": colapsar el mecanismo a una variable casi binaria satisface el objetivo numérico de momentos (asimetría, curtosis) sin producir una distribución que se parezca a un compuesto Likert real de *k* categorías y *m*=10 ítems -- el dist² bajo (0.0173) no detecta esto porque el objetivo de calibración solo mide distancia en momentos, no plausibilidad del mecanismo generativo.

**Contexto adicional que motivó revisar el objetivo en vez de solo arreglar el optimizador**: ninguno de los 6 instrumentos reales del estudio se acerca al percentil 95 de Cain et al. -- la curtosis real más alta es SPS-10 con 1.986 (Sección 15), muy por debajo de 9.48. Un "muy_alto" tan extremo no tiene ningún instrumento real cerca para validar, además de ser generativamente inalcanzable de forma no degenerada.

**Decisión**: usar el **percentil 90** en vez del 95 para muy_alto -- asimetría=2.401, curtosis=7.52 (mismo método de interpolación que en la Sección 16 para |asimetría|; curtosis con signo directo de Cain et al., interpolada linealmente entre el 75º y 95º ya que el 90º no es uno de los percentiles que publican). Verificación local (no oficial, solo factibilidad) con 6 arranques: λ=0.854 (razonable, lejos de 1), umbrales `[0.70, 1.68, 2.36, 2.54]` (todos alcanzables), dist²=4.3×10⁻⁵ -- ajuste casi exacto y sin degeneración. Se descartó la opción de restringir el optimizador contra soluciones degeneradas (más trabajo, sin garantía de que exista una solución no degenerada al percentil 95 con m=10 ítems) y la de aumentar la cantidad de ítems (cambiaría la comparabilidad del diseño).

**Nueva Tabla 2 (definitiva)**:

| Nivel | Percentil (asimetría / curtosis) | Asimetría objetivo | Curtosis exceso objetivo |
|---|---|---|---|
| bajo | 5º / 5º | 0.053 | −1.28 |
| bajo_moderado | 25º / 25º | 0.276 | −0.57 |
| moderado | 50º / 50º | 0.688 | 0.07 |
| alto | 75º / 75º | 1.332 | 1.62 |
| muy_alto | 90º / 90º | 2.401 | 7.52 |

**Verificación tras la corrida completa** (calibración run 36229461732, simulación run 36231310528): sin degeneración en ninguna de las 7 celdas de k -- λ entre 0.54 y 0.86 (lejos de 1), umbrales en rango razonable (0.4 a 2.2), dist² máxima 0.0003 en las 35 celdas totales. Los conteos de NA en la simulación completa volvieron a niveles normales (máximo 19 de 10.000 réplicas, salvo D'Agostino-Pearson en n=10 que sigue fallando el 100% de las veces -- limitación ya conocida de esa prueba específica en muestras muy chicas, no relacionada con este problema). Epps-Pulley pasó de potencia≈0 en todo n a un comportamiento sensible (0.34 en n=10, 1.00 desde n=250).

## 18. Recálculo completo de resultados con los niveles corregidos (26 sep 2026)

Con la calibración final (Secciones 16-17) se recalcularon todos los análisis que dependen del bloque de niveles.

**Tabla 3 (brecha k3-k9 por nivel)**: bajo=0.027, bajo_moderado=0.045, moderado=0.036, alto=0.016, muy_alto=0.012. Desde bajo_moderado en adelante la brecha decae de forma monótona (0.045→0.036→0.016→0.012), igual que en el diseño original. La única excepción es "bajo" (0.027), que queda por debajo de "bajo_moderado" en vez de ser el máximo -- porque el objetivo de curtosis de "bajo" (−1.28, percentil 5 de Cain et al.) es una desviación real de la normalidad, no un punto cercano a ella como en el diseño anterior (que sí estaba anclado cerca de cero en ambas dimensiones). El hallazgo central del estudio se sostiene en su mayor parte, con esta salvedad real que hay que reportar explícitamente, no ocultar.

**Tabla 5 (brecha por nivel × n, pico)**: bajo→n=50, bajo_moderado→n=100, moderado→n=50, alto→n=25, muy_alto→n=10. De moderado en adelante el desplazamiento a n cada vez más chico es monótono y limpio (n=50→25→10); bajo→bajo_moderado es la única inversión (mismo patrón que la Tabla 3).

**Reasignación de severidad de los 6 instrumentos reales** (distancia euclidiana a los niveles corregidos, |asimetría| vs. curtosis con signo): RSE→bajo_moderado (dist=0.299), MACH-IV→bajo_moderado (dist=0.162), SPS-10→alto (dist=0.387), HEXACO→bajo_moderado (dist=0.066), AHS→moderado (dist=0.273), RWAS→alto (dist=0.450). Cambia sustancialmente respecto a la asignación anterior -- ahora 3 instrumentos comparten "bajo_moderado" (RSE, MACH-IV, HEXACO) y 2 comparten "alto" (SPS-10, RWAS), una estructura más rica que los pares aislados de antes. Las distancias son en general peores que en el diseño anterior (0.066-0.450 vs. 0.002-0.958) porque los niveles ya NO están anclados a instrumentos propios del estudio -- es la validación genuinamente independiente que motivó todo el rediseño (Sección 16).

**Validación real-vs-simulado**: correlación global r=0.981 (mejor que las versiones anteriores, 0.909 y 0.945), con r individual por instrumento entre 0.957 (SPS-10, el peor) y 0.999 (MACH-IV, AHS). La relación entre distancia de ajuste y error de predicción se debilita bastante (Spearman ρ=0.37, Pearson r=0.40) respecto a las versiones anteriores (0.83-1.00) -- con niveles genuinamente independientes, la predicción se mantiene fuerte para los 6 instrumentos sin importar tanto la distancia exacta, a diferencia del diseño anterior donde la distancia predecía casi perfectamente el error (en parte reflejo de su propia circularidad).

**H1 (efecto de k, controlando severidad) -- reevaluado con la nueva estructura**: dentro de "bajo_moderado" (3 instrumentos: RSE k=4, MACH-IV k=5, HEXACO k=7), la regresión de potencia sobre k (11 pruebas como pseudo-réplicas) da coeficiente NEGATIVO (dirección de H1) en 5 de 8 tamaños de *n* (50, 100, 250, 500, 1000), ninguno significativo individualmente (3 instrumentos, 1 gl para k). Dentro de "alto" (SPS-10 k=6 vs. RWAS k=9), la dirección se invierte y es significativa en *n*=10,25,50 (p<.001) -- mismo patrón que con el diseño anterior: SPS-10 sigue siendo el instrumento que rompe la dirección esperada en cualquier nivel donde caiga (su distancia de ajuste, 0.387, sigue siendo la 2da peor de los 6).

**Tablas 13.2/13.3 (comparación de las 11 pruebas, real vs. simulado-confundido con el nuevo emparejamiento nivel-k: bajo_moderado/k4, bajo_moderado/k5, alto/k6, bajo_moderado/k7, moderado/k8, alto/k9)**:

| Prueba | Rank real | Rank sim. confundido | Desplazamiento |
|---|---|---|---|
| D'Agostino-Pearson | 3 | 3 | **0** |
| Epps-Pulley | 4 | 4 | **0** |
| Shapiro-Wilk | 5 | 5 | **0** |
| Anderson-Darling | 9 | 9 | **0** |
| Jarque-Bera | 20 | 20 | **0** |
| Curtosis | 22 | 22 | **0** |
| Shapiro-Francia | 13 | 12 | 1 |
| Cramér-von Mises | 14 | 15 | 1 |
| Lilliefors | 12 | 13 | 1 |
| SSTN | 15 | 17 | 2 |
| Pearson χ² | 15 | 12 | 3 |

**Mejora notable respecto a las versiones anteriores del estudio**: 6 de 11 pruebas tienen desplazamiento CERO (antes, con cualquiera de los dos instrumentos previos de k=6, el máximo era 1 prueba con desplazamiento cero y varias por encima de 8). D'Agostino-Pearson se mantiene #1 en ambos escenarios, consistente en las tres versiones del estudio (diseño original, con NFC, con SPS-10 solo, y ahora con niveles recalibrados). SSTN queda en un lugar intermedio de predictibilidad (desplazamiento=2), ni el mejor ni el peor -- ya no hay una ventaja de predictibilidad destacable para SSTN que reportar, a diferencia de lo que parecía en una versión anterior (que resultó no ser robusta, ver Sección 13.4 histórica).

## 19. Síntesis final: utilidad práctica del rediseño de niveles (26 sep 2026)

Más allá de robustecer la Tabla 2 con una cita externa, todo este proceso (Secciones 16-18) deja tres cosas concretamente útiles para el paper y para la práctica de investigación en general.

**Primero**, la calibración por niveles quedó validada de forma genuinamente independiente (r=0.981, sin que los niveles estén anclados a los mismos instrumentos que se usan para probarlos) -- esto es un argumento mucho más fuerte para defender la herramienta como método de planificación de estudios reutilizable, porque ya no se le puede objetar circularidad (a diferencia del diseño original, donde "bajo" y "muy_alto" estaban anclados a RSE y RWAS, dos de los propios instrumentos usados para validar).

**Segundo**, el hallazgo de que 6 de las 11 pruebas de normalidad predicen su comportamiento real con desplazamiento cero entre el escenario simulado-confundido y el real (antes, con calibraciones más frágiles, como máximo una prueba lograba eso) le da al investigador aplicado una base sólida para elegir prueba según prioridad: D'Agostino-Pearson como opción por defecto (mejor balance potencia/estabilidad, confirmado en las tres calibraciones distintas de este estudio), con la confianza adicional de que su elección de prueba se va a comportar de forma predecible en la mayoría de los casos reales, no solo en el escenario ideal simulado.

**Tercero, y quizás el más transferible más allá de este estudio específico**: el episodio de la calibración degenerada (Sección 17) es una advertencia metodológica reusable para cualquiera que calibre simulaciones Monte Carlo por optimización de momentos -- un ajuste numéricamente "bueno" (dist² bajo) no garantiza un mecanismo generativo válido; hace falta inspeccionar los parámetros mismos (aquí, λ y los umbrales) para detectar soluciones degeneradas que satisfacen el objetivo numérico mientras producen datos sin sentido (en este caso, una variable binaria disfrazada de escala de k categorías). Es una práctica de verificación concreta y accionable, digna de mencionarse explícitamente en el Método del paper, no solo dejarla en el registro de decisiones del repositorio.
