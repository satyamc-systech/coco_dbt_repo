# DBT Prompt Templates

## Source
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create dbt source model.
Database: <database>
Schema: <schema>
Table: <table>
```

## Staging
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create staging model.
Database: <database>
Schema: <schema>
Table: <table>
Primary Key: <column>
```

## Intermediate
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create intermediate model.
Pipeline folder: <folder>
Input staging tables: <tables>
Transformations: joins | filters | aggregations
```

## Mart
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create mart model.
Pipeline folder: <folder>
Fact Tables: <tables> (grain, measures)
Dimensions: <tables>
```

## Publish
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create publish model.
Pipeline Folder: <folder>
Publish Folder: <folder>
Model Name: <name>
Input Mart Models: <models>
Columns Required: <columns>
Filters: <conditions>
Business Description: <desc>
Materialization: view
```

## Full Pipeline
```
Using coco_dbt/cortex/skills/dbt_rules.md as reference,
Create full DBT pipeline.
Database: <database>
Schema: <schema>
Table: <table>
Primary key: <column>
Columns: <columns>
Generate: source, staging, intermediate, mart, publish
```

## Demo Data
```
Generate Snowflake demo tables.
Domain: <domain>
Tables: <table_list>
DB & Schema: <db>.<schema>
Rows per table: 500
```
