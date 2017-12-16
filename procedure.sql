
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
	
	SELECT dbo.Tariffs.Tariff_ID 
		FROM dbo.Tariffs 
		WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
	IF(@@ROWCOUNT = 0)
		THROW 50002, '�� ������ ����� �����.', 1;

	BEGIN TRAN
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
IF OBJECT_ID('dbo.TariffsDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsDelete 
END 
GO
CREATE PROC dbo.TariffsDelete 
    @Tariff_name nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Tariffs
	WHERE  dbo.Tariffs.Tariff_name = @Tariff_name

	COMMIT
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

		IF(RTRIM(@Phone) NOT LIKE '(%)[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
				THROW 50003, '�������� ������ ������ �������� (����. (11)111-1111).', 1;
		IF(@Email NOT LIKE '%@%.%')
			THROW 50004, '�������� ������ �����.', 1;
		IF(@MAC NOT LIKE '[0-F][0-F]-[0-F][0-F]-[0-F][0-F]-[0-F][0-F]-[0-F][0-F]-[0-F][0-F]')
			THROW 50005, '�������� ������ MAC.', 1;
		IF(@Latitude NOT BETWEEN -90 AND 90)
			IF(@Longitude BETWEEN -180 AND 180)
				THROW 50006, '������[-90,90], �������[-180,180]', 1;

		DECLARE @count int;
		DECLARE @User_ID int;
		exec @count = dbo.CheckUserName @First_name, @Last_name, @Patronymic;
		IF(@count > 0)
			THROW 50001, '������������ � ����� ������ ��� ����������.', 1;

		DECLARE @Tariff_ID int;
		SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID 
			FROM dbo.Tariffs 
			WHERE dbo.Tariffs.Tariff_name = @Tariff_name;
		IF(@Tariff_ID is null)
			THROW 50002, '�� ������ ����� �����.', 1;

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
			THROW 50008, '����� ����������� ������������ �������� ��� ������������ user', 1;

		INSERT INTO dbo.Accounts(User_ID, Login, Password, IsActive, User_type_ID) 
			SELECT @User_ID, @Login, @Password, 0, @User_type_ID;

		DECLARE @g geography;
		SET @g = geography::Point(@Latitude, @Longitude, 4326);
		INSERT INTO dbo.Physical_addresses(User_ID, Location) 
			SELECT @User_ID, @g;
		
		COMMIT TRAN
		RETURN @User_ID;
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
		print @res
		IF(@res = 0)
			return 0

		DECLARE @User_type_ID tinyint
		SELECT @User_type_ID = User_type_ID 
			FROM dbo.User_types 
			WHERE dbo.User_types.Type = 'admin'
		IF(@User_type_ID is NULL)
			THROW 50008, '����� ����������� �������������� �������� ��� ������������ admin', 1;
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
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
IF OBJECT_ID('dbo.GetUserByLogin') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByLogin 
END
GO
CREATE PROC dbo.GetUserByLogin @Login nvarchar(50)
AS BEGIN
	SELECT dbo.Accounts.User_ID 
		FROM dbo.Accounts
		WHERE dbo.Accounts.Login = @Login
		IF(@@ROWCOUNT = 0)
			THROW 50007, '������ ������������ �� ����������', 1;
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Tariffs.Tariff_name,
			dbo.Phones.Phone,
			dbo.Emails.Email,
			dbo.Accounts.Login,
			dbo.Accounts.IsActive,
			dbo.Logical_addresses.MAC,
			dbo.Logical_addresses.IP_V4,
			dbo.Logical_addresses.IP_V6,
			dbo.Physical_addresses.Location
			FROM dbo.Users 
			INNER JOIN dbo.Tariffs ON dbo.Users.Tariff_ID = dbo.Tariffs.Tariff_ID
			INNER JOIN dbo.Phones ON dbo.Users.User_ID = dbo.Phones.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID AND
										dbo.Accounts.Login = @Login
END
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.GetAllUsers') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetAllUsers 
END
GO
CREATE PROC dbo.GetAllUsers 
AS BEGIN
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.User_types.Type,
			dbo.Tariffs.Tariff_name,
			(dbo.Tariffs.Monthly_payment / 30)[DailyPayment],
			dbo.Phones.Phone,
			dbo.Emails.Email,
			dbo.Accounts.Login,
			dbo.Accounts.Password,
			dbo.Accounts.IsActive,
			dbo.Logical_addresses.MAC,
			dbo.Logical_addresses.IP_V4,
			dbo.Logical_addresses.IP_V6,
			dbo.Physical_addresses.Location
			FROM dbo.Users 
			INNER JOIN dbo.Tariffs ON dbo.Users.Tariff_ID = dbo.Tariffs.Tariff_ID
			INNER JOIN dbo.Phones ON dbo.Users.User_ID = dbo.Phones.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID
			INNER JOIN dbo.User_types ON dbo.User_types.User_type_ID = dbo.Accounts.User_type_ID
END
			

GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

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
		THROW 50007, '������ ������ �� ����������', 1;
	return @Tariff_ID
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
	return 0
END CATCH
END

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

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
			DECLARE @User_ID int
			DECLARE @ResBalance real

			SELECT @User_ID = dbo.Accounts.User_ID 
			FROM dbo.Accounts
			WHERE dbo.Accounts.Login = @Login
			IF(@@ROWCOUNT = 0)
				THROW 50007, '������ ������������ �� ����������', 1;

			SELECT @ResBalance = dbo.Users.Payment_balance
			FROM dbo.Users
			WHERE dbo.Users.User_ID = @User_ID

			UPDATE dbo.Users
			SET dbo.Users.Payment_balance = @ResBalance + @Summ
			WHERE dbo.Users.User_ID = @User_ID

			INSERT INTO dbo.Payment_log(User_ID, Date_payment, Sum_payment)
			values(@User_ID, GETDATE(), @Summ)

			COMMIT TRAN
		RETURN 1
	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		rollback tran
		return 0
	END CATCH
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.CheckPay') IS NOT NULL
BEGIN 
    DROP PROC dbo.CheckPay 
END 
GO
CREATE PROC dbo.CheckPay @Login nvarchar(50)
AS
	BEGIN TRY
		SET NOCOUNT ON

		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
		DECLARE @User_ID int
		DECLARE @ResBalance real
		DECLARE @Monthly_payment real


		SELECT @User_ID = dbo.Accounts.User_ID 
		FROM dbo.Accounts
		WHERE dbo.Accounts.Login = @Login
		IF(@@ROWCOUNT = 0)
			THROW 50007, '������ ������������ �� ����������', 1;

		SELECT @ResBalance = dbo.Users.Payment_balance
		FROM dbo.Users
		WHERE dbo.Users.User_ID = @User_ID

		SELECT @Monthly_payment = dbo.Tariffs.Monthly_payment
		FROM dbo.Users
		INNER JOIN dbo.Tariffs ON dbo.Users.Tariff_ID = dbo.Tariffs.Tariff_ID
		WHERE dbo.Users.User_ID = @User_ID

		IF(@ResBalance-@Monthly_payment / 30 < 0)
			UPDATE dbo.Accounts SET dbo.Accounts.IsActive = 0 WHERE dbo.Accounts.Login = @Login
		ELSE
			UPDATE dbo.Accounts SET dbo.Accounts.IsActive = 1 WHERE dbo.Accounts.Login = @Login

		UPDATE dbo.Users 
		SET dbo.Users.Payment_balance = @ResBalance-@Monthly_payment / 30
		WHERE dbo.Users.User_ID = @User_ID

		COMMIT TRAN
		RETURN 1
	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		ROLLBACK TRAN
		RETURN 0
	END CATCH
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.DailyPayment') IS NOT NULL
BEGIN 
    DROP PROC dbo.DailyPayment 
END 
GO
CREATE PROC dbo.DailyPayment
AS
	BEGIN TRY
		SET NOCOUNT ON

		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN

		DECLARE getAllUsersCursor CURSOR 
		FOR SELECT dbo.Users.User_ID, dbo.Tariffs.Monthly_payment, dbo.Users.Payment_balance
			FROM dbo.Tariffs 
			INNER JOIN dbo.Users ON dbo.Tariffs.Tariff_ID = dbo.Users.Tariff_ID
			INNER JOIN dbo.Accounts ON dbo.Accounts.User_ID = dbo.Users.User_ID
			INNER JOIN dbo.User_types ON dbo.Accounts.User_type_ID = dbo.User_types.User_type_ID
			AND dbo.User_types.Type != 'admin'
		OPEN getAllUsersCursor
			IF(@@CURSOR_ROWS = 0)
				THROW 50008, '������������� ���.', 1;
			DECLARE @User_ID int,
					@Monthly_payment real,
					@Payment_balance real
			FETCH NEXT FROM getAllUsersCursor INTO @User_ID, @Monthly_payment, @Payment_balance
			WHILE @@FETCH_STATUS = 0
			BEGIN
			--------------------
			------- LOOP -------
				IF(@Payment_balance-@Monthly_payment / 30 < 0)
					UPDATE dbo.Accounts SET dbo.Accounts.IsActive = 0 WHERE dbo.Accounts.User_ID = @User_ID
				ELSE
					UPDATE dbo.Accounts SET dbo.Accounts.IsActive = 1 WHERE dbo.Accounts.User_ID = @User_ID

				UPDATE dbo.Users 
					SET dbo.Users.Payment_balance = @Payment_balance-@Monthly_payment / 30
					WHERE dbo.Users.User_ID = @User_ID

				FETCH NEXT FROM getAllUsersCursor INTO @User_ID, @Monthly_payment, @Payment_balance
			------- END -------
			-------------------
			END
		CLOSE getAllUsersCursor
		DEALLOCATE getAllUsersCursor;

		COMMIT TRAN
		RETURN 1
	END TRY
	BEGIN CATCH
		print error_number()
		print error_message()
		ROLLBACK TRAN
		RETURN 0
	END CATCH
----------------------------------------------------------------------------------------
--daily payment
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.GetStatusAccount') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetStatusAccount 
END 
GO
CREATE PROC dbo.GetStatusAccount @Login nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @Status int
	SELECT @Status = dbo.Accounts.IsActive 
		FROM dbo.Accounts
		WHERE dbo.Accounts.Login = @Login
	IF(@@ROWCOUNT = 0)
		THROW 50007, '������ ������������ �� ����������', 1;
	IF(@Status > 0)
		print 'Active'
	ELSE
		print 'Blocked'
	RETURN @Status
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
END CATCH
END

GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.DeleteUser') IS NOT NULL
BEGIN 
    DROP PROC dbo.DeleteUser 
END 
GO
CREATE PROC dbo.DeleteUser @Login nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON

END TRY
BEGIN CATCH
		print error_number()
		print error_message()
END CATCH
END


GO

use InternetProvider;


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
