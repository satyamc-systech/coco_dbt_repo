# Staging Model Creation

## Upstream Dependency

Always reference source models.

Never reference raw tables directly.

Use:

{{ source('<database>__<schema>', '<table>') }}

---

## Naming

stg__<schema>__<table>.sql

---

## Materialization

view

---

## SQL Pattern

Refer to: `patterns/staging_sql_pattern.md`

Since staging models have only one CTE, explicitly list all columns inside that CTE.
The final select must be `select * from <last_cte>`.

Example:

```sql
with source_data as (

    select
        column_1,
        column_2,
        column_3
    from {{ source('<database>__<schema>', '<table>') }}

)

select * from source_data
```

---

## Tests

unique
not_null

---

# YAML Generation

For every staging model created, also generate the yaml definition file.

Location

models/staging/<schema_name>/definitions/

Naming

stg__<schema_name>__<table_name>.yml