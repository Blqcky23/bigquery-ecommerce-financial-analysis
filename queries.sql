-- ============================================================================
-- 1. FINANCIAL PERFORMANCE BY PRODUCT CATEGORY
-- Purpose: Calculate revenue, cost, gross profit, and margin percentage 
-- for completed orders using JOIN and GROUP BY aggregations.
-- ============================================================================
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.sale_price), 2) AS total_revenue,
    ROUND(SUM(p.cost), 2) AS total_cost,
    ROUND(SUM(oi.sale_price - p.cost), 2) AS gross_profit,
    ROUND(SAFE_DIVIDE(SUM(oi.sale_price - p.cost), SUM(oi.sale_price)) * 100, 2) AS margin_pct
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p 
    ON oi.product_id = p.id
WHERE oi.status = 'Complete'
GROUP BY p.category
ORDER BY gross_profit DESC;


-- ============================================================================
-- 2. MONTHLY REVENUE TREND & CUMULATIVE GROWTH
-- Purpose: Track month-over-month performance and running revenue totals
-- using Common Table Expressions (CTE) and SQL Window Functions.
-- ============================================================================
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC(DATE(created_at), MONTH) AS sales_month,
        ROUND(SUM(sale_price), 2) AS monthly_revenue
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE status = 'Complete'
    GROUP BY 1
)
SELECT 
    sales_month,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER(ORDER BY sales_month), 2) AS cumulative_revenue,
    ROUND(LAG(monthly_revenue) OVER(ORDER BY sales_month), 2) AS prev_month_revenue
FROM monthly_sales
ORDER BY sales_month DESC
LIMIT 24;


-- ============================================================================
-- 3. FINANCIAL DATA QUALITY & ANOMALY AUDIT
-- Purpose: Verify data integrity by checking for NULL values, non-positive 
-- prices/costs, and negative profit margins before downstream reporting.
-- ============================================================================
SELECT 
    COUNT(*) AS total_rows,
    COUNTIF(oi.sale_price IS NULL OR oi.sale_price <= 0) AS invalid_prices,
    COUNTIF(p.cost IS NULL OR p.cost <= 0) AS invalid_costs,
    COUNTIF(oi.sale_price < p.cost) AS negative_margin_items
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` p 
    ON oi.product_id = p.id;
