{% macro check_table_status(database, schema, table) %}
    {%- set relation = adapter.get_relation(database=database, schema=schema, identifier=table) -%}

    {% if relation is none %}
        {{ log("Table does not exist", info=True) }}
        {{ return({'exists': False, 'row_count': 0}) }}
    {% else %}
        {%- set query -%}
            select count(*) as row_count
            from {{ relation }}
        {%- endset -%}

        {%- set results = run_query(query) -%}
        {%- if execute and results %}
            {% set row_count = results.columns[0].values()[0] | int %}
            {{ log("Table exists with " ~ row_count ~ " rows", info=True) }}
            {{ return({'exists': True, 'row_count': row_count}) }}
        {% else %}
            {{ return({'exists': True, 'row_count': None}) }}
        {% endif %}
    {% endif %}
{% endmacro %}



