use InternetProvider;

GO
IF OBJECT_ID('dbo.InsertUserType') IS NOT NULL
BEGIN 
    DROP PROC dbo.InsertUserType 
END 
GO
CREATE PROCEDURE dbo.InsertUserType (@type nvarchar(50))
AS 
BEGIN TRY
	SET NOCOUNT ON
	BEGIN TRAN
	INSERT INTO dbo.User_types (Type) values (@type)
	commit tran;
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
	if @@trancount > 0 rollback tran; 
END CATCH;

GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.InsertTariffs') IS NOT NULL
BEGIN 
    DROP PROC dbo.InsertTariffs 
END 
GO
CREATE PROCEDURE dbo.InsertTariffs (@Tariff_name nvarchar(50), @Monthly_payment real, @speed smallint)
AS
BEGIN TRY
	SET NOCOUNT ON
	BEGIN TRAN
	INSERT INTO dbo.Tariffs (Tariff_name, Monthly_payment, Speed) 
	values ( @Tariff_name, @Monthly_payment, @speed)
	commit tran;
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
	if @@trancount > 0 rollback tran; 
END CATCH;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.AddUser') IS NOT NULL
BEGIN 
    DROP PROC dbo.AddUser 
END 
GO
CREATE PROC dbo.AddUser		@First_name nvarchar(50), 
							@Last_name nvarchar(50), 
							@Patronymic nvarchar(50), 
							@BirthDay date,
							@Tariff_name nvarchar(50),
							@Phone nchar(15), 
							@Email nvarchar(50),
							@MAC nchar(17), 
							@IP_V4 nchar(15), 
							@IP_V6 nchar(39), 
							@Login nvarchar(50),
							@Password nvarchar(50),
							@Latitude float,
							@Longitude float
