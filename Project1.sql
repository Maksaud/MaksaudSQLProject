--1.1
/*
This is Selecting The CustomerID, CompanyName aliased as Name Of Company column and the joint together column of
Address, Region, Country, City, PostalCode aliased as Address
*/
SELECT
    CustomerID,
    CompanyName AS "Name Of Company",
    CONCAT(Address,' ',Region, ' ', Country, ' ', City,' ', PostalCode) AS "Address"
FROM Customers
WHERE
    City IN ('London', 'Paris');

--1.2

SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%Bottles%';

--1.3
SELECT s.CompanyName AS "Supplier Name", Country FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE QuantityPerUnit LIKE '%Bottles%';

--1.4
SELECT c.CategoryID, c.CategoryName AS "Names Of Categories", SUM(c.CategoryID) AS "Total Products In Each Category" FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY SUM(c.CategoryID) DESC;

--1.5
SELECT TitleOfCourtesy+' '+FirstName+' '+LastName AS "Emplyee Name", City AS "City Of Residence" FROM Employees
WHERE Country = 'UK';

--1.6
SELECT r.RegionID, SUM(ROUND(od.UnitPrice*Quantity*(1-Discount),0)) AS "SALES" FROM Territories t
INNER JOIN Region r ON t.RegionID = r.RegionID
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Orders o ON o.EmployeeID = et.EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY r.RegionID HAVING SUM(ROUND(od.UnitPrice*Quantity*(1-Discount),0)) >1000000 
ORDER BY "SALES" DESC; 

--1.7
SELECT COUNT(OrderID) AS "Orders Where Freight Is More Than 100 In UK And USA" FROM Orders
WHERE (Freight > 100.00) AND (ShipCountry = 'UK' OR ShipCountry = 'USA');

--1.8
SELECT
    OrderID,
    (UnitPrice * Quantity * Discount) AS "Amount Discount"
FROM [Order Details]
WHERE
    (UnitPrice*Quantity*Discount) = (
        SELECT MAX(UnitPrice*Quantity*Discount)
        FROM [Order Details]
    );


--2.1
CREATE TABLE SpartansTable(
    SpartaID Int IDENTITY(1,1),
    Title VARCHAR(6),
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    UniversityAttended VARCHAR(100),
    CourseTaken VARCHAR(100),
    MarkAchieved VARCHAR(10),
    PRIMARY KEY (SpartaID)
);
 --2.2
INSERT SpartansTable(
    Title, FirstName, LastName, UniversityAttended, CourseTaken, MarkAchieved
)
VALUES
--('Mr.', 'Maksaud', 'Ahmed', 'N/A', 'N/A', 'N/A')
('Mr.', 'Victor', 'Simbanda', 'Lincoln', 'Electrical', '1'),
('Mr.', 'Camile', 'Malungu', 'Brunel', 'Computer Science', '2:2'),
('Mr.', 'Mohammed', 'Uddin', 'Greenwich', 'Computer Science', '3'),
('Mr.', 'Kevin', 'Monteiro', 'Cass', 'Mathematcial Trading & Finance', 'Pass'),
('Miss.', 'Michalina', 'Ramos', 'Queen Mary', 'Computer Science', '2:1'),
('Mr.', 'Oscar', 'Romero', 'City', 'Mathematics', '1'),
('Mr.', 'Cole', 'Santos', 'Brunel', 'Computer Science', '2:1'),
('Miss.', 'Aleksandra', 'Blackwell', 'Brunel', 'Computer Science', '2:2'),
('Mr.', 'Ollie', 'Justice', 'Brunel', 'Brunel', '1');


--3.1
SELECT EmployeeID, FirstName + ' ' + LastName AS 'Employee Name',
CASE
WHEN ReportsTo = 2 THEN 'Andrew Fuller'
WHEN ReportsTo = 5 THEN 'Steven Buchanan'
ELSE 'Reports To No One'
END AS "Reports To"
FROM Employees;

--3.2
SELECT od.UnitPrice*od.Quantity AS "SALES", CompanyName AS "Supplier Name" FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY od.UnitPrice*Quantity, CompanyName HAVING od.UnitPrice*Quantity > 10000;

--3.3
SELECT TOP 10
    c.CustomerID,
    C.CompanyName AS "Company Name",
    YEAR(o.ShippedDate) AS "Only 1998",
    SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) AS "Value of orders"
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN customers c ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, C.CompanyName, YEAR(o.ShippedDate) HAVING YEAR(o.ShippedDate) = (SELECT MAX(YEAR(ShippedDate)) FROM Orders)
ORDER BY "Value of orders" DESC;

--3.4
SELECT 
    MONTH(ShippedDate) AS 'Month',
    AVG(DATEDIFF(day, OrderDate, ShippedDate)) AS 'Difference in time in hours'
FROM Orders
WHERE Month(ShippedDate) IS NOT NULL
GROUP BY Month(ShippedDate)
ORDER BY Month(ShippedDate)