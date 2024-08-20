BEGIN;

-- Inserts value for 'post_harvest_storage' table
INSERT INTO xxxxx.post_harvest_storage (post_harvest_storage_id, post_harvest_storage_name, post_harvest_storage_type, built_date, location)
VALUES 
    (1, 'a', 'room_temperature_storage', '2023-01-01', ST_Extrude(ST_GeomFromText('POLYGON ((384150 478450 0, 384450 478450 0, 384600 478750 0, 384300 478750 0, 384150 478450 0))', 27700), 0, 0, 150)),
    (2, 'b', 'cool_storage', '2023-12-31', ST_Extrude(ST_GeomFromText('POLYGON ((384650 478450 0, 384950 478450 0, 385100 478750 0, 384800 478750 0, 384650 478450 0))', 27700), 0, 0, 150));

--=============================

-- Inserts for 'seed_storage' table
INSERT INTO xxxxx.seed_storage (seed_storage_id, post_harvest_storage_id, seed_storage_name, seed_storage_type, location)
VALUES
    (
        1,
        (
            SELECT post_harvest_storage_id 
            FROM xxxxx.post_harvest_storage b 
            WHERE ST_3Dintersects(b.location, 
            ST_GeomFromText('POLYGON ((384650 478450 0, 384950 478450 0, 385100 478750 0, 384800 478750 0, 384650 478450 0))', 27700))
        ),
        'flax', 'medium_seed',
        ST_Extrude(ST_GeomFromText('POLYGON((384650 478450 0, 384800 478450 0, 384950 478750 0, 384800 478750 0, 384650 478450 0))', 27700), 0, 0, 75)
    ),
	 (
        2,
        (
            SELECT post_harvest_storage_id 
            FROM xxxxx.post_harvest_storage b 
            WHERE ST_3Dintersects(b.location, 
            ST_GeomFromText('POLYGON ((384150 478450 0, 384450 478450 0, 384600 478750 0, 384300 478750 0, 384150 478450 0))', 27700))
        ),
        'chia', 'strong_seed',
        ST_Extrude(ST_GeomFromText('POLYGON ((384150 478450 0, 384300 478450 0, 384450 478750 0, 384300 478750 0, 384150 478450 0))', 27700), 0, 0, 75)
    ),
	(
        3,
        (
            SELECT post_harvest_storage_id 
            FROM xxxxx.post_harvest_storage b 
            WHERE ST_3Dintersects(b.location, 
            ST_GeomFromText('POLYGON ((384650 478450 0, 384950 478450 0, 385100 478750 0, 384800 478750 0, 384650 478450 0))', 27700))
        ),
        'sunflower', 'fragile_seed',
       ST_Extrude(ST_GeomFromText('POLYGON ((384800 478450 0, 384950 478450 0, 385100 478750 0, 384950 478750 0, 384800 478450 0))', 27700), 0, 0, 75)
    );


--=============================

-- Inserts for 'seed_stations' table

-- Inserts for 'seed_stations' table
INSERT INTO xxxxx.seed_stations
    (seed_station_id, seed_storage_id, location)
VALUES
    (
        1,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON((384650 478450 0, 384800 478450 0, 384950 478750 0, 384800 478750 0, 384650 478450 0))', 27700)) 
            LIMIT 1
        ),
        ST_GeomFromText('POINT (384750 478500)', 27700)
    ),
    (
        2,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON((384650 478450 0, 384800 478450 0, 384950 478750 0, 384800 478750 0, 384650 478450 0))', 27700)) 
            LIMIT 1
        ),
        ST_GeomFromText('POINT (384700 478600)', 27700)
    ),
    (
        3,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384150 478450 0, 384300 478450 0, 384450 478750 0, 384300 478750 0, 384150 478450 0))', 27700))
        ),
        ST_GeomFromText('POINT (384200 478500)', 27700)
    ),
    (
        4,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384150 478450 0, 384300 478450 0, 384450 478750 0, 384300 478750 0, 384150 478450 0))', 27700))
        ),
        ST_GeomFromText('POINT (384250 478600)', 27700)
    ),
    (
        5,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384150 478450 0, 384300 478450 0, 384450 478750 0, 384300 478750 0, 384150 478450 0))', 27700))
        ),
        ST_GeomFromText('POINT (384275 478550)', 27700)
    ),
    (
        6,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384800 478450 0, 384950 478450 0, 385100 478750 0, 384950 478750 0, 384800 478450 0))', 27700)) 
            ORDER BY 1 DESC LIMIT 1
        ),
        ST_GeomFromText('POINT (384900 478500)', 27700)
    ),
    (
        7,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384800 478450 0, 384950 478450 0, 385100 478750 0, 384950 478750 0, 384800 478450 0))', 27700)) 
            ORDER BY 1 DESC LIMIT 1
        ),
        ST_GeomFromText('POINT (384850 478700)', 27700)
    ),
    (
        8,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384800 478450 0, 384950 478450 0, 385100 478750 0, 384950 478750 0, 384800 478450 0))', 27700)) 
            ORDER BY 1 DESC LIMIT 1
        ),
        ST_GeomFromText('POINT (384875 478650)', 27700)
    ),
    (
        9,
        (
            SELECT seed_storage_id 
            FROM xxxxx.seed_storage b 
            WHERE ST_3Dintersects(b.location, ST_GeomFromText('POLYGON ((384800 478450 0, 384950 478450 0, 385100 478750 0, 384950 478750 0, 384800 478450 0))', 27700)) 
            ORDER BY 1 DESC LIMIT 1
        ),
        ST_GeomFromText('POINT (384925 478600)', 27700)
    );


