{{ config(
    materialized='incremental',
    unique_key='txn_sk'
) }}

with txn_branch as (

    select * from {{ ref('int__txn_with_branch') }}

),

firm_rel as (

    select * from {{ ref('int__firm_with_producer_rel') }}

),

joined as (

    select
        tb.txn_id,
        tb.policy_number,
        tb.product_type,
        tb.txn_type,
        tb.txn_status,
        tb.txn_date,
        tb.effective_date,
        tb.premium_amount,
        tb.commission_amount,
        tb.physical_branch_id,
        tb.master_firm_id,
        tb.owner_first_name,
        tb.owner_last_name,
        tb.owner_state,
        tb.annuitant_age,
        tb.surrender_period_yrs,
        tb.interest_rate,
        tb.branch_name,
        tb.branch_type,
        tb.branch_status,
        tb.branch_city,
        tb.branch_state,
        tb.branch_manager,
        fr.firm_dim_key,
        fr.firm_name,
        fr.firm_type,
        fr.firm_status,
        fr.relationship_id,
        fr.fin_prof_dim_key,
        fr.relationship_type,
        fr.relationship_status,
        fr.relationship_start_date,
        fr.relationship_end_date,
        fr.commission_split_pct,
        fr.primary_flag,
        row_number() over (
            partition by tb.txn_id
            order by fr.relationship_start_date desc
        ) as rn,
        tb.created_at,
        tb.updated_at
    from txn_branch tb
    inner join firm_rel fr
        on tb.master_firm_id = fr.master_firm_id

),

deduped as (

    select * from joined
    where rn = 1

),

final__annuity_policy_txn as (

    select
        {{ dbt_utils.generate_surrogate_key(['txn_id']) }} as txn_sk,
        txn_id,
        policy_number,
        product_type,
        txn_type,
        txn_status,
        txn_date,
        effective_date,
        premium_amount,
        commission_amount,
        case
            when premium_amount > 0 then round(commission_amount / premium_amount * 100, 2)
            else 0
        end as commission_rate_pct,
        physical_branch_id,
        master_firm_id,
        owner_first_name,
        owner_last_name,
        owner_state,
        annuitant_age,
        surrender_period_yrs,
        interest_rate,
        branch_name,
        branch_type,
        branch_status,
        branch_city,
        branch_state,
        branch_manager,
        firm_dim_key,
        firm_name,
        firm_type,
        firm_status,
        relationship_id,
        fin_prof_dim_key,
        relationship_type,
        relationship_status,
        relationship_start_date,
        relationship_end_date,
        commission_split_pct,
        primary_flag,
        created_at,
        updated_at
    from deduped
    {% if is_incremental() %}
    where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}

)

select * from final__annuity_policy_txn
