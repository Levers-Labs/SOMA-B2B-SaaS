{%-
  macro genereate_metrics_cube (
    source_cte,
    anchor_date,
    metric_calculation,
    metric_slices = [],
    date_slices = ["year", "quarter", "month", "week"],
    include_overall_total = true,
    is_snapshot_reliant_metric = false,
    metric_numerator = none,
    metric_denominator = none
  )
-%}

{#- CONSTANTS -#}

{%- set supported_date_slices = ["year", "quarter", "month", "week", "day"] -%}
{%- set total_name = "total" -%}
{%- set total_value = 'Total' -%}


{# INPUT VALIDATION -#}

{# Input Validation 1: either metric_slices or include_overall_total defined -#}
{%- if metric_slices|length == 0 and include_overall_total != true %}
  {{ exceptions.raise_compiler_error("Either metric_slices or include_overall_total must be defined") }}
{%- endif -%}

{# Input Validation 2: limit number of slice columns to 4 -#}
{# The purpose of this limitation is to limit the complexity of the metrics supported by this framework. -#}
{# Questions? Talk to a Data Lead. -#}
{% for slice in metric_slices %}
  {%- if slice|length > 4 %}
    {{ exceptions.raise_compiler_error("A slice may only contain at most 4 dimensions.") }}
  {%- elif slice is string %}
    {{ exceptions.raise_compiler_error("A slice must contain at least one dimension, wrapped in brackets []: " ~ slice) }}
  {%- endif -%}
{%- endfor -%}

{# Input Validation 3: use lowercase identifiers -#}
{# The column identifiers are included in the model output and used for grouping, so should be uniform. -#}
{%- if anchor_date != anchor_date|lower or metric_slices|string != metric_slices|string|lower -%}
  {{ exceptions.raise_compiler_error("Use lowercase identifiers for anchor_date and metric_slices.") }}
{%- endif -%}

{# Input Validation 4: sort dimensions in metric_slices -#}
{%- if metric_slices|length > 0 and metric_slices|map('sort')|list != metric_slices -%}
  {{ exceptions.raise_compiler_error("Dimensions in metric_slices must be sorted.") }}
{%- endif -%}

{# Input Validation 5: No duplicate metric_slice values -#}
{%- if metric_slices|map('string')|unique|list != metric_slices|map('string')|list -%}
  {{ exceptions.raise_compiler_error("Duplicate metric_slice values are not allowed.") }}
{%- endif -%}

{# Input Validation 6: No duplicate metric_slice dimensions -#}
{% for metric_slice in metric_slices -%}
  {%- if metric_slice|unique|list|length != metric_slice|length -%}
     {{ exceptions.raise_compiler_error("Duplicate metric_slice dimensions are not allowed.") }}
  {%- endif -%}
{% endfor -%}

{# Input Validation 7: Values in dates_slices are supported -#}
{% for date_slice in date_slices -%}
  {%- if date_slice not in supported_date_slices -%}
    {%- set msg = "The date_slices value " ~ date_slice ~ " is not supported. Supported values: " ~ supported_date_slices -%}
    {{ exceptions.raise_compiler_error(msg) }}
  {%- endif -%}
{% endfor -%}

{# Input Validation 8: the 'is_snapshot_reliant_metric' parameter must be a boolean -#}
{%- if is_snapshot_reliant_metric != true and is_snapshot_reliant_metric != false %}
  {{ exceptions.raise_compiler_error("The is_snapshot_reliant_metric parameter must be a boolean value") }}
{%- endif -%}

{# Input Validation 9: If the metric_calculation looks like a ratio, both metric_numerator and metric_denominator must be defined #}
{%-
  if '/' in metric_calculation
  and metric_calculation|select("in", ["+", "-", "*", "/", "%"])|list|count == 1
  and (
    metric_numerator == none
    or metric_denominator == none
  )
%}
  {{ exceptions.raise_compiler_error("metric_numerator and metric_denominator parameters must be filled in for ratio metrics") }}
{%- endif -%}

{# QUERY DEFINITION -#}

{# This macro assumes the calling model includes a source_cte that already includes the 'with' keyword. -#}
{# To simplify the calling model, a comma after its CTE definition is not expected, so add one here.-#}
,

{# Aggregate at every possible combination of date grains & slice -#}
cte_grouping_sets as (
  select
    {# Loop through each date grain and create a date_trunc version of it (e.g. day, month, year) -#}
    {%- for date_slice in date_slices -%}
      date_trunc('{{date_slice}}', {{ anchor_date }})::date as metric_{{date_slice}},
      grouping(metric_{{date_slice}}) as {{date_slice}}_bit,
    {% endfor -%}

    {% if include_overall_total == true -%}
      '{{total_value}}' as {{total_name}}_object,
    {% endif -%}

    {# Loop through each slice & create helper columns for later use -#}
    {# Store combination dictionary values, concatenated dimension names, and concatenated dimension values -#}
    {%- for combination in metric_slices -%}
      {%- for dimension in combination -%}
        concat('{"dim_name": "{{dimension}}", "dim_value": "', {{dimension}} , '"}') {%- if not loop.last %}, {% endif -%}
      {% endfor %} as combination_{{loop.index}},
    {% endfor -%}

    {# grouping() returns 0 for a row that is grouped on the column specified, and 1 when left out of aggregation -#}
    {% for _ in metric_slices -%}
      grouping(combination_{{loop.index}}) as combination_{{loop.index}}_bit,
    {% endfor -%}

    {%- if include_overall_total == true -%}
      grouping({{total_name}}_object) as {{total_name}}_bit,
    {% endif -%}

    {{"null" if metric_denominator is none else metric_denominator}} as metric_denominators,
    '{{metric_calculation}}' as metric_calculation,
    {{metric_calculation}} as metric_value
  from
    {{ source_cte }}
  {# Allow future dates for forward-looking metrics, with an upper bound of 1 year into the future -#}
  where {{ anchor_date }} between '2014-01-01' and current_date() + interval 365 day
  group by grouping sets (
    {# Add grouping sets for every combination of date_grain_pivots and slice -#}
    {%- for date_slice in date_slices -%}
      {%- for _ in metric_slices -%}
        (metric_{{date_slice}}, combination_{{loop.index}}) {%- if include_overall_total == true or (include_overall_total != true and not loop.last) -%}, {%- endif %}
      {% endfor -%}
      {%- if include_overall_total == true -%}
        (metric_{{date_slice}}, {{total_name}}_object)
      {%- endif -%}{%- if not loop.last -%}, {%- endif %}
    {% endfor -%}
  )
),

cte_final as (
    select
        '{{ model.name }}' as metric_model,
        {{ is_snapshot_reliant_metric }} as is_snapshot_reliant_metric,
        '{{ anchor_date }}' as anchor_date,
        {# Utilize grouping() bits created above to determine the level of aggregation -#}
        case
          {% for date_slice in date_slices -%}
            when {{date_slice}}_bit = 0 then '{{date_slice}}'
          {% endfor -%}
        end as date_grain,
        case
          {% for date_slice in date_slices -%}
            when {{date_slice}}_bit = 0 then metric_{{date_slice}}
          {% endfor -%}
        end as metric_date,
        case
          {% for _ in metric_slices -%}
            when combination_{{loop.index}}_bit = 0 then combination_{{loop.index}}
          {% endfor -%}
          {% if include_overall_total == true -%}
            when total_bit = 0 then {{total_name}}_object
          {% endif -%}
        end as slice_object,
        {# Create a string of dimension names, utilizing the key-value pairs -#}
        case
          {% for _ in metric_slices -%}
            when combination_{{loop.index}}_bit = 0 then concat(
              {%- for dimension in metric_slices[loop.index0] -%}
                ifnull(json_extract_string(slice_object, '$.dim_name'), 'null') {%- if not loop.last -%}, ' x ', {% endif %}
              {%- endfor -%}
            )
          {% endfor -%}
          {% if include_overall_total == true -%}
            when total_bit = 0 then '{{total_name}}'
          {% endif -%}
        end as slice_dimension,
        {# Create a string of dimension values, utilizing the key-value pairs -#}
        case
          {% for _ in metric_slices -%}
            when combination_{{loop.index}}_bit = 0 then concat(
              {%- for dimension in metric_slices[loop.index0] -%}
                ifnull(json_extract_string(slice_object, '$.dim_value'), 'null') {%- if not loop.last -%}, ' x ', {% endif %}
              {%- endfor -%}
            )
          {% endfor -%}
          {% if include_overall_total == true -%}
            when total_bit = 0 then '{{total_value}}'
          {% endif -%}
        end as slice_value,
        metric_calculation,
        case
          when metric_denominators != 0 and metric_value is null then 0
          else metric_value
        end as metric_value
    from
      cte_grouping_sets
)
select * from cte_final
{% endmacro %}