{{ config(
    materialized='table'
) }}

with stg_txn as (

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
        fb.branch_name,
        fb.branch_type,
        fb.branch_status,
        fb.branch_city,
        fb.branch_state,
        fb.branch_manager,
        t.created_at,
        t.updated_at
    from stg_txn t
    inner join stg_firm_branch fb
        on t.physical_branch_id = fb.branch_id

)

select * from final__txn_with_branch
