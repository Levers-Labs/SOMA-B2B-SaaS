{{-
    config(materialized = 'view')
-}}

-- Returns a list of relations that match schema.prefix%
{%- set cube_tables = dbt_utils.get_relations_by_pattern('main', 'ga_cube%') -%}
{{ dbt_utils.union_relations(relations = cube_tables) }}

-- depends_on: {{ ref('ga_cube_churned_subscriptions') }}
-- depends_on: {{ ref('ga_cube_churned_revenue') }}
-- depends_on: {{ ref('ga_cube_contraction_revenue') }}
-- depends_on: {{ ref('ga_cube_contraction_subscriptions') }}
-- depends_on: {{ ref('ga_cube_expansion_revenue') }}
-- depends_on: {{ ref('ga_cube_expansion_subscriptions') }}
-- depends_on: {{ ref('ga_cube_new_revenue') }}
-- depends_on: {{ ref('ga_cube_new_subscriptions') }}
-- depends_on: {{ ref('ga_cube_resurrected_revenue') }}
-- depends_on: {{ ref('ga_cube_resurrected_subscriptions') }}
-- depends_on: {{ ref('ga_cube_net_revenue') }}
-- depends_on: {{ ref('ga_cube_retained_subscriptions') }}
-- depends_on: {{ ref('ga_cube_retained_revenue') }}
-- depends_on: {{ ref('ga_cube_net_subscriptions') }}
-- depends_on: {{ ref('ga_cube_quick_ration') }}
-- depends_on: {{ ref('ga_cube_total_revenue') }}
-- depends_on: {{ ref('ga_cube_total_subscriptions') }}
-- depends_on: {{ ref('ga_cube_committed_revenue') }}
-- depends_on: {{ ref('ga_cube_gross_revenue_churn') }}
-- depends_on: {{ ref('ga_cube_gross_revenue_churn_rate') }}
-- depends_on: {{ ref('ga_cube_net_revenue_churn') }}
-- depends_on: {{ ref('ga_cube_net_revenue_churn_rate') }}
-- depends_on: {{ ref('ga_cube_revenue_cmgr') }}
-- depends_on: {{ ref('ga_cube_gross_subscriptions_churn') }}
-- depends_on: {{ ref('ga_cube_revenue_growth_rate') }}
-- depends_on: {{ ref('ga_cube_subscriber_cmgr') }}
-- depends_on: {{ ref('ga_cube_subscriber_growth_rate') }}
-- depends_on: {{ ref('ga_cube_gross_dollar_retention') }}
-- depends_on: {{ ref('ga_cube_net_dollar_retention') }}
