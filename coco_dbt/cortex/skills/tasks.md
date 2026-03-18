# DBT Tasks

## Source
- **File**: `src__<schema>__<table>.yml` in `models/sources/<schema>/`
- **Content**: database, schema, table, columns (name, data_type, description)
- **Test**: `dbt_expectations.expect_table_columns_to_match_set`
- **No SQL file needed**

```yaml
sources:
  - name: <database>__<schema>
    database: <database>
    schema: <schema>
    tables:
      - name: <table>
        columns:
          - name: column_1
            data_type: varchar
            description: <desc>
```

## Staging
- **File**: `stg__<schema>__<table>.sql` + YAML in `definitions/`
- **Materialization**: `view`
- **Reference**: `{{ source('<database>__<schema>', '<table>') }}` inside a CTE
- **Tests**: `unique`, `not_null` on key columns
- **Rules**: Explicit column listing, no joins, no aggregations
- **Prerequisite**: Source must exist; create it first if missing

## Intermediate
- **File**: `int__<table>.sql` + YAML in `definitions/`
- **Materialization**: `table`
- **Reference**: `{{ ref('stg__<schema>__<table>') }}`
- **Tests**: Optional
- **Rules**: Modular logic, use CTEs with naming convention, final CTE as `final__<table>`
- **Prerequisite**: Staging must exist

## Mart
- **File**: `fct__<table>.sql` or `dim__<table>.sql` + YAML in `definitions/`
- **Materialization**: `incremental` (with `unique_key`)
- **Reference**: `{{ ref('int__<table>') }}` or `{{ ref('stg__<schema>__<table>') }}`
- **Tests**: `unique` + `not_null` on primary/surrogate key
- **Rules**: Surrogate keys via `dbt_utils.generate_surrogate_key()`, metadata columns (created_at, updated_at)
- **Prerequisite**: Staging or intermediate must exist

## Publish
- **File**: `<name>.sql` + YAML in `definitions/`
- **Materialization**: `view`
- **Reference**: `{{ ref('fct__<table>') }}` or `{{ ref('dim__<table>') }}`
- **Tests**: Optional
- **Prerequisite**: Mart must exist

## Snapshot
- **File**: `snp__<table>.yml`
- **Required config**: `strategy`, `unique_key`, `check_cols`
- **No SQL file needed**

## Full Pipeline
Generate in order: Source → Staging → Intermediate → Mart → Publish. Each layer follows its rules above.

## Demo Data
Generate Snowflake tables with 50-1000 rows. Include: primary keys, foreign keys, realistic timestamps, numeric metrics.

---

## Validation Checklist (All Layers)

| Check | Src | Stg | Int | Mart | Pub | Snap |
|---|---|---|---|---|---|---|
| Correct naming | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| SQL file exists | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| YAML file exists | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| Materialization set | ✖ | view | table | incr | view | ✖ |
| source() used | ✔ | ✔ | ✖ | ✖ | ✖ | ✖ |
| ref() used | ✖ | ✖ | ✔ | ✔ | ✔ | ✔ |
| Source inside CTE | ✖ | ✔ | ✖ | ✖ | ✖ | ✖ |
| CTE naming convention | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Final CTE exists | ✖ | ✖ | ✔ | ✔ | ✔ | ✖ |
| Explicit columns in CTE | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| `select * from final_cte` | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Modular logic | ✖ | ✖ | ✔ | ✔ | ✖ | ✖ |
| unique_key in config | ✖ | ✖ | ✖ | ✔ | ✖ | ✔ |
| Surrogate key (optional) | ✖ | ✖ | ✖ | ✔ | ✖ | ✖ |
| Metadata columns | ✖ | ✖ | ✖ | ✔ | ✖ | ✖ |
| Table description | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Column descriptions | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Column data types | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Generic tests | ✖ | ✔ | ✔ | ✔ | ✔ | ✖ |
| unique test | ✖ | ✔ | ✖ | ✔ | ✔ | ✖ |
| not_null test | ✖ | ✔ | ✖ | ✔ | ✔ | ✖ |
| Composite key (dbt_utils) | ✖ | ✔ | ✖ | ✔ | ✔ | ✖ |
| Column match test | ✔ | ✖ | ✖ | ✖ | ✖ | ✖ |
| Snapshot strategy | ✖ | ✖ | ✖ | ✖ | ✖ | ✔ |
| Snapshot unique_key | ✖ | ✖ | ✖ | ✖ | ✖ | ✔ |
| Snapshot check_cols | ✖ | ✖ | ✖ | ✖ | ✖ | ✔ |
