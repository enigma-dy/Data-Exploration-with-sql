SELECT COUNT(DISTINCT brand) as TotalMissingValue
FROM Project..brands
WHERE brand is NULL

Drop TABLE IF EXISTS #FullReport
CREATE TABLE #FullReport(
    product_id NVARCHAR(255),
    brand NVARCHAR(255),
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT,
    product_name TEXT,
    [description] TEXT,
    rating FLOAT,
    reviews INT,
    last_visited DATETIME
)
INSERT INTO #FullReport
SELECT B.product_id,brand,listing_price,sale_price,discount,revenue,product_name,[description],rating,reviews,last_visited
FROM Project..brands as B
Full JOIN Project..finance as F ON B.product_id = F.product_id
Full JOIN Project..info_v2 as I on b.product_id = I.product_id
Full JOIN Project..reviews as R on b.product_id = R.product_id
Full JOIN Project..traffic as T on b.product_id = T.product_id

SELECT top(10)*
From #FullReport



SELECT AVG(sale_price) as AveragePrice,brand
FROM #FullReport
Where brand is NOT NULL 
GROUP BY brand

SELECT brand,sale_price,
CASE
    WHEN sale_price > 183 THEN 'Expensive'
    ELSE  'Cheap'
END as LabelBaseOnPrice
from #FullReport

SELECT rating,reviews,[description]
FROM #FullReport
ORDER by Cast([description] as nvarchar(500)) DESC

SELECT MONTH(last_visited) as [MONTH], SUM(rating) as MonthlyRating,SUM(reviews) as MouthlyReview
from #FullReport
WHERE MONTH(last_visited) is not NULL
GROUP BY MONTH(last_visited)
ORDER BY 1

