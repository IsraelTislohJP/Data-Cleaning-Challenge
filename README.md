# Data Cleaning Challenge using R
### Overview

This repository showcases a data cleaning challenge I completed using R. The project focuses on transforming raw, messy data into a clean, well-structured dataset ready for analysis workflows. It includes detailed steps for handling missing values, inconsistencies, and more.

### Features
- Identified and resolved missing values using imputation techniques.
- Standardized column names and formats for consistency.
- Converted data types to ensure compatibility with analysis tools.
- Generated a clean, analysis-ready dataset for downstream tasks.

### Dataset
- Source: This dataset is gotten from GreenData Solutions and contains patients health records.
- Size: The dataset includes 1,659 rows and 12 columns.
- Type: The data is in CSV format and contains both numerical and categorical variables.

### Tools and Libraries Used
##### R Packages:
        - tidyverse: For data manipulation and visualization.
        - tools: For code and text processing
        - skimr: For descriptive statistics
        - randomForest
        - nnet
        - caret
 
### Steps Taken 
- Load libraries and read the dataset
- Descriptive Statistics: Used the skim() function to get an overview of the dataset. Identified issues like missing values, empty cells, incorrect data types, and inconsistencies.
- Data Cleaning:
   - General Cleaning:
     - Replaced all empty cells ("") with NA.
     - Checked the number of missing values in each column.
  - Column-Specific Cleaning:
     - Name: Standardized names to proper title case using toTitleCase()
     - Age: Replaced "Unknown" with NA. Converted the column to numeric.
     - Gender: Standardized values to Male and Female based on patterns (^m for male and ^f for female). Left ambiguous values unchanged.
     - City: Corrected common misspellings for cities like Albuquerque, Baltimore, and Atlanta using pattern matching.
     - Education: Standardized values to categories such as Bachelors and High School using pattern matching.
     - Employment: Standardized employment categories (e.g., Employed, Freelance, Retired) using case_when().
     - Salary: Removed unwanted text after the salary value. Converted negative salary values (from parentheses) to proper negative numbers. Converted the column to numeric         after removing $ and ,.
     - Credit Score: Removed unwanted text after the score. Replaced invalid entries (e.g., starting with "n") with NA. Converted the column to numeric.
     - Admission Date: Removed rows with non-date entries. Reformatted the column to Date type using ymd().

### Handling Missing Values:
- Removed the Gender column due to a high proportion of missing values.
- For numeric columns, replaced missing values with the column median.
- For character columns, replaced missing values with the modal value (most frequent category).

### Final Dataset:
- Removed rows with missing values in the Date of Admission column.
- Performed a final descriptive analysis using skim().

### Logic Behind Each Decision
- Empty Cells → NA:
  - Consistency: Makes it easier to identify and handle missing data programmatically.
- Descriptive Analysis:
  - Provided a quick snapshot of data issues (e.g., missing values, data types, inconsistencies).
- Column-Specific Cleaning:
  - Name: Ensures names are consistently formatted for readability.
  - Age: Unknown is replaced with NA because it cannot be converted to a numeric type. Missing values are later imputed with the median.
  - Gender: Simplifies gender values into standard categories (Male, Female) for analysis.
  - City: Corrects common misspellings to ensure consistency in geographic data.
  - Education & Employment: Groups similar entries into standardized categories for easier aggregation and analysis.
  - Salary: Removed extraneous characters and formatted as numeric for mathematical operations.
  - Credit Score: Eliminated invalid entries and converted to numeric for numerical analysis.
  - Admission Date: Removed invalid date entries and reformatted the column for date-based operations.

### Assumptions Made
- Empty cells indicate missing values: Assumed empty strings ("") in the dataset are equivalent to missing data.
- Gender Standardization: Assumed that entries starting with m or f represent Male or Female respectively.
- City Names: Assumed partial matches like Al → Albuquerque, Ba → Baltimore, and At → Atlanta.
- Education Categories: Assumed patterns like ^bach and ^hig correspond to Bachelors and High School.
- Employment Categories: Assumed text like ^emp → Employed, ^unem → Unemployed, etc., based on prefix matches.
- Salary Formatting: Assumed that values in parentheses represented negative salaries and removed extraneous characters ($, ,).
- Credit Score: Assumed that entries starting with n are invalid and replaced them with NA.
- Admission Date: Assumed rows with non-date entries in the Admission Date column are invalid and removed them.
- Imputation: For numeric columns: Replaced missing values with the median to minimize the effect of outliers.
- For character columns: Replaced missing values with the most frequent value (mode).
- Removing Gender: Assumed that imputing missing values for Gender would lead to inaccuracies due to its high proportion of NA.

### Output
- The cleaned dataset is saved as clean_health.csv.
- All inconsistencies were resolved, and the dataset is ready for analysis.
