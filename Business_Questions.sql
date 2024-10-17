use healthcare_dashboard;

-- (1) What are the top 10 cities by the number of patients?

select
	c.City,
    count(p.Patient_ID)  as Patients_Count
from
	healthcare_dashboard.patient p
join
	healthcare_dashboard.cities c
on
	p.City_ID = c.City_ID
group by
	c.City
order by
	Patients_Count desc
limit 10;
-------------------------------------
-- (2) What are the different departments available in the hospital?

select
	distinct Department,
    Department_ID
from
	healthcare_dashboard.departments;

-- (3) List all the visits for a given patient along with the treatment costs.

select
	DateOfVisit,
    PatientID,
    TreatmentCost
from
	healthcare_dashboard.visits
where
	PatientID = 125;

----------------------------------------------------------------------
-- (3) How many patients visited each department?
select
    d.Department,
    count(distinct v.PatientID) as Frequency
from
	healthcare_dashboard.departments d
join
	healthcare_dashboard.visits v
on
	d.Department_ID = v.DepartmentID
group by
	d.Department
order by
		Frequency desc;

------------------------------------------------

-- (4) What is the total revenue generated from treatment costs for each service type (Inpatient/Outpatient)?

select
	ServiceType,
    sum(TreatmentCost) as Total_Cost
from
	healthcare_dashboard.visits
group by
	ServiceType
order by
	Total_Cost desc;

-- List the names of patients who have not scheduled a follow-up visit.

select
	p.Patient_Name,
    v.FollowUpVisitDate
from
	healthcare_dashboard.patient p
join
	healthcare_dashboard.visits v
on
	p.Patient_ID = v.PatientID
where
	v.FollowUpVisitDate is null;

-- Find the average patient satisfaction score for all visits.

select
	round(avg(PatientSatisfactionScore),2) as Avg_Satifaction_Score
from
	healthcare_dashboard.visits;

-- How many unique insurance providers are used by patients?

select
	count(distinct InsuranceID)
from
	healthcare_dashboard.visits;

-- List all patients who had an emergency visit.

select
	*
from
	healthcare_dashboard.visits
where
	EmergencyVisit = 'Yes';

-- Which patients have room charges but no treatment cost?

select
	p.Patient_Name,
    v.`RoomCharges(DailyRate)`,
    v.TreatmentCost
from
	healthcare_dashboard.patient p
join
	healthcare_dashboard.visits v
on
	p.Patient_ID = v.PatientID
where
	v.`RoomCharges(DailyRate)` is not null
    and v.TreatmentCost is null;
    
------------------------------------------------------------------------------------------------------------------------------------------

-- (1) What is the total cost (treatment + medication) for each patient?

select
	PatientID,
	sum(TreatmentCost) as Treatment_Cost,
    sum(MedicationCost) as Medication_Cost,
    sum(TreatmentCost) + sum(MedicationCost) as Total_Cost
from
	healthcare_dashboard.visits
group by
	PatientID
order by
	Treatment_Cost desc;

-- (2) List patients who have received multiple diagnoses during a single visit.

select
	p.Patient_Name,
    v.DateOfVisit,
    v.PatientID,
    count(v.DiagnosisID) as Frequency
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.patient p
on
	v.PatientID = p.Patient_ID
group by
	v.PatientID,v.DateOfVisit,p.Patient_Name
having
	count(v.DiagnosisID)>1;

-- (3) Which city has the highest average patient satisfaction score?
select
	c.City,
    -- p.Patient_ID,
    round(avg(v.PatientSatisfactionScore),2) as Avg_Score
from
	healthcare_dashboard.cities c
join
	healthcare_dashboard.patient p
on
	c.City_ID = p.City_ID
join
	healthcare_dashboard.visits v
on
	p.Patient_ID = v.PatientID
group by
	c.City
order by
	Avg_Score desc;

-- (4) How many patients have been admitted to each department over the past year?

select
	d.Department,
	count(v.AdmittedDate) as Admitted_Date
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.departments d
on
	v.DepartmentID = d.Department_ID
where
	v.AdmittedDate >= curdate() - interval 1 year
group by
	d.Department
order by
	Admitted_Date desc;
	

