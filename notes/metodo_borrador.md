# Método (borrador v1) — segundo paper

Prosa continua, sin marcado LaTeX de plantilla todavía. Numeración de subsecciones provisional (2.1, 2.2...), a ajustar cuando se una con la plantilla real.

---

## 2.1. Diseño general

El estudio combina dos componentes complementarios, ambos evaluados con la misma batería de once pruebas de normalidad (§2.5) y, cuando aplica, la misma grilla de tamaño de muestra *n* ∈ {10, 25, 50, 100, 250, 500, 1000, 1500}. El primer componente es puramente simulado (§2.3): cinco niveles ordenados de severidad de no-normalidad, cruzados sistemáticamente con *k* ∈ {3, ..., 9} y con *n*, aíslan el efecto de la cantidad de categorías de respuesta de la forma específica de la distribución subyacente. El segundo componente ancla ese resultado a la práctica psicométrica real (§2.4): seis instrumentos de acceso abierto que difieren en su cantidad nativa de categorías de respuesta se someten a submuestreo aleatorio repetido sobre la misma grilla de *n*.

## 2.2. Instrumentos psicométricos reales

Los seis instrumentos usados en el componente de datos reales se resumen en la Tabla 1. Se seleccionaron específicamente por su cantidad nativa de categorías de respuesta —no colapsada ni modificada post-hoc—, buscando cubrir el rango más amplio posible de *k* disponible en datos abiertos: *k*=4 (RSE: Open-Source Psychometrics Project, 2014b), *k*=5 (MACH-IV: Open-Source Psychometrics Project, 2019) y *k*=7 (HEXACO: Open-Source Psychometrics Project, 2014a) vienen del catálogo de openpsychometrics.org; *k*=9 también (RWAS: Open-Source Psychometrics Project, 2016); *k*=6 y *k*=8, ausentes de ese catálogo, se localizaron en Open Science Framework tras una búsqueda más amplia (SPS-10, de la encuesta COVIDiSTRESS Global Survey; Yamada, Ćepulić, COVIDiSTRESS Global Survey Consortium y Lieberoth, 2021; y la Adult Hope Scale, de un estudio longitudinal sobre enfermedad crónica; Davis et al., 2021).

**Tabla 1**
*Instrumentos reales usados, su cantidad nativa de categorías de respuesta y parámetros psicométricos*

| Instrumento | *k* | Ítems | Dimensiones | *N* | α | Ítems invertidos | Fuente del dataset |
|---|---|---|---|---|---|---|---|
| Escala de Autoestima de Rosenberg (Rosenberg, 1965) | 4 | 10 | Unidimensional (autoestima global) | 46.546 | .77–.88 publicado (Blascovich y Tomaka, 1993; Rosenberg, 1986) | {3,5,8,9,10} | Open-Source Psychometrics Project (2014b) |
| MACH-IV (Christie y Geis, 1970) | 5 | 20 | Unidimensional (maquiavelismo total; se usa como puntaje único pese a las tres facetas teóricas originales —tácticas, visión del mundo, moralidad—, sin estructura factorial robusta en la práctica) | 73.486 | .68–.70 publicado | {3,4,6,7,9,10,11,14,16,17} | Open-Source Psychometrics Project (2019) |
| Social Provisions Scale, forma corta SPS-10 (Cutrona y Russell, 1987) | 6 | 10 | 5 dimensiones, 2 ítems c/u: Apego/Apoyo emocional, Integración social, Reafirmación de valía, Alianza confiable, Orientación/Guía (se excluye la sexta provisión original, Oportunidad de crianza; puntaje total validado como dominado por un factor general, Sischka et al., 2025) | 91.658 | .92 (calculado en este estudio) | ninguno | Yamada et al. (2021) |
| HEXACO, faceta Expresividad (Ashton, Lee y Goldberg, 2007) | 7 | 10 | Unidimensional (ya es una única faceta del dominio Extraversión, no el dominio completo) | 22.783 | .84 publicado (Ashton et al., 2007, Tabla 2) | {6,7,8,9,10} | Open-Source Psychometrics Project (2014a) |
| Adult Hope Scale, versión abreviada de 8 ítems (Snyder et al., 1991) | 8 | 8 | 2 dimensiones, 4 ítems c/u: Agencia (energía orientada a metas), Vías (planificación para alcanzar metas) | 1.036 | .92 (calculado en este estudio) | ninguno | Davis et al. (2021) |
| Escala de Autoritarismo de Derecha — RWAS (Altemeyer, 1981) | 9 | 22 | Unidimensional (autoritarismo de derecha total) | 9.680 | ≈.90 publicado | {4,6,8,9,11,13,15,18,20,21} | Open-Source Psychometrics Project (2016) |

