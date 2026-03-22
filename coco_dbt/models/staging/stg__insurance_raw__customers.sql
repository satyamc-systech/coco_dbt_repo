{{ config(
    materialized='view'
) }}

with source_data as (

    select
        customer_id,
        customer_number,
        first_name,
        last_name,
        date_of_birth,
        email,
        phone,
        address_line1,
        address_line2,
        city,
        state,
        zip_code,
        customer_type,
        credit_score,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__insurance_raw', 'CUSTOMERS') }}

)

select * from source_data
