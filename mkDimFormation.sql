use OilAndGas
go

create procedure crDimFormation as
begin

if object_id('DimFormation') is not null
	drop table DimFormation

create table DimFormation (
	 [formation_id] [int] IDENTITY(1,1) primary key
	,[formation_code] [nvarchar](6) NULL
	,[formation] [nvarchar](50) NULL
	)

insert into DimFormation
	select distinct
			 [formation_code]
			,[formation]
		from [dbo].[Completions 2017]

end