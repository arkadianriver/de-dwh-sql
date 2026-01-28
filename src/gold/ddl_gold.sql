/*
    DDL Script to create gold views.

    Run with psql:

        sudo -u postgres psql -f ddl_gold.sql
*/

\timing on

\c datawarehouse;

\echo ''
\echo '====================================================='
\echo 'Creating Gold Layer Tables...'
\echo '====================================================='

\echo ''
\echo '--------------------------------'
\echo 'Creating Customer dimension...'
\echo '--------------------------------'

DROP VIEW IF EXISTS gold.dim_customers CASCADE;

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	cl.cntry as country,
	ci.cst_marital_status as marital_status,
	CASE WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'Unknown')
	END as gender,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date
  FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca on ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl on ci.cst_key = cl.cid;


\echo ''
\echo '--------------------------------'
\echo 'Creating Product dimension...'
\echo '--------------------------------'

DROP VIEW IF EXISTS gold.dim_products CASCADE;

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.category,
	pc.subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
  FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id=pc.id
WHERE pn.prd_end_dt IS NULL;


\echo ''
\echo '--------------------------------'
\echo 'Creating Sales facts...'
\echo '--------------------------------'

DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
	pr.product_key,
	cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
  FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id;
