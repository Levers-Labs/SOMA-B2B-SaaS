{{-
    config(materialized = 'table')
-}}

with cte_cmgr_calculation as (
    select
        '{{ model.name }}' as metric_model,
        false as is_snapshot_reliant_metric,
        tm.anchor_date,
        tm.date_grain,
        tm.metric_date,
        tm.slice_object,
        tm.slice_dimension,
        tm.slice_value,
        '((total_rr(t) / total_rr(t-12)) ^ 1/12) - 1' as metric_calculation,
        power((tm.metric_value / lm.metric_value), 1.0/12.0) as metric_value
    from
        {{ ref('total_subscriptions_cube')}} tm
        join{{ ref('total_subscriptions_cube')}} lm
            on tm.metric_date = lm.metric_date - interval 12 month
            and tm.slice_dimension = lm.slice_dimension
            and tm.date_grain = lm.date_grain
)
select
    metric_model,
    date_grain,
    metric_date,
    slice_dimension,
    slice_value,
    metric_calculation,
    case when not isnan(metric_value) then metric_value - 1 end as metric_value
from
    cte_cmgr_calculation