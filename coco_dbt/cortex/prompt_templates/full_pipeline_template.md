# Full Pipeline Prompt Template

Use this template to generate an end-to-end dbt pipeline (source -> staging -> intermediate -> mart -> publish).
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Create full DBT pipeline.

Database: CORTEX_ANALYST_DEMO
Schema: INSURANCE_RAW
Table: CLAIMS

Primary key: CLAIM_ID

Columns:
- CLAIM_ID (NUMBER) — Unique claim identifier
- CLAIM_NUMBER (TEXT) — Human-readable claim reference
- POLICY_ID (NUMBER) — Foreign key to policies
- CLAIM_STATUS (TEXT) — Current status (OPEN, APPROVED, DENIED, SETTLED)
- CLAIM_TYPE (TEXT) — Type of claim
- INCIDENT_DATE (DATE) — Date of incident
- REPORT_DATE (DATE) — Date claim was reported
- CLAIM_AMOUNT (NUMBER) — Total claimed amount
- APPROVED_AMOUNT (NUMBER) — Approved payout amount
- DEDUCTIBLE_APPLIED (NUMBER) — Deductible subtracted
- SETTLEMENT_DATE (DATE) — Date of settlement
- CREATED_AT (TIMESTAMP_NTZ) — Record creation timestamp
- UPDATED_AT (TIMESTAMP_NTZ) — Record update timestamp

Generate:
- source
- staging
- intermediate
- mart
- publish

---

## Additional Example

### Customers full pipeline

@(skill:dbt-router) Create full DBT pipeline.

Database: CORTEX_ANALYST_DEMO
Schema: INSURANCE_RAW
Table: CUSTOMERS

Primary key: CUSTOMER_ID

Columns:
- CUSTOMER_ID (NUMBER) — Unique customer identifier
- FIRST_NAME (TEXT) — Customer first name
- LAST_NAME (TEXT) — Customer last name
- EMAIL (TEXT) — Email address
- PHONE (TEXT) — Phone number
- ADDRESS (TEXT) — Street address
- CITY (TEXT) — City
- STATE (TEXT) — State code
- ZIP_CODE (TEXT) — ZIP code
- DATE_OF_BIRTH (DATE) — Date of birth
- CREATED_AT (TIMESTAMP_NTZ) — Record creation timestamp

Generate:
- source
- staging
- intermediate
- mart
- publish