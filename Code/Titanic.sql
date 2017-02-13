
--https://www.mssqltips.com/sqlservertip/4126/sql-server-2016-r-services-executing-r-code-in-sql-server/
--https://msdn.microsoft.com/en-us/library/mt591989.aspx?f=255&MSPPError=-2147217396


declare @inputData nvarchar(max)
set @inputData =N'
SELECT * FROM [UCIrvine].[dbo].[Titanic];'

declare @script nvarchar(max)
set @script = N'
titanic <- InputDataSet;

titanic <- data.frame(titanic);
OutputDataSet <- head(titanic);'

EXECUTE sp_execute_external_script @language = N'R', @script = @script, @input_data_1 = @inputData


