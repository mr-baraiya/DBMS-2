-- Creating PersonInfo Table

CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL
);

--From the above given tables perform the following queries:
--Part – A
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display
--a message “Record is Affected.”
create or alter trigger tr_personalInfo_1
on PersonInfo
after insert,update,delete
as
begin
	print 'record is affected';
end

insert into PersonInfo values(101,'Parva',9999,'2025-01-01','Gondal',19,'2005-11-28');

update PersonInfo
set PersonName = 'Karia Parv'
where PersonID = 101;

delete from PersonInfo
where PersonID = 101;

drop trigger tr_personalInfo_1;
--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.
--Trigger on Insert
create or alter trigger tr_PersonInfo_2
on PersonInfo
after insert
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from inserted;

	insert into PersonLog values
	(@pid,@pName,'Insert',GETDATE());
end

insert into PersonInfo values(101,'Parva',9999,'2025-01-01','Rajkot',19,'2005-11-28');

drop trigger tr_PersonInfo_2;
select * from PersonLog;
select * from PersonInfo;
--Trigger on Update
create or alter trigger tr_PersonInfo_2
on PersonInfo
after update
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from inserted;

	insert into PersonLog values
	(@pid,@pName,'Update',GETDATE());
end

update PersonInfo
set PersonName = 'Karia Parv'
where PersonID = 101;

drop trigger tr_PersonInfo_2;
select * from PersonLog;
select * from PersonInfo;

--Trigger on Delete
create or alter trigger tr_PersonInfo_2
on PersonInfo
after delete
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from deleted;

	insert into PersonLog values
	(@pid,@pName,'Delete',GETDATE());
end

delete from PersonInfo
where PersonID = 101;

drop trigger tr_PersonInfo_2;
select * from PersonLog;
select * from PersonInfo;

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo
--table. For that, log all operations performed on the person table into PersonLog.
--Instead Of Trigger on Insert
create or alter trigger tr_PersonInfo_3
on PersonInfo
instead of insert
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from inserted;

	insert into PersonLog values
	(@pid,@pName,'Insert',GETDATE());
end

insert into PersonInfo values(106,'abcd',9999,'2025-01-01','Rajkot',19,'2005-11-28');

drop trigger tr_PersonInfo_3;
select * from PersonLog;
select * from PersonInfo;
--Trigger on Update
create or alter trigger tr_PersonInfo_3
on PersonInfo
instead of update
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from inserted;

	insert into PersonLog values
	(@pid,@pName,'Update',GETDATE());
end

update PersonInfo
set PersonName = 'Karia Parv'
where PersonID = 101;

drop trigger tr_PersonInfo_3;
select * from PersonLog;
select * from PersonInfo;

--Trigger on Delete
create or alter trigger tr_PersonInfo_3
on PersonInfo
instead of delete
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from deleted;

	insert into PersonLog values
	(@pid,@pName,'Delete',GETDATE());
end

delete from PersonInfo
where PersonID = 101;

drop trigger tr_PersonInfo_3;
select * from PersonLog;
select * from PersonInfo;

--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into
--uppercase whenever the record is inserted.
create or alter trigger tr_PersonInfo_4
on PersonInfo
after insert
as
begin
	declare @pid int , @pName varchar(50);
	select @pid = PersonID , @pName = PersonName from inserted;

	update PersonInfo
	set PersonName = upper(@pName)
	where @pid = PersonId;
end

insert into PersonInfo values(109,'Arjun Bala',9999,'2025-01-01','Rajkot',19,'2005-11-28');

drop trigger tr_PersonInfo_4;
select * from PersonInfo;

--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
create or alter trigger tr_PersonInfo_5
on PersonInfo
instead of insert
as
begin
	insert into PersonInfo
	select
		PersonID,
		PersonName,
		Salary,
		JoiningDate,
		City,
		Age,
		BirthDate
	from inserted
	where PersonName not in (select PersonName from PersonInfo);
end

insert into PersonInfo values(110,'Visha',9999,'2025-01-01','Rajkot',19,'2005-11-28');

drop trigger tr_PersonInfo_5;
select * from PersonInfo;
--6. Create trigger that prevent Age below 18 years.
create or alter trigger tr_PersonInfo_6
on PersonInfo
instead of insert
as
begin
	insert into PersonInfo
	select
		PersonID,
		PersonName,
		Salary,
		JoiningDate,
		City,
		Age,
		BirthDate
	from inserted
	where Age >= 18;
end

insert into PersonInfo values(106,'Vishal',9999,'2025-01-01','Rajkot',18,'2005-11-28');
drop trigger tr_PersonInfo_6;
select * from PersonInfo;

--Part – B
--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update
--that age in Person table.
--8. Create a Trigger to Limit Salary Decrease by a 10%.
--Part – C
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.
--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog’.