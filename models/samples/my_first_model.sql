{{
    config(
        materialized='table'
    )
}}

select
    'this is great!!' as my_first_column,
    1 / 333 as a_simple_calculation,
    current_timestamp() as current_time_ts
    
