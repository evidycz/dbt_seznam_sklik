{#
Macro to generate impression share metrics for Seznam Sklik.

This macro calculates various impression share metrics based on total impressions
and different types of lost impressions.

Args:
    impressions (string): The column representing the total number of impressions.
    miss_impressions (string): The column representing the total number of missed impressions (the denominator for the share calculation).
    metrics (list of strings, optional): A list of metric types to calculate impression share for.
                                         'impression' calculates total impression share.
                                         Other values (e.g., 'rank_lost', 'budget_lost') assume a corresponding
                                         column named '{metric}_impressions' exists and calculate the share
                                         of impressions lost due to that reason.
                                         Defaults to ['impression', 'rank_lost', 'budget_lost', 'schedule_lost'].
    round_to (int, optional): The number of decimal places to round the resulting share to. Defaults to none.
    coalesce_with (string, optional): The value to coalesce the result with if it's NULL (e.g., due to division by zero). Defaults to '0'.
#}
{% macro impression_shares(impressions, miss_impressions, metrics=['impression', 'rank_lost', 'budget_lost', 'schedule_lost'], round_to=null, coalesce_with='0') %}

{% for metric in metrics %}
    {% set numerator = impressions if metric == 'impression' else metric ~ '_impressions' %}
    {% set denominator = impressions ~ ' + ' ~ miss_impressions %}
    {% set column_name = 'impression_share' if metric == 'impression' else metric ~ '_impression_share' %}

    {% if loop.index > 1 %},{% endif %}
    {% if round_to is not none %}
        round(coalesce(
            case
                when ({{ denominator }}) = 0 then 0
                else {{ numerator }} / ({{ denominator }})
            end, {{ coalesce_with }}
        ), {{ round_to }}) as {{ column_name }}
    {% else %}
        coalesce(
            case
                when ({{ denominator }}) = 0 then 0
                else {{ numerator }} / ({{ denominator }})
            end, {{ coalesce_with }}
        ) as {{ column_name }}
    {% endif %}
{% endfor %}

{% endmacro %}
