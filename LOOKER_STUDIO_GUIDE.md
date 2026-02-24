# Lumina Forecasting Hub — Dashboard Blueprint

> A portfolio-grade, four-page Looker Studio dashboard built on BigQuery.
> Each page maps to a recognized dashboard type, tells a clear story,
> and follows industry-standard visualization best practices.

---

## Dashboard Architecture

This project implements **three dashboard archetypes** across four pages.
Each page serves a distinct audience, answers a specific question, and
feeds into the next — creating a narrative that flows from *pulse* to *policy*.

| Page | Type | Audience | Core Question |
|------|------|----------|---------------|
| 1 | **Executive** | Leadership / Recruiters | "What is the state of US energy right now?" |
| 2 | **Operational** | Grid operators / Analysts | "Where are the problems and how severe are they?" |
| 3 | **Analytical** | Energy strategists | "How is the energy transition progressing?" |
| 4 | **Strategic** | Policy / Portfolio managers | "Does more renewable energy mean higher electricity prices?" |

> **Why not all four types?**
> A *tactical* dashboard (real-time, sub-minute updates) doesn't apply here —
> the EIA API provides hourly snapshots at best. The four pages above cover
> every perspective this dataset can credibly support.

### Narrative Arc

```
Page 1  "The grid is [healthy / stressed]. Renewables are at X%."
  |       Viewer wants details...
  v
Page 2  "Here is where the stress lives — [BA X] has forecast error
         and [BA Y] is near capacity."
  |       Viewer asks about the bigger picture...
  v
Page 3  "Coal is declining. Gas and renewables are rising.
         [State] leads the transition."
  |       Viewer asks the strategic question...
  v
Page 4  "More renewables don't always mean higher prices.
         These states prove it."
```

Every page answers three questions:
**What is happening? → Why? → What should we do about it?**

---

## Design Principles Applied

| # | Principle | How It Shows Up |
|---|-----------|-----------------|
| 1 | **5-Second Rule** | Each page has one headline insight visible without scrolling |
| 2 | **Right chart for the job** | Time series = trends, bars = rankings, scatter = correlation, scorecards = KPIs |
| 3 | **Tell a story** | Pages flow Pulse → Problems → Patterns → Policy |
| 4 | **General → Specific (top to bottom)** | Scorecards at top, hero chart in middle, drill-down detail at bottom |
| 5 | **Logical cross-page flow** | Each page builds on the previous one |
| 6 | **What / Why / What to do** | Scorecards = what, hero chart = why, detail charts = what to do |
| 7 | **Top-left = most critical** | The #1 KPI on each page is the top-left scorecard and the largest |
| 8 | **5-6 visuals max per page** | Scorecards + 2-3 charts. Whitespace is a feature |
| 9 | **Conditional color (RAG)** | Green = on track, Yellow = watch, Red = act now |
| 10 | **Size = importance** | Hero charts get 50% of page. First scorecard is wider |
| 11 | **Round numbers** | MW: 0 decimals. Percentages: 1 decimal. Prices: 1 decimal |

---

## Setup

### 1. Create Report

1. Go to **https://lookerstudio.google.com**
2. Sign in with the **same Google account** as BigQuery
3. Click **Blank Report**

### 2. Connect All 9 Data Sources

**Resource → Manage added data sources → Add a data source → BigQuery → Your Project → lumina**

| # | View | Powers |
|---|------|--------|
| 1 | `v_executive_kpis` | Page 1 scorecards |
| 2 | `v_grid_operations_daily` | Pages 1 & 2: trends, utilization |
| 3 | `v_grid_operations_hourly` | Optional: heatmap |
| 4 | `v_forecast_accuracy_summary` | Page 2: accuracy table |
| 5 | `v_generation_fuel_mix` | Page 3: fuel donut |
| 6 | `v_energy_transition_tracker` | Page 3: stacked area, state bars |
| 7 | `v_retail_cost_analysis` | Page 4: price trends |
| 8 | `v_renewable_price_scatter` | Page 4: scatter plot |

