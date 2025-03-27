WITH order_items AS (
  SELECT
    *
  FROM {{ ref('order_items') }}
), input_2 AS (
  SELECT
    *
  FROM {{ ref('dbt_demo', 'stg_tpch_orders') }}
), formula_1 AS (
  SELECT
    *,
    CASE WHEN RETURN_FLAG = 'accepted' THEN 1 ELSE 0 END AS IS_ACCEPTED
  FROM order_items
), filter_1 AS (
  SELECT
    *
  FROM formula_1
  WHERE
    IS_ACCEPTED = '1'
), aggregate_1 AS (
  SELECT
    ORDER_KEY,
    SUM(GROSS_ITEM_SALES_AMOUNT) AS sum_gross_sales
  FROM filter_1
  GROUP BY
    ORDER_KEY
), join_1 AS (
  SELECT
    input_2.ORDER_KEY,
    input_2.CUSTOMER_KEY,
    input_2.STATUS_CODE,
    input_2.TOTAL_PRICE,
    input_2.ORDER_DATE,
    input_2.PRIORITY_CODE,
    input_2.CLERK_NAME,
    input_2.SHIP_PRIORITY,
    input_2.COMMENT,
    aggregate_1.sum_gross_sales
  FROM input_2
  JOIN aggregate_1
    ON input_2.ORDER_KEY = aggregate_1.ORDER_KEY
), agg_example_sql AS (
  SELECT
    *
  FROM join_1
)
SELECT
  *
FROM agg_example_sql