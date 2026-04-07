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
        fb.branch_id,
        fb.master_firm_id,
        fb.branch_name,
        fb.branch_type,
        fb.branch_status,
        fb.branch_address,
        fb.branch_city,
        fb.branch_state,
        fb.branch_zip,
        fb.branch_phone,
        fb.branch_manager,
        fb.effective_date as branch_effective_date,
        f.firm_dim_key,
        f.firm_name,
        f.firm_type,
        f.firm_status,
        f.firm_state,
        f.firm_city,
        fb.created_at,
        fb.updated_at
    from stg_firm_branch fb
    inner join stg_firm f
        on fb.master_firm_id = f.master_firm_id

)

select * from final__branch_with_firm
