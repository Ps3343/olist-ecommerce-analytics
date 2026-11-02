-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 06_product_join_validation.sql
-- Purpose: Check item rows and revenue before and after
--          joining the products table
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- Check: Compare delivered items before and after product join

SELECT
    'All delivered order items' AS check_name,
    COUNT(*) AS item_rows,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'

UNION ALL

SELECT
    'After joining products' AS check_name,
    COUNT(*) AS item_rows,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';
