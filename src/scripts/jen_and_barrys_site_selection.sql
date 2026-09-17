------------------------------------------------------------------------------
-- Site Selection Analysis Using a PostGIS Spatial Database
-- Jen & Barry's Ice Cream, hypothetical site selection
------------------------------------------------------------------------------

-- STEP 1: County-Level Filtering
-- Isolates counties meeting the initial demographic and agricultural
-- requirements: over 500 milk production farms, a labor pool (ages 18-64)
-- of at least 25,000, and a population density below 150 individuals per
-- square mile.

CREATE OR REPLACE VIEW lab6.suitable_counties AS
SELECT *
FROM lab6.counties
WHERE no_farms87 > 500
  AND age_18_64 >= 25000
  AND pop_sqmile < 150;


-- STEP 2: City-Level Filtering
-- Isolates cities with a crime index of 0.02 or lower and proximity to a
-- university. A spatial join (ST_Intersects) ensures these cities are
-- geographically located within the suitable counties identified in Step 1.
-- This intermediate step generated 9 candidate cities.

CREATE OR REPLACE VIEW lab6.suitable_cities AS
SELECT c.*
FROM lab6.cities c
JOIN lab6.suitable_counties sc
  ON ST_Intersects(c.geom, sc.geom)
WHERE c.crime_inde <= 0.02
  AND c.university = 1;


-- STEP 3: Proximity Analysis
-- Applies the final tier of criteria: within 10 miles of a recreation area
-- and within 20 miles of an interstate. To ensure accurate measurements in
-- feet, geometries are projected on the fly to Pennsylvania State Plane
-- North (SRID: 2271) using ST_Transform within an ST_DWithin query.
-- (10 miles = 52,800 feet; 20 miles = 105,600 feet)

CREATE OR REPLACE VIEW lab6.final_candidate_cities AS
SELECT c.*
FROM lab6.suitable_cities c
WHERE EXISTS (
    SELECT 1 FROM lab6.recareas r
    WHERE ST_DWithin(
        ST_Transform(c.geom, 2271),
        ST_Transform(r.geom, 2271),
        52800
    )
)
AND EXISTS (
    SELECT 1 FROM lab6.interstates i
    WHERE ST_DWithin(
        ST_Transform(c.geom, 2271),
        ST_Transform(i.geom, 2271),
        105600
    )
);


-- RESULTS
-- After applying all spatial and attribute filters, the analysis narrowed
-- the candidates down to exactly 4 cities.

SELECT name, population, crime_inde
FROM lab6.final_candidate_cities;
