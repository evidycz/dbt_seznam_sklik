with ads_stats as (

    select *
    from {{ ref('source_seznam_sklik__ads_stats') }}
),

fields as (

    select
        date_day,

        account_id,
        account_name,

        campaign_id,
        campaign_name,

        ad_group_id,
        ad_group_name,

        ad_id,
        ad_status,
        ad_condition,
        ad_type,
        headline,
        description,

        impressions,
        clicks,
        views,
        conversions,
        conversions_value,
        spend_czk,

        ad_position,
        ish,

        view_rate_25,
        view_rate_50,
        view_rate_75,
        view_rate_100,

    from ads_stats
)

select * from fields