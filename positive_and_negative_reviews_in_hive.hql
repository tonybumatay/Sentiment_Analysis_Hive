--DROP TABLE IF EXISTS positive_words;
--CREATE TABLE postive_words (word STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n';
-- go into the command line and add the data to the table 
-- $hadoop fs -put /home/training/cse427s_fl16/final_project/text/pos-words.txt /user/hive/warehouse/postive_words
ALTER TABLE postive_words ADD COLUMNS (count INT);
DROP TABLE IF EXISTS positive; 
CREATE TABLE positive (rating String, count int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE positive SELECT word, 1 FROM postive_words;

--DROP TABLE IF EXISTS negative_words;
--CREATE TABLE negative_words (word STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n';
-- go into the command line and add the data to the table 
-- $hadoop fs -put /home/training/cse427s_fl16/final_project/text/neg-words.txt /user/hive/warehouse/negative_words
ALTER TABLE negative_words ADD COLUMNS (count INT);
DROP TABLE IF EXISTS negative; 
CREATE TABLE negative (rating String, count int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE negative SELECT word, -1 FROM negative_words;

