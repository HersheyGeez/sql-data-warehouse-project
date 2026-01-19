-- creating database 'DataWarehouse'

/*

==========================================
Create Database and Schemas
==========================================
Script Purpose:
	Creates a new Database 'DataWarehouse' after checking if it already exists.
	If it already exists, it is dropped and recreated.
	Additionally, the script sets up three schemas within the database:
	'bronze', 'silver', 'gold'


WARNING:
	Running the scripts will drop the entire 'DataWarehouse'
	Database if it exists.

	All data in the database will be deleted permanently.

	Proceed with caution, ensure you have proper backups b4 running
	the script.
*/


USE master;
GO


-- drop and recreate the 'DataWarehouse' Database if it exists in the system
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


CREATE DATABASE DataWarehouse;
GO


USE DataWarehouse;
GO


--Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
