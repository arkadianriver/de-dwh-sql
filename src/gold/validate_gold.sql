
\c datawarehouse

\echo ''
\echo ===================================================
\echo Validating Gold Layer...
\echo ===================================================

\echo ''
\echo ---------------------------------------------------
\echo Dimensions
\echo ---------------------------------------------------

\echo ''
\echo -----------------------
\echo Customer dimension...
\echo -----------------------

\echo >> Check for uniqueness of customer keys.
-- Expectation: No Results
DO $$
BEGIN
    IF EXISTS (
        SELECT customer_key, COUNT(*) AS duplicate_count
          FROM gold.dim_customers
        GROUP BY customer_key HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Keys are not unique.';
    ELSE
        RAISE NOTICE '✔ Keys are unique.';
       END IF;
END $$;

\echo ''
\echo -----------------------
\echo Product dimension...
\echo -----------------------

\echo >> Check for uniqueness of product keys.
-- Expectation: No Results
DO $$
BEGIN
    IF EXISTS (
        SELECT product_key, COUNT(*) AS duplicate_count
          FROM gold.dim_products
        GROUP BY product_key HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Keys are not unique.';
    ELSE
        RAISE NOTICE '✔ Keys are unique.';
       END IF;
END $$;


\echo ''
\echo ---------------------------------------------------
\echo Sales Facts
\echo ---------------------------------------------------

\echo >> Check fact and dimension connectivity.
-- Expectation: No Results
DO $$
BEGIN
    IF (
        SELECT count(*) FROM gold.fact_sales f
        LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
        LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
        WHERE p.product_key IS NULL OR c.customer_key IS NULL
    ) > 0 THEN
        RAISE EXCEPTION 'Problem between keys.';
    ELSE
        RAISE NOTICE '✔ No unlinked keys.';
    END IF;
END $$;
