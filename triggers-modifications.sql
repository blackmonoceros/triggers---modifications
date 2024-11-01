

--Zadanie nr 1a:


CREATE TRIGGER UniemozliwA
ON Categories
AFTER INSERT
AS
BEGIN
RAISERROR (‘Operacja wstawiania nie dozwolona .', 16, 1)
ROLLBACK TRANSACTION
END
Zadanie nr 1b:
CREATE TRIGGER UniemozliwB
ON Categories
INSTEAD OF INSERT
AS
BEGIN
RAISERROR (‘Operacja wstawiania nie dozwolona.', 16, 1)
END


--Zadanie nr 2:


CREATE TABLE Products_log
(
Nr INT IDENTITY(1,1) PRIMARY KEY,
Data DATETIME,
Uwagi NVARCHAR(255)
)
GO
CREATE TRIGGER LogUpdateOnProducts
ON Products
AFTER UPDATE
AS
BEGIN
INSERT INTO Products_log (Data, Uwagi)
VALUES (GETDATE(), 'Product Updated')
END


--Zadanie nr 3:

ALTER TRIGGER LogUpdateOnProducts
ON Products
AFTER UPDATE
AS
BEGIN
IF UPDATE(Price)
BEGIN
INSERT INTO Products_log (Data, Uwagi)
VALUES (GETDATE(), 'Product price changed')
END
END


--Zadanie nr 4:

ALTER TABLE Products_log ADD OldPrice MONEY
ALTER TRIGGER LogPriceChangeOnProducts
ON Products
AFTER UPDATE
AS
BEGIN
IF UPDATE(Price)
BEGIN
INSERT INTO Products_log (Data, Uwagi, OldPrice)
SELECT GETDATE(), 'Product price changed', d.Price
FROM deleted d
END
END


--Zadanie nr 5:

ALTER TABLE Products_log ADD NewPrice MONEY
ALTER TRIGGER LogPriceChangeOnProducts
ON Products
AFTER UPDATE
AS
BEGIN
IF UPDATE(Price)
BEGIN
INSERT INTO Products_log (Data, Uwagi, OldPrice, NewPrice)
SELECT GETDATE(), 'Product price changed', d.Price, i.Price
FROM deleted d
INNER JOIN inserted i ON d.ProductID = i.ProductID
END
END


--Zadanie nr 6:

CREATE TRIGGER CorrectPriceInOrderDetails
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT i.OrderID, i.ProductID, p.UnitPrice, i.Quantity, i.Discount
FROM inserted i
INNER JOIN Products p ON i.ProductID = p.ProductID
END



--Zadanie nr 7:

ALTER TABLE Products2 ADD Login NVARCHAR(128), LastModified DATETIME
CREATE TRIGGER UpdateLoginAndLastModified
ON Products2
AFTER UPDATE
AS
BEGIN
UPDATE Products2
SET Login = SUSER_SNAME(), LastModified = GETDATE()
FROM Products2 p
INNER JOIN inserted i ON p.ProductID = i.ProductID
END


--Zadanie nr 8:

CREATE TRIGGER UpdateUnitsInStock
ON [Order Details]
AFTER INSERT
AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS (
 SELECT 1
 FROM inserted i
 JOIN Products p ON i.ProductID = p.ProductID
 WHERE i.Quantity > p.UnitsInStock
 )
 BEGIN
 ROLLBACK TRANSACTION;
 END
 ELSE
 BEGIN
 UPDATE p
 SET p.UnitsInStock = p.UnitsInStock - i.Quantity
 FROM inserted i
 JOIN Products p ON i.ProductID = p.ProductID;
 END
END;