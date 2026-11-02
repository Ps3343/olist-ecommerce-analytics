
-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 01_data_validation.sql
-- Purpose: Validate table sizes, order IDs, and statuses
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- CHECK 1: Count rows in each table
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;

-- CHECK 2: Preview the orders table
SELECT *
FROM orders
LIMIT 5;

-- CHECK 3: Compare total order rows and unique order IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- CHECK 4: Order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

