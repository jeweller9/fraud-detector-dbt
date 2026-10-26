SELECT * FROM {{ ref('stg_transactions') }} WHERE transaction_time > now()
