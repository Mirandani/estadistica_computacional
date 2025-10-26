# Análisis de Datos Bancarios - PKDD Discovery Challenge 1999

## Descripción del Dataset
Base de datos real de un banco checo que contiene información sobre:
- 4,500+ cuentas bancarias, 5,369 clientes, 1M+ transacciones
- 680+ préstamos, información demográfica de 77 distritos

## Resultados de las Consultas SQL

```
frequency           num_accounts
------------------  ------------
POPLATEK MESICNE    4167        
POPLATEK TYDNE      240         
POPLATEK PO OBRATU  93          
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
type    operation       num_transactions
------  --------------  ----------------
VYDAJ   VYBER           418252          
VYDAJ   PREVOD NA UCET  208283          
PRIJEM                  183114          
PRIJEM  VKLAD           156743          
PRIJEM  PREVOD Z UCTU   65226           
VYBER   VYBER           16666           
VYDAJ   VYBER KARTOU    8036            
account_id  num_transactions  last_amount
----------  ----------------  -----------
8261        675               186.7      
3834        665               109.8      
96          661               372.7      
2932        655               104.5      
9307        649               323.6      
9265        643               173.3      
5215        637               273.2      
2762        634               237.9      
1801        633               383.9      
5952        628               286.2      
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
account_id  num_owners  num_disponents  total_dispositions
----------  ----------  --------------  ------------------
2           1           1               2                 
3           1           1               2                 
8           1           1               2                 
12          1           1               2                 
13          1           1               2                 
17          1           1               2                 
29          1           1               2                 
48          1           1               2                 
61          1           1               2                 
63          1           1               2                 
70          1           1               2                 
71          1           1               2                 
72          1           1               2                 
80          1           1               2                 
83          1           1               2                 
86          1           1               2                 
95          1           1               2                 
96          1           1               2                 
97          1           1               2                 
98          1           1               2                 
tipo_tarjeta  num_tarjetas  tasa_por_1000_cuentas  porcentaje_del_total
------------  ------------  ---------------------  --------------------
classic       659           146.44                 73.88               
junior        145           32.22                  16.26               
gold          88            19.56                  9.87                
region           year  num_transacciones  monto_total  monto_promedio
---------------  ----  -----------------  -----------  --------------
Prague           1993  115                685967.0     5964.93       
Prague           1994  362                2044597.0    5648.06       
Prague           1995  463                2613129.0    5643.91       
Prague           1996  597                3368162.0    5641.81       
Prague           1997  850                4796799.0    5643.29       
Prague           1998  996                5603676.0    5626.18       
central Bohemia  1993  159                871839.0     5483.26       
central Bohemia  1994  427                2393151.0    5604.57       
central Bohemia  1995  534                3016736.0    5649.32       
central Bohemia  1996  830                4665859.0    5621.52       
central Bohemia  1997  1184               6571839.0    5550.54       
central Bohemia  1998  1296               7201320.0    5556.57       
east Bohemia     1993  106                563759.0     5318.48       
east Bohemia     1994  284                1543997.0    5436.61       
east Bohemia     1995  422                2316933.0    5490.36       
east Bohemia     1996  682                3759186.0    5512.0        
east Bohemia     1997  977                5406396.0    5533.67       
east Bohemia     1998  1044               5790372.0    5546.33       
north Bohemia    1993  156                790776.0     5069.08       
north Bohemia    1994  321                1684214.0    5246.77       
north Bohemia    1995  435                2314669.0    5321.08       
north Bohemia    1996  576                3086074.0    5357.77       
north Bohemia    1997  808                4400337.0    5445.96       
north Bohemia    1998  864                4703064.0    5443.36       
north Moravia    1993  234                1297464.0    5544.72       
north Moravia    1994  561                3131620.0    5582.21       
north Moravia    1995  757                4150878.0    5483.33       
north Moravia    1996  1094               6065155.0    5544.02       
north Moravia    1997  1461               8127276.0    5562.82       
north Moravia    1998  1668               9282936.0    5565.31       
south Bohemia    1993  59                 344775.0     5843.64       
south Bohemia    1994  126                710028.0     5635.14       
south Bohemia    1995  241                1330335.0    5520.06       
south Bohemia    1996  376                2075341.0    5519.52       
south Bohemia    1997  583                3155062.0    5411.77       
south Bohemia    1998  648                3501348.0    5403.31       
south Moravia    1993  197                1087663.0    5521.13       
south Moravia    1994  433                2363255.0    5457.86       
south Moravia    1995  644                3512413.0    5454.06       
south Moravia    1996  924                5032923.0    5446.89       
south Moravia    1997  1312               7130999.0    5435.21       
south Moravia    1998  1464               7966620.0    5441.68       
west Bohemia     1993  123                694988.0     5650.31       
west Bohemia     1994  305                1695998.0    5560.65       
west Bohemia     1995  407                2239524.0    5502.52       
west Bohemia     1996  552                3062761.0    5548.48       
west Bohemia     1997  781                4337157.0    5553.34       
west Bohemia     1998  900                4982748.0    5536.39       
account_id  last_loan_date  loan_amount  transactions_post_loan  total_credits  total_debits  net_flow
----------  --------------  -----------  ----------------------  -------------  ------------  --------
2           940105          80952        44                      132299.0       134419.8      -2120.8 
19          960429          30276        46                      112186.9       108245.1      3941.8  
25          971208          30276        5                       104.4          12154.8       -12050.4
37          981014          318480       14                      49669.3        20132.7       29536.6 
38          980419          110736       56                      118453.1       121903.8      -3450.7 
67          960502          165960       48                      270580.2       273114.6      -2534.4 
97          970810          102876       45                      99537.6        92249.0       7288.6  
103         971206          265320       6                       15885.7        12214.6       3671.1  
105         981205          352704       3                       94.1           13048.0       -12953.9
110         970908          162576       29                      106364.2       96044.4       10319.8 
132         961106          88440        17                      108095.9       123378.4      -15282.5
173         940531          104808       54                      115823.0       118639.6      -2816.6 
176         970410          27456        59                      349099.8       355491.8      -6392.0 
226         980712          109344       35                      106639.2       119713.0      -13073.8
276         981202          160920       6                       40433.5        29382.5       11051.0 
290         941103          123696       16                      42509.8        46392.2       -3882.4 
303         980530          112752       41                      101680.9       106512.2      -4831.3 
309         981125          91248        8                       28901.7        17355.6       11546.1 
314         970503          66840        38                      240760.1       232500.0      8260.1  
319         970711          369000       55                      196955.2       190314.0      6641.2  
duration  num_loans  avg_payment  min_payment  max_payment  avg_loan_amount  total_to_pay
--------  ---------  -----------  -----------  -----------  ---------------  ------------
12        131        4469.63      415.0        9736.0       53635.51         53635.51    
24        138        4134.08      319.0        8710.0       99217.91         99217.91    
36        130        4001.34      304.0        8339.0       144048.18        144048.18   
48        138        4283.18      334.0        9910.0       205592.7         205592.7    
60        145        4074.18      312.0        9847.0       244450.76        244450.76   
client_id  age  avg_balance  healthy_loan  has_card  premium_score
---------  ---  -----------  ------------  --------  -------------
9717       47   76453.61     1             1         4            
5253       53   76110.07     1             1         4            
13095      49   75639.47     1             1         4            
12378      53   73529.32     1             1         4            
13620      29   73271.69     1             1         4            
13690      36   73259.42     1             1         4            
1133       41   72794.26     1             1         4            
5376       29   70888.95     1             1         4            
7127       42   70233.51     1             1         4            
12599      43   69377.26     1             1         4            
2686       48   69319.47     1             1         4            
5232       51   68942.87     1             1         4            
6610       45   68515.3      1             1         4            
10040      31   68464.94     1             1         4            
3519       50   67985.42     1             1         4            
2267       33   67825.29     1             1         4            
13134      37   67736.73     1             1         4            
9569       49   67486.63     1             1         4            
5366       28   67194.59     1             1         4            
10528      47   66296.53     1             1         4            
2739       49   66185.96     1             1         4            
414        52   65889.69     1             1         4            
10636      28   65871.97     1             1         4            
9641       54   65701.56     1             1         4            
5727       46   65213.01     1             1         4            
10145      34   81192.76     0             1         3            
5204       36   79906.27     0             1         3            
2329       26   78237.64     0             1         3            
1705       53   77371.24     1             0         3            
2982       26   76095.82     0             1         3            
254        36   75988.29     0             1         3            
10912      36   75910.51     0             1         3            
114        30   75665.41     0             1         3            
2762       46   75360.55     0             1         3            
1246       37   74787.91     0             1         3            
1799       40   74517.27     0             1         3            
5128       36   74434.18     0             1         3            
2320       48   73785.02     0             1         3            
2156       33   73729.04     0             1         3            
2332       50   73530.23     0             1         3            
unemployment_quintile  total_loans  bad_loans  default_rate  avg_unemployment_rate  min_unemployment  max_unemployment
---------------------  -----------  ---------  ------------  ---------------------  ----------------  ----------------
Q1 (Bajo desempleo)    84           7          8.33          0.43                   0.43              0.43            
Q2                     44           4          9.09          1.11                   0.54              1.54            
Q3                     86           12         13.95         1.94                   1.71              2.21            
Q4                     176          22         12.5          3.06                   2.26              3.76            
Q5 (Alto desempleo)    292          31         10.62         5.54                   3.95              9.4             
```

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

