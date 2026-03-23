{{ config(
    materialized='view'
) }}

with source_data as (

    select
        relationship_id,
        fin_prof_dim_key,
        firm_dim_key,
        relationship_type,
        relationship_status,
        start_date,
        end_date,
        commission_split_pct,
        primary_flag,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__producers', 'FIN_PROF_TO_FIRM_REL') }}

)

select * from source_data
