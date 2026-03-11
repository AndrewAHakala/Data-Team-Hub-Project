{{ config(materialized='table') }}

select
    dim.*,
    sales.rev,
    sales.ads
from {{ ref('int_dimensional_scaffold') }} dim
left join {{ ref('int_ads_revenue') }} sales
    on sales.customer_num = dim.customer_num
   and sales.product_lvl_1 = dim.product_lvl_1
   and sales.product_lvl_2 = dim.product_lvl_2
   and sales.product_lvl_3 = dim.product_lvl_3
   and sales.product_lvl_4 = dim.product_lvl_4
   and sales.product_lvl_6 = dim.product_lvl_6
   and sales.fiscal_year_mo = dim.fiscal_year_mo
   and sales.territory_id = dim.territory_id