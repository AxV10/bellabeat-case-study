CREATE OR REPLACE TABLE `bellabeat-capstone-470220.BELLABEAT.daily_activity_clean` AS
WITH casted AS (
  SELECT
    CAST(Id AS STRING) AS Id,
    CAST(ActivityDate AS DATE) AS activity_date,
    SAFE_CAST(TotalSteps AS INT64) AS TotalSteps,
    SAFE_CAST(TotalDistance AS FLOAT64) AS TotalDistance,
    SAFE_CAST(TrackerDistance AS FLOAT64) AS TrackerDistance,
    SAFE_CAST(LoggedActivitiesDistance AS FLOAT64) AS LoggedActivitiesDistance,
    SAFE_CAST(VeryActiveDistance AS FLOAT64) AS VeryActiveDistance,
    SAFE_CAST(ModeratelyActiveDistance AS FLOAT64) AS ModeratelyActiveDistance,
    SAFE_CAST(LightActiveDistance AS FLOAT64) AS LightActiveDistance,
    SAFE_CAST(SedentaryActiveDistance AS FLOAT64) AS SedentaryActiveDistance,
    SAFE_CAST(VeryActiveMinutes AS INT64) AS VeryActiveMinutes,
    SAFE_CAST(FairlyActiveMinutes AS INT64) AS FairlyActiveMinutes,
    SAFE_CAST(LightlyActiveMinutes AS INT64) AS LightlyActiveMinutes,
    SAFE_CAST(SedentaryMinutes AS INT64) AS SedentaryMinutes,
    SAFE_CAST(Calories AS INT64) AS Calories
  FROM `bellabeat-capstone-470220.BELLABEAT.dailyactivity_raw`
),
with_helpers AS (
  SELECT
    *,
    IFNULL(VeryActiveMinutes,0)+IFNULL(FairlyActiveMinutes,0)+IFNULL(LightlyActiveMinutes,0) AS active_mins,
    FORMAT_DATE('%A', activity_date) AS dow
  FROM casted
  WHERE (TotalSteps IS NULL OR TotalSteps >= 0)
    AND (Calories  IS NULL OR Calories  >= 0)
),
dedup AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, activity_date ORDER BY Calories DESC) rn
  FROM with_helpers
)
SELECT * EXCEPT(rn) FROM dedup WHERE rn = 1;

