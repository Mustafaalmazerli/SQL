

--- här ser jag summan av  vad har de säjt
SELECT 
    SP.BusinessEntityID,
    P.FirstName,
    P.LastName,
    ST.Name AS TerritoryName,
    SUM(SOH.TotalDue) AS TotalSalesAmount
FROM 
    Sales.SalesPerson AS SP
INNER JOIN Person.Person AS P ON SP.BusinessEntityID = P.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST ON SP.TerritoryID = ST.TerritoryID
INNER JOIN Sales.SalesOrderHeader AS SOH ON SP.BusinessEntityID = SOH.SalesPersonID
GROUP BY 
    SP.BusinessEntityID,
    P.FirstName,
    P.LastName,
    ST.Name
ORDER BY 
    ST.Name;
--01
SELECT 
    CASE 
        WHEN CountryRegionCode = 'US' THEN 'USA' 
        ELSE Name 
    END AS TerritoryName, 
    CountryRegionCode
FROM (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY CountryRegionCode ORDER BY Name) AS TerritoryOrder,
        Name,
        CountryRegionCode
    FROM Sales.SalesTerritory
) AS Subquery
ORDER BY TerritoryOrder, CountryRegionCode;




--- HumanResources 02
SELECT TOP 10
    JobTitle,
    MIN(HireDate) AS EarliestHireDate,
    MAX(HireDate) AS LatestHireDate,
    AVG(YEAR(GETDATE()) - YEAR(BirthDate)) AS AverageAge,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee
GROUP BY 
    JobTitle
ORDER BY NEWID()

-- PERSON 03
SELECT TOP 10
    FirstName,
    LastName,
	PhoneNumber,
	EmailAddress,
    AddressLine1,
    City,
    PostalCode
  FROM 
    Person.Person
INNER JOIN Person.Address ON Person.Person.BusinessEntityID = Person.Address.AddressID
INNER JOIN Person.StateProvince ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID
INNER JOIN Person.PersonPhone ON Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID
INNER JOIN Person.EmailAddress ON Person.Person.BusinessEntityID = Person.EmailAddress.BusinessEntityID
ORDER BY NEWID();
--från 04´01

SELECT TOP 10
       ProductID
      ,Name
      ,ProductNumber
      ,SafetyStockLevel
FROM AdventureWorks2022.Production.Product
ORDER BY NEWID()
---- 0402 
SELECT TOP 10 
    P.ProductID,
    P.Name AS ProductName,
    P.ProductNumber,
    P.Color,
    P.ListPrice,
    P.StandardCost
FROM Production.Product AS P
WHERE 
    P.ProductID IS NOT NULL
    AND P.Name IS NOT NULL
    AND P.ProductNumber IS NOT NULL
    AND P.Color IS NOT NULL
    AND P.ListPrice IS NOT NULL
    AND P.ListPrice > 0
    AND P.StandardCost IS NOT NULL
    AND P.StandardCost > 0
ORDER BY NEWID();
---0501
SELECT TOP 10
    so.SalesOrderID, so.OrderDate,
    c.CustomerID, c.PersonID, c.StoreID, c.TerritoryID,
    sp.BusinessEntityID, sp.TerritoryID, sp.SalesQuota, sp.Bonus,
    cc.CardNumber
FROM 
    Sales.SalesOrderHeader so
JOIN 
    Sales.Customer c ON so.CustomerID = c.CustomerID
JOIN 
    Sales.SalesPerson sp ON so.SalesPersonID = sp.BusinessEntityID
LEFT JOIN 
    Sales.CreditCard cc ON so.CreditCardID = cc.CreditCardID
	ORDER BY NEWID();


--0502
SELECT TOP 10
    SP.BusinessEntityID,
	p.FirstName,
    p.LastName,
    COUNT(s.SalesOrderID) AS NumberOfOrders,       
   
    COUNT(DISTINCT st.BusinessEntityID) AS NumberOfStores,
    SP.SalesYTD,
    SP.SalesLastYear,
    SUM(s.TotalDue) as TotalDue
FROM Sales.SalesOrderHeader s
INNER JOIN Person.Person p ON s.SalesPersonID = p.BusinessEntityID
LEFT JOIN Sales.Store st ON s.SalesPersonID = st.SalesPersonID
INNER JOIN Sales.SalesPerson SP ON s.SalesPersonID = SP.BusinessEntityID
WHERE  s.SalesPersonID IS NOT NULL
GROUP BY 
    SP.BusinessEntityID,
    SP.SalesYTD,
    SP.SalesLastYear,
    p.FirstName,
    p.LastName
HAVING 
    COUNT(s.SalesOrderID) > 0
ORDER BY 
    NumberOfOrders DESC;


		-- kod för visa vilka som jobba och var.
SELECT 
    e.BusinessEntityID AS SalesPersonID,
    pp.FirstName,
    pp.LastName,
    e.JobTitle,
    ST.Name AS TerritoryName
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
JOIN 
    Sales.SalesPerson SP ON e.BusinessEntityID = SP.BusinessEntityID
JOIN 
    Sales.SalesTerritory ST ON SP.TerritoryID = ST.TerritoryID
JOIN 
    Person.Person pp ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
    ST.CountryRegionCode = 'US'
    AND e.JobTitle = 'Sales Representative'
