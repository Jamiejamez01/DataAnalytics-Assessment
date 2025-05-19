WITH transaction_data AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MAX(transaction_date), MIN(transaction_date)) / 30.0 AS tenure_months
    FROM savings_savingsaccount
    GROUP BY owner_id
), 
frequency_analysis AS (
    SELECT 
        owner_id,
        total_transactions,
        tenure_months,
        (total_transactions / NULLIF(tenure_months, 0)) AS avg_txn_per_month
    FROM transaction_data
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM frequency_analysis
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;