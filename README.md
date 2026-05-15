# Fleet-Profitability-Analytics
# 🚚 End-to-End Logistics Fleet Profitability Engine

![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)
![Pandas](https://img.shields.io/badge/Pandas-Data_Engineering-green.svg)
![SQL](https://img.shields.io/badge/SQL-DuckDB-orange.svg)
![Status](https://img.shields.io/badge/Status-Completed-success.svg)

## 📌 Executive Summary
In the logistics sector, fluctuating fuel prices and asset underutilization severely compress gross margins. This project serves as an end-to-end data engineering and analytics pipeline designed to ingest raw telematics data, allocate maintenance/fuel overhead, and programmatically identify high-risk drivers and unprofitable freight corridors.

**Business Impact:**
* Established a baseline cost-per-mile (CPM) metric incorporating real-time fuel and fleet downtime costs.
* Identified bottom-quartile drivers contributing to excessive idle-time fuel burn.
* Built a scenario-modeling dataset ready for financial pricing simulations across top freight lanes.

---

## 🏗️ Architecture & Tech Stack

### Phase 1: Data Engineering & ETL (Python / Pandas)
* **Ingestion:** Processed over 300,000 synthetic IoT and transaction records across 9 distinct entities (`trips`, `loads`, `fuel_purchases`, `maintenance_records`, etc.).
* **Feature Engineering:** Calculated driver tenure, aggregated maintenance overhead per asset, and mapped geospatial US regions.
* **Data Quality Guardrails:** Built programmatic anomaly detection to flag impossible sensor readings (e.g., MPG < 4.0).
* **Automated Logging:** Generated continuous ETL execution logs verifying Primary/Foreign Key referential integrity.

### Phase 2: Data Warehousing & Analytics (SQL / DuckDB)
* **In-Memory Warehousing:** Utilized embedded `DuckDB` to execute high-performance column-oriented SQL directly against the cleaned Python dataframes, eliminating the need for local database server installation.
* **Advanced Querying:** * Authored **Window Functions** (`DENSE_RANK`, `NTILE`) to rank lane profitability and tier customer accounts based on RFM logic.
  * Used **Common Table Expressions (CTEs)** and `CASE` statements to build a Driver Efficiency Scorecard.
  * Deployed **Correlated Subqueries** to benchmark individual fuel purchases against state-wide fleet averages.
  * Executed **Pareto Analysis (80/20)** using cumulative rolling window frames (`ROWS BETWEEN UNBOUNDED PRECEDING`) to isolate foundational enterprise accounts.

---

## 📂 Repository Navigation
* [`/notebooks/Phase_1_ETL_Pipeline.ipynb`](notebooks/Phase_1_ETL_Pipeline.ipynb) - The core Python data cleansing and transformation pipeline.
* [`/sql/`](sql/) - Contains all advanced SQL analytical queries.
* [`/data/3_final_export/excel_pricing_model_input.csv`](data/3_final_export/) - The final aggregated output dataset prepared for downstream BI reporting.
* [`/logs/etl_execution_audit.txt`](logs/etl_execution_audit.txt) - Automated data quality validation log.

---

## 🚀 How to Run Locally
1. Clone this repository: `git clone https://github.com/YourUsername/Logistics-Fleet-Analytics.git`
2. Open the Jupyter Notebook in Google Colab or your local Jupyter environment.
3. Run the notebook sequentially to trigger the Pandas ETL and the embedded DuckDB SQL engine.
