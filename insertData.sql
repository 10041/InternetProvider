
use InternetProvider;

exec dbo.InsertUserType @type = 'admin';
exec dbo.InsertUserType @type = 'user';

exec dbo.InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec dbo.InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec dbo.InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;

exec dbo.UpdateTariffs 'tariff1', 300, 10;
exec dbo.UpdateTariffs 'tariff2', 3000, 100;
exec dbo.UpdateTariffs 'tariff3', 30, 1;

DECLARE @res int
exec @res = dbo.AddUser 'Dima', 
						'Laqrr', 
						'LaLaa', 
						'22.10.1997', 
						'tariff2',
						'(29)111-2233', 
						'ar5aaa@agg.com', 
						'AA-BB-CC-DD-EE-FF', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10051', 
						'12345', 
						53.932864, 
						27.428590
print @res

DECLARE @res int
exec @res = dbo.AddUser 'Andrey', 
						'Laqrr', 
						'LaLaa', 
						'22.10.1997', 
						'tariff3',
						'(29)106-5212', 
						'aa@gg.com', 
						'AA-BB-CC-DD-EE-EE', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10052', 
						'12345', 
						53.932888, 
						27.427590
print @res

DECLARE @res int
exec @res = dbo.AddAdmin 'Andey', 
						'Laqr', 
						'LaLaa', 
						'22.10.1997', 
						'tariff1',
						'(29)106-5212', 
						'aa@gg.om', 
						'AA-BB-CC-DD-AE-EE', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10050', 
						'12345'
print @res

SELECT * FROM Tariffs;
SELECT * FROM User_types;
SELECT * FROM Users;

exec dbo.GetUserByLogin '10050'
exec dbo.GetAllUsers

exec dbo.UserPay '10051', 470
exec dbo.UserPay '10052', 20

exec dbo.CheckPay '10051'
exec dbo.CheckPay '10052'

exec dbo.GetStatusAccount '10052'

exec dbo.DailyPayment

exec dbo.GetAllUsers


DECLARE @User_ID int
			SELECT @User_ID = dbo.Accounts.User_ID 
			FROM dbo.Accounts
			WHERE dbo.Accounts.Login = '10052'
			print @User_ID


SELECT dbo.Tariffs.Monthly_payment
		FROM dbo.Users
		INNER JOIN dbo.Tariffs ON dbo.Users.Tariff_ID = dbo.Tariffs.Tariff_ID
		WHERE dbo.Users.User_ID = 1

SELECT dbo.Users.User_ID, dbo.Tariffs.Monthly_payment, dbo.Users.Payment_balance
		FROM dbo.Tariffs 
		INNER JOIN dbo.Users ON dbo.Tariffs.Tariff_ID = dbo.Users.Tariff_ID
		INNER JOIN dbo.Accounts ON dbo.Accounts.User_ID = dbo.Users.User_ID
		INNER JOIN dbo.User_types ON dbo.Accounts.User_type_ID = dbo.User_types.User_type_ID
		AND dbo.User_types.Type != 'admin'
