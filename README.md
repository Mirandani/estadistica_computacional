
#  Estadistica Computacional
# Tarea 2 - Solución: Limpieza y preparación de datos con `awk`
## Alumno: Daniel Miranda Badillo

**Autor:** Daniel Miranda Badillo  
**Curso:** Maestría en Ciencia de Datos - Estadística Computacional  
**Dataset:** Adult Income (UCI Machine Learning Repository)

---

## Descripción General

Esta solución implementa un pipeline completo de procesamiento de datos usando `awk`  para analizar el dataset "Adult Income". El script `solucion.sh` automatiza todas las tareas requeridas, desde la descarga de datos hasta la generación de reportes estadísticos.

---

## Ejecución

```bash
# Dar permisos de ejecución
chmod +x solucion.sh

# Ejecutar el script completo
bash solucion.sh
```

**Requisitos del sistema:**
- `awk` (cualquier versión POSIX compatible)
- `wget` (se instala automáticamente si no está disponible)
- `sed`, `sort`, `cut`, `wc` (utilidades estándar)
- Conexión a internet (para descarga inicial de datos)

---

## Estructura de Salida

```
tarea2/
├── solucion.sh              # Script principal
├── adult.csv                # Dataset procesado con encabezados
├── README.md                # Readme
└── out/                     # Directorio de resultados
    ├── adult_missing_rows.csv      # Filas con valores faltantes
    ├── adult_summary_stats.csv     # Estadísticas descriptivas
    ├── income_counts.csv           # Conteo por categoría de ingreso
    ├── adult_over50hours.csv       # Personas con 50+ horas/semana
    ├── adult_with_netcapital.csv   # Dataset con variable derivada
    ├── adult_norm_age.csv          # Dataset con age normalizada
    └── hours_bins_freq.csv         # Frecuencias por terciles de horas
```

---

## Ejercicios

### 1. **Validación Básica** (10 pts)
-Conteo de filas (excluyendo encabezado): 32,561 registros
-Conteo de columnas: 15 variables
-Visualización del encabezado original

**Comando clave:**
```bash
awk -F',' 'NR==1 {print NF}' adult.csv  # Contar columnas
```

### 2. **Detección de Valores Faltantes** (10 pts)
-Detección de valores `"?"` y campos vacíos
-Reporte de filas afectadas: 2,399 registros
-Exportación a `out/adult_missing_rows.csv`

**Técnica utilizada:**
```bash
# Búsqueda de valores faltantes en cualquier columna
for (i=1; i<=NF; i++) {
    if ($i == "?" || $i == "" || $i ~ /^ *$/) {
        count++; break
    }
}
```

### 3. **Estadísticas Descriptivas** (15 pts)
-Cálculo de min, max, promedio para 6 variables numéricas
-Salida en consola y archivo `out/adult_summary_stats.csv`
-Manejo de valores faltantes

**Variables analizadas:**
- `age`: 17-90 años (promedio: 38.58)
- `fnlwgt`: 12,285-1,484,705 (promedio: 189,778.37)
- `education-num`: 1-16 (promedio: 10.08)
- `capital-gain`: 0-99,999 (promedio: 1,077.65)
- `capital-loss`: 0-4,356 (promedio: 87.30)
- `hours-per-week`: 1-99 (promedio: 40.44)

### 4. **Conteo por Categoría de Ingreso** (10 pts)
-Distribución: `<=50K` vs `>50K`
-Archivo: `out/income_counts.csv`

### 5. **Filtrado y Exportación** (10 pts)
-Filtro: `hours-per-week >= 50`
-Preservación de encabezados
-Resultado: 2,819 personas (incluyendo encabezado)

### 6. **Variable Derivada** (15 pts)
-Fórmula: `net_capital = capital-gain - capital-loss`
-Manejo de valores faltantes (conversión a 0)
-Nueva columna agregada al final

### 7. **Normalización Min-Max** (15 pts)
-Fórmula: `(age - min_age) / (max_age - min_age)`
-Rango resultante: `[0.000000, 1.000000]`
-Verificación automática del rango

### 8. **Discretización por Terciles** (15 pts)
-Cálculo de Q1 (33%) y Q2 (67%) para `hours-per-week`
-Categorías: `Bajo`, `Medio`, `Alto`
-Tabla de frecuencias generada

---

## 🛠️ Técnicas y Decisiones de Implementación

### **Gestión de Espacios en CSV**
```bash
sed -i '' 's/, /,/g' adult_income.csv  # Eliminar espacios después de comas
```
**Justificación:** Los datos originales tienen formato `, ` que complica el parsing con `awk -F','`.

### **Búsqueda Dinámica de Columnas**
```bash
# En lugar de usar números fijos ($13), buscar por nombre
for (i=1; i<=NF; i++) {
    if ($i == "hours-per-week") {
        hours_col = i; break
    }
}
```
**Ventajas:** Código más mantenible y resistente a cambios en el orden de columnas.

### **Control de Locale para Decimales**
```bash
LC_NUMERIC=C awk ...  # Forzar punto como separador decimal
```
**Problema resuelto:** Evitar que `38.58` se convierta en `38,58` (que crea columnas extra en CSV).

### **Alternativa a `asort()` para Compatibilidad**
```bash
# En lugar de asort() (no disponible en todas las versiones)
awk ... | sort -n | awk ...  # Pipeline híbrido
```
**Resultado:** Solución portable que funciona en cualquier sistema POSIX.

### **Manejo Robusto de Valores Faltantes**
- Conversión de `"?"` a `0` en operaciones matemáticas
- Exclusión de valores faltantes en cálculos estadísticos
- Preservación de `"?"` cuando es apropiado

---

## Resultados Destacados

### **Calidad de Datos**
- **2,399 filas (7.4%)** contienen valores faltantes
- Valores faltantes concentrados en: `workclass`, `occupation`, `native-country`

### **Distribución de Ingresos**
- **75.9%** gana ≤50K
- **24.1%** gana >50K

### **Análisis de Horas Trabajadas**
- **8.6%** trabaja 50+ horas por semana
- Distribución por terciles permite identificar patrones de trabajo

### **Variable Derivada `net_capital`**
- Mayoría tiene `net_capital = 0`
- Algunos casos extremos con ganancias/pérdidas significativas

---

##  Comandos de Verificación

```bash
# Verificar estructura de archivos generados
ls -la out/

# Contar registros en cada archivo
wc -l out/*.csv

# Ver primeras líneas de resultados
head -5 out/adult_summary_stats.csv
head -5 out/hours_bins_freq.csv

# Verificar rango de normalización
tail -5 adult_norm_age.csv | cut -d',' -f16
```
