# DBT Project Structure Standard

This document defines the required directory structure for the dbt project.

All dbt models must follow this structure.

project/
├── models/
│   ├── sources/
│   │   └── <schema_name>/            # e.g. publish, raw — confirm with user
│   │       └── src__<schema_name>__<table_name>.yml
│   ├── staging/
│   │   └── <schema_name>/
│   │       ├── stg__<schema_name>__<table_name>.sql
│   │       └── definitions/
│   │           └── stg__<schema_name>__<table_name>.yml
│   ├── intermediate/
│   │   └── <pipeline_folder>/
│   │       ├── int__<table_name>.sql
│   │       └── definitions/
│   │           └── int__<table_name>.yml
│   ├── marts/
│   │   └── <pipeline_folder>/
│   │       ├── fct__<table_name>.sql
│   │       ├── dim__<table_name>.sql
│   │       └── definitions/
│   │           ├── fct__<table_name>.yml
│   │           └── dim__<table_name>.yml
│   └── publish/
│       └── <user_defined_folder>/
│           ├── <user_defined_name>.sql
│           └── definitions/
│               └── <user_defined_name>.yml
├── macros/
│   └── mc__<macro_name>.sql
├── seeds/
│   └── sd__<table_name>.csv
└── snapshots/
│   └── snp__<table_name>.yml
│
├── cortex/
│   ├── skills/
│   │
│   │   ├── dbt_router_skill.md
│   │
│   │   ├── tasks/
│   │   │   ├── create_source_model.md
│   │   │   ├── create_staging_model.md
│   │   │   ├── create_intermediate_model.md
│   │   │   ├── create_mart_model.md
│   │   │   ├── create_publish_model.md
│   │   │   ├── generate_full_pipeline.md
│   │   │   ├── generate_demo_data.md
│   │   │
│   │   ├── patterns/
│   │   │   ├── staging_sql_pattern.md
│   │   │   ├── incremental_pattern.md
│   │   │   ├── surrogate_key_pattern.md
│   │   │
│   │   └── standards/
│   │       ├── dbt_project_structure.md
│   │       ├── naming_conventions.md
│   │       ├── testing_rules.md
│   │
│   └── prompt_templates/
│       ├── source_template.md
│       ├── staging_template.md
│       ├── intermediate_template.md
│       ├── mart_template.md
│       ├── publish_template.md
│       ├── full_pipeline_template.md
│       ├── demo_data_template.md


## Rules

1. One model per file.
2. YAML definitions must be stored in `definitions/` folders.
3. Folder names must reflect schemas or pipeline names.
4. Do not mix models from different layers in the same folder.

---

# Model Definition Files

Each model must have a separate yaml definition file.

Examples

staging

stg__raw__customer.sql
definitions/stg__raw__customer.yml

intermediate

int__customer_enriched.sql
definitions/int__customer_enriched.yml

marts

fct__policy_transactions.sql
definitions/fct__policy_transactions.yml

publish

customer_policy_summary.sql
definitions/customer_policy_summary.yml