{{ config(
    materialized='incremental',
    unique_key='producer_sk'
) }}

with producer_profile as (

    select * from {{ ref('int__producer_with_profile') }}

),

final__producer as (

    select
        {{ dbt_utils.generate_surrogate_key(['pp.fin_prof_dim_key']) }} as producer_sk,
        pp.fin_prof_dim_key,
        pp.producer_npn,
        pp.first_name,
        pp.last_name,
        pp.full_name,
        pp.producer_type,
        pp.license_state,
        pp.license_status,
        pp.license_number,
        pp.email,
        pp.phone,
        pp.designation,
        pp.years_experience,
        pp.active_flag,
        pp.firm_dim_key,
        pp.relationship_type,
        pp.relationship_status,
        pp.start_date as relationship_start_date,
        pp.end_date as relationship_end_date,
        pp.commission_split_pct,
        pp.primary_flag,
        pp.created_at,
        pp.updated_at
    from producer_profile pp
    {% if is_incremental() %}
    where pp.updated_at > (select max(updated_at) from {{ this }})
    {% endif %}

)

select * from final__producer
