-- ASSIGNMENT #2: SQL

-- PART 1

/* Consider the AIRLINE database schema of Elmasri Figure 5.8.
What are the referential integrity constraints that should hold on the schema?
Write the appropriate SQL DDL to define the database.

Constraints:
flight_leg:
flight_number → flight[number]
departure_airport_code → airport[airport_code]
arrival_airport_code → airport[airport_code]

leg_instance:
[flight_number, leg_number] → flight_leg[flight_number, leg_number]
airplane_id → airplane[airplane_id]
departure_airport_code → airport[airport_code]
arrival_airport_code → airport[airport_code]

fares:
flight_number → flight[number]
can_land: airplane_type_name → airplane_type[type_name] airport_code →
airport[airport_code]

airplane:
airplane_type → airplane_type[type_name]

seat_reservation:
[flight_number, leg_number, date] → leg_instance[flight_number, leg_number,
date]
*/

CREATE TABLE AIRPORT (
  Airport_code VARCHAR(45) PRIMARY KEY,
  Name VARCHAR(45) NOT NULL,
  City VARCHAR(45) NOT NULL,
  State VARCHAR(45) NOT NULL
);

CREATE TABLE FLIGHT (
  Flight_number VARCHAR(45) PRIMARY KEY,
  Airline VARCHAR(45) NOT NULL,
  Weekdays VARCHAR(45) NOT NULL
);

