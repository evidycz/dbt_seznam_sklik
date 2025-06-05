with base as (

    select *
    from {{ ref('base_seznam_sklik__groups_stats') }}
),

final as (

    select
        {{ adapter.quote('date') }} as date_day,

        account_id,
        cast(campaign__id as string) as campaign_id,
        cast(id as string) as ad_group_id,

        upper(device) as device,

        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks,
        coalesce(conversions, 0) as conversions,
        coalesce(conversion_value, 0) as conversions_value,
        round(coalesce(total_money, 0) / 100, 2) as spend_czk,

        coalesce(avg_pos, 0) as ad_position,
        round(coalesce(ish_sum, 0) / 100, 2) as ish,
        coalesce(win_rate, 0) as auction_win,

    from base
)

select * from final