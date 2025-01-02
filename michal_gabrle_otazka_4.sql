WITH price_year_to_year AS (
		SELECT 
			category_code
			,category_name 
			,"year" 
			,avg_value 
			,round ((avg_value - LAG(avg_value) OVER (PARTITION BY category_code ORDER BY year)) / LAG(avg_value) OVER (PARTITION BY category_code ORDER BY year) * 100) AS year_to_year_percent
		FROM t_michal_gabrle_project_sql_primary_final AS mgtable
		WHERE "type" = 'price'
		ORDER BY category_code, year
	)
	,avg_price_year_to_year AS (
		SELECT 
			year
			,avg(year_to_year_percent) AS avg_price_year_to_year_percent
		FROM price_year_to_year
		GROUP BY year
	)
	,payroll_year_to_year AS (
		SELECT 
			category_code
			,category_name 
			,"year" 
			,avg_value 
			,round ((avg_value - LAG(avg_value) OVER (PARTITION BY category_code ORDER BY year)) / LAG(avg_value) OVER (PARTITION BY category_code ORDER BY year) * 100) AS year_to_year_percent
		FROM t_michal_gabrle_project_sql_primary_final AS mgtable
		WHERE "type" = 'payroll' AND category_code IS NOT NULL
		ORDER BY category_code, year
		)
	,avg_payroll_year_to_year AS (
		SELECT 
			year
			,avg(year_to_year_percent) AS avg_payroll_year_to_year_percent
		FROM payroll_year_to_year
		GROUP BY year
	)
	,price_payroll_difference AS (
		SELECT 
			price.YEAR AS YEAR
			,price.avg_price_year_to_year_percent AS price_year_difference
			,payroll.avg_payroll_year_to_year_percent AS payroll_year_difference
			,ABS(price.avg_price_year_to_year_percent - payroll.avg_payroll_year_to_year_percent) AS price_payroll_difference
		FROM avg_price_year_to_year AS price
		JOIN avg_payroll_year_to_year AS payroll ON price.YEAR = payroll.YEAR
		ORDER BY price_payroll_difference desc
	)
SELECT * 
FROM price_payroll_difference
WHERE price_payroll_difference > 10

