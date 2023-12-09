{{
    config(materialized = 'table')
}}

{{
    get_current_entity(ref('ent_companies_history'))
}}