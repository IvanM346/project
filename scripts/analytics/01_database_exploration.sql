-- Gold tables and columns (Таблицы и столбцы слоя Gold)
USE DataWarehouseAnalytics;
GO

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold';

-- Inspect customer columns (Проверка столбцов клиентов)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_NAME = 'dim_customers';
