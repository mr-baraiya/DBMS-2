--Part – A
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display 
--a message “Record is Affected.” 

--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, 
--log all operations performed on the person table into PersonLog.
--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo 
--table. For that, log all operations performed on the person table into PersonLog.
--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into 
--uppercase whenever the record is inserted.
--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
--6. Create trigger that prevent Age below 18 years.

--Part – B
--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update 
--that age in Person table.
--8. Create a Trigger to Limit Salary Decrease by a 10%.

--Part – C 
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL 
--during an INSERT.
--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints 
--‘Record deleted successfully from PersonLog’.