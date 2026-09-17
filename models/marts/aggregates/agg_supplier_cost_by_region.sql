with order_items as (

    select * from {{ ref('fct_order_items') }}

)

select
    region_name,
    sum(supplier_cost * quantity) as total_supplier_cost
from order_items
group by region_name
order by region_name
