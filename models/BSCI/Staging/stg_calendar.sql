{{ config(materialized='view') }}

select *
from {{ source('salesops_pi_stg', 'pi_calendar') }}