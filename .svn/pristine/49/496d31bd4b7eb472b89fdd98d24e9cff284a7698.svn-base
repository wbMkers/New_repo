/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					:UpgradeDataTypesandChecks.sql (MSSQL Server)
	Author						: Chitvan Chhabra
	Date written (DD/MM/YYYY)	: 8/21/2014
	Description					: For creation of Indexes on  tables
	
Change Date		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover	Bug 62518 - Step by Step Debugs in Version Upgrade.
19/06/2017 Ashok Kumar			Bug 70151 - Primary key constraint violation while moving data from wfmailqueuetable to wfmailqueuehistorytable
________*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'UpgradeDataTypesandChecks' AND xType = 'P')
BEGIN
	Drop Procedure UpgradeDataTypesandChecks
	PRINT 'As Procedure UpgradeDataTypesandChecks exists dropping old procedure ........... '
END
~

PRINT 'Creating procedure UpgradeDataTypesandChecks ........... '
~


CREATE PROCEDURE UpgradeDataTypesandChecks
AS
BEGIN

	DECLARE @const_name VARCHAR(100)
	DECLARE @v_logStatus NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP06_002_DataTypesandChecks'
	SET NOCOUNT ON
	
exec @v_logStatus= LogInsert 1,@v_scriptName,'Inserting value in WFCabVersionTable for START of UpgradeDataTypesandChecks.sql for SU6'
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		BEGIN TRANSACTION trans
		EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''START of UpgradeDataTypesandChecks.sql for SU6'', N''Y'')')
		COMMIT TRANSACTION trans
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus= LogInsert 2,@v_scriptName,'Table ExceptionTable altered column ExceptionComments to NVarchar(1024)'	
	BEGIN
	BEGIN TRY
		IF EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExceptionTable')
		AND  NAME = 'ExceptionComments' )
		BEGIN
			IF NOT EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExceptionTable')
			AND  NAME = 'ExceptionComments' AND length=2048 AND type=39)
			BEGIN
				exec  @v_logStatus = LogSkip 2,@v_scriptName
				EXECUTE('ALTER TABLE ExceptionTable ALTER COLUMN ExceptionComments NVarchar(1024)')
				PRINT 'Table ExceptionTable altered column ExceptionComments to NVarchar(1024) '
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

exec @v_logStatus= LogInsert 3,@v_scriptName,'Table ExceptionHistoryTable altered column ExceptionComments to NVarchar(1024)'	
	BEGIN
	BEGIN TRY	
		IF EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExceptionHistoryTable')
		AND  NAME = 'ExceptionComments')
		BEGIN
			IF NOT EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExceptionHistoryTable')
			AND  NAME = 'ExceptionComments' AND length=2048 AND type=39)
			BEGIN
				exec  @v_logStatus = LogSkip 3,@v_scriptName
				EXECUTE('ALTER TABLE ExceptionHistoryTable ALTER COLUMN ExceptionComments NVarchar(1024)')
				PRINT 'Table ExceptionHistoryTable altered column ExceptionComments to NVarchar(1024) '
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

exec @v_logStatus= LogInsert 4,@v_scriptName,'Table TEMPLATEDEFINITIONTABLE altered column ArgList to NVarchar(2000) '	
	BEGIN
	BEGIN TRY
		IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'TEMPLATEDEFINITIONTABLE')
		AND  NAME = 'ArgList' )
		BEGIN
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'TEMPLATEDEFINITIONTABLE')
			AND  NAME = 'ArgList' AND length=4000 AND type=39)
			BEGIN
				exec  @v_logStatus = LogSkip 4,@v_scriptName
				EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ALTER COLUMN ArgList NVarchar(2000)')
				PRINT 'Table TEMPLATEDEFINITIONTABLE altered column ArgList to NVarchar(2000) '
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

