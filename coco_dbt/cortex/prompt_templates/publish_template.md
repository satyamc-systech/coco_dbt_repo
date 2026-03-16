# Publish Model Prompt Template

Use this template to generate publish layer models.

Publish models expose curated datasets for downstream consumers such as BI tools or analytics teams.

---

## Template

Create a publish model.

Pipeline Folder:

Publish Folder Name:

Model Name:

Input Mart Models:

Columns Required:

Filters if any:

Business Description:

Materialization: view

---

## Example Prompt

Create a publish model.

Pipeline Folder: policy_pipeline  
Publish Folder Name: reporting  
Model Name: customer_policy_summary

Input Mart Models:

fct__policy_transactions  
dim__customer  

Columns Required:

customer_id  
customer_name  
policy_id  
policy_start_date  
policy_end_date  
policy_status  

Filters:

policy_status = 'ACTIVE'

Business Description:

Dataset used by BI dashboards to track active customer policies.

Materialization: view