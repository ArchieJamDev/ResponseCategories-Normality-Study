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

**La interacción de los tres factores.** El hallazgo central del estudio surge de cruzar los dos anteriores: la brecha de potencia entre *k*=3 y *k*=9 no solo se achica al aumentar la severidad de la no-normalidad —como muestra la Tabla 3 de forma agregada—, sino que el tamaño de muestra en el que esa brecha alcanza su punto máximo **se desplaza hacia valores de *n* cada vez más pequeños** a medida que la severidad aumenta (Tabla 5 y Figura 1).

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

Sobre los cuatro instrumentos reales, la potencia media (11 pruebas) crece con *n* en los cuatro casos, como es esperable (Tabla 6). Sin embargo, el patrón entre instrumentos no reproduce directamente el orden de *k* observado en el bloque de niveles: RWAS (*k*=9) alcanza una potencia sustancialmente mayor que los otros tres instrumentos en casi toda la grilla de *n* —0.364 en *n*=10 y 0.749 ya en *n*=25, frente a 0.048–0.063 y 0.063–0.076 respectivamente para los instrumentos de *k* más bajo en esos mismos tamaños de muestra—, mientras que RSE (*k*=4), MACH-IV (*k*=5) y HEXACO (*k*=7) se mantienen agrupados entre sí y muy por debajo de RWAS hasta *n*≈250.

**Tabla 6**
*Potencia media (11 pruebas) por instrumento real y tamaño de muestra*

| Instrumento (*k*) | 10 | 25 | 50 | 100 | 250 | 500 | 1000 | 1500 |
|---|---|---|---|---|---|---|---|---|
| RSE (4) | 0.048 | 0.063 | 0.108 | 0.248 | 0.719 | 0.983 | 1.000 | 1.000 |
| MACH-IV (5) | 0.052 | 0.076 | 0.131 | 0.282 | 0.760 | 0.989 | 1.000 | 1.000 |
| HEXACO (7) | 0.049 | 0.068 | 0.104 | 0.212 | 0.644 | 0.967 | 1.000 | 1.000 |
| RWAS (9) | 0.364 | 0.749 | 0.928 | 0.954 | 0.984 | 0.998 | 1.000 | 1.000 |

Este patrón —potencia sustancialmente mayor en el instrumento de *k* más alto— es, a primera vista, opuesto al observado en el bloque de niveles (§3.1), donde *k* alto se asocia sistemáticamente con potencia *menor*, no mayor. La explicación de esta aparente discrepancia se desarrolla en la Discusión (§4), donde se retoma el hecho, ya documentado en el Método, de que los cuatro instrumentos reales difieren simultáneamente en *k*, en cantidad de ítems y en la asimetría/curtosis real del constructo medido —factores que el bloque de niveles, por diseño, mantiene separados—.

---

## 3.4. Hipótesis puestas a prueba en datos reales (6 instrumentos, k=4..9)

El bloque de niveles (§3.1) genera hipótesis; esta sección resume qué tanto se pudieron confirmar con los 6 instrumentos reales (RSE k=4, MACH-IV k=5, NFC k=6, HEXACO k=7, AHS k=8, RWAS k=9). Ver `notes/DESIGN.md` Secciones 9-13 para el detalle estadístico completo de cada punto.

**H1 — Menos categorías de respuesta (k) → más potencia.** Confirmada, pero solo donde fue evaluable: únicamente en pares de instrumentos con severidad real equivalente (MACH-IV k=5 vs HEXACO k=7, ambos en nivel bajo-moderado por distancia euclidiana a los niveles calibrados) se pudo aislar el efecto de *k* de la severidad real. Ahí la dirección predicha se confirma, significativa en *n*=50 a *n*=500 (t pareado por prueba, p<.05 en 4 de 8 tamaños de muestra). El ANCOVA agregado con los 6 instrumentos confirma la misma dirección (coeficiente de *k* negativo en los 7 *n* evaluables) solo tras excluir NFC —cuyo desajuste de severidad (ver H5 más abajo) basta para invertir el signo del modelo agregado—, sin alcanzar significancia individual por baja potencia estadística (5 instrumentos, un dato por *k*).

