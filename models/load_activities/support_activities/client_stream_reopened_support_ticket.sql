{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'reopened_support_ticket',
    has_revenue_impact = false,
    feature_json_dict = '{"segment": ["s1", "s2", "s3", "s4"],
                          "mrr_tier": ["t1", "t2", "t3"],
                          "plan": ["p1", "p2", "p3", "p4"],
                          "csm": ["csm1", "csm2", "csm3"]}'
  )
-}}
