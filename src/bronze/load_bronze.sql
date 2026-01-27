/*
    DDL Script to load bronze (raw 'E'xtract) tables.

    Run with psql:

        sudo -u postgres psql -f load_bronze.sql
*/

\timing on

\c datawarehouse;

\echo ''
\echo '====================================================='
\echo 'Loading Bronze Layer Tables...'
\echo '====================================================='

\echo ''
\echo '--------------------------------'
\echo 'Loading CRM Source Data...'
\echo '--------------------------------'

\echo 'crm_cust_info...'
TRUNCATE TABLE bronze.crm_cust_info;
\copy bronze.crm_cust_info FROM 'datasets/source_crm/cust_info.csv' DELIMITER ',' CSV HEADER

\echo 'crm_prd_info...'
TRUNCATE TABLE bronze.crm_prd_info;
\copy bronze.crm_prd_info FROM 'datasets/source_crm/prd_info.csv' DELIMITER ',' CSV HEADER

\echo 'crm_sales_details...'
TRUNCATE TABLE bronze.crm_sales_details;
\copy bronze.crm_sales_details FROM 'datasets/source_crm/sales_details.csv' DELIMITER ',' CSV HEADER

\echo ''
\echo '--------------------------------'
\echo 'Loading ERP Source Data...'
\echo '--------------------------------'

\echo 'erp_cust_az12...'
TRUNCATE TABLE bronze.erp_cust_az12;
\copy bronze.erp_cust_az12 FROM 'datasets/source_erp/CUST_AZ12.csv' DELIMITER ',' CSV HEADER

\echo 'erp_prd_mstr_p20...'
TRUNCATE TABLE bronze.erp_loc_a101;
\copy bronze.erp_loc_a101 FROM 'datasets/source_erp/LOC_A101.csv' DELIMITER ',' CSV HEADER

\echo 'erp_loc_a101...'
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\copy bronze.erp_px_cat_g1v2 FROM 'datasets/source_erp/PX_CAT_G1V2.csv' DELIMITER ',' CSV HEADER

\timing off

\q
