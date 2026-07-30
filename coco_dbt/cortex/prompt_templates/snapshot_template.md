# Snapshot Prompt Template

Use this template to create a dbt snapshot that tracks historical changes to a source table.
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Create snapshot:

Database: CORTEX_ANALYST_DEMO

Schema: INSURANCE_RAW

Table Name: CLAIMS

Primary Key: CLAIM_ID

Strategy: timestamp

Updated At Column: UPDATED_AT

---

## Notes

- **Strategy options**: `timestamp` (preferred when an updated_at column exists) or `check`
- **Check strategy**: Replace `Updated At Column` with `Check Columns: COL_1, COL_2` or `Check Columns: all`
- **Invalidate hard deletes**: Set to `true` by default to track deleted rows
