CREATE DATABASE PROJECT;
USE PROJECT;
-- stations table--
create table stations(
StationId varchar(10) primary key,
StationName varchar(100),
City varchar(20),
State varchar(20),
Status varchar(20)
);

SHOW variables LIKE 'SECURE_FILE_PRIV';
SELECT * FROM STATIONS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stations.csv'
INTO TABLE stations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM stations;

-- station hour table--
create table station_hour(
StationId varchar(10) ,
Datetime date,
PM2_5 VARCHAR(50),
PM10 VARCHAR(50),
NO VARCHAR(50),
NO2 VARCHAR(50),
NOx VARCHAR(50),
NH3 VARCHAR(50),
CO VARCHAR(50),
SO2 VARCHAR(50),
O3 VARCHAR(50),
Benzene VARCHAR(50),
Toluene VARCHAR(50),
Xylene VARCHAR(50),
AQI varchar(10),
AQI_Bucket varchar(50),
foreign key(StationId) references stations(StationId));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/station_hour.csv'
INTO TABLE station_hour
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from station_hour;

-- table city hour--
create table city_hour(
City varchar(20) ,
Datetime date,
PM2_5 VARCHAR(50),
PM10 VARCHAR(50),
NO VARCHAR(50),
NO2 VARCHAR(50),
NOx VARCHAR(50),
NH3 VARCHAR(50),
CO VARCHAR(50),
SO2 VARCHAR(50),
O3 VARCHAR(50),
Benzene VARCHAR(50),
Toluene VARCHAR(50),
Xylene VARCHAR(50),
AQI varchar(10),
AQI_Bucket varchar(50));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/city_hour.csv'
INTO TABLE city_hour
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from city_hour
limit 10000;

-- table city day--
create table city_day(
City varchar(20) ,
Date date,
PM2_5 VARCHAR(50),
PM10 VARCHAR(50),
NO VARCHAR(50),
NO2 VARCHAR(50),
NOx VARCHAR(50),
NH3 VARCHAR(50),
CO VARCHAR(50),
SO2 VARCHAR(50),
O3 VARCHAR(50),
Benzene VARCHAR(50),
Toluene VARCHAR(50),
Xylene VARCHAR(50),
AQI varchar(10),
AQI_Bucket varchar(50));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/city_day.csv'
INTO TABLE city_day
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from city_day;

-- table station day--
create table station_day(
StationId varchar(10) ,
Date date,
PM2_5 VARCHAR(50),
PM10 VARCHAR(50),
NO VARCHAR(50),
NO2 VARCHAR(50),
NOx VARCHAR(50),
NH3 VARCHAR(50),
CO VARCHAR(50),
SO2 VARCHAR(50),
O3 VARCHAR(50),
Benzene VARCHAR(50),
Toluene VARCHAR(50),
Xylene VARCHAR(50),
AQI varchar(10),
AQI_Bucket varchar(50),
foreign key(StationId) references stations(StationId));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/station_day.csv'
INTO TABLE station_day
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from station_day;

# Quetions
-- 1.What is the total number of records in the AQI dataset?
SELECT COUNT(*) AS total_records
FROM station_hour;
SELECT COUNT(*) AS total_records
FROM city_hour;

-- 2.What is the average AQI value for each city?
SELECT city,ROUND(AVG(aqi), 2) AS avg_aqi
FROM city_hour
WHERE aqi IS NOT NULL
GROUP BY city
ORDER BY avg_aqi DESC;
    
-- 3.What is the maximum and minimum AQI recorded in the dataset?
SELECT MAX(aqi) AS max_aqi,MIN(aqi) AS min_aqi
FROM station_day
WHERE aqi IS NOT NULL;

SELECT MAX(aqi) AS max_aqi,MIN(aqi) AS min_aqi
FROM city_day
WHERE aqi IS NOT NULL;

SELECT MAX(aqi) AS max_aqi,MIN(aqi) AS min_aqi
FROM city_hour
WHERE aqi IS NOT NULL;

-- 4.Which city has the highest average AQI?
SELECT city,ROUND(AVG(aqi), 2) AS avg_aqi
FROM city_day
WHERE aqi IS NOT NULL
GROUP BY city
ORDER BY avg_aqi DESC
LIMIT 1;

