# Publish Model Creation

## Naming

User defined

## Materialization

view

## Source

Always reference mart models.

Example

SELECT *
FROM {{ ref('fct__sales') }}