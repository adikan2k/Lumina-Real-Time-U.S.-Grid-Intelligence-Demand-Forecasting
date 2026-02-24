SELECT
    DATE(timestamp_utc) AS date_utc,
    ba_code,
    ba_name,
    region,
    peak_capacity_mw,

    -- Daily demand stats
    ROUND(AVG(demand_mw), 1) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 1) AS peak_demand_mw,
    ROUND(MIN(demand_mw), 1) AS min_demand_mw,
    ROUND(MAX(demand_mw) - MIN(demand_mw), 1) AS demand_range_mw,

    -- Daily forecast accuracy
    ROUND(AVG(ABS(forecast_error_pct)), 2) AS mape_daily,
    ROUND(SQRT(AVG(POWER(forecast_error_mw, 2))), 1) AS rmse_daily,
    ROUND(AVG(forecast_error_mw), 1) AS bias_mw,

    -- Capacity utilization
    ROUND(MAX(SAFE_DIVIDE(demand_mw, peak_capacity_mw)) * 100, 1) AS peak_utilization_pct,
    COUNTIF(SAFE_DIVIDE(demand_mw, peak_capacity_mw) > 0.90) AS hours_above_90pct,

    -- Generation & trade
    ROUND(AVG(net_generation_mw), 1) AS avg_generation_mw,
    ROUND(AVG(interchange_mw), 1) AS avg_interchange_mw,

    COUNT(*) AS hours_reported

FROM `lumina-da.lumina.v_grid_operations_hourly`
GROUP BY 1, 2, 3, 4, 5