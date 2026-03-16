
# Surrogate Key Pattern

This pattern defines how surrogate keys should be generated using dbt_utils.

## Macro
Use the dbt_utils macro:
dbt_utils.generate_surrogate_key()

## Syntax
{{ dbt_utils.generate_surrogate_key([
'column_1',
'column_2',
'column_3'
]) }}

## Example
SELECT
{{ dbt_utils.generate_surrogate_key([
    'customer_id',
    'policy_id'
]) }} AS customer_policy_sk,
customer_id,
policy_id,
policy_start_date,
policy_end_date
FROM {{ ref('stg__insurance__policy') }}

## Rules
1. Surrogate keys should only be generated in:
- intermediate models
- mart models

2. Do NOT generate surrogate keys in:
- source models
- staging models

3. Always name surrogate keys using:
<entity>_sk
Example
customer_sk
policy_sk
claim_sk

4. The macro automatically hashes the values to create a deterministic key.

## Dependency
Ensure dbt_utils package is installed.
packages.yml
packages:
package: dbt-labs/dbt_utils
version: ">=1.0.0"
