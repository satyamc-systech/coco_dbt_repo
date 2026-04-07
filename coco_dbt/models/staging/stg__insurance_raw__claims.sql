{{ config(
    materialized='view'
) }}

with source_data as (

    select
        claim_id,
        claim_number,
        policy_id,
        claim_status,
        claim_type,
        incident_date,
        report_date,
        cast(claim_amount as decimal(12, 2)) as claim_amount,
        cast(approved_amount as decimal(12, 2)) as approved_amount,
        cast(deductible_applied as decimal(8, 2)) as deductible_applied,
        incident_description,
        adjuster_name,
        settlement_date,
        created_at,
        updated_at
    from {{ source('cortex_analyst_demo__insurance_raw', 'CLAIMS') }}

)

select * from source_data
