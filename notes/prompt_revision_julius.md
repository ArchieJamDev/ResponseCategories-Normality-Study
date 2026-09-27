# Prompt para revisión con Julius AI

Actúa como revisor(a) por pares de la revista *Methodology* (PsychOpen GOLD, Scopus Q1, JCR IF 1.7). Te adjunto el manuscrito completo (PDF) de un estudio Monte Carlo. Necesito una revisión crítica, específica y honesta — no un resumen ni una validación general.

## Contexto del estudio

El estudio evalúa cómo interactúan (a) la cantidad de categorías de respuesta de una escala Likert (*k*, de 3 a 9), (b) el tamaño de muestra (*n*) y (c) la severidad real de la no-normalidad del constructo medido, sobre la potencia comparada de una batería de 11 pruebas de normalidad. Combina dos componentes:
- Un **bloque simulado**: 5 niveles de severidad (anclados a percentiles de Cain et al., 2017) cruzados con *k*=3–9 y *n*, con *k* y severidad manipulados de forma ortogonal (280 celdas, R=10.000 réplicas cada una).
- Un **bloque de datos reales**: 6 instrumentos psicométricos de acceso abierto con *k* nativo de 4 a 9, sometidos a submuestreo m-out-of-N repetido (R=10.000), donde *k* no se manipula y va entrelazado con la severidad real de cada instrumento.

Incluye además dos chequeos de robustez post-hoc (submuestras EE.UU. vs. resto del mundo, y hombres vs. mujeres, ambos a *n*=250) para evaluar si la heterogeneidad composicional de los datos reales infla la potencia observada de forma independiente a *k*.

## Qué necesito que revises

1. **Validez metodológica del diseño simulado**: ¿la calibración de λ libre + umbrales vía Nelder-Mead, y el anclaje a percentiles de Cain et al. (2017), es una estrategia defendible? ¿Hay algún supuesto no declarado o salto lógico?
2. **Validez del bloque real**: ¿el submuestreo m-out-of-N sin reemplazo está bien justificado dado que *N* > *n* máximo en 5 de 6 instrumentos? ¿La excepción de AHS (grilla reducida) está bien resuelta?
3. **Solidez estadística de las afirmaciones**: revisa cada número reportado en Resultados y Discusión — ¿la interpretación que se le da (ej. "se reproduce", "no concluyente") es proporcional a la evidencia mostrada (tamaños de efecto, *p*, correlaciones)? Señala cualquier sobreinterpretación o afirmación más fuerte de lo que los datos permiten.
4. **Terminología y consistencia**: el estudio evita deliberadamente llamar "hipótesis" a los patrones puestos a prueba en datos reales (para no sugerir preregistro), usando en cambio "patrones" y "se reproduce/no se reproduce". ¿Esa elección de lenguaje es clara y se sostiene sin ambigüedad en todo el texto, o en algún punto se vuelve confusa o inconsistente?
5. **Claridad de la prosa**: marca cualquier oración difícil de seguir, con sujeto ambiguo, o que mezcle dos ideas distintas en una sola frase (ya se corrigieron varias así, pero puede haber más).
6. **Cumplimiento de APA 7ma edición**: formato de citas, tablas, figuras, nivel de encabezados.
7. **Limitaciones no declaradas**: ¿hay alguna limitación importante del diseño o del análisis que el manuscrito no reconozca?

## Formato de respuesta que necesito

Para cada hallazgo: **ubicación** (sección o cita textual corta), **problema específico**, **por qué importa**, y **sugerencia concreta de corrección** (no solo señalar el problema). Ordena los hallazgos de mayor a menor severidad (los que un revisor real usaría para rechazar o pedir revisión mayor, primero). Si algo está bien resuelto y no necesita cambios, no lo menciones — enfócate solo en lo que requiere atención.

No hagas un resumen del estudio ni elogios generales; asume que ya conozco el contenido y quiero encontrar los puntos débiles antes de que lo encuentre un revisor real.
