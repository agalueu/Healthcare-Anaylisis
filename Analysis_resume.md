# 📊 Analysis Summary

This document explains the analytical queries implemented in `sql/analysis.sql`, including their objectives, logic, and business insights.

---

## 1. Age & Gender Distribution

### 📝 Goal

Analyze patient distribution by age group and gender.

### ⚙️ Logic

* Use the demographic view to retrieve age, age group, and gender
* Group by age_group and gender
* Count total patients per segment

### 📊 Insight

Provides a demographic overview to support resource allocation and targeted healthcare planning.

Sample:
[Age & Gender Distribution](images/1_age_gender_distribution.png)

---

## 2. Most Common Conditions

### 📝 Goal

Identify the most frequently diagnosed conditions.

### ⚙️ Logic

* Count total condition records per description
* Count distinct patients per condition
* Compute average records per patient

### 📊 Insight

Highlights prevalent conditions and supports prioritization of treatments and preventive strategies.

Sample:
[Most Common Conditions](images/2_most_common_conditions.png)

---

## 3. Medication Frequency by Demographics

### 📝 Goal

Analyze prescription patterns by age group and gender.

### ⚙️ Logic

* Join medications with the demographic view
* Count total prescriptions and unique patients
* Group by medication, gender, and age group

### 📊 Insight

Reveals prescribing patterns and potential over- or under-utilization across demographic segments.

Sample:
[Medication Frequency](images/3_medication_frequency.png)

---

## 4. Hospital Stay Duration by Condition

### 📝 Goal

Evaluate hospital stay duration per condition.

### ⚙️ Logic

* Join encounters with conditions
* Filter valid timestamps and exclude extreme outliers (>365 days)
* Calculate average, minimum, and maximum stay duration

### 📊 Insight

Supports capacity planning and identifies conditions requiring higher resource utilization.

Sample:
[Hospital Stay](images/4_hospital_stay.png)

---

## 5. Medications by Geography

### 📝 Goal

Analyze medication distribution by city.

### ⚙️ Logic

* Count total prescriptions and unique patients per medication and city
* Calculate percentage of unique patients relative to total prescriptions

### 📊 Insight

Reveals geographic prescribing patterns and supports regional healthcare planning.

Sample:
[Geography](images/5_medications_geography.png)

---

## 6. Procedures by City

### 📝 Goal

Identify procedure demand relative to city population.

### ⚙️ Logic

* Count distinct patients per procedure per city
* Compute total population per city
* Normalize usage as a percentage

### 📊 Insight

Highlights location-based healthcare demand and supports resource allocation.

Sample:
[Procedures](images/6_common_procedures.png)

---

## 7. Year-over-Year Growth (Conditions)

### 📝 Goal

Track condition trends over time by age group.

### ⚙️ Logic

* Compute yearly patient percentages per condition
* Use LAG() to retrieve previous year values
* Calculate growth rate

### 📊 Insight

Enables trend analysis and supports proactive healthcare planning.

Sample:
[YoY Growth](images/7_YoY.png)
