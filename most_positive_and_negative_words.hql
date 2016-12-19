SELECT reviews, COUNT(count) AS negSentiment FROM review_join GRUP BY review_join.reviews ORDER BY negSentiment DESC LIMIT 5;
SELECT reviews,  COUNT(count) AS topN FROM negative GROUP BY negative.reviews ORDER BY topN DESC LIMIT 5;  
SELECT reviews,  COUNT(count) AS topN FROM positive GROUP BY positive.reviews ORDER BY topN DESC LIMIT 5; 

