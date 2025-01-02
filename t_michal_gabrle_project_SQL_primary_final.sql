CREATE TABLE t_michal_gabrle_project_SQL_primary_final AS
(
	SELECT 
		round(avg(cp.value)) AS avg_value
		,cpib.code AS category_code
		,cpib."name" AS category_name
		,cp.payroll_year AS YEAR
		,'payroll' AS type
	FROM czechia_payroll AS cp
	LEFT JOIN
		czechia_payroll_industry_branch AS cpib ON cp.industry_branch_code = cpib.code
	WHERE value_type_code = 5958 AND calculation_code = 200
	GROUP BY year, category_code
	UNION
	SELECT 
		round(avg(cpr.value)) AS avg_value
		,cpc.code::text AS category_code
		,cpc."name" AS category_name
		,date_part('year', date_from) AS YEAR
		,'price' AS type		
	FROM czechia_price AS cpr
	JOIN 
		czechia_price_category AS cpc ON cpr.category_code = cpc.code 
	WHERE region_code IS NULL
	GROUP BY YEAR, cpc.code
	UNION
	SELECT 
		gdp
		,'CZ'
		,country 
		,year
		,'GDP_USD'
	FROM economies 
	WHERE 
		country = 'Czech Republic'
		AND GDP IS NOT NULL 
	ORDER BY type, year,category_code
)

