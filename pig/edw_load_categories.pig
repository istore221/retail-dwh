-- pig -param imported_date=2013-05-05 -x mapreduce -useHCatalog  edw_load_categories.pig

staging_categories = LOAD 'retail_stage.categories' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_categories BY imported_date == '$imported_date';

drop_part_column = FOREACH workon_part generate category_id,category_name;

STORE drop_part_column into 'retail_dwh.dim_categories' USING org.apache.hive.hcatalog.pig.HCatStorer();
