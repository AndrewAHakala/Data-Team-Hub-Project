WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_b2f7 AS (
  SELECT
    *,
    DATE_TRUNC('MONTH', ORDER_DATE) AS ORDER_MONTH
  FROM fct_order_items
), aggregation_9808 AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    SUM(GROSS_ITEM_SALES_AMOUNT) AS GROSS_REVENUE
  FROM formula_b2f7
  GROUP BY
    ORDER_MONTH,
    REGION_NAME
), order_f75e AS (
  SELECT
    *
  FROM aggregation_9808
  ORDER BY
    ORDER_MONTH ASC,
    REGION_NAME ASC
), monthly_gross_revenue AS (
  SELECT
    *
  FROM order_f75e
)
SELECT
  *
FROM monthly_gross_revenue