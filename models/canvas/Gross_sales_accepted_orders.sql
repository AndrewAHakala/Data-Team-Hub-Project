WITH stg_tpch_orders AS (
  /* staging layer for orders data */
  SELECT
    *
  FROM {{ ref('dbt_demo', 'stg_tpch_orders') }}
), order_items AS (
  /* Intermediate model where we calculate item price, discounts and tax. This model is at the order item level. */
  SELECT
    *
  FROM {{ ref('dbt_demo', 'order_items') }}
), formula_1 AS (
  /* Case whgen coimment */
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
    stg_tpch_orders.ORDER_KEY,
    stg_tpch_orders.CUSTOMER_KEY,
    stg_tpch_orders.STATUS_CODE,
    stg_tpch_orders.TOTAL_PRICE,
    stg_tpch_orders.ORDER_DATE,
    stg_tpch_orders.PRIORITY_CODE,
    stg_tpch_orders.CLERK_NAME,
    stg_tpch_orders.SHIP_PRIORITY,
    stg_tpch_orders.COMMENT,
    aggregate_1.sum_gross_sales
  FROM stg_tpch_orders
  LEFT JOIN aggregate_1
    ON stg_tpch_orders.ORDER_KEY = aggregate_1.ORDER_KEY
), gross_sales_accepted_orders_sql AS (
  SELECT
    *
  FROM join_1
)
SELECT
  *
FROM gross_sales_accepted_orders_sql