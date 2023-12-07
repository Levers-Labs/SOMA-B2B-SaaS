{{
    config(materialized = 'table')
}}
with cte_base_dates as (
    {{
        dbt_utils.date_spine(
            datepart = "day",
            start_date = "cast('2023-01-01' as date)",
            end_date = "current_date() + interval 3 year"
        )
    }}
),
cte_dates_with_prior_year_dates as (
    select
        cast(d.date_day as date) as date_day,
        cast(timestampadd(year, -1, d.date_day) as date) as prior_year_date_day,
        cast(timestampadd(day, -364, d.date_day) as date) as prior_year_over_year_date_day
    from
    	cte_base_dates d
)
select
    d.date_day,
    cast(timestampadd(day, -1, d.date_day) as date) as prior_date_day,
    cast(timestampadd(day, 1, d.date_day) as date) as next_date_day,
    d.prior_year_date_day as prior_year_date_day,
    d.prior_year_over_year_date_day,
    date_part('dayofweek', d.date_day) as day_of_week,
    date_part('dayofweek_iso', d.date_day) as day_of_week_iso,
    date_format(d.date_day, 'EEEE') as day_of_week_name,
    date_format(d.date_day, 'E') as day_of_week_name_short,
    date_part('day', d.date_day) as day_of_month,
    dayofyear(d.date_day) as day_of_year,
    cast(date_trunc('week', d.date_day) as date) as week_start_date,
    cast(timestampadd(day, -1, timestampadd(week, 1, date_trunc('week', d.date_day))) as date) as week_end_date,
    cast(date_trunc('week', d.prior_year_over_year_date_day) as date) as prior_year_week_start_date,
    cast(timestampadd(day, -1, timestampadd(week, 1, date_trunc('week', d.prior_year_over_year_date_day))) as date) as prior_year_week_end_date,
    cast(date_part('week', d.date_day) as integer) as week_of_year,
    cast(date_trunc('week', d.date_day) as date) as iso_week_start_date,
    cast(timestampadd(day, 6, cast(date_trunc('week', d.date_day) as date)) as date) as iso_week_end_date,
    cast(date_trunc('week', d.prior_year_over_year_date_day) as date) as prior_year_iso_week_start_date,
    cast(timestampadd(day, 6, cast(date_trunc('week', d.prior_year_over_year_date_day) as date)) as date) as prior_year_iso_week_end_date,
    cast(date_part('week', d.date_day) as integer) as iso_week_of_year,
    cast(date_part('week', d.prior_year_over_year_date_day) as integer) as prior_year_week_of_year,
    cast(date_part('week', d.prior_year_over_year_date_day) as integer) as prior_year_iso_week_of_year,
    cast(date_part('month', d.date_day) as integer) as month_of_year,
    date_format(d.date_day, 'MMMM')  as month_name,
    date_format(d.date_day, 'MMM')  as month_name_short,
    cast(date_trunc('month', d.date_day) as date) as month_start_date,
    cast(cast(timestampadd(day, -1, timestampadd(month, 1, date_trunc('month', d.date_day))) as date) as date) as month_end_date,
    cast(date_trunc('month', d.prior_year_date_day) as date) as prior_year_month_start_date,
    cast(cast(timestampadd(day, -1, timestampadd(month, 1, date_trunc('month', d.prior_year_date_day))) as date) as date) as prior_year_month_end_date,
    cast(date_part('quarter', d.date_day) as integer) as quarter_of_year,
    cast(date_trunc('quarter', d.date_day) as date) as quarter_start_date,
    cast(cast(timestampadd(day, -1, timestampadd(quarter, 1, date_trunc('quarter', d.date_day))) as date) as date) as quarter_end_date,
    cast(date_part('year', d.date_day) as integer) as year_number,
    cast(date_trunc('year', d.date_day) as date) as year_start_date,
    cast(cast(timestampadd(day, -1, timestampadd(year, 1, date_trunc('year', d.date_day))) as date) as date) as year_end_date
from
    cte_dates_with_prior_year_dates d
