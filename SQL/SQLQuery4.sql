--Note: for Table valued function use tables of Lab-2
select * from Department;
select * from Designation;
select * from Person;
--Part – A
--1. Write a function to print "hello world".
create or alter function FN_Print_Hello_World()
returns varchar(50)
as 
begin
	return 'Hello World'
end

select dbo.FN_Print_Hello_World()
--2. Write a function which returns addition of two numbers.
create or alter function FN_Add_Two_Number(@n1 int,@n2 int)
returns int
as 
begin
    declare @sum int
	set @sum = @n1 + @n2
	return @sum
end

select dbo.FN_Add_Two_Number(12,34);
--3. Write a function to check whether the given number is ODD or EVEN.
create or alter function FN_Even_Odd(@n int)
returns varchar(50)
as
begin
	declare @ans varchar(50);
	if (@n % 2 = 0)
		set @ans = 'Even'
	else
		set @ans = 'Odd'
	return @ans
end

select dbo.FN_Even_Odd(1)
--4. Write a function which returns a table with details of a person whose first name starts with B.
create or alter function FN_Person_Strat_With_B()
returns table
as
	return(
		select * from Person
		where FirstName like '%b%'
	)

select * from dbo.FN_Person_Strat_With_B()
--5. Write a function which returns a table with unique first names from the person table.
create or alter function FN_Person_Unique_FirstName()
returns table
as
	return(
		select distinct FirstName from Person
	)
select * from dbo.FN_Person_Unique_FirstName()
--6. Write a function to print number from 1 to N. (Using while loop)
create or alter function FN_Person_Print_1_To_N(@n int)
returns varchar(500)
as
begin
	declare @ans varchar(500) = ' ';
	declare @i int = 1;
	while @i <= @n
	begin
		set @ans = @ans + cast(@i as varchar) + ' '
		set @i = @i + 1
	end
	return @ans
end
select dbo.FN_Person_Print_1_To_N(10)
--7. Write a function to find the factorial of a given integer.
create or alter function FN_Find_Factorial(@n int)
returns bigint
as
begin
	declare @ans bigint = 1;
	declare @i int = 1;
	while @i <= @n
	begin
		set @ans = @ans * @i
		set @i = @i + 1
	end
	return @ans
end

select dbo.FN_Find_Factorial(5)

--Part – B
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
create or alter function FN_Compare_Two_Numbers(@n1 int,@n2 int)
returns varchar(50)
as
begin
	return case
		when @n1 > @n2
			then cast(@n1 As varchar) + ' Is Grater Then ' + cast(@n2 As varchar)
		when @n1 < @n2
			then cast(@n1 As varchar) + ' Is Less Then ' + cast(@n2 As varchar)
		when @n1 = @n2
			then cast(@n1 As varchar) + ' Is Equal To ' + cast(@n2 As varchar)
		else 'Wrong Input!'
		end
end
select dbo.FN_Compare_Two_Numbers(15,13);
--9. Write a function to print the sum of even numbers between 1 to 20.
create or alter function FN_Sum_Of_Even_Numbers()
returns int
as 
begin
	declare @ans int = 0;
	declare @i int = 1;
	while @i <= 20
	begin
		if @i % 2 = 0
			set @ans = @ans + @i
		set @i = @i + 1
	end
	return @ans
end
select dbo.FN_Sum_Of_Even_Numbers();
--10. Write a function that checks if a given string is a palindrome
create or alter function FN_Check_Palindrome(@s varchar(100))
returns varchar(100)
as
begin
	declare @reverse_S varchar(100) = reverse(@s);
	declare @msg varchar(100) = ' '
	if @reverse_S = @s
		set @msg = @s + ' is Palindrome String.'
	else
		set @msg = @s + ' is Not Palindrome String.'
	return @msg
end
select dbo.FN_Check_Palindrome('Nayan')

--Part – C
--11. Write a function to check whether a given number is prime or not.
create or alter function FN_Prime_Number(@n int)
returns varchar(50)
as 
begin
	declare @msg varchar(50) = ' ';
	declare @count int = 0;
	declare @i int = 1;
	while @i <= @n
	begin
		if @n % @i = 0
			set @count = @count + 1
		set @i = @i + 1
	end
	if @count = 2
		set @msg = cast(@n as varchar)+' is a Prime Number.'
	else
		set @msg = cast(@n as varchar)+' is Not a Prime Number.'
	return @msg
end
select dbo.FN_Prime_Number(19);
--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
create or alter function FN_Date_Difference(@date1 date,@date2 date)
returns int
as
begin
	declare @ans int;
	set @ans = DATEDIFF(DAY,@date1,@date2)
	return @ans
end
select dbo.FN_Date_Difference('2024-1-1','2024-1-25');

--13. Write a function which accepts two parameters year & month in integer and returns total days each year.
create or alter function FN_Total_Days(@y int,@m int)
returns int
as
begin
	declare @ans varchar(50);
	declare @date date;
	declare @days int;
	set @date = cast(@y as varchar) + '-' + cast(@m as varchar) + '-1'
	set @days = day(EOMONTH(@date))
	return @days
end
select dbo.FN_Total_Days(2024,8);
--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
create or alter function FN_Person_Deatails_By_DepartmentId(@did int)
returns table
as
	return
	(
		select * from Person
		where DepartmentID = @did
	)
select * from dbo.FN_Person_Deatails_By_DepartmentId(1);

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
create or alter function FN_Person_Details_By_JoineingDate(@jdate date)
returns table
as
	return
	(
		select * from Person
		where JoiningDate > @jdate
	)
select * from dbo.FN_Person_Details_By_JoineingDate('1991-1-1');