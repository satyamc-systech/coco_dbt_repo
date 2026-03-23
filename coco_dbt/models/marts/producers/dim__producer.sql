{{ config(
    materialized='incremental',
    unique_key='producer_sk'
) }}

with producer_with_profile as (

    select * from {{ ref('int__producer_with_profile') }}

),

final__producer as (

    select
        {{ dbt_utils.generate_surrogate_key(['fin_prof_dim_key']) }} as producer_sk,
        fin_prof_dim_key,
        producer_npn,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        producer_type,
        license_state,
        license_status,
        license_number,
        email,
        phone,
        designation,
        years_experience,
        active_flag,
        firm_dim_key,
        relationship_type,
        relationship_status,
        relationship_start_date,
        relationship_end_date,
        commission_split_pct,
        primary_flag,
        current_timestamp() as dbt_created_at,
        current_timestamp() as dbt_updated_at
    from producer_with_profile

)

select * from final__producer
