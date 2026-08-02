SELECT
	COUNT(*) AS Total_Customers,
	SUM(Sales) AS Total_Sales,
	AVG(Sales) AS Avg_Sales,
	MAX(Sales) AS Max_Sales,
	MIN(Sales) AS Min_Sales
FROM Sales.Orders;

SELECT
	ProductID,
	SUM(Sales)
FROM Sales.Orders
GROUP BY ProductID;

-- Window Functions

SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) AS Sum_Sales_Product
FROM Sales.Orders;

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() AS TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS TotalSalesByStatusAndProduct
FROM Sales.Orders;

SELECT
	OrderID,
	OrderDate,
	RANK() OVER(ORDER BY Sales DESC) AS RankedTotalSales
FROM Sales.Orders;

SELECT
	CustomerID,
	SUM(Sales) AS TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS Rank
FROM Sales.Orders
GROUP BY CustomerID;





-- AVG

SELECT
	OrderID,
	ProductID,
	OrderDate,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesProduct 
FROM Sales.Orders;


SELECT
	CustomerID,
	CONCAT(FirstName, ' ', LastName),
	Score,
	AVG(Score) OVER() AS UntreatedAvgScore,
	AVG(COALESCE(Score, 0)) OVER() AS TreatedAvgScore
FROM Sales.Customers;

-- Subquery to filter only Sales > AVG
SELECT
	*
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AS AvgSales
	FROM Sales.Orders
)t WHERE Sales > AvgSales;


SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	
	MIN(Sales) OVER() AS LowestSale,
	MAX(Sales) OVER() AS HighestSale,
	
	MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSaleByProduct,
	MAX(Sales) OVER(PARTITION BY ProductID) AS HighestSaleByProduct

FROM Sales.Orders;


-- Moving AVG

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgProductSales, 
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgOfProductSales
FROM Sales.Orders;


-- Identifying Duplicates in Table

SELECT
	*
FROM (
	SELECT
		OrderID,
		COUNT(OrderID) OVER(PARTITION BY OrderID) AS IDCounter
	FROM Sales.OrdersArchive
)t WHERE IDCounter > 1;



-- RANKING Functions
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowRankHighestSales,
	RANK() OVER(ORDER BY Sales DESC) AS RankHighestSales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS DenseRankHighestSales
FROM Sales.Orders;

-- Rank() handles Ties, but skip ranks afterwards
SELECT
	*
FROM (
	SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowRankHighestSales,
	RANK() OVER(ORDER BY Sales DESC) AS RankHighestSales
	FROM Sales.Orders
)t WHERE RankHighestSales <= 3;


-- Top N Analysis

SELECT
	*
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS RowRankSalesByProduct
	FROM Sales.Orders
)t WHERE RowRankSalesByProduct <= 3;

-- Bottom N Analysis

SELECT *
FROM (
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) AS LowestCustomerSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t WHERE LowestCustomerSales <= 2;



-- Assign Unique PK (Paginating)
SELECT
	ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueID,
	*
FROM Sales.OrdersArchive;

-- Identifying Duplicates
SELECT
	*
FROM (
	SELECT
		ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueID,
		*
	FROM Sales.OrdersArchive
)t WHERE OrderID != UniqueID;

-- Data Cleansing: Duplicates
SELECT *
FROM (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
		*
	FROM Sales.OrdersArchive
)t WHERE rn = 1;

-- Finding Old Duplicate Data
SELECT *
FROM (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
		*
	FROM Sales.OrdersArchive
)t WHERE rn > 1;

-- NTILE: Bins/Buckets
SELECT
	OrderID,
	Sales,
	NTILE(5) OVER(ORDER BY Sales DESC) AS MostSalesBins
FROM Sales.Orders;

-- Data Segmentation
SELECT 
	*,
	CASE MostSalesBins
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END SalesSegmentations
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) AS MostSalesBins
	FROM Sales.Orders
)t

-- ELT Balancing, Data Batching
SELECT
	NTILE(5) OVER(ORDER BY OrderID) AS Buckets,
	*
FROM Sales.Orders;


-- Percent Ranking
SELECT
	*
FROM (
	SELECT	
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) AS cume_position
	FROM Sales.Products
)t WHERE cume_position <= 0.4;