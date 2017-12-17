use InternetProvider;

GO
IF OBJECT_ID('dbo.UpdateTariffs') IS NOT NULL
BEGIN 
    DROP PROC dbo.UpdateTariffs 
END 
GO
CREATE PROCEDURE dbo.UpdateTariffs (@Tariff_name nvarchar(50), @New_Monthly_payment real, @New_speed smallint)
AS
BEGIN TRY
	SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN
	DECLARE @Tariff_ID int
	SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID 
		FROM dbo.Tariffs 
		WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
	IF(@@ROWCOUNT = 0)
		THROW 50002, 'Не найден такой тариф.', 1;

	
		UPDATE dbo.Tariffs 
			SET dbo.Tariffs.Monthly_payment = @New_Monthly_payment,
				dbo.Tariffs.Speed = @New_speed
			WHERE dbo.Tariffs.Tariff_name = @Tariff_name
	commit tran;
	return 1
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
	if @@trancount > 0 rollback tran; 
	return 0
END CATCH;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.UpdateUserTariff') IS NOT NULL
BEGIN 
    DROP PROC dbo.UpdateUserTariff 
END 
GO
CREATE PROC dbo.UpdateUserTariff	@Login nvarchar(50),
									@New_Tariff_name nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @User_ID int
	DECLARE @New_Tariff_ID int


	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login
	

	SELECT @New_Tariff_ID = dbo.Tariffs.Tariff_ID
	FROM dbo.Tariffs
	WHERE dbo.Tariffs.Tariff_name = @New_Tariff_name
	
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN
	IF(@User_ID is null)
		THROW 50007, 'Такого пользователя не существует', 1;
	IF(@New_Tariff_ID is null)
		THROW 50002, 'Не найден такой тариф.', 1;
	UPDATE dbo.Users SET dbo.Users.Tariff_ID = @New_Tariff_ID WHERE dbo.Users.User_ID = @User_ID
	COMMIT TRAN
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
		ROLLBACK TRAN
END CATCH
END
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.UpdateAccount') IS NOT NULL
BEGIN 
    DROP PROC dbo.UpdateAccount 
END 
GO
CREATE PROC dbo.UpdateAccount	@Login nvarchar(50),
								@New_Password nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @User_ID int

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login

	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN

	IF(@User_ID is null)
		THROW 50007, 'Такого пользователя не существует', 1;
	UPDATE dbo.Accounts SET dbo.Accounts.Password = @New_Password WHERE dbo.Accounts.User_ID = @User_ID
	COMMIT TRAN
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
END CATCH
END
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.UpdatePhone') IS NOT NULL
BEGIN 
    DROP PROC dbo.UpdatePhone 
END 
GO
CREATE PROC dbo.UpdatePhone	@Login nvarchar(50),
							@New_Phone nchar(15)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @User_ID int

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login

	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	IF(RTRIM(@New_Phone) NOT LIKE '(%)[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
		THROW 50003, 'Неверный формат номера телефона (прим. (11)111-1111).', 1;
	IF(@User_ID is null)
		THROW 50007, 'Такого пользователя не существует', 1;
	UPDATE dbo.Phones SET dbo.Phones.Phone = @New_Phone WHERE dbo.Phones.User_ID = @User_ID
	COMMIT TRAN
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
END CATCH
END
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.UpdateLocation') IS NOT NULL
BEGIN 
    DROP PROC dbo.UpdateLocation 
END 
GO
CREATE PROC dbo.UpdateLocation	@Login nvarchar(50),
								@New_Latitude float,
								@New_Longitude float
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @User_ID int
	DECLARE @g geography;

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login

	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	IF(@User_ID is null)
		THROW 50007, 'Такого пользователя не существует', 1;

	IF(@New_Latitude NOT BETWEEN -90 AND 90)
		THROW 50006, 'Широта[-90,90], долгота[-180,180]', 1;
	IF(@New_Longitude NOT BETWEEN -180 AND 180)
		THROW 50006, 'Широта[-90,90], долгота[-180,180]', 1;

	
	SET @g = geography::Point(@New_Latitude, @New_Longitude, 4326);
	UPDATE dbo.Physical_addresses 
	SET dbo.Physical_addresses.Location = @g 
	WHERE dbo.Physical_addresses.User_ID = @User_ID
	COMMIT TRAN
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
END CATCH
END