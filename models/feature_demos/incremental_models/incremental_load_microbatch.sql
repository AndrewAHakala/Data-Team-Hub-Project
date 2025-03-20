--Use microbatch incremental models to process large time-series datasets efficiently
--Each "batch" corresponds to a single bounded time period defined by event_time + batch_size
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
