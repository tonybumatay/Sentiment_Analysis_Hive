
-- get our_data into hive as our data
DROP TABLE IF EXISTS our_filtered_data; 
CREATE TABLE our_filtered_data (hw_number STRING, label STRING, review STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
INSERT OVERWRITE TABLE our_filtered_data SELECT hw_number, label, filter_stop(review) FROM our_data;

DROP TABLE IF EXISTS our_hw_reviews;


CREATE TABLE our_hw_reviews AS SELECT hw_number AS hw_number, label AS label, SPLIT(review, ' ') AS review, row_number() OVER() as id FROM our_filtered_data WHERE our_filtered_data.review is not NULL;

DROP TABLE IF EXISTS our_explodedReviews;
CREATE TABLE our_explodedReviews AS SELECT id AS id, hw_number AS hw_number, label AS label, reviews FROM our_hw_reviews LATERAL VIEW EXPLODE(review) r AS reviews;
DROP TABLE IF EXISTS our_word_join; 
CREATE TABLE our_word_join AS SELECT our_explodedReviews.id, our_explodedReviews.hw_number, our_explodedReviews.label, our_explodedReviews.reviews, all_words.count FROM our_explodedReviews LEFT OUTER JOIN all_words ON (our_explodedReviews.reviews = all_words.rating);
DROP TABLE IF EXISTS our_grouped_by_person; 
CREATE TABLE our_grouped_by_person AS SELECT hw_number AS hw_number, id AS id, label AS label, SUM(count) AS summation FROM our_word_join GROUP BY our_word_join.id, our_word_join.hw_number, our_word_join.label;
DROP TABLE IF EXISTS our_accuracy; 
CREATE TABLE our_accuracy AS SELECT label as label, hw_number AS hw_number, id AS id from our_grouped_by_person WHERE ((label == 'positive' AND summation > 0) OR (label == 'negative' AND summation < 0) OR (label == 'neutral' AND summation == 0));
SELECT count(*) FROM our_accuracy;
SELECT count(*) FROM our_grouped_by_person;

