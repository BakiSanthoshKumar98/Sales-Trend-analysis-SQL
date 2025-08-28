
-- ================================
-- SALES TREND ANALYSIS PROJECT
-- Author: B. Santhosh
-- ================================

-- 1. Create Database
CREATE DATABASE SalesDB;
USE SalesDB;

-- 2. Create Tables
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE Regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    region_id INT,
    sale_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (region_id) REFERENCES Regions(region_id)
);

-- 3. Insert Sample Data
INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Shoes', 'Fashion'),
(4, 'Watch', 'Accessories');

INSERT INTO Regions VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

INSERT INTO Sales (product_id, region_id, sale_date, quantity, unit_price) VALUES
(1, 1, '2025-01-15', 10, 60000),
(2, 2, '2025-01-20', 25, 25000),
(3, 3, '2025-02-05', 50, 2000),
(4, 4, '2025-02-10', 15, 5000),
(1, 2, '2025-03-01', 12, 58000),
(2, 1, '2025-03-15', 30, 24000),
(3, 4, '2025-04-01', 70, 2200),
(4, 3, '2025-04-10', 18, 5200);

-- 4. Sales Trend Analysis Queries

-- (a) Total Sales Amount per Month
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY month
ORDER BY month;

-- (b) Top 3 Best-Selling Products by Revenue
SELECT 
    p.product_name,
    SUM(s.quantity * s.unit_price) AS revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 3;

-- (c) Regional Sales Distribution
SELECT 
    r.region_name,
    SUM(s.quantity * s.unit_price) AS total_sales
FROM Sales s
JOIN Regions r ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_sales DESC;

-- (d) Monthly Growth Rate in Sales
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(quantity * unit_price) AS total_sales
    FROM Sales
    GROUP BY month
)
SELECT 
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
            LAG(total_sales) OVER (ORDER BY month)) * 100, 2) AS growth_rate_percent
FROM MonthlySales;

-- (e) Category-Wise Sales Trend
SELECT 
    p.category,
    DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
    SUM(s.quantity * s.unit_price) AS category_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.category, month
ORDER BY month, category;

-- =====================================
-- END OF SALES TREND ANALYSIS PROJECT
-- =====================================
