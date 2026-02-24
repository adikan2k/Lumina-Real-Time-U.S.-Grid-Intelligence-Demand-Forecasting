# ⚡ Lumina: U.S. Energy Grid Analytics & Renewable Economics Platform

**Scalable energy analytics platform processing 400K+ hourly demand records across 10 U.S. balancing authorities and 50 states, revealing that high-renewable states pay 30% less than the national average — disproving the "clean energy = expensive" myth.**

- **Live Dashboard:** [Looker Studio Link] (https://lookerstudio.google.com/reporting/158c880a-d220-406e-9b55-867c0b547d2e)

![Strategic Dashboard](Strategic%20Dashboard.png)

---

## 📊 Project Impact

- **Identified a 21% forecast failure** at Duke Energy Carolinas — 4× the national 5.55% MAPE
- **Tracked U.S. renewable share at 30.6%** — up from ~20% in 2019, proving the energy transition is accelerating
- **Disproved the renewables-cost myth** — WA, ID, OR achieve 70%+ renewable share with below-average electricity prices
- **Processed 400K+ records** across 4 federal datasets into a BigQuery star-schema warehouse with 8 analytical views

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        EIA Open Data API v2                         │
│  electricity/rto  │  operational-data  │  retail-sales  │  seds    │
└────────┬──────────┴────────┬───────────┴───────┬────────┴────┬─────┘
         │                   │                   │             │
         ▼                   ▼                   ▼             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Google Colab (Python ETL)                       │
│  02_ingest_grid   03_ingest_gen   04_ingest_retail   Backfill/     │
│  _operations      _fuel_mix       _and_emissions     Incremental   │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Google BigQuery (Star Schema)                     │
│                                                                     │
│  Dimensions:  dim_balancing_authority  dim_fuel_type                │
│               dim_geography           dim_date                      │
│                                                                     │
│  Facts:       fact_hourly_demand      fact_monthly_generation       │
│               fact_retail_sales       fact_carbon_emissions         │
│                                                                     │
│  Views:       v_grid_operations_hourly    v_executive_kpis         │
│               v_grid_operations_daily     v_generation_fuel_mix    │
│               v_forecast_accuracy_summary v_energy_transition_tracker│
│               v_retail_cost_analysis      v_renewable_price_scatter │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Looker Studio (4 Pages)                         │
│  Page 1: Executive    │  Page 2: Operational                       │
│  Page 3: Analytical   │  Page 4: Strategic                         │
└─────────────────────────────────────────────────────────────────────┘
```

**Tech Stack:** Python · SQL · Google BigQuery · Looker Studio · EIA API · Google Colab

---

## 🎯 Key Findings

### 1. National Forecast Accuracy is Strong — But Duke Energy is an Outlier
The national forecast MAPE is 5.55%, indicating reliable demand predictions. However, **Duke Energy Carolinas shows 21.15% MAPE** — a critical forecast failure requiring model retraining or data quality investigation.

### 2. U.S. Renewable Share Crossed 30% — Energy Transition is Accelerating
Renewable energy now accounts for **30.6% of total U.S. generation**, up from ~20% in 2019. **Wind + solar alone contribute 18.6%**, while coal has declined to **19.6%** — proving the transition is measurable and ongoing.

### 3. Pacific Northwest Leads at 70%+ Renewable Share
**Washington, Idaho, and Oregon** dominate with 70%+ renewable share driven by hydropower, while the Southeast remains below 20% due to fossil fuel dependence.

### 4. High Renewable Share Does NOT Correlate with Higher Prices
States with 70%+ renewable share (WA, ID, OR) pay **30% less than the national average** of 17.89¢/kWh. Expensive states like Hawaii are driven by island logistics, not renewables. This **disproves the industry assumption that clean energy raises costs**.

---

## 📸 Dashboard Preview

### Page 1: U.S. Grid Operations — Executive Overview
![Executive Dashboard](Executive%20Dashboard.png)

**Key Metrics:** 5.55% Forecast MAPE · 42,223 MW Avg Demand · 139,410 MW Peak Demand · 31% Renewable Share · 17.89¢/kWh Avg Price

**Insights:** 60-day demand trend shows stable operations. **West region leads renewable adoption at 45%** — driven by hydro (WA, OR) and solar (CA).

---

### Page 2: Grid Operations — Daily Forecast Performance
![Operational Dashboard](Operational%20Dashboard.png)

**Key Metrics:** 5.05% Daily MAPE · 39.9K MW Avg Demand · 64.0% Peak Utilization · 0 Hours Above 90%

**Insights:** Combo chart reveals daily demand patterns vs. forecast accuracy. **Duke Energy Carolinas flagged with 21.15% MAPE** — 4× national average, requiring immediate attention.

---

### Page 3: U.S. Energy Transition — Generation Mix Analysis
![Analytical Dashboard](Analytical%20Dashboard.png)

**Key Metrics:** 30.6% Renewable Share · 30.8M MWh Total Generation · 19.6% Coal Share · 18.6% Wind + Solar

**Insights:** Stacked area chart shows **natural gas remains dominant at 38.1%, but coal has declined to 17.1% since 2019**. Pacific Northwest achieves 70%+ renewables via hydropower dominance. Southeast remains fossil fuel dominant at <20% renewable share.

---

### Page 4: Renewable Energy Economics — Price vs. Share Analysis ⭐
![Strategic Dashboard](Strategic%20Dashboard.png)

**Key Metrics:** 10.81¢/kWh Avg Residential Price · $3.2M Total Revenue · 35.22% Avg Renewable Share · Hawaii (Highest Price State)

**Insights:** Scatter plot with quadrant analysis reveals **no correlation between renewable share and electricity prices**. Washington, Idaho, Oregon achieve 70%+ renewables with lowest prices in the U.S. **Key Finding:** High renewable share does NOT correlate with higher electricity prices. Hydropower-rich states (WA, OR, ID) achieve 70%+ renewables at below-average costs.

---

## 🚀 Reproducibility

**Prerequisites:** EIA API key (free) · Google Cloud project with BigQuery · Google Colab · Looker Studio

```bash
# 1. Get EIA API key
Visit: https://www.eia.gov/opendata/register.php

# 2. Set up Google Cloud
Create project at: https://console.cloud.google.com
Enable BigQuery API

# 3. Configure credentials
Edit config.py:
  - EIA_API_KEY = "your_key_here"
  - GCP_PROJECT_ID = "your_project_id"

# 4. Run notebooks in order (Google Colab)
01_setup_bigquery_schema.ipynb       # Creates star schema (4 dims + 4 facts)
02_ingest_grid_operations.ipynb      # Loads 400K hourly demand records
03_ingest_generation_fuel_mix.ipynb  # Loads 60K generation records
04_ingest_retail_and_emissions.ipynb # Loads 15K retail + 3K emissions
05_create_analytical_views.ipynb     # Creates 8 derived views

# 5. Build Looker Studio dashboard
Follow: LOOKER_STUDIO_GUIDE.md
Connect to BigQuery → Select views → Build 4 pages
```

**Incremental Loading:** After initial backfill, notebooks check BigQuery high-watermark and load only new records.

---

## 📁 Project Structure

```
Lumina-Forecasting/
├── notebooks/                       # Google Colab ETL pipeline (5 notebooks)
│   ├── 01_setup_bigquery_schema.ipynb
│   ├── 02_ingest_grid_operations.ipynb
│   ├── 03_ingest_generation_fuel_mix.ipynb
│   ├── 04_ingest_retail_and_emissions.ipynb
│   └── 05_create_analytical_views.ipynb
├── config.py                        # EIA API key + GCP project ID
├── LOOKER_STUDIO_GUIDE.md          # Dashboard build instructions
├── LUMINA_PROJECT_DOCUMENT.md      # Technical deep-dive + interview prep
├── Executive Dashboard.png          # Page 1 screenshot
├── Operational Dashboard.png        # Page 2 screenshot
├── Analytical Dashboard.png         # Page 3 screenshot
├── Strategic Dashboard.png          # Page 4 screenshot
└── README.md                        # This file
```

---

## 📊 Data Sources

| Dataset | API Endpoint | Grain | Records | Date Range |
|---------|-------------|-------|---------|------------|
| **Grid Operations (EIA-930)** | `electricity/rto/region-data` | BA × hour | ~400K | Dec 2025 – Feb 2026 |
| **Generation by Fuel** | `electricity/electric-power-operational-data` | State × fuel × month | ~60K | 2019 – 2025 |
| **Retail Sales** | `electricity/retail-sales` | State × sector × month | ~15K | 2019 – 2025 |
| **CO2 Emissions (SEDS)** | `seds/co2-emissions` | State × source × year | ~3K | 2019 – 2022 |

**All data sourced from the U.S. Energy Information Administration (EIA) Open Data API v2.**


## 👥 Contributors

- **Aditya Kanbargi**

