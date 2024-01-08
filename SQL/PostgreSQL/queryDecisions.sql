-- 1. Calculate suitability scores for planting

-- Find `carbon` in parameter
WITH carbon AS (
    -- Find the maximum value
    WITH maxScore AS (
        -- Calculate total score
        WITH score AS (
            -- Calculate score
            SELECT 
                c.seed_storage_name,
                c.seed_storage_type,
                CASE 
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 3 THEN 0
                END AS score_size,
                size.condition_indicator_description,
                CASE 
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 3 THEN 0
                END AS score_moisture,
                moisture.condition_indicator_description,
                CASE 
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 3 THEN 0
                END AS score_geneticpurity,
                geneticpurity.condition_indicator_description
            FROM 
                xxxxx.seed_stations_condition a
            LEFT JOIN 
                xxxxx.seed_stations b ON a.seed_station_id = b.seed_station_id
            LEFT JOIN 
                xxxxx.seed_storage c ON b.seed_storage_id = c.seed_storage_id
            LEFT JOIN 
                xxxxx.condition_indicator size ON size.condition_indicator_id = A.size_condition
            LEFT JOIN 
                xxxxx.condition_indicator moisture ON moisture.condition_indicator_id = A.moisture_condition
            LEFT JOIN 
                xxxxx.condition_indicator geneticpurity ON geneticpurity.condition_indicator_id = A.genetic_purity_condition
        )

        -- Calculate the total score
        SELECT 
            seed_storage_name,
            seed_storage_type,
            SUM(score_size) + SUM(score_moisture) + SUM(score_geneticpurity) AS total_score
        FROM 
            score
        GROUP BY 
            seed_storage_name,
            seed_storage_type
    )

    SELECT
        seed_storage_name,
        seed_storage_type,
        total_score
    FROM
        maxScore
    WHERE total_score = (SELECT MAX(total_score) FROM maxScore)
    
)
SELECT 
    a.seed_storage_name,
    a.seed_storage_type,
    carbon.carbon
FROM 
    carbon a
LEFT JOIN (
    SELECT parameter_subname, MIN(parameter_value) AS carbon
    FROM xxxxx.parameters 
    WHERE parameter_type = 'carbon' AND 
        parameter_name = 'seed_storage'
    GROUP BY parameter_subname
) carbon ON parameter_subname = a.seed_storage_name
WHERE carbon IS NOT NULL

--=====================================================

-- 2. Determine the potential seed quantity for each room based on space requirements
-- Criteria: Seed storage areas should adhere temperature conditions and Seed stations areas should adhere to size, moisture, or genetic purity conditions, and testers must be IDs 1 to 6
WITH sqm2 AS (
    -- Calculate total space used by each seed type
    WITH sqm AS (
        -- Extract necessary parameters for analysis
        SELECT 
            1 AS type,
            par.parameter_name, 
            par.parameter_subname, 
            par.parameter_value, 
            par.parameter_units,
            ROW_NUMBER() OVER(PARTITION BY par.parameter_name ORDER BY par.parameter_name) AS rowNo
        FROM 
            xxxxx.post_harvest_storage a
        LEFT JOIN 
            xxxxx.parameters par ON par.parameter_subname = a.post_harvest_storage_type AND par.parameter_type = 'size'
        
        UNION ALL
        
        SELECT *,
            ROW_NUMBER() OVER(PARTITION BY parameter_name ORDER BY parameter_name) AS rowNo
        FROM (
            SELECT DISTINCT 
                2 AS type,
                par.parameter_name, 
                par.parameter_subname, 
                par.parameter_value, 
                par.parameter_units
            FROM  xxxxx.seed_storage a
            LEFT JOIN xxxxx.parameters par ON par.parameter_subname = a.seed_storage_name AND par.parameter_type = 'distance'
            LEFT JOIN xxxxx.seed_storage_condition s1 ON a.seed_storage_id = s1.seed_storage_id
            LEFT JOIN xxxxx.seed_stations b ON a.seed_storage_id = b.seed_storage_id
            LEFT JOIN xxxxx.seed_stations_condition s2 ON b.seed_station_id = s2.seed_station_id 
            LEFT JOIN xxxxx.condition_indicator s4 ON s2.size_condition = s4.condition_indicator_id AND s4.condition_indicator_id = 1
            LEFT JOIN xxxxx.testers tester ON tester.tester_id = s2.tester_id
            WHERE (size_condition = 1 OR moisture_condition = 1 OR genetic_purity_condition = 1) AND tester.tester_id IN(1,2,3,4,5,6)
        ) B
        
        UNION ALL
        
        SELECT *,
            ROW_NUMBER() OVER(PARTITION BY parameter_name ORDER BY parameter_name) AS rowNo
        FROM (
            SELECT DISTINCT 
                3 AS type,
                par.parameter_name, 
                par.parameter_subname, 
                par.parameter_value, 
                par.parameter_units
            FROM  xxxxx.seed_storage a
            LEFT JOIN xxxxx.parameters par ON par.parameter_subname = a.seed_storage_name AND par.parameter_type = 'seed size'
            LEFT JOIN xxxxx.seed_storage_condition s1 ON a.seed_storage_id = s1.seed_storage_id
            LEFT JOIN xxxxx.seed_stations b ON a.seed_storage_id = b.seed_storage_id
            LEFT JOIN xxxxx.seed_stations_condition s2 ON b.seed_station_id = s2.seed_station_id 
            LEFT JOIN xxxxx.condition_indicator s4 ON s2.size_condition = s4.condition_indicator_id AND s4.condition_indicator_id = 1
            LEFT JOIN xxxxx.testers tester ON tester.tester_id = s2.tester_id
            WHERE (size_condition = 1 OR moisture_condition = 1 OR genetic_purity_condition = 1) AND tester.tester_id IN(1,2,3,4,5,6)
        ) C
    ) 
    
    -- Calculate space usage by seed type
    SELECT 
        sqm.type,
        sqm.parameter_subname,
        sqm.parameter_value,
        sqm.rowNo,
        (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 1) + 
            (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 1) AS chia,
        (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 2) +
            (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 2) AS flax,
        (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 3) +
            (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 3) AS sunflower 
    FROM 
        sqm
    WHERE 
        type = 1
)