*Nota.* Los valores de α marcados como "publicado" corresponden a la confiabilidad reportada en el desarrollo original de cada instrumento o en estudios de validación citados, no a un cálculo propio. Los de SPS-10 y Adult Hope Scale se calcularon directamente sobre los datos de este estudio (no hay una cifra publicada disponible para las versiones administradas específicamente en cada dataset). Las claves de reversión de MACH-IV y RSE se confirmaron contra checkpsych.com/tests/mach-iv/ y Rosenberg (1965), respectivamente; la de HEXACO, contra la clave oficial de puntuación del IPIP (ipip.ori.org/newHEXACO_PI_key.htm), verificada ítem por ítem; la de RWAS, contra la lista de ítems invertidos reportada independientemente en una base de datos de escalas psicológicas (db.arabpsychology.com/scales/right-wing-authoritarianism-scale/), coincidente con la lectura semántica directa del contenido de cada ítem. SPS-10 y la Adult Hope Scale no tienen ítems invertidos por diseño: la forma corta de SPS-10 retiene deliberadamente solo los ítems redactados en sentido positivo de la escala original de 24 ítems (confirmado por fuente publicada y verificado empíricamente, correlaciones entre ítems todas positivas, 0.39–0.77); los 8 ítems puntuados de la Adult Hope Scale se califican todos en la misma dirección por diseño original de la escala. El puntaje compuesto de cada instrumento se calculó como la suma de sus ítems (con reversión donde correspondía), exigiendo caso completo: un caso solo entra al puntaje total si todos sus ítems tienen respuesta válida en rango. Todos los instrumentos, multidimensionales o no, se analizaron aquí como puntaje compuesto único (suma total), no por subescala separada, porque el objeto de estudio es la potencia de las pruebas de normalidad sobre el puntaje que efectivamente se somete a análisis paramétrico en la práctica —el total, no las subescalas— y porque tratarlos así permite comparar los seis instrumentos entre sí sobre la misma base (una distribución univariada por instrumento).

Los seis instrumentos difieren no solo en *k* sino también en su confiabilidad: MACH-IV es notablemente el más bajo (α≈.68–.70, un problema de consistencia interna ya documentado en la literatura sobre esta escala), mientras que SPS-10 y la Adult Hope Scale son los más altos (α=.92 ambos). Esta variación es una propiedad de los instrumentos tal como existen en la práctica real —no algo controlado por el diseño del estudio—, y se retoma en la Discusión al interpretar los resultados del componente de datos reales.

Los seis instrumentos se eligieron conjuntamente para cubrir el rango de *k* más amplio posible disponible en datos abiertos, de *k*=4 (RSE) a *k*=9 (RWAS), con SPS-10 y la Adult Hope Scale completando los valores intermedios (*k*=6 y *k*=8) ausentes en el catálogo original. El proceso de búsqueda para estos dos últimos, incluido un candidato inicial de *k*=6 descartado tras encontrar que la fuente de datos desaconseja explícitamente combinar sus ítems en un puntaje compuesto, se documenta en el registro de decisiones metodológicas del repositorio (no incluido aquí por extensión).

## 2.3. Bloque de niveles: simulación de la severidad de no-normalidad

Cada nivel simula un compuesto de *m*=10 ítems generados a partir de un factor común θ ~ *N*(0,1) con carga factorial λ: cada ítem = λθ + √(1−λ²)ε_j, con ε_j ~ *N*(0,1) iid, discretizado en *k* categorías ordenadas mediante *k*−1 umbrales sobre la variable latente continua; el puntaje compuesto es la suma de los *m* ítems ya discretizados —la misma lógica generativa que un puntaje tipo Likert-suma real—.

