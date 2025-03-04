{% macro get_semantic_layer_export(export_name) %}

    {{target.database}}.exported_semantics.{{export_name}}
    
{% endmacro %}