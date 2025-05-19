USE adashi_staging;
WITH transaction_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_confirmed_amount
    FROM savings_savingsaccount
    GROUP BY owner_id
),
user_tenure AS (
    SELECT 
        id AS customer_id,
        concat(first_name, " ", last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        u.customer_id,
        u.name,
        u.tenure_months,
        t.total_transactions,
        ROUND(((t.total_transactions / NULLIF(u.tenure_months, 0)) * 12 * 0.001), 2) AS estimated_clv
    FROM user_tenure u
    JOIN transaction_summary t ON u.customer_id = t.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv desc;