#!/bin/bash
set -e # salir si hay error

# Examen de Estadistica Computacional
# Autor: daniel miranda badillo

echo "------------------------------"
echo "Ejecutando bash inicial..."
echo "------------------------------"

#chmod +x sql_process.sh

# Verificar que curl está disponible
if ! command -v curl &> /dev/null; then
    echo "curl no está instalado. Instalando curl..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "curl debería estar disponible en macOS por defecto."
        echo "Si no está disponible, instala Xcode Command Line Tools:"
        echo "xcode-select --install"
        exit 1
    else
        # Linux
        sudo apt-get update && sudo apt-get install -y curl
    fi
else
    echo "curl está disponible"
fi

# revisar si awk está instalado, si no lo está instalarlo
if ! command -v awk &> /dev/null
then
    echo "awk no está instalado. Instalando awk..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "awk debería estar disponible en macOS por defecto."
        exit 1
    else
        sudo apt-get update && sudo apt-get install -y gawk
    fi
else
    echo "✓ awk está disponible"
fi

# descargar el archivo csv Adult Income* (UCI Machine Learning Repository: "Adult Data 
echo "Descargando el archivo CSV..."
curl -L -s -o adult_income.csv "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

# Verificar que el archivo se descargó correctamente
if [ ! -f "adult_income.csv" ] || [ ! -s "adult_income.csv" ]; then
    echo "Error: No se pudo descargar el archivo CSV o está vacío"
    echo "URL: https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
    exit 1
fi
echo "Archivo CSV descargado exitosamente ($(wc -l < adult_income.csv) líneas)"

# reemplazar espacios despues de la coma (usando awk como alternativa)
echo "Limpiando espacios en CSV..."
awk '{gsub(/, /, ","); print}' adult_income.csv > adult_income_clean.csv
mv adult_income_clean.csv adult_income.csv
echo "Espacios eliminados." 

# descargar encabezados
echo "Descargando el archivo de encabezados..."
curl -L -s -o adult_headers.txt "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.names"

# Verificar que el archivo se descargó correctamente
if [ ! -f "adult_headers.txt" ] || [ ! -s "adult_headers.txt" ]; then
    echo "Error: No se pudo descargar el archivo de encabezados o está vacío"
    echo "URL: https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.names"
    exit 1
fi
echo "Archivo de encabezados descargado exitosamente" 

# extraer encabezados y crear archivo headers.txt
echo "Extrayendo encabezados..."
egrep -a '^[a-z-]+:\s'  adult_headers.txt | cut -d':' -f1 | tr '\n' ',' | sed 's/,$/,income/' > headers.txt


echo "Generando archivo CSV con encabezados..."
{
    cat headers.txt
    echo ""
    cat adult_income.csv
} > adult.csv
echo ""

# eliminar archivos temporales
rm adult_income.csv  adult_headers.txt headers.txt

### ********************************
# 1 Validcion basica. Contar filas y columnas cn awk
num_filas=$(awk -F ',' 'BEGIN {OFS=","} NR>1 && NF>0 {print $1}' adult.csv | wc -l)
echo "El archivo adult.csv tiene $num_filas filas."
num_columnas=$(awk -F',' 'NR==1 {print NF}' adult.csv)
echo "El archivo adult.csv tiene      $num_columnas columnas."
# mostrar encabezado
echo ""
echo "Encabezado del archivo adult.csv:"
head adult.csv

### ********************************
# 2. Detección de valores faltantes o inválidos**
# generar fichero out/ para guardar resultados
mkdir -p out

#Guardar en `out/income_counts.csv` con
#   - Detectar valores `"?"` o vacíos en cualquier columna.
#- Reportar el número total de filas afectadas.
#  - Exportar las filas con faltantes a `out/adult_missing_rows.csv`.

echo ""
echo "Detección de valores faltantes o inválidos:"

# Primero detectar y contar filas con valores faltantes
filas_con_faltantes=$(awk -F',' 'NR>1 {
    for (i=1; i<=NF; i++) {
        if ($i == "?" || $i == "" || $i ~ /^ *$/) {
            count++
            break
        }
    }
} END {print count+0}' adult.csv)

echo "Número total de filas afectadas con valores faltantes o invalidos ?: $filas_con_faltantes"

# Exportar filas con faltantes (incluyendo encabezado)
awk -F',' 'NR==1 {print; next} 
NR>1 {
    for (i=1; i<=NF; i++) {
        if ($i == "?" || $i == "" || $i ~ /^ *$/) {
            print $0
            break
        }
    }
}' adult.csv > out/adult_missing_rows.csv

echo "Filas con valores faltantes exportadas a: out/adult_missing_rows.csv"

