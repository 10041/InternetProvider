
use InternetProvider;

GO

CREATE PROCEDURE InsertUserType (@type nvarchar(50))
AS 
BEGIN TRY
	BEGIN TRAN
	INSERT INTO dbo.User_types (Type) values (@type)
	commit tran;
END TRY
BEGIN CATCH
	if @@trancount > 0 rollback tran; 
END CATCH;

GO

CREATE PROCEDURE InsertTariffs (@Tariff_name nvarchar(50), @Monthly_payment real, @speed smallint)
AS
BEGIN TRY
	BEGIN TRAN
	INSERT INTO dbo.Tariffs (Tariff_name, Monthly_payment, Speed) 
	values ( @Tariff_name, @Monthly_payment, @speed)
	commit tran;
END TRY
BEGIN CATCH
	if @@trancount > 0 rollback tran; 
END CATCH;


CREATE PROCEDURE InsertUser(@First_name nvarchar(50), @Last_name nvarchar(50), @Patronymic nvarchar(50), @Phone int, @Email nvarchar(50), 



DROP PROCEDURE InsertUserType;
DROP PROCEDURE InsertTariffs;



GO;

DECLARE @g geography;  
DECLARE @h geography;  
SET @g = geography::Point(53.932864, 27.428590, 4326); 
SET @h = geography::Point(53.892033, 27.550501, 4326); 
SELECT @g.STDistance(@h);