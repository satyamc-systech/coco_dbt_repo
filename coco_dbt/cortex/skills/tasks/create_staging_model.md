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

SELECT
    *
FROM {{ source('<database>__<schema>', '<table>') }}

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