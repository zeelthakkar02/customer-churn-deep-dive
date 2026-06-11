-- =====================================================
-- Customer Churn Deep Dive: SQL Analysis Queries
-- Dataset: Ravenstack SaaS Churn Dataset
-- Purpose: Analyze churn trends, churn drivers, support signals,
--          product usage signals, churn reasons, and revenue impact.
-- =====================================================


-- =====================================================
-- 1. Overall Churn Rate
-- =====================================================

SELECT
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    SUM(CASE WHEN churn_flag = FALSE THEN 1 ELSE 0 END) AS active_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts;


-- =====================================================
-- 2. Churn Rate by Plan Tier
-- =====================================================

SELECT
    plan_tier,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 3. Churn Rate by Industry
-- =====================================================

SELECT
    industry,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts
GROUP BY industry
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 4. Churn Rate by Country
-- =====================================================

SELECT
    country,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts
GROUP BY country
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 5. Churn Rate by Trial Status
-- =====================================================

SELECT
    is_trial,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts
GROUP BY is_trial
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 6. Churn Rate by Referral Source
-- =====================================================

SELECT
    referral_source,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts
GROUP BY referral_source
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 7. Churn Rate by Billing Frequency
-- =====================================================

SELECT
    billing_frequency,
    COUNT(*) AS total_subscriptions,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_subscriptions,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM subscriptions
GROUP BY billing_frequency
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 8. Churn Rate by Downgrade Status
-- =====================================================

SELECT
    downgrade_flag,
    COUNT(*) AS total_subscriptions,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_subscriptions,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM subscriptions
GROUP BY downgrade_flag
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 9. Churn Rate by Upgrade Status
-- =====================================================

SELECT
    upgrade_flag,
    COUNT(*) AS total_subscriptions,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_subscriptions,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM subscriptions
GROUP BY upgrade_flag
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 10. Most Common Churn Reasons
-- =====================================================

SELECT
    reason_code,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS unique_accounts,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund_amount_usd
FROM churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;


-- =====================================================
-- 11. Churn Reasons by Industry
-- =====================================================

SELECT
    a.industry,
    ce.reason_code,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT ce.account_id) AS unique_accounts
FROM churn_events ce
JOIN accounts a
    ON ce.account_id = a.account_id
GROUP BY a.industry, ce.reason_code
ORDER BY a.industry, churn_events DESC;


-- =====================================================
-- 12. Churn by Support Ticket Volume
-- =====================================================

WITH support_summary AS (
    SELECT
        account_id,
        COUNT(ticket_id) AS total_tickets
    FROM support_tickets
    GROUP BY account_id
),

account_support AS (
    SELECT
        a.account_id,
        a.churn_flag,
        COALESCE(ss.total_tickets, 0) AS total_tickets
    FROM accounts a
    LEFT JOIN support_summary ss
        ON a.account_id = ss.account_id
)

SELECT
    CASE
        WHEN total_tickets = 0 THEN '0 tickets'
        WHEN total_tickets BETWEEN 1 AND 2 THEN '1-2 tickets'
        WHEN total_tickets BETWEEN 3 AND 5 THEN '3-5 tickets'
        ELSE '6+ tickets'
    END AS ticket_bucket,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM account_support
GROUP BY ticket_bucket
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 13. Churn by Support Escalation
-- =====================================================

WITH support_summary AS (
    SELECT
        account_id,
        SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
    FROM support_tickets
    GROUP BY account_id
)

SELECT
    CASE
        WHEN COALESCE(ss.escalated_tickets, 0) > 0 THEN 'Has Escalation'
        ELSE 'No Escalation'
    END AS escalation_status,
    COUNT(a.account_id) AS total_accounts,
    SUM(CASE WHEN a.churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN a.churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(a.account_id),
        2
    ) AS churn_rate_percent
FROM accounts a
LEFT JOIN support_summary ss
    ON a.account_id = ss.account_id
GROUP BY escalation_status
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 14. Average Support Metrics by Churn Status
-- =====================================================

WITH support_summary AS (
    SELECT
        account_id,
        COUNT(ticket_id) AS total_tickets,
        AVG(resolution_time_hours) AS avg_resolution_time_hours,
        AVG(first_response_time_minutes) AS avg_first_response_time_minutes,
        AVG(satisfaction_score) AS avg_satisfaction_score,
        SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
    FROM support_tickets
    GROUP BY account_id
)

