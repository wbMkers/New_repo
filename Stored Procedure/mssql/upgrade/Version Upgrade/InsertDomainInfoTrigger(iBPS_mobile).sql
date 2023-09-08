BEGIN
     IF EXISTS (SELECT 1 FROM sys.triggers WHERE Name = 'InsertDomainInfoData')
      BEGIN
         DROP TRIGGER InsertDomainInfoData
       END
END
~
 
CREATE TRIGGER InsertDomainInfoData ON IBPSUserDomainInfo
AFTER INSERT,UPDATE
AS
BEGIN
DECLARE @dbtype VARCHAR(50), @server VARCHAR(50)
	SELECT @dbtype = i.OFCABTYPE FROM inserted AS i
	SELECT @server = i.OFAPPSERVERTYPE FROM inserted AS i
	IF (NOT((@dbtype = 'mssql') 
		AND (@server = 'JBoss' or @server = 'JBossEAP' OR @server = 'WebLogic' 
				OR @server = 'WebSphere' OR @server = 'JTS')))
		BEGIN
			RAISERROR ('The DB type you have entered is invalid.' ,10,1)
			ROLLBACK TRANSACTION
		END
END