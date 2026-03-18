# DBT Patterns

## Staging SQL

```sql
{{ config(materialized='view') }}

with source__<table> as (
    select
        column_1,
        column_2,
        column_3
    from {{ source('<database>__<schema>', '<table>') }}
)

select * from source__<table>
```

Rules: No joins, no aggregations, explicit column listing, minimal transformations.

## Model YAML

```yaml
version: 2
models:
  - name: <model_name>
    description: <description>
    columns:
      - name: column_1
        description: <description>
        data_type: <type>
        data_tests:
          - not_null
      - name: column_2
        description: <description>
        data_type: <type>
```

## Incremental

```sql
{{ config(materialized='incremental', unique_key='id') }}

select * from {{ ref('source_model') }}
{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}
```

## Surrogate Key

```sql
{{ dbt_utils.generate_surrogate_key(['column_1', 'column_2']) }} as <entity>_sk
```

Rules: Only in intermediate/mart layers. Name as `<entity>_sk`. Requires `dbt_utils` package.
