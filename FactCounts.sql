select api12, formation_code, report_date, count(*) nrec
	from FactMonthlyProduction
	group by api12, formation_code, report_date
	order by nrec desc
