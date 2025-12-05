______________________________________________________________________________________________________________________________________
# triggers---modifications

Task 1

A trigger that prevents a record from being added to the Categories table (use RAISERROR and ROLLBACK TRANSACTION)
a) AFTER INSERT version
b) INSTEAD OF INSERT version

Task 2

In the Northwind database, the Products_log table (containing the columns No. INT IDENTITY(1,1), Date DATETIME and Notes NVARCHAR(255)) 
and added a trigger that will add one record to it each time the products table is updated.

CREATE TABLE Products_log
(
No. INT IDENTITY(1,1) PRIMARY KEY,
Date DATETIME,
notes NVARCHAR(255)
)
GO

Task 3
A modified trigger from task 2 so that it reacts only when the price changes.

Task 4
Modified trigger and Products_log table so that information about the old price is remembered (only about the old price, not the new one).

Task 5
Modified trigger and Products_log table so that information about the old price and the new price is remembered.

Task 6
A trigger that will insert the correct price into these rows after adding rows to the [Order Details] table.

Hint: You should write an INSTEAD OF type trigger that will add data using a join of the INSERTED and Products tables instead of adding rows to [Order Details]. 
When testing, you can add new products, e.g. to order no. 10248.

Task 7

A copy of the Products table has been created, name it Product2 and add the Login columns of type NVARCHAR(128) and LastModified of type DATETIME to it.

SELECT * INTO Products2 FROM Products

ALTER TABLE Products2 ADD PRIMARY KEY (ProductId)

ALTER TABLE Products
ADD Login NVARCHAR(128), LastModified DATETIME

A trigger that will automatically enter the appropriate data into the Login and LastModified columns in the table. The trigger is to work after updating (records) 
in the Products2 table and is to enter the login of the person who updated the records in the table into the Login column (this can be achieved using the SUSER_SNAME() function) 
and the date and time when the modification was made into the LastModified column (you can use the GETDATE() function).

Task 8

A trigger that will modify the UnitsInStock field in the Products table after adding a row (rows) to the [Order Details] table. We are therefore to modify 
the quantity of goods in stock, based on data from the order.
At the same time, the trigger is to rollback the transaction if among the newly added rows in the [Order Details] statement, the Quantity column contains 
a value greater than the number of units in stock (i.e. UnitsInStock)...
