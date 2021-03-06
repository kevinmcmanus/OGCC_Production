/****** Script for SelectTopNRows command from SSMS  ******/
use OilAndGas
go

if object_id('DimWell') is not null
	drop table DimWell
go

create table DimWell (
	well_id [int] IDENTITY(1,1) primary key,
	api12 [nvarchar](12),
	[operator_name] [nvarchar](50) NULL,
	[facility_name] [nvarchar](35) NULL,
	[facility_num] [nvarchar](15) NULL, --which looks to be the well name
--	[well_name] [nvarchar](35) NULL, -- always same value as facility name
	[API_num] [nvarchar](15) NULL, 
	[well_bore_status] [nvarchar](2) NULL,
	[qtrqtr] [nvarchar](6) NULL,
	[sec] [nvarchar](2) NULL,
	[twp] [nvarchar](6) NULL,
	[range] [nvarchar](7) NULL,
	[meridian] [nvarchar](1) NULL,
	[dist_e_w] [int] NULL,
	[dir_e_w] [nvarchar](1) NULL,
	[dist_n_s] [int] NULL,
	[dir_n_s] [nvarchar](1) NULL,
	[lat] [decimal](8, 6) NULL,
	[long] [decimal](10, 6) NULL,
	[ground_elev] [real] NULL,
	[utm_x] [int] NULL,
	[utm_y] [int] NULL,
	[WbMeasDepth] [int] NULL,
	[WbTvd] [int] NULL,
	[spud_date] [datetime] NULL,
	[complete_date] [datetime] NULL
	)
go

with api12 as (
	SELECT  
		concat('05',w.[api_county_code], w.[api_seq_num],w.[sidetrack_num]) API12
		,w.*
	  FROM [OilAndGas].[dbo].[Completions 2017] w
	  --where long is not NULL
	  )
, wellrecs as (
	select a.*,
		row_number() over(partition by a.api12 order by a.spud_date) rn
	from api12 a
	)
, firstwellrec as (
	select [api12]
		  ,[name] [operator_name]
		  ,[facility_name]
		  ,[facility_num] --which looks like the well name
--		  ,[well_name] same as facility name
		  ,[API_num] 
		  ,[well_bore_status]
		  ,[qtrqtr]
		  ,[sec]
		  ,[twp]
		  ,[range]
		  ,[meridian]
		  ,[dist_e_w]
		  ,[dir_e_w]
		  ,[dist_n_s]
		  ,[dir_n_s]
		  ,[lat]
		  ,[long]
		  ,[ground_elev]
		  ,[utm_x]
		  ,[utm_y]

		  ,[WbMeasDepth]
		  ,[WbTvd]

	from wellrecs
	where rn = 1
	)
	, welldates as (
		select a.api12
			,min(a.spud_date) spud_date
			,min(a.complete_date) complete_date
		from api12 a
		group by a.api12
	)

insert into DimWell
	select w.*, d.spud_date, d.complete_date from firstwellrec w
	left join welldates d on w.api12 = d.api12