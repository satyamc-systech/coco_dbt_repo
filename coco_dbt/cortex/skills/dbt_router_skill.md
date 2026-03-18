# DBT Router

Route requests to the correct context files.

## Context Files
- **Standards**: `standards.md` — project structure, naming, formatting, testing rules
- **Patterns**: `patterns.md` — SQL templates (staging, incremental, YAML, surrogate key)
- **Tasks**: `tasks.md` — layer-specific rules + validation checklist

## Routing

| User Request | Load |
|---|---|
| Create source | tasks.md → Source section |
| Create staging | tasks.md → Staging (create source first if missing) |
| Create intermediate | tasks.md → Intermediate (create staging+source first if missing) |
| Create mart | tasks.md → Mart (create upstream layers first if missing) |
| Create publish | tasks.md → Publish (create mart first if missing) |
| Create snapshot | tasks.md → Snapshot section |
| Full pipeline | tasks.md → Full Pipeline (all layers in order) |
| Generate demo data | tasks.md → Demo Data section |
| Naming/structure question | standards.md |
| SQL pattern question | patterns.md |

## Dependency Chain
Source → Staging → Intermediate → Mart → Publish

Always create missing upstream layers before the requested layer.

## After Generation
Validate output against the checklist in tasks.md for the relevant layer.
