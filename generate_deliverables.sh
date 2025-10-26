#!/bin/bash
set -e # salir si hay error

echo "<<<======================================"
echo ">>>  GENERACIÓN DE ENTREGABLES - TAREA 3"
echo "<<<======================================"

# Verificar SQLite - Instalar automáticamente si no existe
if ! command -v sqlite3 &> /dev/null; then
    echo "SQLite3 no encontrado. Instalando automáticamente..."
    
    # Detectar el sistema operativo e instalar
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        echo "Instalando SQLite3 en Ubuntu/Debian..."
        apt-get update && apt-get install -y sqlite3
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        echo "Instalando SQLite3 en CentOS/RHEL..."
        yum install -y sqlite
    elif command -v apk &> /dev/null; then
        # Alpine Linux
        echo "Instalando SQLite3 en Alpine..."
        apk add --no-cache sqlite
    elif command -v brew &> /dev/null; then
        # macOS
        echo "Instalando SQLite3 en macOS..."
        brew install sqlite
    else
        echo "ERROR: No se pudo instalar SQLite3 automáticamente."
        echo "Sistema operativo no soportado para instalación automática."
        echo "Por favor instala SQLite3 manualmente."
        exit 1
    fi
    
    # Verificar que la instalación fue exitosa
    if ! command -v sqlite3 &> /dev/null; then
        echo "ERROR: La instalación de SQLite3 falló."
        exit 1
    fi
    
    echo "SQLite3 instalado correctamente."
else
    echo "SQLite3 encontrado"
fi

# Verificar que existen los datos
echo ">>> Descargando datos de entrada..."
if [ ! -d "data/berka" ] || [ ! -f "data/berka/account.asc" ]; then
    echo "Descargando datos PKDD Discovery Challenge 1999..."
    mkdir -p data/berka
    curl -L "https://web.archive.org/web/20070214120527/http://lisp.vse.cz/pkdd99/DATA/data_berka.zip" -o data/berka/data_berka.zip
    unzip -o data/berka/data_berka.zip -d data/berka
    rm data/berka/data_berka.zip
    echo "Datos descargados y descomprimidos."
else
    echo "Datos ya disponibles en data/berka/"
fi

# Limpiar archivos previos
echo ">>> Limpiando archivos anteriores..."
rm -f berka.db

# 1. Crear base de datos con esquema
echo ">>>  Creando esquema de base de datos..."
sqlite3 berka.db < schema.sql

# 2. Cargar datos
echo "Cargando datos desde archivos .asc..."
sqlite3 berka.db < load_data.sql

# 3. Ejecutar consultas desde answers.sql y agregar interpretaciones
echo ">>>  Ejecutando consultas SQL desde answers.sql..."

# Crear header del archivo
cat > answers.md << 'EOF'
# Análisis de Datos Bancarios - PKDD Discovery Challenge 1999

## Descripción del Dataset
Base de datos real de un banco checo que contiene información sobre:
- 4,500+ cuentas bancarias, 5,369 clientes, 1M+ transacciones
- 680+ préstamos, información demográfica de 77 distritos

## Resultados de las Consultas SQL

EOF

# Ejecutar todas las consultas y agregar resultados
echo '```' >> answers.md
sqlite3 berka.db < answers.sql >> answers.md
echo '```' >> answers.md
echo "" >> answers.md

# Agregar interpretaciones al final
cat >> answers.md << 'EOF'
## Interpretación de Resultados

## RESULTADOS DE CONSULTAS SQL
### 1. Distribución de Cuentas por Frecuencia
**Interpretación:** La mayoría de clientes prefieren estados de cuenta mensuale (POPLATEK MESICNE), seguido por cuota semanal (POPLATEK TYDNE ). Por ultimo hay de tarfia despues de transaccion (POPLATEK PO OBRATU )
frequency           num_accounts
------------------  ------------
POPLATEK MESICNE    4167        
POPLATEK TYDNE      240         
POPLATEK PO OBRATU  93    

