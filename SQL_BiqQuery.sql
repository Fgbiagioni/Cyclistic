#1. Making one whole dataset
--We are also including the new variables "ride_length" and "ride_length_minutes"

CREATE TABLE `true-eye-365718.Cyclistic2022.Cyclistic_complete_data` AS

SELECT *, (ended_at-started_at) as ride_length, DATE_DIFF(ended_at, started_at, second) AS ride_length_sec
FROM (
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-01`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-02`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-03`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-04`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-05-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-05-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-06-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-06-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-07-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-07-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-08-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-08-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-09-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-09-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-10-1`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-10-2`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-11`
  UNION ALL
  SELECT *
  FROM `true-eye-365718.Cyclistic2022.2022-12`

  ORDER BY started_at
)


#2. Creating a new table and adding the weekdays, months and minutes of a ride in a new table

CREATE TABLE `true-eye-365718.Cyclistic2022.Cyclistic_data2` AS 
SELECT ride_id, rideable_type, started_at,ended_at,start_station_name,end_station_name, member_casual, ride_length,ride_length_sec, ROUND((ride_length_sec/60),2) as ride_length_min,start_lat,start_lng,end_lat, end_lng,
  CASE 

  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 1 THEN 'Sunday' 
  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 2 THEN 'Monday' 
  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 3 THEN 'Tuesday' 
  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 4 THEN 'Wednesday' 
  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 5 THEN 'Thursday' 
  WHEN EXTRACT(DAYOFWEEK FROM started_at) = 6 THEN 'Friday' 

  ELSE'Saturday'  

  END AS week_day, 

  CASE 

  WHEN EXTRACT(MONTH FROM started_at) = 1 THEN 'January'
  WHEN EXTRACT(MONTH FROM started_at) = 2 THEN 'February'
  WHEN EXTRACT(MONTH FROM started_at) = 3 THEN 'March'
  WHEN EXTRACT(MONTH FROM started_at) = 4 THEN 'April'
  WHEN EXTRACT(MONTH FROM started_at) = 5 THEN 'May'
  WHEN EXTRACT(MONTH FROM started_at) = 6 THEN 'June'
  WHEN EXTRACT(MONTH FROM started_at) = 7 THEN 'July' 
  WHEN EXTRACT(MONTH FROM started_at) = 8 THEN 'August'
  WHEN EXTRACT(MONTH FROM started_at) = 9 THEN 'September'
  WHEN EXTRACT(MONTH FROM started_at) = 10 THEN 'October' 
  WHEN EXTRACT(MONTH FROM started_at) = 11 THEN 'November'
  ELSE 'December' 

  END AS month,

from `true-eye-365718.Cyclistic2022.Cyclistic_complete_data`

##CLEANING THE DATA##

--Looking for null values and erasing them
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` AS data2 
WHERE 
 
  ride_id IS NULL OR
  rideable_type IS NULL OR
  started_at IS NULL OR
  ended_at IS NULL OR
  start_station_name IS NULL OR
  end_station_name IS NULL OR
  member_casual IS NULL OR
  ride_length IS NULL OR
  ride_length_sec IS NULL OR
  ride_length_min IS NULL OR
  week_day IS NULL OR
  month IS NULL OR
  start_lat IS NULL OR
  start_lng IS NULL OR
  end_lat IS NULL OR
  end_lng IS NULL

DELETE FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` WHERE
  member_casual IS NULL OR
  end_station_name IS NULL OR
  start_station_name IS NULL OR
  end_lat IS NULL OR
  end_lng IS NULL
--This statement removed 1,298,311 rows from Cyclistic_data2

SELECT  Count(DISTINCT start_station_name) FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #1,553 obs

SELECT  Count(DISTINCT start_lat) FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #there are 721,566 obs
SELECT  Count(DISTINCT(ROUND(start_lat, 4))) FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #Now we have only 43

--Identifying potencial erros and fixing them
SELECT  DISTINCT ride_id FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #there is a total of 4,369,265 rows (after cleaning)
SELECT  COUNT(ride_id) FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` #we can confirm that there are no duplicates here (it counts 4,369,265)

SELECT   DISTINCT rideable_type FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #we can see that it is correct
SELECT   DISTINCT member_casual FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #there are some errors like "member;" and "casual;"

--fixing it:

UPDATE   `true-eye-365718.Cyclistic2022.Cyclistic_data2` SET   member_casual = "member" WHERE   member_casual = "member;";
UPDATE   `true-eye-365718.Cyclistic2022.Cyclistic_data2` SET   member_casual = "casual" WHERE   member_casual = "casual;"

SELECT DISTINCT member_casual FROM   `true-eye-365718.Cyclistic2022.Cyclistic_data2` #Now we only have member and casual.

#--or:

--UPDATE `true-eye-365718.Cyclistic2022.Cyclistic_data2`
--SET
  --member_casual = TRIM(member_casual)
--WHERE TRUE

#----

--Identifying negative values in ride length

SELECT ride_length, ride_length_min, ride_length_sec
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
ORDER BY ride_length ASC
--We can see that some values are negative, which doesn't make sense, as the difference between ended_at and started_at should be possitive.
SELECT ride_length, ride_length_min
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
WHERE ride_length_min < 0
ORDER BY ride_length_min
--There are 65 errors that need fixing (removing them)

--Fixing it:

DELETE FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` WHERE
  ride_length_min < 0
--We erased 65 rows

##ANALYZING DATA##

SELECT member_casual, COUNT(ride_id) as number_of_rides FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
GROUP BY member_casual
--We can see that, of the total rides made, 1,758,089 belong to casual cyclists and 2,611,111 belong to member cyclists.


#calculate average (mean) of ride_length
SELECT 
	AVG(ride_length_min) AS avg_ride_length
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
--17.1 minutes

#calculate the max value of ride_length
SELECT 
	Max(ride_length_min) AS max_ride_length
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
--34,354.07 minutes, or 572.57 hours

#calculate the "mode" (most frecuent value) of ride_length
SELECT APPROX_TOP_COUNT(ride_length_min, 1)[OFFSET(0)] AS most_frequent_value
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
--MODE: 5 minutes, COUNT: 68,497 rows

#average ride_length by member_casual
SELECT
	member_casual, AVG(ride_length_min) AS avg_length_member
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
GROUP BY member_casual
--Member: 12.45 minutes
--Casual: 23.99 minutes

#average ride_length by day_of_week by member_casual
SELECT 
	AVG(ride_length_min) AS avg_time, week_day
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
GROUP BY week_day

#Number of rides by weekday / in order to know which day of the week has more rides
SELECT 
	COUNT(DISTINCT ride_id) AS num_of_rides, week_day
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
GROUP BY week_day
ORDER BY num_of_rides DESC

#Number of rides by month / in order to know which month of the week has more rides
SELECT 
	COUNT(DISTINCT ride_id) AS num_of_rides, month
FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2`
GROUP BY month
ORDER BY num_of_rides DESC

###EXPORT DATA FOR VISUALIZATION###

EXPORT DATA OPTIONS(
  uri='gs://cyclistic2022dataset/Ciclystic2/*Ciclystic1.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=';') AS
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` LIMIT 1000000 

EXPORT DATA OPTIONS(
  uri='gs://cyclistic2022dataset/Ciclystic2/*Ciclystic2.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=';') AS
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` LIMIT 1000000 OFFSET 1000000

EXPORT DATA OPTIONS(
  uri='gs://cyclistic2022dataset/Ciclystic2/*Ciclystic3.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=';') AS
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` LIMIT 1000000 OFFSET 2000000

EXPORT DATA OPTIONS(
  uri='gs://cyclistic2022dataset/Ciclystic2/*Ciclystic4.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=';') AS
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` LIMIT 1000000 OFFSET 3000000

EXPORT DATA OPTIONS(
  uri='gs://cyclistic2022dataset/Ciclystic2/*Ciclystic5.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=';') AS
SELECT * FROM `true-eye-365718.Cyclistic2022.Cyclistic_data2` LIMIT 400000 OFFSET 4000000

