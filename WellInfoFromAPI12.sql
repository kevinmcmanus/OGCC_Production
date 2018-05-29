declare @api12 nvarchar(12)

set @api12 = '051233366100'

select * from [dbo].[Completions 2017] where
	api_county_code = substring(@api12,3,3)
and api_seq_num = substring(@api12, 6, 5)
and sidetrack_num = substring(@api12, 11,2)

--select count(*) from [dbo].[Completions 2017] where API_num is NULL