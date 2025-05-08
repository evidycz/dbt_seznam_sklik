with queries_stats as (

    select *
    from {{ ref('source_seznam_sklik__queries_stats') }}
)

select * from queries_stats