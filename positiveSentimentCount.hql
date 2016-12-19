DROP TABLE IF EXISTS split_hw_reviews; 
CREATE TABLE split_hw_reviews AS SELECT hw_number AS hw_number, label AS label, SPLIT(review, ‘ ‘) AS review FROM hw_data;
DROP TABLE IF EXISTS explodedReviews; 
CREATE TABLE explodedReviews AS SELECT hw_number AS hw_number, label AS label, reviews FROM hw_word LATERAL VIEW EXPLODE(review) r AS reviews;
DROP TABLE IF EXISTS review_join; 
CREATE TABLE review_join AS SELECT explodedreviews.hw_number, explodedreviews.label, explodedreviews.reviews, positive.count FROM explodedreviews LEFT OUTER JOIN positive ON(explodedreviews.reviews = positive.rating);
SELECT hw_number, COUNT(count) AS sentiment FROM review_join GROUP BY word_join.hw_number ORDER BY sentiment DESC;
