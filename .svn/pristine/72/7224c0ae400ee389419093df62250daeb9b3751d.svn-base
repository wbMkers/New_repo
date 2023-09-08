

/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis_iBPS
	Product / Project			: WorkFlow
	Module						: iBPS_Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Sajid Ali Khan
	Date written (DD/MM/YYYY)	: 06-04-2017
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date			Change By		Change Description (Bug No. (If Any))
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  . 
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered   
05-05-2017		Sajid Khan		Mergingn Bug 55753 - There isn't any option to add Comments while ad-hoc routing of Work Item in process manager
05-05-2017		Sajid Khan		Merging  Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
23/05/2017     Kumar Kimil      Transfer Data for IBPS(Transaction Tables including Case Management)
11/06/2017		Sajid Khan		Bug 69985 - OF 10.3 SP-2 SQL upgrade: If check in process with new version, getting error.
11/06/2017		Sajid Khan		Bug 69994 - BRT forward reverse mapping lost in registered process
09/08/2017		Shubhankur Manuja	Bug 70946 - Workitems are not getting created by the initiation agent. The mails are getting 
									downloaded and going to the failed mails folder
___________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '

~
Create Procedure Upgrade AS
BEGIN
SET NOCOUNT ON;
	Declare @constrnName NVARCHAR(100)
	DECLARE @QueueID INT
	DECLARE @ProcessDefId INT
	DECLARE @activityID INT
	DECLARE @processName	VARCHAR(100)
	DECLARE @ConstraintName NVARCHAR(100)
	Declare @tempQId		INT
	Declare @tempQName 		NVARCHAR(200)
	Declare @actType		INT
	Declare @subActType		INT
	declare @ErrMessage 	nvarchar(200)
	DECLARE @V_TRAN_STATUS NVARCHAR(200)
	
	
	BEGIN
		BEGIN TRY		
			If EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE') AND  NAME = 'mailTo')
			BEGIN
				EXECUTE('ALTER TABLE WFMAILQUEUETABLE Alter column mailTo NVARCHAR(2000)')
			END
			PRINT 'mailTo cloumn in WFMAILQUEUETABLE altered'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE Alter column mailTo FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			If EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'wfmailQueueHistoryTable') AND  NAME = 'mailTo')
			BEGIN
				EXECUTE('ALTER TABLE wfmailQueueHistoryTable Alter column mailTo NVARCHAR(2000)')
			END
			PRINT 'mailTo cloumn in wfmailQueueHistoryTable altered'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE wfmailQueueHistoryTable Alter column mailTo FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			If EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE') AND  NAME = 'mailCC')
			BEGIN
				EXECUTE('ALTER TABLE WFMAILQUEUETABLE Alter column mailCC NVARCHAR(2000)')
			END
			PRINT 'mailCC cloumn in WFMAILQUEUETABLE altered'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE Alter column mailCC FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'wfmailQueueHistoryTable') AND  NAME = 'mailCC')
			BEGIN
				EXECUTE('ALTER TABLE wfmailQueueHistoryTable Alter column mailCC NVARCHAR(2000)')
			END
			PRINT 'mailCC cloumn in wfmailQueueHistoryTable altered'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE wfmailQueueHistoryTable Alter column mailCC FAILED.'')')
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') and NAME='OWNEREMAILID')
			BEGIN
				EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD  OWNEREMAILID NVARCHAR(255)')
			END
			PRINT 'OWNEREMAILID cloumn added in PROCESSDEFTABLE '
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD  OWNEREMAILID FAILED.'')')
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME = 'CreateWebService')
			BEGIN
				EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD  CreateWebService NVARCHAR(2) Default ''Y''')
				EXECUTE('UPDATE PROCESSDEFTABLE SET CreateWebService = ''Y'' WHERE CreateWebService is null or createwebservice = ''''' )
			END
			PRINT 'CreateWebService cloumn in PROCESSDEFTABLE added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD  CreateWebService FAILED.'')')
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSystemServicesTable') AND  NAME = 'AppServerId')
			BEGIN
				EXECUTE('ALTER TABLE WFSystemServicesTable ADD  AppServerId NVARCHAR(100)')
			END
			PRINT 'AppServerId cloumn in WFSystemServicesTable added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD  CreateWebService FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'WFCabinetView')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
				EXECUTE('
					Create view WFCabinetView 
					AS 
					Select * from PDBCabinet
				')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD  CreateWebService FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'VARMAPPINGTABLE') AND  NAME = 'IsEncrypted')
			BEGIN
				EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD  IsEncrypted         NVARCHAR(1)   NULL DEFAULT N''N''')
				EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD  IsMasked           	NVARCHAR(1)	  NULL DEFAULT N''N''')
				EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD  MaskingPattern      NVARCHAR(10)  NULL DEFAULT N''X''')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD  CreateWebService FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable') AND  NAME = 'IsEncrypted')
			BEGIN
				EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD  IsEncrypted         NVARCHAR(1)   NULL DEFAULT N''N''')
				EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD  IsMasked           	NVARCHAR(1)	  NULL DEFAULT N''N''')
				EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD  MaskingPattern      NVARCHAR(10)  NULL DEFAULT N''X''')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFUDTVarMappingTable ADD  IsEncrypted FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFActivityMaskingInfoTable')
			BEGIN
				CREATE TABLE WFActivityMaskingInfoTable (
					ProcessDefId 		INT 			NOT NULL,
					ActivityId 		    INT 		    NOT NULL,
					ActivityName 		NVARCHAR(30)	NOT NULL,
					VariableId			INT 			NOT NULL,
					VarFieldId			SMALLINT		NOT NULL,
					VariableName		NVARCHAR(255) 	NOT NULL
				)
				PRINT 'Table WFCabVersionTable created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFUDTVarMappingTable ADD  IsEncrypted FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFAUDITTRAILDOCTABLE')
			BEGIN
				CREATE TABLE WFAUDITTRAILDOCTABLE(
					PROCESSDEFID			INT NOT NULL,
					PROCESSINSTANCEID		NVARCHAR(63),
					WORKITEMID			INT NOT NULL,
					ACTIVITYID			INT NOT NULL,
					DOCID				INT NOT NULL,
					PARENTFOLDERINDEX		INT NOT NULL,
					VOLID				INT NOT NULL,
					APPSERVERIP			NVARCHAR(63) NOT NULL,
					APPSERVERPORT			INT NOT NULL,
					APPSERVERTYPE			NVARCHAR(63) NULL,
					ENGINENAME			NVARCHAR(63) NOT NULL,
					DELETEAUDIT			NVARCHAR(1) Default 'N',
					STATUS				CHAR(1)	NOT NULL,
					LOCKEDBY			NVARCHAR(63)	NULL,
					PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID)
				)
				PRINT 'Table WFAUDITTRAILDOCTABLE created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFUDTVarMappingTable ADD  IsEncrypted FAILED.'')')
			SELECT @ErrMessage = 'Block 12 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVETABLE') AND  NAME = 'DeleteAudit')
			BEGIN
				EXECUTE('ALTER TABLE ARCHIVETABLE ADD  DeleteAudit   NVARCHAR(1) DEFAULT ''N''')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ARCHIVETABLE ADD  DeleteAudit FAILED.'')')
			SELECT @ErrMessage = 'Block 13 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PSREGISTERATIONTABLE') AND  NAME = 'BulkPS')
			BEGIN
				EXECUTE('ALTER TABLE PSREGISTERATIONTABLE ADD  BulkPS   NVARCHAR(1)')
				PRINT 'BulkPS column added in Table PSREGISTERATIONTABLE'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PSREGISTERATIONTABLE ADD  BulkPS  FAILED.'')')
			SELECT @ErrMessage = 'Block 14 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/* Modifying the Check contraint on WFCommentsTable */
	BEGIN
		BEGIN TRY		
			BEGIN
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsTable' AND constraint_type = 'CHECK'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE WFCommentsTable DROP CONSTRAINT ' + @constrnName)
				END
				EXECUTE('ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10))')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsTable DROP CONSTRAINT  FAILED.'')')
			SELECT @ErrMessage = 'Block 15 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
