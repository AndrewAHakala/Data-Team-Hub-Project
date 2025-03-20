--Add a new row to preserve history, typically with start/end dates or a version number to track changes.
--Table persists and grows over time as new data is added.
--Ideal for large, append-only datasets or event-based data where reprocessing everything would be inefficient.

{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

with t as (
select
    id as customer_id,
    concat(fname,' ',lname) as customer_name,
    address, 
    modified_timestamp,
    current_timestamp() as valid_from,
    null as valid_to
from {{ source('customer_data_source', 'customer_dim') }})

select *
from t
{% if is_incremental() %}
--identify new or updated records
where modified_timestamp > (select max(modified_timestamp) from t)
{% endif %}