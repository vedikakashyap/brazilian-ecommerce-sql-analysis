USE ecommerce_analysis;

-- Revenue Overview
SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as total_customers,
    ROUND(SUM(oi.price + oi.freight_value), 2) as total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) as avg_order_value,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.customer_id), 2) as revenue_per_customer
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- repeat customers
SELECT COUNT(*) AS repeat_customers
FROM
	(
    SELECT 
		c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_count
        FROM customers c
		JOIN orders o
			ON c.customer_id = o.customer_id
				WHERE order_status = 'delivered'
				GROUP BY c.customer_unique_id
                HAVING COUNT(DISTINCT o.order_id) > 1
	 ) AS repeat_customer_list;

-- repeat purchase     
SELECT COUNT(DISTINCT o.customer_id) AS total_customer_id,
	   COUNT(DISTINCT c.customer_unique_id) AS actual_unique_people,
       COUNT(DISTINCT o.customer_id) - COUNT(DISTINCT c.customer_unique_id) AS repeated_customers
FROM orders o 
JOIN customers c 
	ON o.customer_id = c.customer_id
		WHERE o.order_status = 'delivered';
        
-- Repeat rate calculation
SELECT 
    COUNT(DISTINCT c.customer_unique_id) as total_unique_customers,
    2801 as repeat_customers,
    ROUND(2801 * 100.0 / COUNT(DISTINCT c.customer_unique_id), 2) as repeat_rate_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';
