-- Dataset: Bank Fraud dataset
-- Database: Snowflake

-- =========================================================
-- Fraud Pattern Analysis
-- =========================================================


-- Calculate fraud rate by:
-- Merchant Category


SELECT
    merchant_category,
    ROUND(
        COUNT_IF(is_fraud = TRUE)
        / COUNT(transaction_id) * 100.0,
        2
    ) AS fraud_rate
FROM bank_fraud
GROUP BY merchant_category
ORDER BY fraud_rate DESC;


-- Determine fraud rate by:
-- Payment Method


SELECT
    payment_method,
    ROUND(
        COUNT_IF(is_fraud = TRUE)
        / COUNT(transaction_id) * 100.0,
        2
    ) AS fraud_rate
FROM bank_fraud
GROUP BY payment_method
ORDER BY fraud_rate DESC;


-- Determine fraud rate by:
-- Device Type


SELECT
    device_type,
    ROUND(
        COUNT_IF(is_fraud = TRUE)
        / COUNT(transaction_id) * 100.0,
        2
    ) AS fraud_rate
FROM bank_fraud
GROUP BY device_type
ORDER BY fraud_rate DESC;


-- Find the most common fraud type.
-- Output:
-- fraud_type
-- count
-- percentage


SELECT
    fraud_type,
    COUNT(*) AS count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
        2
    ) AS percentage
FROM bank_fraud
WHERE is_fraud = TRUE
GROUP BY fraud_type
ORDER BY count DESC;


-- Analyze fraud transactions occurring during:
-- Night vs Day


SELECT
    COUNT_IF(is_night_transaction = TRUE) AS night_transaction,
    COUNT_IF(is_night_transaction = FALSE) AS day_transaction
FROM bank_fraud
WHERE is_fraud = TRUE;


-- Weekend vs Weekday


SELECT
    COUNT_IF(is_weekend = TRUE) AS weekend_transaction,
    COUNT_IF(is_weekend = FALSE) AS weekday_transaction
FROM bank_fraud
WHERE is_fraud = TRUE;


SELECT
    is_weekend,
    COUNT(*) AS transaction_count
FROM bank_fraud
WHERE is_fraud = TRUE
GROUP BY is_weekend
ORDER BY is_weekend DESC;