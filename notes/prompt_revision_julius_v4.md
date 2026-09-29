# Prompt para revisión externa (ronda 5 — respuesta a los 12 puntos sobre Tabla 6, umbral de referencia con m=10 ítems, y lenguaje inferencial)

Actúa como revisor(a) por pares de la revista *Methodology* (PsychOpen GOLD, Scopus Q1, JCR IF 1.7). Te adjunto el manuscrito completo (PDF), ya revisado en cuatro rondas externas anteriores. Necesito una revisión crítica, específica y honesta — no un resumen ni una validación general. Esta ronda responde a una revisión previa de 12 puntos; quiero saber si las correcciones resolvieron el problema o solo lo desplazaron a otro lugar del texto.

## Contexto del estudio

El estudio evalúa cómo interactúan (a) la cantidad de categorías de respuesta de una escala Likert (*k*, de 3 a 9), (b) el tamaño de muestra (*n*) y (c) la severidad real de la no-normalidad del constructo medido, sobre la potencia comparada de una batería de 11 pruebas de normalidad. Combina un **bloque simulado** (5 niveles de severidad cruzados con *k* y *n*, 280 celdas, R=10.000 réplicas, mismo mecanismo generativo de $m=10$ ítems en todas las celdas) y un **bloque de datos reales** (6 instrumentos psicométricos con *k* nativo de 4 a 9 y entre 8 y 22 ítems, submuestreo m-out-of-N repetido). Bajo el criterio nominal ($p<.05$) la potencia decae levemente con *k*; corrigiendo el umbral de decisión por descalibración inducida por la discreción del compuesto (tamaño ajustado a un DGP de referencia específico, no a la normalidad matemática), el patrón se invierte: la potencia ajustada es mayor en *k* grande que en *k* chico, con un mínimo local no explicado en *k*=7.

## Qué cambió desde la última ronda (esto es lo que más necesito que revises)

La ronda anterior encontró que, pese a una reescritura previa centrada en precisión terminológica, quedaban puntos sin resolver: la Tabla 6 seguía llamando "potencia" a un escenario real donde el H0 verdadero es desconocido; el umbral de referencia aplicado al bloque real se calibra con un DGP simulado de $m=10$ ítems fijos sin conectar esa discrepancia (los instrumentos reales tienen 8-22 ítems) con la validez de la corrección; la frase "bajo esa H0" reintroducía la ambigüedad conceptual que ya se había corregido en otro lugar; los p-valores de una regresión con las 11 pruebas como pseudo-réplicas se reportaban con lenguaje inferencial pese a una advertencia de que no lo eran; "la corrección no es un artefacto" sobreinterpretaba lo que $N=6$ permite decir; "la potencia aumenta con k" sonaba más monotónico de lo que el propio texto reconoce (mínimo en k=7); y dos oraciones habían quedado telegráficas por recortes de presupuesto de palabras anteriores.

Se hicieron estos cambios:

1. **Tabla 6 y su sección**: título, caption y las 4 viñetas ya no dicen "potencia" para el escenario Real; ahora "valor medio bajo el umbral ajustado", con el texto de alrededor aclarando que el escenario Real es tasa de rechazo. Revisa si esta distinción quedó clara sin que la tabla en sí (que solo tiene tres columnas numéricas sin etiqueta de unidad por columna) induzca a un lector a promediar o comparar directamente potencia con tasa como si fueran la misma magnitud.
2. **Nueva limitación explícita sobre el número de ítems**: el manuscrito ahora dice, en tres lugares (Método/bloque real, Resultados/bloque real, Discusión/Limitaciones), que el umbral aplicado a los 6 instrumentos reales viene de un DGP calibrado con $m=10$ ítems fijos, mientras esos instrumentos tienen entre 8 y 22. ¿Repetirlo en tres lugares comunica bien la gravedad del punto, o diluye el mensaje porque en ningún lugar se cuantifica cuánto podría cambiar el resultado si se recalibrara por número de ítems?
3. **"Bajo ese DGP de referencia" reemplaza "bajo esa H0"**: revisa si queda alguna mención residual de "H0" que reintroduzca la idea de que se calibró contra la normalidad matemática en vez de contra el DGP discreto específico del estudio.
4. **Los p-valores de la sección de "patrones" fueron eliminados del texto** (antes se reportaban con una advertencia de que no eran inferencia formal; ahora los 4 patrones se describen solo por dirección/magnitud, sin cifras de p). ¿Este cambio resolvió el problema sin sacrificar demasiada información? Un revisor podría ahora preguntar por qué no se reportan los p-valores en absoluto si el código los calcula.
5. **"La corrección no es un artefacto del bloque simulado" se matizó** a una formulación sobre concordancia descriptiva que "no depende solo de las celdas repetidas dentro de instrumento". ¿Este matiz es suficiente, o sigue sonando a una conclusión más fuerte de lo que $N=6$ instrumentos permite?
6. **"Aumenta con k" se reformuló como comparación de extremos** ($k=9$ vs. $k=3$) en vez de una tendencia monotónica, en las mismas oraciones donde antes decía "aumenta". ¿Esta reformulación es consistente en todo el manuscrito, o hay algún lugar donde todavía se implica monotonicidad perfecta?

## Un punto específico de riesgo: presupuesto de palabras extremadamente ajustado

Después de cuatro rondas de recortes acumulados, el manuscrito quedó en 4.780 palabras de cuerpo + 1.205 de referencias = 5.985 de 6.000 --solo 15 palabras de margen--. Marca con prioridad cualquier oración que se sienta comprimida, ambigua, o que haya perdido un matiz importante; es más probable que el problema esté ahí que en el contenido nuevo.

## Qué NO hace falta que revises

Los puntos ya resueltos en rondas anteriores (terminología de "patrones" vs. "hipótesis", justificación del submuestreo m-out-of-N, calibración de λ libre + umbrales, formato APA 7, la anomalía de *k*=7, la definición del método de corrección por tamaño, la distinción potencia/tasa fuera de la Tabla 6) ya se verificaron; no los señales de nuevo salvo que esta ronda haya introducido una inconsistencia nueva con ellos.

## Formato de respuesta que necesito

Para cada hallazgo: **ubicación** (sección o cita textual corta), **problema específico**, **por qué importa**, y **sugerencia concreta de corrección**. Ordena los hallazgos de mayor a menor severidad. Si algo está bien resuelto y no necesita cambios, no lo menciones.

No hagas un resumen del estudio ni elogios generales; asume que ya conozco el contenido y quiero encontrar los puntos débiles antes de que lo encuentre un revisor real.