### 2. Clientes por Región
**Interpretación:** En Checa, la region de south Moravia tiene la mayor cantidad de clientes, seguida por north Moravia y cebtral Bohemia.
La mayor cantidad de clientes estáan en la region historica de moravia-Bohemia, reflejando la distribución poblacional del país.
region           num_clients
---------------  -----------
south Moravia    937        
north Moravia    920        
central Bohemia  664        
Prague           663        
east Bohemia     660        
north Bohemia    561        
west Bohemia     515        
south Bohemia    449  

### 3. Edad Promedio por Región  
**Interpretación:** Las edades promedio en regiones varian entre 45 y 47 años, la mas joven en promedio es east Bohemia y la mas grande north Moravia con 46.6 años

region           edad_promedio
---------------  -------------
north Moravia    46.6         
north Bohemia    46.0         
Prague           45.9         
south Bohemia    45.7         
west Bohemia     45.7         
central Bohemia  45.5         
south Moravia    45.5         
east Bohemia     45.4   

### 4. Tipos de Transacciones
**Interpretación:** VYDAJ   VYBER (Retiro en efectivo)  es el tipo de transacción mas común , corresponde a retiros en efectivo. 
PREVOD NA UCET(Transferencia a cuenta) es el segundo tipo de transacción
PRIJEM Z UCTU (Ingreso a cuenta) es el tercer tipo de transacción mas común

### 5. Cuentas con Mayor Actividad
**Interpretación:** Las cuentas más activas tienen +600 transacciones mensuales.

### 6. Préstamos Morosos por Región
**Interpretación:** Las zonas de Moraavia tienen mayor numero de prestamos morosos.

region           num_loans_morosos  porcentaje_del_total_morosos
---------------  -----------------  ----------------------------
north Moravia    18                 23.68                       
south Moravia    13                 17.11                       
central Bohemia  10                 13.16                       
west Bohemia     9                  11.84                       
south Bohemia    9                  11.84                       
east Bohemia     9                  11.84                       
Prague           7                  9.21                        
north Bohemia    1                  1.32     

### 7.  Porcentaje de morosos (status B, D) por región
**Interpretación:**  West Bohemia y North Moravia presentan las tasas más altas de morosidad en préstamos, superando el 15%. En contraste, North Bohemia tiene una tasa muy baja de solo 1.64%, indicando una mejor salud crediticia en esa región.

region           total_loans  loans_morosos  porcentaje_morosos
---------------  -----------  -------------  ------------------
west Bohemia     57           9              15.79             
north Moravia    117          18             15.38             
south Bohemia    60           9              15.0              
central Bohemia  90           10             11.11             
east Bohemia     84           9              10.71             
south Moravia    129          13             10.08             
Prague           84           7              8.33              
north Bohemia    61           1              1.64  

### 8. Dueños y usuarios por cuenta. -- Para cada account_id, indica cuántos OWNER y cuántos DISPONENT existen.
**Interpretación:** La mayoría de cuentas tienen un solo propietario. Pocas cuentas tienen usuarios adicionales (DISPONENT).

### 9.  Uso de tarjetas por tipo. -- Muestra el número de tarjetas por card.type y la tasa por cada 1 000 cuentas.
**Interpretación:** Baja adopción de tarjetas (~15% de cuentas), predominando tarjetas clásicas sobre gold/junior. Mercado en desarrollo.

tipo_tarjeta  num_tarjetas  tasa_por_1000_cuentas  porcentaje_del_total
------------  ------------  ---------------------  --------------------
classic       659           146.44                 73.88               
junior        145           32.22                  16.26               
gold          88            19.56                  9.87    


### 10. Pagos de pensión (DUCHOD). -- Calcula el número de transacciones y el monto total por región y año.
**Interpretación:** Se calcula por region y por año los pagos de pensión (DUCHOD). Se observa una distribución geográfica uniforme de pensiones, con incrementos anuales consistentes.

region           year  num_transacciones  monto_total  monto_promedio
---------------  ----  -----------------  -----------  --------------
Prague           1993  115                685967.0     5964.93       
Prague           1994  362                2044597.0    5648.06       
Prague           1995  463                2613129.0    5643.91       
Prague           1996  597                3368162.0    5641.81       
Prague           1997  850                4796799.0    5643.29       
Prague           1998  996                5603676.0    5626.18 

