

# Customer Data Cleaning, Formatting & Validation Pipeline using SQL

## 1. Project Title

**Customer Data Cleaning, Formatting & Validation Pipeline using SQL**

---

## 2. Introduction

This project focuses on cleaning, formatting, and validating customer data using SQL queries in MySQL Workbench. The raw dataset contained inconsistent text formatting, unwanted spaces, special characters, invalid phone number formats, and duplicate records.

The objective of this project was to transform unstructured customer data into a clean, standardized, and analysis-ready dataset that can be used for reporting and business analytics.

---

## 3. Objectives

* Import CSV data into MySQL
* Clean inconsistent customer records
* Remove unwanted spaces and special characters
* Standardize text formatting
* Validate email addresses
* Format phone numbers
* Detect duplicate records
* Improve overall data quality

---

## 4. Tools & Technologies Used

* **MySQL Workbench**
* **SQL**
* **CSV Dataset**

---

## 5. Dataset Description

The dataset contains customer-related information such as:

* Customer ID
* Full Name
* Email
* Phone Number
* City
* Username
* Comments

### Initial Data Issues

The dataset initially contained:

* Mixed uppercase and lowercase text
* Extra spaces
* Special characters
* Invalid phone number formats
* Duplicate records
* Missing values

---

## 6. Steps Performed

### Step 1: Create Database

```sql
CREATE DATABASE sql_project;
USE sql_project;
```

**Purpose:**
Created a database to store customer records.

---

### Step 2: Import CSV File

#### Process:

1. Open MySQL Workbench
2. Select the schema
3. Use **Table Data Import Wizard**
4. Import the `customers.csv` file

**Purpose:**
Imported the raw customer dataset into MySQL.

---

### Step 3: View Raw Data

```sql
SELECT * FROM customers;
```

**Purpose:**
Verified imported records before cleaning.

---

### Step 4: Disable Safe Update Mode

```sql
SET SQL_SAFE_UPDATES = 0;
```

**Purpose:**
Allowed update operations on the table.

---

### Step 5: Remove Extra Spaces

```sql
UPDATE customers
SET
    full_name = TRIM(full_name),
    city = TRIM(city),
    email = TRIM(email);
```

**Purpose:**
Removed unnecessary leading and trailing spaces.

---

### Step 6: Standardize Text Case

```sql
UPDATE customers
SET
    full_name = UPPER(full_name),
    city = UPPER(city),
    email = LOWER(email),
    username = LOWER(username),
    comments = UPPER(comments);
```

**Purpose:**
Standardized text formatting across the dataset.

---

### Step 7: Remove Special Characters

```sql
UPDATE customers
SET
    username = REGEXP_REPLACE(username, '[^a-zA-Z0-9]', ''),
    full_name = REGEXP_REPLACE(full_name, '[^a-zA-Z0-9 ]', '');
```

**Purpose:**
Removed unwanted symbols and special characters.

---

### Step 8: Standardize Phone Numbers

```sql
UPDATE customers
SET
    phone = REGEXP_REPLACE(phone, '[^0-9]', '');
```

**Purpose:**
Converted phone numbers into a consistent numeric format.

---

### Step 9: Validate Email Addresses

```sql
SELECT *
FROM customers
WHERE email NOT LIKE '%@%.%';
```

**Purpose:**
Identified invalid email records.

---

### Step 10: Validate Phone Numbers

```sql
SELECT *
FROM customers
WHERE LENGTH(phone) <> 10;
```

**Purpose:**
Detected phone numbers with invalid lengths.

---

### Step 11: Check Missing Values

```sql
SELECT *
FROM customers
WHERE full_name IS NULL
   OR full_name = ''
   OR city IS NULL
   OR city = ''
   OR email IS NULL
   OR email = '';
```

**Purpose:**
Identified incomplete records.

---

### Step 12: Detect Duplicate Records

```sql
SELECT
    phone,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY phone
HAVING COUNT(*) > 1;
```

**Purpose:**
Detected duplicate customer entries.

---

### Step 13: Create Final Clean Table

```sql
CREATE TABLE final_customers AS
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT MIN(customer_id)
    FROM customers
    GROUP BY phone
)
ORDER BY customer_id ASC;
```

**Purpose:**
Created a final cleaned dataset after removing duplicates.

---

### Step 14: View Final Clean Data

```sql
SELECT * FROM final_customers;
```



**Purpose:**
Verified the cleaned and standardized dataset.

---

### Step 15: Enable Safe Update Mode Again

```sql
SET SQL_SAFE_UPDATES = 1;
```

**Purpose:**
Re-enabled MySQL safe update mode.

---

## 7. Results

After performing data cleaning and validation:

* Text fields became standardized
* Emails converted to lowercase
* Usernames cleaned successfully
* Phone numbers normalized
* Duplicate records identified
* Missing values detected
* Dataset became analysis-ready

---

## 8. Challenges Faced

* Handling inconsistent text formatting
* Writing regex expressions for cleaning
* Standardizing phone numbers
* Managing duplicate records
* Ensuring data consistency

---

## 9. Conclusion

This project successfully demonstrated how SQL can be used for real-world data cleaning and validation tasks. The final dataset became clean, accurate, consistent, and suitable for analytics and business reporting.

The project also improved practical knowledge of:

* SQL data cleaning techniques
* Regular expressions in SQL
* Data validation
* MySQL Workbench operations
* Database management concepts

---

## 10. Future Improvements

* Automate the cleaning pipeline using stored procedures
* Add advanced validation rules
* Integrate visualization dashboards
* Perform data quality scoring
