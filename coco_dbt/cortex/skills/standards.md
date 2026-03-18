# DBT Standards

## Project Structure

```
models/
  sources/<schema>/src__<schema>__<table>.yml
  staging/<schema>/stg__<schema>__<table>.sql
  staging/<schema>/definitions/stg__<schema>__<table>.yml
  intermediate/<pipeline>/int__<table>.sql
  intermediate/<pipeline>/definitions/int__<table>.yml
  marts/<pipeline>/fct__<table>.sql | dim__<table>.sql
  marts/<pipeline>/definitions/fct__<table>.yml | dim__<table>.yml
  publish/<folder>/<name>.sql
  publish/<folder>/definitions/<name>.yml
macros/mc__<macro_name>.sql
seeds/sd__<table>.csv
snapshots/snp__<table>.yml
```

Rules: One model per file. YAML in `definitions/` folders. No mixing layers in same folder.

## Naming

| Layer | Pattern | Example |
|---|---|---|
| Source | `src__<schema>__<table>.yml` | `src__raw__customer.yml` |
| Staging | `stg__<schema>__<table>.sql` | `stg__raw__customer.sql` |
| Intermediate | `int__<table>.sql` | `int__customer_enriched.sql` |
| Mart (fact) | `fct__<table>.sql` | `fct__policy_transactions.sql` |
| Mart (dim) | `dim__<table>.sql` | `dim__customer.sql` |
| Publish | `<user_defined>.sql` | `customer_policy_summary.sql` |
| Seed | `sd__<table>.csv` | `sd__country_codes.csv` |
| Snapshot | `snp__<table>.yml` | `snp__customer.yml` |
| Macro | `mc__<name>.sql` | `mc__generate_schema_name.sql` |

## Code Formatting

- keep all case-insensitive things/code in lowercase.

## Testing Rules

| Layer | Required Tests |
|---|---|
| Source | `dbt_expectations.expect_table_columns_to_match_set` |
| Staging | `unique` + `not_null` on key columns |
| Intermediate | Optional |
| Mart (fact) | `unique` + `not_null` on primary key |
| Mart (dim) | `unique` + `not_null` on surrogate key |
| Publish | Optional unless required by consumers |

Composite keys: use `dbt_utils.unique_combination_of_columns`.

Every model must have its own YAML file. Never combine multiple models into one YAML.
