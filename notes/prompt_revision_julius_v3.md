# Prompt para revisión externa (ronda 4 — respuesta a los 16 puntos de precisión terminológica)

Actúa como revisor(a) por pares de la revista *Methodology* (PsychOpen GOLD, Scopus Q1, JCR IF 1.7). Te adjunto el manuscrito completo (PDF), ya revisado en tres rondas externas anteriores. Necesito una revisión crítica, específica y honesta — no un resumen ni una validación general. Esta ronda responde a una revisión previa de 16 puntos centrada en precisión terminológica y alcance metodológico; quiero saber si esas correcciones realmente resolvieron el problema o si solo lo reformularon con otras palabras.

## Contexto del estudio

El estudio evalúa cómo interactúan (a) la cantidad de categorías de respuesta de una escala Likert (*k*, de 3 a 9), (b) el tamaño de muestra (*n*) y (c) la severidad real de la no-normalidad del constructo medido, sobre la potencia comparada de una batería de 11 pruebas de normalidad. Combina un **bloque simulado** (5 niveles de severidad cruzados con *k* y *n*, 280 celdas, R=10.000 réplicas) y un **bloque de datos reales** (6 instrumentos psicométricos con *k* nativo de 4 a 9, submuestreo m-out-of-N repetido). Bajo el criterio nominal ($p<.05$) la potencia decae levemente con *k*; corrigiendo el umbral de decisión por descalibración inducida por la discreción del compuesto (tamaño ajustado a un DGP de referencia específico, no a la normalidad matemática), el patrón se invierte: la potencia con tamaño ajustado aumenta con *k*, confirmado de forma independiente en el bloque simulado y en el bloque real.

## Qué cambió desde la última ronda (esto es lo que más necesito que revises)

La ronda anterior señaló que el manuscrito sobreclamaba en varios puntos: llamaba "potencia genuina"/"normalidad genuina" a algo que en rigor es tamaño ajustado a un DGP de referencia discreto, no a la normalidad matemática; trataba la tasa de rechazo del bloque real como si fuera potencia identificada en sentido estricto (cuando el H0 verdadero de cada instrumento real es desconocido); usaba los p-valores de una regresión con las 11 pruebas como pseudo-réplicas como si fueran inferencia formal independiente; y presentaba el $r=.977$ de validación real-vs-simulado sin advertir que esas 47 celdas comparten instrumento (solo 6 unidades genuinamente independientes).

Se hicieron los siguientes cambios:

1. **Terminología separada**: ahora el manuscrito distingue explícitamente "potencia corregida" (bloque simulado, donde el H0 es conocido por diseño) de "tasa corregida" o "tasa de rechazo ajustada" (bloque real, donde no se conoce el H0 verdadero de cada instrumento). Revisa si esta distinción se aplica de forma consistente en todo el texto —abstract, Resultados, Discusión, captions de tablas— o si en algún punto se mezclan otra vez.
2. **Reframing de los p-valores de "patrones"**: la sección que compara los patrones del bloque simulado contra los 6 instrumentos reales ahora dice explícitamente que los p-valores reportados (de una regresión que trata las 11 pruebas como pseudo-réplicas dentro de cada nivel) son "descriptivos, no inferencia formal", con una advertencia de que esas pruebas comparten la misma muestra. ¿Ese único aviso al inicio de la sección es suficiente, o los bullets que siguen (con "$p<.001$", "coeficiente positivo", etc.) todavía se leen como si fueran resultados inferenciales formales pese a la advertencia?
3. **Validación agregada por instrumento**: se agregó un segundo cálculo de la correlación real-vs-simulado, promediando primero por instrumento (*N*=6 unidades independientes, $r=.980$), presentado junto al $r=.977$ original de las 47 celdas no independientes. ¿Esta forma de presentarlo dos números uno junto al otro comunica bien que la concordancia no depende de tratar celdas no independientes como si lo fueran, o crea la impresión de que se están inflando los resultados con una segunda cifra similar?
4. **Matices de alcance metodológico**: se suavizaron frases como "el diseño aísla k" (ahora aclara que solo iguala asimetría/curtosis, no la forma distribucional completa), "el bloque real confirma la reversión" (ahora "es consistente con"), "Pearson $\chi^2$ es la peor en cualquier escenario" (ahora "tiene la menor potencia media en los tres escenarios agregados, no necesariamente en cada condición individual") y "no reducir categorías por debajo de cuatro" (ahora una recomendación más general de evitar escalas con muy pocas categorías). ¿Estos matices logran el objetivo sin volver la prosa ambigua o evasiva?
5. **Reconocimiento de irregularidades**: se agregó que la brecha corregida no crece de forma monótona con *n* (hay retrocesos puntuales), y que la tasa corregida de SPS-10 y AHS *decrece* en los tamaños de muestra más grandes (contraintuitivo, sin explicación causal). ¿Estas admisiones están en el lugar correcto del texto y con el peso adecuado, o quedan enterradas entre otros resultados?

## Un punto específico de riesgo: presupuesto de palabras

Para incorporar todos los cambios anteriores dentro del límite de 6.000 palabras de *Methodology*, se recortó agresivamente en Introducción, Resultados y Discusión (el manuscrito quedó en 5.972 palabras, con solo ~28 de margen). Esto incluyó fusionar los párrafos de heterogeneidad por país y por sexo en uno solo, y acortar varios títulos de subsección. Marca específicamente cualquier oración que haya quedado telegráfica, ambigua, o que perdiera un matiz importante por este recorte —este es el riesgo más probable de esta ronda, más que un error de contenido nuevo.

## Qué NO hace falta que revises

Los puntos ya resueltos en rondas anteriores (terminología de "patrones" vs. "hipótesis", justificación del submuestreo m-out-of-N, calibración de λ libre + umbrales, formato APA 7, la explicación de la anomalía de *k*=7, la definición original del método de corrección por tamaño) ya se verificaron; no los señales de nuevo salvo que esta ronda de ediciones haya introducido una inconsistencia nueva con ellos.

## Formato de respuesta que necesito

Para cada hallazgo: **ubicación** (sección o cita textual corta), **problema específico**, **por qué importa**, y **sugerencia concreta de corrección**. Ordena los hallazgos de mayor a menor severidad. Si algo está bien resuelto y no necesita cambios, no lo menciones.

No hagas un resumen del estudio ni elogios generales; asume que ya conozco el contenido y quiero encontrar los puntos débiles antes de que lo encuentre un revisor real.
