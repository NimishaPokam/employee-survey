
--Identifying employees who paradoxically report high workload but also high job satisfaction.
SELECT ed.EmpID, 
    j.JobLevelType, 
    d.DeptName, 
    es.Workload, 
    es.JobSatisfaction
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
JOIN JobLevel j ON ed.joblevelid = j.joblevelid
JOIN Department d ON d.deptid = ed.deptid
WHERE es.Workload >= 4 AND es.JobSatisfaction >= 4;

--Does one gender consistently take on more demanding jobs?
SELECT ed.Gender, 
    COUNT(*) AS HighWorkloadEmployees
FROM EmployeeDetails ed
JOIN Employeesurvey es ON ed.employeesurveyid = es.employeesurveyid
WHERE es.Workload = 5
GROUP BY ed.Gender
ORDER BY HighWorkloadEmployees DESC;

-- Identifying the point at which overtime starts negatively affecting job satisfaction with workload ranges
SELECT 
    CASE 
        WHEN es.WorkLoad BETWEEN 1 AND 2 THEN 'Low'
        WHEN es.WorkLoad BETWEEN 3 AND 4 THEN 'Moderate'
        WHEN es.WorkLoad > 4 THEN 'High'
    END AS WorkLoadCategory,
    ROUND(AVG(es.JobSatisfaction), 2) AS AvgJobSatisfaction, 
    ROUND(AVG(es.Stress), 2) AS AvgStress,
    COUNT(*) AS EmployeeCount,
    CASE 
        WHEN AVG(es.JobSatisfaction) < 3 THEN 'Low Job Satisfaction'
        WHEN AVG(es.Stress) > 4 THEN 'High Stress'
        ELSE 'Normal'
    END AS Condition
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
WHERE haveOT = 'TRUE'
GROUP BY 
    CASE 
        WHEN es.WorkLoad BETWEEN 1 AND 2 THEN 'Low'
        WHEN es.WorkLoad BETWEEN 3 AND 4 THEN 'Moderate'
        WHEN es.WorkLoad > 4 THEN 'High'
    END
ORDER BY AvgJobSatisfaction;

--Highlighting employees who might deserve a promotion based on their responsibilities.
SELECT ed.EmpID, 
    j.JobLevelType, 
    ed.NumReports
FROM EmployeeDetails ed
JOIN JobLevel j ON ed.joblevelid = j.joblevelid
WHERE ed.NumReports >= 0 AND j.JobLevelType NOT IN ('Senior', 'Lead');

--Is workload, commute distance, or lack of physical activity a major cause of stress in certain departments?
SELECT d.DeptName, 
    ROUND(AVG(es.Workload),2) AS AvgWorkload, 
    ROUND(AVG(es.Stress),2) AS AvgStress,
    ROUND(AVG(c.CommuteDistance),2) AS AvgCommuteDistance,
    ROUND(AVG(es.PhysicalActivities),2) AS AvgPhysicalActivity
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
JOIN Department d ON d.deptid = ed.deptid
JOIN Commute c ON c.commuteid = ed.commuteid
GROUP BY d.DeptName;

--Identifying the department where employees get the most sleep on average.
SELECT d.DeptName, 
    ROUND(AVG(es.SleepHours),2) AS AvgSleepHours
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON es.employeesurveyid = ed.employeesurveyid
JOIN Department d ON ed.deptid = d.deptid
GROUP BY d.DeptName
ORDER BY AvgSleepHours DESC;

--Are older employees stuck in lower job levels?
SELECT ed.Age, 
    j.JobLevelType, 
    COUNT(*) AS EmployeeCount
FROM EmployeeDetails ed
JOIN Joblevel j ON ed.joblevelid = j.joblevelid
GROUP BY ed.Age, j.jobleveltype
HAVING j.JobLevelType IN ('Junior', 'Intern/Fresher') AND Age > 28;

