/*_________________________________________________                                                                                                                                                                                                                                                                                                                                                                                                          ____________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: TableScript_Server.sql (MS Sql Server)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 08/10/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp1
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))
09/24/2020  Shubham Singla      Bug 94270 - iBPS 4.0 :-MessageId column needs to be added in WFInitiationAgentReportTable. 
11/02/2020	Mohnish Chopra		Changes for Generate response and Locale handling
29/01/2021  Sourabh Tantuway    Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256
28/05/2021  Chitranshi Nitharia Bug 99590 - Handling of master user preferences with userid 0.
20/10/2021	Vardaan Arora		Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022	Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
 ______________________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'TableScript' AND xType = 'P')
BEGIN
	Drop Procedure TableScript
	PRINT 'As Procedure TableScript exists dropping old procedure ........... '
END

PRINT 'Creating procedure TableScript ........... '

~

Create Procedure TableScript AS
BEGIN
SET NOCOUNT ON;
	DECLARE @ConstraintName NVARCHAR(100)
	DECLARE @ErrorMessage NVARCHAR(1000)
	DECLARE @V_QUERYSTR NVARCHAR(2000)
	declare @V_PARAMDEFINITION1 nvarchar(2000)
	declare @InputFormat nvarchar(100)
	declare @Tool nvarchar(50)
	declare @Processdefid nvarchar(50)
	declare @Templateid int
	DECLARE @TemplateFileName nvarchar(500)
	declare @TemplateFileName_out nvarchar(500)
	DECLARE @ErrMessage NVARCHAR(200)
	DECLARE @V_TRAN_STATUS NVARCHAR(200)
	DECLARE @FileName nvarchar(500)
	declare @FileName_out nvarchar(500)
	declare @TriggerID int
	DECLARE @DATA nvarchar(max)
	DECLARE @USREID int
	DECLARE @OBJECTID int
	DECLARE @OBJECTNAME nvarchar(5)
	DECLARE @OBJECTTYPE nvarchar(5)
	DECLARE @TempDATA nvarchar(max)
	DECLARE @TempIndex1 int
	DECLARE @TempIndex2 int
	DECLARE @FinalIndex int
	DECLARE @chunk1 nvarchar(max)
	DECLARE @chunk2 nvarchar(max)
	DECLARE @chunk3 nvarchar(200)
	DECLARE @vProcessDefId INT
	DECLARE @vVariableId INT
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFInitiationAgentReportTable') AND  NAME = 'MessageId')
				BEGIN
					EXECUTE('ALTER TABLE WFInitiationAgentReportTable ADD MessageId  NVARCHAR(1000) NULL')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

		
		BEGIN
				BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'LOCALE')
				BEGIN
					EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD Locale NVARCHAR(30) Default ''en_US''')
					EXECUTE('UPDATE WFINSTRUMENTTABLE SET LOCALE=''en_US''')
				END
				END TRY
				BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD Locale Failed.'')')
					SELECT @ErrMessage = 'Block 2' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,16,1)
					RETURN
				END CATCH
			END
			
			BEGIN
				BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'LOCALE')
				BEGIN
					EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD Locale NVARCHAR(30) Default ''en_US''')
					EXECUTE('UPDATE QUEUEHISTORYTABLE SET LOCALE=''en_US''')
				END
				END TRY
				BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD Locale Failed.'')')
					SELECT @ErrMessage = 'Block 3' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,16,1)
					RETURN
				END CATCH
			END
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'LOCALE')
			BEGIN
				DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
					open varCursor
					FETCH NEXT FROM varCursor INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						
						EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10027,    ''LOCALE'',''LOCALE'',     10,    ''M''    ,0,    NULL,    30  ,0    ,''N'')')
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
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable Failed.'')')
			SELECT @ErrMessage = 'Block 4 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM sysColumns WITH(NOLOCK) WHERE id = OBJECT_ID('TemplateDefinitionTable') AND  NAME = 'InputFormat')
		BEGIN
			EXECUTE('ALTER TABLE TemplateDefinitionTable ADD InputFormat NVARCHAR(10) NULL, Tools NVARCHAR(20) NULL, DateTimeFormat NVARCHAR(50) NULL')

			
			IF CURSOR_STATUS('global','processDefIDCur') >= -1
			BEGIN
				IF CURSOR_STATUS('global','processDefIDCur') > -1
				BEGIN
				CLOSE processDefIDCur
				END
				DEALLOCATE processDefIDCur
			END
			
			DECLARE processDefIDCur Cursor Fast_Forward For SELECT  TemplateFileName, ProcessDefId, TemplateId FROM TEMPLATEDEFINITIONTABLE
			
			
			
			OPEN processDefIDCur
			FETCH NEXT FROM processDefIDCur INTO @TemplateFileName , @Processdefid , @Templateid
			WHILE(@@Fetch_Status = 0)
			
			BEGIN

				IF (CHARINDEX('.', @TemplateFileName) > 0)
				BEGIN
				
				    SET @TemplateFileName=LTRIM(RTRIM(@TemplateFileName))
				
					SET @V_QUERYSTR = 'SELECT @TemplateFileName_out = LEFT(@TemplateFileName, LEN(@TemplateFileName) - CHARINDEX(''.'', REVERSE(@TemplateFileName) + ''.''))'
					
					SET @V_PARAMDEFINITION1 = N'@TemplateFileName_out nvarchar(200) output , @TemplateFileName nvarchar(500) '
					EXECUTE sp_executesql @V_QUERYSTR ,@V_PARAMDEFINITION1 , @TemplateFileName = @TemplateFileName, @TemplateFileName_out=@TemplateFileName_out output
					
					SET @V_QUERYSTR = 'SELECT @InputFormat = RIGHT(@TemplateFileName, CHARINDEX(''.'', REVERSE(@TemplateFileName) + ''.'') - 1)'
					SET @V_PARAMDEFINITION1 = N'@InputFormat nvarchar(100) output , @TemplateFileName nvarchar(500)'
					EXECUTE sp_executesql @V_QUERYSTR, @V_PARAMDEFINITION1 , @TemplateFileName = @TemplateFileName, @InputFormat=@InputFormat output
					
					
					
					IF(@InputFormat = 'odt' OR @InputFormat = 'doc')
					BEGIN
						SET @Tool = 'Open Office'
					END
					ELSE IF ( @InputFormat = 'docx' )
					BEGIN
						SET @Tool = 'MS Office'
					END	
					ELSE IF( @InputFormat = 'htm' OR  @InputFormat = 'html')
					BEGIN
						SET @Tool = 'AddIns(Java)'
					END
					
						
					print('--------------------------------------')
					
					Print ('Tool-->' + @Tool )
					print('--------------------------------------')
					
					SET @V_QUERYSTR = N'UPDATE TemplateDefinitionTable 
					SET TemplateFileName =  @TemplateFileName_out , InputFormat =  @InputFormat , Tools =  @Tool , DateTimeFormat = ''dd/MM/yyyy''
					where processdefid =  @Processdefid  and templateid = @Templateid'
					
					SET @V_PARAMDEFINITION1 = N'@TemplateFileName_out nvarchar(200) , @InputFormat NVARCHAR(100) , @Tool nvarchar(100) , @Processdefid int, @templateid int'
					
					EXECUTE sp_executesql @V_QUERYSTR , @V_PARAMDEFINITION1 , @TemplateFileName_out=@TemplateFileName_out ,@InputFormat=@InputFormat, @Tool =  @Tool , @Processdefid = @Processdefid , @templateid=@templateid
					
					
				END
				ELSE
				BEGIN
					Print('No extension defined For TemplateFileName->' + @TemplateFileName)
				END
				FETCH NEXT FROM processDefIDCur INTO @TemplateFileName , @Processdefid , @Templateid
			END
			CLOSE processDefIDCur
			DEALLOCATE processDefIDCur
			
			
			
			IF CURSOR_STATUS('global','GenrateresponseCur') >= -1
			BEGIN
				IF CURSOR_STATUS('global','GenrateresponseCur') > -1
				BEGIN
				CLOSE GenrateresponseCur
				END
				DEALLOCATE GenrateresponseCur
			END
			
			DECLARE GenrateresponseCur Cursor Fast_Forward For SELECT Filename, ProcessDefId, TriggerID from GenerateResponseTable WITH(NOLOCK)
			OPEN GenrateresponseCur
			FETCH NEXT FROM GenrateresponseCur INTO @FileName , @ProcessDefId, @TriggerID
			WHILE(@@Fetch_Status = 0)
			BEGIN
				IF (CHARINDEX('.', @FileName) > 0)
				BEGIN
				
					--PRINT ('---2--')
					
					SET @FileName=LTRIM(RTRIM(@FileName))
					SET @V_QUERYSTR = 'SELECT @FileName_out = LEFT(@FileName, LEN(@FileName) - CHARINDEX(''.'', REVERSE(@FileName) + ''.''))'
						
					SET @V_PARAMDEFINITION1 = N'@FileName_out nvarchar(200) output , @FileName nvarchar(500) '
					EXECUTE sp_executesql @V_QUERYSTR ,@V_PARAMDEFINITION1 , @FileName = @FileName, @FileName_out=@FileName_out output
					
					SET @V_QUERYSTR = N'UPDATE GenerateResponseTable 
						SET FileName =  @FileName_out 
						where processdefid =  @Processdefid and triggerid = @TriggerID'
						
					SET @V_PARAMDEFINITION1 = N'@FileName_out nvarchar(200) , @Processdefid int, @TriggerID int'
						
					EXECUTE sp_executesql @V_QUERYSTR , @V_PARAMDEFINITION1 , @FileName_out=@FileName_out , @Processdefid = @Processdefid , @TriggerID=@TriggerID
			
			
				END
				ELSE
				BEGIN
					PRINT ('---3--')
					Print('No extension defined For FileName->' + @FileName)
				END
				FETCH NEXT FROM GenrateresponseCur INTO @FileName , @ProcessDefId , @TriggerID
			END
			CLOSE GenrateresponseCur
			DEALLOCATE GenrateresponseCur
			
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = 'Block 5 failed ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END CATCH
	
	BEGIN
	BEGIN TRY

		SET @ConstraintName = ''
		SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFMailQueueHistoryTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
		IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
		BEGIN
			EXECUTE ('ALTER TABLE WFMailQueueHistoryTable DROP CONSTRAINT ' + @ConstraintName)
			PRINT 'Table WFMailQueueHistoryTable altered, Primary Key on WFMailQueueHistoryTable is dropped.'
		END
	
	END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 6 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END;	

	BEGIN
		BEGIN TRY		
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFCOMMENTSVIEW' and xtype = 'V')
				BEGIN
					EXECUTE('DROP VIEW WFCOMMENTSVIEW')
				END
				
				EXECUTE ('Create View WFCOMMENTSVIEW 
					As 
					SELECT * FROM WFCOMMENTSTABLE (NOLOCK)	
						UNION ALL
					SELECT * FROM WFCOMMENTSHISTORYTABLE (NOLOCK)
			')
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 7 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY		
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFGROUPVIEW' and xtype = 'V')
				BEGIN
					EXECUTE('DROP VIEW WFGROUPVIEW')
				END
				
				EXECUTE ('CREATE VIEW WFGROUPVIEW 
							AS 
							SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
								privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex, parentgroupindex  
							FROM PDBGROUP WITH(NOLOCK)
						')
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Patch 3 Block 5_1 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

    BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFDEActivityTable')
				BEGIN
					EXECUTE('CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INT NOT NULL,
	ActivityId      INT NOT NULL,
	IsolateFlag     NVARCHAR (2) NOT NULL,
	ConfigurationID INT NOT NULL,
	ConfigType     NVARCHAR (2) NOT NULL
	)
	')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 8 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

 BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFDETableMappingDetails')
				BEGIN
					EXECUTE('CREATE TABLE WFDETableMappingDetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	OrderId            INT NOT NULL,
	VariableType       NVARCHAR (2)  NOT NULL,
	RowCountVariableId INT NULL,
	FilterString       NVARCHAR (255) NULL,
	EntityType         NVARCHAR (2) NOT NULL,
	EntityName         NVARCHAR (255) NOT NULL,
	ColumnName         NVARCHAR (255) NOT NULL,
	Nullable           NVARCHAR (2) NOT NULL,
	VarName            NVARCHAR (255) NOT NULL,
	VarType            NVARCHAR (2) NOT NULL,
	VarId              INT NOT NULL,
	VarFieldId         INT NOT NULL,
	ExtObjId           INT NOT NULL,
	updateIfExist      NVARCHAR (2) NOT NULL,
	ColumnType         INT NOT NULL
	)
	')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 9 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

 BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFDETableRelationdetails')
				BEGIN
					EXECUTE('CREATE TABLE WFDETableRelationdetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	EntityName         NVARCHAR (255) NOT NULL,
	EntityType         NVARCHAR (2) NOT NULL,
	EntityColumnName   NVARCHAR (255) NOT NULL,
	ComplexTableName   NVARCHAR (255) NOT NULL,
	RelationColumnName NVARCHAR (255) NOT NULL,
	ColumnType         INT NOT NULL,
	RelationType       NVARCHAR (2) NOT NULL
	)
	')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 10 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

 BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFDEConfigTable')
				BEGIN
					EXECUTE('CREATE TABLE WFDEConfigTable
(
    ProcessDefId       INT NOT NULL,
    ConfigName         NVARCHAR(255) NOT NULL,
    ActivityId         INT NOT NULL
)
	')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 11 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END			
	IF EXISTS(select * from sys.columns 
            where Name = 'AppServerIP' and Object_ID = Object_ID('WF_OMSConnectInfoTable'))
    BEGIN            
    PRINT 'Increase AppServerIP column length in WF_OMSConnectInfoTable ........... '
        EXECUTE('alter table WF_OMSConnectInfoTable alter column AppServerIP nvarchar(100)')
    END
	
	BEGIN
		BEGIN TRY
		IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFESCALATIONTABLE') AND  NAME = 'CONCERNEDAUTHINFO')
		BEGIN
			EXECUTE('ALTER TABLE WFESCALATIONTABLE ALTER COLUMN CONCERNEDAUTHINFO NVARCHAR(2000)')	
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFESCALATIONTABLE ALTER COLUMN CONCERNEDAUTHINFO Failed.'')')
			SELECT @ErrMessage = 'Block 12 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMETHODDEFTABLE') AND  NAME = 'IsBRMSService')
		BEGIN
			EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD IsBRMSService Nvarchar(1) NULL')	
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD  IsBRMSService Failed.'')')
			SELECT @ErrMessage = 'Block 13 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSRuleSetInfo') AND  NAME = 'isEncrypted')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSRuleSetInfo ADD  isEncrypted Nvarchar(1) NULL')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSRuleSetInfo ADD isEncrypted Failed.'')')
					SELECT @ErrMessage = 'Block 14' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,16,1)
					RETURN
			END CATCH
	END
	
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSRuleSetInfo') AND  NAME = 'RuleSetId')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSRuleSetInfo ADD  RuleSetId Integer NUll')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSRuleSetInfo ADD RuleSetId Failed.'')')
					SELECT @ErrMessage = 'Block 15' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,16,1)
					RETURN
			END CATCH
	END
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSActivityAssocTable') AND  NAME = 'Type')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSActivityAssocTable ADD  Type	Nvarchar(1) Default ''S'' NOT NULL')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSActivityAssocTable ADD Type Failed.'')')
					SELECT @ErrMessage = 'Block 16' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,16,1)
					RETURN
			END CATCH
	END
	
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM USERPREFERENCESTABLE WHERE Userid = 0 AND ObjectType = N'U')
		BEGIN
			EXECUTE('Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,''U'',''U'',''N'',''<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General><Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist><SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument><Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk><GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>'')')
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrMessage = 'Block 6 failed. ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage, 16, 1)
		RETURN
	END CATCH
	
	BEGIN TRY
		SET @V_QUERYSTR = N'UPDATE USERPREFERENCESTABLE SET DATA=@DATA WHERE Userid=@Userid AND ObjectId=@ObjectId AND ObjectName=@ObjectName AND ObjectType=@ObjectType'
		SET @V_PARAMDEFINITION1 = N'@DATA nvarchar(max) ,@Userid INT, @ObjectId INT , @ObjectName nvarchar(255) , @ObjectType nvarchar(30)'
		DECLARE V_CURSOR CURSOR FAST_FORWARD  FOR SELECT Userid,ObjectId,ObjectName,ObjectType,DATA FROM USERPREFERENCESTABLE WITH(NOLOCK) where Userid<>0 and ObjectType= N'U'
		OPEN V_CURSOR
		FETCH NEXT FROM V_CURSOR INTO @USREID,@OBJECTID,@OBJECTNAME,@OBJECTTYPE,@DATA
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF CHARINDEX('WL_TURNAROUND_CONSUMED',@DATA) = 0
			BEGIN
				SET @TempIndex1 = CharIndex('WL_ENTRY_DATE',@DATA,1)
				IF (@TempIndex1 >0)
				BEGIN
					SET @TempIndex1 = CharIndex('</Field>',@DATA,@TempIndex1)+8
				END
				ELSE
				BEGIN
					RAISERROR('WL_ENTRY_DATE FIELD NOT FOUND', 16, 1)
				END
				SET @TempIndex2 = (LEN(@DATA)-@TempIndex1)
				IF (@TempIndex2 >0)
				BEGIN
					SET @TempIndex2 = @TempIndex2+1
					SET @chunk1 = Substring(@DATA,0,@TempIndex1)
					SET @chunk2 = Substring(@DATA,@TempIndex1,@TempIndex2)
					SET @chunk3 =N'<Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field>'
					SET @TempDATA = @chunk1+@chunk3+@chunk2
					BEGIN
						EXECUTE SP_EXECUTESQL @V_QUERYSTR, @V_PARAMDEFINITION1 ,@DATA=@TempDATA, @Userid=@USREID , @ObjectId=@OBJECTID , @ObjectName=@OBJECTNAME ,@ObjectType=@OBJECTTYPE
					END
				END
				ELSE
				BEGIN
					RAISERROR('WL_ENTRY_DATE FIELD NOT FOUND', 16, 1)
				END
			END
			FETCH NEXT FROM V_CURSOR INTO @USREID,@OBJECTID,@OBJECTNAME,@OBJECTTYPE,@DATA
		END
		CLOSE V_CURSOR
		DEALLOCATE V_CURSOR
	END TRY
	BEGIN CATCH
		IF CURSOR_STATUS('global','V_CURSOR') >= -1
		BEGIN
			IF CURSOR_STATUS('global','V_CURSOR') > -1
			BEGIN
				CLOSE V_CURSOR
			END
			DEALLOCATE V_CURSOR
		END
		SET @ErrorMessage = 'BLOCK 7 FAILED. '+ ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END CATCH
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSConnectTable') AND  NAME = 'RESTServerHostName')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSConnectTable ADD  RESTServerHostName  nvarchar(128)')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSConnectTable ADD RESTServerHostName Failed.'')')
					SELECT @ErrMessage = 'Block 18' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,18,1)
					RETURN
			END CATCH
	END
	
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSConnectTable') AND  NAME = 'RESTServerPort')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSConnectTable ADD  RESTServerPort  integer')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSConnectTable ADD RESTServerPort Failed.'')')
					SELECT @ErrMessage = 'Block 19' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,19,1)
					RETURN
			END CATCH
	END
	
	
	BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSConnectTable') AND  NAME = 'RESTServerProtocol')
				BEGIN
					EXECUTE('ALTER TABLE WFBRMSConnectTable ADD  RESTServerProtocol  nvarchar(32)')
				END
			END TRY
			BEGIN CATCH
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFBRMSConnectTable ADD RESTServerProtocol Failed.'')')
					SELECT @ErrMessage = 'Block 20' + ERROR_MESSAGE()
					RAISERROR(@ErrMessage,20,1)
					RETURN
			END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'TATRemaining')
			BEGIN
				DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
					open varCursor
					FETCH NEXT FROM varCursor INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						
						EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10028,    ''TATRemaining'',''TATRemaining'',     4,    ''S''    ,0,    NULL,    NULL  ,0    ,''N'')')
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
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable Failed.'')')
			SELECT @ErrMessage = 'Block 21' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'TATConsumed')
			BEGIN
				DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
					open varCursor
					FETCH NEXT FROM varCursor INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					BEGIN TRANSACTION trans
						
						EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10029,    ''TATConsumed'',''TATConsumed'',     4,    ''S''    ,0,    NULL,    NULL  ,0    ,''N'')')
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
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable Failed.'')')
			SELECT @ErrMessage = 'Block 22' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTypeDefTable') AND  NAME = 'SortingFlag')
		BEGIN
			EXECUTE('ALTER TABLE WFTypeDefTable ADD SortingFlag NVARCHAR(1)')
			EXECUTE('UPDATE WFTypeDefTable SET SortingFlag = ''N''')
		END
	END TRY
	BEGIN CATCH
		SET @ErrorMessage = 'BLOCK 23 FAILED. '+ ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END CATCH

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable') AND  NAME = 'DefaultSortingFieldname')
		BEGIN
			EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD DefaultSortingFieldname NVARCHAR(256), DefaultSortingOrder INT')
			SET @V_QUERYSTR = N'UPDATE WFUDTVarMappingTable SET DefaultSortingFieldname = ''insertionorderid'', DefaultSortingOrder = 0 WHERE ProcessDefId = @vProcessDefId AND VariableId = @vVariableId AND ParentVarFieldId = 0'
			SET @V_PARAMDEFINITION1 = N'@vProcessDefId INT, @vVariableId INT'
			DECLARE V_CURSOR CURSOR FAST_FORWARD FOR SELECT ProcessDefId, VariableId FROM VarMappingTable WITH(NOLOCK) WHERE VariableType = 11 AND Unbounded = 'Y'
			OPEN V_CURSOR
			FETCH NEXT FROM V_CURSOR INTO @vProcessDefId, @vVariableId
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				EXECUTE SP_EXECUTESQL @V_QUERYSTR, @V_PARAMDEFINITION1, @vProcessDefId = @vProcessDefId, @vVariableId = @vVariableId
				FETCH NEXT FROM V_CURSOR INTO @vProcessDefId, @vVariableId
			END
			CLOSE V_CURSOR
			DEALLOCATE V_CURSOR
		END
	END TRY
	BEGIN CATCH
		IF CURSOR_STATUS('global','V_CURSOR') >= -1
		BEGIN
			IF CURSOR_STATUS('global','V_CURSOR') > -1
			BEGIN
				CLOSE V_CURSOR
			END
			DEALLOCATE V_CURSOR
		END
		SET @ErrorMessage = 'BLOCK 24 FAILED. '+ ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END CATCH
	
	BEGIN
		BEGIN TRY
				IF ((Select character_maximum_length from information_schema.columns where table_name = 'WFMailqueuetable' AND COLUMN_NAME='mailSubject') <  512)
				BEGIN
					EXECUTE('ALTER TABLE wfmailqueuetable alter column mailSubject  NVARCHAR(512) NULL')	
				END
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = 'BLOCK 25 FAILED. '+ ERROR_MESSAGE()
			RAISERROR(@ErrorMessage, 25, 1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF ((Select character_maximum_length from information_schema.columns where table_name = 'WFMailqueuehistorytable' AND COLUMN_NAME='mailSubject') <  512)
				BEGIN
					EXECUTE('ALTER TABLE wfmailqueuehistorytable alter column mailSubject  NVARCHAR(512) NULL')	
				END
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = 'BLOCK 26 FAILED. '+ ERROR_MESSAGE()
			RAISERROR(@ErrorMessage, 26, 1)
			RETURN
		END CATCH
	END
END	

~

EXEC TableScript 

~

PRINT 'Executing procedure TableScript ........... '

~

DROP PROCEDURE TableScript

~