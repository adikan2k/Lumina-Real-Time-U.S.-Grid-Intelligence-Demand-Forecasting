SELECT
    h.timestamp_utc,
    DATE(h.timestamp_utc) AS date_utc,
    EXTRACT(HOUR FROM h.timestamp_utc) AS hour_utc,
    EXTRACT(DAYOFWEEK FROM h.timestamp_utc) AS day_of_week,
    CASE WHEN EXTRACT(DAYOFWEEK FROM h.timestamp_utc) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,

    h.ba_code,
    ba.ba_name,
    ba.region,
    ba.peak_capacity_mw,

    h.demand_mw,
    h.demand_forecast_mw,
    h.net_generation_mw,
    h.interchange_mw,
    h.forecast_error_mw,
    h.forecast_error_pct,

    -- Derived metrics
    SAFE_DIVIDE(h.demand_mw, ba.peak_capacity_mw) * 100 AS capacity_utilization_pct,
    ABS(h.forecast_error_pct) AS abs_forecast_error_pct,
    CASE
        WHEN SAFE_DIVIDE(h.demand_mw, ba.peak_capacity_mw) > 0.90 THEN 'CRITICAL'
        WHEN SAFE_DIVIDE(h.demand_mw, ba.peak_capacity_mw) > 0.80 THEN 'WARNING'
        WHEN SAFE_DIVIDE(h.demand_mw, ba.peak_capacity_mw) > 0.70 THEN 'ELEVATED'
        ELSE 'NORMAL'
    END AS capacity_alert_level,

    -- Net position: positive = exporting, negative = importing
    CASE
        WHEN h.interchange_mw > 0 THEN 'Exporting'
        WHEN h.interchange_mw < 0 THEN 'Importing'
        ELSE 'Balanced'
    END AS trade_position,

FROM `lumina-da.lumina.fact_hourly_demand` h
LEFT JOIN `lumina-da.lumina.dim_balancing_authority` ba ON h.ba_code = ba.ba_code