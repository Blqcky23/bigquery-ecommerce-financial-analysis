# E-Commerce Financial Performance & Data Audit (BigQuery & Python)

## 📌 Project Overview
This project demonstrates an end-to-end data analysis and financial reconciliation workflow using **Google Cloud Platform (BigQuery)** and **Python**. Using the public `thelook_ecommerce` dataset, the analysis evaluates product category profitability, tracks cumulative revenue trends, and enforces automated financial data quality checks prior to reporting.

## 🛠️ Tech Stack
* **Cloud Data Warehouse:** Google BigQuery (`bigquery-public-data.thelook_ecommerce`)
* **Query Language:** Standard SQL (CTEs, `JOIN`, `GROUP BY`, `SAFE_DIVIDE`, Window Functions: `SUM() OVER`, `LAG()`)
* **Programming & Validation:** Python (`pandas`, `google-cloud-bigquery`, Google Colab)
* **AI Workflow:** AI coding assistants used for query structuring and optimization, followed by manual code review and strict numerical reconciliation.

## 📂 Repository Structure
* `queries.sql` – Production-style SQL queries covering category profitability, month-over-month cumulative revenue trends, and row-level data anomaly audits.
* `financial_analysis.ipynb` – Google Colab notebook connecting to BigQuery via API to extract aggregated metrics and run automated financial integrity assertions.

## 🔍 Key Analytical & Engineering Steps
1. **Financial & Margin Analysis (`queries.sql`):** Joined transactional `order_items` with `products` metadata (filtered to `Complete` orders) to compute gross profit and profit margins across product categories.
2. **Time-Series & Window Functions (`queries.sql`):** Used Common Table Expressions (CTEs) alongside `SUM() OVER` and `LAG()` window functions to monitor running revenue totals and month-over-month shifts.
3. **Automated Financial Reconciliation (`financial_analysis.ipynb`):**
   * Verified the absence of `NULL`/`NaN` values and non-positive revenue figures.
   * Cross-checked aggregated category revenue against raw source table totals (`abs(raw_total - aggregated_total) < 0.01`) to ensure `JOIN` operations did not introduce duplicate records or financial discrepancies.

## 🚀 How to Run
1. Open `financial_analysis.ipynb` in **Google Colab**.
2. Authenticate with a Google Cloud account (BigQuery Sandbox is sufficient).
3. Replace `"PASTE_YOUR_PROJECT_ID_HERE"` with your active GCP Project ID and run all cells.