AS
	BEGIN TRY
		SET NOCOUNT ON 

		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN 

		IF(RTRIM(@Phone) NOT LIKE '(%) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
				THROW 50003, 'Неверный формат номера телефона (прим. (11)111-1111).', 1;
		IF(@Email NOT LIKE '%@%.%')
			THROW 50004, 'Неверный формат почты.', 1;
		IF(@MAC NOT LIKE '[0-F][0-F]:[0-F][0-F]:[0-F][0-F]:[0-F][0-F]:[0-F][0-F]:[0-F][0-F]')
			THROW 50005, 'Неверный формат MAC.', 1;
		IF(@Latitude NOT BETWEEN -90 AND 90)
			THROW 50006, 'Широта[-90,90], долгота[-180,180]', 1;
		IF(@Longitude NOT BETWEEN -180 AND 180)
			THROW 50006, 'Широта[-90,90], долгота[-180,180]', 1;

		DECLARE @count int;
		DECLARE @User_ID int;
		exec @count = dbo.CheckUserName @First_name, @Last_name, @Patronymic;
		IF(@count > 0)
			THROW 50001, 'Пользователь с таким именем уже существует.', 1;

		DECLARE @Tariff_ID int;
		SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID 
			FROM dbo.Tariffs 
			WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
		IF(@Tariff_ID is null)
			THROW 50002, 'Не найден такой тариф.', 1;

		INSERT INTO dbo.Users (BirthDay, First_name, Last_Name, Patronymic, Tariff_ID, Payment_balance)
			SELECT @BirthDay, @First_name, @Last_Name, @Patronymic, @Tariff_ID, 0;

		SET @User_ID = IDENT_CURRENT('Users');

		INSERT INTO dbo.Phones(User_ID, Phone)
			SELECT @User_ID, @Phone;

		INSERT INTO dbo.Emails(User_ID, Email) 
			SELECT @User_ID, @Email;

		INSERT INTO dbo.Logical_addresses(User_ID, MAC, IP_V4, IP_V6) 
			SELECT @User_ID, @MAC, @IP_V4, @IP_V6;

		DECLARE @User_type_ID tinyint
		SELECT @User_type_ID = User_type_ID 
			FROM dbo.User_types 
			WHERE dbo.User_types.Type = 'user'
		IF(@User_type_ID is NULL)
			THROW 50008, 'Перед добавлением пользователя добавьте тип пользователя user', 1;

		INSERT INTO dbo.Accounts(User_ID, Login, Password, IsActive, User_type_ID) 
			SELECT @User_ID, @Login, @Password, 0, @User_type_ID;

		DECLARE @g geography;
		SET @g = geography::Point(@Latitude, @Longitude, 4326);
		INSERT INTO dbo.Physical_addresses(User_ID, Location) 
			SELECT @User_ID, @g;
		
		COMMIT TRAN
		RETURN @User_ID;
		--Значения широты всегда находятся в интервале [-90, 90]. 
		--Все значения, находящиеся вне этого диапазона, вызывают исключение. 
		--Значения долготы всегда находятся в интервале [-180, 180].

	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
		return 0
	END CATCH

GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.AddAdmin') IS NOT NULL
BEGIN 
    DROP PROC dbo.AddAdmin 
END 
GO
CREATE PROC dbo.AddAdmin	@First_name nvarchar(50), 
							@Last_name nvarchar(50), 
							@Patronymic nvarchar(50), 
							@BirthDay date,
							@Tariff_name nvarchar(50),
							@Phone nchar(15), 
							@Email nvarchar(50),
							@MAC nchar(17), 
							@IP_V4 nchar(15), 
							@IP_V6 nchar(39), 
							@Login nvarchar(50),
							@Password nvarchar(50)
AS
	BEGIN TRY
		SET NOCOUNT ON
		DECLARE @res int
		exec @res = dbo.AddUser	@First_name, 
								@Last_name, 
								@Patronymic, 
								@BirthDay, 
								@Tariff_name, 
								@Phone, 
								@Email,
								@MAC,
								@IP_V4,
								@IP_V6,
								@Login,
								@Password,
								0,
								0
		IF(@res = 0)
			return 0

		DECLARE @User_type_ID tinyint
		SELECT @User_type_ID = User_type_ID 
			FROM dbo.User_types 
			WHERE dbo.User_types.Type = 'admin'
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
		IF(@User_type_ID is NULL)
			THROW 50008, 'Перед добавлением администратора добавьте тип пользователя admin', 1;

		UPDATE dbo.Accounts 
			SET dbo.Accounts.User_type_ID = @User_type_ID 
			WHERE dbo.Accounts.User_ID = @res
		COMMIT TRAN
		RETURN @res
	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
		return 0
	END CATCH
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.CheckUserName') IS NOT NULL
BEGIN 
    DROP PROC dbo.CheckUserName 
END 
GO
CREATE PROC dbo.CheckUserName	@First_name nvarchar(50),
								@Last_name nvarchar(50),
								@Patronymic nvarchar(50)
AS BEGIN
	SET NOCOUNT ON  
	DECLARE @count int
	DECLARE ChekName CURSOR LOCAL STATIC FOR 
		SELECT First_name, Last_name, Patronymic
		FROM dbo.Users
		WHERE dbo.Users.First_name = @First_name AND 
		dbo.Users.Last_Name = @Last_name AND
		dbo.Users.Patronymic = @Patronymic 

	OPEN ChekName
	SET @count = @@CURSOR_ROWS
	CLOSE ChekName
	DEALLOCATE ChekName;
	return @count
END

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO


IF OBJECT_ID('dbo.GetTariffID') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetTariffID 
END 
GO
CREATE PROC dbo.GetTariffID	@Tariff_name nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON 
	DECLARE @Tariff_ID tinyint
	SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID FROM dbo.Tariffs WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
	IF(@@ROWCOUNT = 0)
		THROW 50007, 'Такого тарифа не существует', 1;
	return @Tariff_ID
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
	return 0
END CATCH
END