-- Calculate potential seed quantity per room per seed type
SELECT 
    parameter_subname,
    parameter_value / chia AS chia,
    parameter_value / flax AS flax,
    parameter_value / sunflower AS sunflower
FROM 
    sqm2
WHERE 
    rowNo = 1

UNION ALL 

SELECT 
    parameter_subname,
    parameter_value / chia AS chia,
    parameter_value / flax AS flax,
    parameter_value / sunflower AS sunflower
FROM 
    sqm2
WHERE 
    rowNo = 2

--=====================================================

-- 3. Calculate the planting cost for each seed type in different rooms based on their space requirements and station locations
WITH minTotal AS (
    WITH calCost AS (
        -- Calculate the total space used by each seed type
        WITH sqm2 AS (
            -- Calculate the space used by different seed types based on various parameters
            WITH sqm AS (
                SELECT 
                    1 AS type,
                    par.parameter_name, 
                    par.parameter_subname, 
                    par.parameter_value, 
                    par.parameter_units,
                    ROW_NUMBER() OVER(PARTITION BY par.parameter_name ORDER BY par.parameter_subname) AS rowNo
                FROM 
                    xxxxx.post_harvest_storage a
                LEFT JOIN 
                    xxxxx.parameters par ON par.parameter_subname = a.post_harvest_storage_type AND par.parameter_type = 'size'
                
                UNION ALL
                
                SELECT 
                   2 AS type,
                    par.parameter_name, 
                    par.parameter_subname, 
                    par.parameter_value, 
                    par.parameter_units,
                    ROW_NUMBER() OVER(PARTITION BY par.parameter_name ORDER BY par.parameter_subname) AS rowNo
                    FROM  xxxxx.seed_storage a
                    LEFT JOIN xxxxx.parameters par ON par.parameter_subname = a.seed_storage_name AND par.parameter_type = 'distance'
                
                UNION ALL
                
                SELECT 
                    3 AS type,
                    par.parameter_name, 
                    par.parameter_subname, 
                    par.parameter_value, 
                    par.parameter_units,
                    ROW_NUMBER() OVER(PARTITION BY par.parameter_name ORDER BY par.parameter_subname) AS rowNo
                    FROM  xxxxx.seed_storage a
                    LEFT JOIN xxxxx.parameters par ON par.parameter_subname = a.seed_storage_name AND par.parameter_type = 'seed size'
            ) 
		
            SELECT 
                sqm.type,
                sqm.parameter_subname,
                sqm.parameter_value,
                sqm.rowNo,
                (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 1) + 
                    (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 1) AS chia,
                (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 2) +
                    (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 2) AS flax,
                (SELECT parameter_value FROM sqm WHERE type = 2 AND rowNo = 3) +
                    (SELECT parameter_value FROM sqm WHERE type = 3 AND rowNo = 3) AS sunflower
            FROM 
                sqm
            WHERE 
                type = 1
        )
        
        -- Calculate the quantity of seeds that can be planted in each room per seed type
        SELECT 
            parameter_subname,
            parameter_value / chia AS chia,
            parameter_value / flax AS flax,
            parameter_value / sunflower AS sunflower
        FROM 
            sqm2
        WHERE 
            rowNo = 1

        UNION ALL 

        SELECT 
            parameter_subname,
            parameter_value / chia AS chia,
            parameter_value / flax AS flax,
            parameter_value / sunflower AS sunflower
        FROM 
            sqm2
        WHERE 
            rowNo = 2
    ) 
            
    -- Calculate the planting cost for each seed type in different rooms based on their space requirements and station locations
    SELECT  
        DISTINCT calCost.parameter_subname,
        lastpar.parameter_value,
        (SELECT par.parameter_value FROM xxxxx.parameters par WHERE par.parameter_type = 'planting cost' AND par.parameter_subname = 'chia') * calCost.chia AS chia,
        (SELECT par.parameter_value FROM xxxxx.parameters par WHERE par.parameter_type = 'planting cost' AND par.parameter_subname = 'flax') * calCost.flax AS flax,
        (SELECT par.parameter_value FROM xxxxx.parameters par WHERE par.parameter_type = 'planting cost' AND par.parameter_subname = 'sunflower') * calCost.sunflower AS sunflower,
		lastpar.loc3 as stationsLocation
    FROM 
        calCost
    LEFT JOIN (
        SELECT 
            lastpar.parameter_value,
            lastpar.parameter_type,
            lastpar.parameter_subname,
            a.location AS loc1,
            b.location AS loc2,
            c.location AS loc3
        FROM 
            xxxxx.post_harvest_storage a 
        LEFT JOIN 
            xxxxx.latest_parameters lastpar ON lastpar.parameter_subname = a.post_harvest_storage_type AND lastpar.parameter_type = 'cost'
        LEFT JOIN 
            xxxxx.seed_storage b ON a.post_harvest_storage_id = b.post_harvest_storage_id
        LEFT JOIN 
            xxxxx.seed_stations c ON b.seed_storage_id = c.seed_storage_id
    ) lastpar ON calCost.parameter_subname = lastpar.parameter_subname AND lastpar.parameter_type = 'cost'
)
SELECT 
    parameter_subname, 
    parameter_value + chia + flax + sunflower AS Total,
	stationsLocation
