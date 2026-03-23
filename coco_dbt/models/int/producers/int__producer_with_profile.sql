{{ config(
    materialized='table'
) }}

with stg_fin_prof_to_firm_rel as (

    select * from {{ ref('stg__producers__fin_prof_to_firm_rel') }}

),

stg_fin_prof as (

    select * from {{ ref('stg__producers__fin_prof') }}

),

final__producer_with_profile as (

    select
        r.relationship_id,
        r.fin_prof_dim_key,
        r.firm_dim_key,
        r.relationship_type,
        r.relationship_status,
        r.start_date as relationship_start_date,
        r.end_date as relationship_end_date,
        r.commission_split_pct,
        r.primary_flag,
        p.producer_npn,
        p.first_name,
        p.last_name,
        p.producer_type,
        p.license_state,
        p.license_status,
        p.license_number,
        p.email,
        p.phone,
        p.designation,
        p.years_experience,
        p.active_flag,
        r.created_at,
        r.updated_at
    from stg_fin_prof_to_firm_rel r
    inner join stg_fin_prof p
        on r.fin_prof_dim_key = p.fin_prof_dim_key

)

select * from final__producer_with_profile
