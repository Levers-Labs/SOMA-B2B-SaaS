{% macro get_latest_entity_history(entity_history_table) %}
with cte_latest_values as (
    select
        eh.*,
        row_number() over (partition by entity_id order by observed_on) = 1 as is_latest
    from
        {{ entity_history_table }} eh
)
select *
from cte_latest_values
where is_latest
{% endmacro %}