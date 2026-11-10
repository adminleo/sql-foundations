-- =============================================================================
-- 04 — Aggregates in context
-- =============================================================================
USE publications;

-- 1. From how many different states are our authors?
SELECT COUNT(DISTINCT state) AS n_states FROM authors;

-- 2. How many publishers are based in the USA?
--    COUNT(*) with a WHERE, not COUNT(DISTINCT country) — the question asks
--    how many publishers, not how many countries are represented.
SELECT COUNT(*) AS publishers_usa FROM publishers
WHERE country = 'USA';

-- 3. Average quantity sold per sale by store 7131
--    The column is stor_id, not store_id, and the filter belongs in WHERE,
--    never inside the aggregate.
SELECT AVG(qty) AS avg_qty FROM sales
WHERE stor_id = '7131';

-- 4. When was the employee with the highest level hired?
--    MAX() returns the value, not the row. For the row, sort and take the top.
SELECT fname, lname, job_lvl, hire_date FROM employee
ORDER BY job_lvl DESC
LIMIT 1;

-- 5. Average price of psychology books
SELECT AVG(price) AS avg_psychology FROM titles
WHERE type = 'psychology';

-- 6. business vs popular_comp by year-to-date sales
SELECT SUM(ytd_sales) AS business FROM titles WHERE type = 'business';
SELECT SUM(ytd_sales) AS popular_comp FROM titles WHERE type = 'popular_comp';

-- 7. Title and price of the most expensive book
SELECT title, price FROM titles
ORDER BY price DESC
LIMIT 1;

-- 8. Price of the most expensive psychology book
SELECT MAX(price) AS max_psychology FROM titles
WHERE type = 'psychology';

-- 9. Authors living in San Jose or Salt Lake City
SELECT COUNT(*) AS n FROM authors
WHERE city IN ('San Jose', 'Salt Lake City');