### ********************************
# 3.Estadísticas descriptivas (numéricas)**  
echo ""
echo "Estadísticas descriptivas (numéricas):" #**mínimo, máximo, promedio**. 

# Crear archivo CSV con encabezado
echo "variable,minimo,maximo,promedio" > out/adult_summary_stats.csv

# columnas numéricas: edad, fnlwgt, educación-numérica, capital-gain, capital-loss, horas-por-semana
columnas=(age fnlwgt education-num capital-gain capital-loss hours-per-week) 
for col in "${columnas[@]}"; do
    echo "Columna: $col"
    stats=$(LC_NUMERIC=C awk -F',' -v columna="$col" '
    NR==1 {
        for (i=1; i<=NF; i++) {
            if ($i == columna) {
                col_index = i
                break
            }
        }
    }
    NR>1 && NF>0 {
        valor = $col_index
        if (valor != "?") {
            suma += valor
            if (min == "" || valor < min) {
                min = valor
            }
            if (max == "" || valor > max) {
                max = valor
            }
            count++
        }
    }
    END {
        if (count > 0) {
            promedio = suma / count
            printf "%s,%.0f,%.2f", min, max, promedio
        } else {
            print ",,"
        }
    }' adult.csv)
    
    # Mostrar en consola
    min_val=$(echo $stats | cut -d',' -f1)
    max_val=$(echo $stats | cut -d',' -f2)
    avg_val=$(echo $stats | cut -d',' -f3)
    echo "Mínimo: $min_val, Máximo: $max_val, Promedio: $avg_val"
    
    # Agregar al archivo CSV
    echo "$col,$stats" >> out/adult_summary_stats.csv
    echo ""
done 

echo "Estadisticas guardadas en: out/adult_summary_stats.csv" 

### ********************************
# 4. Conteo por categoría de ingreso
echo ""
echo "Conteo por categoría de ingreso:"
# Guardar en out/income_counts.csv con columnas income,count
awk -F',' 'NR>1 && NF>0 {ingreso[$NF]++} END {print "income,count"; for (cat in ingreso) print cat "," ingreso[cat]}' adult.csv > out/income_counts.csv
echo "Conteo de ingresos guardado en: out/income_counts.csv"



### ********************************
# 5. Filtrado y exportación**  
#   - Filtrar filas con `hours_per_week >= 50`.  
#   - Guardar en `out/adult_over50hours.csv` preservando encabezados. 

echo ""
echo "Filtrado de personas con 50+ horas por semana:"
awk -F',' 'BEGIN{OFS=","} 
NR==1 {
    # Encontrar la posición de la columna hours-per-week
    for (i=1; i<=NF; i++) {
        if ($i == "hours-per-week") {
            hours_col = i
            break
        }
    }
    print
    next
}
NR>1 && NF>0 && $hours_col != "?" {
    if ($hours_col >= 50) {
        print $0
    }
}' adult.csv > out/adult_over50hours.csv

filas_filtradas=$(wc -l < out/adult_over50hours.csv)
echo "Filas con 50+ horas por semana (incluyendo encabezado): $filas_filtradas"
echo "Archivo guardado en: out/adult_over50hours.csv"


### ********************************
# 6. **(15 pts) Variable derivada**  
#   - Crear `net_capital = capital_gain - capital_loss`.  
#   - Añadir como nueva columna al final y exportar a `out/adult_with_netcapital.csv`.  

echo ""
echo "Creando variable derivada net_capital:"
awk -F',' 'BEGIN{OFS=","} 
NR==1 {
    # Encontrar posiciones de las columnas capital-gain y capital-loss
    for (i=1; i<=NF; i++) {
        if ($i == "capital-gain") {
            gain_col = i
        } else if ($i == "capital-loss") {
            loss_col = i
        }
    }
    print $0, "net_capital"
    next
}
NR>1 && NF>0 {
    capital_gain = $gain_col
    capital_loss = $loss_col
    
    # Manejar valores faltantes
    if (capital_gain == "?") capital_gain = 0
    if (capital_loss == "?") capital_loss = 0
    
    net_capital = capital_gain - capital_loss
    print $0, net_capital
}' adult.csv > out/adult_with_netcapital.csv

echo "Variable net_capital agregada en: out/adult_with_netcapital.csv".csv

### ********************************
# 7. ** Normalización Min–Max**  
#   - Normalizar `age` a `[0,1]` con `(age - min(age)) / (max(age) - min(age))`.  
#   - Agregar columna `age_norm` y guardar en `out/adult_norm_age.csv`.  
#   - Verificar en consola el rango observado de `age_norm` (min y max).  

echo ""
echo "Normalizando columna age con Min-Max:"

# Paso 1: Encontrar min y max de age
min_max_age=$(awk -F',' '
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "age") {
            age_col = i
            break
        }
    }
    next
}
NR>1 && NF>0 {
    age_val = $age_col
    if (age_val != "?") {
        if (min == "" || age_val < min) {
            min = age_val
        }
        if (max == "" || age_val > max) {
            max = age_val
        }
    }
} 
END {
    printf "%s,%s", min, max
}' adult.csv)

