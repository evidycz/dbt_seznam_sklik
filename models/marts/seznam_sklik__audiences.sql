{{ config(
    cluster_by="account_name"
) }}

with retargeting_stats as (

    select *
    from {{ ref('source_seznam_sklik__retargeting_stats') }}
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

        audience_id,
        audience_name,

        impressions,
        clicks,
        conversions,
        conversions_value,
        spend_czk,

        ad_position,
        ish,

    from retargeting_stats
)

select * from fields