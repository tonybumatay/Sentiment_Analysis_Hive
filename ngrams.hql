DROP TABLE IF EXISTS total_ngrams2; 
CREATE TABLE total_ngrams2 (NEW_ITEM ARRAY<STRUCT<ngram:array<string>, estfrequency:double>>);
INSERT OVERWRITE TABLE total_ngrams2 SELECT context_ngrams(sentences(review), array(null, null), 1000) AS snippet FROM filtered_data;
DROP TABLE IF EXISTS review_data_2gram; 
CREATE TABLE review_data_2gram (term1 String, term2 String, estfrequency double);
INSERT OVERWRITE TABLE review_data_2gram SELECT X.ngram[0],X.ngram[1] X.estfrequency FROM (SELECT EXPLODE(new_item) AS X FROM total_ngrams2 Z;


DROP TABLE IF EXISTS total_ngrams3; 
CREATE TABLE total_ngrams3 (NEW_ITEM ARRAY<STRUCT<ngram:array<string>, estfrequency:double>>);
INSERT OVERWRITE TABLE total_ngrams3 SELECT context_ngrams(sentences(review), array(null, null, null), 1000) AS snippet FROM filtered_data;
DROP TABLE IF EXISTS review_data_3gram; 
CREATE TABLE review_data_3gram (term1 String, term2 String, term3 String, estfrequency double);
INSERT OVERWRITE TABLE review_data_3gram SELECT X.ngram[0],X.ngram[1], X.ngram[2], X.estfrequency FROM (SELECT EXPLODE(new_item) AS X FROM total_ngrams3) Z;
