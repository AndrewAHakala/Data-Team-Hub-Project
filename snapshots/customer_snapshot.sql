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