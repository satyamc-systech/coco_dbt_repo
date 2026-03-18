{{ config(
    materialized='view'
) }}

WITH source_data AS (

    SELECT
        *
    FROM {{ source('cortex_analyst_demo__insurance_raw', 'PAYMENTS') }}

)

SELECT
    *
FROM source_data
