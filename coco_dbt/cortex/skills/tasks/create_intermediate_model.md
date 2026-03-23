# Intermediate Model Creation

## Naming

int__<table>.sql

## Materialization

table

## Input

Always reference staging models.

## SQL Pattern

Rules:
- Use `select *` in all the source declaration CTEs
- Explicitly list all columns only in the last CTE
- The final select outside CTEs must be `select * from <last_cte>`

Example:

```sql
{{ config(
    materialized='table'
) }}

with stg_customers as (

    select * from {{ ref('stg__schema__customers') }}

),

stg_orders as (

    select * from {{ ref('stg__schema__orders') }}

),

final as (

    select
        c.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date
    from stg_customers c
    inner join stg_orders o
        on c.customer_id = o.customer_id

)

select * from final
```