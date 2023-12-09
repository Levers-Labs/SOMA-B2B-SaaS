{{% macro get_attribute_history(entity_history_table, attribute) %}}
with cte_attribute_history as (
    select
        entity_id,
        expected_close_date as current_close_date,
        observed_on,
        estimated_pipeline_value,
        lag(expected_close_date, 1) over(partition by entity_id order by observed_on asc) as previous_close_date
    from
        {{ ref(entity_history_table) }}
    qualify current_close_date != previous_close_date
)
select *
from cte_attribute_history
where 
{{% endmacro %}}