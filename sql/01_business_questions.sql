-- Customer Churn Deep Dive: Business Questions
-- Dataset: Ravenstack SaaS churn dataset

-- 1. What is the overall churn rate?
-- Uses: accounts.churn_flag

-- 2. How has churn changed month over month?
-- Uses: churn_events.churn_date

-- 3. Which plan tiers have the highest churn?
-- Uses: accounts.plan_tier, accounts.churn_flag

-- 4. Which industries have the highest churn?
-- Uses: accounts.industry, accounts.churn_flag

-- 5. Which countries have the highest churn?
-- Uses: accounts.country, accounts.churn_flag

-- 6. Are trial customers more likely to churn?
-- Uses: accounts.is_trial, accounts.churn_flag

-- 7. Does billing frequency affect churn?
-- Uses: subscriptions.billing_frequency, subscriptions.churn_flag

-- 8. Are downgraded customers more likely to churn?
-- Uses: subscriptions.downgrade_flag, subscriptions.churn_flag

-- 9. Are customers with more support tickets more likely to churn?
-- Uses: support_tickets.account_id, accounts.churn_flag

-- 10. Do customers with lower satisfaction scores churn more?
-- Uses: support_tickets.satisfaction_score, accounts.churn_flag

-- 11. Do customers with high error counts churn more?
-- Uses: feature_usage.error_count, subscriptions.account_id, accounts.churn_flag

-- 12. Which churn reasons are most common?
-- Uses: churn_events.reason_code

-- 13. How much revenue is lost from churned subscriptions?
-- Uses: subscriptions.mrr_amount, subscriptions.arr_amount, subscriptions.churn_flag

-- 14. Which high-value accounts are at risk?
-- Uses: subscriptions.mrr_amount, accounts.churn_flag, feature_usage.usage_date

-- 15. What actions should we recommend for each churn risk group?
-- Uses: churn risk segmentation from Python analysis