# Mart Model Creation

## Naming

Fact tables:
fct__<table>

Dimension tables:
dim__<table>

---

## Materialization

incremental

---

## Incremental Pattern

Use merge logic.

Rules:
- Use `select *` in all source declaration CTEs
- Explicitly list all columns only in the last CTE
- The final select outside CTEs must be `select * from <last_cte>`

Refer to: `patterns/incremental_pattern.md`

Example:

```sql
{{ config(
    materialized='incremental',
    unique_key='id'
) }}

with stg_data as (

    select * from {{ ref('int__table') }}

),

final as (

    select
        id,
        col1,
        col2,
        updated_at
    from stg_data
    {% if is_incremental() %}
    where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}

)

select * from final
```