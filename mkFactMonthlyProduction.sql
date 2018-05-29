USE [OilAndGas]
GO

/****** Object:  Table [dbo].[M_Producion_2017]    Script Date: 5/6/2018 3:58:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactMonthlyProduction](
	[ProdFactId] bigint identity(1,1) primary key, 
	[formation_code] [nvarchar](6) NULL,
	[well_status] [nvarchar](2) NULL,
	[prod_days] [float] NULL,
	[water_disp_code] [nvarchar](2) NULL,
	[water_vol] [float] NULL,
	[water_press_tbg] [float] NULL,
	[water_press_csg] [float] NULL,
	[bom_invent] [float] NULL,
	[oil_vol] [float] NULL,
	[oil_sales] [float] NULL,
	[adjustment] [float] NULL,
	[eom_invent] [float] NULL,
	[gravity_sales] [float] NULL,
	[gas_sales] [float] NULL,
	[flared] [float] NULL,
	[gas_vol] [float] NULL,
	[shrink] [float] NULL,
	[gas_prod] [float] NULL,
	[btu_sales] [float] NULL,
	[gas_press_tbg] [float] NULL,
	[gas_press_csg] [float] NULL,
	[operator_num] [nvarchar](10) NULL,
	[name] [nvarchar](50) NULL,
	[facility_name] [nvarchar](35) NULL,
	[facility_num] [nvarchar](15) NULL,
	[revised] [float] NULL,
	[API12] [nvarchar](12) NULL,
	[report_date] [date] NULL,
	[accepted_dt] [date] NULL
)

GO


