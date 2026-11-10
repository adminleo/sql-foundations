-- =============================================================================
-- 09 — Table aliases and JOINs
--
-- INNER keeps only rows matching on both sides. LEFT keeps every row from the
-- left table and fills NULL where the right side has no match.
-- =============================================================================
USE publications;

-- 1. Alias the sales table
--    Once a table has an alias you must use it, not the original name.
SELECT s.ord_num FROM sales AS s;

-- 2. Title and publisher name of all books
SELECT t.title, p.pub_name
FROM titles AS t
INNER JOIN publishers AS p ON t.pub_id = p.pub_id;

-- 3. Order number, quantity and book title for all sales
SELECT s.ord_num, s.qty, t.title
FROM sales AS s
INNER JOIN titles AS t ON s.title_id = t.title_id;

-- 4. Full name of all employees and their publisher
SELECT CONCAT(e.fname, ' ', e.lname) AS full_name, p.pub_name
FROM employee AS e
INNER JOIN publishers AS p ON e.pub_id = p.pub_id;

-- 5. Full name and job description of all employees
SELECT CONCAT(e.fname, ' ', e.lname) AS full_name, j.job_desc
FROM employee AS e
INNER JOIN jobs AS j ON e.job_id = j.job_id;

-- 6. Full name, job description and publisher — three tables, two joins
SELECT CONCAT(e.fname, ' ', e.lname) AS full_name, j.job_desc, p.pub_name
FROM employee AS e
INNER JOIN jobs AS j       ON e.job_id = j.job_id
INNER JOIN publishers AS p ON e.pub_id = p.pub_id;

-- 7. Same, restricted to Binnet & Hardley
SELECT CONCAT(e.fname, ' ', e.lname) AS full_name, j.job_desc, p.pub_name
FROM employee AS e
INNER JOIN jobs AS j       ON e.job_id = j.job_id
INNER JOIN publishers AS p ON e.pub_id = p.pub_id
WHERE p.pub_name = 'Binnet & Hardley';

-- 8. Name and PR info of publishers based in Berkeley, California
SELECT p.pub_name, i.pr_info
FROM publishers AS p
INNER JOIN pub_info AS i ON p.pub_id = i.pub_id
WHERE p.city = 'Berkeley' AND p.state = 'CA';

-- 9. All columns from discounts — note the NULLs
--    Only one of the three discounts is tied to a store; the other two are
--    global rules with stor_id = NULL.
SELECT * FROM discounts;

-- 10. Every store with its discount, store id from both tables
--     The left column is always filled, the right one is NULL where no match
--     existed. The two global discounts never appear at all, because their
--     stor_id is NULL and NULL never equals anything.
SELECT s.stor_name, s.stor_id AS store_side, d.stor_id AS discount_side, d.discount
FROM stores AS s
LEFT JOIN discounts AS d ON s.stor_id = d.stor_id;

-- 11. Only stores that actually offer a discount
--     Switching LEFT to INNER removes exactly the NULL-filled rows.
SELECT s.stor_name, d.discount
FROM stores AS s
INNER JOIN discounts AS d ON s.stor_id = d.stor_id;
