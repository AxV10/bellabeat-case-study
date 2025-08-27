CREATE OR REPLACE TABLE `bellabeat-capstone-470220.BELLABEAT.weight_log_clean` AS
WITH casted AS (
  SELECT
    CAST(Id AS STRING) AS Id,
    -- Sleep/weight timestamps can be text or already TIMESTAMP; handle both:
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', CAST(Date AS STRING)),
      CAST(Date AS TIMESTAMP)
    ) AS wt_ts,
    SAFE_CAST(WeightKg AS FLOAT64)       AS WeightKg,
    SAFE_CAST(BMI AS FLOAT64)            AS BMI,
    SAFE_CAST(IsManualReport AS BOOL)    AS IsManualReport,
    SAFE_CAST(Fat AS INT64)              AS Fat
  FROM `bellabeat-capstone-470220.BELLABEAT.weight_raw`
  WHERE Date IS NOT NULL
),
ranked AS (
  -- keep the latest log per (Id, date)
  SELECT
    Id,
    DATE(wt_ts) AS d,
    wt_ts, WeightKg, BMI, IsManualReport, Fat,
    ROW_NUMBER() OVER (PARTITION BY Id, DATE(wt_ts) ORDER BY wt_ts DESC) AS rn
  FROM casted
)
SELECT
  Id, d, wt_ts, WeightKg, BMI, IsManualReport, Fat,
  FORMAT_DATE('%A', d) AS dow
FROM ranked
WHERE rn = 1;
