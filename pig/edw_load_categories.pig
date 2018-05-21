-- pig -param year=2013 -param month=05 -param day=12 -x mapreduce -useHCatalog  edw_load_categories.pig

staging_categories = LOAD 'retail_stage.categories' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_categories BY imported_date == '$year-$month-$day';

drop_part_column = FOREACH workon_part generate category_id,category_name;

STORE drop_part_column into 'retail_dwh.dim_categories' USING org.apache.hive.hcatalog.pig.HCatStorer();
