-- =========================================================================
-- INTRODUCTION
-- =========================================================================
-- This project is a SQL practice exercise built on a real-world-style
-- hospital dataset. It uses two related tables, Patients and Appointments,
-- to practice writing SQL queries that answer realistic healthcare
-- questions — from simple lookups to multi-table joins, subqueries, and
-- aggregate analysis. The goal is to move beyond textbook syntax and apply
-- SQL to a dataset that behaves like real data: it has duplicates, missing
-- values, and inconsistent entries that had to be cleaned before use.
--
--
-- =========================================================================
-- OVERVIEW
-- =========================================================================
-- Dataset:
--   - Patients table    -> one row per patient (demographics, insurance)
--   - Appointments table -> one row per appointment (linked to a patient)
--
-- Relationship:
--   Appointments.PatientID references Patients.PatientID (one-to-many:
--   a single patient can have multiple appointments).
--
-- What this file contains:
--   22 SQL practice questions grouped into 5 sections — basic filtering,
--   aggregation, CASE logic, joins, and subqueries — each with space to
--   write your own query and record your insights after running it.
--
-- How to use this file:
--   1. Run Hospital_Database.sql first to create and populate the tables.
--   2. Work through each question below, writing your query in the blank
--      space provided.
--   3. Record what you learned under each question's "INSIGHTS" section.
-- =========================================================================


-- =========================================================================
-- HOSPITAL APPOINTMENTS DATABASE — SQL PRACTICE WORKSHEET
-- Tables: Patients  | Appointments 
--
-- HOW TO USE THIS FILE
--   1. Read the question.
--   2. Write your query in the empty space below it.
--   3. Run it, then jot down what you learned under "INSIGHTS".
-- =========================================================================


-- #########################################################################
-- SECTION 1: BASIC SELECT / WHERE / ORDER BY
-- #########################################################################

USE HOSPITAL_APPOINTMENTS_DB

-- -------------------------------------------------------------------------
-- Q1. List all patients who are Uninsured, ordered by Age descending.
-- -------------------------------------------------------------------------
SELECT *FROM PATIENTS
WHERE INSURANCE = 'UNINSURED'
ORDER BY AGE DESC;


-- INSIGHTS:
-- Patients without insurance are identified, and the results are arranged in descending order of age,
-- helping to understand the age distribution of uninsured patients.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q2. Find all appointments in the "Cardiology" department that resulted
--     in a no-show.
-- -------------------------------------------------------------------------
SELECT *
FROM APPOINTMENTS
WHERE DEPARTMENTS = 'CARDIOLOGY'
  AND NOSHOW = 1;


-- INSIGHTS:
-- 399 Cardiology appointments resulted in no-shows,
--  highlighting a considerable number of missed appointments in this department.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q3. Show the 10 most recently scheduled appointments (by ScheduledDate).
-- -------------------------------------------------------------------------
SELECT *
FROM APPOINTMENTS
ORDER BY SCHEDULEDDATE DESC
LIMIT 10;


-- INSIGHTS:
-- The query identifies the 10 most recently scheduled appointments, 
-- helping to track the latest appointments in the hospitaL
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q4. Find all patients whose DOB is flagged invalid (DOB_Invalid = 1).
-- -------------------------------------------------------------------------
SELECT *
FROM PATIENTS
WHERE DOB_INVALID = 1;


-- INSIGHTS:
-- The query identifies 4 patients with invalid date-of-birth records,
--  highlighting data-quality issues that may need correction.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q5. List distinct VisitType values used across all appointments.
-- -------------------------------------------------------------------------
SELECT DISTINCT VISITTYPE
FROM APPOINTMENTS;

-- INSIGHTS:
-- The query identifies all unique types of visits recorded in the hospital appointments, 
-- helping to understand the different categories of visits made by patients.
-- -------------------------------------------------------------------------


-- #########################################################################
-- SECTION 2: AGGREGATION / GROUP BY / HAVING
-- #########################################################################

-- -------------------------------------------------------------------------
-- Q6. Count the total number of appointments per Department.
-- -------------------------------------------------------------------------
SELECT DEPARTMENT, COUNT(*) AS TOTALAPPOINTMENTS
FROM APPOINTMENTS
GROUP BY DEPARTMENT
ORDER BY TOTALAPPOINTMENTS DESC;

-- INSIGHTS:
-- The query counts the total number of appointments in each department and sorts the departments from highest to lowest number of appointments. 
-- This helps identify which departments handle the most appointments.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q7. Find the average LeadDays (days between scheduling and the visit)
--     per Department.
-- -------------------------------------------------------------------------
SELECT DEPARTMENT , AVG(LEADDAYS) AS AVGLEADDAYS
FROM APPOINTMENTS
GROUP BY DEPARTMENT;

