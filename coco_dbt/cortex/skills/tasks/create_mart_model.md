# Mart Model Creation

## Naming

Fact tables:
fct__<table>

Dimension tables:
dim__<table>

---

## Materialization

incremental

---

## Incremental Pattern

Use merge logic.

{{ config(
    materialized='incremental',
    unique_key='id'
) }}

SELECT *
FROM {{ ref('int__table') }}