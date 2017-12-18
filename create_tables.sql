

use InternetProvider;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Tariffs') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Tariffs
END 
GO
CREATE TABLE dbo.Tariffs(
	Tariff_ID int IDENTITY(1,1) PRIMARY KEY,
	Tariff_name nvarchar(50) NOT NULL UNIQUE,
	Monthly_payment real NOT NULL,
	Speed smallint NOT NULL,
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Users') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Users
END 
GO
CREATE TABLE dbo.Users(
	User_ID int IDENTITY(1,1) PRIMARY KEY,
	BirthDay date NOT NULL,
	First_name nvarchar(50) NOT NULL,
	Last_Name nvarchar(50) NOT NULL,
	Patronymic nvarchar(50) NOT NULL,
	Payment_balance real,
	Tariff_ID int,
	FOREIGN KEY (Tariff_ID) REFERENCES dbo.Tariffs(Tariff_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Phones') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Phones
END 
GO
CREATE TABLE dbo.Phones(
	Phone_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Phone nchar(15) NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Emails') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Emails
END 
GO
CREATE TABLE dbo.Emails(
	Email_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Email varchar(50) NOT NULL UNIQUE,
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Physical_addresses') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Physical_addresses
END 
GO
CREATE TABLE dbo.Physical_addresses(
	Ph_address_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Location geography NOT NULL,	
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Logical_addresses') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Logical_addresses
END 
GO
CREATE TABLE dbo.Logical_addresses(
	L_address int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	MAC nchar(17) NOT NULL,
	IP_V4 nchar(15) NOT NULL,
	IP_V6 nchar(39) NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Payment_log') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Payment_log
END 
GO
CREATE TABLE dbo.Payment_log(
	Log_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Date_payment datetime NOT NULL,
	Sum_payment real NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.User_types') IS NOT NULL
BEGIN 
    DROP TABLE dbo.User_types
END 
GO
CREATE TABLE dbo.User_types(
	User_type_ID tinyint IDENTITY(1,1) PRIMARY KEY,
	Type nvarchar(50) NOT NULL
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Accounts') IS NOT NULL
BEGIN 
    DROP TABLE dbo.Accounts
END 
GO
CREATE TABLE dbo.Accounts(
	Accounts_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Login nvarchar(50) NOT NULL UNIQUE,
	Password nvarchar(50) NOT NULL,
	IsActive bit NOT NULL,
	User_type_ID tinyint NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES dbo.Users(User_ID),
	FOREIGN KEY (User_type_ID) REFERENCES dbo.User_types(User_type_ID)
);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
USE InternetProvider;

go
DELETE FROM Physical_addresses;
DELETE FROM Logical_addresses;
DELETE FROM Payment_log;
DELETE FROM Accounts;
DELETE FROM Emails;
DELETE FROM Phones;
DELETE FROM Users;
DELETE FROM Tariffs;
DELETE FROM User_types;

GO

DBCC CHECKIDENT ('Physical_addresses', RESEED, 0);
DBCC CHECKIDENT ('Logical_addresses', RESEED, 0);
DBCC CHECKIDENT ('Payment_log', RESEED, 0);
DBCC CHECKIDENT ('Accounts', RESEED, 0);
DBCC CHECKIDENT ('Emails', RESEED, 0);
DBCC CHECKIDENT ('Phones', RESEED, 0);
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Tariffs', RESEED, 0);
DBCC CHECKIDENT ('User_types', RESEED, 0);

GO

DROP TABLE Physical_addresses;
DROP TABLE Logical_addresses;
DROP TABLE Payment_log;
DROP TABLE Accounts;
DROP TABLE Emails;
DROP TABLE Phones;
DROP TABLE Users;
DROP TABLE Tariffs;
DROP TABLE User_types;