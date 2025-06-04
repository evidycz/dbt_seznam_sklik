{#
Macro to unpivot device-specific columns in Seznam Sklik tables.

This macro transforms columns with a device prefix (e.g., device_mobile__impressions, 
device_desktop__impressions) into rows with device and metric columns.

Args:
    columns_to_unpivot (list of strings): List of metrics to unpivot (e.g., ['impressions', 'clicks', 'conversions']).
                                         The macro will automatically find all device columns for these metrics.
    device_pattern (string, optional): The pattern to identify the device part in column names. 
                                      Defaults to 'device_'.
    metric_separator (string, optional): The separator between device and metric in column names.
                                        Defaults to '__'.
    dimension_columns (list of strings, optional): Columns to include in the output as dimensions
                                                 (e.g., date, campaign_name).
                                                 These columns will be included in the output alongside
                                                 the unpivoted data.
                                                 Defaults to an empty list.

Example:
    ```sql
    select
        {{ seznam_sklik_unpivot_device(
            columns_to_unpivot=['impressions', 'clicks', 'conversions'],
            dimension_columns=['date', 'campaign_name', 'campaign_id']
        ) }}
    from my_table
    ```

    This will produce a result with columns: date, campaign_name, campaign_id, device, impressions, clicks, conversions
    where device will have values like 'mobile', 'desktop', 'tablet' and the metric columns will have the corresponding values.
#}
{% macro seznam_sklik_unpivot_device(columns_to_unpivot, device_pattern='device_', metric_separator='__', dimension_columns=[], relation=none, column_names=none) %}

-- Mobile device
select
    {% for dim_column in dimension_columns %}
        {{ dim_column }},
    {% endfor %}

    'mobile' as device,

    {% for metric in columns_to_unpivot %}
        device_phone__{{ metric }} as {{ metric }}{% if not loop.last %},{% endif %}
    {% endfor %}

from source

union all

-- Desktop device
select
    {% for dim_column in dimension_columns %}
        {{ dim_column }},
    {% endfor %}

    'desktop' as device,

    {% for metric in columns_to_unpivot %}
        device_desktop__{{ metric }} as {{ metric }}{% if not loop.last %},{% endif %}
    {% endfor %}

from source

union all

-- Tablet device
select
    {% for dim_column in dimension_columns %}
        {{ dim_column }},
    {% endfor %}

    'tablet' as device,

    {% for metric in columns_to_unpivot %}
        device_tablet__{{ metric }} as {{ metric }}{% if not loop.last %},{% endif %}
    {% endfor %}

from source

union all

-- Other device
select
    {% for dim_column in dimension_columns %}
        {{ dim_column }},
    {% endfor %}

    'other' as device,

    {% for metric in columns_to_unpivot %}
        device_other__{{ metric }} as {{ metric }}{% if not loop.last %},{% endif %}
    {% endfor %}

from source

{% endmacro %}
