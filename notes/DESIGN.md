# DESIGN.md -- ResponseCategories-Normality-Study

Registro de decisiones metodológicas, en orden cronológico.

## 1. Origen del proyecto (22 sep 2026)

Este proyecto nace de un hallazgo secundario de SSTN-Normality-Study (Bloque 5 ampliado: 12 escenarios simulados x k=3..8, ver ese repo, `notes/DESIGN.md`): la potencia de las 11 pruebas de normalidad evaluadas frente a la cantidad de categorías de respuesta k del instrumento simulado (a) depende en su mayoría de la CANTIDAD de categorías dentro de una misma paridad (no de la paridad par/impar en sí, salvo para SSTN, Jarque-Bera, D'Agostino-Pearson y curtosis, que son robustas a ambos), y (b) esa dependencia está fuertemente modulada por n: negligible en n=10, pico en n≈100-250, casi desaparece en n≥1000.

Decisión: separar esto en un artículo independiente en vez de agregarlo como una sexta sección al manuscrito de SSTN-Normality-Study (que ya está en revisión mayor en Psicothema y convergiendo) -- la pregunta de fondo ("¿cómo interactúan diseño del instrumento y tamaño de muestra en la potencia de CUALQUIER prueba de normalidad?") es distinta a la de ese paper ("¿cómo se compara SSTN contra las clásicas?") y generalizable más allá de SSTN.

Título de trabajo (actualizado 23 sep 2026, tras cerrar el bloque de niveles -- Sección 9): "Cuándo importa la cantidad de categorías de respuesta: un estudio Monte Carlo de su interacción con el tamaño de muestra y la severidad de la no-normalidad en 11 pruebas".

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

## 5. Grilla de n y método de submuestreo (22 sep 2026)

Se usa la MISMA grilla de n que el Bloque 5 simulado de SSTN-Normality-Study -- {10,25,50,100,250,500,1000,1500} -- para que la comparación entre el hallazgo simulado y su contraparte real sea directa, celda por celda de n, no solo cualitativa. El N mínimo de los 4 datasets (RWAS, 9.680) es muy superior al n máximo del grid (1.500), así que el remuestreo sin reemplazo (mismo método "m-out-of-N" del Bloque 4 de SSTN-Normality-Study) es válido para los 4 sin ajuste.

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
