{{ config(materialized='view') }}

WITH source AS (
    SELECT * FROM {{ source('transactions_db', 'transactions') }}
),
renamed AS (
    SELECT
        transaction_time,
        toDate(transaction_time)                AS transaction_date,
        toHour(transaction_time)                AS transaction_hour,
        toDayOfWeek(transaction_time)           AS day_of_week,
        merch,
        cat_id,
        amount,
        {{ amount_bucket('amount') }}           AS amount_bucket,
        name_1,
        name_2,
        name_1 || ' ' || name_2                 AS customer_full_name,
        gender,
        us_state,
        target AS is_fraud
    FROM source
)
SELECT * FROM renamed
