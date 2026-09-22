
# 💊 Pharmaceutical Supply Chain Optimization

**Turning demand-forecast and stock-level records into understock, overstock, and restocking-strategy insights — using Python, SQL, and Power BI.**

![Python](https://img.shields.io/badge/Python-3.10-3776AB?logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Wrangling-150458?logo=pandas&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?logo=jupyter&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📌 About This Project

I built this project to answer a question every pharmaceutical distributor eventually has to deal with: **is stock actually being planned to match demand, or is inventory just being restocked on a schedule and hoped for the best?**

I ran it as a full analytics workflow, not a single-tool exercise — starting in **Python** to clean and engineer features on 100,000 raw demand/stock records, moving into **MySQL** to answer structured business questions with SQL, and finishing in **Power BI** to package everything into an interactive dashboard a supply-chain stakeholder could actually use.

The goal wasn't just to report an understock/overstock split — it was to test an assumption most restocking programs are built on: that replenishing stock more often (weekly vs. monthly vs. quarterly) reduces shortage risk. The data says otherwise.

---

## 🎯 Business Problem

A pharmaceutical supply chain had no clear, data-driven view of how well its inventory planning matched real demand:

- 💊 **41.85% of Stock Keeping Unit records were understocked** — a real patient-safety exposure, not a rounding error
- 📦 The portfolio was simultaneously **net overstocked by ~78.1M units**, tying up capital while shortages still occurred elsewhere
- 🤔 The common assumption — that a tighter restocking cadence (Weekly) reduces stockout risk more than a looser one (Quarterly) — hadn't been tested against the actual data
- 🗺️ No visibility into which drugs or stock bands were driving the risk

**Objectives:**
1. Clean and structure 100,000 raw demand/stock records into an analysis-ready dataset
2. Quantify understock vs. overstock exposure across the drug portfolio
3. Test whether restocking strategy (Weekly / Monthly / Quarterly) actually reduces shortage risk
4. Identify which drugs and SKUs are most exposed to shortage
5. Package findings into a dashboard stakeholders can filter and act on directly

---

## 🧰 Tech Stack

| Layer | Tools |
|---|---|
| **Data Wrangling** | Python, Pandas |
| **Visualization (EDA)** | Matplotlib, Seaborn |
| **Database** | MySQL, SQLAlchemy |
| **Querying** | SQL (aggregations, `GROUP BY`, window functions, `CASE` bucketing) |
| **Business Intelligence** | Power BI (interactive filtering by drug & strategy) |
| **Environment** | Jupyter Notebook |

---

## 🗂️ Dataset

| File | What it holds |
|---|---|
| `Pharmaceutical_Supply_Chain_Optimization.xlsx` | Raw demand-forecast and stock-level export (100,000 records) |

Each record covers a drug (`Metformin`, `Lisinopril`, `Insulin`, `Atorvastatin`), its `Demand_Forecast`, `Optimal_Stock_Level`, and assigned `Restocking_Strategy` (Weekly / Monthly / Quarterly). Engineered fields added during cleaning: `Stock_Difference`, `Stock_Status`, and `Priority`.

---

## 🔄 Project Workflow

```
Raw Excel export (Pharmaceutical_Supply_Chain_Optimization.xlsx)
        │
        ▼
Python (Pandas) → clean, dedupe, engineer features
        │
        ▼
MySQL (SQLAlchemy) → load cleaned data into `supply_data` table
        │
        ▼
SQL → answer structured stock & risk questions
        │
        ▼
Power BI → interactive stock-health dashboard
        │
        ▼
Business Insights & Recommendations
```

---

## 🧹 Data Cleaning (Python)

The raw file needed cleaning and feature engineering before analysis. The notebook (`Pharmaceutical_Supply_Chain_Optimization.ipynb`) handles:

- Checking and removing null values (`df.dropna()`)
- Removing duplicate records (`df.drop_duplicates()`)
- Engineering new fields:
  - `Stock_Difference` = `Optimal_Stock_Level − Demand_Forecast`
  - `Stock_Status` = `"Understock"` if `Stock_Difference < 0`, else `"Overstock"`
  - `Priority` = `"High"` for understocked records, `"Low"` otherwise
- Loading the cleaned dataset into MySQL via SQLAlchemy

---

## 🧮 SQL Analysis

After loading the cleaned dataset into MySQL (`Pharmaceutical_Supply_Chain.supply_data`), I wrote 20 queries to answer real inventory-planning questions — not just practice `SELECT` statements:

- 📦 What's the total demand vs. total stock, and how far apart are they?
- ⚖️ What's the understock vs. overstock split, in count and percentage?
- 🚨 Which drugs have the most severe shortages, and which are most overstocked?
- 🔁 Does restocking strategy (Weekly / Monthly / Quarterly) actually change the understock rate?
- 🎯 How many SKUs land close to optimal stock (within ±10 units)?
- 🏆 Rank drugs by demand and by shortage severity using `DENSE_RANK()`
- 🪣 Bucket records into demand tiers and stock-difference bands for a portfolio-level view

Full queries live in [`Pharmaceutical_Supply_Chain.sql`](./Pharmaceutical_Supply_Chain.sql).

---

## 📈 Power BI Dashboard

The final deliverable: an interactive dashboard (`Pharmaceutical_Supply_Chain.pbix`) letting stakeholders filter by **Drug** and **Restocking Strategy**, with KPI cards and stock-status breakdowns.

**Headline KPIs:**

| Total Records | Understocked | Overstocked | Understock Rate | Total Demand | Total Stock |
|:---:|:---:|:---:|:---:|:---:|:---:|
| **99,995** | **41,850** | **58,145** | **41.85%** | **548.9M units** | **627.0M units** |

The single most useful insight the dashboard surfaces: **restocking cadence barely changes shortage risk** — Weekly, Monthly, and Quarterly strategies all sit within ~0.2 points of each other on understock rate, meaning the fix isn't "restock more often," it's forecasting accuracy.

<img width="484" height="274" alt="Pharmaceutical_Dashboard_Snapshot" src="https://github.com/user-attachments/assets/b7f03739-41d2-4935-a88e-20c46da23c94" />

---

## 💡 Key Insights

- 📦 Overall there's more stock than needed (627.0M units planned vs. 548.9M units of demand — a 78.1M unit surplus). But that "extra" stock isn't evenly spread — many individual drugs are still running short even though the total looks fine.
- ⚠️ **41.85% of SKU records are understocked** (41,850 of 99,995) — overstock and shortage coexist across different SKUs rather than cancelling out
- 🔁 **Restocking strategy has almost no effect on shortage risk**: Monthly 41.86%, Quarterly 41.96%, Weekly 41.74% — a near-identical understock rate regardless of cadence
- 💉 **Risk is spread evenly across drugs** — Insulin, Metformin, Atorvastatin, and Lisinopril all sit within a narrow band of total demand (136–138M units each) and average stock difference (+772 to +788 units)
- 🎯 **Only 0.17% of records** (173) land within ±10 units of optimal — precise stock-setting is rare across the portfolio
- 🚨 **41,850 records show demand exceeding planned stock** — these are the SKUs requiring immediate reorder attention

---

## ✅ Recommendations

1. Prioritize forecasting accuracy over restocking frequency — cadence doesn't move the understock rate, so effort is better spent improving how `Demand_Forecast` and `Optimal_Stock_Level` are calculated
2. Set a tiered safety-stock buffer for the ~41.85% of chronically understocked SKUs, especially Insulin given its clinical criticality
3. Investigate the overstock side (58.15% of records, ~196.8M excess units) for working-capital and expiry-risk reduction
4. Operationalize the SQL queries and Power BI dashboard as a recurring monitoring report rather than a one-off analysis
5. Extend the dataset with unit cost and shelf-life fields in future iterations to quantify the financial impact of over- and under-stocking, not just unit counts

---

## 📁 Repository Structure

```
├── Pharmaceutical_Supply_Chain_Optimization.ipynb   # Python data cleaning & feature engineering
├── Pharmaceutical_Supply_Chain.sql                  # SQL queries for stock & risk analysis
├── Pharmaceutical_Supply_Chain.pbix                 # Power BI dashboard file
├── Pharmaceutical_Supply_Chain_Optimization.xlsx    # Raw source data
└── README.md
```

---

## ▶️ How to Reproduce

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/pharmaceutical-supply-chain-optimization.git
cd pharmaceutical-supply-chain-optimization

# 2. Install dependencies
pip install pandas matplotlib seaborn sqlalchemy pymysql openpyxl

# 3. Run the notebook
jupyter notebook Pharmaceutical_Supply_Chain_Optimization.ipynb

# 4. Run the SQL queries against your MySQL instance
mysql -u <user> -p < Pharmaceutical_Supply_Chain.sql

# 5. Open the dashboard
# Open Pharmaceutical_Supply_Chain.pbix in Power BI Desktop
```

> ⚠️ Note: set your database credentials as environment variables rather than hardcoding them in the notebook before pushing to a public repo.

---

## 🧠 Skills Demonstrated

`Data Cleaning` `Feature Engineering` `Exploratory Data Analysis` `SQL (Aggregation, Window Functions & Bucketing)` `Database Integration (SQLAlchemy)` `Power BI Dashboarding` `Business Storytelling` `Root-Cause Analysis`

---

## 👤 About Me

I'm a data analyst who enjoys taking a raw operational dataset and turning it into something a supply-chain team can actually act on. This project reflects how I like to work: start with the business question, not the tool — and let the tool choice follow from what the problem actually needs.

📫 Feel free to connect or reach out if you'd like to talk through the approach, the SQL, or the dashboard design decisions.

⭐ If this project was useful or interesting to you, a star on the repo is always appreciated!
