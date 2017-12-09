

use InternetProvider;

CREATE TABLE Tariffs(
	Tariff_ID tinyint IDENTITY(1,1) PRIMARY KEY,
	Tariff_name nvarchar(50) NOT NULL,
	Monthly_payment real NOT NULL,
	Speed smallint NOT NULL,
);

CREATE TABLE Users(
	User_ID int IDENTITY(1,1) PRIMARY KEY,
	BirthDay date NOT NULL,
	First_name nvarchar(50) NOT NULL,
	Last_Name nvarchar(50) NOT NULL,
	Patronymic nvarchar(50) NOT NULL,
	Payment_balance real,
	Tariff_ID tinyint,
	FOREIGN KEY (Tariff_ID) REFERENCES Tariffs(Tariff_ID)
);

CREATE TABLE Phones(
	Phone_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Phone nchar(15) NOT NULL,
	Priority bit NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Emails(
	Email_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Email varchar(50) NOT NULL,
	Priority bit NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Physical_addresses(
	Ph_address_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	location geometry,	
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Logical_addresses(
	L_address int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	MAC nchar(17) NOT NULL,
	IP_V4 nchar(15) NOT NULL,
	IP_V6 nchar(39) NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Payment_log(
	Log_ID int IDENTITY(1,1) PRIMARY KEY,
	User_ID int NOT NULL,
	Date_payment datetime NOT NULL,
	Sum_payment real NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE User_types(
	User_type_ID int IDENTITY(1,1) PRIMARY KEY,
	Type nvarchar(50) NOT NULL
);

CREATE TABLE Accounts(
	Accounts_ID int IDENTITY(1,1) PRIMARY KEY,
	Login nvarchar(50) NOT NULL,
	Password nvarchar(50) NOT NULL,
	User_ID int NOT NULL,
	User_type_ID int NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
	FOREIGN KEY (User_type_ID) REFERENCES User_types(User_type_ID)
);



DROP TABLE Physical_addresses;
DROP TABLE Logical_addresses;
DROP TABLE Payment_log;
DROP TABLE Accounts;
DROP TABLE Emails;
DROP TABLE Phones;
DROP TABLE Users;
DROP TABLE Tariffs;
DROP TABLE User_types;
