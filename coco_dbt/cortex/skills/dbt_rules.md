# DBT Rules

## Dependency Chain
Source → Staging → Intermediate → Mart → Publish. Always create missing upstream layers first.

## Layer Definitions

| Layer | File | Mat. | Ref | Prereq | Tests |
|---|---|---|---|---|---|
| Source | `src__<schema>__<table>.yml` | — | — | — | `expect_table_columns_to_match_set` |
| Staging | `stg__<schema>__<table>.sql` +yml | view | `source()` in CTE | Source | `unique`+`not_null` on key |
| Intermediate | `int__<table>.sql` +yml | table | `ref()` | Staging | Optional |
| Mart (fact) | `fct__<table>.sql` +yml | incremental | `ref()` | Stg/Int | `unique`+`not_null` on PK |
| Mart (dim) | `dim__<table>.sql` +yml | incremental | `ref()` | Stg/Int | `unique`+`not_null` on SK |
| Publish | `<name>.sql` +yml | view | `ref()` | Mart/Int/Stg | Optional |
| Snapshot | `snp__<table>.yml` | — | — | stg/int | strategy+unique_key+check_cols |
| Seed | `sd__<table>.csv` | — | — | — | — |
| Macro | `mc__<name>.sql` | — | — | — | — |

**yml** = separate file in `definitions/` subfolder. One model per YAML. Source yml lives directly in `models/sources/<schema>/`.

## Project Structure

```
models/
  sources/<schema>/src__<schema>__<table>.yml
  staging/<schema>/<sql> + definitions/<yml>
  intermediate/<pipeline>/<sql> + definitions/<yml>
  marts/<pipeline>/<sql> + definitions/<yml>
  publish/<folder>/<sql> + definitions/<yml>
macros/  seeds/  snapshots/
```

One model per file. No mixing layers.

## Formatting
Lowercase everything (SQL keywords, columns, CTEs, aliases). Uppercase only for database/schema names.

## SQL Patterns

**Staging**
```sql
{{ config(materialized='view') }}
with source__<table> as (
    select column_1, column_2
    from {{ source('<db>__<schema>', '<table>') }}
)
select * from source__<table>
```
No joins, no aggregations, explicit columns only.

**Incremental (Mart)**
```sql
{{ config(materialized='incremental', unique_key='<pk>') }}
select * from {{ ref('<upstream>') }}
{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}
```

**Surrogate Key** (intermediate/mart only)
```sql
{{ dbt_utils.generate_surrogate_key(['col_1','col_2']) }} as <entity>_sk
```

**YAML**
```yaml
version: 2
models:
  - name: <model>
    description: <desc>
    columns:
      - name: <col>
        description: <desc>
        data_type: <type>
        data_tests: [not_null]
```

**Source YAML**
```yaml
sources:
  - name: <db>__<schema>
    database: <db>
    schema: <schema>
    tables:
      - name: <table>
        columns:
          - name: <col>
            data_type: <type>
            description: <desc>
```

## CTE Rules
- Staging: source inside CTE, explicit columns, `select * from <cte>`
- Int/Mart/Publish: named CTEs, final CTE as `final__<table>`, `select * from final__<table>`
- Mart: modular logic, surrogate keys (optional), metadata columns (created_at, updated_at)

## Testing
Composite keys: `dbt_utils.unique_combination_of_columns`. Requires `dbt_utils` package.

## Demo Data
Generate Snowflake tables, 50-1000 rows, with PKs, FKs, timestamps, metrics.

## Validation Checklist

| Check | Src | Stg | Int | Mart | Pub | Snap |
|---|---|---|---|---|---|---|
| Naming correct | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| SQL file | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| YAML file | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| Materialization | ✖ | view | table | incr | view | ✖ |
| source() | ✔ | ✔ | ✖ | ✖ | ✖ | ✖ |
| ref() | ✖ | ✖ | ✔ | ✔ | ✔ | ✔ |
| CTE naming | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Final CTE | ✖ | ✖ | ✔ | ✔ | ✔ | ✖ |
| Explicit cols | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| select * from CTE | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| unique_key config | ✖ | ✖ | ✖ | ✔ | ✖ | ✔ |
| Surrogate key | ✖ | ✖ | ✖ | ✔ | ✖ | ✖ |
| Metadata cols | ✖ | ✖ | ✖ | ✔ | ✖ | ✖ |
| Descriptions | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Data types | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Tests (per layer) | col_match | u+nn | opt | u+nn | opt | strat |