-- 5.Which city has the lowest average AQI?
select city,avg(aqi) from city_day
group by city
order by city desc
limit 1;

-- 6.How many unique cities are included in the dataset?
select count(distinct city) as unique_city
 from stations;

-- 7.What is the distribution of AQI values for each city (using city as a group)?
select city,sum(aqi) as aqi_dist 
from city_day
group by city;

-- 8.Which year has the highest recorded AQI?
SELECT YEAR(date) AS year, max(aqi) AS max_aqi
FROM city_day
GROUP BY YEAR(date)
ORDER BY max_aqi desc
LIMIT 1;

-- 9.Which year has the lowest recorded AQI?
SELECT YEAR(date) AS year, MIN(aqi) AS min_aqi
FROM city_day
GROUP BY YEAR(date)
ORDER BY min_aqi ASC
LIMIT 1;

-- 10.What is the average AQI for each month across all years?
SELECT MONTH(date) AS month_number,round(AVG(aqi) ,2) AS average_aqi
FROM city_day
GROUP BY month_number
ORDER BY month_number;

-- 11.What is the total number of records for each air quality category (e.g., Good, Moderate, Unhealthy)?
select AQI_Bucket,count(*) as records from station_day
group by AQI_Bucket;
select AQI_Bucket,count(*) as records from city_day
group by AQI_Bucket;

-- 12.What is the percentage of days that have a 'Good' AQI across all cities?
SELECT ROUND(
        (SELECT COUNT(DISTINCT DATE(date)) 
         FROM city_day
         WHERE aqi BETWEEN 0 AND 50
        ) * 100.0 / 
        (SELECT COUNT(DISTINCT DATE(date)) 
         FROM city_day
        ), 2) AS good_aqi_percentage;

-- 13.How does the AQI change on a yearly basis for each city?
SELECT city,YEAR(date) AS year,ROUND(AVG(aqi), 2) AS avg_aqi
FROM city_day
GROUP BY city, YEAR(date)
ORDER BY city, year;
    
-- 14.What are the top 5 cities with the most days of "Unhealthy" AQI?
SELECT city,COUNT(DISTINCT DATE(date)) AS unhealthy_days
FROM city_day
WHERE aqi BETWEEN 151 AND 200
GROUP BY city
ORDER BY unhealthy_days DESC
LIMIT 5;

-- 15.Which months tend to have the worst air quality on average?
SELECT MONTH(date) AS month_number,
ROUND(AVG(aqi), 2) AS avg_aqi
FROM city_day
GROUP BY month_number
ORDER BY avg_aqi DESC
limit 1;

-- 16.What is the percentage of missing AQI data per city?
SELECT city,COUNT(*) AS total_records,SUM(aqi IS NULL) AS missing_aqi_count,
    ROUND(sum(aqi IS NULL) * 100.0 / COUNT(*), 2) AS missing_aqi_percentage
FROM city_hour
GROUP BY city
ORDER BY missing_aqi_percentage DESC;

-- 17.Find the cities where AQI has shown the most improvement 
-- (lower AQI) from the previous year.
WITH yearly_aqi AS (SELECT city,YEAR(date) AS year,AVG(aqi) AS avg_aqi FROM city_day
    GROUP BY city, YEAR(date)),
aqi_diff AS (
    SELECT curr.city,curr.year,curr.avg_aqi - prev.avg_aqi AS aqi_change
    FROM yearly_aqi curr
    JOIN yearly_aqi prev
	ON curr.city = prev.city AND curr.year = prev.year + 1)
SELECT city, year, aqi_change FROM aqi_diff
ORDER BY aqi_change ASC
LIMIT 10;

-- 18.For each air quality level, what is the average number of days that fall into each 
-- category in a year?
SELECT aqi, AVG(days_per_year) AS avg_days_per_year
FROM (
    SELECT
        YEAR(date) AS year,
        aqi,COUNT(*) AS days_per_year
    FROM city_day
    GROUP BY YEAR(date), aqi
) AS yearly_counts
GROUP BY aqi;

-- 19.What is the distribution of AQI values for each air quality level (e.g., Good, Moderate, Unhealthy)?
SELECT  AQI_Bucket , count(aqi) AS total_count FROM station_day WHERE aqi IS NOT NULL
GROUP BY AQI_Bucket
ORDER BY AQI_Bucket DESC;