### 3. Report Settings

| Setting | Value |
|---------|-------|
| Canvas size | **1200 x 900** |
| Theme | "Constellation" or "Simple Dark" |
| Background | `#0f0f1a` (near-black) |
| Card / panel fill | `#1a1a2e` (dark navy) |
| Text | `#ffffff` (white) |
| Primary accent | `#00d4ff` (electric blue) |
| Success | `#00ff88` (green) |
| Alert | `#ff4444` (red) |

### 4. Create Four Pages

1. **Executive Overview**
2. **Grid Operations**
3. **Energy Transition**
4. **Cost & Market Intelligence**

---

## Layout Grid Reference

All pages use the same spatial grid. **Canvas: 1200 x 900.**

```
Margins:     20 px on all four sides
Usable area: x = 20 → 1180   (width = 1160)
             y = 15 → 880    (height = 865)
Element gap: 15 px
```

Standard row positions (consistent across all pages):

| Row | Purpose | y-start | Height | Notes |
|-----|---------|---------|--------|-------|
| 1 | Header / Filters | 15 | 45 | Dark bar or filter controls |
| 2 | Scorecards | 75 | 80 | KPI cards in a row |
| 3 | Hero chart | 170 | 350-400 | Full width, 50% of remaining space |
| 4 | Supporting charts | 545-580 | 300-335 | Two charts side by side |

---

## Page 1 — Executive Dashboard

| | |
|---|---|
| **Type** | Executive |
| **Story** | "Here is the pulse of US energy in 10 seconds." |
| **What / Why / Do** | Scorecards show status → Trend shows trajectory → Bars show regional breakdown |

### Wireframe

```
┌─────────────────────────────────────────────────────────────────────┐
│  "Lumina Forecasting Hub"                [Data thru ___] [BA ▼]    │  y=15, h=45
├──────────┬────────┬─────────┬──────────┬────────────────────────────┤
│ MAPE ★   │Avg Dem │Peak Dem │Renew Shr │ Avg Price                  │  y=75, h=80
│ (wider)  │        │         │          │                            │
├──────────┴────────┴─────────┴──────────┴────────────────────────────┤
│                                                                     │
│           Daily Demand — Avg vs Peak  (Time Series)                 │  y=170, h=355
│                                                                     │
│                                                                     │
├─────────────────────────────┬───────────────────────────────────────┤
│   Demand by Region          │   Renewable Share by Region           │  y=540, h=340
│   (Horizontal Bar)          │   (Horizontal Bar)                    │
│                             │                                       │
└─────────────────────────────┴───────────────────────────────────────┘
```

### Exact Element Positions

#### Row 1 — Header Bar

| Element | Type | x | y | w | h | Details |
|---------|------|---|---|---|---|---------|
| Title text | Text | 20 | 15 | 650 | 45 | "Lumina Forecasting Hub" — white, bold, 22 pt. Subtitle below in gray 11 pt: "Real-time analytics across 10 US balancing authorities" |
| Data freshness | Scorecard | 740 | 20 | 180 | 35 | Source: `v_executive_kpis`, metric: `data_end`, agg: MAX. Label: "Data through". Font: 10 pt |
| BA filter | Drop-down | 940 | 20 | 240 | 35 | Source: `v_grid_operations_daily`, field: `ba_code` |

#### Row 2 — KPI Scorecards

All cards: **y = 75, h = 80.** Card backgrounds: `#1a1a2e`. Label: 10 pt gray. Value: 28 pt bold white.

