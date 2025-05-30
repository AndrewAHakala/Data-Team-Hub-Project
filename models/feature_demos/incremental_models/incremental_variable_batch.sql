{% set status = check_table_status(database="HAKALA_DEVELOPMENT", schema="DBT_AHAKALA", table="incremental_variable_batch") %}

{% if not status.exists or status.row_count == 0 %}
    {# year batch size for initial load #}
    {{ log("Table does not exist or is empty.", info=True) }}
    {{
        config(
            materialized='incremental',
            unique_key='id',
            incremental_strategy='merge',
            batch_size=1000000
        )
    }}
{% else %}
    {# day batch size for incremental updates #}
    {{ log("Table exists with " ~ status.row_count ~ " rows.", info=True) }}
    {{
        config(
            materialized='incremental',
            unique_key='id',
            incremental_strategy='microbatch',
            batch_size=100
        )
    }}
{% endif %}
--UPDATE WITH YOUR INCREMENTAL SQL LOGIC
select
    id,
    status,
    CAST(CREATED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS CREATED_TIMESTAMP,
    CAST(MODIFIED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS MODIFIED_TIMESTAMP
from {{ source('example_source', 'example_orders_table') }}

{% if is_incremental() %}
    where modified_timestamp > (select max(modified_timestamp) from {{ this }}) 
{% endif %}


