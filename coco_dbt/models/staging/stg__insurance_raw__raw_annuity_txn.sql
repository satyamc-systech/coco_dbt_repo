{{ config(
    materialized='view'
) }}

with source_data as (

    select
        txn_id,
        policy_number,
        product_type,
        txn_type,
        txn_status,
        txn_date,
        effective_date,
        premium_amount,
        commission_amount,
        physical_branch_id,
        master_firm_id,
        owner_first_name,
        owner_last_name,
        owner_state,
        annuitant_age,
        surrender_period_yrs,
        interest_rate,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__insurance_raw', 'RAW_ANNUITY_TXN') }}

)

select * from source_data
