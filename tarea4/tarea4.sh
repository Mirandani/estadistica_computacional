
# Descarga de archivos con curl dataset Boston Housing
echo ">>> PASO 1 Descargando datos de entrada..."
curl -o boston_housing_raw.txt https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data

# Descarga de archivo con nombres de columnas
curl -o boston_housing_names.txt https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.names

egrep -a '^\s{1,4}[0-9]{1,2}\.' boston_housing_names.txt | awk '{print $2}' | tr '\n' ',' | sed 's/,$/\n/' > boston_housing_header.csv

# Suponiendo que el dataset original viene con delimitadores irregulares o espacios
# Podemos usar 'sed' y 'tr' para normalizar:
echo ">>> PASO 1.1 Normalizando y convirtiendo a CSV..."
cat boston_housing_raw.txt | tr -s ' ' | sed 's/^ //;s/ $//' | tr ' ' ',' > boston_housing_data.csv

# Combinar encabezado y datos
cat boston_housing_header.csv boston_housing_data.csv > boston_housing.csv

# Limpiar archivos temporales
#rm boston_housing_raw.txt boston_housing_names.txt boston_housing_header.csv


