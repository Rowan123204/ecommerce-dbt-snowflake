# Tests

This directory contains dbt generic and singular tests.

## Planned Tests

`yaml
# Example: add to sources.yml or schema.yml
models:
  - name: fct_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: order_status
        tests:
          - accepted_values:
              values: ['delivered', 'shipped', 'cancelled', 'processing']
`

Run tests with: dbt test
"@,
    [System.Text.Encoding]::UTF8
)

[System.IO.File]::WriteAllText(
    "C:\Users\DELL\Desktop\ecommerce_dbt_project\olist_dbt\analyses\README.md",
    @"
# Analyses

Ad-hoc SQL queries for exploratory analysis.
These are NOT materialized in the warehouse - they are for reference only.

Example use: quick data profiling queries, one-off business questions.