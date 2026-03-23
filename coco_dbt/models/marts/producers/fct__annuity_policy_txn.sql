{{ config(
    materialized='incremental',
    unique_key='txn_sk'
) }}

with txn_with_branch as (

    select * from {{ ref('int__txn_with_branch') }}

),

firm_with_producer_rel as (

    select * from {{ ref('int__firm_with_producer_rel') }}

),

final__annuity_policy_txn as (

    select
        {{ dbt_utils.generate_surrogate_key(['t.txn_id']) }} as txn_sk,
        t.txn_id,
        t.policy_number,
        t.product_type,
        t.txn_type,
        t.txn_status,
        t.txn_date,
        t.effective_date,
        cast(t.premium_amount as decimal(28, 2)) as premium_amount,
        cast(t.commission_amount as decimal(28, 2)) as commission_amount,
        case
            when t.premium_amount != 0
            then round(t.commission_amount / t.premium_amount * 100, 2)
            else 0
        end as commission_rate_pct,
        t.physical_branch_id,
        t.master_firm_id,
        t.owner_first_name,
        t.owner_last_name,
        t.owner_state,
        t.annuitant_age,
        t.surrender_period_yrs,
        t.interest_rate,
        t.branch_name,
        t.branch_type,
        t.branch_state,
        f.firm_dim_key,
        f.firm_name,
        f.firm_type,
        f.firm_status,
        current_timestamp() as dbt_created_at,
        current_timestamp() as dbt_updated_at
    from txn_with_branch t
    left join firm_with_producer_rel f
        on t.master_firm_id = f.master_firm_id
    qualify row_number() over (
        partition by t.txn_id
        order by f.relationship_start_date desc
    ) = 1

)

select * from final__annuity_policy_txn
