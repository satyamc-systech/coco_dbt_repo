{{ config(
    materialized='view'
) }}

with source_data as (

    select
        payment_id,
        payment_number,
        claim_id,
        payment_type,
        payment_status,
        payment_method,
        cast(payment_amount as decimal(12, 2)) as payment_amount,
        payment_date,
        due_date,
        check_number,
        payee_name,
        bank_account,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__insurance_raw', 'PAYMENTS') }}

)

select * from source_data
