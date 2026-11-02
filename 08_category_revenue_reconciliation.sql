-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 08_category_revenue_reconciliation.sql
-- Purpose: Validate total revenue across product categories
-- Filter: Delivered orders only
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- Check: Reconcile category revenue with delivered revenue
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
