WITH monthly_gross_revenue AS (
  SELECT
    *
  FROM {{ ref('monthly_gross_revenue') }}
), formula_1 AS (
  SELECT
    *,
    RANK() OVER (PARTITION BY REGION_NAME ORDER BY SUM(GROSS_REVENUE) DESC) AS REVENUE_RANK
  FROM monthly_gross_revenue
), aggregate_1 AS (
  SELECT
    REGION_NAME,
    ORDER_MONTH
  FROM formula_1
  GROUP BY
    REGION_NAME,
    ORDER_MONTH
), order_1 AS (
  SELECT
    *
  FROM aggregate_1
  ORDER BY
    REGION_NAME ASC,
    REVENUE_RANK ASC
), untitled_4_sql AS (
  SELECT
    REGION_NAME,
    ORDER_MONTH,
    REVENUE_RANK
  FROM order_1
)
SELECT
  *
FROM untitled_4_sql