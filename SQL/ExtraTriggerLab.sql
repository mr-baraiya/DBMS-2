
-------------------------------------------------AFTER TRIGGER--------------------------------------------------

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID				Int Primary Key
	,EmployeeName			Varchar(100) Not Null
	,ContactNo				Varchar(100) Not Null
	,Department				Varchar(100) Not Null
	,Salary					Decimal(10,2) Not Null
	,JoiningDate			DateTime Null
);

CREATE TABLE EmployeeLogs (
	LogID						INT PRIMARY KEY IDENTITY(1,1)
	,EmployeeID					INT NOT NULL
	,EmployeeName				VARCHAR(100) NOT NULL
	,ActionPerformed			VARCHAR(100) NOT NULL
	,ActionDate					DATETIME NOT NULL
);

--1)	Create a trigger that fires AFTER INSERT,UPDATE,and DELETE operationson the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"

--------------------------------------------TR_EMPLOYEEDETAILS_INSERT------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_INSERT
on EMPLOYEEDETAILS
after INSERT
as BEGIN
	print 'Employee record inserted';
END

insert into EMPLOYEEDETAILS values (102,'Vishal Baraiya',1234567890,'CSE',10,'01-01-2025');
select * from EMPLOYEEDETAILS;
drop trigger TR_EMPLOYEEDETAILS_INSERT;

--------------------------------------------TR_EMPLOYEEDETAILS_UPDATE------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_UPDATE
on EMPLOYEEDETAILS
after UPDATE
as BEGIN
	print 'Employee record Updated';
END

update EMPLOYEEDETAILS
set EmployeeName = 'Bhadvo'
where EmployeeID = 102;
select * from EMPLOYEEDETAILS;
drop trigger TR_EMPLOYEEDETAILS_UPDATE;

--------------------------------------------TR_EMPLOYEEDETAILS_DELETE------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_DELETE
on EMPLOYEEDETAILS
after DELETE
as BEGIN
	print 'Employee record Deleted';
END

Delete from EMPLOYEEDETAILS
where EmployeeName = 'Bhadvo';

select * from EMPLOYEEDETAILS;
drop trigger TR_EMPLOYEEDETAILS_DELETE;

--2)	Create a trigger that fires AFTER INSERT,UPDATE,and DELETE operationson the EmployeeDetails table to log all operations into the EmployeeLog table.

--------------------------------------------TR_EMPLOYEEDETAILS_INSERT------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_INSERT
on EMPLOYEEDETAILS
after INSERT
as BEGIN
	DECLARE @EmployeeID				Int;
	DECLARE @EmployeeName			Varchar(100);
	SELECT @EmployeeID = EmployeeID , @EmployeeName = EmployeeName FROM inserted;
	INSERT INTO EmployeeLogs VALUES
	(@EmployeeID,@EmployeeName,'INSERT',GETDATE());
END

insert into EMPLOYEEDETAILS values (103,'Vishal Baraiya',1234567890,'CSE',10,'01-01-2025');
select * from EMPLOYEEDETAILS;
select * from EmployeeLogs;
drop trigger TR_EMPLOYEEDETAILS_INSERT;

--------------------------------------------TR_EMPLOYEEDETAILS_UPDATE------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_UPDATE
on EMPLOYEEDETAILS
after update
as BEGIN
	DECLARE @EmployeeID				Int;
	DECLARE @EmployeeName			Varchar(100);
	SELECT @EmployeeID = EmployeeID , @EmployeeName = EmployeeName FROM inserted;
	INSERT INTO EmployeeLogs VALUES
	(@EmployeeID,@EmployeeName,'UPDATE',GETDATE());
END

update EMPLOYEEDETAILS
set EmployeeName = 'Bhadvo'
where EmployeeID = 103;
select * from EMPLOYEEDETAILS;
select * from EmployeeLogs;
drop trigger TR_EMPLOYEEDETAILS_UPDATE;

--------------------------------------------TR_EMPLOYEEDETAILS_DELETE------------------------------------------------------
create or alter trigger TR_EMPLOYEEDETAILS_DELETE
on EMPLOYEEDETAILS
after DELETE
as BEGIN
	DECLARE @EmployeeID				Int;
	DECLARE @EmployeeName			Varchar(100);
	SELECT @EmployeeID = EmployeeID , @EmployeeName = EmployeeName FROM deleted;
	INSERT INTO EmployeeLogs VALUES
	(@EmployeeID,@EmployeeName,'DELETE',GETDATE());
END

Delete from EMPLOYEEDETAILS
where EmployeeID = 102;
select * from EMPLOYEEDETAILS;
select * from EmployeeLogs;
drop trigger TR_EMPLOYEEDETAILS_DELETE;

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.

