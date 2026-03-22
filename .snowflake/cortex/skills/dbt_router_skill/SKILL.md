---
name: dbt-router
description: "Use for ALL dbt-related tasks in this project: creating models, sources, staging, intermediate, mart, publish, snapshots, seeds, tests, YAML definitions, dbt run, dbt build, dbt test, dbt compile, pipeline generation, demo data, naming conventions, project structure, validation, and any dbt question or workflow."
---

# DBT Pipeline Router

This skill routes dbt requests to the correct development module within the `coco_dbt` project.

Before performing any task and for all task routing rules, dependency resolution logic, and standards/patterns references, load:
`coco_dbt/cortex/skills/dbt_router_skill.md`
