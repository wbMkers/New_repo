/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: UpgradeMessageIdLogId.sql (MS Sql Server)
	Author						: Sweta Bansal
	Date written (DD/MM/YYYY)	: 19/05/2014
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
19/05/2014	Sweta Bansal	Bug 45827 - (java.sql.SQLException: Arithmetic overflow error converting IDENTITY to data type int) in case of sql and (Numeric Overflow) error in case of oracle while running Message Agent.
21/09/2016	Ashutosh Pandey	Bug 64633 - Error Arithmetic overflow is coming in WFMovetoCurrentTouteLogTable when log id value exceeds INT range
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
_______________________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'UpgradeMessageIdLogId' AND xType = 'P')
BEGIN
	Drop Procedure UpgradeMessageIdLogId
	PRINT 'As Procedure UpgradeMessageIdLogId exists dropping old procedure ........... '
END

PRINT 'Creating procedure UpgradeMessageIdLogId ........... '
~

Create Procedure UpgradeMessageIdLogId AS
BEGIN
	Declare @constrnName  NVARCHAR(100)
	DECLARE @v_logStatus NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP06_003_MessageIdLogId'
	SET NOCOUNT ON
	
exec @v_logStatus= LogInsert 1,@v_scriptName,'INSERT Value in WFCabVersionTable for START of UpgradeMessageIdLogId.sql for SU6'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		BEGIN TRANSACTION trans
		EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''START of UpgradeMessageIdLogId.sql for SU6'', N''Y'')')
		COMMIT TRANSACTION trans
	END TRY
	BEGIN CATCH
				exec  @v_logStatus = LogFailed 1,@v_scriptName
				
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus= LogInsert 2,@v_scriptName,'Table WFMessageTable altered, Primary Key on WFMessageTable is dropped;Table WFMessageTable altered with Column MessageId changed to BIGINT;Table WFMessageTable altered, Primary Key created.'	
	BEGIN
	BEGIN TRY	

		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'WFMESSAGETABLE' and COLUMN_NAME= 'messageid' and data_type= 'bigint')
		BEGIN
			exec  @v_logStatus = LogSkip 2,@v_scriptName

			IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'WFMessageTable')
			BEGIN		
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'WFMessageTable' and constraint_type = 'PRIMARY KEY'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table WFMessageTable drop constraint ' + @constrnName)  
					PRINT 'Table WFMessageTable altered, Primary Key on WFMessageTable is dropped.'
				END

				SET @constrnName = ''
				Select @constrnName = index_name 
				from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  ,ic.index_column_id,
				ic.key_ordinal, ic.is_included_column  
				FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
				ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
				WHERE i.object_id = OBJECT_ID('WFMessageTable'))a where column_name = 'MessageId'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE('DROP INDEX ' + @constrnName + ' ON WFMessageTable')
					PRINT('Index Dropped on WFMessageTable')
				END
				
				EXECUTE('alter table WFMessageTable alter column MessageId BIGINT NOT NULL')
				PRINT 'Table WFMessageTable altered with Column MessageId changed to BIGINT'
				
				EXECUTE('ALTER TABLE WFMessageTable ADD PRIMARY KEY (MessageId)')
				PRINT 'Table WFMessageTable altered, Primary Key created.'
			END
		
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 2,@v_scriptName
		RAISERROR('Block 2 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 2,@v_scriptName

exec @v_logStatus= LogInsert 3,@v_scriptName,'Table WFFailedMessageTable altered with Column MessageId changed to BIGINT'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'WFFailedMessageTable' and COLUMN_NAME= 'MessageId' and data_type= 'bigint')
		BEGIN
			IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable')
			BEGIN
				exec  @v_logStatus = LogSkip 3,@v_scriptName	
				EXECUTE('alter table WFFailedMessageTable alter column MessageId BIGINT NOT NULL')
				PRINT 'Table WFFailedMessageTable altered with Column MessageId changed to BIGINT'
			END
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 3,@v_scriptName
		RAISERROR('Block 3 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 3,@v_scriptName

exec @v_logStatus= LogInsert 4,@v_scriptName,'Table WFCurrentRouteLogTable altered, Primary Key on WFCurrentRouteLogTable is dropped; Index on Logid Dropped from WFCURRENTROUTELOGTABLE; Table WFCurrentRouteLogTable altered with Column LogId changed to BIGINT; Table WFCurrentRouteLogTable altered, Primary Key created.'	
	BEGIN
	BEGIN TRY	
		
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'WFCURRENTROUTELOGTABLE' and COLUMN_NAME= 'LogId' and data_type= 'bigint')
		BEGIN
			exec  @v_logStatus = LogSkip 4,@v_scriptName

			IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'WFCurrentRouteLogTable')
			BEGIN		
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'WFCurrentRouteLogTable' and constraint_type = 'PRIMARY KEY'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table WFCurrentRouteLogTable drop constraint ' + @constrnName)  
					PRINT 'Table WFCurrentRouteLogTable altered, Primary Key on WFCurrentRouteLogTable is dropped.'
				END			
				
				SET @constrnName = ''
				Select @constrnName = index_name from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  
				,ic.index_column_id, ic.key_ordinal, ic.is_included_column  
				FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
				ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
				WHERE i.object_id = OBJECT_ID('WFCURRENTROUTELOGTABLE'))a where column_name = 'Logid'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE('DROP INDEX '+ @constrnName + ' ON WFCURRENTROUTELOGTABLE')
					PRINT 'Index on Logid Dropped from WFCURRENTROUTELOGTABLE'
				END
				
				EXECUTE('alter table WFCurrentRouteLogTable alter column LogId BIGINT NOT NULL')
				PRINT 'Table WFCurrentRouteLogTable altered with Column LogId changed to BIGINT'
				
				EXECUTE('ALTER TABLE WFCurrentRouteLogTable ADD PRIMARY KEY (LogId)')
				PRINT 'Table WFCurrentRouteLogTable altered, Primary Key created.'
			END
		
		
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 4,@v_scriptName
		RAISERROR('Block 4 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 4,@v_scriptName

exec @v_logStatus= LogInsert 5,@v_scriptName,'Table WFHistoryRouteLogTable altered, Primary Key on WFHistoryRouteLogTable is dropped; Index on Logid Dropped from WFHistoryRouteLogTable; Table WFHistoryRouteLogTable altered with Column LogId changed to BIGINT; Table WFHistoryRouteLogTable altered, Primary Key created.'	
	BEGIN
	BEGIN TRY	
				
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
			  from information_schema.columns  
			 where table_name = 'WFHistoryRouteLogTable' and COLUMN_NAME= 'LogId' and data_type= 'bigint')
			BEGIN
			exec  @v_logStatus = LogSkip 5,@v_scriptName

			IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'WFHistoryRouteLogTable')
			BEGIN		
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'WFHistoryRouteLogTable' and constraint_type = 'PRIMARY KEY'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table WFHistoryRouteLogTable drop constraint ' + @constrnName)  
					PRINT 'Table WFHistoryRouteLogTable altered, Primary Key on WFHistoryRouteLogTable is dropped.'
				END			
				
				SET @constrnName = ''
				Select @constrnName = index_name from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  
				,ic.index_column_id, ic.key_ordinal, ic.is_included_column  
				FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
				ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
				WHERE i.object_id = OBJECT_ID('WFHistoryRouteLogTable'))a where column_name = 'Logid'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE('DROP INDEX '+ @constrnName + ' ON WFHistoryRouteLogTable')
					PRINT 'Index on Logid Dropped from WFHistoryRouteLogTable'
				END
					
				EXECUTE('alter table WFHistoryRouteLogTable alter column LogId BIGINT NOT NULL')
				PRINT 'Table WFHistoryRouteLogTable altered with Column LogId changed to BIGINT'
				
				EXECUTE('ALTER TABLE WFHistoryRouteLogTable ADD PRIMARY KEY (LogId)')
				PRINT 'Table WFHistoryRouteLogTable altered, Primary Key created.'
			END
			
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 5,@v_scriptName
		RAISERROR('Block 5 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 5,@v_scriptName

exec @v_logStatus= LogInsert 6,@v_scriptName,'Table CurrentRouteLogTable altered, Primary Key on CurrentRouteLogTable is dropped; Index on Logid Dropped from CurrentRouteLogTable; Table CurrentRouteLogTable altered with Column LogId changed to BIGINT; Table CurrentRouteLogTable altered, Primary Key created'	
	BEGIN
	BEGIN TRY		
			
			IF NOT EXISTS (select column_name, data_type, character_maximum_length    
			  from information_schema.columns  
			 where table_name = 'CurrentRouteLogTable' and COLUMN_NAME= 'LogId' and data_type= 'bigint')
			BEGIN
				
					
				IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'CurrentRouteLogTable')
				BEGIN	
					exec  @v_logStatus = LogSkip 6,@v_scriptName
					SET @constrnName = ''
					SELECT @constrnName =  constraint_name 
					FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
					where table_name = 'CurrentRouteLogTable' and constraint_type = 'PRIMARY KEY'
					IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
					BEGIN
						EXECUTE ('alter table CurrentRouteLogTable drop constraint ' + @constrnName)  
						PRINT 'Table CurrentRouteLogTable altered, Primary Key on CurrentRouteLogTable is dropped.'
					END			
					
					SET @constrnName = ''
					Select @constrnName = index_name from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  
					,ic.index_column_id, ic.key_ordinal, ic.is_included_column  
					FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
					ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
					WHERE i.object_id = OBJECT_ID('CurrentRouteLogTable'))a where column_name = 'Logid'
					IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
					BEGIN
						EXECUTE('DROP INDEX '+ @constrnName + ' ON CurrentRouteLogTable')
						PRINT 'Index on Logid Dropped from CurrentRouteLogTable'
					END
				
					EXECUTE('alter table CurrentRouteLogTable alter column LogId BIGINT NOT NULL')
					PRINT 'Table CurrentRouteLogTable altered with Column LogId changed to BIGINT'
					
					EXECUTE('ALTER TABLE CurrentRouteLogTable ADD PRIMARY KEY (LogId)')
					PRINT 'Table CurrentRouteLogTable altered, Primary Key created.'
				END
			
			END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 6,@v_scriptName
		RAISERROR('Block 6 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 6,@v_scriptName

exec @v_logStatus= LogInsert 7,@v_scriptName,'Table HistoryRouteLogTable altered, Primary Key on HistoryRouteLogTable is dropped; Index on Logid Dropped from HistoryRouteLogTable; Table HistoryRouteLogTable altered with Column LogId changed to BIGINT; Table HistoryRouteLogTable altered, Primary Key created'	
	BEGIN
	BEGIN TRY		
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		from information_schema.columns  
		where table_name = 'HistoryRouteLogTable' and COLUMN_NAME= 'LogId' and data_type= 'bigint')
		BEGIN
			
			IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'HistoryRouteLogTable')
			BEGIN
				exec  @v_logStatus = LogSkip 7,@v_scriptName
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'HistoryRouteLogTable' and constraint_type = 'PRIMARY KEY'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table HistoryRouteLogTable drop constraint ' + @constrnName)  
					PRINT 'Table HistoryRouteLogTable altered, Primary Key on HistoryRouteLogTable is dropped.'
				END			
			
				SET @constrnName = ''
				Select @constrnName = index_name from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  
				,ic.index_column_id, ic.key_ordinal, ic.is_included_column  
				FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
				ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
				WHERE i.object_id = OBJECT_ID('HistoryRouteLogTable'))a where column_name = 'Logid'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE('DROP INDEX '+ @constrnName + ' ON HistoryRouteLogTable')
					PRINT 'Index on Logid Dropped from HistoryRouteLogTable'
				END
			
				EXECUTE('alter table HistoryRouteLogTable alter column LogId BIGINT NOT NULL')
				PRINT 'Table HistoryRouteLogTable altered with Column LogId changed to BIGINT'
			
				EXECUTE('ALTER TABLE HistoryRouteLogTable ADD PRIMARY KEY (LogId)')
				PRINT 'Table HistoryRouteLogTable altered, Primary Key created.'
			END
	
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 7,@v_scriptName
		RAISERROR('Block 7 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 7,@v_scriptName

exec @v_logStatus= LogInsert 8,@v_scriptName,'ALTER TABLE WFCRLTMigrationResults ALTER COLUMN minLogId BIGINT; ALTER TABLE WFCRLTMigrationResults ALTER COLUMN maxLogId BIGINT'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 8,@v_scriptName
		IF NOT EXISTS (SELECT * FROM SYSObjects WHERE NAME = 'WFCRLTMigrationResults')
		BEGIN
			CREATE TABLE WFCRLTMigrationResults (minLogId BIGINT, maxLogId BIGINT, migrationCount INTEGER, actionDateTime DATETIME)
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_name = 'WFCRLTMigrationResults' AND COLUMN_NAME = 'minLogId' AND data_type = 'BIGINT')
			BEGIN
				EXECUTE('ALTER TABLE WFCRLTMigrationResults ALTER COLUMN minLogId BIGINT')
			END
			IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_name = 'WFCRLTMigrationResults' AND COLUMN_NAME = 'maxLogId' AND data_type = 'BIGINT')
			BEGIN
				EXECUTE('ALTER TABLE WFCRLTMigrationResults ALTER COLUMN maxLogId BIGINT')
			END
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 8,@v_scriptName
		RAISERROR('Block 8 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 8,@v_scriptName

exec @v_logStatus= LogInsert 9,@v_scriptName,'INSERT Value in WFCabVersionTable for END of UpgradeMessageIdLogId.sql for SU6'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 9,@v_scriptName
		BEGIN TRANSACTION trans
		EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''END of UpgradeMessageIdLogId.sql for SU6'', N''Y'')')
		COMMIT TRANSACTION trans
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 9,@v_scriptName
		RAISERROR('Block 9 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 9,@v_scriptName

END;

~

PRINT 'Executing procedure UpgradeMessageIdLogId ........... '
EXEC UpgradeMessageIdLogId
~			

DROP PROCEDURE UpgradeMessageIdLogId

~

