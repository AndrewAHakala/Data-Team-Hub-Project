{{ config(store_failures = true) }}
{% test warn_gross_revenue_is_negative(model, column_name) %}

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