USE MyDatabase;

-- Comment line

/*
Comment section
*/


-- Selecting the whole tables
SELECT * 
FROM customers;

SELECT *
FROM orders;

-- Selecting columns

SELECT 
	first_name, 
	country, 
	score
FROM customers;

-- Selecting values that match WHERE Filter
SELECT
	first_name,
	score
FROM customers
WHERE score != 0;

SELECT first_name
FROM customers
WHERE country = 'Germany';

-- Sort
SELECT first_name, score
FROM customers
ORDER BY score DESC;

-- Nested Sort
SELECT first_name, country, score
FROM customers
ORDER BY country ASC, score DESC;

-- Group by
SELECT 
	country, 
	SUM(score) AS total_score
FROM customers
GROUP BY country;


-- Group by Filtered Sorted
SELECT 
	country, 
	SUM(score) AS total_score,
	COUNT(country) as total_customers
FROM customers
GROUP BY country
HAVING SUM(score) > 800
ORDER BY SUM(score) DESC;

SELECT 
	country, 
	SUM(score) AS total_score,
	COUNT(country) AS total_customers
FROM customers
WHERE score > 400
GROUP BY country
HAVING SUM(score) > 800
ORDER BY SUM(score) DESC;

SELECT
	country,
	AVG(score) AS average_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

-- Selecting Distinct lines
SELECT DISTINCT
	country
FROM customers;

SELECT DISTINCT
	country, first_name
FROM customers;

-- Top
SELECT TOP 3 *
FROM customers;

SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

-- TABLE orders

-- select the 2 more recent orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;



-- BETWEEN operator
SELECT * FROM customers
WHERE score BETWEEN 100 AND 500;

-- IN ; NOT IN
SELECT * FROM customers
WHERE country IN ('USA', 'Germany');

-- LIKE
SELECT * FROM customers
WHERE country LIKE 'g%';

SELECT * FROM customers
WHERE country LIKE '%r%';

SELECT * FROM customers
WHERE first_name LIKE '__r%';