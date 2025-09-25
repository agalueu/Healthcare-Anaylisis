Healthcare Analytics Project
📌 Overview

This project analyzes hospital encounters, conditions, treatments, and medications to generate insights into patient care, healthcare costs, and disease patterns.

The analysis is based on a synthetic healthcare dataset (COVID-19 focused) commonly used in analytics practice.

📊 Dataset

The dataset comes from a public healthcare simulation dataset that includes information on patients and their medical history.

Main tables used:

patients 🧍 – demographics and baseline information.

encounters 🏥 – hospital visits (start/stop times, costs, reasons).

conditions ⚕️ – diagnoses and chronic conditions.

procedures 🩺 – treatments/procedures linked to encounters.

medications 💊 – prescribed drugs with costs and coverage.

observations 📊 – lab results, vitals, and other recorded measurements.

The original CSV files were loaded into PostgreSQL using COPY commands.

🛠️ Tools & Technologies

PostgreSQL → SQL queries and data transformations.

Power BI → Dashboards and interactive reports.

GitHub → Documentation and version control.

❓ Key Business Questions

What are the most common conditions diagnosed across patients?

How do hospital encounter costs vary by encounter type?

What are the most frequently prescribed medications and their costs?

How long are patients typically staying in hospital by condition?

Are there cost differences across patient demographics (age, gender, race)?

What are the most common lab observations for COVID-related encounters?

Which conditions are most associated with readmissions?

📂 Repository Structure
├── README.md                # Project overview (this file)  
├── analysis_resume.md       # Query goals, logic, and insights  
├── sql/                     # SQL scripts for analysis  
├── powerbi/                 # PBIX dashboard file  
└── images/                  # Screenshots of dashboards  

🔄 How to Reproduce

Clone this repository.

Load the CSV files into PostgreSQL using the provided COPY statements.

Run the SQL queries in sql/.

Connect Power BI to PostgreSQL and build the dashboard.

🔗 Relationships (ERD)

The project uses a snowflake schema with:

patients as the main entity,

linked to encounters,

which in turn connect to conditions, procedures, medications, and observations.

This structure allows analyzing patients from both a clinical and cost perspective.

📈 Power BI Dashboard

The dashboard provides:

Condition prevalence by patient demographics.

Encounter and treatment cost analysis.

Medication utilization and cost coverage.

Observation patterns for COVID-related cases.

Patient journey mapping across encounters.

📷 Screenshots are available in the images/ folder.
