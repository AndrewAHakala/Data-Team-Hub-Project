{{ 
    config(
        materialized='incremental',
        unique_key=[
            'customer_number',
            'product_lvl_1',
            'product_lvl_2',
            'product_lvl_3',
            'product_lvl_4',
            'product_lvl_6',
            'territory_number',
            'fiscal_year_mo'
        ]
    ) 
}}

with base as (

    select *
    from {{ ref('int_cleaned_sales') }}

    {% if is_incremental() %}
        where fiscal_year_mo >= (
            select max(fiscal_year_mo) from {{ this }}
        )
    {% endif %}

)

select
    *,
    'SALES' as record_source,

    case
        when series <= 2 then null
        when series > max_series then null
        else avg(rev) over (
            partition by customer_number,
                         product_lvl_1,
                         product_lvl_2,
                         product_lvl_3,
                         product_lvl_4,
                         product_lvl_6
            order by series
            rows between 2 preceding and current row
        )
    end as avg_rev_3_mo,

    case
        when series <= 2 then null
        when series > max_series then null
        else avg(ads) over (
            partition by customer_number,
                         product_lvl_1,
                         product_lvl_2,
                         product_lvl_3,
                         product_lvl_4,
                         product_lvl_6
            order by series
            rows between 2 preceding and current row
        )
    end as avg_ads_3_mo

from base