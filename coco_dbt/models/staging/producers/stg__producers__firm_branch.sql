{{ config(
    materialized='view'
) }}

with source_data as (

    select
        branch_id,
        master_firm_id,
        branch_name,
        branch_type,
        branch_status,
        branch_address,
        branch_city,
        branch_state,
        branch_zip,
        branch_phone,
        branch_manager,
        effective_date,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__producers', 'FIRM_BRANCH') }}

)

select * from source_data
