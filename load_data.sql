-- Instrucciones para carga de datos PKDD Discovery Challenge 1999
-- Base de datos bancaria Berka

-- Configurar separador de campos
.separator ";"

-- Crear tablas temporales para importar con headers
CREATE TEMP TABLE temp_accounts (
    account_id TEXT,
    district_id TEXT, 
    frequency TEXT,
    date TEXT
);

CREATE TEMP TABLE temp_cards (
    card_id TEXT,
    disp_id TEXT,
    type TEXT,
    issued TEXT
);

CREATE TEMP TABLE temp_clients (
    client_id TEXT,
    birth_number TEXT,
    district_id TEXT
);

CREATE TEMP TABLE temp_dispositions (
    disp_id TEXT,
    client_id TEXT,
    account_id TEXT,
    type TEXT
);

CREATE TEMP TABLE temp_districts (
    A1 TEXT, A2 TEXT, A3 TEXT, A4 TEXT, A5 TEXT, A6 TEXT, A7 TEXT, A8 TEXT,
    A9 TEXT, A10 TEXT, A11 TEXT, A12 TEXT, A13 TEXT, A14 TEXT, A15 TEXT, A16 TEXT
);

CREATE TEMP TABLE temp_loans (
    loan_id TEXT,
    account_id TEXT,
    date TEXT,
    amount TEXT,
    duration TEXT,
    payments TEXT,
    status TEXT
);

CREATE TEMP TABLE temp_orders (
    order_id TEXT,
    account_id TEXT,
    bank_to TEXT,
    account_to TEXT,
    amount TEXT,
    k_symbol TEXT
);

CREATE TEMP TABLE temp_transactions (
    trans_id TEXT,
    account_id TEXT,
    date TEXT,
    type TEXT,
    operation TEXT,
    amount TEXT,
    balance TEXT,
    k_symbol TEXT,
    bank TEXT,
    account TEXT
);

-- Importar a tablas temporales (incluirá headers)
.import data/berka/account.asc temp_accounts
.import data/berka/card.asc temp_cards
.import data/berka/client.asc temp_clients
.import data/berka/disp.asc temp_dispositions
.import data/berka/district.asc temp_districts
.import data/berka/loan.asc temp_loans
.import data/berka/order.asc temp_orders
.import data/berka/trans.asc temp_transactions

-- Copiar datos excluyendo headers a tablas finales
INSERT INTO accounts SELECT 
    CAST(account_id AS INTEGER),
    CAST(district_id AS INTEGER),
    frequency,
    date
FROM temp_accounts WHERE account_id != 'account_id';

INSERT INTO cards SELECT 
    CAST(card_id AS INTEGER),
    CAST(disp_id AS INTEGER),
    type,
    issued
FROM temp_cards WHERE card_id != 'card_id';

INSERT INTO clients SELECT 
    CAST(client_id AS INTEGER),
    birth_number,
    CAST(district_id AS INTEGER)
FROM temp_clients WHERE client_id != 'client_id';

INSERT INTO dispositions SELECT 
    CAST(disp_id AS INTEGER),
    CAST(client_id AS INTEGER),
    CAST(account_id AS INTEGER),
    type
FROM temp_dispositions WHERE disp_id != 'disp_id';

INSERT INTO districts SELECT 
    CAST(A1 AS INTEGER),
    A2, A3,
    CASE WHEN A4 = 'A4' THEN NULL ELSE CAST(A4 AS INTEGER) END,
    CASE WHEN A5 = 'A5' THEN NULL ELSE CAST(A5 AS INTEGER) END,
    CASE WHEN A6 = 'A6' THEN NULL ELSE CAST(A6 AS INTEGER) END,
    CASE WHEN A7 = 'A7' THEN NULL ELSE CAST(A7 AS INTEGER) END,
    CASE WHEN A8 = 'A8' THEN NULL ELSE CAST(A8 AS INTEGER) END,
    CASE WHEN A9 = 'A9' THEN NULL ELSE CAST(A9 AS INTEGER) END,
    CASE WHEN A10 = 'A10' THEN NULL ELSE CAST(A10 AS REAL) END,
    CASE WHEN A11 = 'A11' THEN NULL ELSE CAST(A11 AS REAL) END,
    CASE WHEN A12 = 'A12' THEN NULL ELSE CAST(A12 AS REAL) END,
    CASE WHEN A13 = 'A13' THEN NULL ELSE CAST(A13 AS REAL) END,
    CASE WHEN A14 = 'A14' THEN NULL ELSE CAST(A14 AS INTEGER) END,
    CASE WHEN A15 = 'A15' THEN NULL ELSE CAST(A15 AS INTEGER) END,
    CASE WHEN A16 = 'A16' THEN NULL ELSE CAST(A16 AS INTEGER) END
FROM temp_districts WHERE A1 != 'A1';

INSERT INTO loans SELECT 
    CAST(loan_id AS INTEGER),
    CAST(account_id AS INTEGER),
    date,
    CAST(amount AS INTEGER),
    CAST(duration AS INTEGER),
    CAST(payments AS REAL),
    status
FROM temp_loans WHERE loan_id != 'loan_id';

INSERT INTO orders SELECT 
    CAST(order_id AS INTEGER),
    CAST(account_id AS INTEGER),
    bank_to,
    account_to,
    CAST(amount AS REAL),
    k_symbol
FROM temp_orders WHERE order_id != 'order_id';

INSERT INTO transactions SELECT 
    CAST(trans_id AS INTEGER),
    CAST(account_id AS INTEGER),
    date,
    type,
    operation,
    CAST(amount AS REAL),
    CAST(balance AS REAL),
    k_symbol,
    bank,
    account
FROM temp_transactions WHERE trans_id != 'trans_id';

-- Verificar carga de datos
.headers on
.mode column

-- Mostrar conteo de registros por tabla
SELECT 'accounts' as tabla, COUNT(*) as registros FROM accounts
UNION ALL
SELECT 'cards' as tabla, COUNT(*) as registros FROM cards  
UNION ALL
SELECT 'clients' as tabla, COUNT(*) as registros FROM clients
UNION ALL
SELECT 'dispositions' as tabla, COUNT(*) as registros FROM dispositions
UNION ALL
SELECT 'districts' as tabla, COUNT(*) as registros FROM districts
UNION ALL
SELECT 'loans' as tabla, COUNT(*) as registros FROM loans
UNION ALL
SELECT 'orders' as tabla, COUNT(*) as registros FROM orders
UNION ALL
SELECT 'transactions' as tabla, COUNT(*) as registros FROM transactions;