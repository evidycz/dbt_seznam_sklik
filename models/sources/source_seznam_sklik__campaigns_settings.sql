with base as (

    select *
    from {{ source('seznam_sklik', 'campaigns_settings') }}
),

final as (

    select
        account_id,
        account_name,

        id as campaign_id,
        name as campaign_name,
        type as campaign_type,
        status as campaign_status,

        create_date,
        delete_date,
        start_date,
        end_date,

        total_budget / 100 as total_budget_czk,
        total_budget_from,

        ad_selection,
        video_format

    from base
)

select * from final