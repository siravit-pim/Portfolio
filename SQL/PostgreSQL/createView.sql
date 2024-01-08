-- Fetch the latest parameters
-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS xxxxx.vw_latest_parameters CASCADE;

-- Create a view to fetch the latest parameters
CREATE VIEW xxxxx.vw_latest_parameters AS (
    WITH latest_parameters AS (
        -- Select the latest parameters by grouping based on type, name, and subname
        SELECT 
            parameter_type, 
            parameter_name, 
            parameter_subname, 
            MAX(date_created) AS date_created
        FROM 
            xxxxx.parameters
        GROUP BY 
            parameter_type, 
            parameter_name, 
            parameter_subname
    )

    -- Join to retrieve the rest of the parameter details
    SELECT 
        a.parameter_id, 
        a.parameter_value, 
        b.* 
    FROM 
        xxxxx.parameters a 
    INNER JOIN 
        latest_parameters b ON a.parameter_type = b.parameter_type 
                            AND a.parameter_name = b.parameter_name 
                            AND a.parameter_subname = b.parameter_subname 
                            AND a.date_created = b.date_created
);

--====================================

-- Find MIN / MAX / AVG temperature values and their corresponding locations in different storage types
-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS xxxxx.vw_temperature CASCADE;

-- Create a view to fetch the latest parameters
CREATE VIEW xxxxx.vw_temperature AS (
    -- Calculate temperature values and their associated locations
    WITH cal1 AS (
        SELECT 
            a.seed_storage_id,
            a.temperature_condition,
            b.condition_indicator_description,
            s.post_harvest_storage_type,
            s.seed_storage_name,
            s.seed_storage_type,
            s.location
        FROM  
            xxxxx.seed_storage_condition a
        LEFT JOIN 
            xxxxx.condition_indicator b ON a.temperature_condition = b.condition_indicator_id
        LEFT JOIN (
            SELECT 
                s1.post_harvest_storage_type,
                s2.seed_storage_name,
                s2.seed_storage_type,
                s2.location,
                s2.seed_storage_id
            FROM 
                xxxxx.post_harvest_storage s1
            LEFT JOIN 
                xxxxx.seed_storage s2 ON s1.post_harvest_storage_id = s2.post_harvest_storage_id
            LEFT JOIN 
                xxxxx.seed_stations s3 ON s2.seed_storage_id = s3.seed_storage_id
        ) s ON a.seed_storage_id = s.seed_storage_id 
    )

    -- Calculate MIN / MAX / AVG temperature values per storage location
    SELECT 
        seed_storage_id,
        MIN(temperature_condition) AS temperatureMin,
        MAX(temperature_condition) AS temperatureMax,
        AVG(temperature_condition) AS temperatureAVG,
        location
    FROM 
        cal1
    GROUP BY 
        seed_storage_id, location
);

--====================================

-- Find MIN / MAX / AVG size, moisture, genetic purity values and their corresponding locations in different stations
-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS xxxxx.vw_stationscon CASCADE;
CREATE VIEW xxxxx.vw_stationscon AS (
-- Calculate size, moisture, genetic purity values and their associated locations
WITH cal1 AS (
  SELECT 
        a.seed_station_id,
		a.size_condition ,
		a.moisture_condition ,
		a.genetic_purity_condition ,
        b1.condition_indicator_description,
		b2.condition_indicator_description,
		b3.condition_indicator_description,
        s.post_harvest_storage_type,
        s.seed_storage_name,
        s.seed_storage_type,
        s.location
    FROM  
        xxxxx.seed_stations_condition a
    LEFT JOIN 
        xxxxx.condition_indicator b1 ON a.size_condition = b1.condition_indicator_id
	LEFT JOIN 
        xxxxx.condition_indicator b2 ON a.moisture_condition = b2.condition_indicator_id
	LEFT JOIN 
        xxxxx.condition_indicator b3 ON a.genetic_purity_condition = b3.condition_indicator_id
    LEFT JOIN (
        SELECT 
            s1.post_harvest_storage_type,
            s2.seed_storage_name,
            s2.seed_storage_type,
            s3.location,
            s3.seed_station_id
        FROM 
            xxxxx.post_harvest_storage s1
        LEFT JOIN 
            xxxxx.seed_storage s2 ON s1.post_harvest_storage_id = s2.post_harvest_storage_id
        LEFT JOIN 
            xxxxx.seed_stations s3 ON s2.seed_storage_id = s3.seed_storage_id
    ) s ON a.seed_station_id = s.seed_station_id 
)

-- Calculate MIN / MAX / AVG size, moisture, genetic purity values per stations location
SELECT 
    seed_station_id,
    MIN(size_condition) AS sizeMin,
    MAX(size_condition) AS sizeMax,
    AVG(size_condition) AS sizeAVG,
	MIN(moisture_condition) AS moistureMin,
    MAX(moisture_condition) AS moistureMax,
    AVG(moisture_condition) AS moistureAVG,
	MIN(genetic_purity_condition) AS genetic_purityMin,
    MAX(genetic_purity_condition) AS genetic_purityMax,
    AVG(genetic_purity_condition) AS genetic_purityAVG,
	location
FROM 
    cal1
GROUP BY 
    seed_station_id,location
);

