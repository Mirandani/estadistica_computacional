-- Consultas SQL para responder las preguntas de la tarea 3
-- Competencia PKDD Discovery Challenge 1999
-- Dataset bancario Berka

-- Configuración inicial
.separator ";"
.headers on
.mode column

-- 1.  Número de cuentas por frecuencia de estado de cuenta. -- Agrupa por frequency y ordena de mayor a menor.

SELECT frequency, COUNT(*) AS num_accounts
FROM accounts
GROUP BY frequency
ORDER BY num_accounts DESC;

-- # 2. Número de clientes por región. -- Une client con district y agrupa por A3 (región).

SELECT 
    districts.A3 AS region,
    COUNT(clients.client_id) AS num_clients
FROM clients
LEFT JOIN districts ON clients.district_id = districts.A1
GROUP BY districts.A3
ORDER BY num_clients DESC;

# 3. Edad promedio de los clientes por región. -- Calcula la edad promedio por región.

SELECT 
    region,
    ROUND(avg_age, 1) AS edad_promedio
FROM avg_age_region
ORDER BY edad_promedio DESC;

-- # 4 Distribución de tipos de transacción. -- Agrupa por type y operation.

SELECT 
    type,
    operation,
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY type, operation
ORDER BY num_transactions DESC;

-- # 5. Top 10 cuentas con mayor número de transacciones. -- Muestra el account_id, la cantidad de transacciones y el saldo final (última transacción).

SELECT
    t1.account_id,
    COUNT(*) AS num_transactions,
    (SELECT amount 
     FROM transactions t2 
     WHERE t2.account_id = t1.account_id 
     ORDER BY t2.date DESC, t2.trans_id DESC 
     LIMIT 1) AS last_amount
FROM transactions t1
GROUP BY t1.account_id
ORDER BY num_transactions DESC
LIMIT 10;

--- # Consultas AVANZADAS

-- 6  Conteo de préstamos morosos por región
SELECT 
    districts.A3 AS region,
    COUNT(loans.loan_id) AS num_loans_morosos,
    ROUND(COUNT(loans.loan_id) * 100.0 / (SELECT COUNT(*) FROM loans WHERE status IN ('B', 'D')), 2) AS porcentaje_del_total_morosos
FROM loans
LEFT JOIN accounts ON loans.account_id = accounts.account_id
LEFT JOIN districts ON accounts.district_id = districts.A1
WHERE loans.status IN ('B', 'D') AND districts.A3 IS NOT NULL
GROUP BY districts.A3
ORDER BY num_loans_morosos DESC;

-- # 7. Porcentaje de morosos (status B, D) por región
SELECT 
    districts.A3 AS region,
    COUNT(loans.loan_id) AS total_loans,
    SUM(CASE WHEN loans.status IN ('B', 'D') THEN 1 ELSE 0 END) AS loans_morosos,
    ROUND(
        SUM(CASE WHEN loans.status IN ('B', 'D') THEN 1 ELSE 0 END) * 100.0 / COUNT(loans.loan_id), 
        2
    ) AS porcentaje_morosos
FROM loans
LEFT JOIN accounts ON loans.account_id = accounts.account_id
LEFT JOIN districts ON accounts.district_id = districts.A1
WHERE districts.A3 IS NOT NULL
GROUP BY districts.A3
ORDER BY porcentaje_morosos DESC;

--  # 8. Dueños y usuarios por cuenta. -- Para cada account_id, indica cuántos OWNER y cuántos DISPONENT existen.

SELECT
    accounts.account_id,
    SUM(CASE WHEN dispositions.type = 'OWNER' THEN 1 ELSE 0 END) AS num_owners,
    SUM(CASE WHEN dispositions.type = 'DISPONENT' THEN 1 ELSE 0 END) AS num_disponents,
    COUNT(dispositions.disp_id) AS total_dispositions
FROM accounts
LEFT JOIN dispositions ON accounts.account_id = dispositions.account_id
GROUP BY accounts.account_id
ORDER BY total_dispositions DESC
LIMIT 20;

-- # 9. Uso de tarjetas por tipo. -- Muestra el número de tarjetas por card.type y la tasa por cada 1 000 cuentas.

SELECT 
    cards.type AS tipo_tarjeta,
    COUNT(cards.card_id) AS num_tarjetas,
    ROUND(COUNT(cards.card_id) * 1000.0 / (SELECT COUNT(*) FROM accounts), 2) AS tasa_por_1000_cuentas,
    ROUND(COUNT(cards.card_id) * 100.0 / (SELECT COUNT(*) FROM cards), 2) AS porcentaje_del_total
FROM cards
GROUP BY cards.type
ORDER BY num_tarjetas DESC;

-- # 10. Pagos de pensión (DUCHOD). -- Calcula el número de transacciones y el monto total por región y año.

SELECT
    districts.A3 AS region,
    CASE 
        WHEN CAST(SUBSTR(transactions.date, 1, 2) AS INTEGER) > 25 
        THEN '19' || SUBSTR(transactions.date, 1, 2)
        ELSE '20' || SUBSTR(transactions.date, 1, 2)
    END AS year,
    COUNT(transactions.trans_id) AS num_transacciones,
    ROUND(SUM(transactions.amount), 2) AS monto_total,
    ROUND(AVG(transactions.amount), 2) AS monto_promedio
