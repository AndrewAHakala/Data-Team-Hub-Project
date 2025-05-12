SELECT
    oli.customer_key,
    oli.order_key,
    oli.part_key,
    oli.order_date,
    oli.line_number,
    oli.quantity,
    SUM(oli.base_price) OVER (
        PARTITION BY oli.customer_key
        ORDER BY
            oli.order_date
    ) AS running_total
FROM {{ ref('fct_order_items') }} AS oli
