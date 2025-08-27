CREATE OR REPLACE TABLE `bellabeat-capstone-470220.BELLABEAT.hourly_steps_clean` AS
WITH casted AS (
  SELECT
    CAST(Id AS STRING) AS Id,
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', CAST(ActivityHour AS STRING)),
      CAST(ActivityHour AS TIMESTAMP)
    ) AS activity_ts,
    SAFE_CAST(StepTotal AS INT64) AS StepTotal
  FROM `bellabeat-capstone-470220.BELLABEAT.hourlysteps_raw`
  WHERE ActivityHour IS NOT NULL
    AND SAFE_CAST(StepTotal AS INT64) IS NOT NULL
),
ranked AS (
  -- de-dupe exact timestamp per user
  SELECT
    Id, activity_ts, StepTotal,
    ROW_NUMBER() OVER (PARTITION BY Id, activity_ts ORDER BY StepTotal DESC) AS rn
  FROM casted
)
SELECT
  Id,
  activity_ts,
  DATE(activity_ts) AS d,
  EXTRACT(HOUR FROM activity_ts) AS hr,
  StepTotal
FROM ranked
WHERE rn = 1;
