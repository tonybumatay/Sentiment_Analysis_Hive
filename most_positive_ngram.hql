DROP TABLE IF EXISTS 2gram_joined;
CREATE TABLE 2gram_joined AS SELECT review_data_2gram.term1, review_data_2gram.term2, review_data_2gram.estfrequency FROM review_data_2gram JOIN positive WHERE (review_data_2gram.term1 = positive.word OR review_data_2gram.term2 = positive.word);

SELECT * FROM 2gram_joined ORDER BY estfrequency DESC LIMIT 3;


DROP TABLE IF EXISTS 3gram_joined;
CREATE TABLE 3gram_joined AS SELECT review_data_3gram.term1, review_data_3gram.term2, review_data_3gram.term3, review_data_3gram.estfrequency FROM review_data_3gram JOIN positive WHERE (review_data_3gram.term1 = positive.word OR review_data_3gram.term2 = positive.word OR review_data_3gram.term3 = positive.word);

SELECT * FROM 2gram_joined ORDER BY estfrequency DESC LIMIT 3;
