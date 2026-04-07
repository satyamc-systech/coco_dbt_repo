{{ config(
    materialized='incremental',
    unique_key='firm_sk'
) }}

with branch_with_firm as (

    select * from {{ ref('int__branch_with_firm') }}

),

branch_counts as (

    select
        master_firm_id,
        count(*) as branch_count
    from branch_with_firm
    group by master_firm_id

),

stg_firm as (

    select * from {{ ref('stg__producers__firm') }}

),

final__firm as (

    select
        {{ dbt_utils.generate_surrogate_key(['f.firm_dim_key']) }} as firm_sk,
        f.firm_dim_key,
        f.master_firm_id,
        f.firm_name,
        f.firm_type,
        f.firm_status,
        f.firm_npn,
        f.firm_tax_id,
        f.firm_state,
        f.firm_city,
        f.firm_zip,
        f.effective_date,
        f.expiration_date,
        coalesce(bc.branch_count, 0) as branch_count,
        f.created_at,
        f.updated_at
    from stg_firm f
    left join branch_counts bc
        on f.master_firm_id = bc.master_firm_id
    {% if is_incremental() %}
    where f.updated_at > (select max(updated_at) from {{ this }})
    {% endif %}

)

select * from final__firm
