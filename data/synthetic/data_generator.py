import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

np.random.seed(42)

n = 1500

departments = {
    'Engineering': 28,
    'Sales': 24,
    'Marketing': 16,
    'Finance': 12,
    'HR': 10,
    'Operations': 10
}

role_levels = {
    'Junior': (0, 2),
    'Analyst': (1, 4),
    'Senior': (3, 7),
    'Lead': (6, 10),
    'Manager': (8, 15)
}

sources = {
    'Referral': 0.78,
    'LinkedIn': 0.55,
    'Naukri': 0.42,
    'Campus': 0.48,
    'Company Website': 0.38
}

recruiters = {
    'Priya S': 0.85,
    'Rahul M': 0.75,
    'Anita K': 0.70,
    'Deepak R': 0.60,
    'Sneha T': 0.80
}

hiring_managers = [
    'Arjun Mehta',
    'Neha Kapoor',
    'Ravi Verma',
    'Simran Gill',
    'Kunal Shah',
    'Pooja Nair'
]

locations = [
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Mumbai',
    'Delhi'
]

work_modes = [
    'Remote',
    'Hybrid',
    'Onsite'
]

offer_rejection_reasons = [
    'Higher salary elsewhere',
    'Location mismatch',
    'Long hiring process',
    'Counter offer accepted',
    'Role mismatch'
]

genders = [
    'Male',
    'Female'
]

def weighted_choice(dictionary):
    items = list(dictionary.keys())
    weights = list(dictionary.values())
    return random.choices(items, weights=weights)[0]

def random_date(start, end):
    return start + timedelta(
        days=random.randint(0, (end - start).days)
    )

data = []

for i in range(n):

    department = weighted_choice(departments)

    role = random.choice(list(role_levels.keys()))

    source = weighted_choice(sources)

    recruiter = weighted_choice(recruiters)

    hiring_manager = random.choice(hiring_managers)

    location = random.choice(locations)

    work_mode = random.choice(work_modes)

    gender = random.choice(genders)

    exp_min, exp_max = role_levels[role]

    experience = random.randint(exp_min, exp_max)

    applied = random_date(
        datetime(2023, 1, 1),
        datetime(2024, 6, 30)
    )

    department_delay = {
        'Engineering': random.randint(20, 40),
        'Sales': random.randint(12, 25),
        'Marketing': random.randint(15, 28),
        'Finance': random.randint(18, 35),
        'HR': random.randint(10, 22),
        'Operations': random.randint(14, 30)
    }

    total_hiring_days = department_delay[department]

    screening_date = applied + timedelta(
        days=random.randint(1, 5)
    )

    interview_date = screening_date + timedelta(
        days=random.randint(3, 10)
    )

    offer_date = interview_date + timedelta(
        days=random.randint(2, 7)
    )

    joining_date = applied + timedelta(
        days=total_hiring_days
    )

    interview_score = random.randint(45, 100)

    screening_pass_prob = 0.60 + (experience * 0.02)

    passed_screening = (
        random.random() < min(screening_pass_prob, 0.95)
    )

    interview_pass_prob = (
        interview_score / 100
    ) if passed_screening else 0

    passed_interview = (
        random.random() < interview_pass_prob
    )

    got_offer = (
        random.random() < 0.72
        if passed_interview else False
    )

    accepted_offer = (
        random.random() < sources[source]
        if got_offer else False
    )

    candidate_dropout = (
        random.random() < 0.08
    )

    if candidate_dropout:
        accepted_offer = False

    salary_base = {
        'Junior': (400000, 700000),
        'Analyst': (500000, 900000),
        'Senior': (800000, 1500000),
        'Lead': (1400000, 2200000),
        'Manager': (1800000, 3200000)
    }

    salary_offered = (
        random.randint(
            salary_base[role][0],
            salary_base[role][1]
        )
        if got_offer else None
    )

    rejection_reason = (
        random.choice(offer_rejection_reasons)
        if got_offer and not accepted_offer
        else None
    )

    candidate_status = (
        'Joined'
        if accepted_offer else
        'Offer Rejected'
        if got_offer else
        'Interview Rejected'
        if passed_screening else
        'Screening Rejected'
    )

    data.append({

        'candidate_id': f'C{i+1001}',

        'department': department,

        'role_level': role,

        'source': source,

        'recruiter': recruiter,

        'hiring_manager': hiring_manager,

        'location': location,

        'work_mode': work_mode,

        'gender': gender,

        'application_date':
            applied.strftime('%Y-%m-%d'),

        'screening_date':
            screening_date.strftime('%Y-%m-%d'),

        'interview_date':
            interview_date.strftime('%Y-%m-%d'),

        'offer_date':
            offer_date.strftime('%Y-%m-%d'),

        'joining_date':
            joining_date.strftime('%Y-%m-%d'),

        'passed_screening':
            int(passed_screening),

        'passed_interview':
            int(passed_interview),

        'got_offer':
            int(got_offer),

        'accepted_offer':
            int(accepted_offer),

        'candidate_dropout':
            int(candidate_dropout),

        'candidate_status':
            candidate_status,

        'interview_score':
            interview_score,

        'time_to_hire_days':
            total_hiring_days
            if accepted_offer else None,

        'experience_years':
            experience,

        'salary_offered':
            salary_offered,

        'offer_rejection_reason':
            rejection_reason
    })

df = pd.DataFrame(data)

import os

current_dir = os.path.dirname(__file__)

output_path = os.path.join(

    current_dir,

    '..',

    'raw',

    'recruitment_raw.csv'

)

output_path = os.path.abspath(output_path)

df.to_csv(

    output_path,

    index=False

)

print(f"\nGenerated {len(df)} recruitment records\n")

print(df.head())

print("\nDataset Shape:")
print(df.shape)

print("\nCandidate Status Distribution:")
print(df['candidate_status'].value_counts())