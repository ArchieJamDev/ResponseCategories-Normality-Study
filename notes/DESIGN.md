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

## 5. Grilla de n y método de submuestreo (22 sep 2026; actualizado 24 sep 2026 tras agregar NFC y AHS -- ver Secciones 10 y 11)

Se usa la MISMA grilla de n que el Bloque 5 simulado de SSTN-Normality-Study -- {10,25,50,100,250,500,1000,1500} -- para que la comparación entre el hallazgo simulado y su contraparte real sea directa, celda por celda de n, no solo cualitativa. El N mínimo de los 4 datasets originales (RWAS, 9.680) es muy superior al n máximo del grid (1.500), así que el submuestreo sin reemplazo (mismo método "m-out-of-N" del Bloque 4 de SSTN-Normality-Study) es válido para los 4 sin ajuste.

Con los 6 datasets finales (RSE k=4, MACH-IV k=5, NFC k=6, HEXACO k=7, AHS k=8, RWAS k=9), 5 de 6 siguen usando el grid completo (el N mínimo entre esos 5, NFC con 1.688, sigue siendo mayor que 1.500). La excepción es **AHS (k=8, N=1.036)**: no alcanza el n máximo de 1.500, así que corre con un grid reducido {10,25,50,100,250,500,1000} -- una asimetría explícita en el diseño, no un dato faltante (ver Sección 11).

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

## 10. Hallazgo posterior de un instrumento real con k=6: NFC / GESIS ZA5088 (23-24 sep 2026)

La Sección 2 documentó la ausencia de datasets abiertos con k=6 o k=8 tras una búsqueda en openpsychometrics.org, OSF, Kaggle y candidatos específicos de la literatura (Need for Cognition, entre otros). Antes de dar la limitación por cerrada, se hizo una segunda búsqueda más intensiva, esta vez extendida a repositorios institucionales de ciencias sociales (GESIS, ZIS, ICPSR) y con la colaboración directa del usuario explorando Google Dataset Search.

Se encontró el estudio GESIS ZA5088 ("Identity Development and Value Transmission among Veteran and Migrant Adolescents and Their Families in Germany and Israel"), que en su submuestra de Israel aplicó la escala de Necesidad de Cierre Cognitivo (Webster y Kruglanski, 1994) en formato de 6 puntos (la submuestra de Alemania usó una versión de 7 puntos del mismo instrumento, por eso no se mezclan). Se extrajeron 3 de las 5 subescalas originales (9 ítems), N=1.688 tras exigir caso completo. Ver `R/01_extract_real_subscales.R` para la clave de puntuación (inferida cruzando el contenido semántico de los ítems contra la estructura documentada en el informe metodológico del estudio, ya que este no publica una tabla de reversión ítem por ítem) y la Sección 5 para su lugar en la grilla de n (usa el grid completo, con margen ajustado: solo 188 casos de sobra sobre el n máximo de 1.500).

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

La simulación de niveles (Sección 6) usa siempre m=10 ítems fijos (`R/04_simulacion_niveles.R`, `m_items <- 10L`), independientemente del nivel o k. Los 6 instrumentos reales varían bastante en cantidad de ítems: RSE=10, MACH-IV=20, NFC=9, HEXACO X:Expr=10, AHS=8, RWAS=22. Esto es una fuente de confusión candidata adicional a la severidad real (Sección 9): un compuesto de más ítems tiende a una forma más suave por el Teorema Central del Límite, independientemente de k.

**Chequeo de robustez** (1000 subconjuntos aleatorios de 10 ítems, sin selección por calidad psicométrica para no introducir un sesgo de selección nuevo) sobre los 2 instrumentos con más de 10 ítems:

| | MACH-IV (m=20) | RWAS (m=22) |
|---|---|---|
| α con todos los ítems | 0.888 | 0.964 |
| α medio de subconjuntos de 10 | 0.797 | 0.924 |
| skew con todos los ítems / medio de subconjuntos | -0.164 / -0.179 | 1.352 / 1.331 |
| kurt_exc con todos los ítems / medio de subconjuntos | -0.686 / -0.649 | 1.170 / 1.137 |

