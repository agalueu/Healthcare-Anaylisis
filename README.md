📌 Overview
This project analyzes synthetic healthcare data to uncover patient demographics, condition prevalence, medication usage, hospital stay patterns, procedure demand, and year-over-year trends. The goal is to simulate real-world healthcare analytics and demonstrate SQL, data modeling, and visualization skills.

📊 Dataset
The dataset includes anonymized healthcare records with the following entities:

Patients → demographic information (birthdate, gender, city, etc.)

Conditions → medical conditions diagnosed per patient

Medications → prescriptions issued to patients

Encounters → hospital visits, admissions, and length of stay

Procedures → medical procedures performed

🛠️ Tools & Technologies

PostgreSQL → database storage and querying

SQL (CTEs, Window Functions, Aggregations) → data analysis

Power BI → interactive dashboards and data visualization

dbdiagram.io → Entity Relationship Diagram (ERD)

❓ Key Business Questions

What is the distribution of patients by age group and gender?

What are the most common medical conditions?

How does medication usage vary by age group, gender, and geography?

What are the typical hospital stay durations for different conditions?

Which procedures are most common in each city?

How do conditions grow or decline year-over-year by age group?

📂 Repository Structure

├── data/                 # Raw dataset files
├── queries/              # SQL scripts for analysis
├── analysis/             # Query analysis & documentation
├── dashboard/            # Power BI files and visuals
├── erd/                  # Entity Relationship Diagram
└── README.md             # Project documentation


🔄 How to Reproduce

Clone this repository.

Create the database schema in PostgreSQL.

Load the dataset into the respective tables.

Run SQL scripts from the queries/ folder.

Open Power BI and connect it to PostgreSQL for visualization.

🔗 Relationships (ERD)
The database schema connects patients with their encounters, conditions, medications, and procedures. The ERD is included in the /erd folder for visualization of table relationships.

📈 Power BI Dashboard
An interactive dashboard was created in Power BI to visualize key insights such as patient demographics, condition prevalence, prescription trends, and year-over-year growth. This dashboard translates SQL queries into intuitive charts for business users.
