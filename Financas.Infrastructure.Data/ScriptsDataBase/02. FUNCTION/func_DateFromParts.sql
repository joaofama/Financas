USE [Financas]
GO
/****** Object:  UserDefinedFunction [dbo].[func_DateFromParts]    Script Date: 28/12/2016 14:10:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_DateFromParts]
(
    @Year INT,
    @Month INT,
    @DayOfMonth INT,
    @Hour INT = 0,  -- based on 24 hour clock (add 12 for PM :)
    @Min INT = 0,
    @Sec INT = 0
)
RETURNS DATETIME
AS
BEGIN

    RETURN DATEADD(second, @Sec, 
            DATEADD(minute, @Min, 
            DATEADD(hour, @Hour,
            DATEADD(day, @DayOfMonth - 1, 
            DATEADD(month, @Month - 1, 
            DATEADD(Year, @Year-1900, 0))))))

END