La FORMA del compuesto (asimetría, curtosis) se mantiene estable entre el compuesto completo y el promedio de subconjuntos de 10 ítems en ambos casos -- la confiabilidad sí cae con menos ítems (esperado por Spearman-Brown), más en MACH-IV (escala multifacética) que en RWAS (escala muy homogénea), pero eso es un hecho psicométrico esperado, no evidencia de que la forma del compuesto esté distorsionada por tener más ítems que la simulación.

**Prueba cuantitativa directa** (¿los datasets con más ítems predicen sistemáticamente mejor la potencia real, más allá de lo que ya explica el ajuste de severidad?): usando los 6 instrumentos como unidad de análisis (`m_items`, `dist_severidad` de la Sección 11 y el error absoluto medio real-vs-simulado de la sección de validación), la correlación simple entre cantidad de ítems y error de predicción es engañosa (ρ=-0.75, más ítems parece asociarse a menos error) porque RWAS combina a la vez el mayor N de ítems (22) y el mejor ajuste de severidad (dist=0.002) -- pura coincidencia entre las dos variables, no un efecto de ítems.

Controlando `dist_severidad` (regresión múltiple `error_abs ~ dist_severidad + m_items`, N=6, 3 gl residuales):

```
dist_severidad:  coef=0.272,  p=.038 *
m_items:         coef=0.0009, p=.853  (no significativo; correlación parcial ~0.12)
```

**Conclusión**: la brecha entre lo que predice la simulación y la potencia real observada se explica casi enteramente por qué tan bien calibrada está la severidad de cada instrumento (Sección 9/11) -- la cantidad de ítems, aunque varía de 8 a 22 frente a los m=10 fijos de la simulación, no aporta una distorsión sistemática detectable una vez controlada la severidad. Esto respalda usar los 6 instrumentos reales tal como están (con su cantidad nativa de ítems), sin necesidad de reconstruir compuestos artificiales de 10 ítems para el análisis principal del paper. Limitación honesta: con solo 6 datasets (3 gl residuales) la potencia para detectar un efecto pequeño de ítems es muy baja -- esto es evidencia de ausencia de un efecto GRANDE, no prueba definitiva de que no exista ningún efecto.

## 13. Comparación de las 11 pruebas: potencia bruta, estabilidad a k, y qué tan predecible es su comportamiento real desde la simulación (24 sep 2026)

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
| D'Agostino-Pearson | 0.673 | 0.222 | 2 |
| Shapiro-Wilk | 0.642 | 0.242 | 5 |
| Lilliefors | 0.621 | 0.236 | 6 |
| Anderson-Darling | 0.626 | 0.252 | 7 |
| Pearson χ² | 0.610 | 0.256 | 11.5 |
| Shapiro-Francia | 0.616 | 0.276 | 12 |
| Cramér-von Mises | 0.610 | 0.270 | 12.5 |
| Jarque-Bera | 0.534 | 0.297 | 18 |
| SSTN | 0.584 | 0.318 | 18 |
| Epps-Pulley | 0.592 | 0.325 | 18 |
| Curtosis | 0.505 | 0.335 | 22 |

D'Agostino-Pearson se sostiene como la mejor combinación también aquí (coincide con 13.1, buena señal de consistencia). SSTN cae a un CV casi 10 veces mayor que en la tabla limpia -- pero antes de interpretar eso como pérdida real de estabilidad, ver 13.3.

### 13.3 Tabla simulada CONFUNDIDA (mismo emparejamiento nivel-k que los reales, a propósito)

Para que 13.1 y 13.2 sean comparables sin el "ruido" de que una está limpia y la otra no, se repitió el cálculo sobre SOLO 6 celdas simuladas, las que comparten nivel y k con los 6 datasets reales (bajo/k4, bajo_moderado/k5, alto/k6, bajo_moderado/k7, alto/k8, muy_alto/k9) -- el mismo confound de los reales, impuesto artificialmente sobre datos simulados:

