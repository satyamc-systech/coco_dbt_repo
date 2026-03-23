# Publish Model Creation

## Naming

User defined

## Materialization

view

## Source

Always reference mart models.

## SQL Pattern

Rules:
- Use `select *` in all source declaration CTEs
- Explicitly list all columns only in the last CTE
- The final select outside CTEs must be `select * from <last_cte>`

Example:

```sql
{{ config(
    materialized='view'
) }}

with mart_sales as (

    select * from {{ ref('fct__sales') }}

),

final as (

    select
        sale_id,
        customer_id,
        amount,
        sale_date
    from mart_sales

)

select * from final
```