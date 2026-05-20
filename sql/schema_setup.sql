DROP TABLE IF EXISTS recruitment CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

-- =====================================================
-- EMPLOYEES TABLE
-- =====================================================

CREATE TABLE employees (

    age INT,
    attrition VARCHAR(10),
    business_travel VARCHAR(50),
    daily_rate INT,
    department VARCHAR(50),
    distance_from_home INT,
    education INT,
    education_field VARCHAR(50),
    employee_count INT,
    employee_number INT PRIMARY KEY,
    environment_satisfaction INT,
    gender VARCHAR(20),
    hourly_rate INT,
    job_involvement INT,
    job_level INT,
    job_role VARCHAR(100),
    job_satisfaction INT,
    marital_status VARCHAR(50),
    monthly_income INT,
    monthly_rate INT,
    num_companies_worked INT,
    over18 VARCHAR(5),
    overtime VARCHAR(10),
    percent_salary_hike INT,
    performance_rating INT,
    relationship_satisfaction INT,
    standard_hours INT,
    stock_option_level INT,
    total_working_years INT,
    training_times_last_year INT,
    work_life_balance INT,
    years_at_company INT,
    years_in_current_role INT,
    years_since_last_promotion INT,
    years_with_curr_manager INT

);

-- =====================================================
-- RECRUITMENT TABLE
-- =====================================================

CREATE TABLE recruitment (

    candidate_id VARCHAR(20) PRIMARY KEY,
    department VARCHAR(50),
    role_level VARCHAR(50),
    source VARCHAR(50),
    recruiter VARCHAR(50),
    hiring_manager VARCHAR(100),
    location VARCHAR(50),
    work_mode VARCHAR(30),
    gender VARCHAR(20),

    application_date DATE,
    screening_date DATE,
    interview_date DATE,
    offer_date DATE,
    joining_date DATE,

    passed_screening INT,
    passed_interview INT,
    got_offer INT,
    accepted_offer INT,
    candidate_dropout INT,

    candidate_status VARCHAR(50),

    interview_score INT,
    time_to_hire_days INT,
    experience_years INT,
    salary_offered INT,

    offer_rejection_reason VARCHAR(255)

);

-- =====================================================
-- PERFORMANCE INDEXES
-- =====================================================

CREATE INDEX idx_attrition
ON employees(attrition);

CREATE INDEX idx_department
ON employees(department);

CREATE INDEX idx_overtime
ON employees(overtime);

CREATE INDEX idx_recruitment_department
ON recruitment(department);

CREATE INDEX idx_recruitment_source
ON recruitment(source);

CREATE INDEX idx_recruitment_status
ON recruitment(candidate_status);