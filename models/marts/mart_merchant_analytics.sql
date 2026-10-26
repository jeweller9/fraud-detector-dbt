{{ config(materialized='table', engine='MergeTree()') }}
WITH merchant_stats AS (
    SELECT
        merch,
        COUNT(*) AS total_transactions,
        COUNT(DISTINCT customer_full_name) AS unique_customers,
        SUM(amount) AS total_amount,
        AVG(amount) AS avg_check,
        SUM(is_fraud) AS fraud_transactions,
        SUM(is_fraud) * 100.0 / COUNT(*) AS fraud_rate_pct,
        SUMIf(amount, is_fraud = 1) AS fraud_amount
    FROM {{ ref('stg_transactions') }}
    GROUP BY merch
)
SELECT
    merch, total_transactions, unique_customers, total_amount, avg_check,
    fraud_transactions, ROUND(fraud_rate_pct, 2) AS fraud_rate_pct, fraud_amount,
    CASE WHEN fraud_rate_pct >= 30 AND fraud_transactions >= 5 THEN 1 ELSE 0 END AS is_suspicious
FROM merchant_stats
