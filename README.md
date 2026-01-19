# **Global COVID-19 Data Exploration & Insight Extraction Using SQL**

## **Project Overview**
COVID-19 reshaped public health, mobility, and economic activity worldwide. While dashboards provided fast reporting, fewer efforts focused on structured analytical exploration of pandemic data to understand geographic patterns, mortality ratios, and continent-level disparities.  
This project uses SQL to interrogate global COVID-19 data and extract quantitative insights around cases, deaths, and population-adjusted risk.


## **Purpose**
**Primary Goal:** Perform structured SQL-based exploratory analysis to quantify the scale, distribution, and severity of COVID-19 across countries and continents.

**Secondary Goal:** Translate raw epidemiological data into interpretable metrics such as mortality percentage, population-normalized case counts, and cross-region comparisons.


## **Technical Stack**
- **Microsoft SQL Server Management Studio (SSMS)**
- **SQL (CTEs, Joins, Aggregations, Window Functions)**
- **CSV Data Files (Our World in Data)**

## **Data Source**
Data sourced from **Our World in Data**, covering:
- Global daily cases and deaths
- Country and continent identifiers
- Population counts
- Reporting dates

**Coverage Period:** *1 January 2020 → 3 May 2023*


## **Analytical Narrative & Key Questions**

### **Analytical Questions**
The study was structured around epidemiological and socio-geographic questions such as:
1. What is the global scale of confirmed COVID-19 cases and deaths?
2. Which countries experienced the highest mortality burden?
3. How do cases compare after adjusting for population exposure?
4. Which continents saw the heaviest concentration of cases and deaths?
5. How severe was the pandemic when expressed as global death percentage?

These questions move from **total magnitude → proportional severity → comparative burden**.


## **SQL Approach & Methodology**

### **Data Exploration Techniques**
- **Aggregations:** Total cases & deaths at global and regional levels
- **Population Normalization:** Cases per population to identify true exposure severity
- **Grouping:** Country and continent-level comparisons
- **Window Functions:** Ranking countries by mortality and infection rates
- **Filtering:** Handling NULL reporting periods and incomplete regional data

SQL served as a powerful tool for **direct computation**, avoiding premature visualization bias and keeping analysis grounded in epidemiological metrics.

