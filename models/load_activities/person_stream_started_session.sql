{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'started_session',
    has_revenue_impact = false,
    feature_json_dict = '{"channel": ["ch1", "ch2", "ch3","ch4"],
                         "campaign": ["cmp1", "cmp2", "cmp3", "cmp4"],
                         "page": ["page1", "page2", "page3", "page4", "page5"]}'
  )
-}}
