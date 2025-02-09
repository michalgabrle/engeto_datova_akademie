--průměry rychlosti zdražování po jednotlivých kategoriích. V seznamu ponechány i kategorie, které zlevnily.

SELECT 
	round(avg(difference_percent)::numeric, 2) AS avg_difference_percent
	,category_name
FROM( 
	SELECT 
		category_code 
		,category_name 
		,"year" 
		,avg_value
		,LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR) AS avg_value_last_year
		,round((avg_value - LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR)) / LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR) * 100) AS "difference_percent"
		FROM t_michal_gabrle_project_sql_primary_final AS mgtable
	WHERE "type" = 'price'
	ORDER BY category_code, YEAR
)
GROUP BY category_name
ORDER BY avg_difference_percent


/*Kategorie, která nejpomaleji zdražuje. Kontrolou zjištěno, že jsou 2 kategorie se stejnou hodnotou. Namísto použití "natvrdo"  limit = 2  jsem chtěl jít obecnou cestou, která by fungovala nad
libovolným datasetem -> zjištění minimální hodnoty a potom vypsání všech kategorií s danou hodnotou*/

WITH dataset AS (
	SELECT 
		round(avg(difference_percent)::numeric, 2) AS avg_difference_percent
		,category_name
	FROM( 
		SELECT 
			category_code 
			,category_name 
			,"year" 
			,avg_value
			,LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR) AS avg_value_last_year
			,round((avg_value - LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR)) / LAG(avg_value) OVER (PARTITION BY category_code ORDER BY YEAR) * 100) AS "difference_percent"
			FROM t_michal_gabrle_project_sql_primary_final AS mgtable
		WHERE "type" = 'price'
		ORDER BY category_code, YEAR
	)
	GROUP BY category_name
	HAVING round(avg(difference_percent)::numeric, 2) > 0
	ORDER BY avg_difference_percent
	)
,min_avg_difference_percent AS (
	SELECT min(avg_difference_percent) FROM dataset
	)
SELECT * FROM dataset WHERE avg_difference_percent = (SELECT * FROM min_avg_difference_percent)
