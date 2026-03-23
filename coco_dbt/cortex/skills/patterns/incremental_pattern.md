# Incremental SQL Pattern

## Column Listing Rules

- Use `select *` in all source declaration CTEs
- Explicitly list all columns only in the last CTE
- The final select outside CTEs must be `select * from <last_cte>`

## Standard SQL Structure

{{ config(
    materialized='incremental',
    unique_key='id'
) }}

with src__source_table as (

    select * from {{ ref('upstream_model') }}

),

final as (

    select
        col1,
        col2,
        colN,
        updated_at
    from src__source_table
    {% if is_incremental() %}
    where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}

)

select * from final
