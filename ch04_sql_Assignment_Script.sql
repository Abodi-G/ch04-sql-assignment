1

SELECT full_name, location
FROM customer_info
WHERE location = 'Nairobi';

2

SELECT c.full_name, p.product_name, p.price
FROM customer_info c
JOIN products p ON c.customer_id = p.customer_id;

3


SELECT c.full_name, SUM(s.total_sales) AS total_amount_spent
FROM customer_info c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.full_name
ORDER BY total_amount_spent DESC;

4

SELECT DISTINCT c.full_name, c.location
FROM customer_info c
JOIN products p ON c.customer_id = p.customer_id
WHERE p.price > 10000;

5

SELECT c.full_name, SUM(s.total_sales) AS total_amount_spent
FROM customer_info c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.full_name
ORDER BY total_amount_spent DESC
LIMIT 3;

6

WITH customer_totals AS (
    SELECT c.customer_id, c.full_name, SUM(s.total_sales) AS total_sales
    FROM customer_info c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.full_name
),
avg_sales AS (
    SELECT AVG(total_sales) AS avg_total_sales
    FROM customer_totals
)
SELECT ct.full_name, ct.total_sales
FROM customer_totals ct, avg_sales a
WHERE ct.total_sales > a.avg_total_sales;

7

SELECT p.product_name,
       SUM(s.total_sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_name;

8

CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.full_name, SUM(s.total_sales) AS total_sales
FROM customer_info c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.full_name
HAVING SUM(s.total_sales) > 15000;

SELECT * FROM high_value_customers;

9

DELIMITER $$

CREATE PROCEDURE GetCustomersByLocation(IN loc VARCHAR(90))
BEGIN
    SELECT c.full_name, SUM(s.total_sales) AS total_spending
    FROM customer_info c
    JOIN sales s ON c.customer_id = s.customer_id
    WHERE c.location = loc
    GROUP BY c.full_name;
END $$

DELIMITER ;

10
WITH RECURSIVE sales_cte AS (
    SELECT s.sales_id, s.total_sales, s.total_sales AS running_total
    FROM sales s
    WHERE s.sales_id = (SELECT MIN(sales_id) FROM sales)

    UNION ALL

    SELECT s.sales_id, s.total_sales, sc.running_total + s.total_sales
    FROM sales s
    JOIN sales_cte sc ON s.sales_id = sc.sales_id + 1
)
SELECT sales_id, total_sales, running_total
FROM sales_cte;

11

SELECT sales_id, total_sales
FROM sales
WHERE total_sales > 5000;

12

CREATE INDEX idx_customer_location ON customer_info(location);

EXPLAIN ANALYZE
SELECT full_name, location
FROM customer_info
WHERE location = 'Nairobi';

13

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    location VARCHAR(90)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Sales table (fact relationship)
CREATE TABLE sales (
    sales_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_sales DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


14
CREATE TABLE fact_sales (
    sales_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    location_id INT,
    quantity INT,
    total_sales DECIMAL(12,2),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id)
);

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120),
    price DECIMAL(10,2)
);

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(120)
);

CREATE TABLE dim_location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(90)
);

SELECT 
    p.product_name,
    l.location_name,
    SUM(f.total_sales) AS total_sales_amount,
    SUM(f.quantity) AS total_quantity_sold
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY p.product_name, l.location_name
ORDER BY total_sales_amount DESC;


15

CREATE TABLE sales_report (
    sales_id INT PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(120),
    location VARCHAR(90),
    product_id INT,
    product_name VARCHAR(120),
    price DECIMAL(10,2),
    quantity INT,
    total_sales DECIMAL(12,2)
);

SELECT location, SUM(total_sales) 
FROM sales_report
GROUP BY location;











