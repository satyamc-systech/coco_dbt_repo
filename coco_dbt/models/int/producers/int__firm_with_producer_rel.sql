{{ config(
    materialized='table'
) }}

with stg_firm as (

    select * from {{ ref('stg__producers__firm') }}

),

stg_fin_prof_to_firm_rel as (

    select * from {{ ref('stg__producers__fin_prof_to_firm_rel') }}

),

final__firm_with_producer_rel as (

    select
        r.relationship_id,
        r.fin_prof_dim_key,
        f.firm_dim_key,
        f.master_firm_id,
        f.firm_name,
        f.firm_type,
        f.firm_status,
        f.firm_state,
        f.firm_city,
        r.relationship_type,
        r.relationship_status,
        r.start_date as relationship_start_date,
        r.end_date as relationship_end_date,
        r.commission_split_pct,
        r.primary_flag,
        r.created_at,
        r.updated_at
    from stg_firm f
    inner join stg_fin_prof_to_firm_rel r
        on f.firm_dim_key = r.firm_dim_key

)

select * from final__firm_with_producer_rel
