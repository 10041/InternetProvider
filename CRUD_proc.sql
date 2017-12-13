USE InternetProvider;
GO

IF OBJECT_ID('dbo.AccountsSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.AccountsSelect 
END 
GO
CREATE PROC dbo.AccountsSelect 
    @Accounts_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Accounts_ID, Login, Password, User_ID, User_type_ID 
	FROM   dbo.Accounts 
	WHERE  (Accounts_ID = @Accounts_ID OR @Accounts_ID IS NULL) 

	COMMIT
GO
IF OBJECT_ID('dbo.AccountsInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.AccountsInsert 
END 
GO
CREATE PROC dbo.AccountsInsert 
    @Login nvarchar(50),
    @Password nvarchar(50),
    @User_ID int,
    @User_type_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO dbo.Accounts (Login, Password, User_ID, User_type_ID)
	SELECT @Login, @Password, @User_ID, @User_type_ID
	
	
	SELECT Accounts_ID, Login, Password, User_ID, User_type_ID
	FROM   dbo.Accounts
	WHERE  Accounts_ID = SCOPE_IDENTITY()
	
               
	COMMIT
GO
IF OBJECT_ID('dbo.AccountsUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.AccountsUpdate 
END 
GO
CREATE PROC dbo.AccountsUpdate 
    @Accounts_ID int,
    @Login nvarchar(50),
    @Password nvarchar(50),
    @User_ID int,
    @User_type_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Accounts
	SET    Login = @Login, Password = @Password, User_ID = @User_ID, User_type_ID = @User_type_ID
	WHERE  Accounts_ID = @Accounts_ID
	
	
	SELECT Accounts_ID, Login, Password, User_ID, User_type_ID
	FROM   dbo.Accounts
	WHERE  Accounts_ID = @Accounts_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.AccountsDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.AccountsDelete 
END 
GO
CREATE PROC dbo.AccountsDelete 
    @Accounts_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Accounts
	WHERE  Accounts_ID = @Accounts_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EmailsSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.EmailsSelect 
END 
GO
CREATE PROC dbo.EmailsSelect 
    @Email_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Email_ID, User_ID, Email 
	FROM   dbo.Emails 
	WHERE  (Email_ID = @Email_ID OR @Email_ID IS NULL) 

	COMMIT
GO
IF OBJECT_ID('dbo.EmailsInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.EmailsInsert 
END 
GO
CREATE PROC dbo.EmailsInsert 
    @User_ID int,
    @Email varchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO dbo.Emails (User_ID, Email)
	SELECT @User_ID, @Email
	
	
	SELECT Email_ID, User_ID, Email
	FROM   dbo.Emails
	WHERE  Email_ID = SCOPE_IDENTITY()
	
               
	COMMIT
GO
IF OBJECT_ID('dbo.EmailsUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.EmailsUpdate 
END 
GO
CREATE PROC dbo.EmailsUpdate 
    @Email_ID int,
    @User_ID int,
    @Email varchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Emails
	SET    User_ID = @User_ID, Email = @Email
	WHERE  Email_ID = @Email_ID
	
	
	SELECT Email_ID, User_ID, Email
	FROM   dbo.Emails
	WHERE  Email_ID = @Email_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.EmailsDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.EmailsDelete 
END 
GO
CREATE PROC dbo.EmailsDelete 
    @Email_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Emails
	WHERE  Email_ID = @Email_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Logical_addressesSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.Logical_addressesSelect 
END 
GO
CREATE PROC dbo.Logical_addressesSelect 
    @L_address int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT L_address, User_ID, MAC, IP_V4, IP_V6 
	FROM   dbo.Logical_addresses 
	WHERE  (L_address = @L_address OR @L_address IS NULL) 

	COMMIT
GO
IF OBJECT_ID('dbo.Logical_addressesInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.Logical_addressesInsert 
END 
GO
CREATE PROC dbo.Logical_addressesInsert 
    @User_ID int,
    @MAC nchar(17),
    @IP_V4 nchar(15),
    @IP_V6 nchar(39)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO dbo.Logical_addresses (User_ID, MAC, IP_V4, IP_V6)
	SELECT @User_ID, @MAC, @IP_V4, @IP_V6
	
	
	SELECT L_address, User_ID, MAC, IP_V4, IP_V6
	FROM   dbo.Logical_addresses
	WHERE  L_address = SCOPE_IDENTITY()
	
               
	COMMIT
GO
IF OBJECT_ID('dbo.Logical_addressesUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.Logical_addressesUpdate 
END 
GO
CREATE PROC dbo.Logical_addressesUpdate 
    @L_address int,
    @User_ID int,
    @MAC nchar(17),
    @IP_V4 nchar(15),
    @IP_V6 nchar(39)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Logical_addresses
	SET    User_ID = @User_ID, MAC = @MAC, IP_V4 = @IP_V4, IP_V6 = @IP_V6
	WHERE  L_address = @L_address
	
	
	SELECT L_address, User_ID, MAC, IP_V4, IP_V6
	FROM   dbo.Logical_addresses
	WHERE  L_address = @L_address	
	

	COMMIT
GO
IF OBJECT_ID('dbo.Logical_addressesDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.Logical_addressesDelete 
END 
GO
CREATE PROC dbo.Logical_addressesDelete 
    @L_address int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Logical_addresses
	WHERE  L_address = @L_address

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Payment_logSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.Payment_logSelect 
END 
GO
CREATE PROC dbo.Payment_logSelect 
    @Log_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Log_ID, User_ID, Date_payment, Sum_payment 
	FROM   dbo.Payment_log 
	WHERE  (Log_ID = @Log_ID OR @Log_ID IS NULL) 

	COMMIT
GO
IF OBJECT_ID('dbo.Payment_logInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.Payment_logInsert 
END 
GO
CREATE PROC dbo.Payment_logInsert 
    @User_ID int,
    @Date_payment datetime,
    @Sum_payment real
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO dbo.Payment_log (User_ID, Date_payment, Sum_payment)
	SELECT @User_ID, @Date_payment, @Sum_payment
	
	
	SELECT Log_ID, User_ID, Date_payment, Sum_payment
	FROM   dbo.Payment_log
	WHERE  Log_ID = SCOPE_IDENTITY()
	
               
	COMMIT
GO
IF OBJECT_ID('dbo.Payment_logUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.Payment_logUpdate 
END 
GO
CREATE PROC dbo.Payment_logUpdate 
    @Log_ID int,
    @User_ID int,
    @Date_payment datetime,
    @Sum_payment real
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Payment_log
	SET    User_ID = @User_ID, Date_payment = @Date_payment, Sum_payment = @Sum_payment
	WHERE  Log_ID = @Log_ID
	
	
	SELECT Log_ID, User_ID, Date_payment, Sum_payment
	FROM   dbo.Payment_log
	WHERE  Log_ID = @Log_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.Payment_logDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.Payment_logDelete 
END 
GO
CREATE PROC dbo.Payment_logDelete 
    @Log_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Payment_log
	WHERE  Log_ID = @Log_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.PhonesSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.PhonesSelect 
END 
GO
CREATE PROC dbo.PhonesSelect 
    @Phone_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Phone_ID, User_ID, Phone 
	FROM   dbo.Phones 
	WHERE  (Phone_ID = @Phone_ID OR @Phone_ID IS NULL) 

	COMMIT
GO
IF OBJECT_ID('dbo.PhonesInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.PhonesInsert 
END 
GO
CREATE PROC dbo.PhonesInsert 
    @User_ID int,
    @Phone nchar(15)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO dbo.Phones (User_ID, Phone)
	SELECT @User_ID, @Phone
	
	
	SELECT Phone_ID, User_ID, Phone
	FROM   dbo.Phones
	WHERE  Phone_ID = SCOPE_IDENTITY()
	
               
	COMMIT
GO
IF OBJECT_ID('dbo.PhonesUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.PhonesUpdate 
END 
GO
CREATE PROC dbo.PhonesUpdate 
    @Phone_ID int,
    @User_ID int,
    @Phone nchar(15)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Phones
	SET    User_ID = @User_ID, Phone = @Phone
	WHERE  Phone_ID = @Phone_ID
	
	
	SELECT Phone_ID, User_ID, Phone
	FROM   dbo.Phones
	WHERE  Phone_ID = @Phone_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.PhonesDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.PhonesDelete 
END 
GO
CREATE PROC dbo.PhonesDelete 
    @Phone_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Phones
	WHERE  Phone_ID = @Phone_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Physical_addressesSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.Physical_addressesSelect 
END 
GO
CREATE PROC dbo.Physical_addressesSelect 
    @Ph_address_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Ph_address_ID, User_ID, location 
	FROM   dbo.Physical_addresses 
	WHERE  (Ph_address_ID = @Ph_address_ID OR @Ph_address_ID IS NULL) 

	COMMIT
GO

IF OBJECT_ID('dbo.Physical_addressesUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.Physical_addressesUpdate 
END 
GO
CREATE PROC dbo.Physical_addressesUpdate 
    @Ph_address_ID int,
    @User_ID int,
    @location geography = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Physical_addresses
	SET    User_ID = @User_ID, location = @location
	WHERE  Ph_address_ID = @Ph_address_ID
	
	
	SELECT Ph_address_ID, User_ID, location
	FROM   dbo.Physical_addresses
	WHERE  Ph_address_ID = @Ph_address_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.Physical_addressesDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.Physical_addressesDelete 
END 
GO
CREATE PROC dbo.Physical_addressesDelete 
    @Ph_address_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Physical_addresses
	WHERE  Ph_address_ID = @Ph_address_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.TariffsSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsSelect 
END 
GO
CREATE PROC dbo.TariffsSelect 
    @Tariff_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Tariff_ID, Tariff_name, Monthly_payment, Speed 
	FROM   dbo.Tariffs 
	WHERE  (Tariff_ID = @Tariff_ID OR @Tariff_ID IS NULL) 

	COMMIT
GO

IF OBJECT_ID('dbo.TariffsUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsUpdate 
END 
GO
CREATE PROC dbo.TariffsUpdate 
    @Tariff_ID tinyint,
    @Tariff_name nvarchar(50),
    @Monthly_payment real,
    @Speed smallint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Tariffs
	SET    Tariff_name = @Tariff_name, Monthly_payment = @Monthly_payment, Speed = @Speed
	WHERE  Tariff_ID = @Tariff_ID
	
	
	SELECT Tariff_ID, Tariff_name, Monthly_payment, Speed
	FROM   dbo.Tariffs
	WHERE  Tariff_ID = @Tariff_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.TariffsDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.TariffsDelete 
END 
GO
CREATE PROC dbo.TariffsDelete 
    @Tariff_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Tariffs
	WHERE  Tariff_ID = @Tariff_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.User_typesSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.User_typesSelect 
END 
GO
CREATE PROC dbo.User_typesSelect 
    @User_type_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT User_type_ID, Type 
	FROM   dbo.User_types 
	WHERE  (User_type_ID = @User_type_ID OR @User_type_ID IS NULL) 

	COMMIT
GO

IF OBJECT_ID('dbo.User_typesUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.User_typesUpdate 
END 
GO
CREATE PROC dbo.User_typesUpdate 
    @User_type_ID tinyint,
    @Type nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.User_types
	SET    Type = @Type
	WHERE  User_type_ID = @User_type_ID
	
	
	SELECT User_type_ID, Type
	FROM   dbo.User_types
	WHERE  User_type_ID = @User_type_ID	
	

	COMMIT
GO
IF OBJECT_ID('dbo.User_typesDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.User_typesDelete 
END 
GO
CREATE PROC dbo.User_typesDelete 
    @User_type_ID tinyint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.User_types
	WHERE  User_type_ID = @User_type_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.UsersSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersSelect 
END 
GO
CREATE PROC dbo.UsersSelect 
    @User_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT User_ID, BirthDay, First_name, Last_Name, Patronymic, Payment_balance, Tariff_ID 
	FROM   dbo.Users 
	WHERE  (User_ID = @User_ID OR @User_ID IS NULL) 

	COMMIT
GO

IF OBJECT_ID('dbo.UsersUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersUpdate 
END 
GO
CREATE PROC dbo.UsersUpdate 
    @User_ID int,
    @BirthDay date,
    @First_name nvarchar(50),
    @Last_Name nvarchar(50),
    @Patronymic nvarchar(50),
    @Payment_balance real = NULL,
    @Tariff_ID tinyint = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE dbo.Users
	SET    BirthDay = @BirthDay, First_name = @First_name, Last_Name = @Last_Name, Patronymic = @Patronymic, Payment_balance = @Payment_balance, Tariff_ID = @Tariff_ID
	WHERE  User_ID = @User_ID
	
	
	SELECT User_ID, BirthDay, First_name, Last_Name, Patronymic, Payment_balance, Tariff_ID
	FROM   dbo.Users
	WHERE  User_ID = @User_ID	
	

	COMMIT

GO
IF OBJECT_ID('dbo.UsersDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersDelete 
END 
GO
CREATE PROC dbo.UsersDelete 
    @User_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   dbo.Users
	WHERE  User_ID = @User_ID

	COMMIT
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

use InternetProvider;