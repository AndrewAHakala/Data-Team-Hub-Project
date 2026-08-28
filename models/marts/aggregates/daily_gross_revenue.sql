{{ config(materialized="table") }}

select
    date_trunc('day', order_date) as order_date,
    region_name,
    ship_mode,
    order_item_status_code,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref("fct_order_items") }}
group by order_date, region_name, ship_mode, order_item_status_code
order by order_date, region_name, ship_mode, order_item_status_code
