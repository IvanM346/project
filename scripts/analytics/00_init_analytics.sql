USE master;
GO

IF DB_ID(N'DataWarehouseAnalytics') IS NULL
    CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

IF SCHEMA_ID(N'gold') IS NULL
    EXEC(N'CREATE SCHEMA gold');
GO

-- Copy the Gold data once for analysis (Копируем данные Gold для анализа)
IF OBJECT_ID(N'gold.dim_customers') IS NULL
    SELECT * INTO gold.dim_customers FROM DataWarehouse.gold.dim_customers;
GO

IF OBJECT_ID(N'gold.dim_products') IS NULL
    SELECT * INTO gold.dim_products FROM DataWarehouse.gold.dim_products;
GO

IF OBJECT_ID(N'gold.fact_sales') IS NULL
    SELECT * INTO gold.fact_sales FROM DataWarehouse.gold.fact_sales;
GO
