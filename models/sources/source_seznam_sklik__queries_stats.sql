{{ config(enabled=var('seznam_sklik__using_search_term_keyword_stats', True)) }}

with source as (

    select *
    from {{ source('seznam_sklik', 'queries_stats') }}
),

final as (

    select
        account_id,
        account_name,

        cast(campaign__id as string) as campaign_id,
        campaign__name as campaign_name,

        cast(group__id as string) as ad_group_id,
        group__name as ad_group_name,

        cast(keyword__id as string) as keyword_id,
        keyword__name as keyword_text,
        keyword__match_type as keyword_match_type,
        keyword__status as keyword_status,

        query as search_term,

        round(coalesce(keyword__max_cpc, group__max_cpc, 0) / 100, 2) as set_cpc,

        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks,
        coalesce(conversions, 0) as conversions,
        coalesce(conversion_value, 0) as conversions_value,
        round(coalesce(total_money, 0) / 100, 2) as spend_czk,

        coalesce(avg_pos, 0) as ad_position,

    from source
)

select * from final