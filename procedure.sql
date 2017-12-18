
use InternetProvider;

GO
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
				THROW 50007, 'Такого пользователя не существует', 1;

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
			THROW 50007, 'Такого пользователя не существует', 1;

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
				THROW 50008, 'Пользователей нет.', 1;
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
	DECLARE @User_ID int

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login
	IF(@@ROWCOUNT = 0)
		THROW 50007, 'Такого пользователя не существует', 1;

	DELETE FROM dbo.Accounts WHERE dbo.Accounts.User_ID = @User_ID
	DELETE FROM dbo.Emails WHERE dbo.Emails.User_ID = @User_ID
	DELETE FROM dbo.Phones WHERE dbo.Phones.User_ID = @User_ID
	DELETE FROM dbo.Physical_addresses WHERE dbo.Physical_addresses.User_ID = @User_ID
	DELETE FROM dbo.Payment_log WHERE dbo.Payment_log.User_ID = @User_ID
	DELETE FROM dbo.Logical_addresses WHERE dbo.Logical_addresses.User_ID = @User_ID
	DELETE FROM dbo.Users WHERE dbo.Users.User_ID = @User_ID

END TRY
BEGIN CATCH
		print error_number()
		print error_message()
END CATCH
END

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
IF OBJECT_ID('dbo.DistanceFromUsers') IS NOT NULL
BEGIN 
    DROP PROC dbo.DistanceFromUsers 
END 
GO
CREATE PROC dbo.DistanceFromUsers	@Login1 nvarchar(50),
									@Login2 nvarchar(50)
AS 
BEGIN TRY
	DECLARE @User_ID1 int, @User_ID2 int;
	DECLARE @loc1 geography, @loc2 geography;

	SELECT @User_ID1 = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login1
	IF(@User_ID1 is null)
		THROW 50007, 'Первого пользователя не существует', 1;

	SELECT @User_ID2 = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login2
	IF(@User_ID1 is null)
		THROW 50007, 'Второго пользователя не существует', 1;

	SELECT @loc1 = dbo.Physical_addresses.Location
	FROM dbo.Physical_addresses
	WHERE dbo.Physical_addresses.User_ID = @User_ID1

	SELECT @loc2 = dbo.Physical_addresses.Location
	FROM dbo.Physical_addresses
	WHERE dbo.Physical_addresses.User_ID = @User_ID2

	SELECT @loc1.STDistance(@loc2)[Distanse(m)];
	return @loc1.STDistance(@loc2);
END TRY
BEGIN CATCH
		print error_number()
		print error_message()
		return null
END CATCH
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.NearestUsers') IS NOT NULL
BEGIN 
    DROP PROC dbo.NearestUsers 
END 
GO
CREATE PROC dbo.NearestUsers	@Login nvarchar(50)
AS 
BEGIN TRY
	DECLARE @User_ID int
	DECLARE @loc geography

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login
	IF(@User_ID is null)
		THROW 50007, 'Такого пользователя не существует', 1;


	SELECT @loc = dbo.Physical_addresses.Location
	FROM dbo.Physical_addresses
	WHERE dbo.Physical_addresses.User_ID = @User_ID

	SELECT TOP(7) dbo.Accounts.Login, Physical_addresses.Location.ToString() 
	FROM dbo.Accounts 
	INNER JOIN dbo.Physical_addresses ON dbo.Accounts.User_ID = dbo.Physical_addresses.User_ID
	WHERE Location.STDistance(@loc) IS NOT NULL
	ORDER BY Location.STDistance(@loc)

END TRY
BEGIN CATCH
		print error_number()
		print error_message()
END CATCH


use InternetProvider;
