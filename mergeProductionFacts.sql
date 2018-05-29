
-- get the latest reported production data for each well,
-- formation and report date combination. Latest defined
-- by the max of accepted_dt

with ProdDataOrdered as (
	select 
	   [formation_code]
      ,[well_status]
      ,[prod_days]
      ,[water_disp_code]
      ,[water_vol]
      ,[water_press_tbg]
      ,[water_press_csg]
      ,[bom_invent]
      ,[oil_vol]
      ,[oil_sales]
      ,[adjustment]
      ,[eom_invent]
      ,[gravity_sales]
      ,[gas_sales]
      ,[flared]
      ,[gas_vol]
      ,[shrink]
      ,[gas_prod]
      ,[btu_sales]
      ,[gas_press_tbg]
      ,[gas_press_csg]
      ,[operator_num]
      ,[name]
      ,[facility_name]
      ,[facility_num]
      --,[revised]
      ,[API12]
      ,[report_date]
      ,[accepted_dt]
	  ,row_number() over(partition by api12, formation_code, report_date ORDER BY accepted_dt DESC) rn
	from [dbo].[M_Producion_2002] mp
	)

, ProdDataLatest as (
	select * from ProdDataOrdered where rn = 1
	)

insert into FactMonthlyProduction (
	   [formation_code]
      ,[well_status]
      ,[prod_days]
      ,[water_disp_code]
      ,[water_vol]
      ,[water_press_tbg]
      ,[water_press_csg]
      ,[bom_invent]
      ,[oil_vol]
      ,[oil_sales]
      ,[adjustment]
      ,[eom_invent]
      ,[gravity_sales]
      ,[gas_sales]
      ,[flared]
      ,[gas_vol]
      ,[shrink]
      ,[gas_prod]
      ,[btu_sales]
      ,[gas_press_tbg]
      ,[gas_press_csg]
      ,[operator_num]
      ,[name]
      ,[facility_name]
      ,[facility_num]
      --,[revised]
      ,[API12]
      ,[report_date]
      ,[accepted_dt]
)
	select 
	   [formation_code]
      ,[well_status]
      ,[prod_days]
      ,[water_disp_code]
      ,[water_vol]
      ,[water_press_tbg]
      ,[water_press_csg]
      ,[bom_invent]
      ,[oil_vol]
      ,[oil_sales]
      ,[adjustment]
      ,[eom_invent]
      ,[gravity_sales]
      ,[gas_sales]
      ,[flared]
      ,[gas_vol]
      ,[shrink]
      ,[gas_prod]
      ,[btu_sales]
      ,[gas_press_tbg]
      ,[gas_press_csg]
      ,[operator_num]
      ,[name]
      ,[facility_name]
      ,[facility_num]
      --,[revised]
      ,[API12]
      ,[report_date]
      ,[accepted_dt] 

	from ProdDataLatest mp
	where not exists
		 (select api12, formation_code, report_date from FactMonthlyProduction fp
			where mp.api12 = fp.api12 and mp.formation_code=fp.formation_code and
				mp.report_date=fp.report_date)