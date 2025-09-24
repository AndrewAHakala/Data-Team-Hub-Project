{{ config(materialized="table") }}
select
    date_trunc('day', order_date) as order_day,
    region_name,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref("fct_order_items") }}
group by order_day, region_name
order by order_day, region_name