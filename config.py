"""
Lumina Forecasting — Shared Configuration
==========================================
Central config for EIA API ingestion and BigQuery loading.
Update these values before running any notebook.
"""

# ─────────────────────────────────────────────
# EIA API v2
# ─────────────────────────────────────────────
EIA_API_KEY = "YOUR_EIA_API_KEY"          # Register at https://www.eia.gov/opendata/register.php
EIA_BASE_URL = "https://api.eia.gov/v2"
EIA_MAX_ROWS = 5000                       # API hard limit per request

# ─────────────────────────────────────────────
# Google Cloud / BigQuery
# ─────────────────────────────────────────────
GCP_PROJECT_ID = "YOUR_GCP_PROJECT_ID"
BQ_DATASET = "lumina"                     # BigQuery dataset name
BQ_LOCATION = "US"

# ─────────────────────────────────────────────
# Balancing Authorities of Interest
# Major US RTOs/ISOs for the grid operations page
# ─────────────────────────────────────────────
BALANCING_AUTHORITIES = [
    "PJM",       # PJM Interconnection (Mid-Atlantic + Midwest)
    "MISO",      # Midcontinent ISO
    "ERCO",      # ERCOT (Texas)
    "CISO",      # California ISO
    "ISNE",      # ISO New England
    "NYIS",      # New York ISO
    "SWPP",      # Southwest Power Pool
    "SOCO",      # Southern Company
    "TVA",       # Tennessee Valley Authority
    "DUK",       # Duke Energy Carolinas
]

# ─────────────────────────────────────────────
# State FIPS / Codes for SEDS & Retail Sales
# ─────────────────────────────────────────────
US_STATES = [
    "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
    "HI","ID","IL","IN","IA","KS","KY","LA","ME","MD",
    "MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
    "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
    "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY",
    "DC",
]

# ─────────────────────────────────────────────
# Fuel type mapping (EIA codes → clean labels)
# ─────────────────────────────────────────────
FUEL_TYPE_MAP = {
    "SUN": {"label": "Solar",         "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "WND": {"label": "Wind",          "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "WAT": {"label": "Hydro",         "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "NUC": {"label": "Nuclear",       "is_renewable": False, "emission_factor_kg_per_mwh": 0},
    "NG":  {"label": "Natural Gas",   "is_renewable": False, "emission_factor_kg_per_mwh": 411},
    "COL": {"label": "Coal",          "is_renewable": False, "emission_factor_kg_per_mwh": 910},
    "PET": {"label": "Petroleum",     "is_renewable": False, "emission_factor_kg_per_mwh": 700},
    "OTH": {"label": "Other",         "is_renewable": False, "emission_factor_kg_per_mwh": 300},
    "GEO": {"label": "Geothermal",    "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "BIO": {"label": "Biomass",       "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "WAS": {"label": "Waste",         "is_renewable": False, "emission_factor_kg_per_mwh": 500},
    "OOG": {"label": "Other Gas",     "is_renewable": False, "emission_factor_kg_per_mwh": 450},
    "ALL": {"label": "All Fuels",     "is_renewable": False, "emission_factor_kg_per_mwh": None},
    "TSN": {"label": "All Solar",     "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "AOR": {"label": "All Renewables","is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "SPV": {"label": "Solar PV",      "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "STH": {"label": "Solar Thermal", "is_renewable": True,  "emission_factor_kg_per_mwh": 0},
    "DPV": {"label": "Distributed Solar PV", "is_renewable": True, "emission_factor_kg_per_mwh": 0},
    "HYC": {"label": "Conventional Hydro",   "is_renewable": True, "emission_factor_kg_per_mwh": 0},
    "HPS": {"label": "Hydro Pumped Storage", "is_renewable": False,"emission_factor_kg_per_mwh": 0},
    "WWW": {"label": "Wood & Wood Waste",    "is_renewable": True, "emission_factor_kg_per_mwh": 0},
}

# ─────────────────────────────────────────────
# Date ranges for initial backfill
# ─────────────────────────────────────────────
BACKFILL_START_HOURLY = "2024-01-01"      # RTO hourly data (keep manageable)
BACKFILL_START_MONTHLY = "2019-01"        # Generation + retail sales
BACKFILL_START_ANNUAL = "2010"            # SEDS / CO2


# ─────────────────────────────────────────────
# Utility functions
# ─────────────────────────────────────────────
def get_eia_headers():
    """Return default params dict with API key."""
    return {"api_key": EIA_API_KEY}
