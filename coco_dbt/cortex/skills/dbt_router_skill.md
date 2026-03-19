---
name: dbt-router
description: Route dbt-related requests to the correct task module based on user intent, automatically resolving upstream dependencies across source, staging, intermediate, mart, and publish layers.
---

# DBT Pipeline Router

This skill routes dbt requests to the correct development module within the `coco_dbt` project.

Always determine the user's task and load the appropriate module.

Before performing any task, check if the user has given enough information to proceed. If not clear, always ask the user to provide input for the required fields.

## Task Routing Rules

### Create Source
If the user asks to:
- create a source
- bring a table into dbt

Load:
tasks/create_source_model.md

---

### Create Staging Model
If user asks for staging model:

1. Check if source model exists.
2. If source does not exist:
   - generate the source model first.

Then load:
tasks/create_staging_model.md

---

### Create Intermediate Model

Always reference staging models.

If staging model does not exist:

1. Generate staging
2. Generate source if needed

Load:
tasks/create_intermediate_model.md

---

### Create Mart Model

Mart models must reference staging or intermediate models.

If upstream models do not exist:

Create them automatically.

Load:
tasks/create_mart_model.md

---

### Create Publish Model

Publish models must reference marts.

Load:
tasks/create_publish_model.md

---

### Generate Full Pipeline

Load:
tasks/generate_full_pipeline.md

---

### Generate Demo Data

Load:
tasks/generate_demo_data.md

---

## Post-Task Validation

After completing any dbt task, load and run through: `standards/validation_checklist.md`

---

## Standards & Patterns

For naming conventions, load: `standards/naming_conventions.md`
For testing rules, load: `standards/testing_rules.md`
For project structure, load: `standards/dbt_project_structure.md`
For validation checklist, load: `standards/validation_checklist.md`
For SQL/YML patterns, load files from: `patterns/`