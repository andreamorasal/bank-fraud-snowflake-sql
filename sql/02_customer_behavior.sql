-- Dataset: Bank Fraud dataset
-- Database: Snowflake

-- =========================================================
-- Customer Behavior Analytics
-- =========================================================


-- Identify the top 20 customers by:
-- SUM(transaction_amount)


SELECT
    customer_id AS top_customers,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_amount
FROM bank_fraud
GROUP BY customer_id
ORDER BY total_transaction_amount DESC
LIMIT 20;


-- Calculate average transaction amount by age group:
-- 18-25
-- 26-35
-- 36-50
-- 51-65
-- 65+


SELECT
    CASE
        WHEN customer_age < 25 THEN 'Young'
        WHEN customer_age < 35 THEN 'Not that young anymore'
        WHEN customer_age < 50 THEN 'Unfortunately old'
        WHEN customer_age < 65 THEN 'Poor you'
        ELSE 'Very old'
    END AS age_group,
    ROUND(AVG(transaction_amount), 2) AS avg_transaction_amount
FROM bank_fraud
GROUP BY age_group
ORDER BY avg_transaction_amount DESC;


-- Determine which age group has the highest fraud rate.


SELECT
    CASE
        WHEN customer_age < 25 THEN 'Young'
        WHEN customer_age < 35 THEN 'Not that young anymore'
        WHEN customer_age < 50 THEN 'Unfortunately old'
        WHEN customer_age < 65 THEN 'Poor you'
        ELSE 'Very old'
    END AS age_group,
    ROUND(
        COUNT_IF(is_fraud = TRUE)
        / COUNT(transaction_id) * 100.0,
        2
    ) AS fraud_rate
FROM bank_fraud
GROUP BY age_group
ORDER BY fraud_rate DESC;


-- Find customers with:
-- High Balance


SELECT
    customer_id,
    MAX(account_balance) AS account_balance
FROM bank_fraud
GROUP BY customer_id
ORDER BY account_balance DESC;


-- Low Transaction Frequency


SELECT
    customer_id,
    COUNT(transaction_id) AS total_transactions
FROM bank_fraud
GROUP BY customer_id
ORDER BY total_transactions ASC;


-- Potential dormant accounts
-- For example: no transaction in the last 90 days


-- dataset is up to date

SELECT
    customer_id,
    MAX(transaction_date) AS last_transaction_date
FROM bank_fraud
GROUP BY customer_id
HAVING MAX(transaction_date) < DATEADD(DAY, -90, CURRENT_DATE())
ORDER BY last_transaction_date ASC;


-- if dataset is not up to date

SELECT
    customer_id,
    MAX(TRANSACTION_DATE) AS last_transaction_date
FROM bank_fraud
GROUP BY customer_id
HAVING MAX(TRANSACTION_DATE) <
    DATEADD(
        DAY,
        -90,
        (
            SELECT MAX(TRANSACTION_DATE)
            FROM bank_fraud
        )
    )
ORDER BY last_transaction_date ASC;


-- Calculate average account balance and credit score by country.


SELECT
    country,
    ROUND(AVG(account_balance), 2) AS avg_account_balance,
    ROUND(AVG(credit_score), 2) AS avg_credit_score
FROM bank_fraud
GROUP BY country
ORDER BY avg_credit_score DESC;