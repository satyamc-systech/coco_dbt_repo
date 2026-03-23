# DBT Testing Rules

This document defines mandatory testing requirements.

## Staging Layer

Each staging model must include:

- at least one unique test
- at least one not_null test

Example


## models:

- name: stg__raw__customer
  columns:
    - name: customer_id
      data_tests:
        - unique
        - not_null


---

## Mart Layer

Fact and dimension models must include:

- primary key unique test
- not_null tests on key fields

Example

models:
- name: dim__customer
  columns:
    - name: customer_id
      data_tests:
        - unique
        - not_null


---

## Intermediate Layer

Tests are optional.

---

## Publish Layer

Tests are optional unless required by analytics consumers.

---

## Source Layer

Source models should include:

dbt_expectations.expect_table_columns_to_match_set

IMPORTANT: This test must ONLY be placed in source YAML files (src__*.yml).
Do NOT add expect_table_columns_to_match_set to staging, intermediate, mart, publish, or snapshot YAML files unless specified.

---

# YAML Model Definition Rules

For every dbt model created, a corresponding yaml definition file must be generated.

## File Location

The yaml file must be stored inside a definitions folder relative to the model.

Example

staging model

models/staging/raw/stg__raw__customer.sql

yaml file

models/staging/raw/definitions/stg__raw__customer.yml

---

## Rule

Every model must have its own yaml file.

Never combine multiple models into one yaml file.

---

# Composite Key Testing

If a model has a composite key, use the dbt_utils test:

dbt_utils.unique_combination_of_columns

Example

data_tests:
  - dbt_utils.unique_combination_of_columns:
      arguments:
          combination_of_columns:
            - policy_id
            - customer_id

---

# Mart Model Testing

Fact tables

- primary key must be unique
- not_null on primary key

Dimension tables

- surrogate key must be unique
- not_null on surrogate key
