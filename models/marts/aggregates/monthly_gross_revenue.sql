WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_1 AS (
  SELECT
    *,
    DATE_TRUNC('MONTH', ORDER_DATE) AS ORDER_MONTH
  FROM fct_order_items
), aggregate_1 AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    SUM(GROSS_ITEM_SALES_AMOUNT) AS GROSS_REVENUE
  FROM formula_1
  GROUP BY
    ORDER_MONTH,
    REGION_NAME
), order_1 AS (
  SELECT
    *
  FROM aggregate_1
  ORDER BY
    ORDER_MONTH ASC,
    REGION_NAME ASC
), monthly_gross_revenue_sql AS (
  SELECT
    *
  FROM order_1
)
SELECT
  *
FROM monthly_gross_revenue_sql