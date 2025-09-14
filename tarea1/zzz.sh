#!/bin/bash
# ETL script for Coil2000 dataset
#wget https://archive.ics.uci.edu/static/public/125/insurance+company+benchmark+coil+2000.zip
#unzip insurance+company+benchmark+coil+2000.zip

#  conversion de archivos a UTF-8 y eliminar \r
iconv -f WINDOWS-1252 -t UTF-8 TicDataDescr.txt > TicDataDescr_clean.txt

# column names en un nuevo archivo
# l1 regex

# lista columnas
egrep -a "^[0-9]{1,2}\s[A-Z]{2,}" TicDataDescr_clean.txt | cut -d" " -f2 | paste -sd $'\t' > nombre_col.txt

# LO MOSTYPE 
egrep -a "^[0-9]{1,2}\s+[0-9]{1,2}\s+[A-Z][A-Za-z]{1,}" TicDataDescr_clean.txt | tr -d '\r'|   cut -f2,3 --output-delimiter='|' | header -a 'MOSTYPE|MOSTYPECAT' > catalogo_l0.txt

# L1 MGEMLEEF - col4
#egrep -a "^[0-9]\s+[0-9]{1,2}\-" TicDataDescr.txt   | cut -f2 --output-delimiter='|'
egrep -a "^[0-9]\s+[0-9]{1,2}-[0-9]{1,2}\s+[a-z]{1,5}" TicDataDescr_clean.txt | awk '{print $1 "|" $2 " " $3}' | header -a 'MGEMLEEF|MGEMLEEFCAT' > catalogo_l1.txt

# L2 MOSHOOFD - col5
egrep -a "^[0-9]{1,2}\s+[A-Z][a-z]{1,}" TicDataDescr_clean.txt | awk '{print $1 "|" $2 }' | header -a 'MOSHOOFD|MOSHOOFDCAT' > catalogo_l2.txt

# L3 MGODRK
egrep -a "^[0-9]{1,2}\s+[0-9]{1,3}\s+\-\s+[0-9]{1,2}|[0-9]{1}\%" TicDataDescr_clean.txt | awk '{print $1 "|" $2 $3 $4 }' | header -a 'MGODRK|MGODRKCAT'  > catalogo_l3.txt

# L4 PWAPART
egrep -a "^[0-9]{1}\s+[f]\s+" TicDataDescr_clean.txt | awk '{print $1 "|" $3 $4 $5}' | header -a 'PWAPART|PWAPARTCAT' > catalogo_l4.txt

#comandos utiles
#| cut -d $'\t' -f2,3
#|od -xc 
# tr translate

cat nombre_col.txt ticdata2000.txt | tr '\t' '|'  > ticdata2000_h.txt

# lookup
# sort los archivos por la columna de join - ordenar por la primera columna (MOSTYPE)
sort -t "|" -k1,1n ticdata2000_h.txt > ticdata2000_h_sorted.txt

# sort de catalogo_l0 para join - ordenar por la primera columna (MOSTYPE)
sort -t "|" -k1,1n catalogo_l0.txt > catalogo_l0_sorted.txt

#join -t "|" -1 1 -2 1 -o 2.2,1.2,1.3,1.4,1.5,1.6 tmp1.txt tmp2.txt > joined_l0.txt
awk -F"|"  'NR==FNR {map[$1]=$2; next} 
            FNR==1 {print; next} 
           { $1 = map[$1]; OFS="|"; print }' catalogo_l0_sorted.txt ticdata2000_h_sorted.txt > joined_l0.txt


# como conservo todas las columnas de ticdata2000_h.txt y solo reemplazo MOSTYPE por MOSTYPECAT?
#join -t "|" -1 1 -2 1 -o 2.2,1.2,1.3,1.4,1.5,1.6 tmp1.txt tmp2.txt > joined_l0.txt
# join ticdata200 con catalogo_l0 
# -1 usar campo 1 de ticdata2000_h.txt a la izquierda 
# -2 usar campo 1 de catalogo_l0.txt a la derecha
# -o 1.1,2.2,1.2,1.3 → campos que queremos en la salida:
# 1.1 → MOSTYPE de tabla1 (opcional, puedes omitir)
# 2.2 → MOSTYPECAT de tabla2 (el valor que quieres reemplazar)
# join -t "|" -1 1 -2 1 -o 1.1,2.2,1.2,1.3 ticdata2000_h_sorted.txt catalogo_l0_sorted.txt > joined_l0.txt

# sort los archivos por la columna de join - ordenar por la cuarta columna (MGEMLEEF)
sort -t "|" -k4,4n joined_l0.txt > joined_l0_h_sorted.txt
joined_l0_h_sorted.txt > tmp1.txt
# sort de catalogo_l1 para join - ordenar por la primera columna (MGEMLEEF)
sort -t "|" -k1,1n catalogo_l1.txt > catalogo_l1_sorted.txt
catalogo_l1_sorted.txt > tmp2.txt

awk -F"|" 'NR==FNR {map[$1]=$2; next} 
{ $4 = map[$4]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l1.txt        


# sort de joined_l1 MOSHOOFD - col5
sort -t "|" -k5,5n joined_l1.txt > joined_l1_h_sorted.txt
tr -d '\r' < joined_l1_h_sorted.txt > tmp1.txt
# sort de catalogo_l2 para join - ordenar por la primera columna (MOSHOO
sort -t "|" -k1,1n catalogo_l2.txt > catalogo_l2_sorted.txt
tr -d '\r' < catalogo_l2_sorted.txt > tmp2.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} 
{ $5 = map[$5]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l2.txt

# sort de joined_l2 MGODRK - para armar col6 MGODRK Roman catholic see L3
sort -t "|" -k6,6n joined_l2.txt > joined_l2_h_sorted.txt
tr -d '\r' < joined_l2_h_sorted.txt > tmp1.txt
# sort de catalogo_l3 para join - ordenar por la primera columna (MGODRK
#sort -t "|" -k1,1n catalogo_l3.txt > catalogo_l3_sorted.txt
(head -n1 catalogo_l3.txt && tail -n +2 catalogo_l3.txt | sort -t "|" -k1,1n | tr -d '\r') > catalogo_l3_sorted.txt
tr -d '\r' < catalogo_l3_sorted.txt > tmp2.txt

awk -F"|" 'NR==FNR {map[$1]=$2; next} 
{ $6 = map[$6]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l3.txt


# sort de joined_l3 PWAPART - col 44
sort -t "|" -k44,44n joined_l3.txt > joined_l3_h_sorted.txt
tr -d '\r' < joined_l3_h_sorted.txt > tmp1.txt
# sort de catalogo_l4 para join - ordenar por la primera columna (PWAPART
# sort -t "|" -k1,1n catalogo_l4.txt > catalogo_l4_sorted.txt
(head -n1 catalogo_l4.txt && tail -n +2 catalogo_l4.txt | sort -t "|" -k1,1n | tr -d '\r') > catalogo_l4_sorted.txt
tr -d '\r' < catalogo_l4_sorted.txt > tmp2.txt  
awk -F"|" 'NR==FNR {map[$1]=$2; next} 
{ $44 = map[$44]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l4.txt