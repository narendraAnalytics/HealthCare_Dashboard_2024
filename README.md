# HealthCare_Dashboard_2024

# Project Title
![Banner Image](Images/banner_Image.jpg)


### Power BI Dashboard
Access the interactive dashboard here: [HealthCare DashBoard Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMzRiYTk1M2EtMzFkZS00Y2MyLWIxYTAtZmE4ZGRhMmYxZDJhIiwidCI6ImEyZWE5ODRlLTlkYzYtNDU5ZS1iNDFkLTY1YWJmYWEzMTExYyJ9)

Project Overview

This project involves the analysis of various datasets related to healthcare, including information on patients, providers, diagnoses, procedures, and visits. The purpose of this project is to conduct exploratory data analysis (EDA), build visualizations, and gain insights that can inform decision-making in a healthcare setting.

Files in the Project
1. cities.csv
This file contains information about the cities from which patients have visited the healthcare facility. The dataset includes:

city_id: Unique identifier for each city
city_name: Name of the city
state: State to which the city belongs

2. departments.csv
Contains details of the various departments within the healthcare organization:

department_id: Unique identifier for each department
department_name: Name of the department (e.g., Cardiology, Neurology)

3. diagnosis.csv
Details the diagnoses made during patient visits:

diagnosis_id: Unique identifier for each diagnosis
diagnosis_description: A description of the diagnosis

4. insurance_provider.csv
This file lists the insurance providers associated with the patients:

provider_id: Unique identifier for each provider
provider_name: Name of the insurance provider

5. patients.csv
Contains demographic information about the patients:

patient_id: Unique identifier for each patient
first_name: Patient's first name
last_name: Patient's last name
dob: Date of birth of the patient
gender: Gender of the patient
city_id: Reference to the cities.csv file

6. procedure.csv
Details the medical procedures carried out during patient visits:

procedure_id: Unique identifier for each procedure
procedure_description: Description of the medical procedure

7. providers.csv
Lists the healthcare providers who have attended to the patients:

provider_id: Unique identifier for each provider
provider_name: Name of the healthcare provider
department_id: Reference to the departments.csv file

8. visits.csv
Contains data about patient visits:

visit_id: Unique identifier for each visit
patient_id: Reference to the patients.csv file
provider_id: Reference to the providers.csv file
diagnosis_id: Reference to the diagnosis.csv file
procedure_id: Reference to the procedure.csv file
visit_date: Date of the visit

How to Use
Download the files and place them in the appropriate project folder.
Load the data using your preferred analysis tool (e.g., Python, SQL).
Perform data cleaning and preprocessing as necessary.
Explore the relationships between the different entities (e.g., Patients, Providers, Procedures).
Use visualizations to gain insights from the data.
Future Enhancements
Integration with real-time patient monitoring data.
Predictive analytics for patient outcomes based on historical data.
