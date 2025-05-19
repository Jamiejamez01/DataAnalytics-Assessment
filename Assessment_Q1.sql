SELECT u.id, concat(u.first_name, " " , u.last_name) as name, sum(p.is_regular_savings) as savings_count, 
		sum(p.is_a_fund) as investment_count, round(sum(s.confirmed_amount)) as total_deposit
		FROM 
        adashi_staging.savings_savingsaccount s
		JOIN adashi_staging.plans_plan p
		ON s.plan_id = p.id
		JOIN adashi_staging.users_customuser u
		ON s.owner_id = u.id
        GROUP BY u.id
        HAVING investment_count>0 and savings_count>0
        ORDER BY total_deposit desc