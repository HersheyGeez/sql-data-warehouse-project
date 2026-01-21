/*

===================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================
Script Purpose:
	This stored procedure loads into the 'bronze' schema from external CSV files.
	It performs the following actions:
	- Truncates the bronze table before loading the data.
	- Uses bulk 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:
		None.
	This Stored procedure doesn't accept any parameters or return any values.

Usage Examples:
	EXEC bronze.load_bronze
===================================================

*/



CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_final DATETIME, @end_time_final DATETIME;
		
		SET @start_time_final = GETDATE();
		PRINT '=======================================';
		PRINT 'Loading the Bronze Layer';
		PRINT '=======================================';


		PRINT '---------------------------------------';
		PRINT 'Loading the CRM Files';
		PRINT '---------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';

		PRINT '---------------------------------------';
		PRINT 'Loading the ERP Files';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM "D:\Programming\SQL-data-with-Baraa\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ----------';
		SET @end_time_final = GETDATE();
		
		PRINT '=======================================';
		PRINT 'Loading the Bronze Layer';
		PRINT '>> Total Batch Load Duration: ' + CAST(DATEDIFF(second, @start_time_final, @end_time_final) AS NVARCHAR) + ' seconds';
		PRINT '=======================================';

	END TRY

	BEGIN CATCH
		PRINT '=======================================';
		PRINT 'ERROR Loading the Bronze Layer';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================='; 

		THROW;

	END CATCH
END
