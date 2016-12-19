DROP TABLE IF EXISTS sp_split_hw_reviews;

-- run preprocessing on SPRING labeled data only and call table filtered_spring_data
CREATE TABLE sp_split_hw_reviews AS SELECT hw_number AS hw_number, label AS label, SPLIT(review, ' ') AS review, row_number() Over() as id FROM filtered_spring_data;

DROP TABLE IF EXISTS sp_explodedReviews
CREATE TABLE sp_explodedReviews AS SELECT id AS id, hw_number AS hw_number, label AS label, reviews FROM sp_split_hw_reviews LATERAL VIEW EXPLODE(review) r AS reviews;
DROP TABLE IF EXISTS sp_word_join; 
CREATE TABLE sp_word_join AS SELECT sp_explodedReviews.id, sp_explodedReviews.hw_number, sp_explodedReviews.label, sp_explodedReviews.reviews, all_words.count FROM sp_explodedReviews LEFT OUTER JOIN all_words ON (sp_explodedReviews.reviews = all_words.rating);
DROP TABLE IF EXISTS sp_grouped_by_person1; 
CREATE TABLE sp_grouped_by_person1 AS SELECT hw_number AS hw_number, id AS id, label AS label,  SUM(count) AS summation FROM sp_word_join GROUP BY sp_word_join.id, sp_word_join.hw_number, sp_word_join.label;
DROP TABLE IF EXISTS accuracy; 
CREATE TABLE accuracy AS SELECT label as label, hw_number AS hw_number, id AS id from sp_word_join WHERE ((label == 'positive' AND summation > 0) OR (label == 'negative' AND summation < 0) OR (label == 'neutral' AND summation = 0));
SELECT * FROM accuracy;
SELECT count(*) FROM sp_grouped_by_person1;
