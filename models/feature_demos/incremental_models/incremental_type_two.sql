--Type 2: Add a new row to preserve history, typically with start/end dates or a version number to track changes
{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

select
    id as customer_id,
    concat(fname,' ',lname) as customer_name,
    address, 
    current_timestamp() as valid_from,
    null as valid_to
from {{ source('customer_data_source', 'customer_dim') }}
{% if is_incremental() %}
where modified_timestamp > (select max(created_timestamp) from {{ this }})
{% endif %}