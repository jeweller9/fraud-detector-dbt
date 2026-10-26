{% macro amount_bucket(amount_column) %}
    CASE
        WHEN {{ amount_column }} < 10   THEN 'low'
        WHEN {{ amount_column }} < 100  THEN 'medium'
        WHEN {{ amount_column }} < 1000 THEN 'high'
        ELSE 'very_high'
    END
{% endmacro %}
