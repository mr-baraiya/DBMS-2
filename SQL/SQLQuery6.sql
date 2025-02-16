--Part - A

-- Create the Products table
CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
-- Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);

select * from Products;

--1. Create a cursor Product_Cursor to fetch all the rows from a products table.
declare @Pid INT;
declare @PName VARCHAR(250);
declare @Price DECIMAL(10, 2);

declare Cursor_Product_Details Cursor
for
	select * from Products;

open Cursor_Product_Details;

fetch next from Cursor_Product_Details
into @Pid , @PName , @Price;

while @@FETCH_STATUS = 0
	begin
		print cast(@Pid as varchar(10)) + ' ' + @PName + ' ' + cast(@Price as varchar(10));
		fetch next from Cursor_Product_Details
		into @Pid , @PName , @Price;
	end

close Cursor_Product_Details;
deallocate Cursor_Product_Details;
--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName.
--(Example: 1_Smartphone)
declare @Pid INT;
declare @PName VARCHAR(250);

declare Cursor_Product_Cursor_Fetch Cursor
for
	select Product_id,Product_Name from Products;

open Cursor_Product_Cursor_Fetch;

fetch next from Cursor_Product_Cursor_Fetch
into @Pid , @PName ;

while @@FETCH_STATUS = 0
	begin
		print cast(@Pid as varchar(10)) + '_' + @PName;
		fetch next from Cursor_Product_Cursor_Fetch
		into @Pid , @PName;
	end
close Cursor_Product_Cursor_Fetch;
deallocate Cursor_Product_Cursor_Fetch;
--3. Create a Cursor to Find and Display Products Above Price 30,000.
declare @Pid INT;
declare @PName VARCHAR(250);
declare @Price DECIMAL(10, 2);
declare Cursor_Product_Cursor_3 Cursor
for
	select * from Products;

open Cursor_Product_Cursor_3;

fetch next from Cursor_Product_Cursor_3
into @Pid , @PName , @Price;

while @@FETCH_STATUS = 0
	begin
		IF @Price > 30000
			PRINT cast(@Pid as varchar(10)) + ' ' + @PName + ' ' + cast(@Price as varchar(10));

		fetch next from Cursor_Product_Cursor_3
		into @Pid , @PName , @Price;
	end

close Cursor_Product_Cursor_3;
deallocate Cursor_Product_Cursor_3;
--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
DECLARE @PID INT;
DECLARE Product_CursorDelete CURSOR
FOR
	SELECT Product_id FROM Products;

OPEN Product_CursorDelete;

FETCH NEXT FROM Product_CursorDelete
INTO @PID;

WHILE @@FETCH_STATUS = 0
BEGIN
	DELETE FROM Products 
	WHERE Product_id = @PID;

	FETCH NEXT FROM Product_CursorDelete
	INTO @PID;
END
CLOSE Product_CursorDelete;
DEALLOCATE Product_CursorDelete;
SELECT * FROM Products;

--Part – B
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases
--the price by 10%.
declare @Pid INT;
declare @Price DECIMAL(10, 2);

declare Product_CursorUpdate Cursor
for
	select Product_id , Price from Products;

open Product_CursorUpdate;

fetch next from Product_CursorUpdate
into @Pid , @Price;

while @@FETCH_STATUS = 0
	begin
		UPDATE Products
		SET Price = @Price + (@Price * (10/100))
		WHERE Product_id = @Pid;

		fetch next from Product_CursorUpdate
		into @Pid , @Price;
	end

close Product_CursorUpdate;
deallocate Product_CursorUpdate;
SELECT * FROM Products;
--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
declare @Pid INT;

declare Product_Update_Price_To_nearestWholeNumber Cursor
for
	select Product_id from Products;

open Product_Update_Price_To_nearestWholeNumber;

fetch next from Product_Update_Price_To_nearestWholeNumber
into @Pid;

while @@FETCH_STATUS = 0
	begin
		UPDATE Products
		SET Price = ROUND(Price,0)
		WHERE Product_id = @Pid;

		fetch next from Product_Update_Price_To_nearestWholeNumber
		into @Pid;
	end

close Product_Update_Price_To_nearestWholeNumber;
deallocate Product_Update_Price_To_nearestWholeNumber;
SELECT * FROM Products;
--Part – C
--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
--(Note: Create NewProducts table first with same fields as Products table)

CREATE TABLE NewProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
select * from NewProducts;

declare @Pid INT;
declare @Pname VARCHAR(50);
declare @Price DECIMAL(10, 2);

declare Product_Insert_NewProducts Cursor
for
	select * from Products;

open Product_Insert_NewProducts;

fetch next from Product_Insert_NewProducts
into @Pid , @Pname , @Price;

while @@FETCH_STATUS = 0
	begin
		if (@PName = 'Laptop')
			INSERT INTO NewProducts (Product_id, Product_Name, Price) VALUES (@Pid, @PName, @Price);

		fetch next from Product_Insert_NewProducts
		into @Pid , @Pname , @Price;
	end

close Product_Insert_NewProducts;
deallocate Product_Insert_NewProducts;
SELECT * FROM NewProducts;
--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products 
--with a price above 50000 to an archive table, removing them from the original Products table
CREATE TABLE ArchivedProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
select * from ArchivedProducts;
SELECT * FROM Products;

declare @Pid INT;
declare @Pname VARCHAR(50);
declare @Price DECIMAL(10, 2);

declare Product_Insert_ArchivedProducts Cursor
for
	select * from Products;

open Product_Insert_ArchivedProducts;

fetch next from Product_Insert_ArchivedProducts
into @Pid , @Pname , @Price;

while @@FETCH_STATUS = 0
	begin
		if (@Price > 50000)
		Begin
			INSERT INTO ArchivedProducts (Product_id, Product_Name, Price) VALUES (@Pid, @PName, @Price);
			delete from Products where Product_id = @Pid;
		end

		fetch next from Product_Insert_ArchivedProducts
		into @Pid , @Pname , @Price;
	end

close Product_Insert_ArchivedProducts;
deallocate Product_Insert_ArchivedProducts;
SELECT * FROM Products;
SELECT * FROM ArchivedProducts;