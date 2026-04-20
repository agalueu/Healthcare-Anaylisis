/* 
This script contains analytical queries built on top of a reusable demographic view.
The view simplifies joins by centralizing patient attributes such as age, age group, gender, and city.
*/

-- =========================================
-- DEMOGRAPHIC VIEW
-- =========================================
CREATE OR REPLACE VIEW demographic AS
WITH age AS (
    SELECT  patient_id,
            city,
            gender,
            CASE
                WHEN deathdate IS NOT NULL THEN EXTRACT(YEAR FROM AGE(deathdate, birthdate))
                ELSE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))
            END AS age
    FROM patients
),
age_groups AS (
    SELECT *,
           CASE
               WHEN age BETWEEN 0 AND 18 THEN '0-18'
               WHEN age BETWEEN 19 AND 35 THEN '19-35'
               WHEN age BETWEEN 36 AND 50 THEN '36-50'
               WHEN age BETWEEN 51 AND 65 THEN '51-65'
               WHEN age > 65 THEN '65+'
           END AS age_group
    FROM age
)
SELECT patient_id AS patient_id,
       gender,
       age,
       age_group,
       city
FROM age_groups;

-- =========================================
-- 1. Age & Gender Distribution
-- =========================================
SELECT  age_group,
        gender,
        COUNT(patient_id) AS total_patients
FROM demographic
GROUP BY age_group, gender
ORDER BY age_group;

-- =========================================
--2. What are the most common conditions diagnosed across patients?
-- =========================================
SELECT  COUNT(condition_id) AS condition_counter,
		description,
		COUNT(DISTINCT patient_id) AS patients_per_condition,
		ROUND(COUNT(condition_id)::DECIMAL/COUNT(DISTINCT patient_id), 2) AS avg_record_per_patient
FROM conditions
GROUP BY description
ORDER BY condition_counter DESC;


-- =========================================
--3. Medication frequency by age group & gender
-- =========================================
SELECT  m.description,
        d.gender,
        d.age_group,
        COUNT(*) AS total_prescriptions,
        COUNT(DISTINCT d.patient_id) AS unique_patients,
        ROUND(COUNT(DISTINCT d.patient_id)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS pct_unique_of_total
FROM medications m
JOIN demographic d ON m.patient_id = d.patient_id
GROUP BY m.description, d.gender, d.age_group;

-- =========================================
--4. How long are patients typically staying in hospital by condition? (exclude extreme outliers (LOS > 365 days)
-- =========================================
SELECT  
    description,
    patient_id,
    ROUND(AVG(EXTRACT(EPOCH FROM (stop - start)) / 86400), 2) AS avg_stay_days,
    ROUND(MIN(EXTRACT(EPOCH FROM (stop - start)) / 86400), 2) AS min_stay_days,
    ROUND(MAX(EXTRACT(EPOCH FROM (stop - start)) / 86400), 2) AS max_stay_days,
    COUNT(*) AS total_encounters
FROM encounters
WHERE stop IS NOT NULL 
  AND stop > start
  AND (stop - start) < INTERVAL '365 days'  -- cap unrealistic values
GROUP BY description, patient_id
ORDER BY avg_stay_days DESC;

-- =========================================
--5. Medications by geography (city)
-- =========================================
WITH prescriptions_by_city  AS (
	SELECT  m.description,
			COUNT(DISTINCT p.patient_id) AS unique_prescriptions,
			p.city
	FROM patients p
	JOIN medications m ON p.patient_id = m.patient_id
	GROUP BY m.description, p.city
),

total_prescriptions_by_city  AS ( 
SELECT  m.description,
			COUNT(p.patient_id) AS total_prescriptions,
			p.city
	FROM patients p
	JOIN medications m ON p.patient_id = m.patient_id
	GROUP BY m.description, p.city
)

SELECT  pc.description,
		pc.city,
		pc.unique_prescriptions,
		tp.total_prescriptions,
		ROUND(pc.unique_prescriptions::DECIMAL / tp.total_prescriptions * 100, 2) AS percentage_prescription
FROM prescriptions_by_city pc
JOIN total_prescriptions_by_city tp ON pc.description = tp.description
				AND pc.city = tp.city;


-- =========================================
--6. Analyze which procedures are common in each city, state, or country
-- =========================================
WITH procedures_by_city AS (
	SELECT p.description, COUNT(DISTINCT p.patient_id) AS unique_patients, px.city
	FROM patients px
	JOIN procedures p ON px.patient_id = p.patient_id
	GROUP BY p.description, px.city
	ORDER BY COUNT(DISTINCT p.patient_id) DESC
),

total_procedures_by_city AS (
	SELECT COUNT(patient_id) AS population, city
	FROM patients
	GROUP BY city
)

SELECT  pc.description,
		pc.city,
		pc.unique_patients,
		tpc.population,
		ROUND(pc.unique_patients::DECIMAL / tpc.population * 100, 2) AS percentage_patients
FROM procedures_by_city pc
JOIN total_procedures_by_city tpc ON pc.city = tpc.city;


-- =========================================
--7. Year-over-Year Growth per Condition (by Age Group)
-- =========================================
WITH patient_age_group AS (
    -- Total patients per age group (denominator for percentages)
    SELECT age_group, COUNT(patient_id) AS total_patients_per_age_group
    FROM demographic
    GROUP BY age_group
),

total AS (
    -- Unique patients per condition per year per age group
    SELECT  
        d.age_group,
        c.description,
        EXTRACT(YEAR FROM c.start) AS year,
        COUNT(DISTINCT d.patient_id) AS unique_patients,
        p.total_patients_per_age_group,
        ROUND(
            COUNT(DISTINCT d.patient_id)::DECIMAL / NULLIF(p.total_patients_per_age_group, 0) * 100,
            2
        ) AS pct_patients
    FROM conditions c
    JOIN demographic d ON c.patient_id = d.patient_id
    JOIN patient_age_group p ON d.age_group = p.age_group
    GROUP BY d.age_group, c.description, EXTRACT(YEAR FROM c.start), p.total_patients_per_age_group
),

ranked AS (
    -- Previous year's percentage for YoY growth calculation
    SELECT  
        *,
        LAG(pct_patients) OVER (PARTITION BY age_group, description ORDER BY year) AS previous_pct
    FROM total
)

SELECT  
    age_group,
    description,
    year,
    unique_patients,
    total_patients_per_age_group,
    pct_patients,
    ROUND(
        (pct_patients - previous_pct) / NULLIF(previous_pct, 0) * 100,
        2
    ) AS growth
FROM ranked
ORDER BY age_group, description, year;
