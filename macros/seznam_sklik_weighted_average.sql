{#
Macro to calculate a weighted average.

Args:
    value_column (string): The column containing the values to be averaged.
    weight_column (string): The column containing the weights.
    alias (string): The name for the resulting weighted average column.
    round_to (int, optional): The number of decimal places to round the result to. Defaults to none.
    coalesce_with (string, optional): The value to coalesce the result with if it's NULL (e.g., due to division by zero). Defaults to '0'.
#}
{% macro weighted_average(value_column, weight_column, alias, round_to=none, coalesce_with='0') %}

{% set numerator = 'sum(' ~ value_column ~ ' * ' ~ weight_column ~ ')' %}
{% set denominator = 'sum(' ~ weight_column ~ ')' %}

{% set calculation = numerator ~ ' / nullif(' ~ denominator ~ ', 0)' %} {# Use NULLIF to handle division by zero gracefully #}

{% set final_expression %}
    coalesce(
        {% if round_to is not none %}
            round({{ calculation }}, {{ round_to }})
        {% else %}
            {{ calculation }}
        {% endif %},
        {{ coalesce_with }}
    )
{% endset %}

{{ final_expression }} as {{ alias }}

{% endmacro %}