-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 04_category_analysis.sql
-- Purpose: Analyze revenue and items sold by product category
-- Filter: Delivered orders only
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- Product Category Revenue Analysis

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown / Missing Category'
    ) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC;