--====================================

-- table ref:5 / This SQL query computes the ratio between the areas of seed storage facilities and seed station locations, while aggregating the costs for water, electricity, and the average room cost. It incorporates specific criteria for each area:

-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS xxxxx.vw_sqmstation CASCADE;
CREATE VIEW xxxxx.vw_sqmstation AS (
	
WITH A AS (
    -- Compute the area ratio for each seed storage compared to the associated seed stations
    SELECT  
        a.seed_storage_id,
        a.seed_storage_name,
        a.seed_storage_type,
        CAST(ST_AREA(location) AS INTEGER) / (
            SELECT COUNT(1) 
            FROM xxxxx.seed_stations b 
            WHERE a.seed_storage_id = b.seed_storage_id
        ) AS sqm_SeedStation
    FROM 
        xxxxx.seed_storage a
) 
SELECT DISTINCT 
    -- Select distinct seed storage names, types, and their computed area ratios
    a.seed_storage_name,
    a.seed_storage_type,
	a.sqm_SeedStation,
    -- Calculate the total cost per square meter for each seed storage based on the given conditions:
    (
        sqm_SeedStation *
        (
            -- Sum the parameter values for 'cost' with the name 'seed_stations'
            SELECT SUM(parameter_value) AS value
            FROM xxxxx.parameters
            WHERE parameter_type = 'cost' AND parameter_name = 'seed_stations'
        )
    ) +
    (
        sqm_SeedStation *
        (
            -- Compute the average cost per square meter for post-harvest storage types
            SELECT AVG(par.parameter_value)
            FROM xxxxx.post_harvest_storage a
            LEFT JOIN xxxxx.parameters par ON par.parameter_subname = a.post_harvest_storage_type AND par.parameter_type = 'cost' 
        )
    ) AS totalcost_sqm
FROM A
-- Join tables to filter seed storages meeting specific conditions:
LEFT JOIN xxxxx.seed_storage_condition s1 ON a.seed_storage_id = s1.seed_storage_id
LEFT JOIN xxxxx.seed_stations b ON a.seed_storage_id = b.seed_storage_id
LEFT JOIN xxxxx.seed_stations_condition s2 ON b.seed_station_id = s2.seed_station_id 
LEFT JOIN xxxxx.condition_indicator s4 ON s2.size_condition = s4.condition_indicator_id
-- Apply criteria to filter seed storages and seed stations meeting specified conditions
WHERE (s4.condition_indicator_id = 1 or s2.size_condition = 1 OR s2.moisture_condition = 1 OR s2.genetic_purity_condition = 1) 
);

--====================================

-- table ref:6 / Evaluate seed stations and testers based on three conditions, calculate the total score for each, and identify testers with scores below the average
-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS xxxxx.vw_checktester CASCADE;
CREATE VIEW xxxxx.vw_checktester AS (
-- Common Table Expression (CTE) to calculate scores for each seed station and tester
WITH checkTester AS (
    WITH cal AS (
        SELECT
            seed_station_id,
            tester_id,
            -- Calculate scores for size, moisture, and genetic purity conditions
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
            LEFT JOIN xxxxx.condition_indicator size ON size.condition_indicator_id = A.size_condition
            LEFT JOIN xxxxx.condition_indicator moisture ON moisture.condition_indicator_id = A.moisture_condition
            LEFT JOIN xxxxx.condition_indicator geneticpurity ON geneticpurity.condition_indicator_id = A.genetic_purity_condition
    )
    -- Select seed station, tester, and total score
    SELECT
        seed_station_id, 
        tester_id,
        score_size + score_moisture + score_geneticpurity AS totalScore
    FROM
        cal
),

-- CTE to calculate the average scores for size, moisture, and genetic purity conditions
avgScore2 AS (
    WITH avgScore1 AS (
        SELECT
            seed_station_id,
            -- Calculate average scores for size, moisture, and genetic purity conditions
            
                CASE
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.size_condition) = 3 THEN 0
                END
             AS avg_score_size,

                CASE
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.moisture_condition) = 3 THEN 0
                END
             AS avg_score_moisture,
           
                CASE
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 1 THEN 2
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 2 THEN 1
                    WHEN (SELECT z.condition_indicator_id FROM xxxxx.condition_indicator z WHERE z.condition_indicator_id = a.genetic_purity_condition) = 3 THEN 0
                END
             AS avg_score_geneticpurity
        FROM
            xxxxx.seed_stations_condition a
    )
    -- Select average scores for size, moisture, and genetic purity
    SELECT
        AVG(avg_score_size + avg_score_moisture + avg_score_geneticpurity) AS avgScore
    FROM
        avgScore1
)