exec @v_logStatus= LogInsert 5,@v_scriptName,'Table MAILTRIGGERTABLE altered column MailPriorityType to NVARCHAR(255)'	
	BEGIN
	BEGIN TRY
		IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
		AND  NAME = 'MailPriorityType' )
		BEGIN
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
			AND  NAME = 'MailPriorityType' AND length=510 AND type=39)
			BEGIN
				exec  @v_logStatus = LogSkip 5,@v_scriptName
				EXECUTE('ALTER TABLE MAILTRIGGERTABLE ALTER COLUMN MailPriorityType NVARCHAR(255)')
				PRINT 'Table MAILTRIGGERTABLE altered column MailPriorityType to NVARCHAR(255) '
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

exec @v_logStatus= LogInsert 6,@v_scriptName,'Table WFFormFragmentTable altered with Column FragmentName size as NVARCHAR(50),Column IsEncrypted size as NVARCHAR(1),Column StructureName size as NVARCHAR(128)'	
	BEGIN
	BEGIN TRY
		BEGIN
			IF EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
				AND  NAME='FragmentName'
				)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
					AND  NAME ='FragmentName' AND length =100 AND type=39
					)
					BEGIN
						exec  @v_logStatus = LogSkip 6,@v_scriptName
						EXECUTE('alter table WFFormFragmentTable alter column FragmentName	NVARCHAR(50)')
						PRINT 'Table WFFormFragmentTable altered with Column FragmentName size as NVARCHAR(50)'
					END	
			END
			
			IF EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
				AND  NAME ='IsEncrypted'
				)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
					AND  NAME ='IsEncrypted' AND length =2 AND type=39
					)
					BEGIN
						exec  @v_logStatus = LogSkip 6,@v_scriptName
						EXECUTE('alter table WFFormFragmentTable alter column IsEncrypted NVARCHAR(1)')
						PRINT 'Table WFFormFragmentTable altered with Column IsEncrypted size as NVARCHAR(1)'
					END
			END
			
			IF EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
				AND  NAME ='StructureName'
				)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
					AND  NAME ='StructureName' AND length =256 AND type=39
					)
					BEGIN
						exec  @v_logStatus = LogSkip 6,@v_scriptName
						EXECUTE('alter table WFFormFragmentTable alter column StructureName	NVARCHAR(128)')
						PRINT 'Table WFFormFragmentTable altered with Column StructureName size as NVARCHAR(128)'
					END
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

exec @v_logStatus= LogInsert 7,@v_scriptName,'Alter table ROUTEFOLDERDEFTABLE Alter columns (RouteFolderId,ScratchFolderId,WorkFlowFolderId,CompletedFolderId,DiscardFolderId) NVARCHAR(255) NOT NULL'	
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS(SELECT 1 FROM WFCabVersionTable WHERE CabVersion = '9.0_SharepointIntegration') /* Check entry in WFCabVersionTable */
		BEGIN
			
			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
			AND  NAME = 'RouteFolderId'
			)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
				AND  NAME ='RouteFolderId' AND length =510 AND type=39
				)
				BEGIN
					exec  @v_logStatus = LogSkip 7,@v_scriptName
					EXECUTE('ALter table ROUTEFOLDERDEFTABLE Alter column RouteFolderId NVARCHAR(255) NOT NULL')
				END
			END

			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
			AND  NAME = 'ScratchFolderId'
			)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
				AND  NAME ='ScratchFolderId' AND length =510 AND type=39
				)
				BEGIN
					exec  @v_logStatus = LogSkip 7,@v_scriptName
					EXECUTE('ALter table ROUTEFOLDERDEFTABLE Alter column ScratchFolderId NVARCHAR(255) NOT NULL') 
				END
			END

			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
			AND  NAME = 'WorkFlowFolderId'
			)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
				AND  NAME ='WorkFlowFolderId' AND length =510 AND type=39
				)
				BEGIN
					exec  @v_logStatus = LogSkip 7,@v_scriptName
					EXECUTE('ALter table ROUTEFOLDERDEFTABLE Alter column WorkFlowFolderId NVARCHAR(255) NOT NULL')
				END
			END

			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
			AND  NAME = 'CompletedFolderId'
			)
			BEGIN	
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
				AND  NAME ='CompletedFolderId' AND length =510 AND type=39
				)
				BEGIN
					exec  @v_logStatus = LogSkip 7,@v_scriptName
					EXECUTE('ALter table ROUTEFOLDERDEFTABLE Alter column CompletedFolderId NVARCHAR(255) NOT NULL')
				END
			END

			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
			AND  NAME = 'DiscardFolderId'
			)
			BEGIN
				IF NOT EXISTS ( SELECT 1 FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ROUTEFOLDERDEFTABLE')
				AND  NAME ='DiscardFolderId' AND length =510 AND type=39
				)
				BEGIN
					exec  @v_logStatus = LogSkip 7,@v_scriptName
					EXECUTE('ALter table ROUTEFOLDERDEFTABLE Alter column DiscardFolderId NVARCHAR(255) NOT NULL')
				END
				
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SharepointIntegration'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
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

