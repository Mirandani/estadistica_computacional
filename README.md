#  Estadistica Computacional
# Tarea 3 - Análisis de Base de Datos Bancarios
## Alumno: Daniel Miranda Badillo

## Descripción
Análisis completo del dataset PKDD Discovery Challenge 1999 utilizando SQLite y consultas SQL avanzadas.

## Estructura de Archivos
```
tarea3/ 
├── schema.sql              # Definición de tablas y vistas
├── load_data.sql           # Scripts de carga de datos
├── berka.db               # Base de datos SQLite generada
├── answers.sql            # 14 consultas analíticas
├── answers.md             # Resultados e interpretaciones
├── tarea3.sh              # Script principal de análisis
├── generate_deliverables.sh # Script maestro de generación
├── README.md              # Esta documentación
└── data/
    └── berka/
        ├── account.asc    # Datos de cuentas
        ├── card.asc       # Datos de tarjetas
        ├── client.asc     # Datos de clientes
        ├── disp.asc       # Disposiciones
        ├── district.asc   # Información demográfica
        ├── loan.asc       # Datos de préstamos
        ├── order.asc      # Órdenes permanentes
        └── trans.asc      # Transacciones
``` 

### Archivos de Entrega

| Archivo | Descripción | Contenido |
|---------|-------------|-----------|
| `schema.sql` | Definición de esquema | Tablas, vistas y estructura de BD |
| `load_data.sql` | Instrucciones de carga | Comandos .import para datos |
| `berka.db` | Base de datos completa | BD SQLite con todos los datos |
| `answers.sql` | Consultas numeradas | 14 consultas analíticas |
| `answers.md` | Interpretación de resultados | Análisis y conclusiones |

### Archivos de Trabajo

| Archivo | Descripción |
|---------|-------------|
| `tarea3.sh` | Script principal de análisis |
| `generate_deliverables.sh` | Script maestro para generar entrega |
| `README.md` | Esta documentación |

### Datos

```
data/berka/
├── account.asc    # Cuentas bancarias
├── card.asc       # Tarjetas de crédito/débito
├── client.asc     # Clientes
├── disp.asc       # Disposiciones (cliente-cuenta)
├── district.asc   # Información demográfica
├── loan.asc       # Préstamos
├── order.asc      # Órdenes permanentes
└── trans.asc      # Transacciones
```

## Uso

### Opción 1: Generar todo automáticamente
```bash
./generate_deliverables.sh
```

### Opción 2: Paso a paso
```bash
# 1. Crear esquema
sqlite3 berka.db < schema.sql

# 2. Cargar datos  
sqlite3 berka.db < load_data.sql

# 3. Ejecutar análisis
bash tarea3.sh

```

## Consultas Implementadas

1. **Básicas (1-5)**: Frecuencias, distribuciones, top rankings
2. **Avanzadas (6-10)**: Análisis regionales, tipos de cliente, tendencias temporales
3. **Complejas (11-14)**: Comportamiento post-préstamo, scoring premium, análisis de riesgo

## Tecnologías
- **SQLite3**: Base de datos
- **Bash**: Automatización
- **SQL**: Consultas analíticas con CTEs, window functions, percentiles

## Resultados Clave
- 14 consultas analíticas detalladas
- Segmentación de clientes premium
- Análisis de riesgo crediticio
- Correlación desempleo-morosidad
- Patrones de comportamiento bancario

---
*Desarrollado para el curso de Estadistica Computacional