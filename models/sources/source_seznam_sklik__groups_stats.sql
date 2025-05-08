with base as (

    select *
    from {{ source('seznam_sklik', 'groups_stats') }}
),

final as (

    select
        "date" as date_day,

        account_id,
        account_name,

        cast(campaign__id as string) as campaign_id,
        campaign__name as campaign_name,

        cast(id as string) as ad_group_id,
        name as ad_group_name,
        status as ad_group_status,

        round(coalesce(max_cpc, 0) / 100, 2) as set_cpc,
        round(coalesce(max_cpt, 0) / 100, 2) as set_cpm,

        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks,
        coalesce(conversions, 0) as conversions,
        coalesce(conversion_value, 0) as conversions_value,
        round(coalesce(total_money, 0) / 100, 2) as spend_czk,

        coalesce(avg_pos, 0) as ad_position,

        coalesce(win_rate, 0) as win_rate,

        coalesce(miss_impressions, 0) as miss_impressions,
        coalesce(under_forest_threshold, 0) as rank_lost_impressions,
        coalesce(exhausted_budget, exhausted_budget_share, 0) as budget_lost_impressions,
        coalesce(stopped_by_schedule, 0) as schedule_lost_impressions,

    from base
)

select * from final