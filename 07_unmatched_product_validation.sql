-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 07_unmatched_product_validation.sql
-- Purpose: Identify delivered items with missing products
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- Check: Find order items without a matching product
SELECT
    COUNT(*) AS unmatched_item_rows,
    COUNT(DISTINCT oi.product_id) AS unmatched_product_ids,
    ROUND(SUM(oi.price), 2) AS unmatched_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND p.product_id IS NULL;
