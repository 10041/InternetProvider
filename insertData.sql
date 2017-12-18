
use InternetProvider;


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


exec dbo.InsertUserType @type = 'admin';
exec dbo.InsertUserType @type = 'user';

exec dbo.InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec dbo.InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec dbo.InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;

exec dbo.UpdateTariffs 'tariff1', 300, 10;
exec dbo.UpdateTariffs 'tariff2', 3000, 100;
exec dbo.UpdateTariffs 'tariff3', 30, 1;

exec dbo.TariffsDelete 'tariff4'

DECLARE @res int
exec @res = dbo.AddUser 'Andre', 
						'Oleksyuk',
						'Victorovich', 
						'22.10.1997', 
						'tariff1',
						'(29) 111-2233', 
						'andreyoleksyuk@gmail.com', 
						'AA:BB:CC:DD:EE:FF', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10041', 
						'12345', 
						253.932864, 
						27.428590
print @res
GO
DECLARE @res int
exec @res = dbo.AddUser 'Dima', 
						'Borisov', 
						'Borisovich', 
						'19.11.1997', 
						'tariff2',
						'(29) 106-5212', 
						'aa@gg.com', 
						'AA:BB:CC:DD:EE:EE', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10042', 
						'12345', 
						53.932888, 
						27.427590
print @res
GO
DECLARE @res int
exec @res = dbo.AddAdmin 'Max', 
						'La', 
						'LaLa', 
						'22.10.1997', 
						'tariff1',
						'(29) 106-5212', 
						'admin@admin.com', 
						'AA:BB:CC:DD:AE:EE', 
						'127.0.0.1', 
						'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF', 
						'10043', 
						'12345'
print @res

SELECT * FROM Tariffs;
SELECT * FROM User_types;

exec dbo.GetUserByLogin '10041'
exec dbo.GetAllUsers

exec dbo.UserPay '10041', 470
exec dbo.UserPay '10042', 101

exec dbo.CheckPay '10041'
exec dbo.CheckPay '10042'

exec dbo.GetStatusAccount '10042'

exec dbo.DailyPayment

exec dbo.GetAllUsers

exec dbo.DeleteUser '10041'
exec dbo.DeleteUser '10042'
exec dbo.DeleteUser '10043'
--exec dbo.GetAllUsers

exec dbo.GetUserByEmail 'andreyoleksyuk@gmail.com'
exec dbo.GetUserByMAC 'AA-BB-CC-DD-EE-E'

exec dbo.GetUserByName 'Andrey', 
						'Oleksyuk', 
						'Victorovich'
exec GetPaymentLog '10042'

exec UpdateAccount '10052', '54321'
exec UpdateUserTariff '10052', 'tariff1'
exec UpdatePhone '10052', '(222)555-9900'

--53.891492, 27.559753 (ул. Свердлова, 13А)
--53.932583, 27.428394 (ул. Каменногорская, 100)

exec UpdateLocation '10041', 53.891492, 27.559753
exec UpdateLocation '10042', 53.932583, 27.428394

exec DistanceFromUsers '10041', '10042'

exec NearestUsers '10041'
