{{ config(
    cluster_by="account_name"
) }}

with banner_stats as (

    select *
    from {{ ref('source_seznam_sklik__banners_stats') }}
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

        banner_id,
        banner_name,
        banner_status,
        banner_condition,
        width,
        height,

        impressions,
        clicks,
        conversions,
        conversions_value,
        spend_czk,

        ad_position,
        ish,

    from banner_stats
)

select * from fields