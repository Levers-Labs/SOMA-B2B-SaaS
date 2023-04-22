{{-
    config(materialized = 'table')
-}}

select
    '{{ model.name }}' as metric_model,
    false as is_snapshot_reliant_metric,
    er.anchor_date,
    er.date_grain,
    er.metric_date,
    er.slice_object,
    er.slice_dimension,
    er.slice_value,
    '(new_rr + expansion_rr) / (churned_rr + contraction_rr)' as metric_calculation,
    (nr.metric_value + er.metric_value) / (cr.metric_value - ch.metric_value)  as metric_value
from
    {{ ref('ga_cube_expansion_revenue') }} er
    join {{ ref('ga_cube_churned_revenue') }} ch
        on er.metric_date = ch.metric_date
        and er.slice_dimension = ch.slice_dimension
        and er.date_grain = ch.date_grain
    join {{ ref('ga_cube_contraction_revenue') }} cr
        on er.metric_date = cr.metric_date
        and er.slice_dimension = cr.slice_dimension
        and er.date_grain = cr.date_grain
    join {{ ref('ga_cube_new_revenue') }} nr
        on er.metric_date = nr.metric_date
        and er.slice_dimension = nr.slice_dimension
        and er.date_grain = nr.date_grain