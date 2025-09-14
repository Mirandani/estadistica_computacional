#!/bin/bash
# ETL script for Coil2000 dataset
wget https://archive.ics.uci.edu/static/public/125/insurance+company+benchmark+coil+2000.zip
unzip insurance+company+benchmark+coil+2000.zip

# column names en un nuevo archivo
# l1 regex

# lista columnas
egrep -a "^[0-9]{1,2}\s[A-Z]{2,}" TicDataDescr.txt | cut -d" " -f2 |tr -d '\r'| paste -sd $'\t' > nombre_col.txt

# LO MOSTYPE
egrep -a "^[0-9]{1,2}\s+[0-9]{1,2}\s+[A-Z][A-Za-z]{1,}" TicDataDescr.txt | tr -d '\r'|   cut -f2,3 --output-delimiter='|' | header -a 'MOSTYPE|MOSTYPECAT' > catalogo_l0.txt

# L1 MGEMLEEF - col4
#egrep -a "^[0-9]\s+[0-9]{1,2}\-" TicDataDescr.txt   | cut -f2 --output-delimiter='|'
$ egrep -a "^[0-9]\s+[0-9]{1,2}-[0-9]{1,2}\s+[a-z]{1,5}" TicDataDescr.txt | awk '{print $1 "|" $2 " " $3}' | header -a 'MGEMLEEF|MGEMLEEFCAT' > catalogo_l1.txt

# L2 MOSHOOFD
egrep -a "^[0-9]{1,2}\s+[A-Z][a-z]{1,}" TicDataDescr.txt | awk '{print $1 "|" $2 }' | header -a 'MOSHOOFD|MOSHOOFDCAT' > catalogo_l2.txt

# L3 MGODRK
egrep -a "^[0-9]{1,2}\s+[0-9]{1,3}\s+\-\s+[0-9]{1,2}|[0-9]{1}\%" TicDataDescr.txt | awk '{print $1 "|" $2 $3 $4 }' | header -a 'MGODRK|MGODRKCAT'  > catalogo_l3.txt

# L4 PWAPART
egrep -a "^[0-9]{1}\s+[f]\s+" TicDataDescr.txt | awk '{print $1 "|" $3 $4 $5}' | header -a 'PWAPART|PWAPARTCAT' > catalogo_l4.txt

#comandos utiles
#| cut -d $'\t' -f2,3
#|od -xc 
# tr translate

cat nombre_col.txt ticdata2000.txt | tr '\t' '|' |tr -d '\r'|  > ticdata2000_h.txt

# lookup
# sort los archivos por la columna de join - ordenar por la primera columna (MOSTYPE)
sort -t "|" -k1,1n ticdata2000_h.txt > ticdata2000_h_sorted.txt
tr -d '\r' < ticdata2000_h_sorted.txt > tmp1.txt
#tail -n +2 tmp1.txt > tmp1_tic_nohead.txt


# sort de catalogo_l0 para join - ordenar por la primera columna (MOSTYPE)
sort -t "|" -k1,1n catalogo_l0.txt > catalogo_l0_sorted.txt
tr -d '\r' < catalogo_l0_sorted.txt > tmp2.txt
#tail -n +2 tmp2.txt > tmp2_cat_nohead.txt

#join -t "|" -1 1 -2 1 -o 2.2,1.2,1.3,1.4,1.5,1.6 tmp1.txt tmp2.txt > joined_l0.txt
awk -F"|" 'NR==FNR {map[$1]=$2; next} 
           { $1 = map[$1]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l0.txt


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
sort -t "|" -k4,4n ticdata2000_h.txt > ticdata2000_h_sorted.txt
tr -d '\r' < ticdata2000_h_sorted.txt > tmp1.txt
# sort de catalogo_l1 para join - ordenar por la primera columna (MGEMLEEF)
sort -t "|" -k1,1n catalogo_l1.txt > catalogo_l1_sorted.txt
tr -d '\r' < catalogo_l1_sorted.txt > tmp2.txt

awk -F"|" 'NR==FNR {map[$1]=$2; next} 
{ $4 = map[$4]; OFS="|"; print }' tmp2.txt tmp1.txt > joined_l1.txt           