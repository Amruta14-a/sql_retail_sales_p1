-- SQL Retail Sales Analysis - P1
Create Database sql_project_p1;

--Create Table 
CREATE TABLE retail_sales
(
				transaction_id INT PRIMARY KEY,	
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	  INT,
				category VARCHAR(15),	
				quantiy	 INT,
				price_per_unit FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
)

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*) 
FROM retail_sales

-- Data Cleaning 
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- Updated all the age columns with null values 
UPDATE retail_sales
SET age = 35
WHERE transaction_id = 845;

UPDATE retail_sales
SET age = 30
WHERE transaction_id = 1150;

UPDATE retail_sales
SET age = 28
WHERE transaction_id = 1845;

UPDATE retail_sales
SET age = 35
WHERE transaction_id = 797;

UPDATE retail_sales
SET age = 26
WHERE transaction_id = 921;

-- 
DELETE FROM  retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULl;

SELECT 
	COUNT(*) 
FROM retail_sales

-- check again for null values 
SELECT * FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- Data Exploration

--How many sales we have ?
SELECT COUNT(*) AS total_sales FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales

-- How many distinct category we have ? 
SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business key problems & answers

-- My Analysis and Findings 
-- Q.1 Write a SQL query to retrive all column for sales on '2022-11-05'.
-- Q.2 Write a SQL query to retrive all transaction where the category is clothing and quantity sold is more then 4
-- Q.3 Write a SQL query to calculate  the total sales (total_sales) for each catogery
-- Q.4 Write a SQL query to find the average age of the customers who purchase items from the 'Beauty' category
-- Q.5 Write a SQL query to find the all transactions Where total_sales is greater then 1000
-- Q.6 Write a SQL query to find the total number of (transaction_id) made by  each gender in each category 
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month to each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders example morning <=12, Afternoon  Between 12 & 17, Evening >=17.



-- Q.1 Write a SQL query to retrive all coluumn for sales made on '2022-11-05'

SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrive all transaction where the category is clothing and quantity sold is more then 4 in the month of '2022-11'.
SELECT 
* 
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date,'yyyy-mm') ='2022-11' 
	AND 
	quantity>=4;

-- 17 trancatons

-- Q.3 Write a SQL query to calculate  the total sales (total_sales) for each catogery
SELECT category, 
SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of the customers who purchase items from the 'Beauty' category
SELECT 
ROUND(AVG (age),2) AS avg_age
FROM retail_sales 
WHERE category ='Beauty'

-- Answer 40.39

-- Q.5 Write a SQL query to find the all transactions Where total_sales is greater then 1000
SELECT 
* 
FROM retail_sales 
WHERE total_sale >1000

-- Q.6 Write a SQL query to find the total number of (transaction_id) made by  each gender in each category 

SELECT 
category,
gender,
COUNT(*) AS num_transations
FROM retail_sales 
GROUP BY category ,gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month to each year.
SELECT 
	year,
	month,
	avg_sales
FROM 
(
	SELECT 
		EXTRACT(year FROM sale_date) AS year,
		EXTRACT (month FROM sale_date) AS month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER (PARTITION BY EXTRACT (year FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	SUM(total_sale) As total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
	
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS count_unique_customer
FROM retail_sales
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders example morning <=12, Afternoon  Between 12 & 17, Evening >=17.
WITH hourly_sales
AS 
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS  shift
FROM retail_sales
)
SELECT 
shift,
COUNT(transaction_id) AS total_orders
FROM hourly_sales
GROUP BY shift;

--END of project




