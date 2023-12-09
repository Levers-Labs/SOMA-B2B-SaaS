{{
    config (
        materialized = 'incremental',
        incremental_strategy='append'
    )
}}
select
    o.id as entity_id,
    {{ generate_entity_history_id('o.id') }} as entity_history_id,
    email,
    'Account Executive' as function,
    firstName as first_name,
    lastName as last_name,
    firstName || ' ' || lastName as full_name,
    userId as user_id,
    try_cast(createdAt as timestamp) as created_on,
    try_cast(updatedAt as timestamp) as updated_on,
    {{ date_trunc('day',  dbt.current_timestamp()) }} as observed_on
from
    {{ source('raw_hubspot', 'owners') }} o
    left join {{ source('raw_hubspot', 'owners_teams') }} ot
        on o.id = ot.owner_id