| Card | x | w | Label | Source | Metric | Agg | Format | Conditional Color |
|------|---|---|-------|--------|--------|-----|--------|-------------------|
| 1 ★ | 20 | 270 | Forecast MAPE | `v_executive_kpis` | `forecast_mape_pct` | AVG | `#.#%` | Green < 5 / Yellow 5-10 / Red > 10 |
| 2 | 305 | 210 | Avg Demand | `v_executive_kpis` | `current_avg_demand_mw` | AVG | `#,##0 MW` | — |
| 3 | 530 | 210 | Peak Demand | `v_executive_kpis` | `peak_demand_mw` | AVG | `#,##0 MW` | — |
| 4 | 755 | 210 | Renewable Share | `v_executive_kpis` | `national_renewable_share_pct` | AVG | `#.#%` | Green > 25 / Yellow 15-25 / Red < 15 |
| 5 | 980 | 200 | Avg Price | `v_executive_kpis` | `national_avg_price_cents` | AVG | `#.# ¢` | Green < 14 / Yellow 14-18 / Red > 18 |

> Card 1 is **50 px wider** than the others — the eye hits it first.

#### Row 3 — Hero Chart: Daily Demand Trend

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 170, w = 1160, h = 355** |
| Chart type | Time Series |
| Source | `v_grid_operations_daily` |
| Date | `date_utc` |
| Metric 1 | `avg_demand_mw` (AVG) — solid line, `#00d4ff` |
| Metric 2 | `peak_demand_mw` (MAX) — dashed line, `#66e0ff` |
| Style | Smooth, no data points, subtle gridlines |
| Title | "Daily Demand — Average vs Peak" (top-left of chart, 14 pt) |

#### Row 4 — Two Supporting Bar Charts

**Left — Demand by Region:**

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 540, w = 570, h = 340** |
| Chart type | Horizontal Bar |
| Source | `v_grid_operations_daily` |
| Dimension | `region` |
| Metric | `avg_demand_mw` → AVG |
| Sort | Descending |
| Color | `#00d4ff` (single color) |
| Title | "Demand by Region" |

**Right — Renewable Share by Region:**

| Setting | Value |
|---------|-------|
| **Position** | **x = 605, y = 540, w = 575, h = 340** |
| Chart type | Horizontal Bar |
| Source | `v_energy_transition_tracker` |
| Dimension | `census_region` |
| Metric | `renewable_share_pct` → AVG |
| Sort | Descending |
| Color | `#00ff88` green gradient |
| Title | "Renewable Share by Region" |

---

## Page 2 — Operational Dashboard

| | |
|---|---|
| **Type** | Operational |
| **Story** | "Where is the grid stressed and how accurate are our forecasts?" |
| **What / Why / Do** | Scorecards show alerts → Dual-axis shows correlation → Table + bar identify problem BAs |

### Wireframe

```
┌──────────────────┬──────────────────┬──────────────────┬───────────┐
│ [Date Range    ▼]│ [BA Selector   ▼]│ [Region       ▼] │           │  y=15, h=45
├────────┬─────────┼─────────┬────────┼──────────────────┴───────────┤
│MAPE ★  │Avg Dem  │Peak Util│Hrs>90% │                              │  y=75, h=80
│(wider) │         │         │        │                              │
├────────┴─────────┴─────────┴────────┴──────────────────────────────┤
│                                                                     │
│      Demand & Forecast Error Over Time  (Dual-Axis Time Series)     │  y=170, h=345
│      Left: demand lines    Right: MAPE bars                        │
│                                                                     │
├──────────────────────────────────┬──────────────────────────────────┤
│  Forecast Accuracy by BA         │  Peak Utilization by BA          │  y=530, h=350
│  (Table with heatmap)            │  (Horizontal Bar + 90% ref line)│
│                                  │                                  │
└──────────────────────────────────┴──────────────────────────────────┘
```

### Exact Element Positions

#### Row 1 — Filters

All filters: **y = 20, h = 35.**

| Element | Type | x | w | Field | Source |
|---------|------|---|---|-------|--------|
| Date range | Date range picker | 20 | 280 | — | — |
| BA selector | Drop-down | 315 | 280 | `ba_code` | `v_grid_operations_daily` |
| Region selector | Drop-down | 610 | 280 | `region` | `v_grid_operations_daily` |