FROM 
    minTotal
ORDER BY 2 
LIMIT 1

--=====================================================

-- 4. This query retrieves the survivability value of seeds that have temperature, size, moisture, and genetic purity conditions marked as 'most_suitable'.
-- It also displays the tester for both the storage and stations.

WITH survivability AS (
    SELECT 
        s1.post_harvest_storage_type,
        s2.seed_storage_name,
        s2.seed_storage_type,
        s3.location,
        s2c.temperature_condition,
        s3c.all_condition,
        s2c.tester_name AS testerStorage,
        s3c.tester_name AS testerStation
    FROM 
        xxxxx.post_harvest_storage s1
    LEFT JOIN 
        xxxxx.seed_storage s2 ON s1.post_harvest_storage_id = s2.post_harvest_storage_id
    LEFT JOIN 
        (
            SELECT 
                s2c.*, t.tester_name, ci.condition_indicator_description
            FROM 
                xxxxx.seed_storage_condition s2c
            LEFT JOIN 
                xxxxx.condition_indicator ci ON ci.condition_indicator_id = s2c.temperature_condition
            LEFT JOIN 
                xxxxx.testers t ON t.tester_id = s2c.tester_id
            WHERE 
                s2c.temperature_condition = 1
        ) s2c ON s2c.seed_storage_id = s2.seed_storage_id
    LEFT JOIN 
        xxxxx.seed_stations s3 ON s2.seed_storage_id = s3.seed_storage_id
    LEFT JOIN 
        (
            SELECT 
                s3c.*, t.tester_name,
                CASE 
                    WHEN (s3c.size_condition = 1 AND s3c.moisture_condition = 1 AND s3c.genetic_purity_condition = 1) THEN 1 
                    ELSE 0 
                END AS all_condition
            FROM 
                xxxxx.seed_stations_condition s3c
            LEFT JOIN 
                xxxxx.testers t ON t.tester_id = s3c.tester_id
            WHERE 
                (s3c.size_condition = 1 AND s3c.moisture_condition = 1 AND s3c.genetic_purity_condition = 1)
        ) s3c ON s3c.seed_station_id = s3.seed_station_id
    WHERE 
        s2c.temperature_condition = 1 AND s3c.all_condition = 1
)

SELECT 
    survivability.*,
    lspar.parameter_value AS survivability,
    par.parameter_units,
    lspar.date_created
FROM 
    survivability
LEFT JOIN 
    xxxxx.vw_latest_parameters lspar ON lspar.parameter_subname = survivability.seed_storage_type 
LEFT JOIN 
    xxxxx.parameters par ON par.parameter_subname = survivability.seed_storage_type 
WHERE 
    lspar.parameter_type = 'survivability'

--=====================================================

-- 5. Find the lowest total cost per square meter.
select * 
from xxxxx.vw_sqmstation 
order by totalcost_sqm 
limit 1

--=====================================================

-- 6 Find the lowest tester gave score in seed statons.
SELECT *
FROM xxxxx.vw_checktester 
WHERE tester_id = (
    SELECT tester_id
    FROM xxxxx.vw_checktester 
    GROUP BY tester_id
    ORDER BY COUNT(tester_id) DESC
    FETCH FIRST ROW ONLY
);

--=====================================================

-- 7 find the period best score in size, moisture, genetic purity and carbon condition.
-- Retrieve all records from the view 'xxxxx.vw_dayscore' where the 'totalscore' is equal to the maximum 'totalscore' in the same view
SELECT * 
FROM xxxxx.vw_dayscore
WHERE totalscore = (
    -- Subquery to find the maximum 'totalscore' in the 'xxxxx.vw_dayscore' view
    SELECT MAX(totalscore)
    FROM xxxxx.vw_dayscore
);

--=====================================================
