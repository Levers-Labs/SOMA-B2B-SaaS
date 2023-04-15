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
    '(expansion_rr - churned_rr + contraction_rr) / total_rr' as metric_calculation,
    (er.metric_value - cr.metric_value - ch.metric_value) / nullif(tr.metric_value, 0) as metric_value
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
    left join {{ ref('ga_cube_total_revenue') }} tr 
        on tr.metric_date = cr.metric_date - interval 1 month
        and tr.slice_dimension = cr.slice_dimension
        and tr.date_grain = tr.date_grain