-- pig -param year=2013 -param month=05 -param day=12 -x mapreduce -useHCatalog  edw_load_categories.pig

staging_products = LOAD 'retail_stage.products' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_products BY imported_date == '$year-$month-$day';

drop_part_column = FOREACH workon_part generate product_id,product_name,product_price;

STORE drop_part_column into 'retail_dwh.dim_products' USING org.apache.hive.hcatalog.pig.HCatStorer();
