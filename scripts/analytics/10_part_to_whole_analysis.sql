-- Category share of total sales (Доля категории в общей выручке)
USE DataWarehouseAnalytics;
GO

WITH category_sales AS(
 SELECT
    category,
    SUM(sales_amount) AS total_sales
 FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    -- Divide category sales by total sales (Делим продажи категории на общие продажи)
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