La carga factorial λ se trata aquí como un parámetro libre de la calibración, junto con los umbrales, en vez de fijarse a un valor constante. Esta decisión responde a un chequeo de factibilidad previo: fijar λ a un valor constante limita el mecanismo factor-común más umbrales discretizados a combinaciones de asimetría/curtosis platicúrticas o cercanas a la normal; dejando λ libre, el espacio alcanzable se amplía sustancialmente e incluye curtosis positiva, necesaria para reproducir el nivel más extremo del diseño (véase más abajo).

Se definieron cinco niveles ordenados de severidad de no-normalidad, con objetivos de asimetría y curtosis en exceso anclados a los percentiles 5º, 25º, 50º (mediana), 75º y 90º de la distribución de asimetría y curtosis reportada por Cain, Zhang y Yuan (2017) sobre 1.567 distribuciones univariadas reales de estudios publicados en *Psychological Science* y *American Education Research Journal* — en vez de valores elegidos ad-hoc, cada nivel corresponde a un punto empíricamente representativo de qué tan seguido se observa esa combinación de asimetría/curtosis en la práctica psicológica real (Tabla 2). El nivel más severo usa el percentil 90, no el 95 (el más extremo publicado): el objetivo del percentil 95 resultó generativamente inalcanzable de forma no degenerada con el mecanismo de *m*=10 ítems (ver registro de decisiones metodológicas del repositorio para el detalle).

Los objetivos de curtosis usan el percentil con signo tal cual lo reportan Cain et al., porque la dirección de la curtosis (leptocúrtica vs. platicúrtica) representa formas de no-normalidad genuinamente distintas. Los objetivos de asimetría usan el percentil de *|asimetría|* (magnitud, no signo), porque la potencia de las once pruebas de normalidad es estructuralmente simétrica a la dirección del sesgo; como Cain et al. no publican percentiles de asimetría en valor absoluto, estos se derivaron interpolando linealmente la función de distribución acumulada empírica implícita en su tabla de percentiles publicada, resolviendo *P*(|asimetría| ≤ *m*) = *F*(*m*) − *F*(−*m*) = *p* para *p* = .05, .25, .50, .75, .90. Esta es una aproximación sobre datos agregados publicados, no un cálculo directo sobre las distribuciones individuales (no disponibles públicamente) — se reporta así explícitamente para distinguirla del percentil directo usado para curtosis. El percentil de curtosis para el nivel más severo (90) también se interpoló, ya que Cain et al. solo publican el 75º y el 95º directamente, no el 90º.

**Tabla 2**
*Niveles de severidad de no-normalidad y sus objetivos de calibración, anclados a percentiles de Cain, Zhang y Yuan (2017)*

| Nivel | Percentil | Asimetría objetivo (|valor|, interpolado) | Curtosis en exceso objetivo (con signo, directo) |
|---|---|---|---|
| bajo | 5º | 0.053 | −1.28 |
| bajo-moderado | 25º | 0.276 | −0.57 |
| moderado | 50º (mediana) | 0.688 | 0.07 |
| alto | 75º | 1.332 | 1.62 |
| muy alto | 90º | 2.401 | 7.52 |

**Calibración.** Para cada combinación de nivel y *k* (7 valores, 3 a 9; 35 celdas en total), λ y los *k*−1 umbrales se calibraron simultáneamente vía optimización numérica, minimizando la distancia cuadrática entre los momentos empíricos del compuesto simulado y los objetivos de la Tabla 2:

*d*² = (asimetría_lograda − asimetría_objetivo)² + (curtosis_lograda − curtosis_objetivo)²

Los umbrales se parametrizaron como *u₁* = *p*, *uⱼ* = *p* + Σᵢ₌₂ʲ exp(*gᵢ*) para *j* > 1 (con *p* el primer umbral y *g* los log-incrementos), lo que garantiza umbrales crecientes sin restringir el optimizador; λ se parametrizó como λ = expit(*z*) = 1 / (1 + *e*⁻ᶻ), lo que mantiene λ en (0, 1) sin restricciones explícitas. El vector de parámetros libres (*z*, *p*, *g*₁, ..., *g*ₖ₋₂) se optimizó con el algoritmo Nelder-Mead, con dieciséis puntos de partida distintos por celda —barriendo λ inicial de 0.15 a 0.85 y el corrimiento de los umbrales iniciales hacia el signo del objetivo— y quedándose con el resultado de menor *d*² entre los dieciséis. Los momentos empíricos de cada combinación de parámetros se calcularon sobre *N*=150.000 réplicas de números aleatorios comunes (misma semilla y mismos valores de θ y ε generados una sola vez, reusados en las 35 celdas), para que el ruido Monte Carlo no contaminara las comparaciones de forma entre celdas.

