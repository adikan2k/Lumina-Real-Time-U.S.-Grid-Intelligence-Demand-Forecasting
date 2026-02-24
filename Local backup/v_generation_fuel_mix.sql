SELECT
    CAST(g.period_month AS DATE) AS period_month,
    EXTRACT(YEAR FROM g.period_month) AS year,
    EXTRACT(MONTH FROM g.period_month) AS month,

    g.state_code,
    geo.state_name,
    geo.census_region,
    geo.census_division,

    g.fuel_code,
    f.fuel_label,
    f.is_renewable,
    f.emission_factor_kg_mwh,

    CAST(g.sector_code AS STRING) AS sector_code,
    g.generation_mwh,

    -- Estimated CO2 from generation (using emission factors)
    ROUND(g.generation_mwh * COALESCE(f.emission_factor_kg_mwh, 0) / 1e6, 2) AS estimated_co2_ktons,

FROM `lumina-da.lumina.fact_monthly_generation` g
LEFT JOIN `lumina-da.lumina.dim_fuel_type` f ON g.fuel_code = f.fuel_code
LEFT JOIN `lumina-da.lumina.dim_geography` geo ON g.state_code = geo.state_code