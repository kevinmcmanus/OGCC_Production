use OilAndGas
go

alter procedure crDimField as
begin

if object_id('DimField') is not null
	drop table DimField

create table DimField (
	 [field_code] int primary key
	,[field_name] [nvarchar](50) NULL
	)

insert into DimField
	select distinct
			 [field_code]
			,[field_name]
		from [dbo].[Completions 2017]
		where [field_code] is not NULL

end