### 11. Flujo posterior al préstamo. -- Para las cuentas con préstamo, calcula los créditos, débitos y saldo neto en los 6 meses posteriores a la fecha del préstamo.
**Interpretación:** Los clientes muestran mayor actividad transaccional en los 6 meses posteriores al préstamo, con flujos netos variables.

account_id  last_loan_date  loan_amount  transactions_post_loan  total_credits  total_debits  net_flow
----------  --------------  -----------  ----------------------  -------------  ------------  --------
2           940105          80952        44                      132299.0       134419.8      -2120.8 
19          960429          30276        46                      112186.9       108245.1      3941.8  

### 12. Duración y pagos de los préstamos. -- Muestra el promedio y percentiles de payments agrupados por duration.
**Interpretación:** Relación directa entre duración del préstamo y monto de pagos mensuales. Préstamos a 60 meses tienen pagos más altos.

duration  num_loans  avg_payment  min_payment  max_payment  avg_loan_amount  total_to_pay
--------  ---------  -----------  -----------  -----------  ---------------  ------------
12        131        4469.63      415.0        9736.0       53635.51         53635.51    
24        138        4134.08      319.0        8710.0       99217.91         99217.91    
36        130        4001.34      304.0        8339.0       144048.18        144048.18   
48        138        4283.18      334.0        9910.0       205592.7         205592.7    
60        145        4074.18      312.0        9847.0       244450.76        244450.76 

### 13. Perfil de Clientes Premium
**Interpretación:** Clientes premium (edad 25-55, alto balance > 65000, préstamos sano A y C, con tarjeta), si cumple con todo tiene un puntaje de 4. 

client_id  age  avg_balance  healthy_loan  has_card  premium_score
---------  ---  -----------  ------------  --------  -------------
5563       49   75595.63     1             1         4            
3763       48   73383.99     1             1         4    

### 14.  Riesgo por desempleo. -- Relaciona el desempeño de los préstamos (loan.status) con el desempleo (district.A12 o A13). -- Agrupa por quintiles de desempleo y calcula la tasa de morosidad.
**Interpretación:** Las tasas de morosidad no muestran una correlación directa con los niveles de desempleo. El quintil con menor desempleo tiene una tasa de morosidad del 8.33%, mientras que el quintil con mayor desempleo tiene una tasa del 10.62%. 

unemployment_quintile  total_loans  bad_loans  default_rate  avg_unemployment_rate  min_unemployment  max_unemployment
---------------------  -----------  ---------  ------------  ---------------------  ----------------  ----------------
Q1 (Bajo desempleo)    84           7          8.33          0.43                   0.43              0.43            
Q2                     44           4          9.09          1.11                   0.54              1.54            
Q3                     86           12         13.95         1.94                   1.71              2.21            
Q4                     176          22         12.5          3.06                   2.26              3.76            
Q5 (Alto desempleo)    292          31         10.62         5.54                   3.95              9.4 

EOF

echo "Consultas ejecutadas y resultados interpretados."# 4. Verificar archivos generados
echo ""
echo "ARCHIVOS GENERADOS:"
echo "====================="

if [ -f "schema.sql" ]; then
    echo "schema.sql - $(wc -l < schema.sql) líneas"
else
    echo "schema.sql - FALTANTE"
fi

if [ -f "load_data.sql" ]; then
    echo "load_data.sql - $(wc -l < load_data.sql) líneas"
else
    echo "load_data.sql - FALTANTE"
fi

if [ -f "berka.db" ]; then
    db_size=$(du -h berka.db | cut -f1)
    echo "berka.db - $db_size"
else
    echo "berka.db - FALTANTE"
fi

if [ -f "answers.sql" ]; then
    echo "answers.sql - $(wc -l < answers.sql) líneas"
else
    echo "answers.sql - FALTANTE"
fi

if [ -f "answers.md" ]; then
    echo "answers.md - $(wc -l < answers.md) líneas"
else
    echo "answers.md - FALTANTE"
fi

echo ""
echo ""
echo "¡Proceso terminado !"