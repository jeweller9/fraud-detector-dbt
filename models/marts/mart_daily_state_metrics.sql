{{ config(materialized='table', engine='MergeTree()') }}
SELECT
    transaction_date,
    us_state,
    COUNT(*) AS transactions_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_check,
    quantile(0.95)(amount) AS p95_amount,
    COUNTIf(amount_bucket = 'very_high') AS large_transactions_count,
    ROUND(COUNTIf(amount_bucket = 'very_high') * 100.0 / COUNT(*), 2) AS large_transactions_share_pct
FROM {{ ref('stg_transactions') }}
GROUP BY transaction_date, us_state
