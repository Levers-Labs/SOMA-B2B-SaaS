{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'active_on_subscription',
    has_revenue_impact = true,
    feature_json_dict = '{"segment": ["seg1", "seg2", "seg3", "seg4"],
                         "plan": ["plan1", "plan2", "plan3"]}'
  )
-}}
