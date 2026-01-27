
\c datawarehouse

select cst_id, count(*) from bronze.crm_cust_info
group by cst_id having count(*) > 1 or cst_id is null;
