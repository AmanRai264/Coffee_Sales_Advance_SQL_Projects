# Coffee Shop Sales Analysis

## Project Overview
This project focuses on analyzing sales data from a coffee shop to extract valuable business insights using SQL queries. The dataset includes transactions with details such as date, time, store location, product categories, and total sales. Various SQL queries were executed to answer key business questions and identify patterns in customer purchases.

## Dataset Description
The dataset used for this project contains the following columns:
- `transaction_id`: Unique identifier for each transaction
- `transaction_date`: Date of the transaction
- `transaction_time`: Time of the transaction
- `transaction_qty`: Quantity of items purchased
- `store_id`: Unique identifier for the store
- `store_location`: Location of the store
- `product_id`: Unique identifier for each product
- `unit_price`: Price per unit of the product
- `product_category`: Category of the product
- `product_type`: Type of the product
- `product_detail`: Detailed description of the product
- `Size`: Size of the product
- `Month Name`: Month when the transaction occurred
- `Day Name`: Day of the week when the transaction occurred
- `Hour`: Hour of the transaction
- `Total Bill`: Total amount paid for the transaction
- `transaction_time (Hour)`: Extracted hour from transaction time
- `transaction_time (Minute)`: Extracted minutes from transaction time
- `transaction_time (Second)`: Extracted seconds from transaction time

## Dataset Description
The dataset used for this project contains the following columns:
- `transaction_id`: Unique identifier for each transaction
- `transaction_date`: Date of the transaction
- `transaction_time`: Time of the transaction
- `transaction_qty`: Quantity of items purchased
- `store_id`: Unique identifier for the store
- `store_location`: Location of the store
- `product_id`: Unique identifier for each product
- `unit_price`: Price per unit of the product
- `product_category`: Category of the product
- `product_type`: Type of the product
- `product_detail`: Detailed description of the product
- `Size`: Size of the product
- `Month Name`: Month when the transaction occurred
- `Day Name`: Day of the week when the transaction occurred
- `Hour`: Hour of the transaction
- `Total Bill`: Total amount paid for the transaction
- `transaction_time (Hour)`: Extracted hour from transaction time
- `transaction_time (Minute)`: Extracted minutes from transaction time
- `transaction_time (Second)`: Extracted seconds from transaction time

## SQL Queries and Insights
Below are the key queries executed on the dataset and their objectives:

### 1. Top 3 Most Frequently Purchased Products per Month
- Identifies the most popular products each month based on transaction count.

### 2. Detecting High-Value Transactions
- Finds transactions where the total bill exceeds three standard deviations above the average for that product category.

### 3. Transactions Above Store Location Average
- Lists all transactions where the total bill is higher than the average total bill for the respective store location.

### 4. High-Sales Products & Their Average Price
- Identifies products with total sales exceeding $1,000 and calculates their average unit price.

### 5. Peak Sales Hour
- Determines the hour of the day with the highest total sales.

### 6. Updating Missing Unit Prices
- Updates transactions where `unit_price` is 0, setting it to the average `unit_price` for the respective `product_type`.

### 7. Ranking Transactions by Total Bill within Store Locations
- Ranks transactions based on total bill within each store location.

### 8. Simulating a Loyalty Program
- Randomly assigns customer IDs and finds the top 10 customers with the highest total spend.

### 9. Categorizing Transactions by Sales Percentiles
- Groups transactions into three categories: bottom 25%, middle 50%, and top 25%, and calculates the average unit price and transaction quantity for each.

### 10. Best Day & Hour for Sales per Product Category
- Identifies the combination of day name and hour with the highest sales for each product category, including ties.

