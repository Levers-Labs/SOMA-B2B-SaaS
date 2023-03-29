{{-
    config(materialized = 'table')
-}}

select
    '{{ model.name }}' as metric_model,
    false as is_snapshot_reliant_metric,
    tm.anchor_date,
    tm.date_grain,
    tm.metric_date,
    tm.slice_object,
    tm.slice_dimension,
    tm.slice_value,
    '1 - (total_rr(t) / total_rr(t-1)' as metric_calculation,
    1 - (tm.metric_value / lm.metric_value) as metric_value
from
    {{ ref('total_subscriptions_cube')}} tm
    join{{ ref('total_subscriptions_cube')}} lm
        on tm.metric_date = lm.metric_date - interval 1 month
        and tm.slice_dimension = lm.slice_dimension
        and tm.date_grain = lm.date_grain