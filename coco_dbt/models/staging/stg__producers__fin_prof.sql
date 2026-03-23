{{ config(
    materialized='view'
) }}

with source_data as (

    select
        fin_prof_dim_key,
        producer_npn,
        first_name,
        last_name,
        producer_type,
        license_state,
        license_status,
        license_number,
        email,
        phone,
        designation,
        years_experience,
        active_flag,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__producers', 'FIN_PROF') }}

)

select * from source_data
