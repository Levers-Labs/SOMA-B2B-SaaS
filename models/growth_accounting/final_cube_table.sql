{{-
    config(materialized = 'view')
-}}

-- Returns a list of relations that match schema.prefix%
{%- set cube_tables = dbt_utils.get_relations_by_pattern('main', '%cube') -%}
{{ dbt_utils.union_relations(relations = cube_tables) }}

-- depends_on: {{ ref('churned_subscriptions_cube') }}
-- depends_on: {{ ref('churned_revenue_cube') }}
-- depends_on: {{ ref('contraction_revenue_cube') }}
-- depends_on: {{ ref('contraction_subscriptions_cube') }}
-- depends_on: {{ ref('expansion_revenue_cube') }}
-- depends_on: {{ ref('expansion_subscriptions_cube') }}
-- depends_on: {{ ref('new_revenue_cube') }}
-- depends_on: {{ ref('new_subscriptions_cube') }}
-- depends_on: {{ ref('resurrected_revenue_cube') }}
-- depends_on: {{ ref('resurrected_subscriptions_cube') }}
-- depends_on: {{ ref('net_revenue_cube') }}
-- depends_on: {{ ref('retained_subscriptions_cube') }}
-- depends_on: {{ ref('retained_revenue_cube') }}
-- depends_on: {{ ref('net_subscriptions_cube') }}
-- depends_on: {{ ref('quick_ratio_cube') }}
-- depends_on: {{ ref('total_revenue_cube') }}
-- depends_on: {{ ref('total_subscriptions_cube') }}
-- depends_on: {{ ref('committed_revenue_cube') }}
-- depends_on: {{ ref('gross_revenue_churn_cube') }}
-- depends_on: {{ ref('gross_revenue_churn_rate_cube') }}
-- depends_on: {{ ref('net_revenue_churn_cube') }}
-- depends_on: {{ ref('net_revenue_churn_rate_cube') }}
-- depends_on: {{ ref('revenue_cmgr_cube') }}
-- depends_on: {{ ref('gross_subscriptions_churn_cube') }}
-- depends_on: {{ ref('revenue_growth_rate_cube') }}
-- depends_on: {{ ref('subscriber_cmgr_cube') }}
-- depends_on: {{ ref('subscriber_growth_rate_cube') }}
-- depends_on: {{ ref('gross_dollar_retention') }}
-- depends_on: {{ ref('net_dollar_retention') }}
