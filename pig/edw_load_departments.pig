-- pig -param year=2013 -param month=05 -param day=12 -x mapreduce -useHCatalog  edw_load_departments.pig

staging_departments = LOAD 'retail_stage.departments' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_departments BY imported_date == '$year-$month-$day';

drop_part_column = FOREACH workon_part generate department_id,department_name;

STORE drop_part_column into 'retail_dwh.dim_departments' USING org.apache.hive.hcatalog.pig.HCatStorer();
