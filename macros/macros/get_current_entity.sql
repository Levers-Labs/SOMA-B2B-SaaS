{% macro get_current_entity(entity_history_table) %}
select eh.*
from
    {{ entity_history_table }} eh
where
    {{ dbt.date_trunc('day', 'observed_on') }} = {{ dbt.date_trunc('day', dbt.current_timestamp()) }}
{% endmacro %}