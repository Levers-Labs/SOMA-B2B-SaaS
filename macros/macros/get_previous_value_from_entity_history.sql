{% macro get_previous_value_from_entity_history(entity_history_table, attribute) %}
with cte_entity_history as (
    select
        eh.*,
        {{ attribute }} as current_value,
        lag({{ attribute }}, 1) over(partition by entity_id order by observed_on asc) as previous_value
    from
        {{ entity_history_table }} eh
)
select *
from cte_entity_history
where current_value != previous_value
{% endmacro %}