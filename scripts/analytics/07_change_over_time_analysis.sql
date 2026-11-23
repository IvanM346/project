-- Monthly sales trends (Продажи по месяцам)
USE DataWarehouseAnalytics;
GO

SELECT
    YEAR(order_date)             AS order_year,
    MONTH(order_date)            AS order_month,
    SUM(sales_amount)            AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity
FROM gold.fact_sales
-- Exclude orders without dates (Исключаем заказы без даты)
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Same result using DATETRUNC (Тот же результат через DATETRUNC)
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount)            AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
