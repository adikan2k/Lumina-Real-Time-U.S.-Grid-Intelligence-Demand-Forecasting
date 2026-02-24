WITH latest_year AS (
    SELECT MAX(EXTRACT(YEAR FROM period_month)) AS yr
    FROM `lumina-da.lumina.v_energy_transition_tracker`
    WHERE total_gen_mwh > 0
),
renewable AS (
    SELECT
        state_code,
        ROUND(AVG(renewable_share_pct), 2) AS avg_renewable_share,
        ROUND(SUM(total_gen_mwh), 0) AS total_gen_mwh,
        ROUND(AVG(coal_share_pct), 2) AS avg_coal_share,
        ROUND(AVG(gas_share_pct), 2) AS avg_gas_share,
        ROUND(AVG(wind_share_pct), 2) AS avg_wind_share,
        ROUND(AVG(solar_share_pct), 2) AS avg_solar_share,
        ROUND(AVG(nuclear_share_pct), 2) AS avg_nuclear_share
    FROM `lumina-da.lumina.v_energy_transition_tracker`
    WHERE EXTRACT(YEAR FROM period_month) = (SELECT yr FROM latest_year)
    GROUP BY state_code
),
price AS (
    SELECT
        state_code,
        ROUND(AVG(price_cents_kwh), 2) AS avg_residential_price,
        ROUND(SUM(revenue_musd), 2) AS total_revenue_musd,
        ROUND(SUM(sales_mwh), 0) AS total_sales_mwh
    FROM `lumina-da.lumina.v_retail_cost_analysis`
    WHERE sector_name = 'Residential'
        AND year = (SELECT yr FROM latest_year)
    GROUP BY state_code
)
SELECT
    r.state_code,
    geo.state_name,
    geo.census_region,
    geo.population,
    r.avg_renewable_share,
    r.total_gen_mwh,
    r.avg_coal_share,
    r.avg_gas_share,
    r.avg_wind_share,
    r.avg_solar_share,
    r.avg_nuclear_share,
    p.avg_residential_price,
    p.total_revenue_musd,
    p.total_sales_mwh,

    -- Quadrant classification
    CASE
        WHEN r.avg_renewable_share > 25 AND p.avg_residential_price <= 12 THEN 'High Renewable, Low Cost'
        WHEN r.avg_renewable_share > 25 AND p.avg_residential_price > 12 THEN 'High Renewable, High Cost'
        WHEN r.avg_renewable_share <= 25 AND p.avg_residential_price <= 12 THEN 'Low Renewable, Low Cost'
        ELSE 'Low Renewable, High Cost'
    END AS quadrant

FROM renewable r
LEFT JOIN price p ON r.state_code = p.state_code
LEFT JOIN `lumina-da.lumina.dim_geography` geo ON r.state_code = geo.state_code
WHERE r.avg_renewable_share IS NOT NULL
    AND p.avg_residential_price IS NOT NULL