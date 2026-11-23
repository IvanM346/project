USE DataWarehouse;
GO

EXEC bronze.load_bronze @source_root = N'/var/opt/mssql/import';
GO
