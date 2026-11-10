-- =============================================================================
-- 08 — Everything so far, combined
-- =============================================================================
USE publications;

-- 1. Top 5 orders by quantity between 1993-03-11 and 1994-09-13
SELECT ord_num, qty, ord_date FROM sales
WHERE ord_date BETWEEN '1993-03-11' AND '1994-09-13'
ORDER BY qty DESC
LIMIT 5;

-- 2. Authors with an "i" in their first name, from Utah, Maryland or Kansas
SELECT COUNT(*) AS n FROM authors
WHERE au_fname LIKE '%i%' AND state IN ('UT', 'MD', 'KS');

-- 3. California cities containing an "o", more than one author, ascending
--    All three filter stages in one query: WHERE before grouping,
--    HAVING after.
SELECT city, COUNT(*) AS authors FROM authors
WHERE state = 'CA' AND city LIKE '%o%'
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY authors ASC;
