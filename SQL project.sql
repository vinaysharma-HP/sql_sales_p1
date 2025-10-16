-- SQL Retail Sales Analysis - P1


--CREATE TABLE

	CREATE TABLE retail_sales
	(
	 transactions_id INTEGER PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INTEGER,
	gender VARCHAR(15),
	age INTEGER,
	category VARCHAR(15),
	quantiy INTEGER,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT
	)


--DATA CLEANING--

	SELECT * FROM retail_sales
	WHERE
	transactions_id IS NULL 
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
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--

	DELETE FROM retail_sales
	WHERE
	transactions_id IS NULL 
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
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


--DATA EXPLORATION--

--HOW MANY SALES WE HAVE?

	SELECT COUNT(*) AS total_sales FROM retail_sales;

--HOW MANY UNIQUE CUSTOMERS WE HAVE?

	SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;

-- HOW MANY UNIQUE CATEGORIES WE HAVE?

	SELECT COUNT(DISTINCT(category)) FROM retail_sales;

--DATA ANALYSIS/BUSINES KEY PROBLEMS

--Q1:Write a SQL Query to retrieve all columns for sale made on 2022-11-05?



	SELECT * FROM retail_sales
	WHERE sale_date = '2022-11-05';

--Q2: Write a SQL query to retrieve all transactions where category is 
--'clothing' and the the quantity sold is more than equal to 4 in the month of nov- 2022?

	SELECT * FROM retail_sales
	WHERE category = 'Clothing'
	AND quantiy >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--Q3: Write a SQL query to calculate total sales for each category?

	SELECT category, SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders FROM retail_sales
	GROUP BY category

--Q4: Write a SQL query to find the average age of customers who purchased
-- items from 'Beauty' category?

	SELECT ROUND(AVG(age), 2) AS avg_age, category FROM retail_sales
	WHERE category = 'Beauty'
	GROUP BY category;

--Q5: Write a SQL query to find all transactions where total_sale is > 1000?

	SELECT * FROM retail_sales
	WHERE total_sale > 1000

--Q6: Write a SQL query to find total number of transactions(transaction_id)
-- made by each gender in each category?

	SELECT category, gender, COUNT(*) AS total_transactions FROM retail_sales
	GROUP BY category, gender
	ORDER BY category, gender

--Q7: Write a SQL query to calculate the average sale for each month. Find out
--best selling month in each year.

SELECT* FROM (

	SELECT EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_total_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY year, month) as t1

	WHERE RANK = 1

--Q8: Write a SQL query to find the top 5 customers based on highest total sales

	SELECT customer_id, SUM(total_sale) as highest_sale
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY highest_sale DESC
	LIMIT 5
	

--Q9: Write a SQL query to find the number of unique customers who purchased
--items from each category.

	SELECT COUNT( DISTINCT customer_id) AS unique_customer, category
	FROM retail_sales
	GROUP BY category

--Q10: Write a SQL query to create each shift and number of orders
--e.g.(Morning <=12, Afternoon between 12 and 17, Evenings > 17)

	WITH hourly_sale
	AS(
	SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 'EVENING'
	END AS shift
	FROM retail_sales
	)
	SELECT shift, COUNT(transactions_id) as total_orders
	FROM hourly_sale
	GROUP BY shift

--END OF PROJECT




