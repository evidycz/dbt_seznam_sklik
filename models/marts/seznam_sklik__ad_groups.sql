with groups_settings as (

    select *
    from {{ ref('source_seznam_sklik__groups_settings') }}
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

views_stats as (

    select
        date_day,

        ad_group_id,

        sum(views) as views,

        {{ weighted_average('view_rate_25', 'impressions', 'view_rate_25', round_to=2) }},
        {{ weighted_average('view_rate_50', 'impressions', 'view_rate_50', round_to=2) }},
        {{ weighted_average('view_rate_75', 'impressions', 'view_rate_75', round_to=2) }},
        {{ weighted_average('view_rate_100', 'impressions', 'view_rate_100', round_to=2) }},
    from ads_stats
    {{ dbt_utils.group_by(n=2) }}
),

fields as (

    select
        groups_stats.date_day,

        groups_settings.account_id,
        groups_settings.account_name,

        groups_settings.campaign_id,
        groups_settings.campaign_name,

        groups_stats.ad_group_id,
        groups_settings.ad_group_name,
        groups_settings.ad_group_status,

        groups_settings.set_cpc,
        groups_settings.set_cpm,

        groups_stats.device,

        groups_stats.impressions,
        groups_stats.clicks,
        coalesce(views_stats.views, 0) as views,
        groups_stats.conversions,
        groups_stats.conversions_value,
        groups_stats.spend_czk,

        groups_stats.ad_position,
        groups_stats.ish,
        groups_stats.auction_win,

        coalesce(views_stats.view_rate_25, 0) as view_rate_25,
        coalesce(views_stats.view_rate_50, 0) as view_rate_50,
        coalesce(views_stats.view_rate_75, 0) as view_rate_75,
        coalesce(views_stats.view_rate_100, 0) as view_rate_100,

    from groups_stats
    left join groups_settings
        on groups_stats.ad_group_id = groups_settings.ad_group_id
    left join views_stats
        on groups_stats.ad_group_id = views_stats.ad_group_id
        and groups_stats.date_day = views_stats.date_day
)

select * from fields