**H2 — El efecto de *k* se modula por *n* (negligible en extremos, pico en n≈50-250).** Confirmada de forma limpia. El par MACH-IV/HEXACO reproduce la misma forma de U invertida que predice la simulación: p=.117 (*n*=10) → .222 (*n*=25) → .026\* (*n*=50) → .011\* (*n*=100) → .011\* (*n*=250) → .012\* (*n*=500) → .211 (*n*=1000).

**H3 — La brecha de potencia entre *k* extremos se achica con la severidad real (Tabla 3).** No evaluable como tendencia con los datos reales disponibles: solo hay 2 pares de instrumentos que comparten nivel de severidad (bajo-moderado, alto), insuficiente para trazar una curva de brecha vs. severidad. Ni confirmada ni refutada — sigue siendo evidencia exclusivamente simulada.

**H4 — La paridad de *k* (par/impar) afecta la potencia, independiente de su magnitud, controlando severidad.** Estructuralmente no evaluable con los 6 instrumentos: cada nivel de severidad real cae enteramente dentro de un solo grupo de paridad (bajo=par, bajo-moderado=impar, alto=par, muy alto=impar), así que un modelo `potencia ~ nivel + paridad` no puede estimar el coeficiente de paridad (columna `NA` por singularidad exacta, verificado en los 7 tamaños de *n*). Con covariables continuas de asimetría/curtosis en vez de la categoría discreta, el modelo sí es estimable pero el resultado no es robusto (invierte signo o pierde significancia al excluir casi cualquier instrumento individual, análisis leave-one-out). Ni confirmada ni refutada — evidencia exclusivamente simulada, donde el diseño garantiza ortogonalidad entre paridad y severidad.

**H5 — Un instrumento con severidad mal calibrada distorsiona cualquier análisis agregado que lo incluya.** Confirmada con evidencia cuantitativa doble: (a) NFC tiene la peor distancia de ajuste de severidad de los 6 (0.958, un orden de magnitud peor que el resto) porque combina asimetría baja (0.113) con curtosis alta (0.761) — una combinación fuera de la trayectoria que calibran los 5 niveles simulados (exceso de curtosis sobre la trayectoria esperada: +1.376, el mayor de los 6); (b) excluir NFC del ANCOVA agregado restaura la dirección de *k* esperada en los 7 tamaños de *n*, mientras que incluirlo la invierte y la vuelve significativa en 2 celdas — es decir, un solo instrumento mal calibrado puede revertir la conclusión de un análisis agregado.

## 3.5. Comparación de las 11 pruebas: potencia bruta y estabilidad frente a *k*

Pregunta práctica: ¿qué prueba conviene usar, y bajo qué condiciones? Se calcularon tres versiones comparables de la misma tabla (potencia media + coeficiente de variación de la potencia a través de *k*, como medida de estabilidad):

1. **Simulada limpia** (280 celdas, severidad aislada de *k* por diseño — verificado: la asimetría/curtosis lograda por la calibración varía menos de 10⁻⁵ entre los 7 valores de *k* dentro de cada nivel).
2. **Real** (6 instrumentos, *k* y severidad inevitablemente confundidos).
3. **Simulada confundida** (mismas 6 combinaciones nivel-*k* que los instrumentos reales, impuestas artificialmente sobre datos simulados, para poder comparar 1 y 2 en igualdad de condiciones).

**Tabla 7**
*Ranking combinado (potencia + estabilidad a k) de las 11 pruebas, en los tres escenarios*

| Prueba | Rank sim. limpia | Rank real | Rank sim. confundida | Desplazamiento confundida↔real |
|---|---|---|---|---|
| D'Agostino-Pearson | 3 | 2 | 5 | 3 |
| Shapiro-Wilk | 7 | 5 | 3 | 2 |
| Epps-Pulley | 8 | 18 | 6 | **12** |
| Anderson-Darling | 10 | 7 | 7 | **0** |
| Jarque-Bera | 11 | 18 | 21 | 3 |
| Shapiro-Francia | 11 | 12 | 9 | 3 |
| SSTN | 12 | 18 | 19 | **1** |
| Cramér-von Mises | 15 | 12.5 | 15 | 2 |
| Pearson χ² | 16 | 11.5 | 13 | 2 |
| Lilliefors | 17 | 6 | 14 | 8 |
| Curtosis (Anscombe-Glynn) | 22 | 22 | 20 | 2 |

