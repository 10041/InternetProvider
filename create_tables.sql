

use InternetProvider;

CREATE TABLE Users(
	User_ID int PRIMARY KEY,
	Ph_address_ID int NOT NULL,
	BirthDay date NOT NULL,
	First_name nvarchar(50) NOT NULL,
	Last_Name nvarchar(50) NOT NULL,
	Patronymic nvarchar(50) NOT NULL,
	Payment_balance real,
	Tariff_ID tinyint 
	);

DROP TABLE InternetProvider;