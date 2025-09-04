WITH monthly_gross_revenue AS (
  SELECT
    *
  FROM {{ ref('monthly_gross_revenue') }}
), formula_1 AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY REGION_NAME ORDER BY GROSS_REVENUE DESC) AS REVENUE_RANK
  FROM monthly_gross_revenue
), rename_1 AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    GROSS_REVENUE,
    REVENUE_RANK
  FROM formula_1
), filter_1 AS (
  SELECT
    *
  FROM rename_1
  WHERE
    REVENUE_RANK = 1
), order_1 AS (
  SELECT
    *
  FROM filter_1
  ORDER BY
    REGION_NAME ASC,
    ORDER_MONTH ASC
), top_revenue_by_region_sql AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    GROSS_REVENUE
  FROM order_1
)
SELECT
  *
FROM top_revenue_by_region_sql