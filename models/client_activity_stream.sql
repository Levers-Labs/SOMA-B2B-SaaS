{{-
    config(materialized = 'table')
-}}

with cte_union_streams as (
    -- Returns a list of relations that match schema.prefix%
    {%- set all_tables = dbt_utils.get_relations_by_pattern(target.schema, 'client_stream%') -%}
    {% for table in all_tables %}
    select
        id,
        entity_id as customer_id,
        activity,
        activity_ts,
        revenue_impact,
        feature_json,
    from
        {{ table }}
    {%- if not loop.last %}
    union all
    {%- endif -%}
    {% endfor %}
)
select
    id,
    customer_id,
    activity,
    activity_ts,
    revenue_impact,
    feature_json,
    row_number() over(partition by customer_id, activity order by activity_ts asc) as activity_occurrence,
    lead(activity_ts, 1) over(partition by customer_id, activity order by activity_ts asc) as activity_repeated_at
from 
    cte_union_streams
