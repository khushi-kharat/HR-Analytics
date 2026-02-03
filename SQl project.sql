## Created a database
create database HR_ANALYTICS;
use HR_ANALYTICS;


create table HR_1(Age int,
				  Attrition varchar(10),
                  BusinessTravel varchar(50),
                  DailyRate int,
                  Department varchar(50),
                  DistanceFromHome int,
                  Education int,
                  EducationField varchar(50),
                  EmployeeCount int,
                  EmployeeNumber int primary key,
                  EnvironmentSatisfaction int,
                  Gender varchar(10),
                  HourlyRate int,
                  JobInvolvement int,
                  JobLevel int,
                  JobRole varchar(50),
                  JobSatisfaction int,
                  MaritalStatus varchar(20)
			     );
                 select * from HR_1;
                 select count(*) from HR_1;

create table HR_2 (EmployeeID int primary key,
                   MonthlyIncome int,
                   MonthlyRate int,
                   NumCompaniesWorked int,
                   Over18 varchar(5),
                   OverTime varchar(5),
                   PercentSalaryHike int,
                   PerformanceRating int,
                   RelationshipSatisfaction int,
                   StandardHours int,
                   StockOptionLevel int,
                   TotalWorkingYears int,
                   TrainingTimesLastYear int,
                   WorkLifeBalance int,
                   YearsAtCompany int,
                   YearsInCurrentRole int,
                   YearsSinceLastPromotion int,
                   YearsWithCurrManager int
				  );
                  
    select * from HR_2;
    select count(*) from HR_2; 
   
   
   create table Combined_HR_Data as
   select 
          t1.*,
          t2.*
	from 
          hr_1 t1
	inner join
           hr_2 t2 on t1.EmployeeNumber = t2.EmployeeID;
   
   select * from Combined_HR_Data;
   
   
  ## KPI 1. Average Attrition rate for all Departments
  select 
       Department,
       (count(case when Attrition = 'Yes' then 1 else null end) * 100.0 / count(*)) as Average_Attrition_Rate_Percent
   from
       Combined_HR_Data
	group by
        Department;
        
        
  ## KPI 2. Average Hourly rate of Male Research Scientist.alter
  select 
       avg("HourlyRate") as Average_Male_Research_Scientist
   from 
        Combined_HR_Data
	where
        Gender = 'Male' and "JobRole"= 'Research Scientist';


## KPI 3. Attrition rate Vs Monthly income stats.
select
    case 
       when "MonthlyIncome" < 3000 then 'Low Income (<3k)'
       when "MonthlyIncome" >= 3000 and "MonthlyIncome" < 6000 then 'Mid Income (3k-6k)'
       when "MonthlyIncome" >= 6000 and "MonthlyIncome" < 10000 then 'High Income (6k-10k)'
       else 'Very High Income (>10k)'
	  end as Income_Bracket,
      (count(case when Attrition = 'Yes' then 1 else null end) * 100.0 / count(*)) as Attrition_Rate_Percent,
      avg("MonthlyIncome") as Avg_Income_in_Bracket
	from
        Combined_HR_Data
	group by
         Income_Bracket
	order by
          Avg_Income_in_Bracket;
          
          
## KPI 4. Average Working Years for each Department.
select
     Department,
     avg("TotalWorkingYears") as Average_Years_Worked
from
     Combined_HR_Data
group by
      Department;
      
      
## KPI 5. Job Role Vs Work life Balance.
select
     "JobRole",
     avg("WorkLifeBalance") as Average_WorkLifeBalance_Rating
from
     combined_hr_data
group by
      "JobRole"
order by
       Average_WorkLifeBalance_Rating desc;
       
       
##KPI 6. Attrition rate Vs Year since last promotion relation.
select
     case
         when "YearsSinceLastPromotion" = 0 then 'No Promotion'
         when "YearsSinceLastPromotion" between 1 and 3 then '1-3 Years Ago'
         when "YearsSinceLastPromotion" > 3 then 'Over 3 years ago'
	  end as Promotion_Timeline,
      (count(case when Attrition = 'Yes' then 1 else null end)*100.0 / count(*)) as Attrition_Rate_percent
	from
        combined_hr_data
	group by
         Promotion_Timeline
	order by
         Attrition_Rate_Percent desc;
