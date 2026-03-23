{{ config(
    materialized='table'
) }}

with stg_firm_branch as (

    select * from {{ ref('stg__producers__firm_branch') }}

),

stg_firm as (

    select * from {{ ref('stg__producers__firm') }}

),

final__branch_with_firm as (

    select
        b.branch_id,
        b.master_firm_id,
        b.branch_name,
        b.branch_type,
        b.branch_status,
        b.branch_address,
        b.branch_city,
        b.branch_state,
        b.branch_zip,
        b.branch_phone,
        b.branch_manager,
        f.firm_dim_key,
        f.firm_name,
        f.firm_type,
        f.firm_status,
        f.firm_npn,
        f.firm_state as firm_hq_state,
        f.firm_city as firm_hq_city,
        b.effective_date as branch_effective_date,
        f.effective_date as firm_effective_date,
        f.expiration_date as firm_expiration_date,
        b.created_at,
        b.updated_at
    from stg_firm_branch b
    inner join stg_firm f
        on b.master_firm_id = f.master_firm_id

)

select * from final__branch_with_firm