-- Final query to retrieve results and filter by totalScore less than the average score
SELECT
    c.seed_station_id,
    c.tester_id,
    c.totalScore,
    t.tester_name,
    s1.post_harvest_storage_type,
    s3.location
FROM
    checkTester c 
    LEFT JOIN xxxxx.testers t ON t.tester_id = c.tester_id
    LEFT JOIN xxxxx.seed_stations s3 ON s3.seed_station_id = c.seed_station_id
    LEFT JOIN xxxxx.seed_storage s2 ON s2.seed_storage_id = s3.seed_storage_id
    LEFT JOIN xxxxx.post_harvest_storage s1 ON s1.post_harvest_storage_id = s2.post_harvest_storage_id
WHERE
    c.totalScore < (SELECT avgScore FROM avgScore2)
);

--====================================

-- ref table: 7 /Calculate scores for seed stations based on size, moisture, genetic purity, seed carbon, and room carbon conditions
-- Utilize two levels of Common Table Expressions (CTEs) for clarity and modularity
DROP VIEW IF EXISTS xxxxx.vw_dayscore CASCADE;
CREATE VIEW xxxxx.vw_dayscore AS (
-- First CTE (cal1): Calculate individual scores for each condition, including size, moisture, genetic purity, seed carbon, and room carbon
WITH cal2 AS (
WITH cal1 AS (
    SELECT
        a.seed_station_id,
        tester.tester_name,
        a.report_date,
        -- Calculate scores for size, moisture, genetic purity, and carbon conditions
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
        geneticpurity.condition_indicator_description,
        CASE 
            WHEN par.parameter_value < 0.2 THEN 2
            ELSE 1 
        END AS Score_seed_carbon,
        carbon1.condition_indicator_description,
        CASE 
            WHEN par2.parameter_value < 20 THEN 2 
            ELSE 1 
        END AS Score_room_carbon,
        carbon2.condition_indicator_description
    FROM 
        xxxxx.seed_stations_condition a
        LEFT JOIN xxxxx.testers tester ON tester.tester_id = a.tester_id
        LEFT JOIN xxxxx.condition_indicator size ON size.condition_indicator_id = A.size_condition
        LEFT JOIN xxxxx.condition_indicator moisture ON moisture.condition_indicator_id = A.moisture_condition
        LEFT JOIN xxxxx.condition_indicator geneticpurity ON geneticpurity.condition_indicator_id = A.genetic_purity_condition
        LEFT JOIN xxxxx.seed_stations s3 ON s3.seed_station_id = a.seed_station_id
        LEFT JOIN xxxxx.seed_storage s2 ON s2.seed_storage_id = s3.seed_storage_id
        LEFT JOIN xxxxx.vw_latest_parameters par ON par.parameter_type = 'carbon' AND par.parameter_subname = s2.seed_storage_name
        LEFT JOIN xxxxx.condition_indicator carbon1 ON carbon1.condition_indicator_id = (CASE WHEN par.parameter_value < 0.2 THEN 2 ELSE 1 END)
        LEFT JOIN xxxxx.post_harvest_storage s1 ON s1.post_harvest_storage_id = s2.post_harvest_storage_id
        LEFT JOIN xxxxx.parameters par2 ON par2.parameter_type = 'carbon' AND par2.parameter_subname = s1.post_harvest_storage_type
        LEFT JOIN xxxxx.condition_indicator carbon2 ON carbon2.condition_indicator_id = (CASE WHEN par2.parameter_value < 20 THEN 2 ELSE 1 END)
	)
--  Summarize total scores for each seed station based on report_date ranges
	select 
	c.seed_station_id,
	c.score_size + c.score_moisture + c.score_geneticpurity + c.Score_seed_carbon + c.Score_room_carbon as totalScore,
	c.report_date
	from cal1 c
)

	-- Final SELECT statement: Retrieve results from cal2
    SELECT 
        1 AS type, 'days 1-10' AS description, SUM(totalScore) AS totalScore
    FROM cal2
    WHERE 
        CAST(RIGHT(CAST(report_date AS TEXT), 2) AS INT) BETWEEN 1 AND 10
    
    UNION ALL
    
    SELECT 
        2 AS type, 'days 11-20' AS description, SUM(totalScore) AS totalScore
    FROM cal2
    WHERE 
        CAST(RIGHT(CAST(report_date AS TEXT), 2) AS INT) BETWEEN 11 AND 20
    
    UNION ALL
    
    SELECT 
        3 AS type, 'days 21-30' AS description, SUM(totalScore) AS totalScore
    FROM cal2
    WHERE 
        CAST(RIGHT(CAST(report_date AS TEXT), 2) AS INT) BETWEEN 21 AND 30
);

--====================================
