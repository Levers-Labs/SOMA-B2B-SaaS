{{
    config(materialized = 'table')
}}

{{
    get_current_entity(ref('ent_employees_history'))
}}