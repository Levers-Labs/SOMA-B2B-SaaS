{{-
    config(materialized = 'table')
-}}

select
    '{{ model.name }}' as metric_model,
    false as is_snapshot_reliant_metric,
    coalesce(nr.anchor_date, er.anchor_date, cr.anchor_date, ch.anchor_date) as anchor_date,
    coalesce(nr.date_grain, er.date_grain, cr.date_grain, ch.date_grain) as date_grain,
    coalesce(nr.metric_date, er.metric_date, cr.metric_date, ch.metric_date) as metric_date,
    coalesce(nr.slice_object, er.slice_object, cr.slice_object, ch.slice_object) as slice_object,
    coalesce(nr.slice_dimension, er.slice_dimension, cr.slice_dimension, ch.slice_dimension) as slice_dimension,
    coalesce(nr.slice_value, er.slice_value, cr.slice_value, ch.slice_value) as slice_value,
    'new_rr + expansion_rr - contraction_rr - churn_rr' as metric_calculation,
    sum(coalesce(nr.metric_value, 0) + coalesce(er.metric_value, 0) - coalesce(cr.metric_value, 0) - coalesce(ch.metric_value, 0)) as metric_value
from
    {{ ref('new_revenue_cube') }} nr
    full outer join {{ ref('expansion_revenue_cube') }}  er
        on nr.metric_date = er.metric_date
        and nr.slice_dimension = er.slice_dimension
        and nr.date_grain = er.date_grain
    full outer join {{ ref('contraction_revenue_cube') }}  cr
        on nr.metric_date = cr.metric_date
        and nr.slice_dimension = cr.slice_dimension
        and nr.date_grain = cr.date_grain
    full outer join {{ ref('churned_revenue_cube') }}  ch
        on nr.metric_date = ch.metric_date
        and nr.slice_dimension = ch.slice_dimension
        and nr.date_grain = ch.date_grain
group by 1,2,3,4,5,6,7,8