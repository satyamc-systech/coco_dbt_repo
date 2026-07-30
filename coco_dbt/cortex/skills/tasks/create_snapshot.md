# Snapshot Creation Skill

Create dbt snapshot YAML files using the latest dbt 2.0 YAML-based configuration.

## Upstream Dependency

Always reference source models using `source()` or staging models using `ref()`.

Never reference raw tables directly.

---

## Location

snapshots/<schema_name>/

---

## Naming

snap__<schema_name>__<table_name>.yml

---

## Strategy Options

### Timestamp Strategy (preferred)

Use when the source table has a reliable `updated_at` column.

### Check Strategy

Use when no reliable timestamp column exists. Compares column values to detect changes.

---

## YAML Configuration (dbt 2.0 syntax)

Snapshots are defined entirely in YAML. A separate SQL file is only needed for custom queries.

### Timestamp Strategy Example

```yaml
snapshots:
  - name: snap__<schema_name>__<table_name>
    relation: source('<database>__<schema>', '<table>')
    config:
      schema: snapshots
      strategy: timestamp
      unique_key: <primary_key>
      updated_at: <timestamp_column>
      invalidate_hard_deletes: true
```

### Check Strategy Example

```yaml
snapshots:
  - name: snap__<schema_name>__<table_name>
    relation: source('<database>__<schema>', '<table>')
    config:
      schema: snapshots
      strategy: check
      unique_key: <primary_key>
      check_cols:
        - column_1
        - column_2
      invalidate_hard_deletes: true
```

### Check All Columns Example

```yaml
snapshots:
  - name: snap__<schema_name>__<table_name>
    relation: source('<database>__<schema>', '<table>')
    config:
      schema: snapshots
      strategy: check
      unique_key: <primary_key>
      check_cols: all
      invalidate_hard_deletes: true
```

---

## Configuration Options

| Option | Required | Description |
|--------|----------|-------------|
| strategy | Yes | `timestamp` or `check` |
| unique_key | Yes | Column(s) that uniquely identify a row |
| updated_at | If timestamp | Column indicating last update time |
| check_cols | If check | List of columns to compare, or `all` |
| schema | No | Target schema (defaults to `snapshots`) |
| invalidate_hard_deletes | No | Set `true` to track deleted rows |
| snapshot_meta_column_names | No | Customize SCD meta columns |

---

## Meta Column Customization (optional)

```yaml
snapshots:
  - name: snap__<schema_name>__<table_name>
    relation: source('<database>__<schema>', '<table>')
    config:
      schema: snapshots
      strategy: timestamp
      unique_key: <primary_key>
      updated_at: <timestamp_column>
      snapshot_meta_column_names:
        dbt_valid_from: valid_from
        dbt_valid_to: valid_to
        dbt_scd_id: scd_id
        dbt_updated_at: meta_updated_at
```

---

## Required Tests

- unique on `dbt_scd_id`
- not_null on `dbt_scd_id`
- not_null on `dbt_valid_from`

---

## YAML Definition File

For every snapshot created, also generate the YAML properties file if columns need documentation.

Location: `snapshots/<schema_name>/definitions/`

Naming: `snap__<schema_name>__<table_name>.yml`
