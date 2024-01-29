
CREATE DATABASE Staging_DW;

USE Staging_DW;

CREATE TABLE DimCustomer(
 CustomerID int NOT NULL,
 CustomerName varchar(50) NOT NULL,
 Age int NOT NULL,
 Gender varchar(50) NOT NULL,
 City varchar(50) NOT NULL,
 CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerID)
)

CREATE TABLE DimProduct(
 ProductID int NOT NULL,
 ProductName varchar(255) NOT NULL, 
 ProductCategory varchar(255) NOT NULL,
 CONSTRAINT PK_DimProduct PRIMARY KEY (ProductID)
)

CREATE TABLE DimStatusOrder(
 StatusID int NOT NULL,
 StatusOrder varchar(50) NOT NULL,
 StatusDesc varchar(50) NOT NULL,
 CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusID)
)

CREATE Table FactSales(
 OrderID int NOT NULL,
 CustomerID int NOT NULL,
 ProductID int NOT NULL,
 StatusID int NOT NULL,
 Quantity int NOT NULL,
 TotalSales int NOT NULL,
 CONSTRAINT PK_FactSales PRIMARY KEY (OrderID),
 CONSTRAINT FK_FactSalesCust FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
 CONSTRAINT FK_FactSalesProd FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
 CONSTRAINT FK_FactSalesStatus FOREIGN KEY (StatusID) REFERENCES DimStatusOrder(StatusID)
)


-- Membuat SP

 -- SP 

CREATE PROCEDURE summary_order_status
	@statusID int
AS
BEGIN
select
	FactSales.OrderID,
	DimCustomer.CustomerName,
	DimProduct.ProductName,
	FactSales.Quantity,
	DimStatusOrder.StatusOrder
FROM Staging_DW.dbo.FactSales
INNER JOIN Staging_DW.dbo.DimCustomer ON FactSales.CustomerID = DimCustomer.CustomerID
INNER JOIN Staging_DW.dbo.DimProduct ON FactSales.ProductID = DimProduct.ProductID
INNER JOIN Staging_DW.dbo.DimStatusOrder ON FactSales.StatusID = DimStatusOrder.StatusID
WHERE FactSales.StatusID = @statusID;
END;

EXEC summary_order_status @statusID = 4;

