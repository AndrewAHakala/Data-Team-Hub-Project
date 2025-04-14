{{
    config(
        materialized='table'
    )
}}
select
    date_trunc('month', order_date) as order_month,
    region_name,
    return_flag,
    ship_mode,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref('fct_order_items') }}
group by 
    1, 2, 3, 4
order by 
    1, 2, 3, 4