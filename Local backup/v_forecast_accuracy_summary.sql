WITH hourly AS (
    SELECT
        ba_code,
        ba_name,
        DATE_TRUNC(DATE(timestamp_utc), MONTH) AS month,
        demand_mw,
        demand_forecast_mw,
        forecast_error_mw,
        forecast_error_pct,
        hour_utc,
        is_weekend
    FROM `lumina-da.lumina.v_grid_operations_hourly`
    WHERE demand_mw IS NOT NULL AND demand_forecast_mw IS NOT NULL
)
SELECT
    ba_code,
    ba_name,
    month,

    -- Overall accuracy
    ROUND(AVG(ABS(forecast_error_pct)), 2) AS mape,
    ROUND(SQRT(AVG(POWER(forecast_error_mw, 2))), 1) AS rmse_mw,
    ROUND(AVG(forecast_error_mw), 1) AS mean_bias_mw,
    ROUND(STDDEV(forecast_error_mw), 1) AS std_error_mw,

    -- Peak vs off-peak accuracy
    ROUND(AVG(CASE WHEN hour_utc BETWEEN 7 AND 22 THEN ABS(forecast_error_pct) END), 2) AS mape_peak_hours,
    ROUND(AVG(CASE WHEN hour_utc NOT BETWEEN 7 AND 22 THEN ABS(forecast_error_pct) END), 2) AS mape_offpeak_hours,

    -- Weekday vs weekend
    ROUND(AVG(CASE WHEN NOT is_weekend THEN ABS(forecast_error_pct) END), 2) AS mape_weekday,
    ROUND(AVG(CASE WHEN is_weekend THEN ABS(forecast_error_pct) END), 2) AS mape_weekend,

    COUNT(*) AS total_observations

FROM hourly
GROUP BY 1, 2, 3