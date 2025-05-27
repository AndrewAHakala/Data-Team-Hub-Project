WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_7877 AS (
  SELECT
    CUSTOMER_KEY,
    ORDER_KEY,
    PART_KEY,
    ORDER_DATE,
    LINE_NUMBER,
    QUANTITY,
    SUM(BASE_PRICE) OVER (PARTITION BY CUSTOMER_KEY ORDER BY ORDER_DATE) AS RUNNING_TOTAL
  FROM fct_order_items
), agg_customer_value AS (
  SELECT
    *
  FROM formula_7877
)
SELECT
  *
FROM agg_customer_value