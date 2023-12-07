{{
    config (
        materialized = 'incremental',
        incremental_strategy='append'
    )
}}
select 
    hs_object_id as entity_id,
    {{ generate_entity_history_id('hs_object_id') }} as entity_history_id,
    hubspot_owner_id as owner_id,
    lower(industry) as industry,
    name,
    try_cast(annualrevenue as double) as size,
    {{ dbt.safe_cast('createdate', dbt.type_timestamp()) }} as created_on,
    {{ date_trunc('hour',  dbt.current_timestamp()) }} as observed_on
from
    {{ source('raw_hubspot','companies') }}