Con los parámetros calibrados, cada celda (nivel × *k*) se simuló de forma independiente sobre la grilla completa de *n*, con *R*=10.000 réplicas por celda (280 celdas: 5 niveles × 7 valores de *k* × 8 tamaños de muestra).

## 2.4. Bloque de datos reales: submuestreo aleatorio *m-out-of-N*

Sobre cada uno de los seis instrumentos de la Tabla 1 se aplicó submuestreo aleatorio sin reemplazo tipo *m-out-of-N* (Politis, Romano y Wolf, 1999): para cada tamaño de muestra *n* de la grilla, se extrajeron *R*=10.000 submuestras aleatorias del puntaje compuesto completo del instrumento, y se calculó la tasa de rechazo empírica de cada prueba de normalidad frente al *N* completo del instrumento como población de referencia. El *N* mínimo entre cinco de los seis instrumentos (RWAS, 9.680) es muy superior al *n* máximo de la grilla (1.500), por lo que el submuestreo sin reemplazo es válido para esos cinco sin necesidad de ajuste. La excepción es la Adult Hope Scale (*N*=1.036): al no alcanzar el *n* máximo de 1.500, se usó una grilla reducida {10, 25, 50, 100, 250, 500, 1000} solo para este instrumento.

A diferencia del componente de niveles (§2.3), en este componente la cantidad de categorías de respuesta *k* viene naturalmente confundida con la cantidad de ítems del instrumento y con la asimetría/curtosis real del constructo medido —tal como ocurre siempre en la práctica psicométrica aplicada—; el componente de niveles existe precisamente para poder separar esos factores de forma que el componente de datos reales no puede.

## 2.5. Pruebas de normalidad evaluadas

Se evaluó la siguiente batería de once pruebas de normalidad: Shapiro-Wilk (Shapiro y Wilk, 1965), Anderson-Darling (Anderson y Darling, 1954), Lilliefors (Lilliefors, 1967), Jarque-Bera (Jarque y Bera, 1980), D'Agostino-Pearson (D'Agostino y Pearson, 1973), Cramér-von Mises (Csörgő y Faraway, 1996), Shapiro-Francia (Shapiro y Francia, 1972), χ² de Pearson (Pearson, 1900), la prueba de curtosis de Anscombe-Glynn (Anscombe y Glynn, 1983), Epps-Pulley (basada en la función característica empírica) y el SSTN (Anarat y Schwender, 2026) —una prueba de normalidad reciente basada en la autosimilitud bajo convolución—. Ninguna de las once ocupa un rol protagónico en este estudio: el objeto de estudio es el efecto de *k*, *n* y la severidad de la no-normalidad sobre la potencia comparada de la batería completa, no el desempeño relativo de una prueba en particular.

## 2.6. Implementación y reproducibilidad

Todas las simulaciones y el submuestreo se ejecutaron en R (v4.6.1), sobre la infraestructura de GitHub Actions (*runners* ubuntu-latest, paralelización por celda mediante `strategy: matrix`), con `r-lib/actions/setup-r-dependencies` para el cacheo de dependencias. Ninguna corrida real (extracción de datos, calibración, simulación, submuestreo) se ejecutó en una máquina local: los resultados reportados provienen exclusivamente de corridas archivadas en el repositorio de desarrollo, con historial de commits verificable. El código completo, incluida la configuración exacta de la infraestructura de simulación, está disponible en el repositorio citado en §2.7.

## 2.7. Disponibilidad de datos y código

El código completo (extracción de datos reales, calibración y simulación del bloque de niveles, submuestreo del bloque real, agregación de resultados, y la configuración de GitHub Actions que ejecuta cada paso) está disponible en el repositorio de desarrollo del estudio.

Los datos crudos de los seis instrumentos reales provienen de dos fuentes abiertas distintas:

