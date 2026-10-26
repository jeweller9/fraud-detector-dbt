{{ config(materialized='table', engine='MergeTree()') }}
SELECT
    day_of_week,
    transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    AVG(amount) AS avg_amount,
    SUMIf(amount, is_fraud = 1) AS fraud_amount
FROM {{ ref('stg_transactions') }}
GROUP BY day_of_week, transaction_hour
