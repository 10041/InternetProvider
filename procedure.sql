
use InternetProvider;

GO

CREATE PROCEDURE InsertUserType (@type nvarchar(50))
AS 
BEGIN TRY
	BEGIN TRAN
	INSERT INTO dbo.User_types (Type) 
	values (@type)
	commit tran;
END TRY
BEGIN CATCH
	if @@trancount > 0 rollback tran ; 
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
	if @@trancount > 0 rollback tran ; 
END CATCH;


exec AddUserType @type = 'admin';

exec InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 10.222, @speed = 10;

DROP PROCEDURE AddUserType;