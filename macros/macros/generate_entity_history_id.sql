{%- macro generate_entity_history_id(entity_id) %}
{{ entity_id }} || {{ dbt.current_timestamp() }}
{%- endmacro %}