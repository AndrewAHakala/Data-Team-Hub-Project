{{ config(materialized='table') }}

select
    coalesce(customer_num, customer_num) as customer_number,
    product_lvl_1,
    product_lvl_2,
    product_lvl_3,
    product_lvl_4,
    product_lvl_6,
    ptnr_func_code as partner_function,
    territory_id as territory_number,
    coalesce(rev, 0) as rev,
    coalesce(ads, 0) as ads,
    *
from {{ ref('int_scaffolded_sales') }}