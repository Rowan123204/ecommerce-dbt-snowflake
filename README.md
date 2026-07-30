# Olist E-Commerce Data Pipeline

A production-style cloud data engineering pipeline built on **dbt + Snowflake**, transforming raw Brazilian e-commerce data into analytics-ready tables using a **Medallion Architecture** (Bronze → Silver → Gold).

---

## Architecture Overview

```
Raw CSV Files (8 datasets)
        │
        ▼
┌─────────────────┐
│  Snowflake RAW  │  ← Manual ingestion via Snowsight UI
│  (Bronze Layer) │     (Production: AWS S3 + Snowpipe)
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│  Staging (Silver)   │  ← dbt Views: clean, rename, type-cast
│  8 SQL models       │     1-to-1 mapping from raw sources
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Marts (Gold)       │  ← dbt Tables: join, aggregate, enrich
│  3 SQL models       │     Analytics-ready for BI tools
└─────────────────────┘
```

---

## Tech Stack

| Tool | Role |
|------|------|
| **Snowflake** | Cloud Data Warehouse (storage + compute) |
| **dbt** | Data transformation framework |
| **SQL** | Transformation logic |
| **Git + GitHub** | Version control |
| **Docker + Airflow** | Pipeline orchestration *(coming soon)* |
| **LocalStack (AWS S3)** | Cloud storage simulation *(coming soon)* |

---

## Project Structure

```
ecommerce_dbt_project/
└── olist_dbt/
    ├── models/
    │   ├── staging/               # Silver Layer — 8 views
    │   │   ├── sources.yml        # Source definitions pointing to RAW schema
    │   │   ├── stg_customers.sql
    │   │   ├── stg_bookings.sql
    │   │   ├── stg_listings.sql
    │   │   ├── stg_sellers.sql
    │   │   ├── stg_order_items.sql
    │   │   ├── stg_order_payments.sql
    │   │   ├── stg_order_reviews.sql
    │   │   └── stg_geolocation.sql
    │   └── marts/                 # Gold Layer — 3 tables
    │       ├── dim_customers.sql
    │       ├── fct_orders.sql
    │       └── agg_revenue_by_month.sql
    ├── dbt_project.yml            # Project config + materialization settings
    └── README.md
```

---

## Data Models

### Silver Layer — Staging (`ECOM_DB.STAGING`)

| Model | Source | Key Transformations |
|-------|--------|---------------------|
| `stg_customers` | `raw.customers` | Normalize city/state casing |
| `stg_bookings` | `raw.bookings` | Compute `actual_delivery_days` |
| `stg_listings` | `raw.listings` | Fix typos, compute `volume_cm3` |
| `stg_sellers` | `raw.sellers` | Normalize city/state casing |
| `stg_order_items` | `raw.order_items` | Compute `total_line_item_brl` |
| `stg_order_payments` | `raw.order_payments` | Add `is_credit_card` boolean flag |
| `stg_order_reviews` | `raw.order_reviews` | Add `sentiment` + `has_comment` flags |
| `stg_geolocation` | `raw.geolocation` | Deduplicate by zip code, average coords |

### Gold Layer — Marts (`ECOM_DB.STAGING_ANALYTICS`)

| Model | Type | Description |
|-------|------|-------------|
| `dim_customers` | Dimension | Customer profile enriched with order statistics |
| `fct_orders` | Fact | One row per order with financials, delivery, and review data |
| `agg_revenue_by_month` | Aggregation | Monthly KPIs: revenue, orders, delivery, cancellations |

---

## Dataset

**Brazilian E-Commerce Public Dataset by Olist** — 100K+ real orders from 2016–2018.

| Table | Rows | Description |
|-------|------|-------------|
| customers | 99,441 | Unique customer profiles |
| bookings (orders) | 99,441 | Order lifecycle data |
| order_items | 112,650 | Individual items per order |
| order_payments | 103,886 | Payment records |
| order_reviews | 100,000 | Customer reviews |
| listings (products) | 32,951 | Product catalog |
| sellers | 3,095 | Seller profiles |
| geolocation | 1,000,163 | Brazilian zip code coordinates |

---

## Quick Start

### Prerequisites
- Snowflake account (free trial works)
- Python 3.8+
- dbt-snowflake

```bash
# Install dbt
pip install dbt-snowflake

# Clone the repo
git clone https://github.com/Rowan123204/ecommerce-dbt-snowflake.git
cd ecommerce-dbt-snowflake/olist_dbt

# Configure your Snowflake connection
# Create ~/.dbt/profiles.yml with your credentials (see profiles.yml.example)

# Run all models
dbt run

# Run only Silver Layer
dbt run --select staging.*

# Run only Gold Layer
dbt run --select marts.*
```

---

## Key dbt Concepts Used

- **`{{ source() }}`** — Reference raw Snowflake tables defined in `sources.yml`
- **`{{ ref() }}`** — Reference other dbt models (enables DAG dependency resolution)
- **CTEs** — All models use Common Table Expressions for readable, step-by-step logic
- **Materialization** — Staging uses `view` (no storage cost); Marts use `table` (faster queries)
- **Custom schemas** — Gold Layer is isolated in its own `analytics` schema
