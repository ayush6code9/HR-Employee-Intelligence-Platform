-- Q1: Overall hiring funnel conversion
SELECT
    COUNT(*) AS total_applicants,
    SUM(passed_screening) AS screened,
    SUM(passed_interview) AS interviewed,
    SUM(got_offer) AS offered,
    SUM(accepted_offer) AS joined,
    ROUND(100.0 * SUM(passed_screening) / COUNT(*), 1) AS screening_rate,
    ROUND(100.0 * SUM(passed_interview) / NULLIF(SUM(passed_screening), 0), 1) AS interview_rate,
    ROUND(100.0 * SUM(got_offer) / NULLIF(SUM(passed_interview), 0), 1) AS offer_rate,
    ROUND(100.0 * SUM(accepted_offer) / NULLIF(SUM(got_offer), 0), 1) AS acceptance_rate
FROM recruitment;

-- Q2: Time to hire by department
SELECT 
    department,
    ROUND(AVG(time_to_hire_days), 1) AS avg_days,
    MIN(time_to_hire_days) AS fastest,
    MAX(time_to_hire_days) AS slowest,
    COUNT(*) AS hires
FROM recruitment
WHERE accepted_offer = 1
GROUP BY department
ORDER BY avg_days DESC;

-- Q3: Best source of hire
SELECT 
    source,
    COUNT(*) AS applicants,
    SUM(accepted_offer) AS hires,
    ROUND(100.0 * SUM(accepted_offer) / COUNT(*), 1) AS hire_rate,
    ROUND(AVG(CASE WHEN accepted_offer = 1 THEN time_to_hire_days END), 1) AS avg_days_to_hire
FROM recruitment
GROUP BY source
ORDER BY hire_rate DESC;

-- Q4: Recruiter performance (window function)
SELECT 
    recruiter,
    COUNT(*) AS total_handled,
    SUM(accepted_offer) AS successful_hires,
    ROUND(AVG(time_to_hire_days), 1) AS avg_time_to_hire,
    RANK() OVER (ORDER BY SUM(accepted_offer) DESC) AS hire_rank,
    RANK() OVER (ORDER BY AVG(time_to_hire_days) ASC) AS speed_rank
FROM recruitment
WHERE accepted_offer = 1
GROUP BY recruiter;

-- Q5: Month-over-month application volume trend
SELECT 
    TO_CHAR(application_date, 'YYYY-MM') AS month,
    COUNT(*) AS applications,
    SUM(accepted_offer) AS hires,
    LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(application_date, 'YYYY-MM')) AS prev_month_applications,
    ROUND(100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(application_date, 'YYYY-MM')))
        / NULLIF(LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(application_date, 'YYYY-MM')), 0), 1) AS mom_growth_pct
FROM recruitment
GROUP BY TO_CHAR(application_date, 'YYYY-MM')
ORDER BY month;