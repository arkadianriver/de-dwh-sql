select * from (
    select *, row_number() over (
    	partition by cst_id order by cst_create_date desc
    ) as flag_last
    from bronze.crm_cust_info
) sub
where flag_last = 1;
