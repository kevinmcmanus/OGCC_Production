use OilAndGas
go

if object_id('DimFacility') is not null
	drop table DimFacility
go

create table DimFacility (
	facility_id [int] IDENTITY(1,1) primary key,
	[operator_num] [nvarchar](10) NULL,
	[operator_name] [nvarchar](50) NULL,
	[facility_name] [nvarchar](35) NULL,
	[facility_num] [nvarchar](15) NULL
	)
go

insert into DimFacility
	select distinct
		mp.operator_num
		,mp.name operator_name
		,mp.facility_name
		,mp.facility_num
	from [dbo].[FactMonthlyProduction] mp