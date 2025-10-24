WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_6bed AS (
  SELECT
    *,
    DATE_TRUNC('MONTH', ORDER_DATE) AS ORDER_MONTH
  FROM fct_order_items
), aggregation_4fbe AS (
  SELECT
    ORDER_MONTH,
    REGION_NAME,
    SUM(GROSS_ITEM_SALES_AMOUNT) AS GROSS_REVENUE
  FROM formula_6bed
  GROUP BY
    ORDER_MONTH,
    REGION_NAME
), order_0bf8 AS (
  SELECT
    *
  FROM aggregation_4fbe
  ORDER BY
    ORDER_MONTH ASC,
    REGION_NAME ASC
), monthly_gross_revenue AS (
  SELECT
    *
  FROM order_0bf8
)
SELECT
  *
FROM monthly_gross_revenue