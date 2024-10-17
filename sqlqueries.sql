use healthcare_dashboard;

-- View Table Structure

describe healthcare_dashboard.cities;

-- View Sample Data

select
	*
from
	healthcare_dashboard.cities;

-- Check for Null Values

select
	sum(case when State_ID is null then 1 else 0 end) as state_id_null,
    sum(case when State is null then 1 else 0 end) as stae_null,
    sum(case when City_ID is null then 1 else 0 end) as stae_null,
    sum(case when City is null then 1 else 0 end) as stae_null
from
	healthcare_dashboard.cities;

-- Check for Duplicates

select
	State_ID,State,count(*)
from
	healthcare_dashboard.cities
group by
	State_ID,State
having
	count(*)>1;

-- Check Unique Values in Categorical Columns

select
	State,count(*) as Frequency_states
from
	healthcare_dashboard.cities
group by
	State;

-- -- Unique cities

select
	City,count(*) as Frequency_Cities
from
	healthcare_dashboard.cities
group by
	City;
    
-- Count Total Rows in the Dataset

select
	count(*) as Total_count
from
	healthcare_dashboard.cities;

------------------------------------------------------------------------------------------------------------------------------------

-- departments dataset

-- Check Table Structure

describe healthcare_dashboard.departments;

-- View Sample Data

select
	*
from
	healthcare_dashboard.departments;

-- Null Values

select
	sum(case when Department_ID is null then 1 else 0 end) as Id_Null
from
		healthcare_dashboard.departments;

-- Check for Duplicates

select
	Department_ID,count(*) as duplicates
from
	healthcare_dashboard.departments
group by
	Department_ID
having
	count(*)>1;
    
-- Check Unique Values in Categorical Columns

select
		Department,count(*) as Frequency_Department
from
		healthcare_dashboard.departments
group by
		Department;
        
-- Count Total Rows in the Dataset

SELECT COUNT(*) AS total_rows
FROM departments;      

-------------------------------------------------------------------------------------

-- patient datset

-- Check Table structure

desc healthcare_dashboard.patient;

-- View sample dataset

select
	*
from
	healthcare_dashboard.patient
limit 15;

-- Check for Null Values

select
	sum(case when Patient_ID is null then 1 else 0 end) as ID_Null,
    sum(case when Patient_Name is null then 1 else 0 end) as Patient_Null
from
	healthcare_dashboard.patient;
    
-- Check for Duplicates

select
	Patient_ID,Patient_Name,count(*)
from
	healthcare_dashboard.patient
group by
	Patient_ID,Patient_Name
having
	count(*)>1;

-- Check Unique Values in Categorical Columns

select
	Gender,count(*)
from
	healthcare_dashboard.patient
group by
	Gender;
--
-- Age distribution (optional, depending on the need for age analysis)
SELECT Age, COUNT(*) AS frequency
FROM patient
GROUP BY Age
ORDER BY frequency DESC;

----------------------------------
DESCRIBE healthcare_dashboard.visits;

-- View Sample Data

select
	*
from
	healthcare_dashboard.visits;

-- Check for Null Values

select
	sum(case when DateOfVisit is null then 1 else 0 end) as Date_Of_Visist_Null,
    sum(case when PatientID is null then 1 else 0 end) as Patient_ID_Null,
    sum(case when TreatmentCost is null then 1 else 0 end) as TreatMent_Cost
from
	healthcare_dashboard.visits;
    
-- Check Unique Values in Categorical Columns

select
	ServiceType,count(*) as Frequency
from
	healthcare_dashboard.visits
group by
	ServiceType;

select
	RoomType,count(*) as Frquency
from
	healthcare_dashboard.visits
group by
	RoomType;


-- -- Check for incompatible dates

select
	DateOfVisit
from
	healthcare_dashboard.visits
where
	str_to_date(DateOfVisit,'%Y-%m-%d') is null;

-- -- Change 'dataofvisit' from TEXT to DATE

alter table healthcare_dashboard.visits
modify column DateOfVisit date;

update healthcare_dashboard.visits
set `RoomCharges(DailyRate)` = '0'
where trim(`RoomCharges(DailyRate)`) = ''
	or `RoomCharges(DailyRate)` is null;

ALTER TABLE healthcare_dashboard.visits
MODIFY COLUMN `RoomCharges(DailyRate)` INT;

update healthcare_dashboard.visits
set FollowUpVisitDate = null
where FollowUpVisitDate = '' 
	or str_to_date(FollowUpVisitDate,'%Y-%m-%d') is null;

select
	*
from
	healthcare_dashboard.visits
limit 10;    

alter table healthcare_dashboard.visits
modify column FollowUpVisitDate date;
    
update healthcare_dashboard.visits
set DischargeDate = null
where DischargeDate = ''
	or str_to_date(DischargeDate,'%Y-%m-%d') is null;

alter table healthcare_dashboard.visits
modify column DischargeDate date;

update healthcare_dashboard.visits
set AdmittedDate = null
where AdmittedDate =''
	or str_to_date(AdmittedDate,'%Y-%m-%d') is null;
    
alter table healthcare_dashboard.visits
modify column AdmittedDate date;

------------------------------------------------------

select
	*
from
	healthcare_dashboard.visits
where PatientID=1;

with FollowUpVisits as (
	select
		PatientID,FollowUpVisitDate
	from
		healthcare_dashboard.visits
	where 
		FollowUpVisitDate is not null
)
select
	v.PatientID,
    v.DateOfVisit as IntialVisit,
    f.FollowUpVisitDate
from
	healthcare_dashboard.visits v
join
	FollowUpVisits f
on
	v.PatientID=f.PatientID
where v.DateOfVisit < f.FollowUpVisitDate;


-- Find the departments that have the highest average patient satisfaction score

with Avg_Satifaction_Scores as (
	select
		round(avg(PatientSatisfactionScore),2)  as Avg_satisfaction_Score
	from
		healthcare_dashboard.visits
)    
select
	d.Department,
    v.DepartmentID,
    avg(v.PatientSatisfactionScore) as AvgDeptSatisfaction
from
	healthcare_dashboard.visits v
join
	healthcare_dashboard.departments d
on
	v.DepartmentID = d.Department_ID
GROUP BY v.DepartmentID, d.Department
HAVING AVG(v.PatientSatisfactionScore) > (
    SELECT Avg_satisfaction_Score FROM Avg_Satifaction_Scores
)
ORDER BY AvgDeptSatisfaction DESC;



















