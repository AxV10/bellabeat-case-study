CREATE OR REPLACE TABLE `bellabeat-capstone-470220.BELLABEAT.hourly_intensities_clean` AS
WITH casted AS (
  SELECT
    CAST(Id AS STRING) AS Id,
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', CAST(ActivityHour AS STRING)),
      CAST(ActivityHour AS TIMESTAMP)
    ) AS activity_ts,
    SAFE_CAST(TotalIntensity   AS INT64)    AS TotalIntensity,
    SAFE_CAST(AverageIntensity AS FLOAT64)  AS AverageIntensity
  FROM `bellabeat-capstone-470220.BELLABEAT.hourly_intensities_raw`
  WHERE ActivityHour IS NOT NULL
    AND SAFE_CAST(TotalIntensity   AS INT64)   IS NOT NULL
    AND SAFE_CAST(AverageIntensity AS FLOAT64) IS NOT NULL
),
ranked AS (
  SELECT
    Id, activity_ts, TotalIntensity, AverageIntensity,
    ROW_NUMBER() OVER (PARTITION BY Id, activity_ts ORDER BY TotalIntensity DESC) AS rn
  FROM casted
)
SELECT
  Id,
  activity_ts,
  DATE(activity_ts) AS d,
  EXTRACT(HOUR FROM activity_ts) AS hr,
  TotalIntensity, AverageIntensity
FROM ranked
WHERE rn = 1;

