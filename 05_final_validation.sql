
-- =========================================================
-- Project: Olist E-Commerce Analytics
-- File: 05_final_validation.sql
-- Purpose: Validate revenue, customers, product joins,
--          unmatched products, and category revenue
-- Database: olist_ecommerce
-- =========================================================

USE olist_ecommerce;


--  1: Total delivered item-price revenue
SELECT
    ROUND(SUM(oi.price), 2) AS delivered_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 2: Number of unique customers in RFM analysis
SELECT
    COUNT(DISTINCT c.customer_unique_id) AS rfm_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 3: Compare item rows and revenue before
-- and after joining the products table
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


--  4: Identify unmatched product records
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


-- 5: Reconcile revenue across product categories
SELECT
    ROUND(SUM(category_revenue), 2) AS total_category_revenue
FROM (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown / Missing Category'
        ) AS category,
        SUM(oi.price) AS category_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation ct
        ON p.product_category_name = ct.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY category
) AS category_totals;
