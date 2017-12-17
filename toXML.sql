
USE InternetProvider;

IF OBJECT_ID('dbo.TariffsToXML') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsToXML 
END 
GO
CREATE PROC dbo.TariffsToXML
AS 
	SELECT 
		Tariff_ID,
		Tariff_name,
		Monthly_payment,
		Speed
	FROM Tariffs
	FOR XML PATH('Tariff'), ROOT('Tariffs')
GO

exec TariffsToXML

-------------------------------------------------------------------
-------------------------------------------------------------------

IF OBJECT_ID('dbo.TariffsFromXML') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsFromXML 
END 
GO
CREATE PROC dbo.TariffsFromXML
AS 
	DECLARE @x xml
	SELECT @x = P
	FROM OPENROWSET (BULK 'D:\WORK\Oracle\курсовой\InternetProvider\XML\Tariffs.xml', SINGLE_BLOB) AS Tariffs(P)
	DECLARE @hdoc int
	EXEC sp_xml_preparedocument @hdoc OUTPUT, @x
	SELECT *
	FROM OPENXML(@hdoc, '/Tariffs/Tariff', 2)
	WITH(
		Tariff_ID int,
		Tariff_name nvarchar(50),
		Monthly_payment real,
		Speed smallint
		)
GO

exec TariffsFromXML