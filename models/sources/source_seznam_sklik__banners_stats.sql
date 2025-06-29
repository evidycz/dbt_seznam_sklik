with source as (

    select *
    from {{ source('seznam_sklik', 'banners_stats') }}
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

        id as banner_id,
        banner_name,
        status as banner_status,
        ad_status as banner_condition,
        cast(image__width as string) as width,
        cast(image__height as string) as height,

        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks,
        coalesce(conversions, 0) as conversions,
        coalesce(conversion_value, 0) as conversions_value,
        round(coalesce(total_money, 0) / 100, 2) as spend_czk,

        coalesce(avg_pos, 0) as ad_position,
        round(coalesce(ish_sum, 0) / 100, 2) as ish,

    from source
)

select * from final