#!/bin/bash
# ETL script for Coil2000 dataset
# Autor: daniel miranda badillo

# leer URL desde argumento, si no tiene argumento usa la URL por defecto
DEFAULT_URL="https://archive.ics.uci.edu/static/public/125/insurance+company+benchmark+coil+2000.zip"
if [ -z "$1" ]; then
  URL="$DEFAULT_URL"
  echo
else
  URL="$1"
  echo "Usando URL proporcionada: $URL"
fi

# Descargar el archivo
curl -O "$URL"
# Obtener el nombre del archivo descargado
ZIPFILE="$(basename "$URL")"
unzip -o "$ZIPFILE"

# column names en un nuevo archivo
iconv -f WINDOWS-1252 -t UTF-8 TicDataDescr.txt | tr -d '\r' > TicDataDescr_clean.txt

# lista columnas
egrep -a "^[0-9]{1,2}\s[A-Z]{2,}" TicDataDescr.txt | cut -d" " -f2 | tr -d '\r' | paste -sd '|' > nombre_col.txt
# guardar nombre de columnas como encabezados.txt
cat nombre_col.txt | sed 's/|/\n/g' > encabezados.txt
echo "Nombres de columnas guardados en encabezados.txt"

# crear carpeta catálogos 
mkdir -p catalogos

# Catalogo LO MOSTYPE
#egrep -a "^[0-9]{1,2}\s+[0-9]{1,2}\s+[A-Z][A-Za-z]{1,}" TicDataDescr.txt | tr ',' ';' | tr -d '\r'|   cut -f2,3 --output-delimiter='|' | header -a 'MOSTYPE|MOSTYPECAT' > catalogo_l0.txt
(echo "MOSTYPE|MOSTYPECAT"; egrep -a "^[0-9]{1,2}\s+[0-9]{1,2}\s+[A-Z][A-Za-z]{1,}" TicDataDescr.txt | tr ',' ';' | tr -d '\r' | awk '{print $2 "|" $3}') > catalogo_l0.txt

# guarda copia de catalogo_l0.txt en carpeta catálogos
cat catalogo_l0.txt | tr '|' ',' > catalogos/catalogo_l0.csv

# Catalogo L1 MGEMLEEF - col4
#egrep -a "^[0-9]\s+[0-9]{1,2}\-" TicDataDescr.txt   | cut -f2 --output-delimiter='|'
egrep -a "^[0-9]\s+[0-9]{1,2}-[0-9]{1,2}\s+[a-z]{1,5}" TicDataDescr.txt | awk '{print $1 "|" $2 " " $3}' | header -a 'MGEMLEEF|MGEMLEEFCAT' > catalogo_l1.txt
cat catalogo_l1.txt | tr '|' ',' > catalogos/catalogo_l1.csv

# Catalogo L2 MOSHOOFD - col5
egrep -a "^[0-9]{1,2}\s+[A-Z][a-z]{1,}" TicDataDescr.txt | awk '{print $1 "|" $2 }' | header -a 'MOSHOOFD|MOSHOOFDCAT' > catalogo_l2.txt
cat catalogo_l2.txt | tr '|' ',' > catalogos/catalogo_l2.csv

# Catalogo L3 MGODRK
egrep -a "^[0-9]{1,2}\s+[0-9]{1,3}\s+\-\s+[0-9]{1,2}|[0-9]{1}\%" TicDataDescr.txt | awk '{print $1 "|" $2 $3 $4 }' | header -a 'MGODRK|MGODRKCAT'  > catalogo_l3.txt
cat catalogo_l3.txt | tr '|' ',' > catalogos/catalogo_l3.csv

# L4 PWAPART
egrep -a "^[0-9]{1}\s+[f]\s+" TicDataDescr_clean.txt | awk '{print $1 "|" $3 $4 $5}' | header -a 'PWAPART|PWAPARTCAT' > catalogo_l4.txt
cat catalogo_l4.txt | tr '|' ',' > catalogos/catalogo_l4.csv
echo "Catalogos guardados en carpeta '/catalogos'"

# una los nombres de las columnas con ticdata2000.txt en un nuevo archivo llamado ticdata2000_h.txt
cat nombre_col.txt ticdata2000.txt | tr '\t' '|' | tr -d '\r' > ticdata2000_h.txt

# join de ticdata2000 columna 1 con catalogo l0 MOSTYPE
tr -d '\r' < ticdata2000_h.txt > tmp1.txt 
tr -d '\r' < catalogo_l0.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} { $1 = map[$1]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l0.txt

#sed $'1s/ /|/g' joined_l0.txt > joined_l0_tmp.txt && mv joined_l0_tmp.txt joined_l0.txt

# join de joined_l0 columna 4 con catalogo l1 MGEMLEEF
tr -d '\r' < joined_l0.txt > tmp1.txt
tr -d '\r' < catalogo_l1.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} { $4 = map[$4]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l1.txt

# join de joined_l1 columna 5 con catalogo l2 MOSHOOFD
tr -d '\r' < joined_l1.txt > tmp1.txt
tr -d '\r' < catalogo_l2.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} { $5 = map[$5]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l2.txt

# join de joined_l2 columna 6 con catalogo l3 MGODRK
tr -d '\r' < joined_l2.txt > tmp1.txt
tr -d '\r' < catalogo_l3.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} { $6 = map[$6]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l3.txt

# join de joined_l3 columna 43 con catalogo l4 PWAPART
tr -d '\r' < joined_l3.txt > tmp1.txt
tr -d '\r' < catalogo_l4.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} { $43 = map[$43]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l4.txt

# convertir l4 a psv
# final file is joined_l4.txt
# pipe separated value con encabezados
sed $'1s/ /|/g' joined_l4.txt > joined_l4_tmp.txt && mv joined_l4_tmp.txt joined_l4.txt
cat joined_l4.txt > coil2000_transformado.psv
echo "Archivo transformado guardado como coil2000_transformado.psv"

# remove all files except catalogos, coil2000_transformado.psv and encabezados.txt, README.md and etl_coil2000.sh
find . -maxdepth 1 ! -name 'catalogos' ! -name 'coil2000_transformado.psv' ! -name 'encabezados.txt' ! -name 'README.md' ! -name 'etl_coil2000.sh' -type f -exec rm -f {} +

