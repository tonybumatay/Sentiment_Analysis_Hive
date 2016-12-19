DROP TABLE IF EXISTS no_null_ratings; 
CREATE TABLE no_null_ratings (hw_number String, count int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE  TABLE no_null_ratings SELECT hw_number, 1 from filtered_data WHERE filtered_data.review IS NOT NULL;
SELECT hw_number, count(count) AS num FROM no_null_ratings GROUP BY hw_number;s