--=============================

-- Inserts for 'testers' table
INSERT INTO xxxxx.testers (tester_id, tester_name)
VALUES 
    (1, 'Peter'),
    (2, 'Alice'),
    (3, 'John'),
    (4, 'Emma'),
    (5, 'James'),
    (6, 'William');
	
--=============================

-- Inserts for 'condition_indicator' table
INSERT INTO xxxxx.condition_indicator (condition_indicator_id, condition_indicator_description)
VALUES 
    (1, 'most_suitable'),
    (2, 'suitable'),
    (3, 'not_suitable');
	
--=============================

--seed_storage_condition
INSERT INTO xxxxx.seed_storage_condition (seed_storage_condition_id, seed_storage_id, temperature_condition, tester_id, report_date)
VALUES 
    (1, 1, 3, 1, '2023-05-15'),
    (2, 2, 2, 2, '2023-05-01'),
    (3, 3, 1, 3, '2023-05-31'),
    (4, 1, 1, 4, '2023-05-15'),
    (5, 2, 2, 5, '2023-05-01'),
    (6, 3, 3, 6, '2023-05-31');

--=============================

-- Inserts for 'seed_stations_condition' table
INSERT INTO xxxxx.seed_stations_condition (seed_station_id, size_condition, moisture_condition, genetic_purity_condition, tester_id, report_date)
VALUES 
    (1, 1, 1, 1, 1, '2023-08-31'),
    (2, 1, 2, 2, 2, '2023-08-15'),
    (3, 1, 3, 3, 3, '2023-08-01'),
    (4, 2, 1, 1, 4, '2023-08-30'),
    (5, 2, 2, 2, 5, '2023-08-14'),
    (6, 2, 3, 3, 6, '2023-08-02'),
    (7, 3, 1, 1, 1, '2023-08-29'),
    (8, 3, 2, 2, 4, '2023-08-13'),
    (9, 3, 3, 3, 3, '2023-08-03');

--=============================	

-- Inserts for 'parameters' table
INSERT INTO xxxxx.parameters
(parameter_id, parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
VALUES
	(101, 'cost', 'post_harvest_storage', 'room_temperature_storage', 1000, '£ per sq m'),
	(102, 'cost', 'post_harvest_storage', 'cool_storage', 1500, '£ per sq m'),
	(103, 'size', 'post_harvest_storage', 'room_temperature_storage', 180000, 'sq m'),
	(104, 'size', 'post_harvest_storage', 'cool_storage', 180000, 'sq m'),
	(105, 'carbon', 'post_harvest_storage', 'room_temperature_storage', 25, 'metric tons CO2 per year'),
	(106, 'carbon', 'post_harvest_storage', 'cool_storage', 20, 'metric tons CO2 per year'),
	(201, 'planting cost', 'seed_storage', 'flax', 0.5, '£ each'),
	(202, 'planting cost', 'seed_storage', 'chia', 1.0, '£ each'),
	(203, 'planting cost', 'seed_storage', 'sunflower', 2.5, '£ each'),
	(204, 'survivability', 'seed_storage', 'strong_seed', 75, 'percent'),
	(205, 'survivability', 'seed_storage', 'medium_seed', 50, 'percent'),
	(206, 'survivability', 'seed_storage', 'fragile_seed', 25, 'percent'),
	(207, 'distance', 'seed_storage', 'flax', 1, 'sq m'),
	(208, 'distance', 'seed_storage', 'chia', 1, 'sq m'),
	(209, 'distance', 'seed_storage', 'sunflower', 2, 'sq m'),
	(210, 'seed size', 'seed_storage', 'flax', 0.1, 'sq m'),
	(211, 'seed size', 'seed_storage', 'chia', 0.2, 'sq m'),
	(212, 'seed size', 'seed_storage', 'sunflower', 0.2, 'sq m'),
    (213, 'carbon', 'seed_storage', 'flax', 0.2, 'metric tons CO2 per seed'),
	(214, 'carbon', 'seed_storage', 'chia', 0.1, 'metric tons CO2 per seed'),
	(215, 'carbon', 'seed_storage', 'sunflower', 0.1, 'metric tons CO2 per seed'),
    (216, 'cost', 'seed_stations', 'water', 0.1, '£ per sq m'),
	(217, 'cost', 'seed_stations', 'electrical', 0.2, '£ per sq m');
    
    
--=============================		 

END;