SELECT
    a.churn_flag,
    COUNT(a.account_id) AS total_accounts,
    ROUND(AVG(COALESCE(ss.total_tickets, 0)), 2) AS avg_total_tickets,
    ROUND(AVG(ss.avg_resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(ss.avg_first_response_time_minutes), 2) AS avg_first_response_time_minutes,
    ROUND(AVG(ss.avg_satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(AVG(COALESCE(ss.escalated_tickets, 0)), 2) AS avg_escalated_tickets
FROM accounts a
LEFT JOIN support_summary ss
    ON a.account_id = ss.account_id
GROUP BY a.churn_flag
ORDER BY a.churn_flag DESC;


-- =====================================================
-- 15. Product Usage Summary by Churn Status
-- =====================================================

WITH usage_with_accounts AS (
    SELECT
        s.account_id,
        fu.usage_count,
        fu.usage_duration_secs,
        fu.error_count,
        fu.feature_name,
        fu.is_beta_feature
    FROM feature_usage fu
    JOIN subscriptions s
        ON fu.subscription_id = s.subscription_id
),

usage_summary AS (
    SELECT
        account_id,
        SUM(usage_count) AS total_usage_count,
        AVG(usage_count) AS avg_usage_count,
        SUM(usage_duration_secs) AS total_usage_duration_secs,
        AVG(usage_duration_secs) AS avg_usage_duration_secs,
        SUM(error_count) AS total_errors,
        AVG(error_count) AS avg_errors,
        COUNT(DISTINCT feature_name) AS unique_features_used,
        SUM(CASE WHEN is_beta_feature = TRUE THEN 1 ELSE 0 END) AS beta_feature_usage
    FROM usage_with_accounts
    GROUP BY account_id
)

SELECT
    a.churn_flag,
    COUNT(a.account_id) AS total_accounts,
    ROUND(AVG(us.total_usage_count), 2) AS avg_total_usage_count,
    ROUND(AVG(us.total_usage_duration_secs), 2) AS avg_total_usage_duration_secs,
    ROUND(AVG(us.total_errors), 2) AS avg_total_errors,
    ROUND(AVG(us.unique_features_used), 2) AS avg_unique_features_used,
    ROUND(AVG(us.beta_feature_usage), 2) AS avg_beta_feature_usage
FROM accounts a
LEFT JOIN usage_summary us
    ON a.account_id = us.account_id
GROUP BY a.churn_flag
ORDER BY a.churn_flag DESC;


-- =====================================================
-- 16. Churn by Product Error Bucket
-- Note: NTILE creates quartile-style buckets.
-- =====================================================

WITH usage_with_accounts AS (
    SELECT
        s.account_id,
        fu.error_count
    FROM feature_usage fu
    JOIN subscriptions s
        ON fu.subscription_id = s.subscription_id
),

usage_summary AS (
    SELECT
        account_id,
        SUM(error_count) AS total_errors
    FROM usage_with_accounts
    GROUP BY account_id
),

accounts_with_errors AS (
    SELECT
        a.account_id,
        a.churn_flag,
        COALESCE(us.total_errors, 0) AS total_errors,
        NTILE(4) OVER (ORDER BY COALESCE(us.total_errors, 0)) AS error_quartile
    FROM accounts a
    LEFT JOIN usage_summary us
        ON a.account_id = us.account_id
)

SELECT
    CASE
        WHEN error_quartile = 1 THEN 'Low errors'
        WHEN error_quartile = 2 THEN 'Medium-low errors'
        WHEN error_quartile = 3 THEN 'Medium-high errors'
        WHEN error_quartile = 4 THEN 'High errors'
    END AS error_bucket,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM accounts_with_errors
GROUP BY error_quartile, error_bucket
ORDER BY error_quartile;


-- =====================================================
-- 17. Revenue Lost from Churned Subscriptions
-- =====================================================

SELECT
    COUNT(*) AS churned_subscriptions,
    SUM(mrr_amount) AS lost_mrr,
    SUM(arr_amount) AS lost_arr,
    ROUND(AVG(mrr_amount), 2) AS avg_lost_mrr_per_subscription,
    ROUND(AVG(arr_amount), 2) AS avg_lost_arr_per_subscription
FROM subscriptions
WHERE churn_flag = TRUE;


-- =====================================================
-- 18. High-Value Churned Accounts
-- =====================================================

SELECT
    a.account_id,
    a.account_name,
    a.industry,
    a.country,
    a.plan_tier,
    SUM(s.mrr_amount) AS total_mrr,
    SUM(s.arr_amount) AS total_arr,
    COUNT(s.subscription_id) AS total_subscriptions
FROM accounts a
JOIN subscriptions s
    ON a.account_id = s.account_id
WHERE a.churn_flag = TRUE
GROUP BY
    a.account_id,
    a.account_name,
    a.industry,
    a.country,
    a.plan_tier
ORDER BY total_mrr DESC
LIMIT 20;


-- =====================================================
-- 19. Customer Risk Segmentation
-- Note: This mirrors the Python risk-score logic.
-- =====================================================

WITH support_summary AS (
    SELECT
        account_id,
        SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
    FROM support_tickets
    GROUP BY account_id
),

usage_with_accounts AS (
    SELECT
        s.account_id,
        fu.error_count,
        fu.feature_name
    FROM feature_usage fu
    JOIN subscriptions s
        ON fu.subscription_id = s.subscription_id
),

usage_summary AS (
    SELECT
        account_id,
        SUM(error_count) AS total_errors,
        COUNT(DISTINCT feature_name) AS unique_features_used
    FROM usage_with_accounts
    GROUP BY account_id
),

median_values AS (
    SELECT
        AVG(total_errors) AS avg_total_errors,
        AVG(unique_features_used) AS avg_unique_features_used
    FROM usage_summary
),

risk_base AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        a.country,
        a.is_trial,
        a.churn_flag,
        COALESCE(ss.escalated_tickets, 0) AS escalated_tickets,
        COALESCE(us.total_errors, 0) AS total_errors,
        COALESCE(us.unique_features_used, 0) AS unique_features_used,
        mv.avg_total_errors,
        mv.avg_unique_features_used
    FROM accounts a
    LEFT JOIN support_summary ss
        ON a.account_id = ss.account_id
    LEFT JOIN usage_summary us
        ON a.account_id = us.account_id
    CROSS JOIN median_values mv
),

risk_scored AS (
    SELECT
        *,
        CASE WHEN industry = 'DevTools' THEN 2 ELSE 0 END
        + CASE WHEN country = 'DE' THEN 1 ELSE 0 END
        + CASE WHEN is_trial = TRUE THEN 1 ELSE 0 END
        + CASE WHEN escalated_tickets > 0 THEN 1 ELSE 0 END
        + CASE WHEN total_errors >= avg_total_errors THEN 1 ELSE 0 END
        + CASE WHEN unique_features_used >= avg_unique_features_used THEN 1 ELSE 0 END
        AS risk_score
    FROM risk_base
)

SELECT
    CASE
        WHEN risk_score <= 1 THEN 'Low Risk'
        WHEN risk_score BETWEEN 2 AND 3 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_segment,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM risk_scored
GROUP BY risk_segment
ORDER BY churn_rate_percent DESC;


-- =====================================================
-- 20. High-Risk Accounts for Retention Outreach
-- =====================================================

WITH support_summary AS (
    SELECT
        account_id,
        SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
    FROM support_tickets
    GROUP BY account_id
),

usage_with_accounts AS (
    SELECT
        s.account_id,
        fu.error_count,
        fu.feature_name
    FROM feature_usage fu
    JOIN subscriptions s
        ON fu.subscription_id = s.subscription_id
),

usage_summary AS (
    SELECT
        account_id,
        SUM(error_count) AS total_errors,
        COUNT(DISTINCT feature_name) AS unique_features_used
    FROM usage_with_accounts
    GROUP BY account_id
),

median_values AS (
    SELECT
        AVG(total_errors) AS avg_total_errors,
        AVG(unique_features_used) AS avg_unique_features_used
    FROM usage_summary
),

risk_base AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        a.country,
        a.plan_tier,
        a.is_trial,
        a.churn_flag,
        COALESCE(ss.escalated_tickets, 0) AS escalated_tickets,
        COALESCE(us.total_errors, 0) AS total_errors,
        COALESCE(us.unique_features_used, 0) AS unique_features_used,
        mv.avg_total_errors,
        mv.avg_unique_features_used
    FROM accounts a
    LEFT JOIN support_summary ss
        ON a.account_id = ss.account_id
    LEFT JOIN usage_summary us
        ON a.account_id = us.account_id
    CROSS JOIN median_values mv
),

risk_scored AS (
    SELECT
        *,
        CASE WHEN industry = 'DevTools' THEN 2 ELSE 0 END
        + CASE WHEN country = 'DE' THEN 1 ELSE 0 END
        + CASE WHEN is_trial = TRUE THEN 1 ELSE 0 END
        + CASE WHEN escalated_tickets > 0 THEN 1 ELSE 0 END
        + CASE WHEN total_errors >= avg_total_errors THEN 1 ELSE 0 END
        + CASE WHEN unique_features_used >= avg_unique_features_used THEN 1 ELSE 0 END
        AS risk_score
    FROM risk_base
)

SELECT
    account_id,
    account_name,
    industry,
    country,
    plan_tier,
    is_trial,
    escalated_tickets,
    total_errors,
    unique_features_used,
    risk_score,
    CASE
        WHEN risk_score <= 1 THEN 'Low Risk'
        WHEN risk_score BETWEEN 2 AND 3 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_segment,
    CASE
        WHEN risk_score >= 4 THEN 'Priority outreach by Customer Success'
        WHEN risk_score BETWEEN 2 AND 3 THEN 'Targeted onboarding and feature guidance'
        ELSE 'Standard lifecycle communication'
    END AS recommended_action
FROM risk_scored
WHERE churn_flag = FALSE
ORDER BY risk_score DESC, total_errors DESC
LIMIT 50;