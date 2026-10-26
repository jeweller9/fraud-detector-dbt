{{ config(materialized='table', engine='MergeTree()') }}
SELECT
    us_state,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    COUNT(DISTINCT customer_full_name) AS unique_customers,
    COUNT(DISTINCT merch) AS unique_merchants,
    SUM(amount) AS total_amount,
    SUMIf(amount, is_fraud = 1) AS fraud_amount
FROM {{ ref('stg_transactions') }}
GROUP BY us_state
