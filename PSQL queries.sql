SELECT * FROM walmart; 

SELECT COUNT(*) FROM walmart;

SELECT payment_method, Count(*)
FROM walmart
GROUP BY payment_method;

SELECT  COUNT(DISTINCT Branch) FROM walmart;

SELECT Branch, Count(*)
FROM walmart
GROUP BY Branch;

SELECT MIN(quantity) FROM walmart;

SELECT * FROM  walmart
WHERE branch = 'WALM003';

-- Business Problems

-- Problem 1: What are the different payment methods and how many transactions and items
-- were sold by each payment method

SELECT payment_method, Count(*) as total_Transactions, Sum(quantity) as items_Sold
FROM walmart
GROUP BY payment_method;

-- Problem 2:
-- (a): Which category recieved the highest avg rating in each branch
SELECT  branch, category,AVG(rating)
FROM walmart
Group BY branch, category
ORDER BY branch, AVG(RATING) DESC;

-- (b): Ranking the avg rating of each category in different branches
SELECT * FROM
(
    SELECT branch, category, AVG(rating) as avg_rating,
    RANK() OVER(PARTITION BY branch ORDER By AVG(rating) DESC) as rank
    FROM walmart
    GROUP BY branch, category
)
WHERE rank = 1;

-- Problem 3: Identify the busiest day for each branch, based on number of transactions
--SELECT 'date', TO_DATE('date', 'DD/MM/YY') as formated_date;

SELECT * FROM
(
    SELECT branch,
        TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'day') as day_name, 
	    COUNT(*) as total_transactions,
	    RANK() OVER(PARTITION BY branch ORDER BY Count(*) DESC)
        FROM walmart
        GROUP BY branch, day_name
) 
WHERE rank = 1;

-- Problem 4: Calculate the total quantity of items sold per payment method. List 
-- payment_method and total_quantity.



SELECT 
	 payment_method,
	 -- COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;


-- Problem 5: Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

SELECT 
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2;


-- Problem 6: Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.

SELECT 
	category,
	SUM(total_price) as total_revenue,
	SUM(total_price * profit_margin) as profit
FROM walmart
GROUP BY 1;


-- Problem 7:Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

WITH cte 
AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1, 2
)
SELECT *
FROM cte
WHERE rank = 1;


-- Problem 8: Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT
	branch,
CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;