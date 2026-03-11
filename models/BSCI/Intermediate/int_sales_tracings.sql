{{ config(materialized='table') }}

with base as (

    select
        sd.customer_num,
        cal.fiscal_year_mo,
        sd.product_lvl_1,
        sd.product_lvl_2,
        sd.product_lvl_3,
        sd.product_lvl_4,
        sd.product_lvl_6,
        cust.name_1,
        cust.harmonized_name_1,
        cust.national_gpo_customer_name,
        cust.regional_idn_customer_name,
        cust.f85_facility_flag,
        se.ptnr_func_code,
        se.terr_geo_area_cd as territory_id,
        se.*,
        cal.total_days_mo,
        sum(sd.revenue_amount) as rev

    from {{ ref('stg_sell_detail') }} sd

    join {{ ref('stg_calendar') }} cal
        on to_char(sd.calendar_key, 'YYYY-MM') = cal.fiscal_year_mo

    left join {{ ref('stg_seller') }} se
        on se.seller_key = sd.current_date_seller_key

    left join {{ ref('stg_customers') }} cust
        on sd.customer_key = cust.customer_key

    group by all

)

select *
from base
where rev <> 0