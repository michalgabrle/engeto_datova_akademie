WITH 
	dataset AS (
		SELECT
			mgtable.YEAR AS year
		FROM t_michal_gabrle_project_sql_primary_final AS mgtable
		LEFT JOIN 
			t_michal_gabrle_project_sql_primary_final AS mgtable2 ON mgtable.YEAR = mgtable2.year
		WHERE mgtable.type ='payroll' 
			AND mgtable.category_code IS NULL
			AND mgtable2.category_code IN ('111301','114201')
	)
	,years AS (
		SELECT
			max(year)
		FROM dataset
		UNION
		SELECT
			min(year)
		FROM dataset
	)
SELECT
		mgtable.YEAR AS year
		,mgtable.avg_value AS payroll
		,mgtable2.category_name AS comodity
		,mgtable2.avg_value AS comodity_price
		,round(mgtable.avg_value / mgtable2.avg_value) AS amount_buy
	FROM t_michal_gabrle_project_sql_primary_final AS mgtable
	LEFT JOIN 
		t_michal_gabrle_project_sql_primary_final AS mgtable2 ON mgtable.YEAR = mgtable2.year
	WHERE mgtable.type ='payroll' 
		AND mgtable.category_code IS NULL
		AND mgtable2.category_code IN ('111301','114201')
		AND mgtable.YEAR IN (SELECT * FROM years)

		