-- What is the total revenue generated from each insurance provider?

select
	v.InsuranceID,
	i.insurance_provider,
    sum(v.InsuranceCoverage) as Total_Sum
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.insurance_provider i
on
	v.InsuranceID = i.Insurance_ID
group by
	v.InsuranceID,i.Insurance_Provider
order by
	Total_Sum desc;

-- List the top 5 most common diagnoses across all visits.

select
	d.Diagnosis,
	count(v.DiagnosisID) as Count
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.diagnosis d
on
	v.DiagnosisID = d.Diagnosis_ID
group by
	d.Diagnosis
order by
	Count desc
limit 5;

-- Find the average room charges for each room type (Private, General, Semi-Private).

select
	RoomType,
    avg(`RoomCharges(DailyRate)`) as Avg_Amount
from
	healthcare_dashboard.visits
where
	`RoomCharges(DailyRate)` is not null
group by
	RoomType
order by
	Avg_Amount desc;

-- Which healthcare providers have treated the most patients?

select
	p.Provider_Name,
	count(distinct v.PatientID) as Total_provider
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.providers p
on
	v.ProviderID = p.Provider_ID
group by
	p.Provider_Name
order by
	Total_provider desc;

-- Identify patients who have been charged more than the average treatment cost.

WITH AvgTreatmentCost as (
	select
		round(avg(TreatmentCost),2) as Avg_Cost
	from
		healthcare_dashboard.visits
)
select
	p.Patient_Name,
    v.TreatmentCost
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.patient p
on
	v.PatientID = p.Patient_ID
where
	v.TreatmentCost> (select Avg_Cost from AvgTreatmentCost );


-- Which departments have the highest number of emergency visits?

select
	d.Department,
	count(v.EmergencyVisit) as count_Emergency
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.departments d
on
	v.DepartmentID = d.Department_ID
where
	v.EmergencyVisit = 'Yes'
group by
	d.Department
order by
	count_Emergency desc;
    
------------------------------------------------------------------------------------------------------------
--------------------------------------
-- (1) Find the top 3 most expensive procedures performed on patients.
with RankedProcedure as (
	select
		p.`Procedure`,
		v.TreatmentCost,
		RANK() over (order by v.TreatmentCost desc) as Rank_Cost
	from
		healthcare_dashboard.`procedure` p
	join
		healthcare_dashboard.visits v
	on
		p.Procedure_ID = v.ProcedureID
)	
select
	`Procedure`,TreatmentCost
from
	RankedProcedure
where
	Rank_Cost<=3;

-----------------------------------------------------------------------------------------------------------
-- (2) List patients with the highest number of follow-up visits.

with Follow_Up_Count as (
	select
		p.Patient_Name,
		v.PatientID,
		count(v.FollowUpVisitDate) as Follow_Visit_Date,
        count(v.DateOfVisit) as Total_Visit,
		rank() over (order by count(v.FollowUpVisitDate) desc) as Rank_Follow_Up
	from
		healthcare_dashboard.visits v
	join
		healthcare_dashboard.patient p
	on
		v.PatientID = p.Patient_ID
	where
		FollowUpVisitDate is not null
	group by
		v.PatientID,p.Patient_Name
)
select
	Patient_Name,PatientID,Total_Visit
from
	Follow_Up_Count 
where
	Rank_Follow_Up <= 10
order by
	Rank_Follow_Up;
-----------------------------------------------------------------------------------------------    
-- (3) What is the average time between a patient's admission and discharge, grouped by department?
select
	d.Department,
    avg(datediff(v.DischargeDate,v.AdmittedDate)) as Date_Diff
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.departments d
on
	v.DepartmentID = d.Department_ID
group by
	d.Department
order by
	Date_Diff desc;
---------------------------------------------------------------------------------------------
-- (4) Identify patients who visited the hospital for a procedure more than once within 30 days.

