{% macro get_current_entity(entity_history) %}
select eh.*
from
    {{ entity_history }} eh
where
    {{ dbt.date_trunc('date', 'observed_on') }} = {{ dbt.date_trunc('date', dbt.current_timestamp()) }}
{% endmacro %}