min_age=$(echo $min_max_age | cut -d',' -f1)
max_age=$(echo $min_max_age | cut -d',' -f2)
echo "Rango de edad - Mínimo: $min_age, Máximo: $max_age"

# Paso 2: Normalizar y crear archivo con age_norm
LC_NUMERIC=C awk -F',' -v min_age="$min_age" -v max_age="$max_age" 'BEGIN{OFS=","} 
NR==1 {
    # Encontrar posición de age
    for (i=1; i<=NF; i++) {
        if ($i == "age") {
            age_col = i
            break
        }
    }
    print $0, "age_norm"
    next
}
NR>1 && NF>0 {
    age_val = $age_col
    if (age_val != "?" && min_age != max_age) {
        age_norm = (age_val - min_age) / (max_age - min_age)
        printf "%s,%.6f\n", $0, age_norm
    } else {
        print $0, "?"
    }
}' adult.csv > out/adult_norm_age.csv

# Paso 3: Verificar rango de age_norm
echo ""
echo "Verificando rango de age_norm:"
rango_norm=$(LC_NUMERIC=C awk -F',' 'NR>1 && NF>0 && $NF != "?" {
    if (min_norm == "" || $NF < min_norm) {
        min_norm = $NF
    }
    if (max_norm == "" || $NF > max_norm) {
        max_norm = $NF
    }
} END {
    printf "%.6f,%.6f", min_norm, max_norm
}' out/adult_norm_age.csv)

min_norm=$(echo $rango_norm | cut -d',' -f1)
max_norm=$(echo $rango_norm | cut -d',' -f2)
echo "Rango de age_norm - Mínimo: $min_norm, Máximo: $max_norm"
echo "Normalización completada y guardada en: out/adult_norm_age.csv"

### ********************************

# 8. Discretización de `hours_per_week`**  
#   - Calcular puntos de corte por terciles (Q1 y Q2) a partir de los valores observados.  
#   - Asignar categorías: `Bajo` (<Q1), `Medio` [Q1,Q2), `Alto` ≥Q2.  
#   - Generar tabla de frecuencias y guardar en `out/hours_bins_freq.csv` con columnas `bin,count`.

echo ""
echo "Discretizando hours-per-week en categorias por terciles:"

# Paso 1: Calcular Q1 y Q2 (terciles) usando sort
echo "Calculando terciles..."
quartiles=$(awk -F',' '
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "hours-per-week") {
            hours_col = i
            break
        }
    }
    next
}
NR>1 && NF>0 {
    hours_val = $hours_col
    if (hours_val != "?" && hours_val != "") {
        print hours_val
    }
}' adult.csv | sort -n | awk '
{
    values[NR] = $1
    count = NR
}
END {
    if (count > 0) {
        q1_pos = int(count/3) + 1
        q2_pos = int(2*count/3) + 1
        if (q1_pos > count) q1_pos = count
        if (q2_pos > count) q2_pos = count
        printf "%s,%s", values[q1_pos], values[q2_pos]
    }
}')

q1=$(echo $quartiles | cut -d',' -f1)
q2=$(echo $quartiles | cut -d',' -f2)
echo "Q1 (33%): $q1, Q2 (67%): $q2"

# Paso 2: Asignar categorías y contar frecuencias
awk -F',' -v q1="$q1" -v q2="$q2" '
BEGIN {
    bajo = 0; medio = 0; alto = 0
}
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "hours-per-week") {
            hours_col = i
            break
        }
    }
    next
}
NR>1 && NF>0 {
    hours_val = $hours_col
    if (hours_val != "?") {
        if (hours_val < q1) {
            bajo++
        } else if (hours_val < q2) {
            medio++
        } else {
            alto++
        }
    }
}
END {
    print "bin,count"
    print "Bajo," bajo
    print "Medio," medio
    print "Alto," alto
}' adult.csv > out/hours_bins_freq.csv

echo "Distribución por terciles:"
echo "- Bajo (<$q1): $(awk -F',' 'NR==2 {print $2}' out/hours_bins_freq.csv) personas"
echo "- Medio ([$q1,$q2)): $(awk -F',' 'NR==3 {print $2}' out/hours_bins_freq.csv) personas"
echo "- Alto (≥$q2): $(awk -F',' 'NR==4 {print $2}' out/hours_bins_freq.csv) personas"
echo "Tabla de frecuencias guardada en: out/hours_bins_freq.csv"

rm -f sed*