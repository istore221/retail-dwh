-- pig -param imported_date=2013-05-05 -x mapreduce -useHCatalog  edw_load_categories.pig

staging_products = LOAD 'retail_stage.products' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_products BY imported_date == '$imported_date';

drop_part_column = FOREACH workon_part generate product_id,product_name,product_price;

STORE drop_part_column into 'retail_dwh.dim_products' USING org.apache.hive.hcatalog.pig.HCatStorer();