- **RSE**: catálogo de datos abiertos de openpsychometrics.org (Open-Source Psychometrics Project, 2014b).
- **MACH-IV**: catálogo de datos abiertos de openpsychometrics.org (Open-Source Psychometrics Project, 2019).
- **HEXACO (faceta Expresividad)**: catálogo de datos abiertos de openpsychometrics.org (Open-Source Psychometrics Project, 2014a).
- **RWAS**: catálogo de datos abiertos de openpsychometrics.org (Open-Source Psychometrics Project, 2016).
- **SPS-10**: COVIDiSTRESS Global Survey (Open Science Framework, código `z39us`; Yamada, Ćepulić, COVIDiSTRESS Global Survey Consortium y Lieberoth, 2021), archivo `COVIDiSTRESS global survey May 30 2020 (final cleaned file).csv`.
- **Adult Hope Scale**: estudio longitudinal sobre enfermedad crónica (Open Science Framework, código `2anvx`; Davis et al., 2021), solo la ola T1 (línea base).

Los datos de calibración, simulación y submuestreo generados por este estudio (no los datos crudos de terceros, que se redistribuyen según los términos de cada fuente) se archivan como parte del historial del repositorio, junto con los *artifacts* de cada corrida de GitHub Actions.

---

## Referencias de datasets (formato APA 7ma, para la lista de referencias final)

Seis referencias, una por instrumento (no tres agrupadas por fuente), porque cada instrumento se descarga de una página/versión propia dentro de su repositorio, aunque cuatro compartan el mismo autor-grupo (Open-Source Psychometrics Project):

- Open-Source Psychometrics Project. (2014a). *IPIP HEXACO equivalent scales: Raw data* [Data set]. https://openpsychometrics.org/_rawdata/HEXACO.zip
- Open-Source Psychometrics Project. (2014b). *Rosenberg Self-Esteem Scale: Raw data* [Data set]. https://openpsychometrics.org/_rawdata/RSE.zip
- Open-Source Psychometrics Project. (2016). *Right-wing Authoritarianism Scale: Raw data* [Data set]. https://openpsychometrics.org/_rawdata/RWAS.zip
- Open-Source Psychometrics Project. (2019). *Machiavellianism test (MACH-IV): Raw data* [Data set]. https://openpsychometrics.org/_rawdata/MACH_data.zip
- Yamada, Y., Ćepulić, D.-B., COVIDiSTRESS Global Survey Consortium, & Lieberoth, A. (2021). COVIDiSTRESS Global Survey dataset on psychological and behavioural consequences of the COVID-19 outbreak. *Scientific Data, 8*, Article 3. https://doi.org/10.1038/s41597-020-00784-9
- Davis, E. B., Cowden, R. G., VanderWeele, T. J., Worthington, E. L., Jr., McElroy-Heltzel, S. E., Hook, J. N., Davis, D. E., Van Tongeren, D. R., Rueger, S. Y., Shannonhouse, L. R., Lemke, A. W., & Glowiak, K. J. (2021). *Psychological and spiritual health and resilience among U.S. adults with chronic disease* [Data set]. Open Science Framework. https://doi.org/10.17605/OSF.IO/2ANVX

Además, la columna "Dimensiones" de la Tabla 1 introdujo una cita nueva no bibliográfica de dataset (respalda la estructura factorial de SPS-10, no su fuente de datos):

- Sischka, P. E., Albert, I., & Kornadt, A. E. (2025). Validation of the 10-item Social Provision Scale (SPS-10): Evaluating factor structure, reliability, measurement invariance, and nomological network across 38 countries. *Assessment, 32*(7), 1027–1048. https://doi.org/10.1177/10731911241283609

Notas sobre estas seis referencias:

