

DECLARE @pathName NVARCHAR(512) 
SET @pathName = 'D:\BackupInternetProvider\db_backup_' + Convert(varchar(8), GETDATE(), 112) + '.bak' 
BACKUP DATABASE [InternetProvider] TO  DISK = @pathName WITH NOFORMAT, NOINIT,  NAME = N'db_backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
