-- =============================================================================
-- 06 — IN and BETWEEN
-- =============================================================================
USE publications;

-- 1. Stores in California or Oregon
SELECT stor_name, state FROM stores
WHERE state IN ('CA', 'OR');

-- 2. Titles of type psychology, mod_cook or trad_cook
SELECT title, type FROM titles
WHERE type IN ('psychology', 'mod_cook', 'trad_cook');

-- 3. Authors not from Salt Lake City, Ann Arbor or Oakland
--    NOT IN silently drops rows where the column is NULL, because NULL is
--    neither in nor not in the list. Not an issue here, but worth knowing.
SELECT * FROM authors
WHERE city NOT IN ('Salt Lake City', 'Ann Arbor', 'Oakland');

-- 4. Orders with a quantity between 25 and 45
--    BETWEEN is inclusive on both ends.
SELECT ord_num, qty FROM sales
WHERE qty BETWEEN 25 AND 45;

-- 5. Orders between 1993-03-11 and 1994-09-13
--    ord_date is a DATETIME, so '1994-09-13' becomes midnight on that day.
--    Every order here has a 00:00:00 time, so the boundary day is included —
--    but an order placed at 14:30 on the closing date would be silently lost.
--    The robust form is the half-open interval below.
SELECT ord_num, ord_date FROM sales
WHERE ord_date BETWEEN '1993-03-11' AND '1994-09-13';

SELECT ord_num, ord_date FROM sales
WHERE ord_date >= '1993-03-11' AND ord_date < '1994-09-14';

-- 6. Job descriptions with a max_lvl between 150 and 200
SELECT job_desc, max_lvl FROM jobs
WHERE max_lvl BETWEEN 150 AND 200;
