-- =============================================================================
-- 07 — GROUP BY and HAVING
--
-- Execution order is the key to this file:
--   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT
-- WHERE filters rows before grouping; HAVING filters groups after aggregating.
-- =============================================================================
USE publications;

-- 1. Authors per state
SELECT state, COUNT(*) AS n_authors FROM authors
GROUP BY state;

-- 2. Same, descending
--    ORDER BY can use the alias because it runs after SELECT; WHERE cannot.
SELECT state, COUNT(*) AS n_authors FROM authors
GROUP BY state
ORDER BY n_authors DESC;

-- 3. Most expensive title per publisher
--    Only publishers that actually have titles appear — GROUP BY can only
--    build groups from rows that exist. The rest need a LEFT JOIN.
SELECT pub_id, MAX(price) AS most_expensive FROM titles
GROUP BY pub_id;

-- 4. Top 3 stores by units sold
SELECT stor_id, SUM(qty) AS units_sold FROM sales
GROUP BY stor_id
ORDER BY units_sold DESC
LIMIT 3;

-- 5. Average job level per job_id, ascending
SELECT job_id, AVG(job_lvl) AS avg_level FROM employee
GROUP BY job_id
ORDER BY avg_level ASC;

-- 6. Books per type and publisher
SELECT type, pub_id, COUNT(*) AS books FROM titles
GROUP BY type, pub_id;

-- 7. Add the average price
--    Watch popular_comp: COUNT(*) is 3 but the average divides by 2, because
--    one title has a NULL price and AVG skips NULLs rather than treating them
--    as zero. COUNT(*) and AVG(col) can run over different numbers of rows.
SELECT type, pub_id, COUNT(*) AS books, AVG(price) AS avg_price FROM titles
GROUP BY type, pub_id;

-- 8. Only combinations with an average price above 12
--    The UNDECIDED group drops out too: NULL > 12 is NULL, not TRUE.
SELECT type, pub_id, COUNT(*) AS books, AVG(price) AS avg_price FROM titles
GROUP BY type, pub_id
HAVING AVG(price) > 12;

-- 9. Ordered by count, then average price
SELECT type, pub_id, COUNT(*) AS books, AVG(price) AS avg_price FROM titles
GROUP BY type, pub_id
HAVING AVG(price) > 12
ORDER BY books DESC, avg_price DESC;

-- 10. States and cities with 2 or more contracts
--     contract is a 0/1 flag, so SUM counts the contracts while COUNT(*)
--     would count every author.
SELECT state, city, SUM(contract) AS contracts FROM authors
GROUP BY state, city
HAVING SUM(contract) >= 2;

--     Same answer, filtering rows first instead — a clean WHERE/HAVING contrast.
SELECT state, city, COUNT(*) AS contracts FROM authors
WHERE contract = 1
GROUP BY state, city
HAVING COUNT(*) >= 2;
