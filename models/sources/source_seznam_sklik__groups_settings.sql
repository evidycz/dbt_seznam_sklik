with source as (

    select *
    from {{ source('seznam_sklik', 'groups') }}
),

final as (

    select
        account_id,
        account_name,

        cast(campaign__id as string) as campaign_id,
        campaign__name as campaign_name,

        cast(id as string) as ad_group_id,
        name as ad_group_name,
        status as ad_group_status,

        round(coalesce(max_cpc, 0) / 100, 2) as set_cpc,
        round(coalesce(max_cpt, 0) / 100, 2) as set_cpm,

    from source
)

select * from final