{{-
    config(
        materialized = 'table',
        post_hook = "
                update {{ this }} a
                set activity_occurrence = dt.activity_occurrence,
                    activity_repeated_at = dt.activity_repeated_at
                from (
                    select
                        id,
                        customer_id,
                        activity,
                        activity_ts,
                        row_number() over(partition by customer_id, activity order by activity_ts asc) as activity_occurrence,
                        lead(activity_ts, 1) over(partition by customer_id, activity order by activity_ts asc) as activity_repeated_at
                    from 
                        {{ this }}
                )dt
                where 
                    dt.id = a.id
                    and dt.customer_id = a.customer_id
                    and dt.activity = a.activity
                    and a.activity_ts = dt.activity_ts"
)
-}}

-- Returns a list of relations that match schema.prefix%
{%- set all_tables = dbt_utils.get_relations_by_pattern('main', 'customer_stream%') -%}
{% for table in all_tables %}
select
    id,
    customer_id,
    activity,
    activity_ts,
    revenue_impact,
    feature_json,
    cast(null as int) as activity_occurrence,
    cast(null as timestamp) as activity_repeated_at
from
    {{ table }}
{%- if not loop.last %}
union all
{%- endif -%}
{% endfor %}

--depends on: {{ ref('customer_stream_decreased_contract') }}
--depends on: {{ ref('customer_stream_incurred_overage') }}
--depends on: {{ ref('customer_stream_ended_subscription') }}
--depends on: {{ ref('customer_stream_expanded_contract') }}
--depends on: {{ ref('customer_stream_active_on_subscription') }}
--depends on: {{ ref('customer_stream_committed_to_churn') }}
--depends on: {{ ref('customer_stream_resurrected_contract') }}
--depends on: {{ ref('customer_stream_ordered_service') }}
--depends on: {{ ref('customer_stream_renewed_contract') }}
--depends on: {{ ref('customer_stream_started_subscription') }}