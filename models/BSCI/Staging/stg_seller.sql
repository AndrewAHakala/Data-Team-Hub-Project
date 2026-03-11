{{ config(materialized='view') }}

select *
from {{ source('forge_pub', 'seller') }}