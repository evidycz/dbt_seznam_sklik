{{ config(
    cluster_by="account_name",
    enabled=var('seznam_sklik__using_search_term_keyword_stats', True)
) }}

with queries_stats as (

    select *
    from {{ ref('source_seznam_sklik__queries_stats') }}
)

select * from queries_stats