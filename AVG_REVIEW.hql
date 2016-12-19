DROP TABLE IF EXISTS split_reivew;
CREATE TABLE split_review AS SELECT rank AS rank, hw_number AS hw_number, label AS label, split(review, ' ') AS review FROM hw_data;
DROP TABLE IF EXISTS word_join;
CREATE TABLE word_join AS SELECT exploded.rank, exploded.hw_number, exploded.label, exploded.reviews, positive.count FROM exploded OUTER JOIN positive ON(exploded.reviews = positive.rating);
DROP TABLE IF EXISTS grouped_by_person; 
CREATE TABLE grouped_by_person AS SELECT hw_number AS hw_number, rank AS rank, count(count) AS count from word_join_positive_withrow GROUP BY word_join_positive_withrow.rank, word_join_positive_withrow.hw_number ;
SELECT hw_number, AVG(count) AS count FROM grouped_by_person GROUP BY grouped_by_person.hw_number ORDER BY COUNT;
