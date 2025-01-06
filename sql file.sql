create database walmart;
use walmart;
select *from `walmart`.`walmartsalesdata.csv`;

alter table `walmart`.`walmartsalesdata.csv` change `walmart`.`walmartsalesdata.csv` sale;

RENAME TABLE `walmart`.`walmartsalesdata.csv` TO `walmart`.`sale`;
select *from sale;
select *from sale;


-- ----------------------------------------------------feature engineering ------------------------------------
-- 1. time_of_day     
-- Give insight of sales in the Morning, Afternoon and Evening.
-- This will help answer the question on which part of the day most sales are made.
select *from sale;
SELECT 
    time, 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sale;

ALTER TABLE SALE ADD COLUMN time_of_day VARCHAR(20);

UPDATE SALE
SET time_of_day = (
CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
-- SET SQL_SAFE_UPDATES = 0;


-- day_name
-- place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

SELECT date , dayname(date) FROM SALE;

ALTER TABLE SALE ADD COLUMN day_name varchar(15);

UPDATE SALE
SET day_name = 
(
dayname(date)
);


-- MONTH_NAME
-- that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
-- Help determine which month of the year has the most sales and profit.


SELECT
	date,
	MONTHNAME(date)
FROM sale;

ALTER TABLE sale ADD COLUMN month_name VARCHAR(10);
UPDATE SALE 
SET month_name = (
MONTHNAME(date)
);

-- ---------------------------- Generic Questions ------------------------------

-- How many unique cities does the data have?
SELECT *FROM SALE;
SELECT distinct(city) from sale;

-- In which city is each branch?
SELECT distinct(city) , branch from sale;

-- ---------------------------- Product Questions -------------------------------

-- How many unique product lines does the data have?
SELECT *FROM SALE;

SELECT DISTINCT(`product line`) from sale;
SELECT COUNT(DISTINCT `product line`) FROM sale;
ALTER TABLE SALE RENAME COLUMN `PRODUCT LINE` TO productline;

-- What is the most selling product line
select productline , sum(quantity) as qty from sale
group by productline
order by qty desc;

-- What is the total revenue by month
select *from sale;

SELECT month_name , ROUND(sum(total)) as total_revenue
FROM sale
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?

SELECT month_name , sum(cogs) as cogs 
from sale
group by month_name
order by cogs desc; 


-- What product line had the largest revenue?
SELECT productline, SUM(total) as total_revenue
FROM sale
GROUP BY productline
ORDER BY total_revenue;

-- What is the city with the largest revenue?
SELECT BRANCH, CITY, SUM(total) as total_revenue
FROM sale
GROUP BY CITY, BRANCH
ORDER BY total_revenue DESC;

-- What product line had the largest VAT(Value Added TaX)?

SELECT
	productline,
	AVG(`Tax 5%`) as avg_tax,
    max(`Tax 5%`) as max_tax,
    sum(`Tax 5%`) as sum_tax
FROM sale
GROUP BY productline
ORDER BY avg_tax DESC;

select *from sale;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". 
-- Good if its greater than average sales
SELECT 
    productline,
    AVG(quantity) AS avg_qnty,
    CASE
        WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sale) THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sale
GROUP BY productline;

-- Which branch sold more products than average product sold?

SELECT *FROM SALE;
SELECT 
	branch, city,
    SUM(quantity) AS qnty
FROM sale
GROUP BY branch, city
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sale);

-- What is the most common product line by gender?
SELECT
	gender,
    (productline),
    COUNT(gender) AS total_cnt
FROM sale
GROUP BY gender, productline
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
select *from sale;
SELECT productline, round(avg(rating)) as avg_rat
from sale
group by productline
order by avg_rat desc;

SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    productline
FROM sale
GROUP BY productline
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers Related Questions -------------
-- --------------------------------------------------------------------
-- How many unique customer types does the data have?
select *from sale;
SELECT DISTINCT(`customer type`) from sale;

-- How many unique payment methods does the data have?
SELECT DISTINCT(payment) from sale;

-- What is the most common customer type?
SELECT
	(`customer type`),
	count(`customer type`) as count
FROM sale
GROUP BY (`customer type`)
ORDER BY count DESC;

-- Which customer type buys the most?
select *from sale;
SELECT
	(`customer type`),
    COUNT(*)
FROM sale
GROUP BY (`customer type`);

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sale
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sale
WHERE branch = "C" 
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sale
WHERE branch = "B" 
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sale
WHERE branch = "A" 
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sale
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sale
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sale
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sale
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sale
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sale
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sale
WHERE branch = "B"
GROUP BY day_name
ORDER BY total_sales DESC;

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sale
WHERE branch = "A"
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- ------------ Sales Related Quetions---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sale
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	(`customer type`),
	round(SUM(total)) AS total_revenue
FROM sale
GROUP BY (`customer type`)
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(`Tax 5%`), 2) AS avg_tax_pct
FROM sale
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	(`customer type`),
	AVG(`Tax 5%`) AS total_tax
FROM sale
GROUP BY (`customer type`)
ORDER BY total_tax;
