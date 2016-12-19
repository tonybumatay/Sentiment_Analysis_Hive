DROP TABLE IF EXISTS filtered_data;
CREATE TABLE filtered_data (hw_number STRING, label STRING, review STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
--For all of the directories
-- $ hadoop fs -put /home/training/hw_reviews_FL2016/positive/* /user/hive/warehouse/filtered_data
-- you need to have the udf written
ADD JAR  filteringStop.jar;
CREATE TEMPORARY FUNCTION filterData AS 'stubs.stopwords';
CREATE TABLE hw_data (hw_number STRING, label STRING, review STRING, rank INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE hw_data SELECT hw_number, label, filterData(review), row_number() OVER() as rank FROM filtered_data;
