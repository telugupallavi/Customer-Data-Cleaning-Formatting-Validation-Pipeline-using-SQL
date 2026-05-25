-- =====================================================
-- PROJECT: CUSTOMER DATA CLEANING & VALIDATION PIPELINE
-- =====================================================

-- =====================================================
-- STEP 1 : CREATE DATABASE
-- =====================================================

CREATE DATABASE sql_project;

USE sql_project;

-- =====================================================
-- STEP 2 : IMPORT CSV FILE INTO MYSQL WORKBENCH
-- =====================================================

/*
1. Open MySQL Workbench
2. Select the created database
3. Right click on the schema
4. Choose "Table Data Import Wizard"
5. Browse and select the CSV file
6. Create a new table named customers
7. Complete the import process
*/

-- =====================================================
-- STEP 3 : VIEW RAW DATA
-- =====================================================

SELECT * FROM customers;

-- =====================================================
-- STEP 4 : STANDARDIZE TEXT CASE
-- =====================================================

UPDATE customers
SET
    full_name = UPPER(full_name),
    city = UPPER(city),
    email = LOWER(email),
    username = LOWER(username),
    comments = UPPER(comments);

-- =====================================================
-- STEP 5 : REMOVE SPECIAL CHARACTERS
-- =====================================================

UPDATE customers
SET
    username = REGEXP_REPLACE(username, '[^a-zA-Z0-9]', ''),
    full_name = REGEXP_REPLACE(full_name, '[^a-zA-Z0-9 ]', '');

-- =====================================================
-- STEP 6 : STANDARDIZE PHONE NUMBERS
-- =====================================================

UPDATE customers
SET
    phone = REGEXP_REPLACE(phone, '[^0-9]', '');

-- =====================================================
-- STEP 7 : VALIDATE EMAIL ADDRESSES
-- =====================================================

SELECT *
FROM customers
WHERE email NOT LIKE '%@%.%';

-- =====================================================
-- STEP 8 : PHONE NUMBER VALIDATION
-- =====================================================

SELECT *
FROM customers
WHERE LENGTH(phone) <> 10;

-- =====================================================
-- STEP 9 : CHECK MISSING VALUES
-- =====================================================

SELECT *
FROM customers
WHERE full_name IS NULL
   OR full_name = ''
   OR city IS NULL
   OR city = ''
   OR email IS NULL
   OR email = '';

-- =====================================================
-- STEP 10 : DETECT DUPLICATE RECORDS
-- =====================================================

SELECT
    phone,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY phone
HAVING COUNT(*) > 1;

-- =====================================================
-- STEP 11 : CREATE FINAL CLEAN TABLE
-- =====================================================

CREATE TABLE final_customers AS
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT MIN(customer_id)
    FROM customers
    GROUP BY phone
)
ORDER BY customer_id ASC;

-- =====================================================
-- STEP 12 : VIEW FINAL CLEAN DATA
-- =====================================================

SELECT * FROM final_customers;

-- =====================================================
-- STEP 13 : ENABLE SAFE UPDATE MODE AGAIN
-- =====================================================

SET SQL_SAFE_UPDATES = 1;
