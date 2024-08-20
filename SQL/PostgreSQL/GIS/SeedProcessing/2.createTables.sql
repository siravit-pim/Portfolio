BEGIN;
DROP SCHEMA IF EXISTS xxxxx CASCADE;

CREATE SCHEMA xxxxx;


-- Creating the 'post_harvest_storage' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..post_harvest_storage (
    post_harvest_storage_id serial NOT NULL,
    post_harvest_storage_name text NOT NULL,
    post_harvest_storage_type text NOT NULL,
    built_date date NOT NULL
);

-- Adding a geometry column 'location' to 'post_harvest_storage' table
SELECT AddGeometryColumn(
    'xxxxx.', 'post_harvest_storage', 'location', 27700, 'geometry', 3
);

--=============================

-- Creating the 'seed_storage' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..seed_storage (
    seed_storage_id serial NOT NULL,
    post_harvest_storage_id serial NOT NULL,
    seed_storage_name text NOT NULL,
    seed_storage_type text NOT NULL
);

-- Adding a geometry column 'location' to 'seed_storage' table
SELECT AddGeometryColumn(
    'xxxxx.', 'seed_storage', 'location', 27700, 'geometry', 3
);

--=============================

-- Creating the 'seed_stations' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..seed_stations (
    seed_station_id serial NOT NULL,
    seed_storage_id serial NOT NULL
);

-- Adding a geometry column 'location' to 'seed_stations' table
SELECT AddGeometryColumn(
    'xxxxx.', 'seed_stations', 'location', 27700, 'geometry', 2
);

--=============================

-- Creating the 'seed_storage_condition' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..seed_storage_condition (
    seed_storage_condition_id serial NOT NULL,
    seed_storage_id serial NOT NULL,
    temperature_condition serial NOT NULL,
    tester_id serial NOT NULL,
    report_date date NOT NULL
);

--=============================

-- Creating the 'seed_stations_condition' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..seed_stations_condition (
    seed_stations_condition_id serial NOT NULL,
    seed_station_id serial NOT NULL,
    size_condition serial NOT NULL,
    moisture_condition serial NOT NULL,
    genetic_purity_condition serial NOT NULL,
    tester_id serial NOT NULL,
    report_date date NOT NULL
);

--=============================

-- Creating the 'testers' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..testers (
    tester_id serial NOT NULL,
    tester_name text NOT NULL
);

--=============================

-- Creating the 'condition_indicator' table with columns and constraints
CREATE TABLE IF NOT EXISTS xxxxx..condition_indicator (
    condition_indicator_id serial NOT NULL,
    condition_indicator_description text NOT NULL
);

--=============================

CREATE TABLE IF NOT EXISTS xxxxx..parameters (
    parameter_id serial NOT NULL,
    parameter_type text NOT NULL,
    parameter_name text NOT NULL,
    parameter_subname text NOT NULL,
    parameter_value double precision NOT NULL,
    parameter_units text NOT NULL,
    date_created date DEFAULT CURRENT_DATE
);

END;
