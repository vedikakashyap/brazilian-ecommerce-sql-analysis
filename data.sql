CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

-- Customers
CREATE TABLE customers (
    customer_id VARCHAR(255) PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(255),
    customer_state VARCHAR(2)
);

-- Orders
CREATE TABLE orders (
    order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Products
CREATE TABLE products (
    product_id VARCHAR(255) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- Sellers Table
CREATE TABLE sellers (
    seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(255),
    seller_state VARCHAR(2)
);

-- Product Category Translation
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(255) PRIMARY KEY,
    product_category_name_english VARCHAR(255)
);

-- Order Payments Table
CREATE TABLE order_payments (
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    INDEX idx_payment_type (payment_type)
);

-- Order Reviews Table
CREATE TABLE order_reviews (
    review_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    INDEX idx_order (order_id),
    INDEX idx_score (review_score)
);

-- importing data
SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE "C:\\Users\\vedik\\OneDrive\\Documents\\College documents\\SQL Notes\\brazillian e-commerce data\\ecommerce-sql-analysisdata\\olist_order_reviews_dataset.csv"
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Row Counts Validation
SELECT 'customers' as table_name, COUNT(*) as row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews;

-- Expected Results:
-- customers: ~99,441
-- orders: ~99,441
-- order_items: ~112,650
-- products: ~32,951
-- sellers: ~3,095
-- order_payments: ~103,886
-- order_reviews: ~99,224

-- Date Range Check
SELECT 
    MIN(order_purchase_timestamp) as first_order,
    MAX(order_purchase_timestamp) as last_order,
    DATEDIFF(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)) as days_of_data
FROM orders;
-- Should be: 2016-09-04 to 2018-10-17 (around 774 days)

-- Order Status Distribution
SELECT 
    order_status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- Top 10 Product Categories by Revenue
SELECT 
    pct.product_category_name_english,
    COUNT(DISTINCT oi.order_id) as order_count,
    ROUND(SUM(oi.price), 2) as revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;

-- Geographic Distribution
SELECT 
    customer_state,
    COUNT(DISTINCT customer_id) as customer_count,
    ROUND(COUNT(DISTINCT customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM customers), 2) as percentage
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- Data Quality Check - Missing Values
SELECT 
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) as missing_approval,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) as missing_delivery,
    COUNT(*) as total_orders,
    ROUND(SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as pct_missing_delivery
FROM orders;