--Ne		eds to be executed just after CommentTyps check modified in WFCOmmnetsTable
	BEGIN
		BEGIN TRY
			IF EXISTS(select * from sysobjects where name = 'WFCommentsHistoryTable')
			BEGIN
				If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsHistoryTable') AND  NAME = 'ProcessVariantId')
				BEGIN--It means cabinet is getting upgraded from OmniFlow
					EXECUTE('ALTER TABLE WFCommentsHistoryTable Add ProcessVariantId INT NOT NULL DEFAULT 0')
					
				-- Modifying the Check contraint on WFCommentsHistoryTable 
					BEGIN
						SET @constrnName = ''
						SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsHistoryTable' AND constraint_type = 'CHECK'
						IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
						BEGIN
							EXECUTE ('ALTER TABLE WFCommentsHistoryTable DROP CONSTRAINT ' + @constrnName)
						END
						EXECUTE('ALTER TABLE WFCommentsHistoryTable ADD CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10))')
						
						--If Cabinet is from OmniFlow then Update CommentType from 4 to 6 in WFCommentsHistoryTable
						EXECUTE('Update WFCOmmentsHistoryTable Set CommentsType = 6 Where CommentsType = 4')
						
						--If CommentType = 4 then update to 6  in WFCommentsTable
						EXECUTE('Update WFCommentsTable Set CommentsType = 6 Where CommentsType = 4')
					END
				END
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsHistoryTable Add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 16 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
/*Ad		ding ProcessVariantId to WFReportDataHistoryTable, if table exists and column does not exist- Case of Omniflow Cabinet Upgrade*/	
	BEGIN
		BEGIN TRY
			IF EXISTS(select * from sysobjects where name = 'WFReportDataHistoryTable')
			BEGIN
				If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFReportDataHistoryTable') AND  NAME = 'ProcessVariantId')
				BEGIN
					EXECUTE('ALTER TABLE WFReportDataHistoryTable Add ProcessVariantId INT NOT NULL DEFAULT 0')
				END
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFReportDataHistoryTable Add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 17 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
			-- Creating WFCommentsHistoryTable
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(select * from sysobjects where name = 'WFCommentsHistoryTable')
			BEGIN
				EXECUTE(
					'CREATE TABLE WFCommentsHistoryTable(
					CommentsId			INT				IDENTITY(1,1)	PRIMARY KEY,
					ProcessDefId 		INT 			NOT NULL,
					ActivityId 			INT 			NOT NULL,
					ProcessInstanceId 	NVARCHAR(64) 	NOT NULL,
					WorkItemId 			INT 			NOT NULL,
					CommentsBy			INT 			NOT NULL,
					CommentsByName		NVARCHAR(64) 	NOT NULL,
					CommentsTo			INT 			NOT NULL,
					CommentsToName		NVARCHAR(64)	NOT NULL,
					Comments			NVARCHAR(1000)	NULL,
					ActionDateTime		DATETIME		NOT NULL,
					CommentsType		INT				NOT NULL	CHECK(CommentsType IN (1, 2, 3,4,5,6)),
					ProcessVariantId 	INT 			NOT NULL DEFAULT 0
				)'
				)
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFReportDataHistoryTable Add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 18 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*Changes for Queue variables extension */
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'Var_Str9')
			BEGIN
				DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
					open varCursor
					FETCH NEXT FROM varCursor INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values('+@ProcessDefId+ ', 10006, ''VAR_DATE5'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values('+@ProcessDefId+ ', 10007, ''VAR_DATE6'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values('+@ProcessDefId+ ', 10008, ''VAR_LONG5'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values('+@ProcessDefId+ ', 10009, ''VAR_LONG6'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10010, ''VAR_STR9'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10011, ''VAR_STR10'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10012, ''VAR_STR11'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10013, ''VAR_STR12'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10014, ''VAR_STR13'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10015, ''VAR_STR14'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10016, ''VAR_STR15'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10017, ''VAR_STR16'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10018, ''VAR_STR17'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10019, ''VAR_STR18'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10020, ''VAR_STR19'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
		
						EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
						VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
						values(' +@ProcessDefId+ ', 10021, ''VAR_STR20'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')')
						
						
					COMMIT TRANSACTION trans
					FETCH NEXT FROM varCursor INTO @ProcessDefId
				END
				CLOSE varCursor
				DEALLOCATE varCursor
					
			END
		END TRY	
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into varmappingtable FAILED.'')')
			SELECT @ErrMessage = 'Block 19 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'VAR_STR9')
			BEGIN
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD VAR_DATE5 DATETIME, VAR_DATE6 DATETIME, VAR_LONG5 INT, VAR_LONG6 INT, 
				VAR_STR9 NVARCHAR(512), VAR_STR10 NVARCHAR(512), VAR_STR11 NVARCHAR(512), VAR_STR12 NVARCHAR(512), VAR_STR13 NVARCHAR(512), VAR_STR14 NVARCHAR(512), VAR_STR15 NVARCHAR(512), VAR_STR16 NVARCHAR(512), VAR_STR17 NVARCHAR(512), VAR_STR18 NVARCHAR(512), VAR_STR19 NVARCHAR(512), VAR_STR20 NVARCHAR(512)')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD VAR_DATE5 FAILED.'')')
			SELECT @ErrMessage = 'Block 20 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'VAR_STR9')
			BEGIN
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD VAR_DATE5 DATETIME, VAR_DATE6 DATETIME, VAR_LONG5 INT, VAR_LONG6 INT, 
				VAR_STR9 NVARCHAR(512), VAR_STR10 NVARCHAR(512), VAR_STR11 NVARCHAR(512), VAR_STR12 NVARCHAR(512), VAR_STR13 NVARCHAR(512), VAR_STR14 NVARCHAR(512), VAR_STR15 NVARCHAR(512), VAR_STR16 NVARCHAR(512), VAR_STR17 NVARCHAR(512), VAR_STR18 NVARCHAR(512), VAR_STR19 NVARCHAR(512), VAR_STR20 NVARCHAR(512)')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD VAR_DATE5 FAILED.'')')
			SELECT @ErrMessage = 'Block 21 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUETABLE')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
				EXECUTE('DROP VIEW QUEUETABLE')
			END
			
			BEGIN
				EXECUTE(' Create VIEW QUEUETABLE AS
				SELECT  processdefid, processname, processversion, 
				processinstanceid, processinstanceid AS processinstancename, 
				activityid, activityname, 
				parentworkitemid, workitemid, 
				processinstancestate, workitemstate, statename, queuename, queuetype,
				AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
				IntroductionDateTime, CreatedDatetime AS CreatedDatetime,
				Introducedby, createdbyname, entryDATETIME,
				lockstatus, holdstatus, prioritylevel, lockedbyname, 
				lockedtime, validtill, savestage, previousstage,
				expectedworkitemdelay AS expectedworkitemdelaytime,
					expectedprocessdelay AS expectedprocessdelaytime, status, 
				var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
				var_float1, var_float2, 
				var_date1, var_date2, var_date3, var_date4, var_date5, var_date6,
				var_long1, var_long2, var_long3, var_long4, var_long5, var_long6,
				var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, var_str9, var_str10, var_str11, var_str12, var_str13, var_str14, var_str15, var_str16, var_str17, var_str18, var_str19, var_str20, 
				var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
				q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
				referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, ProcessVariantId
				FROM WFINSTRUMENTTABLE  with (NOLOCK)')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create VIEW QUEUETABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 22 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUEVIEW')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
				EXECUTE('DROP VIEW QUEUEVIEW')
			END
			
			BEGIN
				EXECUTE(' Create VIEW QUEUEVIEW AS
				SELECT * FROM QUEUETABLE WITH (NOLOCK) 
				UNION ALL 
				SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,
				VAR_DATE5, VAR_DATE6,
				VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19,VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE WITH (NOLOCK)')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create VIEW QUEUEVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 23 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* modifying the length of var_str from nvarchar(255) to nvarchar(512)*/
			/* Transfering these alter quries to separate script*/
/*	BEGIN                                                      
		BEGIN TRY		
			BEGIN		
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR1 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR2 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR3 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR4 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR5 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR6 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR7 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  VAR_STR8 nvarchar(512) null')
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE alter column  Status nvarchar(255) null')
				
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR1 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR2 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR3 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR4 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR5 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR6 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR7 nvarchar(512) null')
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE alter column  VAR_STR8 nvarchar(512) null')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE and WFINSTRUMENTTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 24 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
*/	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'VARALIASTABLE') AND  NAME = 'DisplayFlag')
			BEGIN
					EXECUTE ('ALTER TABLE VarAliasTable ADD DisplayFlag NVARCHAR(1), SortFlag NVARCHAR(1), SearchFlag NVARCHAR(1)')
					EXECUTE ('UPDATE VarAliasTable SET DisplayFlag = ''Y'', SortFlag = ''Y'', SearchFlag = ''Y''')
					EXECUTE ('ALTER TABLE VarAliasTable Alter Column DisplayFlag NVARCHAR(1) NOT NULL')
					Execute ('ALTER TABLE VarAliasTable Alter Column SortFlag NVARCHAR(1) NOT NULL')
					Execute ('ALTER TABLE VarAliasTable Alter Column SearchFlag NVARCHAR(1) NOT NULL')
					EXECUTE ('ALTER TABLE VarAliasTable ADD CHECK (DisplayFlag = N''Y'' OR DisplayFlag = N''N'')')
					EXECUTE ('ALTER TABLE VarAliasTable ADD CHECK (SortFlag = N''Y'' OR SortFlag = N''N'')')
					EXECUTE ('ALTER TABLE VarAliasTable ADD CHECK (SearchFlag = N''Y'' OR SearchFlag = N''N'')')
		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE VarAliasTable FAILED.'')')
			SELECT @ErrMessage = 'Block 25 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