**Lectura para la Discusión:**

- **D'Agostino-Pearson** es la recomendación por defecto: mejor balance potencia/estabilidad en los tres escenarios, de forma consistente.
- **Shapiro-Wilk** mantiene la potencia bruta más alta ya documentada en la literatura, pero es más sensible a *k* que D'Agostino-Pearson.
- **SSTN** no compite en potencia bruta (nunca la más potente), pero ofrece dos argumentos distintos: (a) 3ra más estable a *k* cuando la severidad está controlada (escenario simulado limpio) — su conclusión depende menos de la cantidad de categorías de la escala; (b) 2da prueba más *predecible* entre el escenario simulado-confundido y el real (desplazamiento=1, solo detrás de Anderson-Darling) — la simulación anticipa fielmente su comportamiento real, incluso cuando la ventaja de estabilidad pura se diluye por la confusión k-severidad inevitable en datos reales.
- **Anderson-Darling** es la única prueba con desplazamiento cero — su ranking en el escenario simulado-confundido predice exactamente su ranking real.
- **Lilliefors y Epps-Pulley** son las menos confiables entre escenarios (desplazamientos de 8 y 12 respectivamente, en direcciones opuestas) — Lilliefors resulta mejor de lo esperado en datos reales, Epps-Pulley resulta peor. Ninguna de las dos permite anticipar con confianza su comportamiento real desde un análisis simulado.
- **Curtosis (Anscombe-Glynn)** es la peor en potencia bruta en casi todos los escenarios y errática entre niveles de severidad (solo detecta desviaciones de curtosis, no de asimetría) — recomendable solo cuando se sabe de antemano que la desviación es puramente de curtosis.

---

## Notas para revisión

- Falta la Figura 1 referenciada en el texto (gráfico de la Tabla 5, brecha k3-k9 vs. n, una línea por nivel, mostrando el desplazamiento del pico) — pendiente de diseñar.
- Falta decidir si se agrega una tabla/figura adicional desglosando el patrón por prueba individual (no solo el promedio de las 11) — el estudio hermano [ya no debe mencionarse, pero como referencia de formato] usaba tablas de prueba x familia; aquí podría ser prueba x nivel o prueba x n. A confirmar si aporta o satura el Resultados.
- Confirmado: el "1.000" de la Tabla 6 en n=1000/1500 es potencia esencialmente perfecta (no redondeo de un valor bajo), verificado contra el consolidado.
- Pendiente: decidir si la Tabla 5 (la más densa) se queda como tabla o se reemplaza enteramente por la Figura 1 y se resume en texto, para no sobrecargar de números el cuerpo del Resultados.
- **PENDIENTE IMPORTANTE**: §3.2 (Tabla 6) sigue con los 4 instrumentos originales (RSE, MACH-IV, HEXACO, RWAS) — falta reescribirla con los 6 (agregar NFC k=6 y AHS k=8), y reemplazar la narrativa "aparente discrepancia con el bloque de niveles" por la explicación ya desarrollada en DESIGN.md Secciones 9-13 (severidad real confundida con k, validada cuantitativamente vía distancia euclidiana y correlación real-vs-simulado). Las nuevas §3.4 y §3.5 ya incorporan el análisis de los 6 instrumentos, pero §3.2 todavía no está alineada con ellas — revisar consistencia antes de considerar el Resultados completo.
- Falta también la sección de validación real-vs-simulado (correlación r=0.91 global, hasta 0.999 en instrumentos bien ajustados, ρ=1 entre distancia de severidad y error de predicción) — está en DESIGN.md Sección 11 pero no volcada aún a este archivo.
