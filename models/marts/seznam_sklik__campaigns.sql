with campaign_settings as (

    select *
    from {{ ref('source_seznam_sklik__campaigns_settings') }}
),

groups_stats as (

    select *
    from {{ ref('source_seznam_sklik__groups_stats') }}
),

ads_stats as (

    select *
    from {{ ref('source_seznam_sklik__ads_stats') }}
    where ad_type = 'video'
),

campaigns_stats as (

    select
        date_day,

        campaign_id,

        device,

        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value,
        sum(spend_czk) as spend_czk,

        {{ weighted_average('ad_position', 'impressions', 'ad_position', round_to=2) }},

        {{ weighted_average('auction_win', 'impressions', 'auction_win', round_to=2) }},

        sum(miss_impressions) as miss_impressions,
        sum(rank_lost_impressions) as rank_lost_impressions,
        sum(budget_lost_impressions) as budget_lost_impressions,
        sum(schedule_lost_impressions) as schedule_lost_impressions,

    from groups_stats
    {{ dbt_utils.group_by(n=3) }}
),

views_stats as (

    select
        date_day,

        campaign_id,

        sum(views) as views,

        {{ weighted_average('view_rate_25', 'impressions', 'view_rate_25', round_to=2) }},
        {{ weighted_average('view_rate_50', 'impressions', 'view_rate_50', round_to=2) }},
        {{ weighted_average('view_rate_75', 'impressions', 'view_rate_75', round_to=2) }},
        {{ weighted_average('view_rate_100', 'impressions', 'view_rate_100', round_to=2) }}
    from ads_stats
    {{ dbt_utils.group_by(n=2) }}
),

fields as (

    select
        campaigns_stats.date_day,

        campaign_settings.account_id,
        campaign_settings.account_name,

        campaign_settings.campaign_id,
        campaign_settings.campaign_name,
        campaign_settings.campaign_type,
        campaign_settings.campaign_status,

        campaign_settings.ad_selection,
        campaign_settings.video_format,

        campaigns_stats.device,

        campaigns_stats.impressions,
        campaigns_stats.clicks,
        coalesce(views_stats.views, 0) as views,
        campaigns_stats.conversions,
        campaigns_stats.conversions_value,
        campaigns_stats.spend_czk,

        campaigns_stats.ad_position,

        coalesce(campaigns_stats.auction_win, 0) as auction_win,

        miss_impressions,
        rank_lost_impressions,
        budget_lost_impressions,
        schedule_lost_impressions,

        coalesce(views_stats.view_rate_25, 0) as view_rate_25,
        coalesce(views_stats.view_rate_50, 0) as view_rate_50,
        coalesce(views_stats.view_rate_75, 0) as view_rate_75,
        coalesce(views_stats.view_rate_100, 0) as view_rate_100,
    from campaigns_stats
    left join views_stats
        on  campaigns_stats.campaign_id = views_stats.campaign_id
        and campaigns_stats.date_day = views_stats.date_day
    left join campaign_settings
        on campaigns_stats.campaign_id = campaign_settings.campaign_id
)

select * from fields