with source as (

    select *
    from {{ source('seznam_sklik', 'ads_stats') }}
),

final as (
    select
        {{ adapter.quote('date') }} as date_day,

        account_id,
        account_name,

        cast(campaign__id as string) as campaign_id,
        campaign__name as campaign_name,

        cast(group__id as string) as ad_group_id,
        group__name as ad_group_name,

        id as ad_id,
        status as ad_status,
        ad_status as ad_condition,
        ad_type,
        concat(headline1, ' - ', headline2) as headline,
        description as description,

        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks,
        coalesce(views, 0) as views,
        coalesce(conversions, 0) as conversions,
        coalesce(conversion_value, 0) as conversions_value,
        round(coalesce(total_money, 0) / 100, 2) as spend_czk,

        coalesce(avg_pos, 0) as ad_position,
        coalesce(ish_sum, 0) as ish,

        coalesce(skip_rate, 0) as skip_rate,

        coalesce(viewership_rate__first_quartile, 0) as view_rate_25,
        coalesce(viewership_rate__midpoint, 0) as view_rate_50,
        coalesce(viewership_rate__third_quartile, 0) as view_rate_75,
        coalesce(viewership_rate__complete, 0) as view_rate_100

    from source
)

select * from final