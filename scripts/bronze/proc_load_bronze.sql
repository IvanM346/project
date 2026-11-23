USE DataWarehouse;
GO
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It truncates the bronze tables and uses BULK INSERT to load the CSV files.

Parameters:
    @source_root: directory containing source_crm and source_erp.

Usage Example:
    EXEC bronze.load_bronze;

Note:
    The default path is 'C:\sql\crm_erp'. Pass a Linux path for Docker.
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze
    @source_root NVARCHAR(4000) = N'C:\sql\crm_erp'
AS
BEGIN
    SET XACT_ABORT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME,
            @batch_start_time DATETIME, @batch_end_time DATETIME,
            @separator NCHAR(1), @file_path NVARCHAR(4000), @bulk_sql NVARCHAR(MAX);

    SET @separator = CASE WHEN LEFT(@source_root, 1) = N'/' THEN N'/' ELSE N'\' END;
    IF RIGHT(@source_root, 1) = @separator
        SET @source_root = LEFT(@source_root, LEN(@source_root) - 1);

    BEGIN TRY
        BEGIN TRANSACTION;
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        SET @file_path = CONCAT(@source_root, @separator, N'source_crm', @separator, N'cust_info.csv');
        SET @bulk_sql = N'BULK INSERT bronze.crm_cust_info FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        SET @file_path = CONCAT(@source_root, @separator, N'source_crm', @separator, N'prd_info.csv');
        SET @bulk_sql = N'BULK INSERT bronze.crm_prd_info FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        SET @file_path = CONCAT(@source_root, @separator, N'source_crm', @separator, N'sales_details.csv');
        SET @bulk_sql = N'BULK INSERT bronze.crm_sales_details FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        SET @file_path = CONCAT(@source_root, @separator, N'source_erp', @separator, N'LOC_A101.csv');
        SET @bulk_sql = N'BULK INSERT bronze.erp_loc_a101 FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        SET @file_path = CONCAT(@source_root, @separator, N'source_erp', @separator, N'CUST_AZ12.csv');
        SET @bulk_sql = N'BULK INSERT bronze.erp_cust_az12 FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        SET @file_path = CONCAT(@source_root, @separator, N'source_erp', @separator, N'PX_CAT_G1V2.csv');
        SET @bulk_sql = N'BULK INSERT bronze.erp_px_cat_g1v2 FROM '''
            + REPLACE(@file_path, N'''', N'''''')
            + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK);';
        EXEC sys.sp_executesql @bulk_sql;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        COMMIT TRANSACTION;
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
        THROW;
    END CATCH
END;
GO
