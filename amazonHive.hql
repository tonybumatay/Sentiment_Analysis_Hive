
add jar s3://elasticmapreduce/samples/hive-ads/libs/jsonserde.jar;

drop table if exists amazon_data; 
create external table amazon_data(reviewerID STRING, reviewText STRING, overall DOUBLE) ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.JsonSerde' LOCATION 's3://cse427finalprojectdata/Automotive_5.json';


-- Doing positive and negative words stuff
DROP TABLE IF EXISTS postive_words;
CREATE  EXTERNAL TABLE postive_words (word STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n' LOCATION 's3://cse427finalprojectdata/pos-words.txt';

DROP TABLE IF EXISTS positive;
CREATE TABLE positive (rating String, count int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ;
INSERT OVERWRITE TABLE positive SELECT word, 1 FROM postive_words;

DROP TABLE IF EXISTS negative_words;
CREATE EXTERNAL TABLE negative_words (word STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n' LOCATION 's3://cse427finalprojectdata/neg-words.txt';

DROP TABLE IF EXISTS negative; 
CREATE TABLE negative (rating String, count int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE negative SELECT word, -1 FROM negative_words;

DROP TABLE IF EXISTS all_words; 
CREATE TABLE all_words AS SELECT rating, count FROM positive UNION ALL SELECT rating, count FROM negative;


--Back to reviews stuff
ADD JAR s3://cse427finalprojectdata/filteringStop.jar; 
CREATE TEMPORARY FUNCTION filter_amazon_data AS 'stubs.stopwords';
DROP TABLE IF EXISTS filter_amazon_data; 
CREATE TABLE filter_amazon_data (reviewerID STRING, reviewText STRING, overall STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE filter_amazon_data SELECT reviewerID, filter_amazon_data(reviewText), overall  FROM amazon_data;

DROP TABLE IF EXISTS amazon_hw_reviews;
CREATE TABLE amazon_hw_reviews AS SELECT reviewerid AS reviewerid, SPLIT(reviewtext, ' ') AS reviewtext, overall AS overall, row_number() OVER() as row_num FROM filter_amazon_data WHERE filter_amazon_data.reviewtext is not NULL;

DROP TABLE IF EXISTS amazon_explodedReviews;
CREATE TABLE amazon_explodedReviews AS SELECT row_num as row_num, reviewerid AS reviewerid, overall AS overall, review_word FROM amazon_hw_reviews LATERAL VIEW EXPLODE(reviewtext) r AS review_word;

DROP TABLE IF EXISTS amazon_word_join; 

CREATE TABLE amazon_word_join AS SELECT amazon_explodedReviews.row_num, amazon_explodedReviews.reviewerid, amazon_explodedReviews.overall, amazon_explodedReviews.review_word, all_words.count FROM amazon_explodedReviews JOIN all_words ON (amazon_explodedReviews.review_word = all_words.rating);


DROP TABLE IF EXISTS amazon_grouped_by_person; 

CREATE TABLE amazon_grouped_by_person AS SELECT row_num AS row_num, reviewerid AS reviewerid, overall AS overall, SUM(count) AS summation FROM amazon_word_join GROUP BY amazon_word_join.row_num, amazon_word_join.reviewerid, amazon_word_join.overall;

DROP TABLE IF EXISTS amazon_accuracy; 
CREATE TABLE amazon_accuracy AS SELECT row_num as row_num, reviewerid AS reviewerid, overall AS overall from amazon_grouped_by_person WHERE ((overall == 5 AND summation > 2) OR (overall == 4 AND summation > 0 AND summation < 2) OR (overall == 3 AND summation == 0) OR (overall == 2 AND summation < 0 AND summation > -2) OR (overall == 1 AND summation < 2));
SELECT count(*) FROM amazon_accuracy;
SELECT count(*) FROM amazon_grouped_by_person;
