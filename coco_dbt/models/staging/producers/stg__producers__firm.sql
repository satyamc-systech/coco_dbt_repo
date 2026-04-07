{{ config(
    materialized='view'
) }}

with source_data as (

    select
        firm_dim_key,
        master_firm_id,
        firm_name,
        firm_type,
        firm_status,
        firm_npn,
        firm_tax_id,
        firm_state,
        firm_city,
        firm_zip,
        effective_date,
        expiration_date,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__producers', 'FIRM') }}

)

select * from source_data
