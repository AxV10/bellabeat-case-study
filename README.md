# Bellabeat Case Study — Usage Patterns → Actions

Goal: Analyze Fitbit data (30 users, CC0) to uncover activity & sleep patterns and turn them into actionable recommendations for Bellabeat products.

Stack: BigQuery (SQL), Excel/Sheets, Tableau

---

## 📂 Repository Structure

---

## 🧹 Data Prep (BigQuery)
Key tables:
- `daily_activity_clean` — parsed dates, deduped, helpers (active_mins, dow)
- `sleep_day_clean` — parsed timestamps, daily totals, weekday
- `hourly_steps_clean` — hourly steps with date/hour features
- `hourly_intensities_clean` — hourly intensity features
- `daily_analytic` — daily_activity_clean LEFT JOIN sleep_day_clean

See `sql/` folder for the exact `CREATE OR REPLACE TABLE` scripts.

---

## 📊 Dashboard (Tableau)
Charts
1. Average steps by weekday (bar)  
2. Steps vs Calories (scatter + linear trend)  
3. Sleep vs Steps (scatter + linear trend; sparse due to missing sleep logs)  
4. Average steps by hour (line, 0–23)

> Note on sleep: The public dataset has few sleep entries → Graph C is sparse by design.

---

## 🔎 Key Findings
- Weekday activity: Wednesday & Saturday lead; Tuesday is lowest.
- Steps - Calories: Strong positive relationship.
- Sleep - Steps: Slight negative trend; <6h sleepers average fewer steps.
- Hourly rhythm: Peaks around 12–1 pm and 6–8 pm.

---

## ✅ Recommendations (Leaf example)
- Send activity nudges 30–60 min before peaks (11:30 am & 5:30 pm).
- Launch Wednesday/Weekend challenges aligned with natural highs.
- Add bedtime reminders & gentle alarms for <6h sleepers.
- Trigger sedentary alerts after 120 min inactivity.
- Promote premium coaching tied to peak engagement times.

---

## ⚠️ Limitations
Small sample (30 users), biased demographics, limited timeframe, sparse sleep logs. Treat insights as directional.

---

## ▶️ Reproduce
1. Upload raw CSVs to BigQuery (safe schema as STRINGs).
2. Run SQL in `sql/` to create `*_clean` tables and `daily_analytic`.
3. Export `agg_by_dow`, `hourly_profile`, and `daily_analytic` to CSV.
4. Build the 4 Tableau charts and assemble the dashboard.

---

## 📄 License
- Code & write-up: MIT  
- Data: Fitbit Kaggle dataset — CC0 (public domain)
