use OilAndGas
go

/*  Nightly Update Procedure
 *
 *  Merges the current OGCC production data into the FactMonthlyProduction Table
 *  such that the Fact table winds up with the most recent production
 *  report for an (api12, formation_code, report_date) combination
 *
 *  Algorithm
 *		M_Production is the current year's production table downloaded daily from
 *		https://cogcc.state.co.us/documents/data/downloads/production/monthly_prod.csv
 *
 *		1. Get the latest production record (the record with the latest
 *			accepted_dt) for each (api12, formation_code, report_date)
 *		2. Delete from the Fact table any record with a strictly earlier
 *			accepted_dt (earlier than any in the current year production
 *			table) for each (api12, formation_code, report_date)
 *		3. Insert into FactMonthlyProduction all records from the current
 *			year production table that *don't* exist in the
 *			FactMonthlyProduction table for each (api12, formation_code, report_date)
 *
 *	Notes:
 *		Should delete no records and insert no records if run a
 *			second time on the same input
 *
 */



alter procedure NightlyUpdate as
begin

-- delete the records from the Fact table where
-- we have more recent records in the production table
delete fmp 
	from [dbo].[FactMonthlyProduction] fmp
	inner join [dbo].[M_Production] mp
		on fmp.API12 = mp.API12
		and fmp.formation_code = mp.formation_code
		and fmp.report_date = mp.report_date
		and fmp.accepted_dt < mp.accepted_dt

-- CTEs to get the latest production record:

-- get the latest reported production data for each well,
-- formation and report date combination. Latest defined
-- by the max of accepted_dt
;with ProdDataOrdered as (
	select *
	  ,row_number() over(partition by api12, formation_code, report_date ORDER BY accepted_dt DESC) rn
	from [dbo].[M_Production] mp
	)
, ProdDataLatest as (
	select * from ProdDataOrdered where rn = 1
	)

-- insert monthly production records into fact table for those records that aren't already in there
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
	where not exists (
		select api12, formation_code, report_date from FactMonthlyProduction fmp
			where fmp.api12 = mp.api12
			 and fmp.formation_code = mp.formation_code
			 and fmp.report_date = mp.report_date)

end
