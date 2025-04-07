{#
{% set required_columns = ['created_timestamp', 'modified_timestamp'] %} -- specify required columns here

-- Get the current schema based on environment
{% set target_schema = target.schema %}
{% if env_var('DBT_CLOUD_PR_ID', '') != '' %}
    {% set target_schema = target.schema ~ '_' ~ env_var('DBT_CLOUD_PR_ID') %}
{% endif %}


-- Get actual columns from database
with actual_columns as (
    select 
        table_catalog as database_name,
        table_schema as schema_name,
        table_name,
        column_name
    from {{ target.database }}.INFORMATION_SCHEMA.COLUMNS
    where table_schema = '{{ target_schema }}'
    and column_name in ({% for col in required_columns %}'{{ col }}'{% if not loop.last %}, {% endif %}{% endfor %})
),

-- Get documented columns from dbt
documented_columns as (
    select 
        node_unique_id,
        '{{ target.database }}' as database_name,
        '{{ target_schema }}' as schema_name,
        split_part(node_unique_id, '.', -1) as model_name,
        name as column_name
    from {{ ref('stg_columns') }}
    where node_unique_id like '%{{ project_name }}%'
    and name in ({% for col in required_columns %}'{{ col }}'{% if not loop.last %}, {% endif %}{% endfor %})
),

-- Compare actual vs documented columns
comparison as (
    select 
        d.node_unique_id,
        d.database_name,
        d.schema_name,
        d.model_name,
        d.column_name as documented_column,
        a.column_name as actual_column
    from documented_columns d
    left join actual_columns a
        on d.database_name = a.database_name
        and d.schema_name = a.schema_name
        and d.model_name = a.table_name
        and d.column_name = a.column_name
)

-- Test will fail if any documented column doesn't exist in the database
select 
    node_unique_id,
    database_name,
    schema_name,
    model_name,
    documented_column,
    actual_column
from comparison
where actual_column is null 
#}