#### Row 2 — KPI Scorecards

All cards: **y = 75, h = 80.**

| Card | x | w | Label | Metric | Agg | Source | Conditional Color |
|------|---|---|-------|--------|-----|--------|-------------------|
| 1 ★ | 20 | 330 | Daily MAPE | `mape_daily` | AVG | `v_grid_operations_daily` | Green < 5 / Yellow 5-10 / Red > 10 |
| 2 | 365 | 260 | Avg Demand | `avg_demand_mw` | AVG | `v_grid_operations_daily` | — |
| 3 | 640 | 260 | Peak Utilization | `peak_utilization_pct` | MAX | `v_grid_operations_daily` | Green < 80 / Yellow 80-90 / Red > 90 |
| 4 | 915 | 265 | Hours > 90% | `hours_above_90pct` | SUM | `v_grid_operations_daily` | Green = 0 / Yellow 1-5 / Red > 5 |

#### Row 3 — Hero Chart: Demand + Forecast Error (Dual Axis)

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 170, w = 1160, h = 345** |
| Chart type | Time Series, dual axis |
| Source | `v_grid_operations_daily` |
| Date | `date_utc` |
| Left axis | `avg_demand_mw` (line, `#00d4ff`), `peak_demand_mw` (line, `#66e0ff`) |
| Right axis | `mape_daily` (bars, `#ff4444` at 40% opacity) |
| Title | "Demand & Forecast Error Over Time" |

#### Row 4 — Two Detail Charts

**Left — Forecast Accuracy Table:**

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 530, w = 600, h = 350** |
| Chart type | Table with heatmap |
| Source | `v_forecast_accuracy_summary` |
| Dimensions | `ba_name`, `month` |
| Metrics | `mape` (AVG), `rmse_mw` (AVG), `mean_bias_mw` (AVG) |
| Heatmap | On `mape`: green (low) → red (high) |
| Title | "Forecast Accuracy by Balancing Authority" |

**Right — Capacity Utilization Bar:**

| Setting | Value |
|---------|-------|
| **Position** | **x = 635, y = 530, w = 545, h = 350** |
| Chart type | Horizontal Bar |
| Source | `v_grid_operations_daily` |
| Dimension | `ba_code` |
| Metric | `peak_utilization_pct` → AVG |
| Sort | Descending |
| Reference line | 90% (red dashed) |
| Bar color | Conditional: green < 80, yellow 80-90, red > 90 |
| Title | "Peak Utilization by BA" |

---

## Page 3 — Analytical Dashboard

| | |
|---|---|
| **Type** | Analytical |
| **Story** | "America's energy mix is transforming — here is the evidence." |
| **What / Why / Do** | Scorecards show current shares → Stacked area shows the structural shift → Donut + bar show who leads |

### Wireframe

```
┌──────────────────┬──────────────────┬──────────────────┬───────────┐
│ [Date Range    ▼]│ [State        ▼] │ [Region       ▼] │           │  y=15, h=45
├───────────────┬──┴──────────┬───────┴──────────────────┴───────────┤
│ Renew Share ★ │ Total Gen   │ Coal Share                           │  y=75, h=80
│ (widest)      │             │                                      │
├───────────────┴─────────────┴──────────────────────────────────────┤
│                                                                     │
│       National Generation by Fuel Source  (Stacked Area)            │  y=170, h=390
│       coal (bottom, gray) → gas → nuclear → wind → solar (top)     │
│                                                                     │
│                                                                     │
├───────────────────────────┬─────────────────────────────────────────┤
│  Generation by Fuel Type  │  Top 15 States by Renewable Share       │  y=575, h=305
│  (Donut Chart)            │  (Horizontal Bar, green gradient)       │
│                           │                                         │
└───────────────────────────┴─────────────────────────────────────────┘
```

### Exact Element Positions

#### Row 1 — Filters

All filters: **y = 20, h = 35.**

