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

--depends on: {{ ref('client_stream_decreased_contract') }}
--depends on: {{ ref('client_stream_incurred_overage') }}
--depends on: {{ ref('client_stream_ended_subscription') }}
--depends on: {{ ref('client_stream_expanded_contract') }}
--depends on: {{ ref('client_stream_active_on_subscription') }}
--depends on: {{ ref('client_stream_committed_to_churn') }}
--depends on: {{ ref('client_stream_resurrected_contract') }}
--depends on: {{ ref('client_stream_ordered_service') }}
--depends on: {{ ref('client_stream_renewed_contract') }}
--depends on: {{ ref('client_stream_started_subscription') }}