FROM transactions
LEFT JOIN accounts ON transactions.account_id = accounts.account_id
LEFT JOIN districts ON accounts.district_id = districts.A1
WHERE transactions.k_symbol = 'DUCHOD' AND districts.A3 IS NOT NULL
GROUP BY districts.A3, year
ORDER BY region, year;

-- # 11. Flujo posterior al préstamo. -- Para las cuentas con préstamo, calcula los créditos, débitos y saldo neto en los 6 meses posteriores a la fecha del préstamo.

SELECT 
    l.account_id,
    MAX(l.date) AS last_loan_date,
    MAX(l.amount) AS loan_amount,
    COUNT(t.trans_id) AS transactions_post_loan,
    SUM(CASE WHEN t.type = 'PRIJEM' THEN t.amount ELSE 0 END) AS total_credits,
    SUM(CASE WHEN t.type IN ('VYDAJ', 'VYBER') THEN t.amount ELSE 0 END) AS total_debits,
    ROUND(SUM(CASE WHEN t.type = 'PRIJEM' THEN t.amount ELSE -t.amount END), 2) AS net_flow
FROM loans AS l
LEFT JOIN transactions t ON l.account_id = t.account_id 
    AND t.date > l.date 
    AND t.date <= (l.date + 600)
GROUP BY l.account_id
ORDER BY l.account_id, net_flow DESC
LIMIT 20;

-- # 12. Duración y pagos de los préstamos. -- Muestra el promedio y percentiles de payments agrupados por duration.

SELECT 
    duration,
    COUNT(*) AS num_loans,
    ROUND(AVG(CAST(payments AS REAL)), 2) AS avg_payment,
    ROUND(MIN(CAST(payments AS REAL)), 2) AS min_payment,
    ROUND(MAX(CAST(payments AS REAL)), 2) AS max_payment,
    ROUND(AVG(CAST(amount AS REAL)), 2) AS avg_loan_amount,
    ROUND(AVG(CAST(payments AS REAL)) * duration, 2) AS total_to_pay
FROM loans
GROUP BY duration
ORDER BY duration;

-- # 13. Clientes "premium". -- Define una regla simple (edad 25–55, saldo alto, préstamo sano, con tarjeta). Calcula un score y ordena los clientes por prioridad.

WITH eligible_clients AS (
    SELECT 
        c.client_id,
        1999 - (1900 + CAST(SUBSTR(c.birth_number, 1, 2) AS INTEGER)) AS age
    FROM clients c
    WHERE (1999 - (1900 + CAST(SUBSTR(c.birth_number, 1, 2) AS INTEGER))) BETWEEN 25 AND 55
)
SELECT 
    ec.client_id,
    ec.age,
    ROUND((SELECT AVG(CAST(balance AS REAL)) FROM transactions WHERE account_id = a.account_id), 2) AS avg_balance,
    COALESCE(MAX(CASE WHEN l.status IN ('A', 'C') THEN 1 ELSE 0 END), 0) AS healthy_loan,
    COALESCE(MAX(CASE WHEN card.card_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS has_card,
    (1 + 
     CASE WHEN (SELECT AVG(CAST(balance AS REAL)) FROM transactions WHERE account_id = a.account_id) > 65000 THEN 1 ELSE 0 END +
     COALESCE(MAX(CASE WHEN l.status IN ('A', 'C') THEN 1 ELSE 0 END), 0) +
     COALESCE(MAX(CASE WHEN card.card_id IS NOT NULL THEN 1 ELSE 0 END), 0)) AS premium_score
FROM eligible_clients ec
INNER JOIN dispositions d ON ec.client_id = d.client_id AND d.type = 'OWNER'
INNER JOIN accounts a ON d.account_id = a.account_id
LEFT JOIN loans l ON a.account_id = l.account_id
LEFT JOIN cards card ON d.disp_id = card.disp_id
GROUP BY ec.client_id, a.account_id, ec.age
ORDER BY premium_score DESC, avg_balance DESC
LIMIT 40;

-- # 14. Riesgo por desempleo. -- Relaciona el desempeño de los préstamos (loan.status) con el desempleo (district.A12 o A13). -- Agrupa por quintiles de desempleo y calcula la tasa de morosidad.

SELECT 
    unemployment_quintile,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status IN ('B', 'D') THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(SUM(CASE WHEN loan_status IN ('B', 'D') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    ROUND(MIN(unemployment_rate), 2) AS min_unemployment,
    ROUND(MAX(unemployment_rate), 2) AS max_unemployment
FROM (
    SELECT 
        l.status AS loan_status,
        CAST(d.A13 AS REAL) AS unemployment_rate,
        CASE 
            WHEN CAST(d.A13 AS REAL) <= 0.43 THEN 'Q1 (Bajo desempleo)'
            WHEN CAST(d.A13 AS REAL) <= 1.67 THEN 'Q2'
            WHEN CAST(d.A13 AS REAL) <= 2.21 THEN 'Q3'
            WHEN CAST(d.A13 AS REAL) <= 3.85 THEN 'Q4'
            ELSE 'Q5 (Alto desempleo)'
        END AS unemployment_quintile
    FROM loans l
    LEFT JOIN accounts a ON l.account_id = a.account_id
    LEFT JOIN districts d ON a.district_id = d.A1
    WHERE d.A13 IS NOT NULL AND d.A13 != ''
) AS loan_unemployment
GROUP BY unemployment_quintile
ORDER BY avg_unemployment_rate;
