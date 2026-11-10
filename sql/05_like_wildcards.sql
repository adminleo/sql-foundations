-- =============================================================================
-- 05 — LIKE and wildcards (% and _)
-- =============================================================================
USE publications;

-- 1. Books containing the word "cooking" in the title
--    MySQL's default collation is case-insensitive, so this also finds "Cooking".
SELECT * FROM titles
WHERE title LIKE '%cooking%';

-- 2. Titles starting with "The"
--    'The %' with a space is stricter if you mean the standalone word.
SELECT * FROM titles
WHERE title LIKE 'The%';

-- 3. Full names of authors whose last name starts with "S"
SELECT au_fname, au_lname FROM authors
WHERE au_lname LIKE 'S%';

-- 4. Stores on an Avenue
SELECT stor_name, stor_address FROM stores
WHERE stor_address LIKE '%Ave.';

-- 5. Stores on an Avenue or a Street
--    Each side of OR needs a complete condition of its own.
SELECT stor_name, stor_address FROM stores
WHERE stor_address LIKE '%Ave.' OR stor_address LIKE '%St.';

-- 6. Female employees
--    The gender marker is the last character of emp_id: PMA42628M, AMD15433F.
SELECT * FROM employee
WHERE emp_id LIKE '%F';

-- 7. Male employees whose first name starts with "P"
SELECT fname, lname FROM employee
WHERE emp_id LIKE '%M' AND fname LIKE 'P%';

-- 8. Titles with "ing" preceded by at least 4 characters
--    Four underscores = exactly four characters; the leading % allows anything
--    before them, so four is the guaranteed minimum.
SELECT * FROM titles
WHERE title LIKE '%____ing%';
