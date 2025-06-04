with source as (

    select *
    from {{ source('seznam_sklik', 'accounts') }}
),

final as (

    select
        cast(user_id as string) as account_id,
        username as account_name,

        agency_status,
        relation_name,
        relation_status,
        relation_type,
        access as access_type,

        wallet_credit / 100 as wallet_credit_czk

    from source
)

select * from final