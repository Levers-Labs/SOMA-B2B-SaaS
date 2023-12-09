{{
    config (
        materialized = 'table'
    )
}}
with cte_latest_employee_history as (
    {{ get_latest_entity_history(ref('ent_employees_history')) }}
)
select
    o.entity_id || o.created_on as primary_key,
    'ae_loses_new_business_opportunity' as activity_name,
    '{
        "entity":"Account_Executive",
        "entity_id":"'|| ae.entity_id ||'",
        "entity_history_id":"'|| ae.entity_history_id ||'"
     }' as actor,
    '{
        "entity":"New_Business_Opportunity",
        "entity_id":"'|| o.entity_id ||'",
        "entity_history_id":"'|| o.entity_history_id ||'"
     }' as object,
    o.updated_on as activity_ts,
    o.observed_on,
    o.primary_contact_id,
    o.company_id,
    'estimated_pipeline_value' as activity_attribute,
    o.estimated_pipeline_value as activity_value
from
    {{ ref('ent_opportunities') }} o
    left join cte_latest_employee_history ae
        on o.owner_id = ae.entity_id
where
    o.stage = 'closedlost'
