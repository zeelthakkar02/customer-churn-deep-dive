# Customer Churn Deep Dive + Action Plan

## Business Problem
A subscription company is experiencing customer churn and needs to identify why customers are leaving.

## Objective
Analyze churn trends, identify leading indicators, segment customers by risk, and recommend retention actions.

## Tools Used
SQL, Python, Pandas, Matplotlib/Seaborn, Scikit-learn, Power BI

## Key Questions
- Is churn increasing over time?
- Which customer segments churn the most?
- What behaviors predict churn?
- Which customers are high-risk?
- What actions should the business take?

## Key Insights
- Customers inactive for 7+ days had significantly higher churn.
- New customers were more likely to churn within the first 90 days.
- Low feature adoption was strongly associated with churn.
- High-value inactive customers represented major revenue risk.

## Recommendations
- Trigger email reminders after 7 days of inactivity.
- Improve onboarding for new users.
- Assign account managers to high-value at-risk customers.
- Escalate customers with multiple unresolved support tickets.

## Deliverables
- SQL churn analysis
- Python EDA and churn model
- Power BI dashboard
- Churn playbook