-- =============================================================================
-- 10 — CASE
--
-- CASE evaluates its branches top to bottom and stops at the first match,
-- which is why the lower bound never has to be repeated.
-- =============================================================================
USE publications;

-- 1. Everything from sales, plus a sales_category column
SELECT *,
       CASE
           WHEN qty >= 50 THEN 'high sales'
           WHEN qty >= 20 THEN 'medium sales'
           ELSE 'low sales'
       END AS sales_category
FROM sales;

-- 2. Total books sold per category
--    MySQL allows GROUP BY on the alias; strict SQL would need the full CASE
--    repeated in the GROUP BY clause.
SELECT CASE
           WHEN qty >= 50 THEN 'high sales'
           WHEN qty >= 20 THEN 'medium sales'
           ELSE 'low sales'
       END AS sales_category,
       SUM(qty) AS total_qty
FROM sales
GROUP BY sales_category;

-- 3. Only categories above 100 units, descending
SELECT CASE
           WHEN qty >= 50 THEN 'high sales'
           WHEN qty >= 20 THEN 'medium sales'
           ELSE 'low sales'
       END AS sales_category,
       SUM(qty) AS total_qty
FROM sales
GROUP BY sales_category
HAVING SUM(qty) > 100
ORDER BY total_qty DESC;

-- 4. Average price per publisher for three book types, with a price band
--    CASE can wrap an aggregate: here it classifies AVG(price), a value that
--    only exists after grouping. Classify the raw average, not the rounded
--    one — the two can disagree at a boundary.
SELECT pub_id,
       ROUND(AVG(price)) AS avg_price,
       CASE
           WHEN AVG(price) <= 5  THEN 'super low'
           WHEN AVG(price) <= 10 THEN 'low'
           WHEN AVG(price) <= 15 THEN 'medium'
           ELSE 'high'
       END AS price_category
FROM titles
WHERE type IN ('business', 'trad_cook', 'psychology')
GROUP BY pub_id;
