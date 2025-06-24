WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_a369 AS (
  SELECT
    *,
    DATE_TRUNC('MONTH', ORDER_DATE) AS ORDER_MONTH
  FROM fct_order_items
), aggregation_85ab AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    SUM(GROSS_ITEM_SALES_AMOUNT) AS GROSS_REVENUE
  FROM formula_a369
  GROUP BY
    ORDER_MONTH,
    REGION_NAME
), order_aaec AS (
  SELECT
    *
  FROM aggregation_85ab
  ORDER BY
    ORDER_MONTH ASC,
    REGION_NAME ASC
), monthly_gross_revenue AS (
  SELECT
    *
  FROM order_aaec
)
SELECT
  *
FROM monthly_gross_revenue