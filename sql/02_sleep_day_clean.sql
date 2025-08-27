CREATE OR REPLACE TABLE `bellabeat-capstone-470220.BELLABEAT.sleep_day_clean` AS
WITH casted AS (
  SELECT
    CAST(Id AS STRING) AS Id,
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', CAST(SleepDay AS STRING)),
      CAST(SleepDay AS TIMESTAMP)
    ) AS sleep_ts,
    SAFE_CAST(TotalSleepRecords    AS INT64) AS total_sleep_records,
    SAFE_CAST(TotalMinutesAsleep   AS INT64) AS total_sleep_mins,
    SAFE_CAST(TotalTimeInBed      AS INT64) AS time_in_bed_mins   -- use the exact typo
  FROM `bellabeat-capstone-470220.BELLABEAT.sleepday_raw`
  WHERE CAST(SleepDay AS STRING) IS NOT NULL
),

by_day AS (
  SELECT
    Id,
    DATE(sleep_ts) AS d,
    SUM(total_sleep_mins) AS total_sleep_mins,
    SUM(time_in_bed_mins) AS time_in_bed_mins
  FROM casted
  GROUP BY Id, d
)

SELECT
  Id,
  d,
  total_sleep_mins,
  time_in_bed_mins,
  FORMAT_DATE('%A', d) AS dow
FROM by_day;
