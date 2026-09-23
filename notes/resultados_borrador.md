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

## Notas para revisión

- Falta la Figura 1 referenciada en el texto (gráfico de la Tabla 5, brecha k3-k9 vs. n, una línea por nivel, mostrando el desplazamiento del pico) — pendiente de diseñar.
- Falta decidir si se agrega una tabla/figura adicional desglosando el patrón por prueba individual (no solo el promedio de las 11) — el estudio hermano [ya no debe mencionarse, pero como referencia de formato] usaba tablas de prueba x familia; aquí podría ser prueba x nivel o prueba x n. A confirmar si aporta o satura el Resultados.
- Confirmado: el "1.000" de la Tabla 6 en n=1000/1500 es potencia esencialmente perfecta (no redondeo de un valor bajo), verificado contra el consolidado.
- Pendiente: decidir si la Tabla 5 (la más densa) se queda como tabla o se reemplaza enteramente por la Figura 1 y se resume en texto, para no sobrecargar de números el cuerpo del Resultados.
