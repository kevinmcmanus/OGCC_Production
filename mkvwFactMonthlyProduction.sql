alter view vwFactMonthlyProduction as

with fieldcodes as (
	select distinct
		concat('05', c.api_county_code, c.api_seq_num, c.sidetrack_num) API12
		,c.field_code
	from [dbo].[Completions 2017] c
	)

select 
       mp.[ProdFactId]
	  ,dw.well_id
	  --,dfa.facility_id
	  ,dfo.formation_id
	  ,fc.field_code
	  ,mp.[report_date]
	  ,datediff(MONTH, isnull(dw.[complete_date],dw.[spud_date]), mp.[report_date]) [WellAgeMonths]
      ,mp.[well_status]
      ,mp.[prod_days]
      ,mp.[water_disp_code]
      ,mp.[water_vol]
      ,mp.[water_press_tbg]
      ,mp.[water_press_csg]
      ,mp.[bom_invent]
      ,mp.[oil_vol]
      ,mp.[oil_sales]
      ,mp.[adjustment]
      ,mp.[eom_invent]
      ,mp.[gravity_sales]
      ,mp.[gas_sales]
      ,mp.[flared]
      ,mp.[gas_vol]
      ,mp.[shrink]
      ,mp.[gas_prod]
      ,mp.[btu_sales]
      ,mp.[gas_press_tbg]
      ,mp.[gas_press_csg]
      ,mp.[accepted_dt]
from [dbo].[FactMonthlyProduction] mp
left join DimWell dw on mp.API12 = dw.API12
left join fieldcodes fc on mp.API12 = fc.API12
left join DimFormation dfo on mp.formation_code = dfo.formation_code
--left join DimFacility dfa on
--		mp.name = dfa.operator_name
--	and mp.operator_num = dfa.operator_num
--	and mp.facility_name = dfa.facility_name
--	and mp.facility_num = dfa.facility_num