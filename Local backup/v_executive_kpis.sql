WITH demand_kpis AS (
    SELECT
        ROUND(AVG(demand_mw), 0) AS current_avg_demand_mw,
        ROUND(MAX(demand_mw), 0) AS peak_demand_mw,
        ROUND(AVG(ABS(forecast_error_pct)), 2) AS overall_mape,
        ROUND(SQRT(AVG(POWER(forecast_error_mw, 2))), 0) AS overall_rmse_mw,
        COUNT(DISTINCT ba_code) AS active_bas,
        MIN(timestamp_utc) AS data_start,
        MAX(timestamp_utc) AS data_end
    FROM `lumina-da.lumina.fact_hourly_demand`
    WHERE timestamp_utc >= TIMESTAMP_SUB(
        (SELECT MAX(timestamp_utc) FROM `lumina-da.lumina.fact_hourly_demand`),
        INTERVAL 30 DAY
    )
),
gen_kpis AS (
    SELECT
        ROUND(SUM(CASE WHEN is_renewable THEN generation_mwh ELSE 0 END) /
              NULLIF(SUM(generation_mwh), 0) * 100, 1) AS national_renewable_share_pct,
        ROUND(SUM(generation_mwh) / 1e6, 1) AS total_generation_twh
    FROM `lumina-da.lumina.v_generation_fuel_mix`
    WHERE period_month >= DATE_SUB(
        CAST((SELECT MAX(period_month) FROM `lumina-da.lumina.fact_monthly_generation`) AS DATE),
        INTERVAL 12 MONTH
    )
),
retail_kpis AS (
    SELECT
        ROUND(AVG(price_cents_kwh), 2) AS national_avg_price_cents,
        ROUND(SUM(revenue_musd) / 1e3, 1) AS total_revenue_busd
    FROM `lumina-da.lumina.fact_retail_sales`
    WHERE CAST(sector_code AS STRING) = 'RES'
        AND period_month >= DATE_SUB(
            CAST((SELECT MAX(period_month) FROM `lumina-da.lumina.fact_retail_sales`) AS DATE),
            INTERVAL 12 MONTH
        )
)
SELECT
    d.current_avg_demand_mw,
    d.peak_demand_mw,
    d.overall_mape AS forecast_mape_pct,
    d.overall_rmse_mw AS forecast_rmse_mw,
    d.active_bas,
    g.national_renewable_share_pct,
    g.total_generation_twh,
    r.national_avg_price_cents,
    r.total_revenue_busd,
    d.data_start,
    d.data_end
FROM demand_kpis d
CROSS JOIN gen_kpis g
CROSS JOIN retail_kpis r