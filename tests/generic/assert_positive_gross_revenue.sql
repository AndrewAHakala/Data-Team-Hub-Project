{% test warn_gross_revenue_is_negative(model, column_name) %}
{{ config(store_failures = false) }}
with t as (
Select {{ column_name }} as validation_field 
FROM {{ model }}
),

t2 as (
Select validation_field 
FROM t
WHERE validation_field<0
)

Select *
FROM t2

{% endtest %}