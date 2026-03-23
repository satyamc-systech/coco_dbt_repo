{{ config(
    materialized='table'
) }}

with stg_raw_annuity_txn as (

    select * from {{ ref('stg__insurance_raw__raw_annuity_txn') }}

),

stg_firm_branch as (

    select * from {{ ref('stg__producers__firm_branch') }}

),

final__txn_with_branch as (

    select
        t.txn_id,
        t.policy_number,
        t.product_type,
        t.txn_type,
        t.txn_status,
        t.txn_date,
        t.effective_date,
        t.premium_amount,
        t.commission_amount,
        t.physical_branch_id,
        t.master_firm_id,
        t.owner_first_name,
        t.owner_last_name,
        t.owner_state,
        t.annuitant_age,
        t.surrender_period_yrs,
        t.interest_rate,
        b.branch_name,
        b.branch_type,
        b.branch_status,
        b.branch_city,
        b.branch_state,
        b.branch_zip,
        b.branch_manager,
        t.created_at,
        t.updated_at
    from stg_raw_annuity_txn t
    inner join stg_firm_branch b
        on t.physical_branch_id = b.branch_id

)

select * from final__txn_with_branch
