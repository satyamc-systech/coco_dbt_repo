{{ config(
    materialized='view'
) }}

with source_data as (

    select
        policy_id,
        policy_number,
        customer_id,
        agent_id,
        policy_type,
        policy_status,
        effective_date,
        expiration_date,
        cast(premium_amount as decimal(12, 2)) as premium_amount,
        cast(deductible_amount as decimal(10, 2)) as deductible_amount,
        cast(coverage_limit as decimal(14, 2)) as coverage_limit,
        billing_frequency,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__insurance_raw', 'POLICIES') }}

)

select * from source_data