| Element | Type | x | w | Field | Source |
|---------|------|---|---|-------|--------|
| Date range | Date range picker | 20 | 280 | — | — |
| State | Drop-down | 315 | 280 | `state_code` | `v_energy_transition_tracker` |
| Region | Drop-down | 610 | 280 | `census_region` | `v_energy_transition_tracker` |

#### Row 2 — KPI Scorecards

All cards: **y = 75, h = 80.**

| Card | x | w | Label | Metric | Agg | Source | Conditional Color |
|------|---|---|-------|--------|-----|--------|-------------------|
| 1 ★ | 20 | 420 | Renewable Share | `renewable_share_pct` | AVG | `v_energy_transition_tracker` | Green > 25 / Yellow 15-25 / Red < 15 |
| 2 | 455 | 350 | Total Generation | `total_gen_mwh` | SUM | `v_energy_transition_tracker` | — (format: `#,##0 MWh`) |
| 3 | 820 | 360 | Coal Share | `coal_share_pct` | AVG | `v_energy_transition_tracker` | Green < 20 / Yellow 20-40 / Red > 40 (inverted!) |

> Renewable Share is the widest card and sits top-left — it is **the** headline metric.
> Coal Share uses **inverted** RAG colors: low coal = green, high coal = red.

#### Row 3 — Hero Chart: Stacked Area (give it maximum height)

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 170, w = 1160, h = 390** |
| Chart type | Stacked Area |
| Source | `v_energy_transition_tracker` |
| Date | `period_month` |
| Metric 1 (bottom) | `coal_gen_mwh` (SUM) — `#555555` dark gray |
| Metric 2 | `gas_gen_mwh` (SUM) — `#ff9800` orange |
| Metric 3 | `nuclear_gen_mwh` (SUM) — `#9c27b0` purple |
| Metric 4 | `wind_gen_mwh` (SUM) — `#00bcd4` teal |
| Metric 5 (top) | `solar_gen_mwh` (SUM) — `#ffc107` gold |
| Style | Stacked, smooth, no data points |
| Title | "National Generation by Fuel Source" |

> **This is the chart hiring managers remember.** Coal shrinks at the bottom,
> renewables grow at the top — the energy transition in one visual.

#### Row 4 — Two Supporting Charts

**Left — Fuel Breakdown (donut):**

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 575, w = 500, h = 305** |
| Chart type | Donut |
| Source | `v_generation_fuel_mix` |
| Dimension | `fuel_label` |
| Metric | `generation_mwh` (SUM) |
| Sort | Descending, top 8, group rest as "Other" |
| Title | "Generation by Fuel Type" |

**Right — Top Renewable States (bar):**

| Setting | Value |
|---------|-------|
| **Position** | **x = 535, y = 575, w = 645, h = 305** |
| Chart type | Horizontal Bar |
| Source | `v_energy_transition_tracker` |
| Dimension | `state_name` |
| Metric | `renewable_share_pct` → AVG |
| Sort | Descending, Top 15 |
| Color | `#00ff88` green gradient |
| Title | "Top 15 States by Renewable Share" |

---

## Page 4 — Strategic Dashboard

| | |
|---|---|
| **Type** | Strategic |
| **Story** | "More renewables don't always mean higher prices — here is the proof." |
| **What / Why / Do** | Scorecards show cost context → Trend shows price evolution → Scatter reveals the relationship between renewables and price |

### Wireframe

