# Prompt para revisión externa (ronda 3 — versión con potencia corregida por tamaño)

Actúa como revisor(a) por pares de la revista *Methodology* (PsychOpen GOLD, Scopus Q1, JCR IF 1.7). Te adjunto el manuscrito completo (PDF), ya revisado en dos rondas externas anteriores. Necesito una revisión crítica, específica y honesta — no un resumen ni una validación general. Esta versión tiene un cambio sustancial respecto a las anteriores: el hallazgo central se invirtió.

## Contexto del estudio

El estudio evalúa cómo interactúan (a) la cantidad de categorías de respuesta de una escala Likert (*k*, de 3 a 9), (b) el tamaño de muestra (*n*) y (c) la severidad real de la no-normalidad del constructo medido, sobre la potencia comparada de una batería de 11 pruebas de normalidad. Combina dos componentes:
- Un **bloque simulado**: 5 niveles de severidad (anclados a percentiles de Cain et al., 2017) cruzados con *k*=3–9 y *n*, con *k* y severidad manipulados de forma ortogonal (280 celdas, R=10.000 réplicas cada una).
- Un **bloque de datos reales**: 6 instrumentos psicométricos de acceso abierto con *k* nativo de 4 a 9, sometidos a submuestreo m-out-of-N repetido (R=10.000), donde *k* no se manipula y va entrelazado con la severidad real de cada instrumento.

Incluye además dos chequeos de robustez post-hoc (submuestras EE.UU. vs. resto del mundo, y hombres vs. mujeres, ambos a *n*=250) para evaluar si la heterogeneidad composicional de los datos reales infla la potencia observada de forma independiente a *k*.

## Qué cambió desde la última ronda (esto es lo que más necesito que revises)

Una revisión externa previa notó que 8 de las 11 pruebas de normalidad rechazan hasta 100% de las veces bajo normalidad genuina cuando *k* es chico y *n* es grande — no porque detecten severidad real, sino porque detectan la discreción propia del compuesto. Esto significaba que el hallazgo original ("menos categorías, más potencia", con brecha nominal de +.012 a +.045) estaba contaminado por descalibración, no solo por potencia genuina.

Para corregir esto se recalibró el umbral de decisión de cada prueba de forma empírica: en vez de usar *p*<.05, se usa el percentil 5 de la distribución de *p*-valores de esa prueba bajo un nivel de referencia normal (mismo *k*, mismo *n*), que por construcción da exactamente 5% de rechazo bajo H0 para este mecanismo discreto específico. Con ese umbral corregido, la brecha **se invierte y crece con *n*** (de −.15 a −.37 en los 5 niveles simulados; confirmado de forma independiente en los 6 instrumentos reales, con RSE/HEXACO cayendo de potencia nominal ≈1.000 a potencia corregida ≈.27–.28).

Puntos específicos a evaluar sobre este cambio:

1. **Validez del método de corrección**: ¿recalibrar el umbral vía percentil 5 empírico bajo el nivel "normal" (en vez de usar *p*<.05 nominal) es la forma correcta de aislar potencia genuina de descalibración por discreción? ¿Es esto equivalente a "size-corrected power" tal como se usa en la literatura de pruebas de hipótesis, o falta algo?
2. **Honestidad de la reversión**: el manuscrito ahora reporta una conclusión opuesta a una versión anterior. ¿La transición entre el hallazgo nominal y el corregido está explicada con suficiente claridad y sin minimizar cuánto cambia la conclusión práctica del estudio?
3. **La anomalía de *k*=7**: hay un mínimo local no monótono en *k*=7 (bloque simulado y HEXACO, único instrumento real con ese *k*), investigado pero sin explicación causal definitiva (se atribuye tentativamente a que calibrar solo 2 momentos no fija de forma única la forma completa de la distribución). ¿Esta forma de reportarlo —como limitación honesta en vez de forzar una narrativa monótona— es adecuada, o un revisor real la penalizaría más de lo que el manuscrito asume?
4. **Proporcionalidad de las afirmaciones**: revisa cada número reportado en Resultados 3.1–3.5 y Discusión bajo el criterio corregido — ¿la interpretación (ej. "se reproduce", "no concluyente") es proporcional a la evidencia mostrada (tamaños de efecto, *p*, correlaciones)?
5. **Claridad tras el recorte de presupuesto de palabras**: varios párrafos de Resultados y Discusión se recortaron agresivamente para mantener el límite de 6.000 palabras de *Methodology*. Marca cualquier oración que haya quedado telegráfica, ambigua, o que perdiera un matiz importante por el recorte.
6. **Consistencia entre potencia nominal y corregida**: el manuscrito reporta ambas en varias tablas (p. ej. Tabla de potencia por instrumento, con filas "nom." y "corr." por instrumento). ¿Esa presentación en paralelo es clara, o genera confusión sobre cuál es la cifra que respalda las conclusiones del estudio?
7. **Limitaciones no declaradas**: dado que país/sexo (heterogeneidad composicional) se evaluaron solo con potencia nominal y no se repitieron con el umbral corregido (declarado como limitación), ¿hay alguna otra sección que debería llevar la misma advertencia y no la lleva?

## Qué NO hace falta que revises

Los puntos ya resueltos en las dos rondas anteriores (terminología de "patrones" vs. "hipótesis", justificación del submuestreo m-out-of-N, calibración de λ libre + umbrales, formato APA 7, prosa de las secciones de Método no tocadas en esta reescritura) ya se verificaron; no los señales de nuevo salvo que la reescritura de Resultados/Discusión haya introducido una inconsistencia nueva con ellos.

## Formato de respuesta que necesito

Para cada hallazgo: **ubicación** (sección o cita textual corta), **problema específico**, **por qué importa**, y **sugerencia concreta de corrección** (no solo señalar el problema). Ordena los hallazgos de mayor a menor severidad (los que un revisor real usaría para rechazar o pedir revisión mayor, primero). Si algo está bien resuelto y no necesita cambios, no lo menciones.

No hagas un resumen del estudio ni elogios generales; asume que ya conozco el contenido y quiero encontrar los puntos débiles antes de que lo encuentre un revisor real.
