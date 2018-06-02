-- pig -param imported_date=2016-05-05 -x mapreduce -useHCatalog  edw_load_departments.pig

staging_departments = LOAD 'retail_stage.departments' using org.apache.hive.hcatalog.pig.HCatLoader();

workon_part = FILTER staging_departments BY imported_date == '$imported_date';

drop_part_column = FOREACH workon_part generate department_id,department_name;

STORE drop_part_column into 'retail_dwh.dim_departments' USING org.apache.hive.hcatalog.pig.HCatStorer();
