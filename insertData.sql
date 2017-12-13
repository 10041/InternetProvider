
use InternetProvider;

exec dbo.InsertUserType @type = 'admin';
exec dbo.InsertUserType @type = 'user';

exec dbo.InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec dbo.InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec dbo.InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;

exec dbo.UsersInsert '10.11.1999', 'Andrey', 'Oleksyuk', 'Victorovich', 0, 1;

exec dbo.UsersDelete 6;

DECLARE @c int
exec @c = dbo.CheckUserName 'Andrey', 'Oleksyuk', 'Victorovich'
print @c

DECLARE @count int 
exec @count = dbo.CheckUserName 'Andrey', 'Oleksyuk', 'Victorovich'
print @count
IF(@count > 0)
print 'yest'
ELSE
print 'not'


BEGIN TRY
 THROW 222222222, 'Hello', 1;
END TRY
BEGIN CATCH
	print error_number()
END CATCH

print IDENT_CURRENT('Users');


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

SELECT * FROM Tariffs;
SELECT * FROM User_types;

DECLARE @Tariff_ID tinyint
		SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID FROM dbo.Tariffs WHERE dbo.Tariffs.Tariff_name = 'tariff2'
		print @Tariff_ID

INSERT INTO dbo.Users (BirthDay, First_name, Last_Name, Patronymic, Tariff_ID)
		SELECT '22.10.1997', 'a', 'a', 'a', @Tariff_ID


DECLARE @Tariff_ID tinyint
exec @Tariff_ID = GetTariffID 'tariff2'
print @Tariff_ID

DECLARE @Tariff_ID int;
SELECT @Tariff_ID = dbo.Tariffs.Tariff_ID FROM dbo.Tariffs WHERE dbo.Tariffs.Tariff_name = 'tariff2';
print @Tariff_ID

SELECT * FROM Users;

DECLARE @Tariff_ID int;
DECLARE GetIDFromTariffs CURSOR LOCAL STATIC FOR
		SELECT dbo.Tariffs.Tariff_ID 
		FROM dbo.Tariffs 
		WHERE dbo.Tariffs.Tariff_name = 'tariff2';
		OPEN GetIDFromTariffs
		IF(@@CURSOR_ROWS = 1)
			FETCH GetIDFromTariffs INTO @Tariff_ID
		ELSE
			THROW 50002, 'Не найден такой тариф', 1;
		CLOSE GetIDFromTariffs
		DEALLOCATE GetIDFromTariffs;
		print @Tariff_ID