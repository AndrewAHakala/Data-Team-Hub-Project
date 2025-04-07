{{
    config(
        materialized='table'
    )
}}

select
    order_date,
    region_name,
    return_flag,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref('fct_order_items') }}
group by 
    1, 2, 3
order by 
    1, 2, 3