/*De		assocaition of User  from System Queues and sagggreagation of worktiems and queues to SystemPFE and System Archieve */
	BEGIN
		BEGIN TRY
			IF  EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A')
			BEGIN
				DECLARE cursor1 CURSOR STATIC FOR Select QueueId ,QueueName FROM QueueDefTable Where QueueType = 'A'
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @tempQId, @tempQName
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						EXECUTE('Delete from WFUserObjAssocTable Where  ObjectTypeId = 2 and ObjectId  = '+@tempQId) --ObjectTypeId = 2 ; Queue
						If(@tempQName = 'SystemPFEQueue')
						BEGIN	
							Select @actType = 10
							Select @subActType = 1
						END
						If(@tempQName = 'SystemArchiveQueue')
						BEGIN	
							Select @actType = 10
							Select @subActType = 4
						END
						If(@tempQName = 'SystemArchiveQueue' OR  @tempQName = 'SystemPFEQueue')
						BEGIN
							DECLARE cursor2 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = @actType 
							AND activitysubtype = @subActType
							OPEN cursor2
							FETCH NEXT FROM cursor2 INTO @ProcessDefId, @activityID
							WHILE(@@FETCH_STATUS = 0) 
							BEGIN
								EXECUTE('Update QueueStreamTable set QueueId = ' + @tempQId + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
								EXECUTE('Update WFInstrumentTable set QueueName='''+@tempQName+''',Q_queueId = ' + @tempQId + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
								EXECUTE('Update WFInstrumentTable set QueueName = '''+@tempQName+''',Q_queueId = ' + @tempQId + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
								FETCH NEXT FROM cursor2 INTO @ProcessDefId, @activityID
							END
							CLOSE cursor2
							DEALLOCATE cursor2
						END
					COMMIT TRANSACTION trans
					FETCH NEXT FROM cursor1 INTO @tempQId,@tempQName
				END
				CLOSE cursor1
				DEALLOCATE cursor1
			END
		END TRY	
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QueueStreamTable and WFInstrumentTable in FAILED.'')')
			SELECT @ErrMessage = 'Block 26 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
/*Sy		stem Queeue Creation and assocaition*/

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemWSQueue')
			BEGIN		
				EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemWSQueue'',''A'',''System generated common WebService Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
				SELECT @QueueID = @@IDENTITY
				DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 22
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
						EXECUTE('Update WFInstrumentTable set QueueName=''SystemWSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
						EXECUTE('Update WFInstrumentTable set QueueName = ''SystemWSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
					COMMIT TRANSACTION trans
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				END
				CLOSE cursor1
				DEALLOCATE cursor1
			END
		END TRY	
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QueueStreamTable and WFInstrumentTable in SystemWSQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 27 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemSAPQueue')
			BEGIN		
				EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemSAPQueue'',''A'',''System generated common SAP Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
				SELECT @QueueID = @@IDENTITY
				DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 29
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
						EXECUTE('Update WFInstrumentTable set QueueName=''SystemSAPQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
						EXECUTE('Update WFInstrumentTable set QueueName = ''SystemSAPQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
					COMMIT TRANSACTION trans
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				END
				CLOSE cursor1
				DEALLOCATE cursor1
			END
		END TRY	
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QueueStreamTable and WFInstrumentTable in SystemSAPQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 28 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* Adding BRMS Queue, QueueType A*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemBRMSQueue')
			BEGIN		
				EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemBRMSQueue'',''A'',''System generated common BRMS Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
				SELECT @QueueID = @@IDENTITY
				
				DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 31
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
						EXECUTE('Update WFInstrumentTable set QueueName=''SystemBRMSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
						EXECUTE('Update WFInstrumentTable set QueueName = ''SystemBRMSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
					COMMIT TRANSACTION trans
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
				END
				CLOSE cursor1
				DEALLOCATE cursor1
			END
		END TRY	
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QueueStreamTable and WFInstrumentTable in SystemBRMSQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 29 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFMailQueueTable' AND COLUMN_NAME = 'TaskId' AND DATA_TYPE = 'BIGINT')
			BEGIN
				IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFMailQueueTable' AND xType = 'U')
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFMailQueueTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFMailQueueTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFMailQueueTable altered, Primary Key on WFMailQueueTable is dropped.'
					END
		
					EXECUTE('ALTER TABLE WFMailQueueTable ALTER COLUMN TaskId BIGINT NOT NULL')
					PRINT 'Table WFMailQueueTable altered with Column TaskId changed to BIGINT'
		
					EXECUTE('ALTER TABLE WFMailQueueTable ADD PRIMARY KEY (TaskId)')
					PRINT 'Table WFMailQueueTable altered, Primary Key created.'
				END
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMailQueueTable FAILED.'')')
			SELECT @ErrMessage = 'Block 30 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFMailQueueHistoryTable' AND COLUMN_NAME = 'TaskId' AND DATA_TYPE = 'BIGINT')
			BEGIN
				IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFMailQueueHistoryTable' AND xType = 'U')
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFMailQueueHistoryTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFMailQueueHistoryTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFMailQueueHistoryTable altered, Primary Key on WFMailQueueHistoryTable is dropped.'
					END
		
					EXECUTE('ALTER TABLE WFMailQueueHistoryTable ALTER COLUMN TaskId BIGINT NOT NULL')
					PRINT 'Table WFMailQueueHistoryTable altered with Column TaskId changed to BIGINT'
		
					EXECUTE('ALTER TABLE WFMailQueueHistoryTable ADD PRIMARY KEY (TaskId)')
					PRINT 'Table WFMailQueueHistoryTable altered, Primary Key created.'
				END
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE VarAliasTable FAILED.'')')
			SELECT @ErrMessage = 'Block 31 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFImportFileData') AND  NAME = 'FailRecords')
			BEGIN
				EXECUTE('UPDATE WFImportFileData SET FileStatus = ''S'' WHERE FileStatus = ''I''')
				EXECUTE('ALTER TABLE WFImportFileData ADD FailRecords INT DEFAULT 0')
				EXECUTE('UPDATE WFImportFileData SET FailRecords = 0')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE WFImportFileData FAILED.'')')
			SELECT @ErrMessage = 'Block 32 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
		
			/* Creating WFFailFileRecords table*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFFailFileRecords')
			BEGIN
				EXECUTE(
					'CREATE TABLE WFFailFileRecords (
						FailRecordId INT IDENTITY (1, 1),
						FileIndex INT,
						RecordNo INT,
						RecordData NVARCHAR(2000),
						Message NVARCHAR(1000),
						EntryTime DATETIME DEFAULT GETDATE()
					)'
				)
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFFailFileRecords FAILED.'')')
			SELECT @ErrMessage = 'Block 33 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		



	
/*Adding ProcessVariantId to WFReportDataHistoryTable, if table exists and column does not exist- Case of Omniflow Cabinet Upgrade*/
	BEGIN
		BEGIN TRY	
			IF EXISTS(select * from sysobjects where name = 'WFATTRIBUTEMESSAGEHISTORYTABLE')
			BEGIN
				If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFATTRIBUTEMESSAGEHISTORYTABLE') AND  NAME = 'ProcessVariantId')
				BEGIN
					EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE Add ProcessVariantId INT NOT NULL DEFAULT 0')
				END
				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFATTRIBUTEMESSAGEHISTORYTABLE' AND COLUMN_NAME = 'messageId' AND DATA_TYPE = 'BIGINT')
				BEGIN
				IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFATTRIBUTEMESSAGEHISTORYTABLE' AND xType = 'U')
					BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFATTRIBUTEMESSAGEHISTORYTABLE' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFATTRIBUTEMESSAGEHISTORYTABLE altered, Primary Key on WFATTRIBUTEMESSAGETABLE is dropped.'
					END
				
					EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ALTER COLUMN messageId BIGINT NOT NULL')
					PRINT 'Table WFATTRIBUTEMESSAGEHISTORYTABLE altered with Column messageId changed to BIGINT'
		
					EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ADD PRIMARY KEY (messageId)')
					PRINT 'Table WFATTRIBUTEMESSAGEHISTORYTABLE altered, Primary Key created.'
					END
				END	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 34 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFATTRIBUTEMESSAGEHISTORYTABLE')
			BEGIN
				CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE (
					ProcessDefId		INTEGER		NOT NULL,	
					ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
					ProcessInstanceID	NVARCHAR(63)  NOT NULL ,
					WorkItemId 			INT 		NOT NULL ,
					MESSAGEID			BIGINT NOT NULL, 
					message				NTEXT	 	NOT NULL, 
					lockedBy			NVARCHAR(63), 
					status 				NVARCHAR(1)	CHECK (status in (N'N', N'F')),
					ActionDateTime		DATETIME,
					CONSTRAINT PK_WFATTRIBUTEMESSAGETABLEHist PRIMARY KEY (MESSAGEID )	
)		
				PRINT 'Table WFATTRIBUTEMESSAGEHISTORYTABLE created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 35 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFReportDataHistoryTable')
			BEGIN
				CREATE TABLE WFReportDataHistoryTable(
					ProcessInstanceId	Nvarchar(63),
					WorkitemId		Integer,
					ProcessDefId		Integer NOT NULL,
					ActivityId		Integer,
					UserId			Integer,
					TotalProcessingTime	Integer,
					ProcessVariantId 	INT 	NOT NULL DEFAULT 0
				)
				PRINT 'Table WFReportDataHistoryTable created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFReportDataHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 36 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable')
			BEGIN
				create table WFTaskStatusHistoryTable(
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId INT NOT NULL,
					ProcessDefId INT NOT NULL,
					ActivityId INT NOT NULL,
					TaskId Integer NOT NULL,
					SubTaskId  Integer NOT NULL,
					TaskStatus integer NOT NULL,
					AssignedBy varchar(63) NOT NULL,
					AssignedTo varchar(63) NULL,
					Instructions varchar(2000) NULL,
					ActionDateTime DATETIME NOT NULL,
					DueDate DATETIME,
					Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
					ShowCaseVisual	varchar(1) default 'N' NOT NULL,
					ReadFlag varchar(1) default 'N' NOT NULL,
					CanInitiate	varchar(1) default 'N' NOT NULL,
					Q_DivertedByUserId INT DEFAULT 0
					CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
				)
				PRINT 'Table WFTaskStatusHistoryTable created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTaskStatusHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 37 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFRTTASKINTFCASSOCHISTORY')
			BEGIN
				create table WFRTTASKINTFCASSOCHISTORY (
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId  INT NOT NULL,
					ProcessDefId INT  NOT NULL, 
					ActivityId INT NOT NULL,
					TaskId Integer NOT NULL, 
					InterfaceId Integer NOT NULL, 
					InterfaceType NCHAR(1) NOT NULL,
					Attribute NVarchar(2)
				)
				PRINT 'Table WFRTTASKINTFCASSOCHISTORY created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFRTTASKINTFCASSOCHISTORY FAILED.'')')
			SELECT @ErrMessage = 'Block 38 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'RTACTIVITYINTFCASSOCHISTORY')
			BEGIN
				CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId  INT NOT NULL,
					ProcessDefId            INT		NOT NULL,
					ActivityId              INT             NOT NULL,
					ActivityName            NVARCHAR(30)    NOT NULL,
					InterfaceElementId      INT             NOT NULL,
					InterfaceType           NVARCHAR(1)     NOT NULL,
					Attribute               NVARCHAR(2)     NULL,
					TriggerName             NVARCHAR(255)   NULL,
					ProcessVariantId 		INT 			NOT NULL DEFAULT 0
				)
				PRINT 'Table RTACTIVITYINTFCASSOCHISTORY created successfully'
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE RTACTIVITYINTFCASSOCHISTORY FAILED.'')')
			SELECT @ErrMessage = 'Block 39 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'ChildProcessInstanceId')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD ChildProcessInstanceId		NVARCHAR(63)	NULL')
			END
			PRINT 'QueueHistoryTable cloumn in ChildProcessInstanceId added	'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 40 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'ChildWorkitemId')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		ChildWorkitemId				INT')
			END
			PRINT 'QueueHistoryTable cloumn in ChildWorkitemId added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD ChildWorkitemId FAILED.'')')
			SELECT @ErrMessage = 'Block 41 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'FilterValue')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		FilterValue					INT		NULL ')
			END
			PRINT 'QueueHistoryTable cloumn in FilterValue added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD FilterValue FAILED.'')')
			SELECT @ErrMessage = 'Block 42 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'Guid')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		Guid 						BIGINT ')
			END
			PRINT 'QueueHistoryTable cloumn in Guid added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD Guid FAILED.'')')
			SELECT @ErrMessage = 'Block 43 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'NotifyStatus')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		NotifyStatus				NVARCHAR(1)')
			END
			PRINT 'QueueHistoryTable cloumn in NotifyStatus added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD NotifyStatus FAILED.'')')
			SELECT @ErrMessage = 'Block 44 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'Q_DivertedByUserId')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		Q_DivertedByUserId   		INT NULL')
			END
			PRINT 'QueueHistoryTable cloumn in Q_DivertedByUserId added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD Q_DivertedByUserId FAILED.'')')
			SELECT @ErrMessage = 'Block 45 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'RoutingStatus')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		RoutingStatus				NVARCHAR(1) ')
			END
			PRINT 'QueueHistoryTable cloumn in RoutingStatus added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD RoutingStatus FAILED.'')')
			SELECT @ErrMessage = 'Block 46 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'NoOfCollectedInstances')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		NoOfCollectedInstances		INT DEFAULT 0')
			END
			PRINT 'QueueHistoryTable cloumn in NoOfCollectedInstances added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD NoOfCollectedInstances FAILED.'')')
			SELECT @ErrMessage = 'Block 47 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'IsPrimaryCollected')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		IsPrimaryCollected			NVARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))')
			END
			PRINT 'QueueHistoryTable cloumn in IsPrimaryCollected added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD IsPrimaryCollected FAILED.'')')
			SELECT @ErrMessage = 'Block 48 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'Introducedbyid')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		Introducedbyid			 INT        NULL ')
			END
			PRINT 'QueueHistoryTable cloumn in Introducedbyid added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD Introducedbyid FAILED.'')')
			SELECT @ErrMessage = 'Block 49 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'IntroducedAt')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		IntroducedAt                NVARCHAR(30)     NULL')
			END
			PRINT 'QueueHistoryTable cloumn in IntroducedAt added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD IntroducedAt FAILED.'')')
			SELECT @ErrMessage = 'Block 50 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			If NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable') AND  NAME = 'Createdby')
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD 		Createdby                    INT         NULL ')
			END
			PRINT 'QueueHistoryTable cloumn in IsPrimaryCollected added'
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD Createdby FAILED.'')')
			SELECT @ErrMessage = 'Block 51 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
