{{ config(
    cluster_by="account_name",
    enabled=var('seznam_sklik__using_search_term_keyword_stats', True)
) }}

with queries_stats as (

    select *
    from {{ ref('source_seznam_sklik__queries_stats') }}
),

fields as (

    select
        account_id,
        account_name,

        campaign_id,
        campaign_name,

        ad_group_id,
        ad_group_name,

        keyword_id,
        keyword_text,
        keyword_match_type,
        keyword_status,

        max(set_cpc) as set_cpc,

        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value,
        sum(spend_czk) as spend_czk,

        {{ weighted_average('ad_position', 'impressions', 'ad_position', round_to=2) }},
    from queries_stats
    {{ dbt_utils.group_by(n=10) }}
)

select * from fields