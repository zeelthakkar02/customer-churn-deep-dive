# Data Dictionary

## accounts

| Column | Description |
|---|---|
| account_id | Unique account/customer identifier |
| account_name | Name of the customer account |
| industry | Industry of the customer |
| country | Customer country |
| signup_date | Date the account signed up |
| referral_source | Channel/source through which customer signed up |
| plan_tier | Subscription plan tier |
| seats | Number of seats/users purchased |
| is_trial | Whether the account is on a trial |
| churn_flag | Whether the account churned |

## subscriptions

| Column | Description |
|---|---|
| subscription_id | Unique subscription identifier |
| account_id | Account linked to the subscription |
| start_date | Subscription start date |
| end_date | Subscription end date |
| plan_tier | Subscription plan tier |
| seats | Number of seats in the subscription |
| mrr_amount | Monthly recurring revenue |
| arr_amount | Annual recurring revenue |
| is_trial | Whether the subscription is a trial |
| upgrade_flag | Whether the subscription had an upgrade |
| downgrade_flag | Whether the subscription had a downgrade |
| churn_flag | Whether the subscription churned |
| billing_frequency | Monthly or annual billing frequency |
| auto_renew_flag | Whether auto-renewal is enabled |

## feature_usage

| Column | Description |
|---|---|
| usage_id | Unique usage record identifier |
| subscription_id | Subscription linked to feature usage |
| usage_date | Date of feature usage |
| feature_name | Name of the product feature used |
| usage_count | Number of times the feature was used |
| usage_duration_secs | Time spent using the feature |
| error_count | Number of errors encountered |
| is_beta_feature | Whether the feature is a beta feature |

## support_tickets

| Column | Description |
|---|---|
| ticket_id | Unique support ticket identifier |
| account_id | Account linked to the ticket |
| submitted_at | Date/time when ticket was submitted |
| closed_at | Date/time when ticket was closed |
| resolution_time_hours | Time taken to resolve the ticket |
| priority | Ticket priority level |
| first_response_time_minutes | Time taken for first support response |
| satisfaction_score | Customer satisfaction score after support interaction |
| escalation_flag | Whether the ticket was escalated |

## churn_events

| Column | Description |
|---|---|
| churn_event_id | Unique churn event identifier |
| account_id | Account linked to churn event |
| churn_date | Date the account churned |
| reason_code | Stated reason for churn |
| refund_amount_usd | Refund amount issued after churn |
| preceding_upgrade_flag | Whether the account upgraded before churn |
| preceding_downgrade_flag | Whether the account downgraded before churn |
| is_reactivation | Whether this event is related to reactivation |
| feedback_text | Customer feedback about churn |