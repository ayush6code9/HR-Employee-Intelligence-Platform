-- Q1: What is the overall attrition rate?
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM employees;

-- Q2: Attrition rate by department
SELECT 
    department,
    COUNT(*) AS total,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_company,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM employees
GROUP BY department
ORDER BY attrition_pct DESC;

-- Q3: Does overtime drive attrition?
SELECT 
    overtime,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    COUNT(*) AS total
FROM employees
GROUP BY overtime;

-- Q4: Salary band vs attrition (window function)
SELECT 
    CASE 
        WHEN monthly_income < 3000 THEN 'Low (<3K)'
        WHEN monthly_income BETWEEN 3000 AND 7000 THEN 'Mid (3K-7K)'
        WHEN monthly_income BETWEEN 7001 AND 15000 THEN 'High (7K-15K)'
        ELSE 'Very High (>15K)'
    END AS salary_band,
    COUNT(*) AS employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0) AS avg_salary
FROM employees
GROUP BY salary_band
ORDER BY attrition_pct DESC;

-- Q5: Top attrition risk profile (multi-factor)
SELECT 
    job_role,
    overtime,
    work_life_balance,
    COUNT(*) AS employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM employees
WHERE overtime = 'Yes' AND work_life_balance <= 2
GROUP BY job_role, overtime, work_life_balance
HAVING COUNT(*) >= 5
ORDER BY attrition_pct DESC;

-- Q6: Years at company vs attrition (window function - running total)
SELECT 
    years_at_company,
    COUNT(*) AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    SUM(COUNT(*)) OVER (ORDER BY years_at_company) AS running_total_employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM employees
GROUP BY years_at_company
ORDER BY years_at_company;

-- Q7: Job satisfaction vs attrition ranked
SELECT 
    job_satisfaction,
    job_role,
    COUNT(*) AS employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    RANK() OVER (PARTITION BY job_satisfaction ORDER BY COUNT(*) DESC) AS rank_within_satisfaction
FROM employees
GROUP BY job_satisfaction, job_role
ORDER BY job_satisfaction, attrition_pct DESC;