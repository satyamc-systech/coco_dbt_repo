# Full DBT Pipeline Generator

Generate the full pipeline for a table.

Pipeline order:

1 Source
2 Staging
3 Intermediate
4 Mart
5 Publish

Rules:

- Create source yml
- Create staging view
- Create intermediate transformation
- Create marts fact or dimension
- Create publish view