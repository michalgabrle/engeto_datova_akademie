CREATE TABLE t_michal_gabrle_project_SQL_secondary_final AS
WITH year_cz_data AS (
	SELECT 
		cp.payroll_year AS YEAR
	FROM czechia_payroll AS cp
	INTERSECT
	SELECT 
		date_part('year', date_from) AS YEAR
	FROM czechia_price AS cpr 
)
SELECT
	ec.country
	,ec."year" 
	,ec.gdp
	,ec.gini 
	,ec.population
	,c.continent 
FROM economies AS ec
JOIN 
	countries AS c ON ec.country = c.country 
WHERE ec."year" IN (
	SELECT * 
	FROM year_cz_data
	)
	AND c.continent = 'Europe'
ORDER BY "year", country