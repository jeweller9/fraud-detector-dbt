{{ config(materialized='table', engine='MergeTree()') }}
WITH customer_stats AS (
    SELECT
        customer_full_name,
        name_1,
        name_2,
        gender,
        us_state,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_amount,
        AVG(amount) AS avg_check,
        SUM(is_fraud) AS fraud_transactions,
        SUM(is_fraud) * 100.0 / COUNT(*) AS fraud_rate_pct,
        MIN(transaction_time) AS first_transaction_at,
        MAX(transaction_time) AS last_transaction_at
    FROM {{ ref('stg_transactions') }}
    GROUP BY customer_full_name, name_1, name_2, gender, us_state
)
SELECT
    customer_full_name, name_1, name_2, gender, us_state,
    total_transactions, total_amount, avg_check, fraud_transactions,
    ROUND(fraud_rate_pct, 2) AS fraud_rate_pct,
    CASE
        WHEN fraud_rate_pct >= 50 THEN 'HIGH'
        WHEN fraud_rate_pct >= 20 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_level,
    first_transaction_at, last_transaction_at
FROM customer_stats
