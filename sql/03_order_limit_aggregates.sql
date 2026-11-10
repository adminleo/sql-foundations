-- =============================================================================
-- 03 — ORDER BY, LIMIT, MIN/MAX, COUNT/AVG/SUM
-- =============================================================================
USE publications;

-- 1. Title and ytd_sales, ordered by year-to-date sales
SELECT title, ytd_sales FROM titles
ORDER BY ytd_sales;

-- 2. Same, descending
--    NULLs sort last in MySQL under DESC — the two titles without a sales
--    figure end up at the bottom rather than the top.
SELECT title, ytd_sales FROM titles
ORDER BY ytd_sales DESC;

-- 3. Top 5 titles by ytd_sales
SELECT title, ytd_sales FROM titles
ORDER BY ytd_sales DESC
LIMIT 5;

-- 4. Maximum amount of books ever sold in a single order
SELECT MAX(qty) AS max_qty FROM sales;

-- 5. Price of the cheapest book
SELECT MIN(price) AS cheapest FROM titles;

-- 6. How many rows are there in the authors table
SELECT COUNT(*) AS n_authors FROM authors;

-- 7. Total year-to-date sales
--    SUM ignores NULLs rather than treating them as zero.
SELECT SUM(ytd_sales) AS total_ytd FROM titles;

-- 8. Average price of books
SELECT AVG(price) AS avg_price FROM titles;

-- 9. Count, average and sum of quantity, in one query
SELECT COUNT(qty) AS n, AVG(qty) AS avg_qty, SUM(qty) AS total_qty
FROM sales;
