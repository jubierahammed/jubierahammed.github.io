------------------------------------------------------------------------------
-- Spatial Inequities in Electric Vehicle Charging Infrastructure in Texas
-- PostgreSQL / PostGIS, all geometries in EPSG:3081
-- (NAD83 / Texas Centric Albers Equal Area, units in meters)
------------------------------------------------------------------------------

-- QUERY 1: Linking demographics to spatial boundaries
-- The ACS population table carries a long-form GEO_ID
-- (e.g. 1400000US48001950100) while the TIGER/Line tracts use the
-- 11-digit FIPS code. RIGHT() strips the prefix so the two can be joined.
-- Tracts with fewer than 1,000 residents are dropped so that lakes,
-- industrial parks and airports are not flagged as "charging deserts".

CREATE VIEW v_populated_tracts AS
SELECT
    t.geoid,
    p.total_population,
    t.geom
FROM tx_census_tracts t
JOIN tx_acs_population p ON t.geoid = RIGHT(p.geo_id, 11)
WHERE p.total_population > 1000;


-- QUERY 2: Identifying the charging deserts (distance analysis)
-- Populated tracts with no public EV station within 8,046 m (~5 miles).
-- Because the data are projected, ST_DWithin measures in meters directly.

SELECT
    pt.geoid,
    pt.total_population
FROM v_populated_tracts pt
WHERE NOT EXISTS (
    SELECT 1
    FROM tx_ev_stations ev
    WHERE ST_DWithin(pt.geom, ev.geom, 8046)
)
ORDER BY pt.total_population DESC;


-- QUERY 3: Pinpointing high-priority corridors (intersection analysis)
-- Major roads that pass directly through the charging deserts found above.

WITH ChargingDeserts AS (
    SELECT geom
    FROM v_populated_tracts pt
    WHERE NOT EXISTS (
        SELECT 1
        FROM tx_ev_stations ev
        WHERE ST_DWithin(pt.geom, ev.geom, 8046)
    )
)
SELECT DISTINCT
    r.fullname AS recommended_highway
FROM tx_major_roads r
JOIN ChargingDeserts cd ON ST_Intersects(r.geom, cd.geom)
WHERE r.fullname IS NOT NULL
ORDER BY r.fullname;
