---
name: dbt-router
description: Route DBT related requests to the correct skill module.
---

# DBT Pipeline Router

This skill routes DBT requests to the correct development module.

Always determine the user's task and load the appropriate module.

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