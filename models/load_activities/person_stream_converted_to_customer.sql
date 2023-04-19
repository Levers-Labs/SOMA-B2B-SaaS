{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'converted_to_customer',
    has_revenue_impact = false,
    feature_json_dict = '{"subcsription_type": ["mrr", "arr"],
"segment": ["seg1", "seg2", "seg3", "seg4"],
                         "plan": ["plan1", "plan2", "plan3"],
                         "csm": ["csm1", "csm2", "csm3", "csm4", "csm5"],
                         "mrr_tier": ["tier1", "tier2"]}'
  )
-}}
