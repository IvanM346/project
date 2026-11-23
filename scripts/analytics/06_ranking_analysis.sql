-- Product and customer ranking (Рейтинг товаров и клиентов)
USE DataWarehouseAnalytics;
GO

-- Top 5 products by revenue (Топ-5 товаров по выручке)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Top 5 including ties (Топ-5 с учётом равных мест)
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount)                             AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Bottom 5 products by revenue (Пять товаров с наименьшей выручкой)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Including products with no sales (Включая товары без продаж)
SELECT TOP 5
    p.product_name,
    COALESCE(SUM(f.sales_amount), 0) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Top 10 customers by revenue (Топ-10 клиентов по выручке)
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Three customers with the fewest orders (Три клиента с наименьшим числом заказов)
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;

-- All customers tied for the fewest orders (Все клиенты с минимальным числом заказов)
SELECT *
FROM (
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT f.order_number)                        AS total_orders,
        RANK() OVER (ORDER BY COUNT(DISTINCT f.order_number)) AS rank_orders
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
) AS ranked_customers
WHERE rank_orders = 1;
