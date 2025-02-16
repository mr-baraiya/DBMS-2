# DBMS-2: Advanced SQL & MongoDB

## Overview
DBMS-2 covers advanced database concepts such as triggers, stored procedures, functions, cursors, indexes, and MongoDB.

## Topics Covered

### 1. Triggers
Triggers are automatic actions executed before or after database events like INSERT, UPDATE, or DELETE.

**Example:**
```sql
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO logs (action, timestamp)
    VALUES ('New employee added', NOW());
END;
```

### 2. Stored Procedures
Stored Procedures are precompiled SQL statements stored in the database for reuse.

**Example:**
```sql
CREATE PROCEDURE GetEmployeeSalary (IN emp_id INT)
BEGIN
    SELECT salary FROM employees WHERE id = emp_id;
END;
```

### 3. Functions
Functions return a single value and can be used in SQL queries.

**Example:**
```sql
CREATE FUNCTION GetTotalSalary()
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(salary) INTO total FROM employees;
    RETURN total;
END;
```

### 4. Cursors
Cursors allow row-by-row processing of query results.

**Example:**
```sql
DECLARE emp_cursor CURSOR FOR SELECT name FROM employees;
```

### 5. Indexes
Indexes improve database performance by speeding up searches.

**Example:**
```sql
CREATE INDEX idx_employee_name ON employees(name);
```

### 6. MongoDB
MongoDB is a NoSQL database that stores data in JSON-like documents.

**Basic Query:**
```js
db.employees.find({ department: "IT" });
```

**Aggregation Example:**
```js
db.employees.aggregate([
    { $group: { _id: "$department", totalSalary: { $sum: "$salary" } } }
]);
```

## Summary
This module provides an in-depth understanding of advanced SQL operations and MongoDB functionalities, crucial for managing and optimizing databases.

