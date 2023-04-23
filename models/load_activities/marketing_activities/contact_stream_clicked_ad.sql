{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'clicked_ad',
    has_revenue_impact = false,
    feature_json_dict = '{"campaign": ["cmp1", "cmp2", "cmp3", "cmp4"]}'
  )
-}}
