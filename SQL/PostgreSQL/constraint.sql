BEGIN;

-- Enforcing CONSTRAINTS on the post_harvest_storage table
ALTER TABLE xxxxx.post_harvest_storage
    ADD PRIMARY KEY (post_harvest_storage_id),
    ADD CONSTRAINT unique_post_harvest_storage_name UNIQUE (post_harvest_storage_name),
    ADD CONSTRAINT check_post_harvest_storage_type CHECK (post_harvest_storage_type IN ('room_temperature_storage', 'cool_storage'));
	
--=============================

-- Enforcing CONSTRAINTS on the seed_storage table
ALTER TABLE xxxxx.seed_storage
    ADD PRIMARY KEY (seed_storage_id),
    ADD FOREIGN KEY (post_harvest_storage_id) REFERENCES xxxxx.post_harvest_storage(post_harvest_storage_id),
    ADD CONSTRAINT unique_seed_storage_name UNIQUE (seed_storage_name),
    ADD CONSTRAINT check_seed_storage_type CHECK (seed_storage_type IN ('strong_seed', 'medium_seed', 'fragile_seed'));
	
--=============================

-- Enforcing CONSTRAINTS on the seed_stations table
ALTER TABLE xxxxx.seed_stations
	ADD PRIMARY KEY (seed_station_id),
    ADD FOREIGN KEY (seed_storage_id) REFERENCES xxxxx.seed_storage(seed_storage_id),
    ADD CONSTRAINT unique_location UNIQUE (location);

--=============================

-- Enforcing CONSTRAINTS on the testers table
ALTER TABLE xxxxx.testers
	ADD PRIMARY KEY (tester_id),
    ADD CONSTRAINT unique_tester_name UNIQUE (tester_name);

--=============================

-- Enforcing CONSTRAINTS on the condition_indicator table
ALTER TABLE xxxxx.condition_indicator
	ADD PRIMARY KEY (condition_indicator_id),
    ADD CONSTRAINT unique_condition_indicator_description UNIQUE (condition_indicator_description);
	
--=============================

-- Enforcing CONSTRAINTS on the seed_storage_condition table
ALTER TABLE xxxxx.seed_storage_condition
    ADD PRIMARY KEY (seed_storage_condition_id),
    ADD FOREIGN KEY (seed_storage_id) REFERENCES xxxxx.seed_storage(seed_storage_id),
	ADD FOREIGN KEY (tester_id) REFERENCES xxxxx.testers(tester_id),
	ADD FOREIGN KEY (temperature_condition) REFERENCES xxxxx.condition_indicator(condition_indicator_id),
    ADD CONSTRAINT seed_storage_tester_report UNIQUE (seed_storage_id, tester_id, report_date);
	
--=============================

-- Enforcing CONSTRAINTS on the seed_stations_condition table
ALTER TABLE xxxxx.seed_stations_condition
    ADD PRIMARY KEY (seed_stations_condition_id),
	ADD FOREIGN KEY (seed_station_id) REFERENCES xxxxx.seed_stations(seed_station_id),
	ADD FOREIGN KEY (size_condition) REFERENCES xxxxx.condition_indicator(condition_indicator_id),
	ADD FOREIGN KEY (moisture_condition) REFERENCES xxxxx.condition_indicator(condition_indicator_id),
	ADD FOREIGN KEY (genetic_purity_condition) REFERENCES xxxxx.condition_indicator(condition_indicator_id),
	ADD FOREIGN KEY (tester_id) REFERENCES xxxxx.testers(tester_id),
	ADD CONSTRAINT unique_seed_station_tester_report UNIQUE (seed_station_id, tester_id, report_date);
	
--=============================

-- Enforcing CONSTRAINTS on the parameters table
ALTER TABLE xxxxx.parameters
	ADD PRIMARY KEY (parameter_id),
	ADD CONSTRAINT unique_parameter_combination UNIQUE (parameter_type, parameter_name, parameter_subname);

--=============================

END;
