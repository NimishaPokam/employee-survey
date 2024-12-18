CREATE TABLE JobLevel(
JobLevelID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
JobLevelType  NVARCHAR2(15) NOT NULL
);

CREATE TABLE Department(
DeptID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
DeptName NVARCHAR2(25) NOT NULL
);

CREATE TABLE EmpType(
EmpTypeID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
EmpTypeName NVARCHAR2(20) NOT NULL
);

CREATE TABLE EduLevel(
EduLevelID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
EduLevelName NVARCHAR2(20)NOT NULL
);

CREATE TABLE Commute(
CommuteID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
CommuteMode NVARCHAR2(20) NOT NULL,
CommuteDistance NUMBER(2) NOT NULL
);

CREATE TABLE EmployeeSurvey(
EmployeeSurveyID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
WLB NUMBER(1) NOT NULL,
WorkEnv NUMBER(1) NOT NULL,
WorkLoad NUMBER(1) NOT NULL,
Stress NUMBER(1) NOT NULL,
JobSatisfaction NUMBER(1) NOT NULL,
PhysicalActivities NUMBER(5,2) NOT NULL,
SleepHours NUMBER(4,1) NOT NULL
);

CREATE TABLE EmployeeDetails (
EmpID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Gender VARCHAR2(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
Age NUMBER(2) NOT NULL,
MaritalStatus NVARCHAR2(20) NOT NULL,
NumCompanies NUMBER(2) NOT NULL,
TeamSize NUMBER(2) NOT NULL,
NumReports NUMBER(2) NOT NULL,
TrainingHoursPerYear NUMBER(4,2) NOT NULL,
HaveOT CHAR(5) CHECK (HaveOT IN ('TRUE', 'FALSE')) NOT NULL,
Experience NUMBER(3) NOT NULL,
JobLevelID NUMBER,
DeptID NUMBER,
EmpTypeID NUMBER,
EduLevelID NUMBER,
CommuteID NUMBER,
EmployeeSurveyID NUMBER,
CONSTRAINT fk_employeedetails_joblevel_id FOREIGN KEY (JobLevelID) REFERENCES JobLevel(JobLevelID),
CONSTRAINT fk_employeedetails_dept_id FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
CONSTRAINT fk_employeedetails_emptype_id FOREIGN KEY (EmpTypeID) REFERENCES EmpType(EmpTypeID),
CONSTRAINT fk_employeedetails_edulevel_id FOREIGN KEY (EduLevelID) REFERENCES EduLevel(EduLevelID),
CONSTRAINT fk_employeedetails_commute_id FOREIGN KEY (CommuteID) REFERENCES Commute(CommuteID),
CONSTRAINT fk_employeedetails_employeesurvey_id FOREIGN KEY (EmployeeSurveyID) REFERENCES EmployeeSurvey(EmployeeSurveyID)
);