```
┌──────────────────┬──────────────────┬──────────────────┬───────────┐
│ [Date Range    ▼]│ [State        ▼] │ [Sector       ▼] │           │  y=15, h=45
├───────────────┬──┴──────────┬───────┴──┬───────────────┴───────────┤
│ Avg Price ★   │ Revenue     │ Price    │ Highest-Price             │  y=75, h=80
│ (widest)      │             │ YoY Chg  │ State                     │
├───────────────┴─────────────┴──────────┴───────────────────────────┤
│                                                                     │
│     Electricity Price by Sector Over Time  (Time Series)            │  y=170, h=280
│     One line per sector (Residential, Commercial, Industrial)       │
│                                                                     │
├──────────────────────────────────┬──────────────────────────────────┤
│                                  │                                  │
│  Renewable Share vs. Elec Price  │  Top 10 Most Expensive States    │  y=465, h=415
│  by State  (Scatter Plot)        │  (Horizontal Bar)                │
│  X = renewable_share_pct         │                                  │
│  Y = avg_residential_price       │                                  │
│  Bubble size = total_gen_mwh     │                                  │
│  Color = census_region           │                                  │
│                                  │                                  │
└──────────────────────────────────┴──────────────────────────────────┘
```

### Exact Element Positions

#### Row 1 — Filters

All filters: **y = 20, h = 35.**

| Element | Type | x | w | Field | Source |
|---------|------|---|---|-------|--------|
| Date range | Date range picker | 20 | 280 | — | — |
| State | Drop-down | 315 | 280 | `state_code` | `v_retail_cost_analysis` |
| Sector | Drop-down | 610 | 280 | `sector_name` | `v_retail_cost_analysis` |

#### Row 2 — KPI Scorecards

All cards: **y = 75, h = 80.**

| Card | x | w | Label | Metric | Source | Conditional Color |
|------|---|---|-------|--------|--------|-------------------|
| 1 ★ | 20 | 330 | Avg Residential Price | `price_cents_kwh` AVG (filter `sector_name` = Residential) | `v_retail_cost_analysis` | Green < 14 / Yellow 14-18 / Red > 18 |
| 2 | 365 | 260 | Total Revenue ($M) | `revenue_musd` SUM | `v_retail_cost_analysis` | — |
| 3 | 640 | 260 | Avg Renewable Share | `avg_renewable_share` AVG | `v_renewable_price_scatter` | Green > 25 / Yellow 15-25 / Red < 15 |
| 4 | 915 | 265 | Highest-Price State | `state_name` (top 1 by `avg_residential_price` DESC) | `v_renewable_price_scatter` | — |

#### Row 3 — Price Trend by Sector

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 170, w = 1160, h = 280** |
| Chart type | Time Series |
| Source | `v_retail_cost_analysis` |
| Date | `period_month` |
| Breakdown | `sector_name` |
| Metric | `price_cents_kwh` (AVG) |
| Style | Colored lines per sector, smooth |
| Title | "Electricity Price by Sector Over Time" |

#### Row 4 — Two Charts Side by Side

**Left — Hero Chart: THE SCATTER PLOT**

| Setting | Value |
|---------|-------|
| **Position** | **x = 20, y = 465, w = 700, h = 415** |
| Chart type | Scatter |
| Source | `v_renewable_price_scatter` |
| Dimension | `state_name` |
| Metric X | `avg_renewable_share` |
| Metric Y | `avg_residential_price` |
| Bubble size | `total_gen_mwh` |
| Bubble color | `census_region` |
| Data labels | `state_code` (2-letter abbreviation) |
| Reference line 1 | Vertical at **25%** (renewable threshold) |
| Reference line 2 | Horizontal at **16** ¢/kWh (national avg boundary) |
| Title | "Renewable Share vs. Electricity Price by State" |

The four quadrants:

| Quadrant | Position | Meaning |
|----------|----------|---------|
| Bottom-right | High X, Low Y | **High Renewable, Low Cost** — the winners (hydro/wind states like WA, ID) |
| Bottom-left | Low X, Low Y | Low Renewable, Low Cost — cheap fossil fuel states |
| Top-right | High X, High Y | High Renewable, High Cost — clean but expensive (HI, island grids) |
| Top-left | Low X, High Y | **Low Renewable, High Cost** — worst of both worlds |

> **Interview talking point:** "This chart challenges the assumption that
> renewable energy always raises prices. States in the bottom-right quadrant
> — like Washington and Idaho — achieve 70%+ renewable share with some of
> the lowest electricity prices in the country, primarily through hydropower.
> The relationship is more nuanced than 'renewables = expensive.'"

