<<<<<<< HEAD
=======
WITH fct_order_items AS (
  SELECT
    *
  FROM {{ ref('fct_order_items') }}
), formula_1 AS (
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
  FROM formula_1
)
>>>>>>> f5513c479499ebb9dd5b9ab58e415b9042c23e71
SELECT
    oli.customer_key,
    oli.order_key,
    oli.part_key,
    oli.order_date,
    oli.line_number,
    oli.quantity
    /*,SUM(oli.base_price) OVER (
        PARTITION BY oli.customer_key
        ORDER BY
            oli.order_date
    )  AS running_total*/
FROM {{ ref('fct_order_items') }} AS oli