# Staging SQL Pattern

## Purpose

Staging models read data from source models and prepare them for transformation layers.

Rules:

- minimal or no transformations
- explicit column listing
- no joins
- no aggregations

---

## Materialization

view

---

## Standard SQL Structure

{{ config(
    materialized='view'
) }}

with source_data as (

    select

        -- explicitly list all columns
        column_1,
        column_2,
        column_3,
        column_4

    from {{ source('<database>__<schema>', '<table_name>') }}

)

select * from source_data