**Right — Top 10 Most Expensive States (bar):**

| Setting | Value |
|---------|-------|
| **Position** | **x = 735, y = 465, w = 445, h = 415** |
| Chart type | Horizontal Bar |
| Source | `v_renewable_price_scatter` |
| Dimension | `state_name` |
| Metric | `avg_residential_price` → MAX |
| Sort | Descending, Top 10 |
| Color | Conditional: green < 14, yellow 14-20, red > 20 |
| Reference line | 16 ¢/kWh national average (dashed gray) |
| Title | "Top 10 Most Expensive States (¢/kWh)" |

---

## Final Polish

### Consistent Page Headers
- On every page, the **Row 1** area (y=15, h=45) should have the same dark background
- Page title: white, bold, 20 pt, left-aligned at x=20
- Subtitle in lighter gray (11 pt): the story sentence
- Copy the header styling across all 4 pages

### Number Formatting

| Metric Type | Format | Example |
|-------------|--------|---------|
| Demand / generation (MW, MWh) | No decimals, with comma separator | `39,826 MW` |
| Percentages (MAPE, shares) | One decimal | `4.9%` |
| Prices | One decimal | `12.3 ¢/kWh` |
| Revenue | One decimal with unit | `$48.2B` |
| Renewable share | One decimal | `30.6%` |

### Conditional Formatting (How to Apply)

1. Right-click the scorecard → **Style** tab
2. Scroll to **Conditional formatting** → Click **Add**
3. Set the rules using the RAG thresholds from the tables above
4. Color mode: **Single color** (background fill is clearest)
5. Use the same green/yellow/red across all pages for consistency:
   - Green: `#00ff88`
   - Yellow: `#ffbb33`
   - Red: `#ff4444`

### Sharing
1. **Share** → "Anyone with the link can view"
2. Copy the link — it goes on your resume, GitHub README, and LinkedIn

---

## Quick Reference: All Elements

