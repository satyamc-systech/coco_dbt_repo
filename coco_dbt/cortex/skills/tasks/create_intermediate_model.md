# Intermediate Model Creation

## Naming

int__<table>.sql

## Materialization

table

## Input

Always reference staging models.

Example:

SELECT
    *
FROM {{ ref('stg__schema__table') }}