-- INSIGHTS:
-- The query calculates the average number of lead days for each department, 
-- helping understand how far in advance appointments are generally scheduled in different departments.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q8. Calculate the no-show rate (%) for each Department.
-- -------------------------------------------------------------------------
SELECT DEPARTMENT,
       ROUND(SUM(NOSHOW) * 100.0 / COUNT(*), 2) AS NOSHOWPCT
FROM APPOINTMENTS
GROUP BY DEPARTMENT;


-- INSIGHTS:
-- The query calculates the no-show percentage for each department,
--  helping identify departments where patients are more likely to miss their scheduled appointments.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q9. Find departments where more than 10% of appointments are no-shows
--     (use HAVING).
-- -------------------------------------------------------------------------
SELECT DEPARTMENT,
       ROUND(SUM(NOSHOW) * 100.0 / COUNT(*), 2) AS NoShowRatePct
FROM APPOINTMENTS
GROUP BY DEPARTMENT
HAVING SUM(NOSHOW) * 100.0 / COUNT(*) > 10;

-- INSIGHTS:
-- The query identifies departments where more than 10% of appointments are no-shows, 
-- helping highlight departments with relatively higher missed-appointment rates.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q10. Find the doctor (DoctorID) who has handled the most appointments.
-- -------------------------------------------------------------------------
SELECT DOCTORID, COUNT(*) AS TOTALAPPOINTMENTS
FROM APPOINTMENTS
GROUP BY DOCTORID
ORDER BY TOTALAPPOINTMENTS DESC
LIMIT 1;

-- INSIGHTS:
-- The query identifies the doctor who has handled the highest number of appointments,
--  helping determine which doctor has the highest appointment workload.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q11. Find the clinic (ClinicID) with the highest average LeadDays.
-- -------------------------------------------------------------------------
SELECT CLINICID, AVG(LEADDAYS) AS AVGLEADDAYS
FROM APPOINTMENTS
GROUP BY CLINICID
ORDER BY AVGLEADDAYS DESC
LIMIT 1;

-- INSIGHTS:
-- The query identifies the clinic with the highest average lead days, 
-- showing which clinic’s appointments are scheduled furthest in advance on average.
-- -------------------------------------------------------------------------

-- #########################################################################
-- SECTION 3: CASE / CONDITIONAL LOGIC
-- #########################################################################

-- -------------------------------------------------------------------------
-- Q12. Categorize patients into age bands ("Under 18", "18-40", "41-65",
--      "65+") using CASE.
-- -------------------------------------------------------------------------
SELECT PATIENTID, Name, AGE,
       CASE
           WHEN AGE < 18 THEN 'UNDER 18'
           WHEN AGE BETWEEN 18 AND 40 THEN '18-40'
           WHEN AGE BETWEEN 41 AND 65 THEN '41-65'
           ELSE '65+'
       END AS AGEBAND
FROM PATIENTS 
WHERE AGE IS NOT NULL;

-- INSIGHTS:
-- The query categorizes patients into four age groups—Under 18, 18–40, 41–65, 
-- and 65+—making it easier to analyze the patient population by age.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q13. Label each appointment as "Short Notice" (LeadDays <= 3) or
--      "Planned" (LeadDays > 3).
-- -------------------------------------------------------------------------
SELECT APPOINTMENTID, LEADDAYS,
       CASE WHEN LEADDAYS <= 3 THEN 'SHORT NOTICE' ELSE 'PLANNED' END AS NOTICETYPE
FROM APPOINTMENTS;


-- INSIGHTS:
-- The query categorizes appointments as “Short Notice” when LeadDays are 3 or less and “Planned” when LeadDays are more than 3, 
-- helping understand how appointments are scheduled.
-- -------------------------------------------------------------------------

-- #########################################################################
-- SECTION 4: JOINS
-- #########################################################################

-- -------------------------------------------------------------------------
-- Q14. List each appointment with the patient's Name and Insurance type
--      (INNER JOIN).
-- -------------------------------------------------------------------------
SELECT a.APPOINTMENTID, p.Name, p.INSURANCE, a.APPOINTMENTDATE, a.DEPARTMENT
FROM APPOINTMENTS a
INNER JOIN PATIENTS p ON a.PATIENTID = p.PATIENTID;

-- INSIGHTS:
-- The query combines appointment and patient information to show each appointment along with the patient’s name, 
-- insurance type, appointment date, and department. This provides a complete view of patient appointments.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q15. Find all patients who have never had an appointment
--      (LEFT JOIN + IS NULL).
-- -------------------------------------------------------------------------
SELECT p.PATIENTID, p.Name
FROM PATIENTS p
LEFT JOIN APPOINTMENTS a ON p.PATIENTID = a.PATIENTID
WHERE a.APPOINTMENTID IS NULL;

