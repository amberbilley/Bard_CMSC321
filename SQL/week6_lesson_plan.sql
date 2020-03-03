-- BASICS
USE elmasri_5_6;

SELECT *
FROM employee
WHERE Dno = 5
ORDER BY Fname
LIMIT 3;

-- SELECT CLAUSE
SELECT *
FROM employee
WHERE Fname='John' AND Minit='B' AND Lname='Smith';

-- Q0
SELECT Bdate, Address
FROM employee
WHERE Fname='John' AND Minit='B' AND Lname='Smith';

-- Q1
SELECT Fname, Lname, Address
FROM employee, department
WHERE Dname='Research' AND Dnumber=Dno;

-- Q1B Clarifying ambiguity
SELECT E.Fname, E.LName, E.Address
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE D.DName = ‘Research’ AND D.Dnumber = E.Dno;

-- Q2 -- For every project located in ‘Stafford’, list the project number, the controlling department number, and the department manager’s last name, address, and birth date.
SELECT Pnumber,Dnum,Lname,Address,Bdate
FROM project,department,employee
WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Plocation='Stafford';

-- Q8 - Clarifying ambiguity
SELECT E.Fname, E.Lname, S.Fname, S.Lname
FROM EMPLOYEE AS E, EMPLOYEE AS S
WHERE E.Super_ssn = S.Ssn;

-- -- Using expressions
SELECT Salary, (Salary * .05) AS Raise
FROM  employee

-- -- Removing duplicates
-- Q11A
SELECT DISTINCT Salary
FROM employee
-- * add SELECT DISTINCT Lname, Salary to demo the DISTINCT

-- WHERE Clause to filter data with conditions
-- -- >,>=,<,<=,=,<>,!=

--AND
SELECT *
FROM employee
WHERE Bdate < '1960-01-01' AND Salary > 50000

--OR
SELECT *
FROM employee
WHERE Bdate < '1960-01-01' OR Salary > 50000

--NEGATE CONDITION w WHERE NOT
SELECT *
FROM employee
WHERE NOT Bdate < '1960-01-01'

-- IN Operator returns results with that exact data in an attribute
SELECT *
FROM works_on
WHERE Pno IN (1,2,20)

-- BETWEEN Operator
SELECT *
FROM employee
WHERE Salary BETWEEN 35000 AND 55000

-- LIKE Operator using substinrg pattern matching to return all employees whose last name start with "w"
-- -- %: any number of chars
-- -- _: exactly one char
SELECT *
FROM employee
WHERE Lname LIKE 'w%'

-- REGEXP Operator  uses Regular expressions
-- -- ^: beginning of string
-- -- $: end of string
-- -- |: logical OR -- '^a|n$'
-- -- [abc]: match any single chars -- 'j[ae]'
-- -- [a-d]: match chars from a to d -- 'j[a-z]'
SELECT *
FROM employee
WHERE Fname REGEXP '^a'

-- IS NULL Operator
SELECT *
FROM employee
WHERE Super_ssn IS NULL

-- ORDER BY CLAUSE
-- -- Sort Projects by Pname and ASC and then Plocation in DESC
SELECT *
FROM project
ORDER BY Pname, Plocation DESC

 -- LIMIT CLAUSE
 -- -- Return a subset of rows
SELECT *
FROM dependent
LIMIT 3
-- SKIP x amount and return 3
SELECT *
FROM dependent
LIMIT 4, 3
-- ORDER BY and LIMIT
SELECT *
FROM dependent
ORDER BY Dependant_name
LIMIT 3

-- NESTED QUERIES
/* In Q4A, the first nested query selects the project numbers of projects that have an
employee with last name ‘Smith’ involved as manager (Smith doesn't manage anything), whereas the second nested query
selects the project numbers of projects that have an employee with last name ‘Smith’
involved as worker. */
SELECT DISTINCT Pnumber
FROM PROJECT
WHERE Pnumber IN
	( SELECT Pnumber
	FROM PROJECT, DEPARTMENT, EMPLOYEE
	WHERE Dnum = Dnumber AND
	Mgr_ssn = Ssn AND Lname = 'Smith' )
OR
Pnumber IN
	( SELECT Pno
	FROM WORKS_ON, EMPLOYEE
	WHERE Essn = Ssn AND Lname = 'Smith' );

-- Q6 EXISTS AND UNIQUE
SELECT Fname, Lname
FROM EMPLOYEE
WHERE NOT EXISTS
  ( SELECT *
    FROM DEPENDENT
    WHERE Ssn = Essn );

-- Q7 Lists the names of manageers who have at least one dependent
SELECT Fname, Lname
FROM EMPLOYEE
WHERE EXISTS
  ( SELECT *
    FROM DEPENDENT
    WHERE Ssn = Essn )
AND
  EXISTS ( SELECT *
  FROM DEPARTMENT
  WHERE Ssn = Mgr_ssn );

-- JOINS!
-- INNER (RIGHT) JOINS
-- -- Returns all the rows that have a e.Dno and p.Dnum
SELECT *
FROM employee e
JOIN project p
	ON e.Dno = p.Dnum

-- Q1A
SELECT Fname, Lname, Address
FROM (EMPLOYEE JOIN DEPARTMENT ON Dno = Dnumber)
WHERE Dname = ‘Research’;

--Fixed it
SELECT Fname, Lname, Address
FROM EMPLOYEE
  JOIN DEPARTMENT
  ON Dno = Dnumber
WHERE Dname = 'Research';

-- ** Set 4 to NULL click Apply
-- Run the Right Join Again = no nulls
-- Run a Left join = null ok

SELECT *
FROM employee e
LEFT JOIN project p
	ON e.Dno = p.Dnum

-- SELF Join
-- -- Let's figure out who manages who in our COMPANY
SELECT
	m.Fname AS Manager,
	e.Fname AS Employee
FROM employee e
JOIN employee m
	ON e.Super_ssn = m.Ssn
--But I want to see who everyone manages and we're missing some info, so let's do left JOIN
SELECT
	m.Fname AS Manager,
	e.Fname AS Employee
FROM employee e
LEFT JOIN employee m
	ON e.Super_ssn = m.Ssn

-- UNIONS
SELECT Fname,Bdate
FROM employee
UNION
SELECT Dependant_name, Bdate
FROM dependent

-- AGGREGATE FUNCTIONS
SELECT sum(Salary), max(Salary), min(Salary) , avg(Salary)
FROM employee;

-- Fixed it
SELECT sum(Salary) AS Total, max(Salary) AS Highest, min(Salary) AS Lowest, avg(Salary) AS Average
FROM employee

-- How about just in the Research Dept
SELECT sum(Salary) AS Total, max(Salary) AS Highest, min(Salary) AS Lowest, avg(Salary) AS Average
FROM (EMPLOYEE JOIN DEPARTMENT ON Dno = Dnumber)
WHERE Dname = 'Research';

-- How about how many DISTINCT salaries
SELECT count(DISTINCT Salary)
FROM EMPLOYEE;

-- GROUPING
-- Q24 For each department, retrieve the department number, the number of employees in the department, and their average salary.
SELECT Dno, count(*), avg(Salary)
FROM EMPLOYEE
GROUP BY Dno;

-- Q27 For each project, retrieve the project number, the project name, and the number of employees from department 5 who work on the project.
SELECT Pnumber, Pname, count(*)
FROM PROJECT, WORKS_ON, EMPLOYEE
WHERE Pnumber = Pno AND Ssn = Essn AND Dno = 5
GROUP BY Pnumber, Pname;
