{{ config(materialized='table') }}

select
    *,
    rev / nullif(total_days_mo, 0) as ads
from {{ ref('int_sales_tracings') }}