CREATE OR ALTER TRIGGER TR_CALLCULATE_JIONING_BONUS
ON EMPLOYEEDETAILS
AFTER INSERT
AS BEGIN
	DECLARE @EmployeeID				Int;
	DECLARE @Salary					Decimal(10,2);
	SELECT @EmployeeID = EmployeeID , @Salary = Salary FROM inserted;

	UPDATE EMPLOYEEDETAILS
	SET Salary = @Salary + ( @Salary * 0.1)
	WHERE EmployeeID = @EmployeeID;
END

insert into EMPLOYEEDETAILS values (101,'Vishal Baraiya',1234567890,'CSE',10,'01-01-2025');
select * from EMPLOYEEDETAILS;
drop trigger TR_CALLCULATE_JIONING_BONUS;

--4)	Create	a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
CREATE OR ALTER TRIGGER TR_CALLCULATE_JOININGDATE
ON EMPLOYEEDETAILS
AFTER INSERT
AS BEGIN
	DECLARE @EmployeeID				Int;
	DECLARE @JoiningDate			DATETIME;
	SELECT @EmployeeID = EmployeeID , @JoiningDate = JoiningDate FROM inserted;

	IF @JoiningDate IS NULL
	BEGIN
		UPDATE EMPLOYEEDETAILS
		SET JoiningDate = GETDATE()
		WHERE EmployeeID = @EmployeeID;
	END
END

insert into EMPLOYEEDETAILS values (102,'Vishal Baraiya',1234567890,'CSE',10,NULL);
select * from EMPLOYEEDETAILS;
drop trigger TR_CALLCULATE_JOININGDATE;

--5)	Create a trigger that ensure that ContactNo is valid during insert and update(Like ContactNo length is 10)
 
CREATE OR ALTER TRIGGER TR_VALIDATE_CONTACTNO
ON EMPLOYEEDETAILS
AFTER INSERT,UPDATE
AS BEGIN
	DECLARE @EmployeeID			Int;
	DECLARE @ContactNo			INT;
	SELECT @EmployeeID = EmployeeID , @ContactNo = ContactNo FROM inserted;

	IF LEN(@ContactNo) != 10
	BEGIN
		DELETE FROM EMPLOYEEDETAILS
		WHERE EmployeeID = @EmployeeID;
	END
END

insert into EMPLOYEEDETAILS values (103,'Vishal Baraiya',123456789,'CSE',10,NULL);
select * from EMPLOYEEDETAILS;
drop trigger TR_VALIDATE_CONTACTNO;


-------------------------------------------------INSTEAD OF TRIGGER--------------------------------------------------

CREATE TABLE Movies (
	MovieID INT PRIMARY KEY
	,MovieTitle		VARCHAR(255) NOT NULL
	,ReleaseYear	INT NOT NULL
    ,Genre			VARCHAR(100) NOT NULL
    ,Rating			DECIMAL(3, 1) NOT NULL
    ,Duration		INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID				INT PRIMARY KEY IDENTITY(1,1)
	,MovieID			INT NOT NULL
	,MovieTitle			VARCHAR(255) NOT NULL
	,ActionPerformed	VARCHAR(100) NOT NULL
	,ActionDate			DATETIME  NOT NULL
);

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.

--------------------------------------------TR_MOVIES_INSERT------------------------------------------------------
create or alter trigger TR_MOVIES_INSERT
on MOVIES
INSTEAD OF INSERT
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	DECLARE @ReleaseYear	INT;
	DECLARE @Genre			VARCHAR(100);
	DECLARE @Rating			DECIMAL(3, 1);
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
		,@ReleaseYear	= ReleaseYear
		,@Genre			= Genre
		,@Rating		= Rating
		,@Duration		= Duration
	FROM inserted;

	INSERT INTO MOVIES VALUES
	(@MovieID,@MovieTitle,@ReleaseYear,@Genre,@Rating,@Duration);

	INSERT INTO MoviesLog VALUES
	(@MovieID,@MovieTitle,'INSERT',GETDATE());
END

insert into MOVIES values (101,'PUSHPA 2',2024,'ABCD',6.7,3);
select * from MOVIES;
select * from MoviesLog;
drop trigger TR_MOVIES_INSERT;

--------------------------------------------TR_MOVIES_UPDATE------------------------------------------------------
create or alter trigger TR_MOVIES_UPDATE
on MOVIES
INSTEAD OF UPDATE
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	DECLARE @ReleaseYear	INT;
	DECLARE @Genre			VARCHAR(100);
	DECLARE @Rating			DECIMAL(3, 1);
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
		,@ReleaseYear	= ReleaseYear
		,@Genre			= Genre
		,@Rating		= Rating
		,@Duration		= Duration
	FROM inserted;

	UPDATE MOVIES
	SET MovieTitle	= @MovieTitle
	,ReleaseYear	= @ReleaseYear
	,Genre			= @Genre
	,Rating			= @Rating
	,Duration		= @Duration
	WHERE MovieID = @MovieID;

	INSERT INTO MoviesLog VALUES
	(@MovieID,@MovieTitle,'UPDATE',GETDATE());
