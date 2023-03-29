{{-
  config(materialized = 'table')
-}}

with cte_sequence as (
    select unnest(generate_series(1,5000)) as id
),
cte_base as (
    select
        id,
        now() - to_seconds(floor(random()*id*10000)::int) as create_date,
        'channel' || floor(50*random())::int::text as first_touch_channel,
        'channel' || floor(50*random())::int::text as last_touch_channel,
        'segment' || floor(30*random())::int::text as last_touch_channel
    from
        cte_sequence
)
select *, substring(date_trunc('month', create_date)::text, 1, 7) as cohort
from cte_base