| Page | Element | Type | x | y | w | h |
|------|---------|------|---|---|---|---|
| **1** | Title text | Text | 20 | 15 | 650 | 45 |
| 1 | Data freshness | Scorecard | 740 | 20 | 180 | 35 |
| 1 | BA filter | Drop-down | 940 | 20 | 240 | 35 |
| 1 | MAPE card ★ | Scorecard | 20 | 75 | 270 | 80 |
| 1 | Avg Demand card | Scorecard | 305 | 75 | 210 | 80 |
| 1 | Peak Demand card | Scorecard | 530 | 75 | 210 | 80 |
| 1 | Renewable card | Scorecard | 755 | 75 | 210 | 80 |
| 1 | Price card | Scorecard | 980 | 75 | 200 | 80 |
| 1 | Demand trend | Time Series | 20 | 170 | 1160 | 355 |
| 1 | Demand by region | Horiz. Bar | 20 | 540 | 570 | 340 |
| 1 | Renewable by region | Horiz. Bar | 605 | 540 | 575 | 340 |
| **2** | Date filter | Date picker | 20 | 20 | 280 | 35 |
| 2 | BA filter | Drop-down | 315 | 20 | 280 | 35 |
| 2 | Region filter | Drop-down | 610 | 20 | 280 | 35 |
| 2 | MAPE card ★ | Scorecard | 20 | 75 | 330 | 80 |
| 2 | Avg Demand card | Scorecard | 365 | 75 | 260 | 80 |
| 2 | Utilization card | Scorecard | 640 | 75 | 260 | 80 |
| 2 | Hours >90% card | Scorecard | 915 | 75 | 265 | 80 |
| 2 | Demand + MAPE | Dual-axis TS | 20 | 170 | 1160 | 345 |
| 2 | Accuracy table | Heatmap Table | 20 | 530 | 600 | 350 |
| 2 | Utilization bar | Horiz. Bar | 635 | 530 | 545 | 350 |
| **3** | Date filter | Date picker | 20 | 20 | 280 | 35 |
| 3 | State filter | Drop-down | 315 | 20 | 280 | 35 |
| 3 | Region filter | Drop-down | 610 | 20 | 280 | 35 |
| 3 | Renewable card ★ | Scorecard | 20 | 75 | 420 | 80 |
| 3 | Total Gen card | Scorecard | 455 | 75 | 350 | 80 |
| 3 | Coal Share card | Scorecard | 820 | 75 | 360 | 80 |
| 3 | Stacked area | Stacked Area | 20 | 170 | 1160 | 390 |
| 3 | Fuel donut | Donut | 20 | 575 | 500 | 305 |
| 3 | Renewable states | Horiz. Bar | 535 | 575 | 645 | 305 |
| **4** | Date filter | Date picker | 20 | 20 | 280 | 35 |
| 4 | State filter | Drop-down | 315 | 20 | 280 | 35 |
| 4 | Sector filter | Drop-down | 610 | 20 | 280 | 35 |
| 4 | Price card ★ | Scorecard | 20 | 75 | 330 | 80 |
| 4 | Revenue card | Scorecard | 365 | 75 | 260 | 80 |
| 4 | Renewable Share card | Scorecard | 640 | 75 | 260 | 80 |
| 4 | Highest-Price State | Scorecard | 915 | 75 | 265 | 80 |
| 4 | Price trend | Time Series | 20 | 170 | 1160 | 280 |
| 4 | Scatter plot | Scatter | 20 | 465 | 700 | 415 |
| 4 | Top 10 expensive | Horiz. Bar | 735 | 465 | 445 | 415 |

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "No data" on a chart | Check data source is correct. Remove all filters and test. |
| Fields show as "null" | Re-run the relevant ingestion notebook (02-04). |
| Date not recognized | Change field type to "Date" in the data source editor. |
| Scatter plot empty | Run `SELECT COUNT(*) FROM lumina.v_renewable_price_scatter` in BigQuery. |
| Conditional colors not showing | Right-click scorecard → Style → Conditional formatting → Add rule. |
| Elements overlap | Use the position coordinates from the Quick Reference table above. |

---

## Time Estimate

| Step | Time |
|------|------|
| Data sources + settings | 10 min |
| Page 1: Executive | 15 min |
| Page 2: Operational | 15 min |
| Page 3: Analytical | 15 min |
| Page 4: Strategic | 15 min |
| Headers, formatting, polish | 10 min |
| **Total** | **~1.5 hours** |

---

## For Your Resume

> **Lumina: End-to-End U.S. Energy Analytics & Demand Forecasting Platform** | *Python, SQL, Google BigQuery, Looker Studio, EIA API*
>
> **Situation:** U.S. energy grid data spanning 10 balancing authorities, 50 states, and 4 federal datasets existed in siloed APIs with no unified view for monitoring grid reliability, forecast accuracy, or the cost impact of the energy transition.
>
> **Task:** Design a complete analytics platform — from raw API ingestion to an executive-ready dashboard — enabling stakeholders to monitor KPIs, identify forecast failures, and evaluate whether renewable adoption drives up electricity costs.
>
> **Action:** Engineered a **Python-based ETL pipeline** ingesting **400K+ records** from the EIA API with incremental loading into a **BigQuery star-schema warehouse** (4 dim + 4 fact tables, 8 analytical views), then designed a **4-page Looker Studio dashboard** with conditional RAG monitoring and a scatter plot analyzing renewable share vs. pricing across all 50 states.
>
> **Result:** Surfaced **5.55% national forecast MAPE**, identified **Duke Energy Carolinas (21% MAPE)** as a forecast outlier, tracked U.S. renewable share at **30.6%**, and **disproved the assumption that renewables raise electricity costs** — states like WA and ID achieve 70%+ renewable share with below-average prices.
