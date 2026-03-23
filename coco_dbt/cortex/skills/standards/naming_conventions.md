# Code Formatting Standard

All generated dbt code must follow lowercase conventions.

## Rules

1. SQL keywords must be lowercase.

example

select
from
where
join
group by

2. Table names, column names, aliases, cte names, and references must be lowercase.

example

select
    customer_id,
    policy_id
from {{ ref('stg__insurance__policy') }}

3. Uppercase should only be used when required, such as:

- database names
- schema names
- external system identifiers

example

{{ source('insurance_db__raw', 'customer') }}

4. YAML files must also use lowercase for:

- model names
- column names
- test definitions


# DBT Naming Conventions

Follow these naming conventions when generating dbt models.

## Source Models

src__<schema>__<table>.yml

Example

src__raw__customer.yml

---

## Staging Models

stg__<schema>__<table>.sql

Example

stg__raw__customer.sql

---

## Intermediate Models

int__<table>.sql

Example

int__customer_enriched.sql

---

## Mart Models

Fact Tables

fct__<table>.sql

Example

fct__policy_transactions.sql

Dimension Tables

dim__<table>.sql

Example

dim__customer.sql

---

## Publish Models

User defined naming.

Example

customer_policy_summary.sql

---

## Seeds

sd__<table>.csv

Example

sd__country_codes.csv

---

## Snapshots

snp__<table>.yml

Example

snp__customer.yml

---

## Macros

mc__<macro_name>.sql

Example

mc__generate_schema_name.sql

---

# Final CTE Pattern

Every dbt SQL model except staging (intermediate, mart, publish) must end with a final CTE that:

1. Is named `final__<table_name>` (matching the model name without the layer prefix).
2. Explicitly lists all output columns inside the CTE.
3. Is followed by `select * from final__<table_name>` as the last statement.

All source/reference declaration CTEs (non-final CTEs) must use `select *` instead of listing individual columns. Only the final CTE should explicitly list columns.
