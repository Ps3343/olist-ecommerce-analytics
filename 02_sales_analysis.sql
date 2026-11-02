
-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 02_sales_analysis.sql
-- Purpose: Analyze overall sales and monthly trends
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;


--  1: Overall sales and freight
SELECT
    ROUND(SUM(oi.price), 2) AS total_item_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_with_freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


--  2: Monthly sales trends for delivered orders
SELECT
    SUBSTRING(o.order_purchase_timestamp, 1, 7) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_item_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY SUBSTRING(o.order_purchase_timestamp, 1, 7)
ORDER BY order_month;
