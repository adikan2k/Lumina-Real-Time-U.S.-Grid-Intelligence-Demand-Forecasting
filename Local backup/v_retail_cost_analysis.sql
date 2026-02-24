SELECT
    CAST(r.period_month AS DATE) AS period_month,
    EXTRACT(YEAR FROM r.period_month) AS year,

    r.state_code,
    geo.state_name,
    geo.census_region,
    geo.population,

    CAST(r.sector_code AS STRING) AS sector_code,
    CASE CAST(r.sector_code AS STRING)
        WHEN 'RES' THEN 'Residential'
        WHEN 'COM' THEN 'Commercial'
        WHEN 'IND' THEN 'Industrial'
        WHEN 'TRA' THEN 'Transportation'
        WHEN 'OTH' THEN 'Other'
        ELSE CAST(r.sector_code AS STRING)
    END AS sector_name,

    r.revenue_musd,
    r.sales_mwh,
    r.price_cents_kwh,
    r.customers,

    -- Derived
    ROUND(SAFE_DIVIDE(r.revenue_musd * 1e6, r.customers), 2) AS revenue_per_customer_usd,
    ROUND(SAFE_DIVIDE(r.sales_mwh * 1e3, r.customers), 2) AS kwh_per_customer,

    -- Price ranking within period
    RANK() OVER (
        PARTITION BY r.period_month, r.sector_code
        ORDER BY r.price_cents_kwh DESC
    ) AS price_rank_high_to_low,

FROM `lumina-da.lumina.fact_retail_sales` r
LEFT JOIN `lumina-da.lumina.dim_geography` geo ON r.state_code = geo.state_code