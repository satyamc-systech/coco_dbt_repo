{{ config(
    materialized='incremental',
    unique_key='id'
) }}

with src__source_table as (
    select * from source_table
    {% if is_incremental() %}
    where updated_at > (
        select max(updated_at) from {{ this }}
    {% endif %}
    )
),

final_target_table as (
    select
        col1,
        col2,
        colN
    from src__source_table
)

select * from final_target_table
