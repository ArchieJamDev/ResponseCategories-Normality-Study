# ResponseCategories-Normality-Study

Efecto de la cantidad de categorías de respuesta y el tamaño de muestra en la potencia de 11 pruebas de normalidad. Proyecto hermano de [SSTN-Normality-Study](../SSTN-Normality-Study), separado como artículo independiente a partir de un hallazgo secundario de ese estudio (Bloque 5 ampliado, k=3..8).

Ver `notes/DESIGN.md` para el registro de decisiones metodológicas.

## Objetivo

El Bloque 5 de SSTN-Normality-Study (simulación pura, factor común + umbrales) mostró que la cantidad de categorías de respuesta k de un instrumento afecta la potencia de las 11 pruebas de normalidad evaluadas, de forma no monotónica y fuertemente modulada por el tamaño de muestra (efecto negligible en n=10, pico en n≈100-250, casi desaparece en n≥1000). Ese hallazgo amerita un estudio propio, con dos componentes:

1. **Réplica/extensión de la simulación** (misma lógica del Bloque 5 de SSTN-Normality-Study: factor común simulado + umbrales calibrados a momentos reales).
2. **Anclaje a datos reales genuinos** (este bloque): 4 datasets reales de openpsychometrics.org, elegidos específicamente por su cantidad NATIVA de categorías de respuesta (no simulada ni colapsada post-hoc), para verificar si el patrón hallado en simulación se replica con datos reales.

## Datasets reales (openpsychometrics.org, `data/raw/`)

| Dataset | k nativo | Ítems | N | Fuente |
|---|---|---|---|---|
| RSE (Autoestima de Rosenberg) | 4 | 10 | 46.546 | openpsychometrics.org/tests/RSE.php |
| MACH-IV (Maquiavelismo) | 5 | 20 | 73.486 | openpsychometrics.org/tests/MACH-IV/ |
| HEXACO, facet X:Expr (Expresividad) | 7 | 10 | 22.783 | openpsychometrics.org/_rawdata/HEXACO.zip |
| RWAS (Autoritarismo de derecha) | 9 | 22 | 9.680 | openpsychometrics.org/tests/RWAS/ |

Se buscó deliberadamente cubrir k=6, 7 y 8 (huecos del diseño simulado original, que solo llega a k=3..8 vía calibración, y del ancla real, que solo tenía k=4 y k=5 vía DASS/RIASEC/MACH-IV/RSE). No se encontró ningún dataset real abierto con k=6 ni k=8 tras una búsqueda exhaustiva en openpsychometrics.org, OSF, Kaggle y candidatos específicos de la literatura — parecen ser valores genuinamente raros en la práctica psicométrica publicada. k=7 (HEXACO) sí se encontró y su clave de puntuación fue verificada contra la fuente oficial de IPIP (ipip.ori.org/newHEXACO_PI_key.htm). k=9 (RWAS) queda un escalón por fuera del rango simulado (k=3..8) — se documenta como extrapolación real, no interpolación.

## Método

Submuestreo aleatorio sin reemplazo tipo *m-out-of-N* (misma lógica del Bloque 4 de SSTN-Normality-Study) sobre cada uno de los 4 datasets, en la MISMA grilla de n que el Bloque 5 simulado: {10,25,50,100,250,500,1000,1500}, R=10.000 réplicas por celda, batería completa de 11 pruebas de normalidad (`R/08_run_battery.R`, idéntico al de SSTN-Normality-Study).

**Restricción de integridad de investigación (no negociable, mismo criterio que SSTN-Normality-Study):** ningún resultado se fabrica ni se estima. Todo sale de corridas reales en GitHub Actions (`gh workflow run`) — nada se corre localmente.

## Estructura

```
R/                        Scripts de extracción y submuestreo
data/raw/                 Datasets reales sin modificar (zips de openpsychometrics.org)
data/processed/           Puntajes compuestos extraídos (gitignored, regenerar vía R/01)
data/results/             Salidas de las corridas de submuestreo
notes/                    Bitácora de diseño y decisiones metodológicas
.github/workflows/        Definición de los jobs en GitHub Actions
```

## Estado

Estructura inicial creada, extracción de los 4 datasets reales validada localmente (solo como chequeo de sintaxis, no como resultado). Pendiente: primer push a GitHub, disparar `correr_extraccion` + `correr_bloque_real` en Actions.
