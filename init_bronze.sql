USE master;
GO

IF DB_ID(N'DataWarehouse') IS NULL
    CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

IF SCHEMA_ID(N'bronze') IS NULL
    EXEC(N'CREATE SCHEMA bronze');
GO

SELECT DB_NAME() AS database_name,
       SCHEMA_ID(N'bronze') AS bronze_schema_id;