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
    '1 - net_revenue_churn_rate' as metric_calculation,
    1 - metric_value as metric_value
from
    {{ ref('ga_cube_net_revenue_churn_rate') }}