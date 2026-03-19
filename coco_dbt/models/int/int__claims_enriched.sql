with stg_claims as (

    select
        claim_id,
        claim_number,
        policy_id,
        claim_status,
        claim_type,
        incident_date,
        report_date,
        claim_amount,
        approved_amount,
        deductible_applied,
        incident_description,
        adjuster_name,
        settlement_date,
        created_at,
        updated_at
    from {{ ref('stg__insurance_raw__claims') }}

),

final__claims_enriched as (

    select
        claim_id,
        claim_number,
        policy_id,
        claim_status,
        claim_type,
        incident_date,
        report_date,
        settlement_date,
        claim_amount,
        approved_amount,
        deductible_applied,
        approved_amount - deductible_applied as net_payout_amount,
        claim_amount - approved_amount as denied_amount,
        datediff('day', incident_date, report_date) as days_to_report,
        datediff('day', report_date, settlement_date) as days_to_settle,
        incident_description,
        adjuster_name,
        created_at,
        updated_at
    from stg_claims

)

select * from final__claims_enriched
