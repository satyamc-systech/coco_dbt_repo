{{ config(
    materialized='table'
) }}

with stg_rel as (

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
        r.start_date,
        r.end_date,
        r.commission_split_pct,
        r.primary_flag,
        fp.producer_npn,
        fp.first_name,
        fp.last_name,
        fp.first_name || ' ' || fp.last_name as full_name,
        fp.producer_type,
        fp.license_state,
        fp.license_status,
        fp.license_number,
        fp.email,
        fp.phone,
        fp.designation,
        fp.years_experience,
        fp.active_flag,
        fp.created_at,
        fp.updated_at
    from stg_rel r
    inner join stg_fin_prof fp
        on r.fin_prof_dim_key = fp.fin_prof_dim_key

)

select * from final__producer_with_profile
