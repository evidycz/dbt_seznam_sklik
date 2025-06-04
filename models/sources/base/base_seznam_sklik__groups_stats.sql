with source as (

    select *
    from {{ source('seznam_sklik', 'groups_stats') }}
)

{{ seznam_sklik_unpivot_device(
    columns_to_unpivot=['impressions', 'clicks', 'total_money', 'conversions', 'conversion_value', 'avg_pos', 'win_rate', 'miss_impressions', 'exhausted_budget', 'stopped_by_schedule', 'under_forest_threshold', 'exhausted_budget_share', 'ish', 'ish_context', 'ish_sum'],
    dimension_columns=['date', 'account_id', 'account_name', 'campaign__id', 'campaign__name', 'id', 'name'],
    column_names=[
        'date', 'account_id', 'account_name', 'campaign__id', 'campaign__name', 'id', 'name',
        'device_phone__impressions', 'device_desktop__impressions', 'device_tablet__impressions', 'device_other__impressions',
        'device_phone__clicks', 'device_desktop__clicks', 'device_tablet__clicks', 'device_other__clicks',
        'device_phone__total_money', 'device_desktop__total_money', 'device_tablet__total_money', 'device_other__total_money',
        'device_phone__conversions', 'device_desktop__conversions', 'device_tablet__conversions', 'device_other__conversions',
        'device_phone__conversion_value', 'device_desktop__conversion_value', 'device_tablet__conversion_value', 'device_other__conversion_value',
        'device_phone__avg_pos', 'device_desktop__avg_pos', 'device_tablet__avg_pos', 'device_other__avg_pos',
        'device_phone__win_rate', 'device_desktop__win_rate', 'device_tablet__win_rate', 'device_other__win_rate',
        'device_phone__miss_impressions', 'device_desktop__miss_impressions', 'device_tablet__miss_impressions', 'device_other__miss_impressions',
        'device_phone__exhausted_budget', 'device_desktop__exhausted_budget', 'device_tablet__exhausted_budget', 'device_other__exhausted_budget',
        'device_phone__stopped_by_schedule', 'device_desktop__stopped_by_schedule', 'device_tablet__stopped_by_schedule', 'device_other__stopped_by_schedule',
        'device_phone__under_forest_threshold', 'device_desktop__under_forest_threshold', 'device_tablet__under_forest_threshold', 'device_other__under_forest_threshold',
        'device_phone__exhausted_budget_share', 'device_desktop__exhausted_budget_share', 'device_tablet__exhausted_budget_share', 'device_other__exhausted_budget_share',
        'device_phone__ish', 'device_desktop__ish', 'device_tablet__ish', 'device_other__ish',
        'device_phone__ish_context', 'device_desktop__ish_context', 'device_tablet__ish_context', 'device_other__ish_context',
        'device_phone__ish_sum', 'device_desktop__ish_sum', 'device_tablet__ish_sum', 'device_other__ish_sum'
    ]
) }}
