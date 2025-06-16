{{ config(
    cluster_by="account_name"
) }}

with accounts_settings as (

    select *
    from {{ ref('source_seznam_sklik__accounts_settings') }}
    where access_type like 'rw%'
),

groups_stats as (

    select *
    from {{ ref('source_seznam_sklik__groups_stats') }}
),

accounts_stats as (

    select
        date_day,
        account_id,

        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value,
        sum(spend_czk) as spend_czk,

    from groups_stats
    {{ dbt_utils.group_by(n=2) }}
),

fields as (

    select
        accounts_stats.date_day,

        accounts_settings.account_id,
        accounts_settings.account_name,

        accounts_settings.wallet_credit_czk,

        accounts_stats.impressions,
        accounts_stats.clicks,
        accounts_stats.conversions,
        accounts_stats.conversions_value,
        accounts_stats.spend_czk,

    from accounts_settings
    left join accounts_stats
        on accounts_settings.account_id = accounts_stats.account_id
)

select * from fields