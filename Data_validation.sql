USE ecommerce_analysis;

-- ===========================================
-- DATA VALIDATION RESULTS
-- Run Date: 2026-02-09
-- ===========================================

-- ROW COUNTS
-- customers: 99,441
-- orders: 99,441
-- order_items: 112,650
-- products: 32,951
-- sellers: 3,095
-- order_payments: 103,886
-- order_reviews: (you didn't paste this - run it)

-- REVENUE METRICS
-- Total delivered orders: 96,478
-- Total revenue: 15,419,773.75 BRL
-- Average order value: 159.83 BRL (~$40 USD)

-- CUSTOMER METRICS
-- Unique customers: 96,096
-- Repeat customers: 2,801
-- Repeat rate: 3.00%

-- GEOGRAPHIC DISTRIBUTION
-- SP: 41.94% of customers
-- RJ: 12.89%
-- MG: 11.72%
-- Top 5 states: 77.12% of total

-- TIME PERIOD
-- First order: 2016-09-04
-- Last order: 2018-10-17
-- Days of data: 773 days (~25 months)

-- KEY INSIGHTS
-- 1. Severe retention problem: Only 3% repeat rate vs 25-30% industry benchmark
-- 2. Low basket size: 1.17 items per order
-- 3. Marketplace model: 3,095 different sellers
-- 4. Payment complexity: 103,886 payment records (installment plans common in Brazil)

-- ROW COUNT
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

-- Revenue overview
SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) as total_revenue_brl,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) as avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- top 5 states
SELECT 
    customer_state,
    COUNT(DISTINCT customer_unique_id) as customer_count,
    ROUND(COUNT(DISTINCT customer_unique_id) * 100.0 / 
          (SELECT COUNT(DISTINCT customer_unique_id) FROM customers), 2) as pct_of_total
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 5;

-- Date Range
SELECT 
    MIN(order_purchase_timestamp) as first_order,
    MAX(order_purchase_timestamp) as last_order,
    DATEDIFF(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)) as days_of_data
FROM orders;

