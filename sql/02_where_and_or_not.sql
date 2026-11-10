-- =============================================================================
-- 02 — WHERE, AND / OR / NOT
-- =============================================================================
USE publications;

-- 1. Authors with the last name "Ringer"
SELECT au_fname, au_lname FROM authors
WHERE au_lname = 'Ringer';

-- 2. Order number and date of all orders where exactly 20 books were sold
SELECT ord_num, ord_date FROM sales
WHERE qty = 20;

-- 3. Authors named Anne Ringer
SELECT au_fname, au_lname FROM authors
WHERE au_lname = 'Ringer' AND au_fname = 'Anne';

-- 4. Publishers based in either Germany or France
SELECT pub_name, city FROM publishers
WHERE country = 'Germany' OR country = 'France';

-- 5. Authors named "Dean" living in Oakland or Berkeley
--    The parentheses are essential: without them AND binds tighter than OR,
--    so the query would return every author in Berkeley regardless of name.
SELECT au_fname, au_lname, city FROM authors
WHERE au_fname = 'Dean' AND (city = 'Oakland' OR city = 'Berkeley');

-- 6. Publishers not based in the USA
SELECT pub_name, city, country FROM publishers
WHERE country <> 'USA';

-- 7. Authors in Oakland or Berkeley whose last name is not "Straight"
SELECT au_fname, au_lname, city FROM authors
WHERE (city = 'Oakland' OR city = 'Berkeley') AND au_lname <> 'Straight';
