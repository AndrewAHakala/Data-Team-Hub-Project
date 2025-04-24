SELECT *
,'Hello world' as col
FROM {{ ref('monthly_gross_revenue') }}