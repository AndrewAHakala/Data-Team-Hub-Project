--Add a new row to preserve history, typically with start/end dates or a version number to track changes.
--Table persists and grows over time as new data is added.
--Ideal for large, append-only datasets or event-based data where reprocessing everything would be inefficient.
--dbt run-operation add_row_to_example_orders_table
{{
    config(
        materialized='incremental'
        ,unique_key='id'
    )
}}

select
    id,
    status,
    CAST(CREATED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS CREATED_TIMESTAMP,
    CAST(MODIFIED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS MODIFIED_TIMESTAMP
from {{ source('example_source', 'example_orders_table') }}

{% if is_incremental() %}
--where statement to identify new or updated records
where modified_timestamp > (select max(modified_timestamp) from {{ this }})
{% endif %}