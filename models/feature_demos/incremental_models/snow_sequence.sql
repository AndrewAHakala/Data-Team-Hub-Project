{{ config(
    materialized='table',
    pre_hook='CREATE OR REPLACE SEQUENCE seq1'
) }}

select
    seq.nextval as sequence_of_numbers,
    orders.o_orderkey as order_key,
    orders.o_custkey as customer_key,
    orders.o_orderstatus as status_code,
    orders.o_totalprice as total_price,
    orders.o_orderdate as order_date
from {{ source('tpch', 'orders') }} orders,
     table(getnextval(seq1)) seq