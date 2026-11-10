-- =============================================================================
-- 01 — SELECT, AS, DISTINCT
-- =============================================================================
USE publications;

-- 1. Select everything from the table authors
SELECT * FROM authors;

-- 2. Select everything from titles, titleauthor, publishers and sales
SELECT * FROM titles;
SELECT * FROM titleauthor;
SELECT * FROM publishers;
SELECT * FROM sales;

-- 3. Select the authors first and last name
SELECT au_fname, au_lname FROM authors;

-- 4. Select the publisher names
SELECT pub_name FROM publishers;

-- 5. Select the title, price and year-to-date sales of all titles
SELECT title, price, ytd_sales FROM titles;

-- 6. Authors' first names, column displayed as "first_name"
SELECT au_fname AS first_name FROM authors;

-- 7. Job id and description, displayed as "id" and "description"
SELECT job_id AS id, job_desc AS description FROM jobs;

-- 8. All unique last names of authors
SELECT DISTINCT au_lname FROM authors;

-- 9. All unique title ids that were involved in a sale
--    DISTINCT matters here: 21 sales rows collapse to 16 distinct titles,
--    because one title can appear in several orders.
SELECT DISTINCT title_id FROM sales;
