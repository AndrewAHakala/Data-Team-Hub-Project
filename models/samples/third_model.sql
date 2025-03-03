{{
    config(
        materialized='table'
    )
}}

select *
,'hello world'
FROM {{ ref('my_second_model') }}