CREATE TABLE FLIGHT_LEG (
  Flight_number VARCHAR(45),
  Leg_number VARCHAR(45) PRIMARY KEY,
  Departure_airport_code VARCHAR(45) NOT NULL,
  Scheduled_departure_time DATETIME NOT NULL,
  Arrival_airport_code VARCHAR(45) NOT NULL,
  Scheduled_arrival_time DATETIME NOT NULL,
  FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number),
  FOREIGN KEY (Departure_airport_code) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY (Arrival_airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE LEG_INSTANCE (
  Flight_number VARCHAR(45),
  Leg_number VARCHAR(45),
  Flight_date DATE PRIMARY KEY,
  Number_of_available_seats INT NOT NULL,
  Airplane_id INT NOT NULL,
  Departure_airport_code VARCHAR(45) NOT NULL,
  Departure_time DATETIME NOT NULL,
  Arrival_airport_code VARCHAR(45) NOT NULL,
  Arrival_time DATETIME NOT NULL,
  FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number),
  FOREIGN KEY (Leg_number) REFERENCES FLIGHT_LEG(Leg_number),
  FOREIGN KEY (Departure_airport_code) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY (Arrival_airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE FARE (
  Flight_number VARCHAR(45),
  Fare_code VARCHAR(45) PRIMARY KEY,
  Amount INT NOT NULL,
  Restrictions VARCHAR(250) NULL,
  FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number)
);

CREATE TABLE AIRPLANE_TYPE (
  Airplane_type_name VARCHAR(45) PRIMARY KEY,
  Max_seats INT(3) NOT NULL,
  Company VARCHAR(45) NOT NULL
);

CREATE TABLE CAN_LAND (
  Airplane_type_name VARCHAR(45),
  Airport_code VARCHAR(45),
  FOREIGN KEY (Airplane_type_name) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
  FOREIGN KEY (Airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE AIRPLANE (
  Airplane_id INT PRIMARY KEY,
  Total_number_of_seats INT(3) NOT NULL,
  Airplane_type VARCHAR(45),
  FOREIGN KEY (Airplane_type) REFERENCES AIRPLANE_TYPE(Airplane_type_name)
);

CREATE TABLE SEAT_RESERVATION (
  Flight_number VARCHAR(45),
  Leg_number VARCHAR(45),
  Seat_reservation_date DATE,
  Seat_number INT PRIMARY KEY,
  Customer_name VARCHAR(45) NOT NULL,
  Customer_phone VARCHAR(45) NOT NULL,
  FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number),
  FOREIGN KEY (Leg_number) REFERENCES FLIGHT_LEG(Leg_number),
  FOREIGN KEY (Seat_reservation_date) REFERENCES LEG_INSTANCE(Flight_date)
);

ALTER TABLE LEG_INSTANCE ADD FOREIGN KEY (Airplane_id) REFERENCES AIRPLANE(Airplane_id);

-- PART 2
/* Using the Elmasri COMPANY database (Figure 5.5, 5.6 and the SQL Schema posted to
GitHub), complete the following tasks: */

/* Problem 1a: For each department whose average employee salary is more than $30,000,
retrieve the department name and the number of employees working for that
department. */

select d.Dname, count(*)
from EMPLOYEE as e, DEPARTMENT as d
where d.Dnumber = e.Dno
group by d.Dname having avg(Salary)>30000;

-- OR

SELECT Dname , cnt
FROM
  (SELECT Dname , COUNT(Fname) as cnt, AVG(Salary) as salary
  FROM department
  INNER JOIN employee ON employee.Dno = department.Dnumber
  GROUP BY Dname) a
WHERE salary > 30000

/*Problem 1b: Suppose that we want the number of male employees in each department
making more than $30,000, rather than all employees (as in Exercise a). Can we
specify this query in SQL? Why or why not? */

select d.Dname, e.gender, count(*)
from EMPLOYEE as e, DEPARTMENT as d
where d.Dnumber = e.Dno and gender='M'
group by d.Dname having avg(Salary)>30000;

/* Problem 2a: Retrieve the names of all employees who work in the department that has the
employee with the highest salary among all employees.
*/

select Fname, Lname, Dno
from employee
where Dno = (select Dno from employee order by Salary desc limit 1);

-- OR

SELECT Fname, Dname, MAX(Salary)
FROM employee
INNER JOIN department ON employee.Dno = department.Dnumber
GROUP BY Dno

/* Problem 2b: Retrieve the names of all employees whose supervisorʼs supervisor has
‘888665555ʼ for Ssn.
*/

SELECT Fname
FROM employee
WHERE Super_ssn IN
  ( SELECT Ssn
    FROM employee
    WHERE Super_ssn = 888665555 )

/*
Problem 2c: Retrieve the names of employees who make at least $10,000 more than the
employee who is paid the least in the company.
*/

SELECT Fname, Salary
FROM employee
WHERE Salary-10000 > (SELECT MIN(Salary)
                      FROM employee)

/*
Problem 3a: A view that has the department name, manager name, and manager salary
for every department.
*/

CREATE VIEW View1 AS
SELECT Dname DepartmentName, Fname ManagerName, Salary ManagerSalary
FROM employee e
INNER JOIN department d ON d.Dnumber = e.Dno
WHERE Salary IN
  (SELECT MAX(Salary)
   FROM employee e
     INNER JOIN department d ON d.Dnumber = e.Dno
     GROUP BY Dno)

/*
Problem 3b: A view that has the employee name, supervisor name, and employee salary
for each employee who works in the ‘Researchʼ department.
*/

CREATE VIEW View2 AS
SELECT e2.Fname EmployeeName, e1.Fname SupervisorName, e2.Salary EmployeeSalary
FROM employee e1
JOIN employee e2 ON e1.Ssn = e2.Super_ssn
INNER JOIN department d ON e2.Dno = d.Dnumber
WHERE e2.Super_ssn IN
  (SELECT Ssn
   FROM employee) AND Dname LIKE 'Research'
ORDER BY e2.Fname

/*
A view that has the project name, controlling department name, number of
employees, and total hours worked per week on the project for each project.
*/

CREATE VIEW View3 AS
SELECT Pname ProjectName, Dname ControllingDepartmentName, COUNT(Essn) NumberOfEmployees, SUM(Hours) TotalHoursWorkedPerWeek
FROM project p
INNER JOIN department d ON p.Dnum = d.Dnumber
INNER JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY Pname

-- END ASSIGNMENT
-- Special thanks to Cole and Nursultan for their code!
