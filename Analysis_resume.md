In this section I´m going to talk about some results in the different queries that i did in the [Query Analysis](sql/Analysis.sql) file, what was the purpose, steps to do it and business insight for this analysis

# 1. Age & Gender Distribution
### 📝 Query Goal
To analyze the distribution of patients by age group and gender.

### ⚙️ Steps / Logic
- Use the demographic view to get patient age, age group, and gender.
- GROUP BY age_group, gender → counts the number of patients per combination.
- ORDER BY age_group → displays age groups in ascending order.

### 📊 Business Insights
- Shows patient demographics for hospital planning and resource allocation.
- Helps identify age or gender segments that require specialized care.

Sample img: [Age & Gender Distribution](images/1_age_gender_distribution.png)

# 2. Most Common Conditions
### 📝 Query Goal
To identify the most frequently diagnosed conditions across patients.

### ⚙️ Steps / Logic
- Count all condition records per description.
- Count distinct patients per condition.
- Calculate average records per patient (COUNT(condition_id) / COUNT(DISTINCT patient_id)).
- ORDER BY condition_counter DESC → most common conditions first.

### 📊 Business Insights
- Highlights prevalent conditions for population health management.
- Supports prioritization of treatments, staff, and medication stock.
- Can guide preventive healthcare strategies.

Sample img: [Most Common Conditions](images/2_most_common_conditions.png)

# 3. Medication Frequency by Age Group & Gender
### 📝 Query Goal
To determine how frequently medications are prescribed across age groups and genders.

### ⚙️ Steps / Logic
- Join medications table with the demographic view.
- Count total prescriptions (COUNT(*)) and unique patients (COUNT(DISTINCT patient_id)).
- Calculate percentage of unique patients per medication.
- Group by medication, gender, and age group.

### 📊 Business Insights
- Reveals prescribing patterns by demographic segments.
- Helps identify over- or under-prescribed medications.
- Useful for targeted patient education or intervention programs.

Sample img: [Medication Frequency by Age Group & Gender](images/3_medication_frequency.png)

# 4. Hospital Stay Duration by Condition
### 📝 Query Goal
To analyze the average, minimum, and maximum hospital stay per patient per condition.

### ⚙️ Steps / Logic
- Filter encounters with valid start and stop times, excluding extreme outliers (>365 days).
- Calculate avg_stay_days, min_stay_days, max_stay_days using EXTRACT(EPOCH FROM (stop - start)) / 86400.
- Group by patient and condition to get per-patient averages.

### 📊 Business Insights
- Highlights conditions that require longer hospitalizations.
- Supports capacity planning, staffing, and resource allocation.
- Helps identify unusual cases that may need further investigation.

Sample img: [Hospital Stay Duration by Condition](images/4_hospital_stay.png)

# 5. Medications by Geography (City)
### 📝 Query Goal
To analyze medication prescriptions by city and their proportion of total prescriptions.

### ⚙️ Steps / Logic
- Count unique patients and total prescriptions per medication per city.
- Calculate the percentage of unique prescriptions relative to total prescriptions.
- Use CTEs (table_1 & table_2) to organize numerator and denominator.

### 📊 Business Insights
- Reveals geographic patterns in medication usage.
- Supports distribution planning and local pharmacy stock management.
- Helps identify city-specific healthcare trends.

Sample img: [Medications by Geography](images/5_medications_geography.png)

# 6. Common Procedures by City
### 📝 Query Goal
To determine which procedures are most common in each city relative to the population.

### ⚙️ Steps / Logic
- Count distinct patients per procedure per city (table_1).
- Count total patients per city (table_2).
- Calculate percentage of patients receiving each procedure (unique_patients / population).

### 📊 Business Insights
- Shows procedure demand per location.
- Supports city-level healthcare resource allocation.
- Helps identify localized health trends or procedure requirements.

Sample img: [Common Procedures by City](images/6_common_procedures.png)

# 7. Year-over-Year Growth per Condition (by Age Group)
### 📝 Query Goal
To track the year-over-year growth of conditions per age group.

### ⚙️ Steps / Logic
- patient_age_group CTE → calculate total patients per age group (denominator).
- total CTE → count unique patients per condition per year and age group; calculate percentage.
- ranked CTE → get previous year’s percentage using LAG().
- Final SELECT → calculate growth as (pct_patients - previous_pct) / previous_pct * 100.

### 📊 Business Insights
- Tracks trends in condition prevalence over time.
- Highlights conditions that are increasing or decreasing per demographic.
- Supports proactive healthcare interventions, resource planning, and longitudinal studies.

Sample img: [Year-over-Year Growth per Condition ](images/7_YoY.png)
