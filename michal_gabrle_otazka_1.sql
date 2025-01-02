SELECT
	year
	,category_code 
	,category_name
	,avg_value
	,LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") AS last_avg_value
	,CASE 
		WHEN LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") IS NULL THEN '---'
		WHEN avg_value < LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'down'
		WHEN avg_value > LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'up'
		WHEN avg_value = LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'same'
	END AS Trend
FROM t_michal_gabrle_project_sql_primary_final AS mgtable
WHERE TYPE = 'payroll' AND category_code IS NOT NULL
ORDER BY category_code, YEAR


/*Získání pouze downtrendů*/
SELECT * FROM (
	SELECT
		year
		,category_code 
		,category_name
		,avg_value
		,LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") AS last_avg_value
		,CASE 
			WHEN LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") IS NULL THEN '---'
			WHEN avg_value < LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'down'
			WHEN avg_value > LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'up'
			WHEN avg_value = LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") THEN 'same'
		END AS Trend
	FROM t_michal_gabrle_project_sql_primary_final AS mgtable
	WHERE TYPE = 'payroll' AND category_code IS NOT NULL
	ORDER BY category_code, YEAR
) WHERE trend ='down'
ORDER BY category_code, YEAR

--Za 5 let
SELECT * FROM (
	SELECT
		year
		,category_code 
		,category_name
		,avg_value
		,LAG(avg_value, 5) OVER (PARTITION BY category_code ORDER BY "year" ) AS last_avg_value
		,CASE 
			WHEN LAG(avg_value) OVER (PARTITION BY category_code ORDER BY "year") IS NULL THEN '---'
			WHEN avg_value < LAG(avg_value,5) OVER (PARTITION BY category_code ORDER BY "year" ) THEN 'down'
			WHEN avg_value > LAG(avg_value,5) OVER (PARTITION BY category_code ORDER BY "year" ) THEN 'up'
			WHEN avg_value = LAG(avg_value,5) OVER (PARTITION BY category_code ORDER BY "year" ) THEN 'same'
		END AS Trend
	FROM t_michal_gabrle_project_sql_primary_final AS mgtable
	WHERE TYPE = 'payroll' AND category_code IS NOT NULL
	ORDER BY category_code, YEAR
) WHERE trend ='down'
ORDER BY category_code, YEAR