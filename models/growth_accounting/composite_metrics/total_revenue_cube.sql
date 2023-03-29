{{-
    config(materialized = 'table')
-}}

select
    '{{ model.name }}' as metric_model,
    false as is_snapshot_reliant_metric,
    anchor_date,
    date_grain,
    metric_date,
    slice_object,
    slice_dimension,
    slice_value,
    'cumulative sum of net_rr' as metric_calculation,
    sum(metric_value) over(partition by slice_value order by metric_date) as metric_value
from
    {{ ref('net_revenue_cube') }}