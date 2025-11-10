# Tarea 4 - Análisis del Dataset Boston Housing

## Descripción General

Este proyecto realiza un análisis exploratorio de datos (EDA) completo del dataset Boston Housing, que contiene información sobre valores de viviendas en el área de Boston. El proyecto incluye procesamiento de datos con bash, análisis estadístico en R Markdown y una aplicación Shiny interactiva.

## Estructura del Proyecto

```
tarea4/
├── tarea4.sh              # Script de descarga y procesamiento de datos
├── Tarea4.rmd            # Análisis exploratorio en R Markdown
├── app.R                 # Aplicación Shiny interactiva
├── boston_housing.csv    # Dataset procesado (generado)
└── README.md            # Este archivo
```

## Archivos del Proyecto

### 1. tarea4.sh

Script de bash que automatiza la descarga y preparación del dataset Boston Housing.

**Funcionalidad:**
- Descarga los datos originales desde el repositorio UCI Machine Learning
- Descarga los nombres de las columnas
- Extrae y formatea los encabezados automáticamente
- Normaliza espacios y convierte el formato a CSV
- Combina encabezados con datos en un archivo CSV final
- Limpia archivos temporales

**Uso:**
```bash
bash tarea4.sh
```

**Salida:**
- `boston_housing.csv` - Dataset limpio y listo para análisis

**Variables del Dataset:**
- CRIM: Tasa de criminalidad per cápita
- ZN: Proporción de terrenos residenciales
- INDUS: Proporción de acres comerciales
- CHAS: Variable ficticia del río Charles
- NOX: Concentración de óxidos nítricos
- RM: Número promedio de habitaciones
- AGE: Proporción de viviendas construidas antes de 1940
- DIS: Distancia a centros de empleo
- RAD: Índice de accesibilidad a autopistas
- TAX: Tasa de impuesto a la propiedad
- PTRATIO: Ratio estudiante-maestro
- B: Proporción de población afroamericana
- LSTAT: Porcentaje de población con bajo estatus socioeconómico
- MEDV: Valor medio de viviendas (variable objetivo, en miles de dólares)

### 2. Tarea4.rmd

Documento R Markdown con análisis exploratorio completo del dataset.

**Contenido:**

1. **Carga de Datos**
   - Importación del CSV generado por tarea4.sh
   - Vista preliminar de los datos

2. **Análisis Univariado**
   - Estadísticas descriptivas para todas las variables
   - Tabla resumen con: mínimo, máximo, media, mediana, desviación estándar y cuartiles
   - Enfoque especial en MEDV (variable objetivo)

3. **Análisis Bivariado**
   - Correlaciones entre variables predictoras y MEDV
   - Gráfico facetado mostrando todas las relaciones
   - Análisis detallado de LSTAT vs MEDV
   - Matriz de correlación completa

4. **Visualizaciones**
   - Histogramas de todas las variables numéricas
   - Scatterplot matrices para identificar relaciones
   - Boxplots para detectar valores atípicos

5. **Exportación**
   - Guardado del dataset en formato Feather (Apache Arrow)
   - Formato optimizado para intercambio de datos

**Requisitos:**
```r
install.packages(c("tidyverse", "dplyr", "ggplot2", "arrow", "shiny"))
```

**Uso:**
```r
# En RStudio
rmarkdown::render("Tarea4.rmd")
```

### 3. app.R

Aplicación web interactiva Shiny para exploración visual del dataset.

**Características:**

**Pestaña 1: Datos**
- Tabla interactiva con el dataset completo
- Funcionalidad de búsqueda, ordenamiento y paginación

**Pestaña 2: Análisis Univariado**
- Tabla de estadísticas descriptivas para todas las variables
- Resumen completo de medidas de tendencia central y dispersión

**Pestaña 3: Análisis Bivariado**
- Selector interactivo de variables para graficar contra MEDV
- Gráfico de dispersión con línea de regresión
- Visualización de coeficiente de correlación
- Vista general de todas las correlaciones simultáneamente

**Pestaña 4: Distribuciones**
- Selector de variable a analizar
- Alternancia entre histograma y boxplot
- Control deslizante para ajustar el número de bins en histogramas
- Visualizaciones personalizables

**Requisitos:**
```r
install.packages(c("shiny", "tidyverse", "dplyr", "ggplot2", "DT", "arrow"))
```

**Uso:**
```r
# En RStudio
shiny::runApp("app.R")

# Desde la línea de comandos
R -e "shiny::runApp('app.R')"
```

La aplicación se abrirá en el navegador predeterminado, típicamente en `http://127.0.0.1:XXXX`

## Flujo de Trabajo Completo

1. **Preparación de Datos:**
   ```bash
   bash tarea4.sh
   ```

2. **Análisis Estático:**
   ```r
   rmarkdown::render("Tarea4.rmd")
   ```

3. **Exploración Interactiva:**
   ```r
   shiny::runApp("app.R")
   ```

## Requisitos del Sistema

- **Sistema Operativo:** Linux, macOS o Windows con WSL
- **Bash:** Para ejecutar tarea4.sh
- **R:** Versión 4.0 o superior
- **Paquetes R:** tidyverse, dplyr, ggplot2, arrow, shiny, DT
- **Conexión a Internet:** Para descargar los datos originales

## Instalación de Dependencias

### R Packages
```r
install.packages(c(
  "tidyverse",
  "dplyr",
  "ggplot2",
  "arrow",
  "shiny",
  "DT",
  "knitr",
  "rmarkdown"
))
```

### Herramientas de Sistema
```bash
# Verificar que curl y awk estén instalados
curl --version
awk --version
```

## Resultados Principales

### Hallazgos del Análisis

- **Variable Objetivo (MEDV):** Rango de $5,000 a $50,000 con media ~$22,500
- **Correlaciones Fuertes:**
  - LSTAT (negativa): A mayor porcentaje de población de bajo estatus, menor valor de vivienda
  - RM (positiva): Más habitaciones correlacionan con mayor valor
  - PTRATIO (negativa): Mayor ratio estudiante-maestro reduce el valor

### Archivos Generados

- `boston_housing.csv` - Dataset procesado
- `boston_housing.feather` - Formato optimizado para análisis
- `Tarea4.html` - Reporte HTML del análisis (si se renderiza)

## Notas Técnicas

- El script bash maneja espacios irregulares en los datos originales
- Todos los análisis incluyen manejo de valores faltantes (`na.rm = TRUE`)
- La aplicación Shiny carga datos en memoria al iniciar para mejor rendimiento
- Los gráficos facetados usan escalas libres para mejor visualización

## Fuente de Datos

**Dataset:** Boston Housing Dataset
**Repositorio:** UCI Machine Learning Repository
**URL:** https://archive.ics.uci.edu/ml/machine-learning-databases/housing/

## Autor

Proyecto desarrollado para el curso de Estadística Computacional - ITAM

## Licencia

Datos originales del UCI Machine Learning Repository. Uso académico.