- **Las cuatro de openpsychometrics.org (RSE, MACH-IV, HEXACO, RWAS)**: mismo autor-grupo, pero cada una es un archivo `.zip` propio, con su propia fecha de actualización listada en la página del catálogo (`_rawdata/`) — esa fecha es el año de cada referencia: HEXACO y RSE comparten año (2014), por lo que se desambiguan como 2014a/2014b (orden alfabético por título: "IPIP HEXACO..." antes que "Rosenberg..."); MACH-IV es 2019; RWAS es 2016. Confirmado navegando la página y extrayendo el enlace de descarga exacto de cada fila (`find` sobre la página, no una URL genérica adivinada). El repositorio hermano (SSTN-Normality-Study) menciona esta misma fuente solo como URL suelta en prosa, sin cita formal — no hay precedente que replicar, esta es la primera vez que se formaliza para ambos papers.
- **COVIDiSTRESS**: se usa el descriptor de datos publicado en *Scientific Data* (Yamada et al., 2021) en vez de citar el nodo OSF `z39us` directamente, siguiendo la guía APA de citar la publicación del dataset cuando existe una, en vez del repositorio crudo. El autor-grupo intermedio ("COVIDiSTRESS Global Survey Consortium") es el que usa el propio artículo publicado (más de 40 colaboradores individuales), evitando tener que reconstruir esa lista completa.
- **Adult Hope Scale / OSF `2anvx`**: no se encontró un descriptor de datos publicado equivalente al de COVIDiSTRESS, así que se cita el dataset de OSF directamente. Lista completa de 12 colaboradores bibliográficos (orden e identidad) obtenida de `api.osf.io/v2/nodes/2anvx/bibliographic_contributors/?embed=users`; año confirmado por `date_created` del nodo (2021-01-27). Cada nombre completo se verificó además contra una publicación firmada por esa misma persona (no solo el perfil de OSF, que puede quedar desactualizado), lo que corrigió dos discrepancias: (1) el perfil de OSF lista varios colaboradores sin segundo nombre/inicial en absoluto ("Richard Cowden", "Everett Worthington", "kevin glowiak", "austin lemke", "Laura Shannonhouse") que sí publican con inicial — confirmado como R. G. Cowden, A. W. Lemke y K. J. Glowiak vía Cowden et al. (2021, *Wellbeing, Space and Society*, 2, Article 100048), como E. L. Worthington, Jr. vía su CV institucional (VCU) y múltiples publicaciones recientes, y como L. R. Shannonhouse vía su perfil de publicaciones (Universidad de Iowa/Florida); (2) el perfil de OSF lista el apellido de soltera "McElroy", pero esta autora publica como "McElroy-Heltzel" desde al menos 2019 (confirmado en Sage Journals) — ya vigente para la fecha de registro del dataset (2021), así que se usa el apellido con el que efectivamente publica.

## Pendientes: referencias completas

Ver `notes/referencias_pendientes.md` — lista única consolidada (antes duplicada entre este archivo e `introduccion_borrador.md`). Las referencias de dataset (Open-Source Psychometrics Project ×4, Yamada et al., Davis et al.) y la de Sischka et al. (2025) ya están completas arriba, en "Referencias de datasets", y no están en ese archivo.

## Notas para revisión

- Falta decidir si el orden de exposición debe ser primero el bloque de niveles o primero el bloque de datos reales — aquí puse niveles primero (§2.3 antes de §2.4) porque es el componente que aísla el mecanismo; en Resultados podría convenir el orden inverso (mostrar primero el dato real "crudo" y su aparente confusión, y luego el bloque de niveles que la resuelve), replicando el arco narrativo real de cómo se llegó al hallazgo. Pendiente de decidir junto con la estructura de Resultados.
- Falta una figura o tabla que muestre visualmente el mecanismo generativo del bloque de niveles (factor común + ítems + umbrales) — el original de SSTN no tenía figuras, solo tablas; revisar si conviene agregar una acá dado que el mecanismo con λ libre es una novedad metodológica del presente estudio.
- Pendiente: decidir si se incluye el detalle completo de las fórmulas (momentos, parametrización de umbrales `primer_umbral + cumsum(exp(log_gaps))`, transformación `plogis`/`qlogis` de λ) en el cuerpo del Método o se relega a un apéndice/material suplementario.
- Confirmado: se eliminaron todas las referencias a "estudio hermano"/trabajo comparado en el texto del Método (instrumentos reales, calibración de λ, submuestreo m-out-of-N, batería de pruebas) — el paper ahora se sostiene sin depender de mencionar trabajo propio no publicado.
- Confirmado: "remuestreo" reemplazado por "submuestreo aleatorio" en todo el documento.
- Pendiente: §2.7 dice "el repositorio de desarrollo del estudio" sin nombrarlo ni enlazarlo — falta decidir si el repositorio (`github.com/ArchieJamDev/ResponseCategories-Normality-Study`) se hace público o se anonimiza antes de someter, según la política de revisión por pares de la revista de destino, y completar la URL/enlace definitivo recién en ese momento.
