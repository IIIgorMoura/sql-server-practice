-- SUBQUERIES

-- FROM Clause subquery
SELECT
*
FROM (
	SELECT
		*,
		AVG(Price) OVER() as AvgPrice
	FROM Sales.Products
)t WHERE Price > AvgPrice;


-- Unrefined version
SELECT
	*,
	DENSE_RANK() OVER(ORDER BY CustomerTotalSales DESC) AS RankCustomersTotalSales
FROM (
	SELECT
		CustomerID,
		SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
	FROM Sales.Orders
)t;

-- Refined version
SELECT
	*,
	RANK() OVER(ORDER BY TotalSales DESC) AS RankCustomers
	FROM (
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t;


-- SELECT Clause subquery
SELECT
	ProductID,
	Product,
	Price,
	(SELECT 
		SUM(Sales)
	FROM Sales.Orders 
	) AS AllSales
FROM Sales.Products;


-- JOIN Clause subquery
SELECT
	c.*,
	o.TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
	SELECT 
		CustomerID,
		COUNT(CustomerID) AS TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID
)o ON c.CustomerID = o.CustomerID;


-- WHERE Clause subquery
SELECT
	*
FROM Sales.Products
WHERE Price > (
	SELECT
		AVG(Price)
	FROM Sales.Products
);


SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN (
	SELECT
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany'
);


SELECT
	*
FROM Sales.Employees
WHERE Department = 'Marketing' AND Salary > ANY (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Department = 'Sales'
);


SELECT
	*
FROM Sales.Employees
WHERE Department = 'Marketing' AND Salary > ALL (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Department = 'Sales'
);


-- Correlated subquery
SELECT
	*,
	(SELECT
		COUNT(CustomerID)
	FROM Sales.Orders AS o WHERE o.CustomerID = c.CustomerID
	) AS TotalSales
FROM Sales.Customers AS c
