--Snapshots are used to capture point-in-time states of a source table, tracking changes to records over time
--snapshot strategy timestamp or check
--dbt run-operation add_row_to_example_orders_table
{% snapshot customer_snapshot %}
{{
    config(
        target_schema='snapshots',
       unique_key='id',
       strategy='timestamp',
        updated_at='modified_timestamp'
    )
}}
select
    id,
    status,
    CAST(CREATED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS CREATED_TIMESTAMP,
    CAST(MODIFIED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS MODIFIED_TIMESTAMP
from {{ source('example_source', 'example_orders_table') }}
{% endsnapshot %}
