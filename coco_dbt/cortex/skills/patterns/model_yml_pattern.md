# DBT Model YAML Pattern

Each model must have a corresponding yaml file.

The yaml file must include:

- model description
- column descriptions
- generic tests

---

## Standard YAML Structure

version: 2

models:
  - name: <model_name>
    description: description of the model

    columns:

      - name: column_1
        description: description of the column
        tests:
          - not_null

      - name: column_2
        description: description of the column

      - name: column_3
        description: description of the column