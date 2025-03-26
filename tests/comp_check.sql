{% set required_columns = ['created_timestamp', 'modified_timestamp'] %}

-- Get the current schema based on environment
{% set target_schema = target.schema %}
{% if env_var('DBT_CLOUD_PR_ID', '') != '' %}
    {% set target_schema = target.schema ~ '_' ~ env_var('DBT_CLOUD_PR_ID') %}
{% endif %}

-- Get all project models
with models as (
    select distinct node_unique_id from {{ ref('stg_columns') }}
    where node_unique_id like '%{{ project_name }}%'
),

-- Get actual columns from database
actual_columns as (
    select 
        table_catalog as database_name,
        table_schema as schema_name,
        table_name,
        listagg(column_name, ', ') within group (order by column_name) as found_columns,
        count(*) as column_count
    from {{ target.database }}.INFORMATION_SCHEMA.COLUMNS
    where table_schema = '{{ target_schema }}'
    and column_name in ({% for col in required_columns %}'{{ col }}'{% if not loop.last %}, {% endif %}{% endfor %})
    group by 1,2,3
),

-- Get documented columns from dbt
documented_columns as (
    select 
        node_unique_id,
        '{{ target.database }}' as database_name,
        '{{ target_schema }}' as schema_name,
        split_part(node_unique_id, '.', -1) as model_name,
        listagg(name, ', ') within group (order by name) as documented_columns,
        count(*) as column_count
    from {{ ref('stg_columns') }}
    where node_unique_id like '%{{ project_name }}%'
    and name in ({% for col in required_columns %}'{{ col }}'{% if not loop.last %}, {% endif %}{% endfor %})
    group by 1,2,3,4
),

-- Scenario 1: Columns exist in code but not documented
scenario_1 as (
    select 
        1 as scenario_type,
        a.database_name,
        a.schema_name,
        a.table_name as model_name,
        a.found_columns as actual_columns,
        coalesce(d.documented_columns, 'none') as documented_columns,
        'Columns exist in code but not documented in YAML: ' || a.found_columns as issue
    from actual_columns a
    left join documented_columns d
        on a.database_name = d.database_name
        and a.schema_name = d.schema_name
        and a.table_name = d.model_name
    where d.model_name is null
),

-- Scenario 2: No columns in code and not documented
scenario_2 as (
    select 
        2 as scenario_type,
        '{{ target.database }}' as database_name,
        '{{ target_schema }}' as schema_name,
        split_part(m.node_unique_id, '.', -1) as model_name,
        'none' as actual_columns,
        'none' as documented_columns,
        'Missing required columns in both code and YAML: ' || '{{ required_columns | join(", ") }}' as issue
    from models m
    left join actual_columns a
        on '{{ target.database }}' = a.database_name
        and '{{ target_schema }}' = a.schema_name
        and split_part(m.node_unique_id, '.', -1) = a.table_name
    where a.table_name is null
),

-- Scenario 3: Columns documented but don't exist in code
scenario_3 as (
    select 
        3 as scenario_type,
        d.database_name,
        d.schema_name,
        d.model_name,
        coalesce(a.found_columns, 'none') as actual_columns,
        d.documented_columns,
        'Columns documented in YAML but do not exist in code: ' || d.documented_columns as issue
    from documented_columns d
    left join actual_columns a
        on d.database_name = a.database_name
        and d.schema_name = a.schema_name
        and d.model_name = a.table_name
    where a.table_name is null
),

-- Combine all scenarios
all_issues as (
    select * from scenario_1
    union all
    select * from scenario_2
    union all
    select * from scenario_3
)

-- Return results in a format that's easy to read in dbt test output
select
    case scenario_type
        when 1 then 'ERROR: ' || model_name || ' - ' || issue
        when 2 then 'ERROR: ' || model_name || ' - ' || issue
        when 3 then 'ERROR: ' || model_name || ' - ' || issue
    end as failure_reason
from all_issues
order by scenario_type, model_name 