-- pig -param year=2013 -param month=05 -param day=12 -x mapreduce -useHCatalog  edw_load_customers.pig

staging_customers = LOAD 'retail_stage.customers' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_customers BY imported_date == '$year-$month-$day';

drop_part_column = FOREACH workon_part generate customer_id,customer_fname,customer_lname,customer_email,customer_street,customer_city,customer_state,customer_zipcode;

STORE drop_part_column INTO 'hbase://customers'
       USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
       'personal_info:customer_fname,personal_info:customer_lname,personal_info:customer_email,personal_info:customer_street,personal_info:customer_city,personal_info:customer_state,personal_info:customer_zipcode');
