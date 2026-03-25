# Publish Model Prompt Template

Use this template to create publish layer models that expose curated datasets for downstream consumers such as BI tools or analytics teams.
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Create a publish model.

Pipeline Folder: insurance_pipeline

Publish Folder Name: reporting

Model Name: pub__claims_overview

Input Mart Models:
- fct__claims_summary
- dim__customer
- dim__policy

Columns Required:
- claim_id
- claim_number
- customer_name
- policy_number
- claim_type
- claim_status
- claim_amount
- approved_amount
- net_payout_amount
- days_to_settle
- region

Filters: claim_status IN ('APPROVED', 'SETTLED')

Business Description: Dataset used by BI dashboards to track approved and settled insurance claims with customer and policy context.

Materialization: view

---

## Additional Example

### Revenue reconciliation report

@(skill:dbt-router) Create a publish model.

Pipeline Folder: finance_pipeline

Publish Folder Name: reporting

Model Name: pub__revenue_reconciliation

Input Mart Models:
- fct__revenue_reconciled

Columns Required:
- policy_id
- policy_number
- product_line
- region
- billing_amount_usd
- gl_amount_usd
- payment_amount_usd
- reconciliation_status
- total_discrepancy_usd

Filters: has_any_discrepancy = TRUE

Business Description: Dataset exposing policies with revenue discrepancies for finance team review.

Materialization: view