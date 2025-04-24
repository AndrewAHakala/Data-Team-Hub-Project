SELECT *
,'hello world' as col1
FROM {{ ref('monthly_gross_revenue') }}