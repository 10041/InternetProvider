
use InternetProvider;

exec InsertUserType @type = 'admin';
exec InsertUserType @type = 'user';

exec InsertTariffs @Tariff_name = 'tariff1', @Monthly_payment = 100, @speed = 10;
exec InsertTariffs @Tariff_name = 'tariff2', @Monthly_payment = 1000, @speed = 100;
exec InsertTariffs @Tariff_name = 'tariff3', @Monthly_payment = 10, @speed = 1;