END

UPDATE Movies
SET MovieTitle = 'PUSHPA'
WHERE MovieID = 101;

select * from MOVIES;
select * from MoviesLog;
drop trigger TR_MOVIES_UPDATE;

--------------------------------------------TR_MOVIES_DELETE------------------------------------------------------
create or alter trigger TR_MOVIES_DELETE
on MOVIES
INSTEAD OF DELETE
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
	FROM deleted;

	DELETE FROM MOVIES
	WHERE MovieID = @MovieID;

	INSERT INTO MoviesLog VALUES
	(@MovieID,@MovieTitle,'DELETE',GETDATE());
END

DELETE FROM Movies
WHERE MovieID = 101;

select * from MOVIES;
select * from MoviesLog;

drop trigger TR_MOVIES_DELETE;

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .

create or alter trigger TR_MOVIES_INSERT
on MOVIES
INSTEAD OF INSERT
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	DECLARE @ReleaseYear	INT;
	DECLARE @Genre			VARCHAR(100);
	DECLARE @Rating			DECIMAL(3, 1);
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
		,@ReleaseYear	= ReleaseYear
		,@Genre			= Genre
		,@Rating		= Rating
		,@Duration		= Duration
	FROM inserted;

	IF @Rating > 5.5
	BEGIN
		INSERT INTO MOVIES VALUES
		(@MovieID,@MovieTitle,@ReleaseYear,@Genre,@Rating,@Duration);
	END
END

insert into MOVIES values (102,'SKY FORCE',2025,'MADDOCK FILMS',9.5,3);
select * from MOVIES;
drop trigger TR_MOVIES_INSERT;

--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.

create or alter trigger TR_MOVIES_PREVENT_DUPLICATE
on MOVIES
INSTEAD OF INSERT
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	DECLARE @ReleaseYear	INT;
	DECLARE @Genre			VARCHAR(100);
	DECLARE @Rating			DECIMAL(3, 1);
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
		,@ReleaseYear	= ReleaseYear
		,@Genre			= Genre
		,@Rating		= Rating
		,@Duration		= Duration
	FROM inserted;

	IF @MovieTitle NOT IN ( SELECT MovieTitle FROM Movies )
	BEGIN
		INSERT INTO MOVIES VALUES
		(@MovieID,@MovieTitle,@ReleaseYear,@Genre,@Rating,@Duration);
	END
	
	INSERT INTO MoviesLog VALUES
	(@MovieID,@MovieTitle,'INSERT',GETDATE());
END

insert into MOVIES values (103,'PUSHPA',2024,'ABCD',6.7,3);
select * from MOVIES;
select * from MoviesLog;
drop trigger TR_MOVIES_PREVENT_DUPLICATE;

--4.	Create trigger that prevents to insert pre-release movies.

create or alter trigger TR_MOVIES_PREVENT_PRE_RELEASE
on MOVIES
INSTEAD OF INSERT
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @MovieTitle		VARCHAR(255);
	DECLARE @ReleaseYear	INT;
	DECLARE @Genre			VARCHAR(100);
	DECLARE @Rating			DECIMAL(3, 1);
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@MovieTitle	= MovieTitle
		,@ReleaseYear	= ReleaseYear
		,@Genre			= Genre
		,@Rating		= Rating
		,@Duration		= Duration
	FROM inserted;

	IF @ReleaseYear = DATEPART(YEAR,GETDATE())
	BEGIN
		INSERT INTO MOVIES VALUES
		(@MovieID,@MovieTitle,@ReleaseYear,@Genre,@Rating,@Duration);
	END
	
	INSERT INTO MoviesLog VALUES
	(@MovieID,@MovieTitle,'INSERT',GETDATE());
END

insert into MOVIES values (104,'DEVA',2025,'ABCD',6.7,3);
select * from MOVIES;
select * from MoviesLog;
drop trigger TR_MOVIES_PREVENT_PRE_RELEASE;

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
create or alter trigger TR_MOVIES_UPDATE
on MOVIES
INSTEAD OF UPDATE
as BEGIN
	DECLARE @MovieID		INT;
	DECLARE @Duration		INT;

	SELECT 
		@MovieID		= MovieID
		,@Duration		= Duration
	FROM inserted;
	IF @Duration <= 2
	BEGIN
		UPDATE MOVIES
		SET Duration = @Duration
		WHERE MovieID = @MovieID;
	END
END

UPDATE Movies
SET Duration = 2
WHERE MovieID = 102;

select * from MOVIES;
select * from MoviesLog;
drop trigger TR_MOVIES_UPDATE;