with DaysDifference as (
	select
		p.Patient_Name,
		v.PatientID,
		v.ProcedureID,
		min(v.DateOfVisit) as First_Visit,
		max(v.DateOfVisit) as Last_Visit,
		datediff(min(v.DateOfVisit), max(v.DateOfVisit)) as Day_Difference
	from
		healthcare_dashboard.visits v
	join
		healthcare_dashboard.patient p
	on
		v.PatientID = p.Patient_ID
	where
		v.ProcedureID is not null
	group by
		v.PatientID,v.ProcedureID,p.Patient_Name
	having
		Day_Difference <=30
) 
select
	Patient_Name,First_Visit,Last_Visit,Day_Difference
from
	DaysDifference
order by
	Day_Difference;
------------------------------------------------------------------------------------------------
-- (5) What is the percentage of inpatient vs. outpatient services over time (month-by-month)?
select
	year(DateOfVisit) as Year_Visit,
    month(DateOfVisit) as Month_Visit,
    count(case when ServiceType = 'Inpatient' then 1 end) * 100 / count(*) as Inpatient_percentage,
    count(case when ServiceType = 'Outpatient' then 1 end) * 100 / count(*) as OutPatient_Percentage
from
	healthcare_dashboard.visits
group by
	Year_Visit,Month_Visit
order by
	Year_Visit,Month_Visit;

----------------------------------------------------------------------------------------------------------------------------    

-- (6) Which healthcare provider has the best patient satisfaction score in each department?

with ProviderName as (
	select
		p.Provider_Name,
		v.ProviderID,
		d.Department,
		v.DepartmentID,
		v.PatientSatisfactionScore,
		rank() over (partition by v.DepartmentID order by v.PatientSatisfactionScore desc) as Rank_Satisfaction
	from
		healthcare_dashboard.visits v
	join
		healthcare_dashboard.providers p
	on
		v.ProviderID = p.Provider_ID
	join
		healthcare_dashboard.departments d
	on
		v.DepartmentID = d.Department_ID
)
select
	Provider_Name,
    Department,
   max(PatientSatisfactionScore) as Best_Satisfaction_Score
from
	ProviderName
where
	Rank_Satisfaction = 1
group by
	Provider_Name,Department
order by
	Department;
--------------------------------------------------------------------------------------------------------------
-- For each patient, calculate the running total of their treatment costs over time.

select
	v.PatientID,
    p.Patient_Name,
    v.DateOfVisit,
    v.TreatmentCost,
    sum(v.TreatmentCost) over(partition by v.PatientID order by v.DateOfVisit) as RunningTotal
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.patient p
on
	p.Patient_ID = v.PatientID;
-----------------------------------------------------------------------------------------------------------------------------------------    

-- Find departments where the average treatment cost exceeds the overall hospital average.

with OverallAvgDeptCost as (
	select avg(TreatmentCost) as overalldeptcost
    from healthcare_dashboard.visits
)
select
	d.Department,
    round(avg(v.TreatmentCost),2) as AvgDeptCost
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.departments d
on
	v.DepartmentID = d.Department_ID
group by
	d.Department
having
	avg(v.TreatmentCost) > (select overalldeptcost from OverallAvgDeptCost)
order by
	AvgDeptCost desc;
    
-----------------------------------------------------------------------------------------------------------------------------------
    
-- Identify the longest-running hospital stays (admission to discharge) and the associated departments.

SELECT 
    p.Patient_Name, 
    d.Department, 
    v.AdmittedDate, 
    v.DischargeDate, 
    DATEDIFF(v.DischargeDate, v.AdmittedDate) AS DaysInHospital
FROM visits v
JOIN patient p ON v.PatientID = p.Patient_ID
JOIN departments d ON v.DepartmentID = d.Department_ID
WHERE v.AdmittedDate IS NOT NULL 
  AND v.DischargeDate IS NOT NULL
ORDER BY DaysInHospital DESC
LIMIT 10;

-- Calculate the ratio of treatment costs to insurance coverage for each patient.
SELECT 
    p.Patient_Name, 
    v.TreatmentCost, 
    v.InsuranceCoverage, 
    CASE 
        WHEN v.InsuranceCoverage IS NULL OR v.InsuranceCoverage = 0 THEN NULL
        ELSE v.TreatmentCost / v.InsuranceCoverage
    END AS TreatmentToCoverageRatio
FROM visits v
JOIN patient p ON v.PatientID = p.Patient_ID
WHERE v.TreatmentCost IS NOT NULL;
























    