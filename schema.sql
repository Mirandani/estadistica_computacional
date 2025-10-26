-- Schema para Base de Datos PKDD Discovery Challenge 1999
-- Tablas principales del dataset bancario Berka

-- Configuración inicial
.separator ";"

-- Tabla: Cuentas bancarias
-- account_id | district_id | frequency | date
CREATE TABLE IF NOT EXISTS accounts (
    account_id INTEGER PRIMARY KEY,
    district_id INTEGER,
    frequency TEXT,
    date TEXT
);

-- Tabla: Tarjetas de crédito/débito  
-- card_id | disp_id | type | issued
CREATE TABLE IF NOT EXISTS cards (
    card_id INTEGER PRIMARY KEY,
    disp_id INTEGER,
    type TEXT,
    issued TEXT
);

-- Tabla: Clientes
-- client_id | birth_number | district_id
CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER PRIMARY KEY,
    birth_number TEXT,
    district_id INTEGER
);

-- Tabla: Disposiciones (relación cliente-cuenta)
-- disp_id | client_id | account_id | type
CREATE TABLE IF NOT EXISTS dispositions (
    disp_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    account_id INTEGER,
    type TEXT
);

-- Tabla: Distritos (información demográfica)
-- A1=district_id | A2=district_name | A3=region | A4=population | etc.
CREATE TABLE IF NOT EXISTS districts (
    A1 INTEGER PRIMARY KEY,  -- district_id
    A2 TEXT,                 -- district_name  
    A3 TEXT,                 -- region
    A4 INTEGER,              -- population
    A5 INTEGER,              -- municipality with inhabitants < 499
    A6 INTEGER,              -- municipality with inhabitants 500-1999
    A7 INTEGER,              -- municipality with inhabitants 2000-9999
    A8 INTEGER,              -- municipality with inhabitants >= 10000
    A9 INTEGER,              -- cities
    A10 REAL,                -- ratio of urban inhabitants
    A11 REAL,                -- average salary
    A12 REAL,                -- unemployment rate 1995
    A13 REAL,                -- unemployment rate 1996
    A14 INTEGER,             -- entrepreneurs per 1000 inhabitants
    A15 INTEGER,             -- crimes committed in 1995
    A16 INTEGER              -- crimes committed in 1996
);

-- Tabla: Préstamos
-- loan_id | account_id | date | amount | duration | payments | status
CREATE TABLE IF NOT EXISTS loans (
    loan_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date TEXT,
    amount INTEGER,
    duration INTEGER,
    payments REAL,
    status TEXT
);

-- Tabla: Órdenes permanentes
-- order_id | account_id | bank_to | account_to | amount | k_symbol
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    bank_to TEXT,
    account_to TEXT,
    amount REAL,
    k_symbol TEXT
);

-- Tabla: Transacciones
-- trans_id | account_id | date | type | operation | amount | balance | k_symbol | bank | account
CREATE TABLE IF NOT EXISTS transactions (
    trans_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date TEXT,
    type TEXT,
    operation TEXT,
    amount REAL,
    balance REAL,
    k_symbol TEXT,
    bank TEXT,
    account TEXT
);

-- Vistas auxiliares creadas durante el análisis

-- Vista: Clientes por región
CREATE VIEW IF NOT EXISTS client_region AS
SELECT 
    districts.A3 AS region,
    COUNT(clients.client_id) AS num_clients
FROM clients
LEFT JOIN districts ON clients.district_id = districts.A1
GROUP BY districts.A3
ORDER BY num_clients DESC;

-- Vista: Edad promedio por región
DROP VIEW IF EXISTS avg_age_region;
CREATE VIEW avg_age_region AS
SELECT 
    districts.A3 AS region,
    AVG(1999 - (1900 + CAST(SUBSTR(clients.birth_number, 1, 2) AS INTEGER))) AS avg_age
FROM clients
LEFT JOIN districts ON clients.district_id = districts.A1
WHERE districts.A3 IS NOT NULL
GROUP BY districts.A3;