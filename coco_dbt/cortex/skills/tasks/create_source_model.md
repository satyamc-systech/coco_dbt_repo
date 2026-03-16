# Source Model Creation Skill

Create dbt source YAML files.

## Location

models/sources/<schema_name>/

## Naming

src__<schema_name>__<table_name>.yml

## Requirements

Each source file must contain:

- database
- schema
- table
- column names
- column data types
- descriptions

## Required Tests

dbt_expectations.expect_table_columns_to_match_set

## Example Structure

sources:
  - name: <database>__<schema>
    database: <database>
    schema: <schema>

    tables:
      - name: <table_name>
        columns:
          - name: column_1
            data_type: varchar
            description: description
