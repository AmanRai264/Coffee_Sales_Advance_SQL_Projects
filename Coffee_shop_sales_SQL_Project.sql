--Q.1) Find the top 3 most frequently purchased product_detail items for each Month Name.

WITH RankedProducts AS (
    SELECT 
        product_detail, 
        EXTRACT(MONTH FROM transaction_date) AS month_number,
        COUNT(product_id) AS times_sold,
        RANK() OVER (
            PARTITION BY EXTRACT(MONTH FROM transaction_date) 
            ORDER BY COUNT(product_id) DESC
        ) AS rank_position
    FROM coffee_shop_sales2
    GROUP BY product_detail, month_number
)

SELECT *
FROM RankedProducts
WHERE rank_position <= 3  -- Get only the Top 3 per month
ORDER BY month_number, rank_position;


--Q.2) Identify transactions where the Total Bill is more than 3 standard deviations above 
--the average for the respective product_category. 
WITH ProductCategoryStats AS (
    SELECT 
        product_category,
        AVG("Total Bill") AS avg_total_bill,
        STDDEV("Total Bill") AS stddev_total_bill
    FROM coffee_shop_sales2
    GROUP BY product_category
)

SELECT 
    s.transaction_id,
    s.product_category,
    s."Total Bill",
    pcs.avg_total_bill,
    pcs.stddev_total_bill
FROM coffee_shop_sales2 s
JOIN ProductCategoryStats pcs
    ON s.product_category = pcs.product_category
WHERE s."Total Bill" > pcs.avg_total_bill + (3 * pcs.stddev_total_bill)
ORDER BY s."Total Bill" DESC;


--Q.3) Write a query to list all transactions where the Total Bill is 
--above the average Total Bill for the respective store_location. 

WITH Average AS (
    SELECT 
        store_location,
        AVG("Total Bill") AS avg_total_bill
    FROM coffee_shop_sales2
    GROUP BY store_location
)

SELECT
    c.transaction_id,
    c.store_location,
    a.avg_total_bill,
    c."Total Bill",
    RANK() OVER (
        PARTITION BY c.store_location 
        ORDER BY c."Total Bill" DESC
    ) AS rank_position
FROM coffee_shop_sales2 c
JOIN Average a
ON c.store_location = a.store_location
WHERE c."Total Bill" > a.avg_total_bill;

--Q.4) Use a Common Table Expression (CTE) to find all product_id with total sales
--exceeding $1,000 and then calculate the average unit_price for these products. 

WITH CCCTE AS (
    SELECT 
        product_id, 
        SUM("Total Bill") AS total_sales
    FROM coffee_shop_sales2
    GROUP BY product_id
    HAVING SUM("Total Bill") > 1000  -- Apply filter inside CTE for better performance
)
SELECT 
    c.product_id, 
    c.total_sales,
    AVG(s.unit_price) AS avg_unit_price
FROM CCCTE c
JOIN coffee_shop_sales2 s
ON c.product_id = s.product_id
GROUP BY c.product_id, c.total_sales;

--Q.5) Determine the hour of the day with the highest total sales.

WITH ctsi AS (
    SELECT 
        Hour, 
        SUM("Total Bill") AS total_sales
    FROM 
        coffee_shop_sales2
    GROUP BY 
        Hour
)
SELECT 
    Hour, 
    total_sales
FROM 
    ctsi
ORDER BY 
    total_sales DESC
LIMIT 1;


--Q.6) Update all transactions with a unit_price of 0 to the average unit_price for 
--the respective product_type

UPDATE coffee_shop_sales2 AS t
SET unit_price = (
    SELECT AVG(unit_price) 
    FROM coffee_shop_sales2 AS s
    WHERE s.product_type = t.product_type 
    AND unit_price > 0
)
WHERE t.unit_price = 0;

--Q.7) Create a ranking of transactions based on Total Bill within each store_location.

WITH ranked_sales AS (
    SELECT 
        store_location, 
        transaction_id, 
        "Total Bill", 
        RANK() OVER (PARTITION BY store_location ORDER BY "Total Bill" DESC) AS rank
    FROM 
        coffee_shop_sales2
)
SELECT 
    store_location, 
    transaction_id, 
    "Total Bill", 
    rank
FROM 
    ranked_sales
WHERE 
    rank <= 5
ORDER BY 
    store_location, rank;

--Q.8)Simulate a "loyalty program" by assigning a customer_id to transactions based on a random distribution (e.g., customer IDs range from 1–1000). 
--Then calculate the top 10 customers with the highest total spend.

WITH AssignedCustomers AS (
    SELECT 
        transaction_id,
        "Total Bill",
        FLOOR(RANDOM() * 1000) + 1 AS customer_id  -- Assign random customer_id between 1 and 1000
    FROM coffee_shop_sales2
)

SELECT 
    customer_id,
    SUM("Total Bill") AS total_spend
FROM AssignedCustomers
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 10;

--Q.9) Partition the transactions into three groups:
--Group 1: Total Bill in the bottom 25% of all transactions.
--Group 2: Total Bill in the middle 50%.
--Group 3: Total Bill in the top 25%. For each group,
--calculate the average unit_price and transaction_qty.    


WITH PercentileValues AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Total Bill") AS p25,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Total Bill") AS p75
    FROM coffee_shop_sales2
),

TransactionGroups AS (
    SELECT 
        transaction_id,
        "Total Bill",
        unit_price,
        transaction_qty,
        CASE 
            WHEN "Total Bill" <= (SELECT p25 FROM PercentileValues) THEN 'Group 1: Bottom 25%'
            WHEN "Total Bill" > (SELECT p25 FROM PercentileValues) 
             AND "Total Bill" <= (SELECT p75 FROM PercentileValues) THEN 'Group 2: Middle 50%'
            ELSE 'Group 3: Top 25%'
        END AS transaction_group
    FROM coffee_shop_sales2
)

SELECT 
    transaction_group,
    AVG(unit_price) AS avg_unit_price,
    AVG(transaction_qty) AS avg_transaction_qty
FROM TransactionGroups
GROUP BY transaction_group
ORDER BY transaction_group;

--Q.10)Analyze sales patterns by identifying the combination of Day Name and 
--Hour with the highest sales (Total Bill) for each product category. Include ties, if any.

WITH SalesByDayHour AS (
    SELECT 
        product_category,
        TO_CHAR(transaction_date, 'Day') AS day_name,  -- Extract day name
        EXTRACT(HOUR FROM transaction_date) AS hour,   -- Extract hour
        SUM("Total Bill") AS total_sales
    FROM coffee_shop_sales2
    GROUP BY product_category, day_name, hour
),

RankedSales AS (
    SELECT 
        product_category,
        day_name,
        hour,
        total_sales,
        RANK() OVER (
            PARTITION BY product_category 
            ORDER BY total_sales DESC
        ) AS rank_position
    FROM SalesByDayHour
)

SELECT 
    product_category,
    day_name,
    hour,
    total_sales
FROM RankedSales
WHERE rank_position = 1  -- Select only the highest sales (including ties)
ORDER BY product_category, total_sales DESC;


