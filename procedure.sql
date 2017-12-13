
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
	BEGIN TRAN
	INSERT INTO dbo.User_types (Type) values (@type)
	commit tran;
END TRY
BEGIN CATCH
	if @@trancount > 0 rollback tran; 
END CATCH;

GO

IF OBJECT_ID('dbo.InsertTariffs') IS NOT NULL
BEGIN 
    DROP PROC dbo.InsertTariffs 
END 
GO
CREATE PROCEDURE dbo.InsertTariffs (@Tariff_name nvarchar(50), @Monthly_payment real, @speed smallint)
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

		DECLARE @count int;
		DECLARE @User_ID int;
		exec @count = dbo.CheckUserName @First_name, @Last_name, @Patronymic;
		IF(@count > 0)
			THROW 50001, '������������ � ����� ������ ��� ����������.', 1;

		DECLARE @Tariff_ID int;
		SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID FROM dbo.Tariffs WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
		IF(@Tariff_ID is null)
			THROW 50002, '�� ������ ����� �����', 1;

		--DECLARE GetIDFromTariffs CURSOR LOCAL STATIC FOR
		--SELECT dbo.Tariffs.Tariff_ID 
		--FROM dbo.Tariffs 
		--WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
		--OPEN GetIDFromTariffs
		--IF(@@CURSOR_ROWS = 1)
		--	FETCH GetIDFromTariffs INTO @Tariff_ID
		--ELSE
		--	THROW 50002, '�� ������ ����� �����', 1;
		--CLOSE GetIDFromTariffs
		--DEALLOCATE GetIDFromTariffs;

		INSERT INTO dbo.Users (BirthDay, First_name, Last_Name, Patronymic, Tariff_ID)
		SELECT @BirthDay, @First_name, @Last_Name, @Patronymic, @Tariff_ID;

		SET @User_ID = IDENT_CURRENT('Users');

		INSERT INTO dbo.Phones(User_ID, Phone)
		SELECT @User_ID, @Phone;

		INSERT INTO dbo.Emails(User_ID, Email) 
		SELECT @User_ID, @Email;

		INSERT INTO dbo.Logical_addresses(User_ID, MAC, IP_V4, IP_V6) 
		SELECT @User_ID, @MAC, @IP_V4, @IP_V6;



		INSERT INTO dbo.Accounts(User_ID, Login, Password, User_type_ID) 
		SELECT @User_ID, @Login, @Password, 2;

		DECLARE @g geography;
		SET @g = geography::Point(@Latitude, @Longitude, 4326);
		INSERT INTO dbo.Physical_addresses(User_ID, Location) 
		SELECT @User_ID, @g;
		
		COMMIT TRAN
		RETURN 1;
		--�������� ������ ������ ��������� � ��������� [-90, 90]. 
		--��� ��������, ����������� ��� ����� ���������, �������� ����������. 
		--�������� ������� ������ ��������� � ��������� [-180, 180].

	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
		return 0
	END CATCH

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

IF OBJECT_ID('dbo.GetUserByLogin') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByLogin 
END
GO
CREATE PROC dbo.GetUserByLogin @Login nvarchar(50)
AS 
	SELECT	dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Phones.Phone,
			dbo.Emails.Email,
			dbo.Logical_addresses.MAC,
			dbo.Logical_addresses.IP_V4,
			dbo.Logical_addresses.IP_V6,
			dbo.Accounts.Login,
			dbo.Physical_addresses.Location
			FROM dbo.Users 
			INNER JOIN dbo.Phones ON dbo.Users.User_ID = dbo.Phones.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID AND
										dbo.Accounts.Login = @Login

GO

IF OBJECT_ID('dbo.GetAllUsers') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetAllUsers 
END
GO
CREATE PROC dbo.GetAllUsers 
AS 
	SELECT	dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Phones.Phone,
			dbo.Emails.Email,
			dbo.Logical_addresses.MAC,
			dbo.Logical_addresses.IP_V4,
			dbo.Logical_addresses.IP_V6,
			dbo.Accounts.Login,
			dbo.Accounts.Password,
			dbo.Physical_addresses.Location
			FROM dbo.Users 
			INNER JOIN dbo.Phones ON dbo.Users.User_ID = dbo.Phones.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID

GO

IF OBJECT_ID('dbo.GetTariffID') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetTariffID 
END 
GO
CREATE PROC dbo.GetTariffID	@Tariff_name nvarchar(50)
AS BEGIN
	SET NOCOUNT ON 
	DECLARE @Tariff_ID tinyint
	SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID FROM dbo.Tariffs WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
	return @Tariff_ID
END

IF OBJECT_ID('dbo.UserPay') IS NOT NULL
BEGIN 
    DROP PROC dbo.UserPay 
END 
GO
CREATE PROCEDURE dbo.UserPay	@Login nvarchar(50),
								@Summ real
AS
	BEGIN TRY
		SET NOCOUNT ON 

		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN


	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
		return 1
	END CATCH



DECLARE @p1 float;
DECLARE @p2 float;
DECLARE @p3 float;
DECLARE @p4 float;
DECLARE @g geography;  
DECLARE @h geography;
SET @p1 = 53.932864;
SET @p2 = 27.428590;
SET @p3 = 53.892033;
SET @p4 = 27.550501;
SET @g = geography::Point(@p1, @p2, 4326); 
SET @h = geography::Point(@p3, @p4, 4326); 
SELECT @g.STDistance(@h);
