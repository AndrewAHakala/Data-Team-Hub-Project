{{ config(materialized='table') }}

with base_dims as (

    select distinct
        customer_num,
        product_lvl_1,
        product_lvl_2,
        product_lvl_3,
        product_lvl_4,
        product_lvl_6,
        ptnr_func_code,
        territory_id,
        name_1,
        harmonized_name_1,
        national_gpo_customer_name,
        regional_idn_customer_name,
        f85_facility_flag
    from {{ ref('int_ads_revenue') }}

)

select
    bd.*,

from base_dims bd
