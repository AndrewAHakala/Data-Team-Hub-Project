--Snapshots are used to capture point-in-time states of a source table, tracking changes to records over time
--snapshot strategy timestamp or check
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
    id as customer_id,
    concat(fname,' ',lname) as customer_name,
    address,
    modified_timestamp
from {{ source('customer_data_source', 'customer_dim') }}
{% endsnapshot %}