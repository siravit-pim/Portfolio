-- Source : https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations

/* Task 1 List the country that has more than average number of people taking vaccines in each observation day
recorded in the dataset among all countries. Each row in the result set must have the following structure. */
-- Create a Common Table Expression (CTE) named "AverageDailyVaccinations."
WITH AverageDailyVaccinations AS (
    -- Select the date and calculate the average daily vaccinations for each date.
    SELECT date,
        AVG(daily_people_vaccinated) AS average_daily_vaccinations
    FROM Vaccinations
    WHERE SUBSTR(location, 1, 2)  <> 'US'
    GROUP BY date
)
-- Select specific columns from the "Vaccinations" table for countries with daily vaccinations higher than the calculated average.
SELECT
    a.location AS "Country Name (CN)",
    a.total_vaccinations AS "Total Vaccinations (administered to date)",
    a.daily_vaccinations AS "Daily Vaccinations",
    a.date AS "Date"
FROM Vaccinations a
-- Join the "Vaccinations" table with the "AverageDailyVaccinations" CTE based on the date.
JOIN AverageDailyVaccinations adv ON a.date = adv.date
-- Filter the results to include only rows where daily_people_vaccinated is greater than average_daily_vaccinations.
WHERE a.daily_people_vaccinated > adv.average_daily_vaccinations
 and SUBSTR(location, 1, 2)  <> 'US';
/* ################################################# */

/* Task 2 Find the countries with more than the average cumulative numbers of COVID-19 doses administered by 
each country (Note: the result may include multiple countries or a single country). Produces a result set 
containing the name of each country and the cumulative number of doses administered in that country. Each row 
in the result set must have the following structure. */
-- Select the country and calculate the sum of daily vaccinations for each country.
SELECT
    a.location AS "Country",
    SUM(a.daily_vaccinations) AS "Cumulative Doses"
FROM Vaccinations a
WHERE SUBSTR(location, 1, 2)  <> 'US'
-- Group the results by the "location" column, which represents the country.
GROUP BY a.location;

/* ################################################# */

/* Task 3 Produce a list of countries with the vaccine types being taken in each country. For a country that has 
taken in multiple vaccine types, the result set is required to show several tuples reporting each vaccine types in a 
separate tuple. Each row in the result set must have the following structure. */
-- Create a recursive CTE named "split."
WITH RECURSIVE split(location, word, csv) AS (
    -- Initial part of the CTE: Split the "vaccines" column into the first word and the rest of the CSV.
    SELECT
        location,
        substr(vaccines, 0, instr(vaccines || ',', ',') - 1),
        substr(vaccines || ',', instr(vaccines || ',', ',') + 1)
    FROM locations
    
        UNION ALL
        
    -- Recursive part of the CTE: Continue splitting the CSV until it's empty.
    SELECT
        location,
        substr(csv, 0, instr(csv, ',') ),
        substr(csv, instr(csv, ',') + 1)
    FROM split
    WHERE csv != ''
)
-- Select and format the resulting data to show "Country" and "Vaccine Type."
SELECT 
    location AS 'Country', TRIM(SUBSTR(word, 1)) AS 'Vaccine Type'
FROM split
WHERE word != ''
-- Sort the results by "Location"
ORDER BY Location;

/* ################################################# */

/* Task 4 There are different data sources used to produce the dataset. Produce a report showing the biggest total 
number of vaccines administered in each country according to each data source (i.e., each unique URL). Order the 
result set by source name (URL). Each row in the result set must have the following structure. */
-- Create a Common Table Expression (CTE) named "z."
WITH z AS (
    -- Create another CTE named "vac" to calculate the total vaccinations per location.
    WITH vac AS (
        SELECT location, SUM(daily_vaccinations) AS 'totalVac'
        FROM vaccinations
        WHERE SUBSTR(location, 1, 2)  <> 'US'
        GROUP BY location
    )
    -- Select data from "locations" table, join it with "vaccinations," and calculate the "Biggest total Administered Vaccines."
    SELECT
        a.location AS 'Country',
        a.source_url AS 'Source Name (URL)',
        -- If value `total_vaccinations` is Null using `daily_vaccinations` instead
        CASE
            WHEN IFNULL(b.total_vaccinations, '') <> ''
            THEN b.total_vaccinations
            ELSE (SELECT totalVac FROM vac WHERE a.location = vac.location)
        END AS 'Biggest total Administered Vaccines',
        -- Calculate row numbers within each partition of "source_url."
        ROW_NUMBER() OVER (PARTITION BY a.source_url
            ORDER BY CASE
                WHEN IFNULL(b.total_vaccinations, '') <> ''
                THEN b.total_vaccinations
                ELSE (SELECT totalVac FROM vac WHERE a.location = vac.location)
            END DESC) AS 'rowNo'
    FROM locations a
    LEFT JOIN vaccinations b ON (a.location = b.location AND a.last_observation_date = b.date) and SUBSTR(b.location, 1, 2)  <> 'US'
)
-- Select columns "Country," "Source Name (URL)," and "Biggest total Administered Vaccines" from CTE "z" where rowNo is 1, ordered by "Source Name (URL)."
SELECT [Country], [Source Name (URL)], [Biggest total Administered Vaccines]
FROM z
WHERE rowNo = 1 -- Only Biggest total Administered Vaccines in each "Source Name (URL)"
-- Sort the results by "Source Name (URL)"
ORDER BY 2;

/* ################################################# */

/* Task 5 How do various countries compare in the speed of their vaccine administration? 
Produce a report that lists all the observation weeks in 2021 and 2022, and then for each week, list the total 
number of people fully vaccinated in each one of the 4 countries used in this assignment. */
-- Create a Common Table Expression (CTE) named "vac."
WITH vac as (
    SELECT
        -- Format the date as a WeekNumber, `Year-Month`.
        strftime('%Y-%W', [date]) AS WeekNumber,
        /* -- This for check date between StartDate and EndDate
        date([date], 'weekday 0', '-6 days') AS WeekStart,
        date([date], 'weekday 0') AS WeekEnd,
        */
        location,
        SUM(daily_people_vaccinated) as 'peopleVac'
    FROM Vaccinations
    WHERE [date] BETWEEN '2021-01-01' AND '2022-12-31'
        AND location IN ('Australia', 'Germany', 'England', 'France')
        AND daily_people_vaccinated > 0
    GROUP BY WeekNumber, location --, WeekStart, WeekEnd, 
)

-- Select and aggregate data based on the WeekNumber and locations.
SELECT
    WeekNumber AS [Date Range (Weeks)],
    -- Used Case when for show result some country
    SUM(CASE WHEN location = 'Australia' THEN peopleVac ELSE 0 END) AS 'Australia',
    SUM(CASE WHEN location = 'Germany' THEN peopleVac ELSE 0 END) AS 'Germany',
    SUM(CASE WHEN location = 'England' THEN peopleVac ELSE 0 END) AS 'England',
    SUM(CASE WHEN location = 'France' THEN peopleVac ELSE 0 END) AS 'France'
FROM vac
-- Group the results by WeekNumber to get weekly aggregates.
GROUP BY WeekNumber
-- Sort the results by WeekNumber.
ORDER BY WeekNumber;

/* ################################################# */
