{{
    config(
        materialized='table'
    )
}}
select
    order_item_key,
    date_trunc('month', order_date) as order_month,
    region_name,
    100 as gross_revenue

from {{ ref('fct_order_items') }}
group by 
    1, 2,3
order by 
    1, 2,3