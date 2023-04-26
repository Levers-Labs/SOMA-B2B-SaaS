{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'updated_win_probability',
    has_revenue_impact = false,
    feature_json_dict = '{"tenure": ["t1", "t2", "t3", "t4"]}'
  )
-}}
