SELECT
	YEAR(OrderDate),
	COUNT(*) N_Orders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

SELECT
	DATENAME(month, OrderDate) AS Month,
	COUNT(*) N_Orders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

SELECT 
	FORMAT(OrderDate, 'MM-yy') AS OrderDate,
	COUNT(*) N_Orders
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MM-yy')
UNION
SELECT 
	FORMAT(OrderDate, 'MM-yy'),
	COUNT(*) N_Orders
FROM Sales.OrdersArchive
GROUP BY FORMAT(OrderDate, 'MM-yy')
ORDER BY OrderDate ASC;

--

SELECT
	AVG(score) AS score_wo_treatment,
	AVG(COALESCE(score, 0)) AS score_treated
FROM Sales.Customers;



SELECT * FROM Sales.Orders;

SELECT
	Sales / NULLIF(Quantity, 0) AS Result
FROM Sales.Orders;

SELECT c.*
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


SELECT
	Category,
	SUM(Sales) AS TotalSales
FROM (
	SELECT
		Sales,
		CASE
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END Category
	FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC;


SELECT
	EmployeeID,
	FirstName,
	LastName,
	Department,
	BirthDate,
	Salary,
	ManagerID,
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Undisclosed'
	END AS Gender
FROM Sales.Employees;


SELECT
	Gender,
	COUNT(*) AS Qnt
FROM Sales.Employees
GROUP BY Gender;


SELECT
	CustomerID,
	FirstName + ' ' + LastName AS Name,
	Score,
	AVG(Score) OVER () AS AvgScore,
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END ScoreAdjusted,
	AVG(CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER () AS AvgAdjusted
FROM Sales.Customers;