/*Up		dating Default FieldLength and Precision(In case of Float)*/

	BEGIN
		BEGIN TRY	
			UPDATE Varmappingtable set variablelength=255 where variablescope='U' and VariableType=10
			and userdefinedname is not NULL and userdefinedname!='' and variablelength is NULL
		
			UPDATE Varmappingtable set variablelength=15,VarPrecision=2 where variablescope='U'
			and VariableType=6 and userdefinedname is not NULL and userdefinedname!='' and variablelength is NULL
			
			UPDATE Varmappingtable set variablelength=2 where variablescope='U' and VariableType=3 and 
			userdefinedname is not NULL  and userdefinedname!='' and variablelength is NULL
			
			UPDATE Varmappingtable set variablelength=4 where variablescope='U' and VariableType=4 
			and userdefinedname is not NULL  and userdefinedname!='' and variablelength is NULL
			
			UPDATE Varmappingtable set variablelength=8 where variablescope='U' and VariableType=8 and 
			userdefinedname is not NULL  and variablelength is NULL
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE Varmappingtable FAILED.'')')
			SELECT @ErrMessage = 'Block 52 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
/*End of Updating Default FieldLength and Precision(In case of Float)*/		
		
/* Modifying the Check contraint on ExtMethodDefTable for B[BRMS Workstep] */
	BEGIN
		BEGIN TRY
			BEGIN
				SET @constrnName = ''
				SELECT @constrnName =  TC.Constraint_Name from information_schema.table_constraints TC
										inner join information_schema.constraint_column_usage CC on TC.Constraint_Name = CC.Constraint_Name
										where CC.TABLE_NAME = 'EXTMETHODDEFTABLE' and CC.COLUMN_NAME ='ExtAppType' And Constraint_Type = 'CHECK'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' + @constrnName)
				END
				EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z'',N''B'',N''R''))')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD CHECK FAILED.'')')
			SELECT @ErrMessage = 'Block 53 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			--EXECUTE ('TRUNCATE TABLE WFMAILQUEUEHISTORYTABLE')
		
	/*Making entry in WFCabVersionTable for iBPS_3.0_SP1*/	
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS(SELECT cabVersion FROM WFCabVersionTable WHERE cabVersion = 'iBPS_3.0_SP1')
			BEGIN
				Execute ('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''iBPS_3.0_SP1'', GETDATE(), GETDATE(), N''iBPS_3.0_SP1'', N''Y'')')
			END	
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT INTO WFCabVersionTable FAILED.'')')
			SELECT @ErrMessage = 'Block 54 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	/*Dropping Extra columns from WFMessageTable, WFmessageInProcessTable and WFFailedMessageTable which is not required in IBPS SP1*/	
	BEGIN
		BEGIN TRY	
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMESSAGETABLE') 
			AND  NAME = 'ProcessInstanceId')
			BEGIN
				EXECUTE('ALTER TABLE WFMESSAGETABLE Drop Column ProcessInstanceId')		
				PRINT 'Column ProcessInstanceId Dropped Successfully from  WFMESSAGETABLE'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped Successfully from  WFMESSAGETABLE'')')	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMESSAGETABLE Drop Column ProcessInstanceId FAILED.'')')
			SELECT @ErrMessage = 'Block 55 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMESSAGETABLE') 
			AND  NAME = 'ActionId')
			BEGIN
				EXECUTE('ALTER TABLE WFMESSAGETABLE Drop Column ActionId')		
				PRINT 'Column ActionId Dropped Successfully from  WFMESSAGETABLE'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped Successfully from  WFMESSAGETABLE'')')	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMESSAGETABLE Drop Column ActionId FAILED.'')')
			SELECT @ErrMessage = 'Block 56 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable') 
			AND  NAME = 'ProcessInstanceId')
			BEGIN
				EXECUTE('ALTER TABLE WFFailedMessageTable Drop Column ProcessInstanceId')		
				PRINT 'Column ProcessInstanceId Dropped Successfully from  WFFailedMessageTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped Successfully from  WFFailedMessageTable'')')	
			END	
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFailedMessageTable Drop Column ProcessInstanceId FAILED.'')')
			SELECT @ErrMessage = 'Block 57 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable') 
			AND  NAME = 'ActionId')
			BEGIN
				EXECUTE('ALTER TABLE WFFailedMessageTable Drop Column ActionId')		
				PRINT 'Column ActionId Dropped Successfully from  WFFailedMessageTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped Successfully from  WFFailedMessageTable'')')	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFailedMessageTable Drop Column ActionId FAILED.'')')
			SELECT @ErrMessage = 'Block 58 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMessageInProcessTable') 
			AND  NAME = 'ProcessInstanceId')
			BEGIN
				EXECUTE('ALTER TABLE WFMessageInProcessTable Drop Column ProcessInstanceId')		
				PRINT 'Column ProcessInstanceId Dropped Successfully from  WFMessageInProcessTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped Successfully from  WFMessageInProcessTable'')')	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMessageInProcessTable Drop Column ProcessInstanceId FAILED.'')')
			SELECT @ErrMessage = 'Block 59 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMessageInProcessTable') 
			AND  NAME = 'ActionId')
			BEGIN
				EXECUTE('ALTER TABLE WFMessageInProcessTable Drop Column ActionId')		
				PRINT 'Column ActionId Dropped Successfully from  WFMessageInProcessTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped Successfully from  WFMessageInProcessTable'')')	
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMessageInProcessTable Drop Column ActionId FAILED.'')')
			SELECT @ErrMessage = 'Block 60 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
			/* Adding identity to messageid column if not present */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sys.identity_columns WHERE object_id = (SELECT id FROM sysobjects WHERE name = 'WFATTRIBUTEMESSAGETABLE'))
			BEGIN
				EXECUTE('select * into TEMP_WFATTRIBUTEMESSAGETABLE from WFATTRIBUTEMESSAGETABLE')
				EXECUTE('DROP TABLE WFATTRIBUTEMESSAGETABLE')
				EXECUTE(' 
						CREATE TABLE WFATTRIBUTEMESSAGETABLE (
							ProcessDefId        INTEGER        NOT NULL,    
							ProcessVariantId     INT         NOT NULL DEFAULT 0,
							ProcessInstanceID    NVARCHAR(63)  NOT NULL ,
							WorkItemId             INT         NOT NULL ,
							messageId             BIGINT        identity (1, 1) PRIMARY KEY, 
							message                NTEXT         NOT NULL, 
							lockedBy            NVARCHAR(63), 
							status                 NVARCHAR(1)    CHECK (status in (N''N'', N''F'')),
							ActionDateTime        DATETIME    
						)
			
					')
				EXECUTE('SET IDENTITY_INSERT WFATTRIBUTEMESSAGETABLE ON')
				EXECUTE('
						INSERT into WFATTRIBUTEMESSAGETABLE (messageId, ProcessDefId, ProcessVariantId, ProcessInstanceID, WorkItemId, message, lockedBy, status, ActionDateTime) select messageId, ProcessDefId, ProcessVariantId, ProcessInstanceID, WorkItemId, message, lockedBy, status, ActionDateTime from TEMP_WFATTRIBUTEMESSAGETABLE'
						)
				EXECUTE('SET IDENTITY_INSERT WFATTRIBUTEMESSAGETABLE OFF')
				EXECUTE('DROP TABLE TEMP_WFATTRIBUTEMESSAGETABLE')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create table WFATTRIBUTEMESSAGETABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 61 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

END

~


PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade 
PRINT 'Procedure Upgrade ran successfully........... '
~
DROP PROCEDURE Upgrade
~
	


	
	
	