exec @v_logStatus= LogInsert 8,@v_scriptName,'Inserting value in WFCabVersionTable,ALter table WFSystemServicesTable Alter column RegInfo '	
	BEGIN
	BEGIN TRY	
		
		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '9.0_WFSystemServicesTable') /* Check entry in WFCabVersionTable */
		BEGIN
			IF EXISTS ( SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSystemServicesTable')
			AND  NAME = 'RegInfo'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 8,@v_scriptName
				EXECUTE('ALter table WFSystemServicesTable Alter column RegInfo NTEXT')
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_WFSystemServicesTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
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

exec @v_logStatus= LogInsert 9,@v_scriptName,'Table WORKWITHPSTABLE altered Column LockedByName'	
	BEGIN
	BEGIN TRY
		IF EXISTS(SELECT * FROM SYSObjects 
				WHERE NAME = 'WORKWITHPSTABLE' AND xType = 'U')
		BEGIN
			exec  @v_logStatus = LogSkip 9,@v_scriptName
			EXECUTE('Alter table WORKWITHPSTABLE Alter column LockedByName NVARCHAR(200)')
			PRINT 'Table WORKWITHPSTABLE altered Column LockedByName'
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 9,@v_scriptName
		RAISERROR('Block 9 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 9,@v_scriptName

exec @v_logStatus= LogInsert 10,@v_scriptName,'Table PSREGISTERATIONTABLE altered Column PSNAME'	
	BEGIN
	BEGIN TRY
		DECLARE @keycount INTEGER;
		SELECT @keycount = count(1)
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
		INNER JOIN
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
        ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND
        TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME AND 
        KU.table_name='PSREGISTERATIONTABLE'
		WHERE column_name in ('PSNAME','Type')
		If @keycount = 2
		print 'PSREGISTERATIONTABLE already having COMPOSITE PRIMARY KEY of PSNAME ,Type'
		else
		BEGIN
			exec  @v_logStatus = LogSkip 10,@v_scriptName
			SELECT @const_name  = CONSTRAINT_NAME  FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  
			WHERE TABLE_NAME = 'PSREGISTERATIONTABLE' AND COLUMN_NAME = 'PSNAME' 
			EXECUTE('Alter table PSREGISTERATIONTABLE drop constraint '+ @const_name )
			EXECUTE('Alter table PSREGISTERATIONTABLE Add PRIMARY KEY(PSNAME,Type)' )
		END
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PSREGISTERATIONTABLE')
				AND  NAME = 'PSNAME' AND length = 400 AND TYPE = 39)
		BEGIN
			EXECUTE('Alter table PSREGISTERATIONTABLE Alter column PSNAME NVARCHAR(200) NOT NULL')
			PRINT 'Table PSREGISTERATIONTABLE altered Column PSNAME'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 10,@v_scriptName
		RAISERROR('Block 10 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 10,@v_scriptName

exec @v_logStatus= LogInsert 11,@v_scriptName,'Table wfexportinfotable altered'	
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS (select * from information_schema.columns where column_name = 'TargetCabinetName' and IS_NULLABLE = 'NO')
		BEGIN
			exec  @v_logStatus = LogSkip 11,@v_scriptName
			EXECUTE('Alter Table wfexportinfotable Alter Column TARGETCABINETNAME nvarchar(255) null')
			EXECUTE('alter table wfexportinfotable alter column TARGETUSERNAME nvarchar(200) NULL')
			PRINT 'Table wfexportinfotable altered'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 11,@v_scriptName
		RAISERROR('Block 11 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 11,@v_scriptName

exec @v_logStatus= LogInsert 12,@v_scriptName,'Table WFMailQueuetable altered column attachmentISIndex with new size'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'attachmentISINDEX')
		BEGIN
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
			AND  NAME = 'attachmentISINDEX' AND length = 2000 AND TYPE = 39)
			BEGIN
				exec  @v_logStatus = LogSkip 12,@v_scriptName	
				EXECUTE('ALTER TABLE WFMAILQUEUETABLE ALTER COLUMN attachmentISINDEX NVARCHAR(1000)')
				PRINT 'Table WFMailQueuetable altered column attachmentISIndex with new size '
			END
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 12,@v_scriptName
		RAISERROR('Block 12 Failed.',16,1)
		exec @v_logStatus = LogUpdate 12,@v_scriptName
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 12,@v_scriptName

exec @v_logStatus= LogInsert 13,@v_scriptName,'Table WFMailQueuetable altered column attachmentNames with new size'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'attachmentNames' AND length = 2000 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 13,@v_scriptName	
			EXECUTE('ALTER TABLE WFMAILQUEUETABLE ALTER COLUMN attachmentNames NVARCHAR(1000)')
			PRINT 'Table WFMailQueuetable altered column attachmentNames with new size '
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 13,@v_scriptName
		RAISERROR('Block 13 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 13,@v_scriptName

exec @v_logStatus= LogInsert 14,@v_scriptName,'Table WFMailQueueHistorytable altered column attachmentISIndex with new size'	
	BEGIN
	BEGIN TRY
	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE')
		AND  NAME = 'attachmentISINDEX' AND length = 2000 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 14,@v_scriptName		
			EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ALTER COLUMN attachmentISINDEX NVARCHAR(1000)')
			PRINT 'Table WFMailQueueHistorytable altered column attachmentISIndex with new size '
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 14,@v_scriptName
		RAISERROR('Block 14 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 14,@v_scriptName

exec @v_logStatus= LogInsert 15,@v_scriptName,'Table WFMailQueueHistorytable altered column attachmentNames with new size'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE')
		AND  NAME = 'attachmentNames' AND length = 2000 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 15,@v_scriptName	
			EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ALTER COLUMN attachmentNames NVARCHAR(1000)')
			PRINT 'Table WFMailQueueHistorytable altered column attachmentNames with new size '
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 15,@v_scriptName
		RAISERROR('Block 15 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 15,@v_scriptName

exec @v_logStatus= LogInsert 16,@v_scriptName,'Table WFFailedMessageTable altered with Column status size increased to 50'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable')
		AND  NAME = 'status' AND length = 100 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 16,@v_scriptName
			EXECUTE('Alter Table WFFailedMessageTable Alter Column status NVARCHAR(50)')
			PRINT 'Table WFFailedMessageTable altered with Column status size increased to 50'
		END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 16,@v_scriptName
		RAISERROR('Block 16 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 16,@v_scriptName

exec @v_logStatus= LogInsert 17,@v_scriptName,'Table WFAdminLogTable altered with Column newvalue size increased to 2000,Table DOCUMENTTYPEDEFTABLE altered with DCNAME  size increased to 250,Table EXTDBCONFTABLE altered with SORTINGCOLUMN  size increased to 255'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFADMINLOGTABLE')
		AND  NAME = 'NEWVALUE' AND length = 4000 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 17,@v_scriptName
			ALTER TABLE WFADMINLOGTABLE ALTER COLUMN NEWVALUE NVARCHAR(2000)
			PRINT 'Table WFAdminLogTable altered with Column newvalue size increased to 2000'

		END

		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'DOCUMENTTYPEDEFTABLE')
		AND  NAME = 'DCNAME' AND length = 500 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 17,@v_scriptName
			ALTER TABLE DOCUMENTTYPEDEFTABLE ALTER Column DCNAME NVARCHAR(250)
			PRINT 'Table DOCUMENTTYPEDEFTABLE altered with DCNAME  size increased to 250'
		END

		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBCONFTABLE')
		AND  NAME = 'SORTINGCOLUMN' AND length = 510 AND TYPE = 39)
		BEGIN
			exec  @v_logStatus = LogSkip 17,@v_scriptName
			ALTER TABLE EXTDBCONFTABLE ALTER COLUMN SORTINGCOLUMN NVARCHAR(255)
			PRINT 'Table EXTDBCONFTABLE altered with SORTINGCOLUMN  size increased to 255'
		END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 17,@v_scriptName
		RAISERROR('Block 17 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 17,@v_scriptName

exec @v_logStatus= LogInsert 18,@v_scriptName,'Recreating new wfmailqueuetable with nText '	
	BEGIN
	BEGIN TRY	
			
		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'WFMAILQUEUETABLE2'
			   
		)
		BEGIN
			exec  @v_logStatus = LogSkip 18,@v_scriptName
			DROP TABLE WFMAILQUEUETABLE2 
		
		END
	
		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'wfmailqueuetable'
			   and data_type = 'text'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 19,@v_scriptName
		
		--PRINT 'Original wfmailqueuetable renamed to wfmailqueuetable_old'
		
			CREATE TABLE WFMAILQUEUETABLE2(
					TaskId 			INTEGER		PRIMARY KEY IDENTITY(1,1),
					mailFrom 		NVARCHAR(255),
					mailTo 			NVARCHAR(2000), 
					mailCC 			NVARCHAR(2000), 
					mailSubject 		NVARCHAR(255),
					mailMessage		NText,
					mailContentType		NVARCHAR(64),
					attachmentISINDEX 	NVARCHAR(1000),
					attachmentNames		NVARCHAR(1000), 
					attachmentExts		NVARCHAR(128),	
					mailPriority		INTEGER, 
					mailStatus		NVARCHAR(1),
					statusComments		NVARCHAR(512),
					lockedBy		NVARCHAR(255),
					successTime		DATETIME,
					LastLockTime		DATETIME,
					insertedBy		NVARCHAR(255),
					mailActionType		NVARCHAR(20),
					insertedTime		DATETIME,
					processDefId		INTEGER,
					processInstanceId	NVARCHAR(63),
					workitemId		INTEGER,
					activityId		INTEGER,
					noOfTrials		INTEGER		default 0,
					zipFlag 			nvarchar(1)		NULL,
					zipName 			nvarchar(255)	NULL,
					maxZipSize 			int				NULL,
					alternateMessage 	ntext			NULL,
					mailBCC 					NVARCHAR(512)
			) 
		
			PRINT 'New wfmailqueuetable created with nText'
			insert into wfmailqueuetable2 (mailFrom, mailTo, mailCC, mailSubject, mailMessage, 		 mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, 	 statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, 	 processDefId,	processInstanceId, workitemId, activityId, noOfTrials,mailBCC) 
			 select mailFrom, mailTo, mailCC, mailSubject, mailMessage, mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, processDefId,	processInstanceId, workitemId, activityId, noOfTrials,mailBCC from wfmailqueuetable 
			 
			drop table  wfmailqueuetable
			EXECUTE(' sp_rename wfmailqueuetable2,wfmailqueuetable ')	 
			if exists(select 1 from information_schema.columns where table_name = 'wfmailqueuehistorytable_ofupgrd')
			begin
				EXECUTE ('drop table  wfmailqueuehistorytable_ofupgrd')	
			end
			EXECUTE(' sp_rename wfmailqueuehistorytable, wfmailqueuehistorytable_ofupgrd')
			CREATE TABLE WFMAILQUEUEHISTORYTABLE(
				TaskId 			BIGINT		PRIMARY KEY,
				mailFrom 		NVARCHAR(255),
				mailTo 			NVARCHAR(512), 
				mailCC 			NVARCHAR(512), 
				mailBCC 		NVARCHAR(512),	
				mailSubject 		NVARCHAR(255),
				mailMessage		NText,
				mailContentType		NVARCHAR(64),
				attachmentISINDEX 	NVARCHAR(1000), 
				attachmentNames		NVARCHAR(1000), 
				attachmentExts		NVARCHAR(128),	
				mailPriority		INTEGER, 
				mailStatus		NVARCHAR(1),
				statusComments		NVARCHAR(512),
				lockedBy		NVARCHAR(255),
				successTime		DATETIME,
				LastLockTime		DATETIME,
				insertedBy		NVARCHAR(255),
				mailActionType		NVARCHAR(20),
				insertedTime		DATETIME,
				processDefId		INTEGER,
				processInstanceId	NVARCHAR(63),
				workitemId		INTEGER,
				activityId		INTEGER,
				noOfTrials		INTEGER		default 0,
				alternateMessage ntext			NULL
			)
			PRINT 'Table wfmailqueuetable updated successfully'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 18,@v_scriptName
		RAISERROR('Block 18 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 18,@v_scriptName

exec @v_logStatus= LogInsert 19,@v_scriptName,'Recreating wfmailqueuetable with column zipFlag,zipName,maxZipSize,alternateMessage '	
	BEGIN
	BEGIN TRY
		IF EXISTS(
			   select * from information_schema.columns where table_name = 'wfmailqueuetable'
				and column_name not in ('zipFlag','zipName','maxZipSize','alternateMessage')
		)
		BEGIN
			
			IF EXISTS(
			   select * from information_schema.columns where table_name = 'wfmailqueuetable2'
			)
			BEGIN
			
			
			   drop table wfmailqueuetable2 
			END
			
			
			exec  @v_logStatus = LogSkip 19,@v_scriptName
			--PRINT 'Original wfmailqueuetable renamed to wfmailqueuetable_old'
			
				CREATE TABLE WFMAILQUEUETABLE2(
						TaskId 			INTEGER		PRIMARY KEY IDENTITY(1,1),
						mailFrom 		NVARCHAR(255),
						mailTo 			NVARCHAR(512), 
						mailCC 			NVARCHAR(512), 
						mailSubject 		NVARCHAR(255),
						mailMessage		NText,
						mailContentType		NVARCHAR(64),
						attachmentISINDEX 	NVARCHAR(1000),
						attachmentNames		NVARCHAR(1000),
						attachmentExts		NVARCHAR(128),	
						mailPriority		INTEGER, 
						mailStatus		NVARCHAR(1),
						statusComments		NVARCHAR(512),
						lockedBy		NVARCHAR(255),
						successTime		DATETIME,
						LastLockTime		DATETIME,
						insertedBy		NVARCHAR(255),
						mailActionType		NVARCHAR(20),
						insertedTime		DATETIME,
						processDefId		INTEGER,
						processInstanceId	NVARCHAR(63),
						workitemId		INTEGER,
						activityId		INTEGER,
						noOfTrials		INTEGER		default 0,
						zipFlag 			nvarchar(1)		NULL,
						zipName 			nvarchar(255)	NULL,
						maxZipSize 			int				NULL,
						alternateMessage 	ntext			NULL,
						mailBCC 					NVARCHAR(512)
				) 
			
			PRINT 'New wfmailqueuetable created with nText'
			
			insert into wfmailqueuetable2 (mailFrom, mailTo, mailCC, mailSubject, mailMessage, 		 mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, 	 statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, 	 processDefId,	processInstanceId, workitemId, activityId, noOfTrials,mailBCC) 
				 select mailFrom, mailTo, mailCC, mailSubject, mailMessage, mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, processDefId,	processInstanceId, workitemId, activityId, noOfTrials,mailBCC from wfmailqueuetable 
			 
			 drop table  wfmailqueuetable
			EXECUTE ('sp_rename wfmailqueuetable2,wfmailqueuetable')  
				 
			PRINT 'Table wfmailqueuetable updated successfully'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 19,@v_scriptName
		RAISERROR('Block 19 Failed.',16,1)
		exec @v_logStatus = LogUpdate 19,@v_scriptName
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 19,@v_scriptName

exec @v_logStatus= LogInsert 20,@v_scriptName,'Table WFHISTORYROUTELOGTABLE altered with NEWVALUE  size increased to 2000'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'WFHISTORYROUTELOGTABLE' and character_maximum_length =2000 and data_type='nvarchar' and column_name='newvalue' )
		 
		BEGIN
			exec  @v_logStatus = LogSkip 20,@v_scriptName
			IF EXISTS (SELECT * FROM SYSObjects 
				WHERE NAME = 'WFHISTORYROUTELOGTABLE' 
				AND xType = 'U')
			BEGIN		

				ALTER TABLE WFHISTORYROUTELOGTABLE ALTER COLUMN NEWVALUE NVARCHAR(2000)
				PRINT 'Table WFHISTORYROUTELOGTABLE altered with NEWVALUE  size increased to 2000'
			
			END

		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 20,@v_scriptName
		RAISERROR('Block 20 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 20,@v_scriptName

exec @v_logStatus= LogInsert 21,@v_scriptName,'Table WFCURRENTROUTELOGTABLE altered with NEWVALUE  size increased to 2000'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'WFCURRENTROUTELOGTABLE' and character_maximum_length =2000 and data_type='nvarchar' and column_name='newvalue' )
		 
		BEGIN
			exec  @v_logStatus = LogSkip 21,@v_scriptName
			IF EXISTS (SELECT * FROM SYSObjects 
				WHERE NAME = 'WFCURRENTROUTELOGTABLE' 
				AND xType = 'U')
			
			BEGIN

				ALTER TABLE WFCURRENTROUTELOGTABLE ALTER COLUMN NEWVALUE NVARCHAR(2000)
				PRINT 'Table WFCURRENTROUTELOGTABLE altered with NEWVALUE  size increased to 2000'
			
			END

		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 21,@v_scriptName
		RAISERROR('Block 21 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 21,@v_scriptName

exec @v_logStatus= LogInsert 22,@v_scriptName,'Table QueueHistoryTable altered with new Column CalendarName'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
		AND  NAME = 'CalendarName'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 22,@v_scriptName
			EXECUTE('ALTER TABLE QueueHistoryTable ADD CalendarName NVARCHAR(255)')
			PRINT 'Table QueueHistoryTable altered with new Column CalendarName'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 22,@v_scriptName
		RAISERROR('Block 22 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 22,@v_scriptName

exec @v_logStatus= LogInsert 23,@v_scriptName,'Table QUEUEHISTORYTABLE altered with new Column EXPORTSTATUS'	
	BEGIN
	BEGIN TRY
	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE')
			AND  NAME = 'EXPORTSTATUS'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 23,@v_scriptName
			EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD EXPORTSTATUS NVARCHAR(1) DEFAULT ''N'' ')
			PRINT 'Table QUEUEHISTORYTABLE altered with new Column EXPORTSTATUS'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 23,@v_scriptName
		RAISERROR('Block 23 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 23,@v_scriptName

exec @v_logStatus= LogInsert 24,@v_scriptName,'Table WFMAILQUEUEHISTORYTABLE altered with new Column alternateMessage'	
	BEGIN
	BEGIN TRY
		
		--this was added while syncing the oracle cabinet and mssql cabinet
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE')
			AND  NAME = 'alternateMessage'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 24,@v_scriptName
			EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD alternateMessage NTEXT')
			PRINT 'Table WFMAILQUEUEHISTORYTABLE altered with new Column alternateMessage'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 24,@v_scriptName
		RAISERROR('Block 24 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 24,@v_scriptName

exec @v_logStatus= LogInsert 25,@v_scriptName,'Table WFMAILQUEUEHISTORYTABLE altered with new Column mailBCC'	
	BEGIN
	BEGIN TRY	
	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE')
			AND  NAME = 'mailBCC'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 25,@v_scriptName
			EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD mailBCC NVARCHAR(512)')
			PRINT 'Table WFMAILQUEUEHISTORYTABLE altered with new Column mailBCC'
		END	
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 25,@v_scriptName
		RAISERROR('Block 25 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 25,@v_scriptName

exec @v_logStatus= LogInsert 26,@v_scriptName,'Table WFTMSSetVariableMapping altered with ALIASRULE  type changes to Nvarchar4000'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTMSSetVariableMapping')
				AND  NAME = 'ALIASRULE' )
		BEGIN
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTMSSetVariableMapping')
					AND  NAME = 'ALIASRULE' AND length = 8000 AND TYPE = 39)
			BEGIN
				exec  @v_logStatus = LogSkip 26,@v_scriptName
				ALTER TABLE WFTMSSetVariableMapping ALTER COLUMN ALIASRULE NVARCHAR(4000)
				PRINT 'Table WFTMSSetVariableMapping altered with ALIASRULE  type changes to Nvarchar4000'
			END
		END
		
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 26,@v_scriptName
		RAISERROR('Block 26 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 26,@v_scriptName

exec @v_logStatus= LogInsert 27,@v_scriptName,'Table WFDataclassUserInfo altered with userPWD  type changes to NVARCHAR(255)'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataclassUserInfo')
				AND  NAME = 'userPWD')
		BEGIN
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataclassUserInfo')
				AND  NAME = 'userPWD' AND length = 510 AND TYPE = 39)
			BEGIN
				exec  @v_logStatus = LogSkip 27,@v_scriptName
				ALTER TABLE  WFDataclassUserInfo ALTER COLUMN userPWD NVARCHAR(255)
				PRINT 'Table WFDataclassUserInfo altered with userPWD  type changes to NVARCHAR(255)'
			END
		END
		
		
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 27,@v_scriptName
		RAISERROR('Block 27 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 27,@v_scriptName

exec @v_logStatus= LogInsert 28,@v_scriptName,'Table WFEXPORTTABLE altered with FeldSeperator  size increaes to NVARCHAR(5)'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEXPORTTABLE')
				AND  NAME = 'FieldSeperator')
		BEGIN
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEXPORTTABLE')
				AND  NAME = 'FieldSeperator' AND length = 10 AND TYPE = 39)
			BEGIN
				exec  @v_logStatus = LogSkip 28,@v_scriptName
				ALTER TABLE WFEXPORTTABLE ALTER COLUMN FieldSeperator NVARCHAR(5)
				PRINT 'Table WFEXPORTTABLE altered with FeldSeperator  size increaes to NVARCHAR(5)'
			END	
		
		END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 28,@v_scriptName
		RAISERROR('Block 28 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 28,@v_scriptName

exec @v_logStatus= LogInsert 29,@v_scriptName,'INSERT value in WFCabVersionTable for END  of UpgradeDataTypesandChecks.sql for SU6'	
	BEGIN
	BEGIN TRY	
		exec  @v_logStatus = LogSkip 29,@v_scriptName
		BEGIN TRANSACTION trans
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''END  of UpgradeDataTypesandChecks.sql for SU6'', N''Y'')')
		COMMIT TRANSACTION trans

	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 29,@v_scriptName
		RAISERROR('Block 29 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 29,@v_scriptName

	
END

~
PRINT 'EXECUTING UpgradeDataTypesandChecks.....'
~

EXEC  UpgradeDataTypesandChecks

~

DROP PROCEDURE UpgradeDataTypesandChecks

~