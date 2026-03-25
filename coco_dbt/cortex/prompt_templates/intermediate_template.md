# Intermediate Model Prompt Template

Use this template to create a dbt intermediate model that joins, filters, or aggregates staging models.
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Create intermediate model.

Pipeline folder: insurance_pipeline

Input staging tables:
- stg__insurance_raw__claims
- stg__insurance_raw__policies

Transformations:
- joins: Join claims to policies on policy_id
- filters: Only include claims with claim_status IN ('APPROVED', 'SETTLED')
- aggregations: None
- computed columns: net_payout_amount = approved_amount - deductible_applied, days_to_settle = datediff(day, report_date, settlement_date)

---

## Additional Example

### Revenue reconciliation intermediate

@(skill:dbt-router) Create intermediate model.

Pipeline folder: finance_pipeline

Input staging tables:
- stg__insurance_raw__policies
- stg__insurance_raw__billing
- stg__insurance_raw__general_ledger
- stg__insurance_raw__payments

Transformations:
- joins: Join billing, GL, and payments to policies on policy_id
- filters: None
- aggregations: Sum billing, GL, and payment amounts per policy
- computed columns: billing_vs_gl_diff = billing_amount - gl_amount, has_discrepancy = billing_amount != gl_amount
