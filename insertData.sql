
use InternetProvider;

exec dbo.InsertUserType @type = 'admin';
exec dbo.InsertUserType @type = 'user';

exec dbo.InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec dbo.InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec dbo.InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;



DECLARE @res int
exec @res = dbo.AddUser 'Dima', 
						'Laqrr', 
						'LaLaa', 
						'22.10.1997', 
						'tariff2',
						'80291112233', 
						'ar5aaa@agg.com', 
						'AA-BB-CC-DD-EE-GG AA-BB-CC-DD-EE-GG', 
						'127.0.0.1', 
						'ip_v6', 
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
						'80291112233', 
						'aa@gg.com', 
						'AA-BB-CC-DD-EE-EE', 
						'127.0.0.1', 
						'ip_v6', 
						'10052', 
						'12345', 
						53.932888, 
						27.427590
print @res

SELECT * FROM Tariffs;
SELECT * FROM User_types;
SELECT * FROM Users;


exec dbo.GetUserByLogin '10051'
exec dbo.GetAllUsers