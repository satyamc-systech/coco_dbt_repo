# Post-Task Validation Checklist

After completing any dbt task, validate the output against the applicable layer checks below.

✓ = required, ✗ = not applicable

| Validation Check | Source | Staging | Intermediate | Mart | Publish | Snapshot |
|---|---|---|---|---|---|---|
| Correct file naming convention | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| SQL file exists | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| YAML file exists | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Model materialization defined | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Materialization = view | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ |
| Materialization = table | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ |
| Materialization = incremental | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| Source referenced using source() | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ |
| Source NOT referenced directly | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ |
| Models referenced using ref() | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ |
| Source used inside a CTE | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ |
| CTE name follows naming convention | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Final CTE exists (final__table) | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| All columns explicitly listed in CTE | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Final query uses select * from final_cte | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Model logic is modular | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Unique key defined in config | ✗ | ✗ | ✗ | ✓ | ✗ | ✓ |
| Surrogate key generated (optional) | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| Metadata columns added (created/updated fields) | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| Table description present in YAML | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Column descriptions present | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Column data types defined | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Generic tests present | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Unique test present | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Not null test present | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Composite key handled using dbt_utils | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Table column validation test present | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Snapshot strategy defined | ✗ | ✗ | ✗ | ✗ | ✗ | ✓ |
| Snapshot unique_key defined | ✗ | ✗ | ✗ | ✗ | ✗ | ✓ |
| Snapshot check_cols defined | ✗ | ✗ | ✗ | ✗ | ✗ | ✓ |
