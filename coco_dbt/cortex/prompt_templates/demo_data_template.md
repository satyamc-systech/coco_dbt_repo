# Demo Data Prompt Template

Use this template to generate Snowflake demo tables with realistic sample data.
Copy, paste, and modify the values below to match your requirements.

---

## Template

@(skill:dbt-router) Generate Snowflake demo tables.

Domain: Insurance

Database: CORTEX_ANALYST_DEMO
Schema: INSURANCE_RAW

Tables:
- CUSTOMERS (customer_id, first_name, last_name, email, phone, address, city, state, zip_code, date_of_birth, created_at)
- POLICIES (policy_id, policy_number, customer_id, policy_type, policy_status, effective_date, expiration_date, premium_amount, coverage_amount, created_at, updated_at)
- CLAIMS (claim_id, claim_number, policy_id, claim_status, claim_type, incident_date, report_date, claim_amount, approved_amount, deductible_applied, incident_description, adjuster_name, settlement_date, created_at, updated_at)
- PAYMENTS (payment_id, policy_id, payment_date, payment_amount, payment_method, payment_status, created_at)

Rows per table: 500

---

## How to Customize

- **Domain**: The business domain for realistic data generation (e.g., `E-Commerce`, `Healthcare`, `Finance`, `HR`)
- **Database / Schema**: Where to create the demo tables
- **Tables**: List table names with their columns in parentheses
- **Rows per table**: Number of sample rows to generate (e.g., `100`, `500`, `1000`)

---

## Additional Examples

### Example 2 — E-Commerce domain

@(skill:dbt-router) Generate Snowflake demo tables.

Domain: E-Commerce

Database: DEV_DB
Schema: ECOMMERCE_RAW

Tables:
- CUSTOMERS (customer_id, first_name, last_name, email, signup_date, country, created_at)
- PRODUCTS (product_id, product_name, category, price, cost, stock_quantity, created_at)
- ORDERS (order_id, customer_id, order_date, order_status, total_amount, shipping_address, created_at)
- ORDER_ITEMS (order_item_id, order_id, product_id, quantity, unit_price, discount_amount)

Rows per table: 1000

### Example 3 — HR domain

@(skill:dbt-router) Generate Snowflake demo tables.

Domain: HR

Database: DEV_DB
Schema: HR_RAW

Tables:
- EMPLOYEES (employee_id, first_name, last_name, email, department, job_title, hire_date, salary, manager_id, created_at)
- DEPARTMENTS (department_id, department_name, location, budget, head_count, created_at)
- TIMESHEETS (timesheet_id, employee_id, work_date, hours_worked, project_id, created_at)

Rows per table: 200