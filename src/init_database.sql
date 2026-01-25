/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.

Run with psql:
    sudo -u postgres psql -f init_database.sql
=============================================================
*/

\timing on

\echo ''
\echo '====================================================='
\echo "Drop and recreate the 'datawarehouse' database"
\echo '====================================================='
DROP DATABASE IF EXISTS datawarehouse;
CREATE DATABASE datawarehouse;

\echo ''
\echo '--------------------------------------'
\echo 'connecting...'
\echo '--------------------------------------'
\c datawarehouse;

\echo ''
\echo '--------------------------------------'
\echo 'create schema bronze, silver, gold...'
\echo '--------------------------------------'
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

\timing off

\q
