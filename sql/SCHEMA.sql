CREATE TABLE IF NOT EXISTS patients (
patient_id UUID PRIMARY KEY,
birthdate DATE NOT NULL,
deathdate DATE,
ssn TEXT,
drivers TEXT,
passport TEXT,
prefix TEXT,
first_name TEXT,
last_name TEXT,
suffix TEXT,
maiden TEXT,
marital TEXT,
race TEXT,
ethnicity TEXT,
gender VARCHAR (1),
birthplace TEXT,
address TEXT,
city TEXT,
state TEXT,
country TEXT,
zip TEXT,
lat DECIMAL (9,6),
lon DECIMAL (9,6),
healthcare_expenses DECIMAL,
healthcare_coverage DECIMAL
);

CREATE TABLE IF NOT EXISTS encounters (
encounter_id UUID NOT NULL PRIMARY KEY,
start TIMESTAMPTZ,
stop TIMESTAMPTZ,
patient_id UUID REFERENCES patients(patient_id),
organization UUID,
provider UUID,
payer UUID,
encounterclass TEXT,
code TEXT,
description TEXT,
base_encounter_cost DECIMAL (10,2),
total_claim_cost DECIMAL (10,2),
payer_coverage DECIMAL (10,2),
reasoncode BIGINT,
reasondescription TEXT
);

CREATE TABLE IF NOT EXISTS conditions (
condition_id SERIAL PRIMARY KEY,
start DATE,
stop DATE,
patient_id UUID REFERENCES patients(patient_id),
encounter_id UUID REFERENCES encounters(encounter_id),
code TEXT,
description TEXT
);

CREATE TABLE IF NOT EXISTS procedures (
procedure_id SERIAL PRIMARY KEY,
date DATE,
patient_id UUID REFERENCES patients(patient_id),
encounter_id UUID REFERENCES encounters(encounter_id),
code TEXT,
description TEXT,
base_cost DECIMAL,
reasoncode BIGINT,
reasondescription TEXT
);

CREATE TABLE IF NOT EXISTS medications (
medication_id SERIAL PRIMARY KEY,
start DATE,
stop DATE,
patient_id UUID REFERENCES patients(patient_id),
payer TEXT,
encounter_id UUID REFERENCES encounters(encounter_id),
code TEXT,
description TEXT,
base_cost DECIMAL,
payer_coverage DECIMAL,
dispenses DECIMAL,
total_cost DECIMAL,
reasoncode BIGINT,
reasondescription TEXT
);

CREATE TABLE IF NOT EXISTS observations (
observation_id SERIAL PRIMARY KEY,
date DATE,
patient_id UUID REFERENCES patients(patient_id),
encounter_id UUID REFERENCES encounters(encounter_id),
code TEXT,
description TEXT,
value TEXT,
units TEXT,
type TEXT
);

/*Now lets insert the data from the cvs file we have for this project */

COPY conditions(start, stop, patient_id, encounter_id, code, description)
FROM 'C:\Program Files\PostgreSQL\17\data\conditions.csv'
DELIMITER ','
CSV HEADER;

COPY procedures(date, patient_id, encounter_id, code, description, base_cost, reasoncode, reasondescription)
FROM 'C:\Program Files\PostgreSQL\17\data\procedures.csv'
DELIMITER ','
CSV HEADER;

COPY medications(start, stop, patient_id, payer, encounter_id, code, description, base_cost, payer_coverage, dispenses, total_cost, reasoncode, reasondescription)
FROM 'C:\Program Files\PostgreSQL\17\data\medications.csv'
DELIMITER ','
CSV HEADER;

COPY observations(date, patient_id, encounter_id, code, description, value, units, type)
FROM 'C:\Program Files\PostgreSQL\17\data\observations.csv'
DELIMITER ','
CSV HEADER;

CREATE INDEX idx_patient_id_conditions ON conditions(patient_id);
CREATE INDEX idx_patient_id_medications ON medications(patient_id);
CREATE INDEX idx_patient_id_procedures ON procedures(patient_id);
CREATE INDEX idx_patient_id_observations ON observations(patient_id);

