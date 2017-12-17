
use InternetProvider;

exec dbo.InsertUserType @type = 'admin';
exec dbo.InsertUserType @type = 'user';

exec dbo.InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec dbo.InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec dbo.InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;

exec dbo.UpdateTariffs 'tariff1', 300, 10;
exec dbo.UpdateTariffs 'tariff2', 3000, 100;
exec dbo.UpdateTariffs 'tariff3', 30, 1;

exec dbo.TariffsDelete 'tariff3'

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
exec dbo.UserPay '10052', 2

exec dbo.CheckPay '10051'
exec dbo.CheckPay '10052'

exec dbo.GetStatusAccount '10051'

exec dbo.DailyPayment

exec dbo.GetAllUsers

exec dbo.DeleteUser '10051'
exec dbo.GetAllUsers

exec dbo.GetUserByEmail 'aa@gg.om'
exec dbo.GetUserByMAC 'AA-BB-CC-DD-EE-E'

exec dbo.GetUserByName 'Andre', 
						'Laqrr', 
						'LaLaa'
exec GetPaymentLog '10052'

exec UpdateAccount '10052', '54321'
exec UpdateUserTariff '10052', 'tariff1'
exec UpdatePhone '10052', '(222)555-9900'

--53.891492, 27.559753 (ул. Свердлова, 13А)
--53.932583, 27.428394 (ул. Каменногорская, 100)

exec UpdateLocation '10051', 53.891492, 27.559753
exec UpdateLocation '10052', 53.932583, 27.428394

exec DistanceFromUsers '10051', '10052'