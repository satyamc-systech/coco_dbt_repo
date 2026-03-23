{{ config(
    materialized='incremental',
    unique_key='firm_sk'
) }}

with branch_with_firm as (

    select * from {{ ref('int__branch_with_firm') }}

),

final__firm as (

    select
        {{ dbt_utils.generate_surrogate_key(['firm_dim_key']) }} as firm_sk,
        firm_dim_key,
        master_firm_id,
        firm_name,
        firm_type,
        firm_status,
        firm_npn,
        firm_hq_state,
        firm_hq_city,
        firm_effective_date,
        firm_expiration_date,
        count(distinct branch_id) as total_branch_count,
        count(distinct case when branch_status = 'ACTIVE' then branch_id end) as active_branch_count,
        current_timestamp() as dbt_created_at,
        current_timestamp() as dbt_updated_at
    from branch_with_firm
    group by
        firm_dim_key,
        master_firm_id,
        firm_name,
        firm_type,
        firm_status,
        firm_npn,
        firm_hq_state,
        firm_hq_city,
        firm_effective_date,
        firm_expiration_date

)

select * from final__firm
