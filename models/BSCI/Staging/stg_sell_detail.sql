{{ config(materialized='view') }}

select
    customer_num,
    calendar_key,
    harmonized_product_group_category_lvl1_code as product_lvl_1,
    harmonized_product_group_category_lvl2_code as product_lvl_2,
    harmonized_product_group_category_lvl3_code as product_lvl_3,
    harmonized_product_group_category_lvl4_code as product_lvl_4,
    harmonized_product_group_category_lvl6_code as product_lvl_6,
    revenue_amount,
    record_type_key,
    business_join_key,
    current_date_seller_key,
    customer_key
from {{ source('forge', 'pub_sell_detail') }}
where record_type_key = 'REVENUE'
  and business_join_key = 15