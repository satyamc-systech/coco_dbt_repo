{{ config(
    materialized='incremental',
    unique_key='id'
) }}

SELECT *
FROM source_table

{% if is_incremental() %}

WHERE updated_at > (
SELECT max(updated_at)
FROM {{ this }}
)

{% endif %}