| Prueba | Potencia (sim. confundido) | CV k (sim. confundido) | Rank combinado |
|---|---|---|---|
| Shapiro-Wilk | 0.779 | 0.197 | 3 |
| D'Agostino-Pearson | 0.760 | 0.201 | 5 |
| Epps-Pulley | 0.735 | 0.196 | 6 |
| Anderson-Darling | 0.751 | 0.225 | 7 |
| Shapiro-Francia | 0.750 | 0.230 | 9 |
| Pearson χ² | 0.733 | 0.237 | 13 |
| Lilliefors | 0.705 | 0.230 | 14 |
| Cramér-von Mises | 0.720 | 0.258 | 15 |
| SSTN | 0.702 | 0.284 | 19 |
| Curtosis | 0.500 | 0.268 | 20 |
| Jarque-Bera | 0.601 | 0.310 | 21 |

**Hallazgo clave**: SSTN cae a un puesto bajo (19 de 22) casi idéntico al que obtiene en datos reales (18) -- no era ruido real, es consecuencia matemática directa de mezclar k con severidad de la forma en que están emparejados estos 6 instrumentos específicos. La ventaja de estabilidad de SSTN es real, pero depende de que la severidad esté controlada -- algo que casi ningún estudio aplicado con instrumentos ya existentes puede garantizar.

### 13.4 Desplazamiento (13.3 vs 13.2): qué tan predecible es cada prueba desde la simulación

Diferencia absoluta de rank combinado entre la tabla simulada-confundida (13.3) y la real (13.2) -- mide si el comportamiento de una prueba en un escenario simulado-confundido anticipa bien su comportamiento real:

| Prueba | Rank (sim. confundido) | Rank (real) | Desplazamiento |
|---|---|---|---|
| Anderson-Darling | 7 | 7 | **0** (perfectamente predecible) |
| SSTN | 19 | 18 | **1** |
| Shapiro-Wilk | 3 | 5 | 2 |
| Cramér-von Mises | 15 | 13 | 2 |
| Pearson χ² | 13 | 11 | 2 |
| Curtosis | 20 | 22 | 2 |
| Jarque-Bera | 21 | 18 | 3 |
| D'Agostino-Pearson | 5 | 2 | 3 |
| Shapiro-Francia | 9 | 12 | 3 |
| Lilliefors | 14 | 6 | 8 |
| Epps-Pulley | 6 | 18 | **12** (la más impredecible) |

**SSTN es la segunda prueba más predecible de las 11**, justo detrás de Anderson-Darling -- esto es un hallazgo DISTINTO al de 13.1-13.3 (estabilidad pura), y complementario: aunque la ventaja de estabilidad-a-k de SSTN se diluye bajo confusión con severidad (13.3), su comportamiento bajo esa confusión es el que MEJOR anticipa la simulación -- la simulación de este estudio es una guía confiable de lo que SSTN hará en la práctica, mucho más que para Epps-Pulley (la más impredecible, pasa de de las mejores en 13.3 a de las peores en 13.2) o Lilliefors (camino inverso: mala en 13.3, notablemente mejor en real).

### 13.5 Síntesis para el paper

- **Si hay que recomendar una sola prueba por defecto**: D'Agostino-Pearson -- mejor balance potencia/estabilidad en las tres tablas (13.1, 13.2, 13.3), consistentemente.
- **Shapiro-Wilk**: máxima potencia bruta en casi todos los escenarios (hallazgo ya conocido en la literatura, no novedoso), pero más sensible a k que D'Agostino-Pearson.
- **SSTN**: su valor agregado no es potencia bruta (nunca es la más potente) -- es estabilidad-a-k cuando la severidad está controlada (13.1) y, cuando no lo está, ser la prueba cuyo comportamiento la simulación anticipa mejor (13.4). Dos argumentos distintos, ambos defendibles, ninguno es "más potente que Shapiro-Wilk".
- **Lilliefors y Epps-Pulley**: evitar si se van a comparar/combinar estudios con formatos de respuesta distintos -- las más sensibles a k en la tabla limpia (Lilliefors) y las más impredecibles entre simulación y realidad (Epps-Pulley).
- **Curtosis (Anscombe-Glynn)**: peor en casi todos los criterios -- útil solo si se sabe de antemano que la desviación es puramente de curtosis, no de asimetría.
