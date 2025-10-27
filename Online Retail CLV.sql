DROP DATABASE IF EXISTS Online_Retail;
CREATE DATABASE online_retail_clv;
USE online_retail_clv;

DROP TABLE IF EXISTS online_retail;
CREATE TABLE online_retail (
    Invoice_No VARCHAR(20),
    Stock_Code VARCHAR(20),
    Description TEXT,
    Quantity INT,
    Invoice_Date DATETIME,
    Unit_Price DECIMAL(10, 2),
    Customer_ID INT NULL,
    Country VARCHAR(100)
);



SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Retail CLV.csv'
INTO TABLE online_retail
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Invoice_No, Stock_Code, Description, Quantity, Invoice_Date, Unit_Price, @Customer_ID, Country)
SET Customer_ID = IF(@Customer_ID = '', 0, @Customer_ID);
------------------------------------------------------------------------------------------
-- 1. Basic Data Understanding
------------------------------ 
select * from online_retail
limit 10;

select count(distinct Invoice_No) AS Total_Transactions
FROM online_retail;

select count(distinct Customer_ID) AS Total_Customers
FROM online_retail;

ALTER TABLE online_retail
ADD COLUMN Profit decimal(10,2);

UPDATE online_retail
SET Profit = Quantity * Unit_Price;

SELECT Profit from online_retail;
---------------------------------------------------------------------------------
-- 2. Revenue Analysis
-----------------------
SELECT Profit AS Total_Revenue
FROM online_retail;

SELECT Country, 
SUM(Profit) AS Revenue
FROM online_retail 
GROUP BY Country
ORDER BY Revenue DESC;

select Description as Product_name,
SUM(Quantity) as Total_sold
from online_retail
group by Description
order by Total_sold Desc
limit 10;

SELECT Description,
SUM(Profit) AS Total_revenue
FROM online_retail
GROUP BY Description
ORDER BY Total_revenue desc
LIMIT 10;
---------------------------------------------------------------------------
-- 3. Customer Insights
--------------------------
SELECT 
    Customer_ID,
    SUM(Profit) AS total_spent
FROM online_retail
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID
ORDER BY total_spent DESC
LIMIT 10;

SELECT SUM(Profit)/COUNT(distinct Customer_ID),2 AS Avg_revenue_per_customer
FROM online_retail
WHERE Customer_ID IS NOT NULL;

SELECT Customer_ID, COUNT(DISTINCT Invoice_No) AS Total_orders
FROM online_retail
GROUP BY Customer_ID
ORDER BY Total_orders DESC
LIMIT 10;
-------------------------------------------------------------------------
-- 4. Time Based Insights
--------------------------
select date_format(Invoice_Date,'%Y-%m') AS Month,
SUM(Profit) AS Monthly_Revenue
From online_retail
group by Month
order by Month;

select SUM(Profit)/count(distinct Invoice_No) as avg_order_value
from online_retail;

SELECT MAX(Invoice_Date) AS last_transaction_date FROM online_retail;

SELECT Customer_ID, MAX(Invoice_Date) AS last_purchase,
COUNT(DISTINCT Invoice_No) AS frequency,
SUM(Profit) AS monetary
FROM online_retail
Where Customer_ID is not null
GROUP BY Customer_ID;
------------------------------------------------------------------------------------- Reference date: last purchase date in dataset
-- 5.RFM Metrics (for LTV modeling)
SELECT @ref_date := MAX(Invoice_Date) FROM online_retail;

-- Compute Recency, Frequency, Monetary
SELECT
    Customer_ID,
    DATEDIFF(@ref_date, MAX(Invoice_Date)) AS RecencyDays,
    COUNT(DISTINCT Invoice_No) AS Frequency,
    ROUND(SUM(Profit), 2) AS Monetary
FROM online_retail
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID
ORDER BY Monetary DESC;
--------------------------------------------------------------------------
-- 6. LTV Feature Preparation
-- Prepare data for modeling
CREATE OR REPLACE VIEW customer_ltv_features AS
SELECT
    Customer_ID,
    DATEDIFF(
        (SELECT MAX(Invoice_Date) FROM online_retail),
        MAX(Invoice_Date)
    ) AS RecencyDays,
    COUNT(DISTINCT Invoice_No) AS Frequency,
    ROUND(SUM(Profit) / COUNT(DISTINCT Invoice_No), 2) AS AOV,
    ROUND(SUM(Profit), 2) AS TotalSpend
FROM online_retail
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID;


-- Check data
SELECT * FROM customer_ltv_features LIMIT 10;










