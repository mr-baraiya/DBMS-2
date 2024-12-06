-- Create Department Table
CREATE TABLE Department (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
 DesignationID INT PRIMARY KEY,
 DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
 PersonID INT PRIMARY KEY IDENTITY(101,1),
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8, 2) NOT NULL,
 JoiningDate DATETIME NOT NULL,
 DepartmentID INT NULL,
 DesignationID INT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
 FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

--Part – A
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.
--INSERT DEPARTMENT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_INSERT
@DID INT,
@DNAME VARCHAR(100)
AS
BEGIN
	INSERT INTO Department VALUES( @DID,@DNAME)
END

EXEC PR_DEPARTMENT_INSERT 1,'ADMIN';
EXEC PR_DEPARTMENT_INSERT 2,'IT';
EXEC PR_DEPARTMENT_INSERT 3,'HR';
EXEC PR_DEPARTMENT_INSERT 4,'ACCOUNT';

SELECT * FROM Department;

--INSERT DESIGNATION
CREATE OR ALTER PROCEDURE PR_DESIGNATION_INSERT
@DEID INT,
@DENAME VARCHAR(100)
AS
BEGIN
	INSERT INTO Designation VALUES( @DEID,@DENAME)
END

EXEC PR_DESIGNATION_INSERT 11,'JOBBER';
EXEC PR_DESIGNATION_INSERT 12,'WELDER';
EXEC PR_DESIGNATION_INSERT 13,'CLERK';
EXEC PR_DESIGNATION_INSERT 14,'MANAGER';
EXEC PR_DESIGNATION_INSERT 15,'CEO';

SELECT * FROM Designation;

--INSERT PERSON
CREATE OR ALTER PROCEDURE PR_PERSON_INSERT
@FNAME VARCHAR(50),
@LNAME VARCHAR(50),
@SALARY DECIMAL(8,2),
@JOINEINGDATE DATETIME,
@DPID INT,
@DSID INT
AS
BEGIN
	INSERT INTO Person (FirstName,LastName,Salary,JoiningDate,DepartmentID,DesignationID)
	VALUES (@FNAME,@LNAME,@SALARY,@JOINEINGDATE,@DPID,@DSID)
END

EXEC PR_PERSON_INSERT 'RAHUL','ANSHU',56000,'1990-01-01',1,12;
EXEC PR_PERSON_INSERT 'HARDIK','HINSHU',18000,'1990-09-25',2,11;
EXEC PR_PERSON_INSERT 'BHAVIN','KAMANI',25000,'1991-05-14',NULL,11;
EXEC PR_PERSON_INSERT 'BHOOMI','PATEL',39000,'2014-02-20',1,13;
EXEC PR_PERSON_INSERT 'ROHIT','RAJGOR',17000,'1990-07-23',2,15;
EXEC PR_PERSON_INSERT 'PRIYA','MEHTA',25000,'1990-10-18',2,NULL;
EXEC PR_PERSON_INSERT 'NEHA','TRIVEDI',18000,'2014-02-20',3,15;

SELECT * FROM Person;

--UPDATE DEPARTMENT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_UPDATE
@DPID INT,
@DNAME VARCHAR(50)
AS
BEGIN
	UPDATE Department
	SET DepartmentName = @DNAME
	WHERE DepartmentID = @DPID;
END

EXEC PR_DEPARTMENT_UPDATE 2 , 'IT';
SELECT * FROM Department;

--UPDATE DESIGNATION
CREATE OR ALTER PROCEDURE PR_DESIGNATION_UPDATE
@DSID INT,
@DSNAME VARCHAR(50)
AS
BEGIN
	UPDATE Designation
	SET DesignationName = @DSNAME
	WHERE DesignationID = @DSID;
END

EXEC PR_DESIGNATION_UPDATE 11 , 'JOBBER';
SELECT * FROM Designation;

--UPDATE PERSON
CREATE OR ALTER PROCEDURE PR_PERSON_UPDATE
@PERSONID INT,
@FNAME VARCHAR(50),
@LNAME VARCHAR(50),
@SALARY DECIMAL(8,2),
@JOINEINGDATE DATETIME,
@DEPARTMENTID INT,
@DESIGNATIONID INT
AS
BEGIN
	UPDATE PERSON
	SET
	FirstName = @FNAME,
	LastName = @LNAME,
	Salary = @SALARY,
	JoiningDate = @JOINEINGDATE,
	DepartmentID = @DEPARTMENTID,
	DesignationID = @DESIGNATIONID
	WHERE PersonID = @PERSONID
END

EXEC PR_PERSON_UPDATE 101,'RAHUL','ANSHU',56000,'1990-01-01',1,12;
SELECT * FROM Person;

--DELETE DEPARTMENMT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DELETE
@DPID INT
AS
BEGIN
	DELETE FROM Department
	WHERE DepartmentID = @DPID
END

--DELETE DESINGNATION
CREATE OR ALTER PROCEDURE PR_DESIGNATION_DELETE
@DSID INT
AS
BEGIN
	DELETE FROM Designation
	WHERE DesignationID = @DSID
END

--PERSON DELETE
CREATE OR ALTER PROCEDURE PR_PERSON_DELETE
@PERSONID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PersonID = @PERSONID
END

--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY

--DEPARTMENT
CREATE OR ALTER PROC PR_DEPARTMENT_SELECTBYPRIMARYKEY
@DPID INT
AS
BEGIN
	SELECT * FROM Department
	WHERE DepartmentID = @DPID
END
EXEC PR_DEPARTMENT_SELECTBYPRIMARYKEY 3

--DESIGNATION
CREATE OR ALTER PROC PR_DESIGNATION_SELECTBYPRIMARYKEY
@DSID INT
AS
BEGIN
SELECT * FROM Designation
WHERE DesignationID = @DSID
END
EXEC PR_DESIGNATION_SELECTBYPRIMARYKEY 11;

--PERSON
CREATE OR ALTER PROC PR_PERSON_SELECTBYPRIMARYKEY
@PERSONID INT
AS
BEGIN
	SELECT * FROM PERSON
	WHERE PersonID = @PERSONID
END
EXEC PR_PERSON_SELECTBYPRIMARYKEY 104;

--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take
--columns on select list)
--DEPARTMENT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECTALL
AS BEGIN
	SELECT * FROM Department;
END
EXEC PR_DEPARTMENT_SELECTALL;

--DESIGNATION
CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECTALL
AS BEGIN
	SELECT * FROM Designation;
END
EXEC PR_DESIGNATION_SELECTALL;

--PERSON
CREATE OR ALTER 
--4. Create a Procedure that shows details of the first 3 persons.
--Part – B
--5. Create a Procedure that takes the department name as input and returns a table with all workers
--working in that department.
--6. Create Procedure that takes department name & designation name as input and returns a table with
--worker’s first name, salary, joining date & department name.
--7. Create a Procedure that takes the first name as an input parameter and display all the details of the
--worker with their department & designation name.
--8. Create Procedure which displays department wise maximum, minimum & total salaries.
--9. Create Procedure which displays designation wise average & total salaries.
--Part – C
--10. Create Procedure that Accepts Department Name and Returns Person Count.
--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than
--input salary value along with their department and designation details.
--12. Create a procedure to find the department(s) with the highest total salary among all departments.
--13. Create a procedure that takes a designation name as input and returns a list of all workers under that
--designation who joined within the last 10 years, along with their department.
--14. Create a procedure to list the number of workers in each department who do not have a designation
--assigned.
--15. Create a procedure to retrieve the details of workers in departments where the average salary is above
--12000.