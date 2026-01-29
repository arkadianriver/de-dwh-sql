
\c datawarehouse

\echo ''
\echo ===================================================
\echo Validating Silver Layer...
\echo ===================================================

\echo ''
\echo ---------------------------------------------------
\echo CRM Data
\echo ---------------------------------------------------

\echo ''
\echo -----------------------
\echo crm_cust_info...
\echo -----------------------

\echo >> Check for nulls or duplicates.
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		select cst_id, count(*) from silver.crm_cust_info
		group by cst_id having count(*) > 1 or cst_id is null
	) THEN
		RAISE EXCEPTION 'Duplicates or null values exist.';
	ELSE
		RAISE NOTICE '✔ No duplicates found.';
   	END IF;
END $$;


\echo >> Check for unwanted spaces
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT cst_key FROM silver.crm_cust_info
		WHERE cst_key != TRIM(cst_key)
	) THEN
		RAISE EXCEPTION 'Unwanted spaces found.';
	ELSE
		RAISE NOTICE '✔ No unwanted spaces found.';
   	END IF;
END $$;


\echo >> Data standardization & consistency
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info
		WHERE cst_marital_status NOT IN ('Married', 'Single', 'Unknown')
	) THEN
		RAISE EXCEPTION 'Unwanted values found.';
	ELSE
		RAISE NOTICE '✔ No unwanted values found.';
   	END IF;
END $$;


\echo ''
\echo -----------------------
\echo crm_prd_info...
\echo -----------------------

\echo >> Check for nulls or duplicates.
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		select prd_id, count(*) from silver.crm_prd_info
		group by prd_id having count(*) > 1 or prd_id is null
	) THEN
		RAISE EXCEPTION 'Duplicates or null values exist.';
	ELSE
		RAISE NOTICE '✔ No duplicates found.';
   	END IF;
END $$;


\echo >> Check for unwanted spaces
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT prd_nm FROM silver.crm_prd_info
		WHERE prd_nm != TRIM(prd_nm)
	) THEN
		RAISE EXCEPTION 'Unwanted spaces found.';
	ELSE
		RAISE NOTICE '✔ No unwanted spaces found.';
   	END IF;
END $$;


\echo >> Check for nulls or negative values in cost
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT prd_cost FROM silver.crm_prd_info
		WHERE prd_cost < 0 or prd_cost IS NULL
	) THEN
		RAISE EXCEPTION 'Negative values or nulls found.';
	ELSE
		RAISE NOTICE '✔ No negative values or nulls found.';
   	END IF;
END $$;


\echo >> Data standardization & consistency
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT prd_line FROM silver.crm_prd_info
		WHERE prd_line NOT IN ('Mountain', 'Road', 'Touring', 'Other Sales', 'Unknown')
	) THEN
		RAISE EXCEPTION 'Unwanted values found.';
	ELSE
		RAISE NOTICE '✔ No unwanted values found.';
   	END IF;
END $$;


\echo >> Check for invalid date orders
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT * FROM silver.crm_prd_info
		WHERE prd_end_dt < prd_start_dt
	) THEN
		RAISE EXCEPTION 'Invalid date found.';
	ELSE
		RAISE NOTICE '✔ No invalid dates found.';
   	END IF;
END $$;


\echo ''
\echo -----------------------
\echo crm_sales_details...
\echo -----------------------


\echo >> Check for invalid due dates
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT sls_due_dt FROM silver.crm_sales_details
		WHERE LENGTH(CAST(sls_due_dt AS VARCHAR)) != 10
		    OR sls_due_dt > '2050-01-01'::date
		    OR sls_due_dt < '1900-01-01'::date
	) THEN
		RAISE EXCEPTION 'Invalid date found.';
	ELSE
		RAISE NOTICE '✔ No invalid dates found.';
   	END IF;
END $$;


\echo >> Check for Invalid Date Orders
-- Expectation: No Results (all Order Dates < Shipping/Due Dates)
DO $$
BEGIN
	IF EXISTS (
		SELECT * FROM silver.crm_sales_details
		WHERE sls_order_dt > sls_ship_dt 
		   OR sls_order_dt > sls_due_dt
	) THEN
		RAISE EXCEPTION 'Invalid date found.';
	ELSE
		RAISE NOTICE '✔ No invalid dates found.';
   	END IF;
END $$;


\echo >> Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT sls_sales, sls_quantity, sls_price 
		FROM silver.crm_sales_details
		WHERE sls_sales != sls_quantity * sls_price
		   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
		   OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
		ORDER BY sls_sales, sls_quantity, sls_price
	) THEN
		RAISE EXCEPTION 'Inconsistent data found.';
	ELSE
		RAISE NOTICE '✔ Data is consistent.';
   	END IF;
END $$;


\echo ''
\echo ---------------------------------------------------
\echo ERP Data
\echo ---------------------------------------------------

\echo ''
\echo -----------------------
\echo erp_cust_az12...
\echo -----------------------

\echo >> Check for invalid birthdates
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT bdate FROM silver.erp_cust_az12
		WHERE bdate < CURRENT_DATE - interval '115 years'
		   OR bdate > CURRENT_DATE
	) THEN
		RAISE EXCEPTION 'Invalid birthdates found.';
	ELSE
		RAISE NOTICE '✔ No invalid birthdates found.';
   	END IF;
END $$;


\echo >> Data standardization & consistency
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT gen FROM silver.erp_cust_az12
		WHERE gen NOT IN ('Male', 'Female', 'Unknown')
	) THEN
		RAISE EXCEPTION 'Unwanted values found.';
	ELSE
		RAISE NOTICE '✔ No unwanted values found.';
   	END IF;
END $$;


\echo ''
\echo -----------------------
\echo erp_px_cat_g1v2...
\echo -----------------------


\echo >> Check for unwanted spaces
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT * FROM silver.erp_px_cat_g1v2
		WHERE category != TRIM(category)
		   OR subcategory != TRIM(subcategory)
		   OR maintenance != TRIM (maintenance)
	) THEN
		RAISE EXCEPTION 'Unwanted spaces found.';
	ELSE
		RAISE NOTICE '✔ No unwanted spaces found.';
   	END IF;
END $$;


\echo >> Data standardization & consistency
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT maintenance FROM silver.erp_px_cat_g1v2
		WHERE maintenance NOT IN ('No', 'Yes')
	) THEN
		RAISE EXCEPTION 'Unwanted values found.';
	ELSE
		RAISE NOTICE '✔ No unwanted values found.';
   	END IF;
END $$;


\echo ''
\echo ''
\echo -----------------------
\echo erp_loc_a101...
\echo -----------------------

\echo >> Data standardization & consistency
-- Expectation: No Results
DO $$
BEGIN
	IF EXISTS (
		SELECT DISTINCT cntry FROM silver.erp_loc_a101
		WHERE cntry NOT IN (
			'Australia',
			'Canada',
			'France',
			'Germany',
			'United Kingdom',
			'United States',
			'Unknown')
	) THEN
		RAISE EXCEPTION 'Unwanted values found.';
	ELSE
		RAISE NOTICE '✔ No unwanted values found.';
   	END IF;
END $$;



