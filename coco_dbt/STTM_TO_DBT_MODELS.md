---
name: sttm_to_dbt_models
description: Generate dbt models from an STTM Excel file for Snowflake projects.
The skill reads an STTM workbook and produces: - dbt source YAML -
staging models - mart models (dimensions and facts)
Follow dbt project conventions defined in AGENTS.md.
---

# 1. Inputs

Required parameters:

-   sttm_excel_path : Path to STTM Excel
-   source_schema : Schema containing raw tables
-   pipeline_folder : Folder under models/marts/
-   source_name (optional) : dbt source name (default = source_schema)
-   pk_hints (optional) : dictionary `{table_name : pk_column}`
-   use_scd2 (optional) : enable SCD2 if STTM specifies scd_type=2

------------------------------------------------------------------------

# 2. Expected STTM Format

Each sheet represents a **target table**.

Ignore sheet `00_README`.

Expected columns:

target_table\
target_column\
target_datatype\
source_table\
source_column\
transformation\
join_condition\
filter_condition\
business_key\
scd_type\
effective_from_column\
effective_to_column\
is_current_column\
hash_key_expression\
record_checksum_expression\
load_ts_column\
batch_id_column\
source_system_expression\
union_tag

Blank values are allowed.

------------------------------------------------------------------------

# 3. Output Structure

Generate files using these paths.

Sources

models/sources/`<schema>`/src\_\_`<schema>`\_\_
```
<table>
```
.yml

Staging

models/staging/`<schema>`/stg\_\_`<schema>`\_\_
```
<table>
```
.sql\
models/staging/`<schema>`/definitions/stg\_\_`<schema>`\_\_
```
<table>
```
.yml

Marts

models/marts/`<pipeline>`/dim\_\_`<name>`.sql\
models/marts/`<pipeline>`/fct\_\_`<name>`.sql\
models/marts/`<pipeline>`/definitions/

------------------------------------------------------------------------

# 4. Source Generation

For every unique `source_table` in STTM:

Create a source YAML.

``` yaml
version: 2
sources:
  - name: <source_name>
    schema: <source_schema>
    tables:
      - name: <table_name>
        description: <table description>
        data_tests:
            - dbt_expectations.expect_table_columns_to_match_set:
                arguments:
                    column_list: [<COMMA SEPARATED COLUMN NAMES>]
```

One file per table.

------------------------------------------------------------------------

# 5. Staging Models

Create one staging model per source table.

Rules

-   Materialization = view
-   Do not rename columns
-   Select directly from source()

SQL template

``` sql
{{ config(materialized='view') }}

select *
from {{ source('<source_name>', '<table>') }}
```

Add tests

-   not_null
-   unique on primary key

Primary key priority:

1.  pk_hints
2.  column ending in `_id`
3.  business_key from STTM

------------------------------------------------------------------------

# 6. Mart Model Generation

Each STTM sheet produces one mart model.

Classification

dim\_\_\* → dimension\
fact\_\_\* → fact

Materialization

incremental

Config

``` sql
{{ config(
  materialized='incremental',
  incremental_strategy='merge',
  unique_key='<business_key>'
) }}
```

------------------------------------------------------------------------

# 7. Column Mapping Rules

For each STTM row:

Expression priority

1 transformation\
2 source_table.source_column

Apply datatype cast if `target_datatype` exists.

Example

``` sql
CAST(source_alias.column AS target_datatype)
```

------------------------------------------------------------------------

# 8. Joins

If `join_condition` references another source table:

Create LEFT JOIN using staging models.

------------------------------------------------------------------------

# 9. Filters

If `filter_condition` exists, apply it as early as possible in WHERE clause.

------------------------------------------------------------------------

# 10. Union Handling

If `union_tag` is populated:

Create multiple CTEs and combine with

UNION ALL

------------------------------------------------------------------------

# 11. Key Generation

If `hash_key_expression` exists → use as surrogate key.

Else generate:

MD5(business_key)

------------------------------------------------------------------------

# 12. SCD Handling

If `scd_type = 2`

Include columns

-   effective_from
-   effective_to
-   is_current
-   record_checksum

Use checksum to detect changes during merge.

Otherwise treat dimension as SCD1.

------------------------------------------------------------------------

# 13. Tests

Add tests in mart YAML

-   unique on business_key
-   not_null on business_key

------------------------------------------------------------------------

# 14. Execution Flow

1 Load STTM Excel\
2 Discover source tables\
3 Generate source YAML\
4 Generate staging models\
5 Generate mart models using STTM mapping

Pipeline:

SRC → STG → MART

Intermediate models are optional.

------------------------------------------------------------------------

# 15. Questions to Ask If Missing

-   Source schema?
-   Pipeline folder name?
-   Primary key hints for staging?
-   Enable SCD2 where scd_type=2?

Do not infer missing information. Ask the user before generating files.
