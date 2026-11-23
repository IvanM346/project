-- Уникальные значения в справочниках.
USE DataWarehouseAnalytics;
GO

SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;

SELECT DISTINCT category, subcategory
FROM gold.dim_products
ORDER BY category, subcategory;

SELECT DISTINCT product_line
FROM gold.dim_products
ORDER BY product_line;
