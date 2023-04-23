{{-
    config(materialized = 'table')
-}}

{{-
generate_fake_data (
    activity_name = 'sdr_called_prospect',
    has_revenue_impact = false,
    feature_json_dict = '{"channel": ["ch1", "ch2", "ch3","ch4"],
                         "campaign": ["cmp1", "cmp2", "cmp3", "cmp4"],
                         "org": ["org1", "org2", "org3"]}'
  )
-}}
