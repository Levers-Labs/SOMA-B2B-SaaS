{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'ramped_ae',
    has_revenue_impact = false,
    feature_json_dict = '{"tenure": ["t1", "t2", "t3", "t4"]}'
  )
-}}
