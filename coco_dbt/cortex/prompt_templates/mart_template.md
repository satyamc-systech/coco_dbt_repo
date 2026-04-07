# Mart Model Prompt Template

Use this template to create dbt mart models (facts and dimensions).
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Create marts.

Pipeline folder: insurance_pipeline

Fact Tables:
- fct__claims_summary

Dimensions:
- dim__customer
- dim__policy

---

### Fact Table: fct__claims_summary

@(skill:dbt-router) Create fct__claims_summary

Grain: One row per claim

Measures:
- claim_amount
- approved_amount
- net_payout_amount
- days_to_settle

Dimensions:
- claim_status
- claim_type
- policy_id
- customer_id

Materialization: incremental
Unique Key: claim_id

---

### Dimension: dim__customer

Grain: One row per customer

Columns:
- customer_id
- customer_name
- email
- state
- region
- created_at

Materialization: table

---

### Dimension: dim__policy

Grain: One row per policy

Columns:
- policy_id
- policy_number
- policy_type
- policy_status
- effective_date
- expiration_date
- premium_amount
- customer_id

Materialization: table

---
## Additional Example

### Revenue reconciliation mart

@(skill:dbt-router) Create marts.

Pipeline folder: finance_pipeline

Fact Tables:
- fct__revenue_reconciled

Dimensions: None (uses existing dims)

### Fact Table: fct__revenue_reconciled

Grain: One row per policy

Measures:
- billing_amount_usd
- gl_amount_usd
- payment_amount_usd
- total_discrepancy_usd

Dimensions:
- product_line
- region
- reconciliation_status

Materialization: incremental
Unique Key: policy_id
