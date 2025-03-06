{{
    config(
        materialized='incremental',
        incremental_strategy='microbatch',
        event_time='modified_timestamp',
        batch_size='day',
        lookback=2,
        begin='2024-09-23',
        full_refresh=false
    )
}}

select 
    id,
    status,
    created_timestamp,
    modified_timestamp
from {{ source('example_source', 'example_orders_table') }}