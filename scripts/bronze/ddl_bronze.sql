/*
    DDL Script to create bronze (raw 'E'xtract) tables.

    Run with psql:

        sudo -u postgres psql -f ddl_bronze.sql
*/

\c datawarehouse;

\echo ''
\echo '====================================================='
\echo 'Creating Bronze Layer Tables...'
\echo '====================================================='

\echo ''
\echo '--------------------------------'
\echo 'Creating CRM Source Tables...'
\echo '--------------------------------'

\echo 'crm_cust_info...'
DROP TABLE IF EXISTS bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            -- in bronze data, some ids don't exist
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  CHAR(1),
    cst_gndr            CHAR(1),
    cst_create_date     DATE
);

\echo 'crm_prd_info...'
DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

\echo 'crm_sales_details...'
DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);


\echo ''
\echo '--------------------------------'
\echo 'Creating ERP Source Tables...'
\echo '--------------------------------'

\echo 'erp_cust_az12...'
DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    cid         VARCHAR(50),
    bdate       DATE,
    gen         VARCHAR(50)
);

\echo 'erp_loc_a101...'
DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50)
);

\echo 'erp_px_cat_g1v2...'
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          VARCHAR(50),
    category    VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50)
);

\q
