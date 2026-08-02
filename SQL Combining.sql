USE MyDatabase;

-- INNER JOIN
SELECT c.id, c.first_name, o.sales, o.order_id 
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;

-- LEFT / RIGHT JOIN
SELECT * 
FROM customers
LEFT JOIN orders
ON id = customer_id;

SELECT * 
FROM customers
RIGHT JOIN orders
ON id = customer_id;

SELECT *
FROM orders
LEFT JOIN customers
ON customer_id = id;

-- FULL JOIN
SELECT * 
FROM customers
FULL JOIN orders
ON id = customer_id;

-- ANTI JOIN
SELECT *
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE customer_id IS NULL;

SELECT *
FROM customers
RIGHT JOIN orders
ON id = customer_id
WHERE id IS NULL;

SELECT *
FROM orders
LEFT JOIN customers
ON customer_id = id
WHERE id IS NULL;

SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id
WHERE
	id IS NULL
	OR
	customer_id IS NULL;

SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id
WHERE
	id IS NOT NULL
	AND
	customer_id IS NOT NULL;

SELECT *
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE
	customer_id IS NOT NULL;



-- MULTI JOINs
USE SalesDB;

/*
NEED Order id, Customer name, Product name, Sales, Price, Salesman name

Tables
	Orders = o
	OrdersArchive = oa
	Employees = e
	Products = p
	Customers = c
*/

SELECT 
	o.OrderID,
	CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
	p.Product,
	o.Sales,
	p.Price,
	CONCAT(e.FirstName, ' ', e.LastName) AS SalesPerson
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID;




-- SET statements (combine rows instead of column)
SELECT
	FirstName,
	LastName
FROM Sales.Customers
UNION
SELECT
	FirstName,
	LastName
FROM Sales.Employees;


SELECT
	FirstName,
	LastName
FROM Sales.Customers
UNION ALL
SELECT
	FirstName,
	LastName
FROM Sales.Employees;


SELECT
	FirstName,
	LastName
FROM Sales.Customers
EXCEPT
SELECT
	FirstName,
	LastName
FROM Sales.Employees;


SELECT
	FirstName,
	LastName
FROM Sales.Customers
INTERSECT
SELECT
	FirstName,
	LastName
FROM Sales.Employees;


SELECT 
	'Orders' AS Origin
	,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
	'OrdersArchive'
	,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderId ASC;