-- INSIGHTS:
-- The query identifies patients who have never had an appointment, 
-- helping find patients who are registered in the system but have no appointment records.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q16. For each Insurance type, find the average number of appointments
--      per patient (JOIN + GROUP BY).
-- -------------------------------------------------------------------------
SELECT p.INSURANCE,
       COUNT(a.APPOINTMENTID) * 1.0 / COUNT(DISTINCT p.PATIENTID) AS AvgAppointmentsPerPatient
FROM Patients p
LEFT JOIN APPOINTMENTS a ON p.PATIENTID = a.PATIENTID
GROUP BY p.INSURANCE;

-- INSIGHTS:
-- The query calculates the average number of appointments per patient for each insurance type,
--  helping compare appointment usage across different insurance groups.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q17. List the top 5 patients (by name) with the most no-shows
--      (JOIN + GROUP BY + ORDER BY).
-- -------------------------------------------------------------------------
SELECT p.Name, COUNT(*) AS NoShowCount
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.PATIENTID = p.PATIENTID
WHERE a.NOSHOW = 1
GROUP BY p.PATIENTID, p.Name
ORDER BY NoShowCount DESC
LIMIT 5;

-- INSIGHTS:
-- The query identifies the top 5 patients with the highest number of no-show appointments, 
-- helping highlight patients with frequent missed appointments.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q18. Find all "Emergency" visit appointments along with the patient's
--      Age and Gender (JOIN + WHERE).
-- -------------------------------------------------------------------------
SELECT a.APPOINTMENTID, p.Name, p.AGE, p.GENDER, a.APPOINTMENTDATE
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.PATIENTID = p.PATIENTID
WHERE a.VISITTYPE = 'EMERGENCY';

-- INSIGHTS:
-- Emergency visits are the most common type (1,630 of 4,997 appointments, ~33%),
--  split almost evenly by gender with an average patient age of ~45.7 — not an elderly-skewed group.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q19. Find patients over 60 who had a no-show in the Orthopedics
--      department (JOIN + multiple WHERE conditions).
-- -------------------------------------------------------------------------
SELECT p.PATIENTID, p.Name, p.AGE, a.APPOINTMENTDATE
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.PATIENTID = p.PATIENTID
WHERE p.AGE > 60
  AND a.NOSHOW = 1
  AND a.DEPARTMENT = 'ORTHOPEDICS';

-- INSIGHTS:
-- Only 88 appointments involve patients over 60 who no-showed in Orthopedics —
--  a small, specific slice, likely worth investigating for mobility/transport barriers among older patients.
-- -------------------------------------------------------------------------


-- #########################################################################
-- SECTION 5: SUBQUERIES
-- #########################################################################


-- -------------------------------------------------------------------------
-- Q20. Find patients whose Age is above the overall average patient age
--      (subquery in WHERE).
-- -------------------------------------------------------------------------
SELECT PATIENTID, Name, AGE
FROM PATIENTS
WHERE AGE > (SELECT AVG(AGE) FROM PATIENTS WHERE AGE IS NOT NULL);

-- INSIGHTS:
-- Average patient age is ~46, and 506 of 996 patients (about 51%) fall above it —
--  a fairly even split, with ages ranging 0–95, so no extreme skew pulling the average.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q21. Find the department with the highest total appointment count
--      using a subquery.
-- -------------------------------------------------------------------------
SELECT DEPARTMENT
FROM APPOINTMENTS
GROUP BY DEPARTMENT
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt FROM APPOINTMENTS GROUP BY DEPARTMENT) t
);

-- INSIGHTS:
-- Cardiology has the most appointments (1,285), but it's barely ahead of Orthopedics (1,284) — 
-- all four departments are actually very close (1,188–1,285), so appointment volume is spread evenly, not concentrated in one department.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- Q22. List patients who have had more appointments than the average
--      number of appointments per patient (subquery or JOIN + HAVING).
-- -------------------------------------------------------------------------
SELECT p.PATIENTID, p.Name, COUNT(a.APPOINTMENTID) AS TOTALAPPOINTMENTS
FROM PATIENTS p
JOIN APPOINTMENTS a ON p.PATIENTID = a.PATIENTID
GROUP BY p.PATIENTID, p.Name
HAVING COUNT(a.APPOINTMENTID) > (
    SELECT COUNT(*) * 1.0 / COUNT(DISTINCT PATIENTID) FROM APPOINTMENTS
);

-- INSIGHTS:
-- Average appointments per patient is ~5.6, and 434 of 896 patients with appointments (about 48%) exceed that average —
--  with the busiest patients logging as many as 14–15 visits, which could flag frequent-visit patients worth reviewing for chronic-care patterns.
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------


-- =========================================================================
-- END OF WORKSHEET — 22 questions, 5 sections
-- =========================================================================
