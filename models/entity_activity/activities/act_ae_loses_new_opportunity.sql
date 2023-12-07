{{
    config (
        materialized = 'table'
    )
}}
select
    o.entity_id || o.created_on as primary_key,
    'ae_loses_new_business_opportunity' as activity_name,
    '{
        "entity":"Account_Executive",
        "entity_id":"'|| ae.entity_id ||'"",
        "entity_history_id":"'|| ae.entity_history_id ||'"
     }' as actor,
    '{
        "entity":"New_Business_Opportunity",
        "entity_id":"'|| o.entity_id ||'"",
        "entity_history_id":"'|| o.entity_history_id ||'"
     }' as object,
    o.updated_on as activity_ts,
    o.observed_on,
    o.primary_contact_id,
    o.company_id,
    o.estimated_value as activity_value
from
    {{ ref('ent_opportunities') }} o
    left join {{ ref('ent_employees_history') }} ae
        on o.owner_id = ae.entity_id
        and o.observed_on = ae.observed_on
where
    o.stage = 'closedlost'
