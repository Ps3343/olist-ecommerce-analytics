-- =====================================================
-- Project: Olist E-Commerce Analytics
-- File: 03_customer_rfm_analysis.sql
-- Purpose: Segment customers using Recency, Frequency,
--          and Monetary value (RFM) analysis
-- Database: olist_ecommerce
-- =====================================================

USE olist_ecommerce;

-- Customer RFM Segment Summary

WITH customer_rfm AS (
    SELECT
        c.customer_unique_id,
        MAX(DATE(o.order_purchase_timestamp)) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price), 2) AS monetary
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        customer_unique_id,
        last_order_date,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY last_order_date ASC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM customer_rfm
)
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
            THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2
            THEN 'Promising / New'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2
            THEN 'Lost'
        ELSE 'Others'
    END AS customer_segment,
    COUNT(*) AS number_of_customers,
    ROUND(AVG(monetary), 2) AS avg_spend,
    ROUND(SUM(monetary), 2) AS total_revenue
FROM rfm_scores
GROUP BY customer_segment
ORDER BY total_revenue DESC;
