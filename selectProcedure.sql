use InternetProvider;

IF OBJECT_ID('dbo.GetUserByLogin') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByLogin 
END
GO
CREATE PROC dbo.GetUserByLogin @Login nvarchar(50)
AS BEGIN
BEGIN TRY
	DECLARE @User_ID int
	SELECT @User_ID = dbo.Accounts.User_ID 
		FROM dbo.Accounts
		WHERE dbo.Accounts.Login = @Login
		IF(@@ROWCOUNT = 0)
			THROW 50007, '“акого пользовател€ не существует', 1;
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Tariffs.Tariff_name,
			(dbo.Tariffs.Monthly_payment / 30)[DailyPayment],
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
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
END CATCH
END
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.GetUserByEmail') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByEmail 
END
GO
CREATE PROC dbo.GetUserByEmail @Email nvarchar(50)
AS BEGIN
BEGIN TRY
	DECLARE @User_ID int
	SELECT @User_ID = dbo.Emails.User_ID 
		FROM dbo.Emails
		WHERE dbo.Emails.Email = @Email
		IF(@@ROWCOUNT = 0)
			THROW 50010, 'ѕользовател€ с такой почтой не существует', 1;
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Tariffs.Tariff_name,
			(dbo.Tariffs.Monthly_payment / 30)[DailyPayment],
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
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID AND
				dbo.Emails.Email = @Email
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
END CATCH
END
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.GetUserByName') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByName 
END
GO
CREATE PROC dbo.GetUserByName	@First_name nvarchar(50), 
								@Last_name nvarchar(50), 
								@Patronymic nvarchar(50)
AS BEGIN
BEGIN TRY
	DECLARE @count int;
	exec @count = dbo.CheckUserName @First_name, @Last_name, @Patronymic;
	IF(@count = 0)
		THROW 50001, 'ѕользовател€ с таким именем не существует.', 1;
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Tariffs.Tariff_name,
			(dbo.Tariffs.Monthly_payment / 30)[DailyPayment],
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
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID 
			AND dbo.Users.First_name  = @First_name
			AND dbo.Users.Last_name  = @Last_name
			AND dbo.Users.Patronymic  = @Patronymic
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
END CATCH
END
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
GO
IF OBJECT_ID('dbo.GetUserByMAC') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetUserByMAC 
END
GO
CREATE PROC dbo.GetUserByMAC @MAC nvarchar(17)
AS BEGIN
BEGIN TRY
	DECLARE @User_ID int
	SELECT @User_ID = dbo.Logical_addresses.User_ID 
		FROM dbo.Logical_addresses
		WHERE dbo.Logical_addresses.MAC = @MAC
		IF(@@ROWCOUNT = 0)
			THROW 50011, 'ѕользовател€ с таким MAC не существует', 1;
	SELECT	dbo.Users.User_ID,
			dbo.Users.First_name,
			dbo.Users.Last_Name,
			dbo.Users.Patronymic,
			dbo.Users.BirthDay,
			dbo.Users.Payment_balance,
			dbo.Tariffs.Tariff_name,
			(dbo.Tariffs.Monthly_payment / 30)[DailyPayment],
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
			INNER JOIN dbo.Physical_addresses ON dbo.Users.User_ID = dbo.Physical_addresses.User_ID
			INNER JOIN dbo.Accounts ON dbo.Users.User_ID = dbo.Accounts.User_ID
			INNER JOIN dbo.Emails ON dbo.Users.User_ID = dbo.Emails.User_ID 
			INNER JOIN dbo.Logical_addresses ON dbo.Users.User_ID = dbo.Logical_addresses.User_ID
			AND dbo.Logical_addresses.MAC = @MAC
END TRY
BEGIN CATCH
	print error_number()
	print error_message()
END CATCH
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
			ORDER BY dbo.Users.User_ID
END
			

GO

----------------------------------------------------------------------------------------
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
		THROW 50007, '“акого пользовател€ не существует', 1;
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
IF OBJECT_ID('dbo.GetPaymentLog') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetPaymentLog 
END 
GO
CREATE PROC dbo.GetPaymentLog @Login nvarchar(50)
AS BEGIN
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @User_ID int

	SELECT @User_ID = dbo.Accounts.User_ID 
	FROM dbo.Accounts
	WHERE dbo.Accounts.Login = @Login
	IF(@@ROWCOUNT = 0)
		THROW 50007, '“акого пользовател€ не существует', 1;

	SELECT Date_payment, Sum_payment FROM dbo.Payment_log WHERE dbo.Payment_log.User_ID = @User_ID

END TRY
BEGIN CATCH
		print error_number()
		print error_message()
END CATCH
END
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

--use InternetProvider;