--Identifying stress triggers that vary by department.
SELECT d.DeptName, 
    ROUND(AVG(es.Workload),2) AS AvgWorkload, 
    ROUND(AVG(es.Stress),2) AS AvgStress,
    ROUND(AVG(c.CommuteDistance),2) AS AvgCommuteDistance,
    ROUND(AVG(es.PhysicalActivities),2) AS AvgPhysicalActivity
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
JOIN Department d ON d.deptid = ed.deptid
JOIN Commute c ON c.commuteid = ed.commuteid
GROUP BY d.DeptName;

--Creating personas based on unique clusters of employee attributes.
SELECT 
    CASE 
        WHEN c.CommuteDistance > 10 AND es.WLB < 3 AND es.Stress > 3 AND es.SleepHours < 7 THEN 'Exhausted Commuter'
        WHEN c.CommuteDistance < 10 AND es.WLB >= 4 AND es.Stress <= 3 THEN 'Balanced Achiever'
        WHEN es.Workload >= 4 AND es.Stress > 4 AND es.JobSatisfaction >= 4 THEN 'Stressed Overachiever'
        ELSE 'Other'
    END AS Persona,
    COUNT(*) AS TotalEmployees
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
JOIN Commute c ON c.commuteid = ed.commuteid
GROUP BY 
    CASE 
        WHEN c.CommuteDistance > 10 AND es.WLB < 3 AND es.Stress > 3 AND es.SleepHours < 7 THEN 'Exhausted Commuter'
        WHEN c.CommuteDistance < 10 AND es.WLB >= 4 AND es.Stress <= 3 THEN 'Balanced Achiever'
        WHEN es.Workload >= 4 AND es.Stress > 4 AND es.JobSatisfaction >= 4 THEN 'Stressed Overachiever'
        ELSE 'Other'
    END
ORDER BY TotalEmployees DESC;

--Employees with the Most Extreme Work-Life Imbalance
SELECT 
    ed.EmpID,
    j.JobLevelType,
    c.CommuteDistance,
    es.Workload,
    es.Stress,
    es.WLB,
    es.SleepHours
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON ed.employeesurveyid = es.employeesurveyid
JOIN Commute c ON ed.commuteid = c.commuteid
JOIN JobLevel j  ON j.joblevelid = ed.joblevelid
WHERE (es.Stress BETWEEN 3 AND 5 OR es.Workload >= 4) 
    AND es.WLB <= 3 AND es.SleepHours < 6 
    AND c.CommuteDistance > 15
ORDER BY es.Stress DESC, es.WLB ASC;

--Workload and Satisfaction by Job Levels and Departments
SELECT 
    d.DeptName,
    j.JobLevelType,
    ROUND(AVG(es.Workload),2) AS AvgWorkload,
    ROUND(AVG(es.JobSatisfaction),2) AS AvgJobSatisfaction,
    COUNT(*) AS TotalEmployees
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON es.employeesurveyid = ed.employeesurveyid
JOIN Department d ON ed.deptid = d.deptid
JOIN JobLevel j ON j.joblevelid = ed.joblevelid
GROUP BY d.DeptName, j.JobLevelType
HAVING AVG(es.Workload) > 3 AND AVG(es.JobSatisfaction) > 3
ORDER BY AvgJobSatisfaction DESC, AvgWorkload ASC;

--Leadership Workload vs. Team Size
SELECT 
    j.JobLevelType,
    ROUND(AVG(es.Workload),2) AS AvgWorkload,
    ROUND(AVG(ed.NumReports),2) AS AvgTeamSize,
    COUNT(*) AS TotalLeaders
FROM EmployeeSurvey es
JOIN EmployeeDetails ed ON es.employeesurveyid = ed.employeesurveyid
JOIN JobLevel j ON ed.joblevelid = j.joblevelid
WHERE j.JobLevelType IN ('Senior', 'Lead')
GROUP BY j.JobLevelType
ORDER BY AvgWorkload DESC, AvgTeamSize DESC;











