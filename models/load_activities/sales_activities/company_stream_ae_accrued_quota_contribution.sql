{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'ae_accrued_quota_contribution',
    has_revenue_impact = false,
    feature_json_dict = '{"tenure": ["t1", "t2", "t3", "t4"]}'
  )
-}}
