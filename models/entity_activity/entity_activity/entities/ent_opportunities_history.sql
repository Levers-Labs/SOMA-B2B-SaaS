{{
    config (
        materialized = 'incremental',
        incremental_strategy='append'
    )
}}
select 
    d.hs_object_id as entity_id,
    {{- generate_entity_history_id('d.hs_object_id') }} as entity_history_id,
    ptos.label as stage,
    dealname as name,
    try_cast(closedate as date) as expected_close_date,
    case when d.dealstage in ('closedwon', 'closedlost')
         then cast(hs_lastmodifieddate as date) end as actual_close_date,
    try_cast(coalesce(hs_arr, '0') as double) as estimated_pipeline_value,
    round(try_cast(hs_deal_stage_probability as double),2) as probability_to_close,
    round(try_cast(hs_deal_stage_probability as double),2)
         * try_cast(coalesce(hs_mrr, '0') as double) as mrr_potential,
    d.pipeline as type,
    o.firstName || ' ' || o.lastName as owned_by,
    d.hubspot_owner_id as owner_id,
    ot.team_name as generating_org,
    atocmp.to_object_id as company_id,
    atocnt.to_object_id as primary_contact_id,
    try_cast(hs_lastmodifieddate as timestamp) as updated_on,
    try_cast(createdate as timestamp) as created_on,
    {{ date_trunc('day',  dbt.current_timestamp()) }} as observed_on
from
    {{ source('raw_hubspot', 'deals') }} d
    left join {{ source('raw_hubspot', 'pipeline_to_stage')}} ptos
        on d.dealstage = ptos.id
    left join {{ source('raw_hubspot', 'owners') }} o
        on d.hubspot_owner_id = o.id
    left join {{ source('raw_hubspot', 'owners_teams') }} ot
        on o.id = ot.owner_id
    left join {{ source('raw_hubspot', 'associations')}} atocmp
        on atocmp.from_object_id = d.hs_object_id
        and atocmp.type = 'deal_to_company'
    left join {{ source('raw_hubspot', 'associations')}} atocnt
        on atocnt.from_object_id = d.hs_object_id
        and atocnt.type = 'deal_to_contact'
where
    d.archived = false
