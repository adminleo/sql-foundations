-- =============================================================================
-- 11 — JOINs applied
-- =============================================================================
USE publications;

-- 1. In which cities has "Is Anger the Enemy?" been sold?
--    Two chained LEFT JOINs: title -> sales -> stores. A title with no sales
--    would still show up, with a NULL city.
SELECT t.title, st.city, s.qty
FROM titles AS t
LEFT JOIN sales  AS s  ON t.title_id = s.title_id
LEFT JOIN stores AS st ON s.stor_id  = st.stor_id
WHERE t.title = 'Is Anger the Enemy?';

-- 2. Book titles linked to employee Howard Snyder
--    The link is indirect: employee -> publisher -> titles. The publishers
--    table is only a bridge; no column of it is selected.
SELECT t.title
FROM employee AS e
INNER JOIN publishers AS p ON e.pub_id = p.pub_id
INNER JOIN titles     AS t ON t.pub_id = p.pub_id
WHERE e.fname = 'Howard' AND e.lname = 'Snyder';

-- 3. Book title with the highest number of sales
--    SUM, not MAX: the title sells across several orders and we want the total.
SELECT t.title, SUM(s.qty) AS total_sold
FROM sales AS s
INNER JOIN titles AS t ON s.title_id = t.title_id
GROUP BY t.title
ORDER BY total_sold DESC
LIMIT 1;

-- 4. All book titles and the full name of their author(s)
--    titleauthor is a junction table: it exists purely to express the
--    many-to-many relationship, so you always route through it with two joins.
--    Books with two authors appear twice, once per author.
SELECT t.title, CONCAT(a.au_fname, ' ', a.au_lname) AS author
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN authors     AS a  ON ta.au_id   = a.au_id;

-- 5. Full names of authors of psychology books
--    DISTINCT on the concatenated name, not on the last name: Anne and Albert
--    Ringer share a surname and both have to survive.
SELECT DISTINCT CONCAT(a.au_fname, ' ', a.au_lname) AS author
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN authors     AS a  ON ta.au_id   = a.au_id
WHERE t.type = 'psychology';

-- 6. Explore roysched
--    title_id, then the sales bracket (lorange to hirange), then the royalty
--    percentage paid within that bracket. One row per bracket, so a title_id
--    repeats — it is a tiered scale that rises with volume.
SELECT * FROM roysched WHERE title_id = 'BU1111';

-- 7. Maximum royalty per title, only titles present in roysched
--    INNER JOIN is what "only titles present in roysched" means; a LEFT JOIN
--    would return all 18 titles with NULL for the two that have no schedule.
SELECT t.title, MAX(r.royalty) AS max_royalty
FROM titles AS t
INNER JOIN roysched AS r ON t.title_id = r.title_id
GROUP BY t.title;
