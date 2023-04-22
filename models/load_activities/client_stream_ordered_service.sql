{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'ordered_service',
    has_revenue_impact = true,
    feature_json_dict = '{"service": ["service1", "service2", "service3"],
"segment": ["seg1", "seg2", "seg3", "seg4"],
                         "plan": ["plan1", "plan2", "plan3"]}'
  )
-}}
