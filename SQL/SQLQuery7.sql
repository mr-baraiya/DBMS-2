--From the above given tables perform the following queries: 

-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY, 
 Customer_Name VARCHAR(250) NOT NULL, 
 Email VARCHAR(50) UNIQUE 
);

-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY, 
 Customer_id INT, 
 Order_date DATE NOT NULL, 
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id) 
);

-- Insert dummy data into Customers table
INSERT INTO Customers (Customer_id, Customer_Name, Email) VALUES
(1, 'John Doe', 'johndoe@example.com'),
(2, 'Jane Smith', 'janesmith@example.com'),
(3, 'Alice Johnson', 'alicejohnson@example.com'),
(4, 'Bob Brown', 'bobbrown@example.com'),
(5, 'Charlie Davis', 'charliedavis@example.com');

-- Insert dummy data into Orders table
INSERT INTO Orders (Order_id, Customer_id, Order_date) VALUES
(101, 1, '2024-02-10'),
(102, 2, '2024-02-11'),
(103, 3, '2024-02-12'),
(104, 4, '2024-02-13'),
(105, 5, '2024-02-14');

select * from Customers;
select * from Orders;
--Part – A

--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
	DECLARE @NUM1 INT = 10, @NUM2 INT = 0, @RESULT INT;
	SET @RESULT = @NUM1 / @NUM2;
END TRY
BEGIN CATCH
	PRINT 'ERROR OCCURS THAT IS - DIVIDE BY ZERO ERROR.'
END CATCH;

--2. Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
	DECLARE @STRVALUE VARCHAR(10) = 'ABC';
	DECLARE @INTVALUE INT;
	SET @INTVALUE = CAST(@STRVALUE AS INT);
END TRY
BEGIN CATCH
	PRINT 'ERROR : UNABLE TO CONVERT STRING TO INTEGER.'
END CATCH

--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle.
--exception with all error functions if any one enters string value in numbers otherwise print result.

CREATE OR ALTER PROCEDURE PR_SUM_OF_TWO_NUMBERS
@NUM1 VARCHAR(10),
@NUM2 VARCHAR(10)
AS BEGIN
	BEGIN TRY
		DECLARE @SUM INT;
		SET @SUM = CAST(@NUM1 AS INT) + CAST(@NUM2 AS INT);

		PRINT @NUM1 + ' + ' + @NUM2 + ' = ' + CAST(@SUM AS VARCHAR(50));
	END TRY
	BEGIN CATCH
		SELECT CAST ( ERROR_NUMBER() AS VARCHAR(50) ) as ERROR_NUMBER,
		CAST ( ERROR_STATE() AS VARCHAR(50) ) as ERROR_STATE,
		CAST ( ERROR_SEVERITY() AS VARCHAR(50) ) as ERROR_SEVERITY,
		ERROR_MESSAGE() as ERROR_MESSAGE;
	END CATCH
END

EXEC PR_SUM_OF_TWO_NUMBERS '12' , 'QWE';

--4. Handle a Primary Key Violation while inserting data into customers table and print the error details 
--such as the error message, error number, severity, and state.

BEGIN TRY
	INSERT INTO Customers VALUES
	( 1 , 'VISHAL BARAIYA' , 'baraiyavishalbhai32@gmail.com');
END TRY
BEGIN CATCH
	SELECT CAST ( ERROR_NUMBER() AS VARCHAR(50) ) as ERROR_NUMBER,
	CAST ( ERROR_STATE() AS VARCHAR(50) ) as ERROR_STATE,
	CAST ( ERROR_SEVERITY() AS VARCHAR(50) ) as ERROR_SEVERITY,
	ERROR_MESSAGE() as ERROR_MESSAGE;
END CATCH

--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws 
--Error like no Customer_id is available in database.

CREATE OR ALTER PROCEDURE PR_SELECT_CUSTMER_BY_CUSTMER_ID
@CUSTMERID INT
AS BEGIN
	IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @CUSTMERID )
		BEGIN
			THROW 50001 , ' NO CUSTMER ID IS AVAILABLE DATABASE. ', 1;
		END
	ELSE
		SELECT * FROM Customers WHERE Customer_id = @CUSTMERID;
END

EXEC PR_SELECT_CUSTMER_BY_CUSTMER_ID 11;

--Part – B

--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error message.
BEGIN TRY
	INSERT INTO Orders VALUES
	( 1 , 999 , GETDATE());
END TRY
BEGIN CATCH
	PRINT 'Foreign Key Violation Error Occured: Invalid Custmer_id.'
END CATCH;
--7. Throw custom exception that throws error if the data is invalid.
CREATE OR ALTER PROCEDURE PR_DATAVALIDATION_CHECKPOSITIVEVALUE
@VALUE INT
AS BEGIN
	IF @VALUE < 0
	BEGIN
		THROW 50002 , ' INVALID DATA: VALUE CANNOT BE NEGATIVE.',1;
	END
	ELSE
	BEGIN
		PRINT 'DATA IS VALID.';
	END
END

EXEC PR_DATAVALIDATION_CHECKPOSITIVEVALUE -12;

--8. Create a Procedure to Update Customer’s Email with Error Handling.

CREATE OR ALTER PROCEDURE PR_CUSTMER_UPDATE_EMAIL
@CUSTMERID INT,
@EMAIL VARCHAR(100)
AS BEGIN
	BEGIN TRY
		IF @EMAIL NOT LIKE '_%@_%._%'
		BEGIN
			THROW 50001 , ' ERROR : INVALID EMAIL FORMAT.' , 1;
		END
		ELSE
		BEGIN
			UPDATE Customers
			SET Email = @EMAIL
			WHERE Customer_id = @CUSTMERID
		END
	END TRY
	BEGIN CATCH
		SELECT CAST ( ERROR_NUMBER() AS VARCHAR(50) ) as ERROR_NUMBER,
		CAST ( ERROR_STATE() AS VARCHAR(50) ) as ERROR_STATE,
		CAST ( ERROR_SEVERITY() AS VARCHAR(50) ) as ERROR_SEVERITY,
		ERROR_MESSAGE() as ERROR_MESSAGE;
	END CATCH
END

EXEC PR_CUSTMER_UPDATE_EMAIL 1 , 'ABCDGMAIL.COM';

--Part – C 

--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another one”.
CREATE PROCEDURE pr_Customer_Insert
    @Customer_id INT,
    @Customer_Name VARCHAR(250),
    @Email VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email) 
        VALUES (@Customer_id, @Customer_Name, @Email);
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627  -- 2627 is the error code for a primary key violation
        BEGIN
            THROW 50001, 'The Customer_id is already taken. Try another one.', 1;
        END
        ELSE
        BEGIN
            THROW; -- Rethrow other errors
        END
    END CATCH
END;

EXEC pr_Customer_Insert 11 , 'VISHAL BARAIYA' , 'baraiya@gmail.com';
