{{-
    config(materialized = 'table')
-}}

select
    '{{ model.name }}' as metric_model,
    false as is_snapshot_reliant_metric,
    cr.anchor_date,
    cr.date_grain,
    cr.metric_date,
    cr.slice_object,
    cr.slice_dimension,
    cr.slice_value,
    'churned_subs + contraction_subs' as metric_calculation,
    cr.metric_value + ch.metric_value as metric_value
from
    {{ ref('ga_cube_contraction_subscriptions') }} cr
    join {{ ref('ga_cube_churned_subscriptions') }} ch
        on cr.metric_date = ch.metric_date
        and cr.slice_dimension = ch.slice_dimension
        and cr.date_grain = ch.date_grain
    left join {{ ref('ga_cube_total_subscriptions') }} tr 
        on tr.metric_date = cr.metric_date - interval 1 month
        and tr.slice_dimension = cr.slice_dimension
        and tr.date_grain = cr.date_grain