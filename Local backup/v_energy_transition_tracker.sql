WITH deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY period_month, state_code, fuel_code
            ORDER BY generation_mwh DESC NULLS LAST
        ) AS rn
    FROM `lumina-da.lumina.v_generation_fuel_mix`
),
monthly_totals AS (
    SELECT
        period_month,
        state_code,
        state_name,
        census_region,
        SUM(generation_mwh) AS total_gen_mwh,
        SUM(CASE WHEN is_renewable THEN generation_mwh ELSE 0 END) AS renewable_gen_mwh,
        SUM(CASE WHEN fuel_label = 'Coal' THEN generation_mwh ELSE 0 END) AS coal_gen_mwh,
        SUM(CASE WHEN fuel_label = 'Natural Gas' THEN generation_mwh ELSE 0 END) AS gas_gen_mwh,
        SUM(CASE WHEN fuel_label IN ('Solar', 'Solar PV', 'Solar Thermal', 'Distributed PV') THEN generation_mwh ELSE 0 END) AS solar_gen_mwh,
        SUM(CASE WHEN fuel_label = 'Wind' THEN generation_mwh ELSE 0 END) AS wind_gen_mwh,
        SUM(CASE WHEN fuel_label = 'Nuclear' THEN generation_mwh ELSE 0 END) AS nuclear_gen_mwh,
        SUM(estimated_co2_ktons) AS estimated_co2_ktons
    FROM deduped
    WHERE rn = 1
    GROUP BY 1, 2, 3, 4
)
SELECT
    *,
    ROUND(SAFE_DIVIDE(renewable_gen_mwh, total_gen_mwh) * 100, 2) AS renewable_share_pct,
    ROUND(SAFE_DIVIDE(coal_gen_mwh, total_gen_mwh) * 100, 2) AS coal_share_pct,
    ROUND(SAFE_DIVIDE(gas_gen_mwh, total_gen_mwh) * 100, 2) AS gas_share_pct,
    ROUND(SAFE_DIVIDE(solar_gen_mwh, total_gen_mwh) * 100, 2) AS solar_share_pct,
    ROUND(SAFE_DIVIDE(wind_gen_mwh, total_gen_mwh) * 100, 2) AS wind_share_pct,
    ROUND(SAFE_DIVIDE(nuclear_gen_mwh, total_gen_mwh) * 100, 2) AS nuclear_share_pct,
    ROUND(SAFE_DIVIDE(estimated_co2_ktons * 1e3, total_gen_mwh / 1e3) * 1e3, 1) AS grid_carbon_intensity_kg_mwh,
    LAG(SAFE_DIVIDE(renewable_gen_mwh, total_gen_mwh) * 100, 12) OVER (
        PARTITION BY state_code ORDER BY period_month
    ) AS renewable_share_pct_prev_year,
FROM monthly_totals