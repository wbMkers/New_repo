/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 08/10/2018
	Description					: This file contains the list of changes done after release of iBPS 4.0
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
25/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
13/05/2019	Ravi Ranjan Kumar Bug 84500 - Support of URN as system variable is required
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//20/12/2019   Shubham SIngla      Bug 87593 - iBPS 4.0:WFUploadWorkitem getting failed when AssociatedFieldId in WFCurrentRouteLogTable becomes greater than the size of int.
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
22/04/2020		Ambuj Tripathi		Bug 91914 - Arabic:- Task description changed in to junk character after task initiated successfully.
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
______________________________________________________________________________________________________________________-*/

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
	DECLARE @ConstraintName NVARCHAR(100)
	Declare @v_ObjectId                      INT
    Declare @v_ObjectTypeId                  INT
    Declare @v_UserId                        INT
    Declare @v_AssociationType				 INT
    Declare @v_RightString                  NVARCHAR(200)
    Declare @v_Filter                       NVARCHAR(200)
	DECLARE @ProcessDefId					INT
	Declare @existsFlag						INT
	Declare @StreamId 						INT
	Declare @ActivityId 					INT
	Declare @StreamName  					NVARCHAR(50)
	
	DECLARE @ToDoId INTEGER
	DECLARE @PickListValue NVARCHAR(50)
	DECLARE @PickListOrderId INTEGER
	DECLARE @LastProcessDefId INTEGER
	DECLARE @LastToDoId INTEGER
	DECLARE @RowCount INTEGER
	DECLARE @PrimaryKeyName NVARCHAR(200)
	DECLARE @DELETEUSERQUEUETABLEDATA INT
	DECLARE @v_folderIndex INT
	DECLARE @v_volumeId INT
	DECLARE @v_siteId INT
	DECLARE @v_cabinettype NVARCHAR(2)
	DECLARE @ErrMessage NVARCHAR(200)
	DECLARE @V_TRAN_STATUS NVARCHAR(200)
	DECLARE	@ExpiryActivity nvarchar(500)
	DECLARE	@expiryactivityid INT
	DECLARE	@connid int
	
	SELECT @DELETEUSERQUEUETABLEDATA = 0

	DECLARE cur_streamIDUpdate CURSOR FOR  Select processdefid,ActivityId,StreamId,StreamName from STREAMDEFTABLE order by processdefid,ActivityId,StreamId
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM WFSYSTEMPROPERTIESTABLE WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG')
			BEGIN
				Execute ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SHAREPOINTFLAG'',''N'')')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT INTO WFSYSTEMPROPERTIESTABLE Table FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFUnderlyingDMS')
			BEGIN
				CREATE TABLE WFUnderlyingDMS (
					DMSType		INT				NOT NULL,
					DMSName		NVARCHAR(255)	NULL
				)
				Print 'Table WFUnderlyingDMS created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFUnderlyingDMS FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFdmslibrary')
			BEGIN
				CREATE TABLE WFDMSLibrary (
					LibraryId			INT				NOT NULL 	IDENTITY(1,1) 	PRIMARY KEY,
					URL					NVARCHAR(255)	NULL,
					DocumentLibrary		NVARCHAR(255)	NULL,
					DOMAINNAME 			NVARCHAR(64)	NULL
				)
				Print 'Table WFdmslibrary created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFdmslibrary FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDMSLIBRARY') AND  NAME = 'DOMAINNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFDMSLibrary ADD DOMAINNAME	NVARCHAR(64)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFdmslibrary FAILED.'')')
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFProcessSharePointAssoc')
			BEGIN
				CREATE TABLE WFProcessSharePointAssoc (
					ProcessDefId			INT		NOT NULL,
					LibraryId				INT		NULL,
					PRIMARY KEY (ProcessDefId)
				)
				Print 'Table  WFProcessSharePointAssoc created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFProcessSharePointAssoc FAILED.'')')
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFsharepointinfo')
			BEGIN
				CREATE TABLE WFSharePointInfo (
					ServiceURL		NVARCHAR(255)	NULL,
					ProxyEnabled	NVARCHAR(200)	NULL,
					ProxyIP			NVARCHAR(20)	NULL,
					ProxyPort		NVARCHAR(200)	NULL,
					ProxyUser		NVARCHAR(200)	NULL,
					ProxyPassword	NVARCHAR(512)	NULL,
					SPWebUrl		NVARCHAR(200)	NULL
				)
				Print 'Table WFsharepointinfo created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFSharePointInfo FAILED.'')')
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFArchiveInSharePoint')
			BEGIN
				CREATE TABLE WFArchiveInSharePoint (
					ProcessDefId			INT				NULL,
					ActivityID				INT				NULL,
					URL					 	NVARCHAR(255)	NULL,		
					SiteName				NVARCHAR(255)	NULL,
					DocumentLibrary			NVARCHAR(255)	NULL,
					FolderName				NVARCHAR(255)	NULL,
					ServiceURL 				NVARCHAR(255) 	NULL,
					SameAssignRights		NVARCHAR(2) 	NULL,
					DiffFolderLoc			NVARCHAR(2) 	NULL,	
					DOMAINNAME 				NVARCHAR(64)	NULL
				)
				Print 'Table  WFArchiveInSharePoint created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFSharePointInfo FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFARCHIVEINSHAREPOINT') AND  NAME = 'DOMAINNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFARCHIVEINSHAREPOINT ADD DOMAINNAME	NVARCHAR(64)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFARCHIVEINSHAREPOINT ADD DOMAINNAME FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFsharepointdatamaptable')
			BEGIN
				CREATE TABLE WFSharePointDataMapTable (
					ProcessDefId			INT				NULL,
					ActivityID				INT				NULL,
					FieldId					INT				NULL,
					FieldName				NVARCHAR(255)	NULL,
					FieldType				INT				NULL,
					MappedFieldName			NVARCHAR(255)	NULL,
					VariableID				NVARCHAR(255)	NULL,
					VarFieldID				NVARCHAR(255)	NULL			
				)
				Print 'Table  WFsharepointdatamaptable created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFSharePointDataMapTable FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFsharepointdocassoctable')
			BEGIN
				CREATE TABLE WFSharePointDocAssocTable (
					ProcessDefId			INT				NULL,
					ActivityID				INT				NULL,
					DocTypeID				INT				NULL,
					AssocFieldName			NVARCHAR(255)	NULL,
					FolderName				NVARCHAR(255)	NULL,
					TARGETDOCNAME			NVARCHAR(255)	NULL
				)
				Print 'Table  WFsharepointdocassoctable created'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFsharepointdocassoctable FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSHAREPOINTDOCASSOCTABLE') AND  NAME = 'TARGETDOCNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME	NVARCHAR(255)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFExportMapTable')
			BEGIN
				CREATE TABLE  WFExportMapTable
				(
					ProcessDefId              INT,		
					ActivityId                INT,
					ExportLocation 			NVARCHAR (2000),
					CurrentCount 			NVARCHAR (100),
					Counter 				NVARCHAR (100),
					RecordFlag 				NVARCHAR (100)
				)
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE  WFExportMapTable FAILED.'')')
			SELECT @ErrMessage = 'Block 12 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='IAId' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFInitiationAgentReportTable'  AND XTYPE='U' ))
			Begin
					Execute ('ALTER TABLE WFInitiationAgentReportTable add IAId nvarchar(50)  NULL ')
					
					Execute ('ALTER TABLE WFInitiationAgentReportTable add AccountName nvarchar(100)  NULL ')
					
					Execute ('ALTER TABLE WFInitiationAgentReportTable add NoOfAttachments int NULL ')
					
					Execute ('ALTER TABLE WFInitiationAgentReportTable add SizeOfAttachments nvarchar(1000) NULL ')
			End
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFInitiationAgentReportTable FAILED.'')')
			SELECT @ErrMessage = 'Block 13 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='RightString' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFUserObjAssocTable'  AND XTYPE='U' ))
			BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFUserObjAssocTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFUserObjAssocTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFUserObjAssocTable altered, Primary Key on WFUserObjAssocTable is dropped.'
					END
					
					
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFProfileObjTypeTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFProfileObjTypeTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFProfileObjTypeTable altered, Primary Key on WFProfileObjTypeTable is dropped.'
					END
					
					
					Execute ('Alter table WFUserObjAssocTable Add RightString NVARCHAR(100) not null Default ''1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111''' )
					
					Execute ('Alter table WFUserObjAssocTable Add Filter NVARCHAR(255)')
		
					EXECUTE('ALTER TABLE WFUserObjAssocTable ADD PRIMARY KEY (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)')
					PRINT 'Table WFUserObjAssocTable altered, Primary Key created.'
					
		
					DECLARE cursor1 CURSOR STATIC FOR Select A.ObjectId, A.ObjectTypeId, A.AssociationType, A.UserId, CAST(C.RightString AS NVARCHAR(200)), CAST(C.Filter AS NVARCHAR(510)) as RightStringCasted FROM
						WFUserObjAssocTable A WITH (NOLOCK)
						,WFObjectListTable B WITH (NOLOCK)
						,WFProfileObjTypeTable C WITH (NOLOCK)
					WHERE A.ObjectTypeId = B.ObjectTypeId
						AND A.ObjectTypeId = C.ObjectTypeId
						AND A.associationType = C.associationType
						AND A.userid = C.userid
						AND A.Profileid = 0
				
					OPEN cursor1
				
					FETCH NEXT FROM cursor1 INTO @v_ObjectId, @v_ObjectTypeId, @v_AssociationType, @v_UserId, @v_RightString, @v_Filter
					WHILE(@@FETCH_STATUS = 0) 
					BEGIN
						EXECUTE('Update WFUserObjAssocTable set RightString = ''' + @v_RightString
						+ ''', Filter  = ''' + @v_Filter
						+ ''' Where Objectid = ' + @v_ObjectId
						+ ' And ObjectTypeId = ' + @v_ObjectTypeId
						+ ' And AssociationType = ' + @v_AssociationType
						+ ' And UserId = ' + @v_UserId
						+ ' And ProfileId = 0'
						)
						FETCH NEXT FROM cursor1 INTO @v_ObjectId, @v_ObjectTypeId, @v_AssociationType, @v_UserId, @v_RightString, @v_Filter
								
						IF (@@ERROR <> 0)
						BEGIN
							CLOSE cursor1
							DEALLOCATE cursor1
							Return
						END
					END 
					CLOSE cursor1
					DEALLOCATE cursor1
						
					EXECUTE('Insert into WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDateTime, AssociationFlag, RightString, Filter) 
					Select DISTINCT -1, ObjectTypeId, 0, UserId, AssociationType, Null, Null, RightString, Filter FROM WFProfileObjTypeTable where AssociationType IN (0,1) and ObjectTypeId not in (1,2,4,6,12,13)')
		
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFUserObjAssocTable AND WFProfileObjTypeTable FAILED.'')')
			SELECT @ErrMessage = 'Block 14 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
		
		
	BEGIN
		BEGIN TRY	
		BEGIN
			OPEN cur_streamIDUpdate
			FETCH NEXT FROM cur_streamIDUpdate INTO @ProcessDefId,@ActivityId,@StreamId,@StreamName
	
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				Select @existsFlag = count(*) from ruleconditiontable where processdefid = @ProcessDefId and ActivityId=@ActivityId and RuleType='S' 
				If (@existsFlag = 0 and @StreamName='Default')
				Begin
						insert into RuleConditionTable (ProcessDefId,ActivityId,RuleType,RuleOrderId,RuleId,ConditionOrderId,Param1,Type1,ExtObjID1,VariableId_1,VarFieldId_1,Param2,Type2,ExtObjID2,VariableId_2,VarFieldId_2,Operator,LogicalOp) values(@ProcessDefId,@ActivityId,'S',1,@StreamId,1,'ALWAYS','S',0,0,0,'ALWAYS','S',0,0,0,4,4)
			
				End
				FETCH NEXT FROM cur_streamIDUpdate INTO @ProcessDefId,@ActivityId,@StreamId,@StreamName
			END
			CLOSE cur_streamIDUpdate   
			DEALLOCATE cur_streamIDUpdate 
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into RuleConditionTable FAILED.'')')
			SELECT @ErrMessage = 'Block 15 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
/*	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'TODOPICKLISTTABLE') AND  NAME = 'PickListOrderId')
			BEGIN
				EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PickListOrderId INT')
				print 'PickListOrderId added to TODOPICKLISTTABLE'
			END	*/
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVARMAPPINGTABLE') AND  NAME = 'MAPPEDVIEWNAME')
		BEGIN
			EXECUTE('Alter table WFUDTVarMappingTable add	MappedViewName     NVARCHAR(256)       NULL')	
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFUDTVarMappingTable add	MappedViewName FAILED.'')')
			SELECT @ErrMessage = 'Block 16 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVARMAPPINGTABLE') AND  NAME = 'ISVIEW')
		BEGIN
			EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD IsView              NVARCHAR(1)   NOT NULL DEFAULT N''N''')	
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFUDTVarMappingTable ADD IsView FAILED.'')')
			SELECT @ErrMessage = 'Block 17 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
			
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONTABLE')
					AND NAME = 'EXCEPTIONCOMMENTS' AND xtype = 231)
				BEGIN
					IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONTABLE')
					AND NAME = 'EXCEPTIONCOMMENTS' AND xtype = 231 AND LENGTH < 2048)
					BEGIN
						EXECUTE('ALTER TABLE ExceptionTable ALTER COLUMN ExceptionComments NVARCHAR(1024)')
						PRINT 'ExceptionTable column exceptioncomments length altered.'
					END
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ExceptionTable ALTER COLUMN ExceptionComments FAILED.'')')
				SELECT @ErrMessage = 'Block 18 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
	
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONHISTORYTABLE')
					AND NAME = 'EXCEPTIONCOMMENTS' AND xtype = 231)
				BEGIN
					IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONHISTORYTABLE')
					AND NAME = 'EXCEPTIONCOMMENTS' AND xtype = 231 AND LENGTH < 2048)
					BEGIN
						EXECUTE('ALTER TABLE ExceptionHistoryTable ALTER COLUMN ExceptionComments NVARCHAR(1024)')
						PRINT 'ExceptionHistoryTable column exceptioncomments length altered.'
					END
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ExceptionHistoryTable ALTER COLUMN ExceptionComments FAILED.'')')
				SELECT @ErrMessage = 'Block 19 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		/*Change to delete the CK_ISSecureFolder constraint from TEMP_PROCESSDEFTABLE if the cabinet is getting upgraded multiple times.
		*/
	BEGIN	
		BEGIN TRY
			SET @ConstraintName = ''
			SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'TEMP_PROCESSDEFTABLE' AND CONSTRAINT_NAME = 'CK_ISSecureFolder'
			IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
			BEGIN
				EXECUTE ('ALTER TABLE TEMP_PROCESSDEFTABLE DROP CONSTRAINT ' + @ConstraintName)
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE TEMP_PROCESSDEFTABLE DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 20 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	
	BEGIN	
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME = 'ISSECUREFOLDER')
		BEGIN
			EXECUTE('Alter table PROCESSDEFTABLE add	ISSecureFolder CHAR(1) DEFAULT ''N'' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN (''Y'', ''N''))')		
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE TEMP_PROCESSDEFTABLE DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 21 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'IMAGECABNAME')
		BEGIN
			EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD  IMAGECABNAME NVARCHAR(100)')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 22 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY
		IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IX1_WFEscalationTable') AND object_id=OBJECT_ID('dbo.WFESCALATIONTABLE'))
		BEGIN
			EXECUTE('DROP INDEX IX1_WFEscalationTable ON WFEscalationTable')
			PRINT('IX1_WFEscalationTable  dropped')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IX1_WFEscalationTable FAILED.'')')
			SELECT @ErrMessage = 'Block 23 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX2_WFEscalationTable') AND object_id=OBJECT_ID('dbo.WFESCALATIONTABLE'))
		BEGIN
			EXECUTE('CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)')
			PRINT('IDX2_WFEscalationTable created')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX2_WFEscalationTable FAILED.'')')
			SELECT @ErrMessage = 'Block 24 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
	
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX3_WFEscalationTable') AND object_id=OBJECT_ID('dbo.WFESCALATIONTABLE'))
		BEGIN
			EXECUTE('CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)')
			PRINT('IDX3_WFEscalationTable created')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX3_WFEscalationTable FAILED.'')')
			SELECT @ErrMessage = 'Block 25 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
	
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE UPPER(TABLE_NAME) =UPPER('WFEscalationTable') AND CONSTRAINT_TYPE = 'PRIMARY KEY')
		BEGIN
			EXECUTE('ALTER TABLE WFEscalationTable ALTER COLUMN EscalationId Integer NOT NULL')
			EXECUTE('ALTER TABLE WFEscalationTable ADD PRIMARY KEY (EscalationId)')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable ADD PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 26 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
		
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'SecondaryDBFlag')
		BEGIN
			EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD SecondaryDBFlag NVARCHAR(1)    NOT NULL Default ''N'' CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD SecondaryDBFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 27 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'SecondaryDBFlag')
		BEGIN
			EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD SecondaryDBFlag NVARCHAR(1)    NOT NULL Default ''N'' CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD SecondaryDBFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 28 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY	
		IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'SecondaryDBFlag')
		BEGIN
			DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
				open varCursor
				FETCH NEXT FROM varCursor INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					
					EXECUTE('insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded,ProcessVariantId,IsEncrypted,IsMasked,MaskingPattern) 
					values('+@ProcessDefId+ ', 10022, ''SecondaryDBFlag'', ''SecondaryDBFlag'', 10, ''M'', 0, ''N'', NULL, 0, ''N'',0,	''N'',	''N'',	''X'')')
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
			SELECT @ErrMessage = 'Block 29 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH	
	END
		
	BEGIN	
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM SYSColumns WHERE ID = (SELECT ID FROM SYSObjects WHERE UPPER(NAME) = UPPER('TODOPICKLISTTABLE') AND xType = 'U') AND UPPER(NAME) = UPPER('PickListOrderId'))
			BEGIN
				EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PickListOrderId INTEGER')
				SELECT @LastProcessDefId = -1
				SELECT @LastToDoId = -1
				SELECT @PickListOrderId = 1
				DECLARE cursor1 CURSOR STATIC FOR SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE WITH(NOLOCK) ORDER BY ProcessDefId ASC, ToDoId ASC
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ToDoId, @PickListValue
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					IF @LastProcessDefId <> @ProcessDefId OR @LastToDoId <> @ToDoId
					BEGIN
						SELECT @PickListOrderId = 1
					END
					EXECUTE('UPDATE TODOPICKLISTTABLE SET PickListOrderId = ' + @PickListOrderId + ' WHERE ProcessDefId = ' + @ProcessDefId + ' AND ToDoId = ' + @ToDoId + ' AND PickListValue = ''' + @PickListValue + '''')
					SELECT @PickListOrderId = @PickListOrderId + 1
					SELECT @LastProcessDefId = @ProcessDefId
					SELECT @LastToDoId = @ToDoId
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ToDoId, @PickListValue
				END
				CLOSE cursor1
				DEALLOCATE cursor1
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE TODOPICKLISTTABLE ADD PickListOrderId FAILED.'')')
			SELECT @ErrMessage = 'Block 30 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN	
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM SYSColumns WHERE ID = (SELECT ID FROM SYSObjects WHERE UPPER(NAME) = UPPER('TODOPICKLISTTABLE') AND xType = 'U') AND UPPER(NAME) = UPPER('PickListId'))
			BEGIN
				EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PickListId INTEGER')
				SELECT @LastProcessDefId = -1
				SELECT @LastToDoId = -1
				SELECT @PickListOrderId = 1
				DECLARE cursor1 CURSOR STATIC FOR SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE WITH(NOLOCK) ORDER BY ProcessDefId ASC, ToDoId ASC
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ToDoId, @PickListValue
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					IF @LastProcessDefId <> @ProcessDefId OR @LastToDoId <> @ToDoId
					BEGIN
						SELECT @PickListOrderId = 1
					END
					EXECUTE('UPDATE TODOPICKLISTTABLE SET PickListId = ' + @PickListOrderId +  ' WHERE ProcessDefId = ' + @ProcessDefId + ' AND ToDoId = ' + @ToDoId + ' AND PickListValue = ''' + @PickListValue + '''')
					SELECT @PickListOrderId = @PickListOrderId + 1
					SELECT @LastProcessDefId = @ProcessDefId
					SELECT @LastToDoId = @ToDoId
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ToDoId, @PickListValue
				END
				CLOSE cursor1
				DEALLOCATE cursor1
				EXECUTE('ALTER TABLE TODOPICKLISTTABLE ALTER COLUMN PickListId INTEGER NOT NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE TODOPICKLISTTABLE ADD PickListOrderId FAILED.'')')
			SELECT @ErrMessage = 'Block 31 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
		BEGIN
			BEGIN TRY
				SELECT @RowCount = COUNT(1) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC WITH(NOLOCK) INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU WITH(NOLOCK) ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME AND TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND KU.table_name='WFAuditTrailDocTable'
				IF @RowCount <> 3
				BEGIN
					SELECT @PrimaryKeyName = name FROM sys.key_constraints WITH(NOLOCK) WHERE parent_object_id = OBJECT_ID('WFAuditTrailDocTable') AND type= 'PK'
					EXECUTE('ALTER TABLE WFAuditTrailDocTable DROP CONSTRAINT ' + @PrimaryKeyName)
					ALTER TABLE WFAuditTrailDocTable ADD PRIMARY KEY(ProcessInstanceId, WorkItemId, ActivityId)
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAuditTrailDocTable DROP CONSTRAINT FAILED.'')')
				SELECT @ErrMessage = 'Block 32 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExtDBConfTable') AND  NAME = 'HistoryTableName')
			BEGIN
				EXECUTE('ALTER TABLE ExtDBConfTable ADD HistoryTableName NVARCHAR(128)')
			END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ExtDBConfTable ADD HistoryTableName FAILED.'')')
				SELECT @ErrMessage = 'Block 33 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'URN')
		BEGIN
			DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
				open varCursor
				FETCH NEXT FROM varCursor INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					
					EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10023,    ''URN'',''URN'',     10,    ''S''    ,0,    ''N'',    63   ,0    ,''N'')')
				COMMIT TRANSACTION trans
				FETCH NEXT FROM varCursor INTO @ProcessDefId
			END
			CLOSE varCursor
			DEALLOCATE varCursor
				
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 34 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE') AND  NAME = 'EDITABLEONQUERY')
			BEGIN
				EXECUTE('ALTER TABLE QUEUEUSERTABLE ADD EDITABLEONQUERY  NVARCHAR(1)   NOT NULL DEFAULT N''N''')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEUSERTABLE ADD EDITABLEONQUERY FAILED.'')')
			SELECT @ErrMessage = 'Block 35 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUSERGROUPVIEW') AND  NAME = 'EDITABLEONQUERY')
			BEGIN
				IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUSERGROUPVIEW') )	
					BEGIN
						EXECUTE('DROP VIEW QUSERGROUPVIEW')
					END
				EXECUTE('CREATE VIEW QUSERGROUPVIEW AS SELECT queueid,userid, NULL  groupid, AssignedtillDateTime, queryFilter,QueryPreview,EditableonQuery FROM   QUEUEUSERTABLE (NOLOCK) WHERE  Associationtype=0 AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate()) UNION SELECT queueid,userindex,userid AS groupid,NULL  AssignedtillDateTime, queryFilter,QueryPreview,EditableonQuery FROM   QUEUEUSERTABLE (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK) WHERE  Associationtype=1 AND    QUEUEUSERTABLE.userid=WFGROUPMEMBERVIEW.groupindex  ')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW QUSERGROUPVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 36 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDOCBUFFER') AND  NAME = 'ATTACHMENTNAME')
				BEGIN
					EXECUTE('ALTER TABLE WFDOCBUFFER ADD ATTACHMENTNAME  NVARCHAR(255)   NOT NULL DEFAULT N''Attachment''')	
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDOCBUFFER ADD ATTACHMENTNAME FAILED.'')')
				SELECT @ErrMessage = 'Block 37 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDOCBUFFER') AND  NAME = 'ATTACHMENTTYPE')
				BEGIN
					EXECUTE('ALTER TABLE WFDOCBUFFER ADD ATTACHMENTTYPE  NVARCHAR(1)   NOT NULL DEFAULT N''A''')	
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDOCBUFFER ADD ATTACHMENTTYPE FAILED.'')')
				SELECT @ErrMessage = 'Block 38 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDOCBUFFER') AND  NAME = 'REQUIREMENTID')
				BEGIN
					EXECUTE('ALTER TABLE WFDOCBUFFER ADD REQUIREMENTID  int   NOT NULL DEFAULT -1 ')	
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDOCBUFFER ADD REQUIREMENTID FAILED.'')')
				SELECT @ErrMessage = 'Block 39 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRULESTABLE' )
				BEGIN
					EXECUTE('CREATE TABLE WFRulesTable (
		ProcessDefId            INT                NOT NULL,
		ActivityID                INT                NOT NULL,
		RuleId                    INT                NOT NULL,
		Condition                NVARCHAR(255)    NOT NULL,
		Action                    NVARCHAR(255)    NOT NULL    
)	
')		
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFRulesTable FAILED.'')')
				SELECT @ErrMessage = 'Block 40 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFSECTIONSTABLE' )
				BEGIN
					EXECUTE('CREATE TABLE WFSectionsTable (
		ProcessDefId            INT                NOT NULL,
		ProjectId                INT                NOT NULL,
		OrderId                    INT                NOT NULL,
		SectionName                NVARCHAR(255)    NOT NULL,
		Description                NVARCHAR(255)    NULL,
		Exclude                 NVARCHAR(1)  default ''N'' NOT NULL,
		ParentID                INT default 0 NOT NULL,
		SectionId                    INT                NOT NULL
)	
	
')		
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFSectionsTable FAILED.'')')
				SELECT @ErrMessage = 'Block 41 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX2_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX2_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX2_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 42 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX3_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX3_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX3_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 43 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX5_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX5_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX5_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 44 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX7_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX7_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX7_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 45 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX8_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX8_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX8_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 46 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX9_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX9_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX9_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 47 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX12_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX12_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX12_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 48 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX13_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDX13_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX13_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 49 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDXMIGRATION_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('DROP INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('IDXMIGRATION_WFINSTRUMENTTABLE  dropped')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDXMIGRATION_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 50 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX15_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)')
					PRINT('IDX15_WFINSTRUMENTTABLE  Created')
				END
				Else
			    BEGIN
				     EXECUTE('DROP INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('Old IDX15_WFINSTRUMENTTABLE  Dropped')
					EXECUTE('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)')
					PRINT('IDX15_WFINSTRUMENTTABLE  Created')				
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP OR CREATE INDEX IDX15_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 51 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX16_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId)')
					PRINT('IDX16_WFINSTRUMENTTABLE  Created')
				END
				Else
			    BEGIN
				     EXECUTE('DROP INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('Old IDX16_WFINSTRUMENTTABLE  Dropped')
					EXECUTE('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId)')
					PRINT('IDX16_WFINSTRUMENTTABLE  Created')				
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP OR CREATE INDEX IDX16_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 52 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX17_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)')
					PRINT('IDX17_WFINSTRUMENTTABLE  Created')
				END
				Else
			    BEGIN
				     EXECUTE('DROP INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('Old IDX17_WFINSTRUMENTTABLE  Dropped')
					EXECUTE('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)')
					PRINT('IDX17_WFINSTRUMENTTABLE  Created')				
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP OR CREATE INDEX IDX17_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 53 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX18_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
				BEGIN
					EXECUTE('CREATE INDEX IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)')
					PRINT('IDX18_WFINSTRUMENTTABLE  Created')
				END
				Else
			    BEGIN
				     EXECUTE('DROP INDEX IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
					PRINT('Old IDX18_WFINSTRUMENTTABLE  Dropped')
					EXECUTE('CREATE INDEX IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)')
					PRINT('IDX18_WFINSTRUMENTTABLE  Created')				
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP OR CREATE INDEX IDX18_WFINSTRUMENTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 54 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT *FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1 AND TABLE_NAME = 'TODOPICKLISTTABLE' and upper(Column_Name)=upper('PickListId'))
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'TODOPICKLISTTABLE' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE TODOPICKLISTTABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table TODOPICKLISTTABLE altered, Primary Key on TODOPICKLISTTABLE is dropped.'
					END
					EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PRIMARY KEY (ProcessDefId,ToDoId,PickListId)')
					PRINT 'Table TODOPICKLISTTABLE altered, Primary Key on TODOPICKLISTTABLE is dropped.'
				END
				ElSE IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'TODOPICKLISTTABLE' AND CONSTRAINT_TYPE = 'PRIMARY KEY')
				BEGIN
					EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PRIMARY KEY (ProcessDefId,ToDoId,PickListId)')
					PRINT 'Table TODOPICKLISTTABLE altered, Primary Key on TODOPICKLISTTABLE is dropped.'
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE TODOPICKLISTTABLE DROP CONSTRAINT FAILED.'')')
				SELECT @ErrMessage = 'Block 55 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONDEFTABLE')
					AND NAME = 'DESCRIPTION' AND xtype = 231)
				BEGIN
					IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'EXCEPTIONDEFTABLE')
					AND NAME = 'DESCRIPTION' AND xtype = 231 AND LENGTH < 1024)
					BEGIN
						EXECUTE('ALTER TABLE EXCEPTIONDEFTABLE ALTER COLUMN DESCRIPTION NVARCHAR(1024)')
						PRINT 'ExceptionTable column exceptioncomments length altered.'
					END
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXCEPTIONDEFTABLE ALTER COLUMN DESCRIPTION FAILED.'')')
				SELECT @ErrMessage = 'Block 56 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFREPORTPROPERTIESTABLE' )
				BEGIN
					EXECUTE('Create table WFReportPropertiesTable(
						CriteriaID				Int IDENTITY (1,1) PRIMARY KEY,
						CriteriaName			NVARCHAR(255) UNIQUE NOT NULL,
						Description				NVARCHAR(255) Null,
						ChartInfo				Ntext Null,
						ExcludeExitWorkitems	Char(1)   	Not Null ,
						State					int			Not Null,
						LastModifiedOn			DATETIME 	NULL
					)')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create table WFReportPropertiesTable FAILED.'')')
				SELECT @ErrMessage = 'Block 57 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFFILTERDEFTABLE' )
				BEGIN
					EXECUTE('Create Table WFFilterDefTable(
						FilterID	Int IDENTITY (1,1) PRIMARY KEY,
						FilterName	NVARCHAR(255) NOT NULL,
						FilterXML	NTEXT NOT NULL,
						CriteriaID	Int Not NULL,
						FilterColor NVARCHAR(20) NOT NULL,
						ConditionOption	int not null,
						CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
					)')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create table WFFilterDefTable FAILED.'')')
				SELECT @ErrMessage = 'Block 58 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFREPORTOBJASSOCTABLE' )
				BEGIN
					EXECUTE('Create TABLE WFReportObjAssocTable(
						CriteriaID	Int NOT Null,
						ObjectID	Int NOT Null,
						ObjectType	Char (1) CHECK ( ObjectType in (N''P'' , N''Q'' , N''F'')),
						ObjectName	NVARCHAR(255),
						CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
					)')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create table WFREPORTOBJASSOCTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 59 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
		
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFREPORTVARMAPPINGTABLE' )
				BEGIN
					EXECUTE('Create TABLE WFReportVarMappingTable(
						CriteriaID			Int NOT Null,
						VariableId			INT NOT NULL ,
						VariableName		NVARCHAR(50) 	NOT NULL ,
						Type				int 			Not null ,
						VariableType 		char(1) 		NOT NULL ,
						DisplayName			NVARCHAR(50)	NOT NULL ,
						SystemDefinedName	NVARCHAR(50) 	NOT NULL ,
						OrderId				Int 			Not NUll ,
						IsHidden			Char(1)			Not Null ,
						IsSortable			Char(1)			Not Null ,
						LastModifiedDateTime datetime 		Not NULL ,
						MappedType			int 			not null ,
						DisableSorting 		char(1) 		NOT NULL,
						CONSTRAINT	pk_WFReportVarMappingTable PRIMARY KEY(CriteriaID,VariableId),
						CONSTRAINT	uk_WFReportVarMappingTable UNIQUE(CriteriaID,DisplayName)
					)')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create table WFReportVarMappingTable FAILED.'')')
				SELECT @ErrMessage = 'Block 60 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM WFOBJECTLISTTABLE WHERE  ObjectType = 'CRM' AND UPPER(ObjectTypeName) = 'CRITERIA MANAGEMENT' )
				BEGIN
					EXECUTE('INSERT INTO WFOBJECTLISTTABLE values (''CRM'',''Criteria Management'',0,''com.newgen.wf.rightmgmt.WFRightGetCriteriaList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')')
					
					SELECT @v_ObjectTypeId=ObjectTypeId FROM WFOBJECTLISTTABLE where ObjectType='CRM'
					
					EXECUTE('INSERT INTO wfassignablerightstable VALUES ('+@v_ObjectTypeId+',''V'',''View'', 2)')
	
					EXECUTE('INSERT INTO wfassignablerightstable VALUES ('+@v_ObjectTypeId+',''M'',''Modify'', 3)')
	
					EXECUTE('INSERT INTO wfassignablerightstable VALUES ('+@v_ObjectTypeId+',''D'',''Delete'', 4)')
	
					EXECUTE('INSERT INTO wffilterlisttable VALUES ('+@v_ObjectTypeId+',''Criteria Name'',''CriteriaName'')')
				END
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert in to table wfassignablerightstable FAILED.'')')
				SELECT @ErrMessage = 'Block 61 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFTransientVarTable' )
			BEGIN
				EXECUTE('create TABLE WFTransientVarTable(
    ProcessDefId             INT                 NOT NULL,
    OrderId                 INT                 NOT NULL,
    FieldName                 NVARCHAR(50)      NOT NULL,
    FieldType                 NVARCHAR(255)      NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue             NVARCHAR(255)      NULL,
    VarPrecision             INT                 NULL,    
	VarScope                   NVARCHAR(2)   DEFAULT ''U''   NOT NULL,
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)

')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert in to table wfassignablerightstable FAILED.'')')
			SELECT @ErrMessage = 'Block 62 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFScriptData' )
			BEGIN
				EXECUTE('create TABLE  WFScriptData(
    ProcessDefId             INT                NOT NULL,
    ActivityId                 INT             NOT NULL,     
    RuleId                     INT                NOT NULL,
    OrderId                 INT              NOT NULL,
    Command                 nvarchar(255)   NOT NULL,
    Target                     nvarchar(255)   NULL,
    Value                     nvarchar(255)   NULL,
    Type                      nvarchar(1)     NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    ExtObjId                 INT             NOT NULL     
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFScriptData FAILED.'')')
			SELECT @ErrMessage = 'Block 63 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRuleFlowData' )
			BEGIN
				EXECUTE('  create TABLE  WFRuleFlowData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    RuleOrderId             INT              NOT NULL,
    RuleType                 nvarchar(1)     NOT NULL,
    RuleName                 nvarchar(100)     NOT NULL,
    RuleTypeId                 INT             NOT NULL,
    Param1                     nvarchar(255)     NULL,
    Type1                     nvarchar(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar(255)     NULL,
    Type2                     nvarchar(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,
    Param3                     nvarchar(255)     NULL,
    Type3                     nvarchar(1)     NOT NULL,
    ExtObjID3                 INT              NOT NULL,
    VariableId_3             INT              NOT NULL,
    VarFieldId_3             INT              NOT NULL,
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL,
    IndentLevel             INT             NOT NULL
  )  
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFRuleFlowData FAILED.'')')
			SELECT @ErrMessage = 'Block 64 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRuleFileInfo' )
			BEGIN
				EXECUTE('create table WFRuleFileInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    FileType                 nvarchar(1)     NOT NULL,
    RowHeader                 INT             NOT NULL,
    Destination             nvarchar(255)     NULL,
    PickCriteria              nvarchar(255)     NULL,
    FromSize                  numeric(15,2)              NULL,
    ToSize                  numeric(15,2)              NULL,
    SizeUnit                  nvarchar(3)     NULL,
    FromModificationDate      datetime              NULL,
    ToModificationDate      datetime              NULL,
    FromCreationDate          datetime              NULL,
    ToCreationDate          datetime              NULL,
    PathType                INT                    NULL,
    DocId                    INT                    NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFRuleFileInfo FAILED.'')')
			SELECT @ErrMessage = 'Block 65 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFWORKITEMMAPPINGTABLE' )
			BEGIN
				EXECUTE('create table WFWORKITEMMAPPINGTABLE(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    VariableName              nvarchar(255)      NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    VariableType             nvarchar(2)     NOT NULL,
    ExtObjId                 INT              NOT NULL,
    MappedVariable          nvarchar(255)      NULL,
    MapType                 nvarchar(2)  DEFAULT ''V'' NOT NULL 
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFWORKITEMMAPPINGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 66 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFExcelMapInfo' )
			BEGIN
				EXECUTE('create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    ColumnName              nvarchar(255)      NULL,
    ColumnType                 INT             NOT NULL,
    VarName                  nvarchar(255)      NULL,
    VarScope                 nvarchar(1)      NULL,
    VarType                 INT             NOT NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFWORKITEMMAPPINGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 67 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRuleFlowMappingTable' )
			BEGIN
				EXECUTE('create TABLE  WFRuleFlowMappingTable(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    ExtMethodIndex             INT              NOT NULL,
    MapType                 nvarchar(1)      NOT NULL,
    ExtMethodParamIndex     INT              NOT NULL,
    MappedField              nvarchar(255)      NULL,
    MappedFieldType         nvarchar(1)       NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    DataStructureId         INT              NOT NULL 
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFRuleFlowMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 68 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRoboticVarDocMapping' )
			BEGIN
				EXECUTE('create TABLE  WFRoboticVarDocMapping(
    ProcessDefId             INT             NOT NULL,
    FieldName                 nvarchar(255)     NOT NULL, 
    MappedFieldName         nvarchar(255)     NOT NULL,                                                                                    
    ExtObjId                   INT             NOT NULL, 
    VariableId                 INT              NOT NULL, 
    Attribute                 nvarchar(2)     NOT NULL,        
    VariableType              INT             NOT NULL,  
    VariableScope           nvarchar(2)     NOT NULL,  
    VariableLength             INT             NOT NULL,   
    VarPrecision               INT             NOT NULL,
    Unbounded               nvarchar(2)      NOT NULL,  
    MapType                 nvarchar(2)     DEFAULT ''V'' NOT NULL 
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFRoboticVarDocMapping FAILED.'')')
			SELECT @ErrMessage = 'Block 69 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFAssociatedExcpTable' )
			BEGIN
				EXECUTE('create TABLE  WFAssociatedExcpTable(
     ProcessDefId             INT             NOT NULL,
     ActivityId             INT             NOT NULL,
     OrderId                 INT              NOT NULL,
     CodeId                 nvarchar(1000)    NOT NULL, 
     TriggerId                 nvarchar(1000)  NOT NULL                                                                                        
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFAssociatedExcpTable FAILED.'')')
			SELECT @ErrMessage = 'Block 70 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFRuleExceptionData' )
			BEGIN
				EXECUTE('create TABLE  WFRuleExceptionData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,    
    Param1                     nvarchar(255)     NULL,
    Type1                     nvarchar(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar(255)     NULL,
    Type2                     nvarchar(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,   
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL    
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFRuleExceptionData FAILED.'')')
			SELECT @ErrMessage = 'Block 70 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFDBDetails' )
			BEGIN
				EXECUTE('CREATE TABLE WFDBDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    IsolateFlag nvarchar(2) NOT NULL,
    ConfigurationID int NOT NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFDBDetails FAILED.'')')
			SELECT @ErrMessage = 'Block 71 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFTableDetails' )
			BEGIN
				EXECUTE('CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName nvarchar(255) NOT NULL,
    EntityType nvarchar(2) NOT NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFTableDetails FAILED.'')')
			SELECT @ErrMessage = 'Block 72 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFTableJoinDetails' )
			BEGIN
				EXECUTE('CREATE TABLE WFTableJoinDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId_1 int  NOT NULL,
    ColumnName_1 nvarchar(255) NOT NULL,
    EntityId_2 int  NOT NULL,
    ColumnName_2 nvarchar(255) NOT NULL,
    JoinType int  NOT NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFTableJoinDetails FAILED.'')')
			SELECT @ErrMessage = 'Block 73 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFTableFilterDetails' )
			BEGIN
				EXECUTE('CREATE TABLE WFTableFilterDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    ColumnName nvarchar(255) NOT NULL,
    VarName nvarchar(255) NOT NULL,
    VarType nvarchar(2) NOT NULL,
    ExtObjId int NOT NULL,
    VarId int NOT NULL,
    VarFieldId int NOT NULL,
    Operator int  NOT NULL,
    LogicalOperator int NOT NULL
)
')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFTableFilterDetails FAILED.'')')
			SELECT @ErrMessage = 'Block 74 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'WFTableMappingDetails' )
			BEGIN
				EXECUTE('CREATE TABLE WFTableMappingDetails(
							ProcessDefId int NOT NULL,
							ActivityId int NOT NULL,
							RuleId int  NOT NULL,
							OrderId int  NOT NULL,
							EntityType nvarchar(2) NOT NULL,
							EntityName nvarchar(255) NOT NULL,
							ColumnName nvarchar(255) NOT NULL,
							Nullable nvarchar(2) NOT NULL,
							VarName nvarchar(255) NOT NULL,
							VarType nvarchar(2) NOT NULL,
							VarId int NOT NULL,
							VarFieldId int  NOT NULL,
							ExtObjId int NOT NULL,
							Type  INT NOT NULL,
							ColumnType nvarchar(255) NULL,
							VarName1 nvarchar(255) NOT NULL,
							VarType1 nvarchar(2) NOT NULL,
							VarId1 int NOT NULL,
							VarFieldId1 int NOT NULL,
							ExtObjId1 int NOT NULL,
							Type1 INT NOT NULL,
							Operator int NOT NULL,
							OperationType nvarchar(2) Default ''E'' NOT NULL
)

')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create TABLE  WFTableMappingDetails FAILED.'')')
			SELECT @ErrMessage = 'Block 75 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'ManualProcessingFlag')
	BEGIN
		DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
			open varCursor
			FETCH NEXT FROM varCursor INTO @ProcessDefId
			WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			BEGIN TRANSACTION trans
				
				EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10024,    ''ManualProcessingFlag'',''ManualProcessingFlag'',     10,    ''M''    ,0,    ''N'',    1   ,0    ,''N'')')
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
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable  FAILED.'')')
			SELECT @ErrMessage = 'Block 76 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
	END CATCH
	END
	
	/* adding changes to add DBExErrCode and DBExErrDesc */
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFInstrumentTable') AND  NAME = 'DBExErrCode')
			BEGIN
				EXECUTE('Alter table WFInstrumentTable add	DBExErrCode     int       NULL')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFInstrumentTable add	DBExErrCode FAILED.'')')
			SELECT @ErrMessage = 'Block 77 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFInstrumentTable') AND  NAME = 'DBExErrDesc')
			BEGIN
				EXECUTE('Alter table WFInstrumentTable add	DBExErrDesc     NVARCHAR(255)       NULL')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFInstrumentTable add	DBExErrDesc FAILED.'')')
			SELECT @ErrMessage = 'Block 78 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'DBExErrCode')
			BEGIN
				EXECUTE('Alter table QUEUEHISTORYTABLE add	DBExErrCode     int       NULL')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table QUEUEHISTORYTABLE add	DBExErrCode FAILED.'')')
			SELECT @ErrMessage = 'Block 79 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'DBExErrDesc')
			BEGIN
				EXECUTE('Alter table QUEUEHISTORYTABLE add	DBExErrDesc     NVARCHAR(255)       NULL')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table QUEUEHISTORYTABLE add	DBExErrDesc FAILED.'')')
			SELECT @ErrMessage = 'Block 80 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'DBExErrCode')
			BEGIN
				DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
				open varCursor
				FETCH NEXT FROM varCursor INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
					BEGIN
						BEGIN TRANSACTION trans
							
							EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10025,    ''DBExErrCode'',''DBExErrCode'',     3,    ''M''    ,0,    NULL,    2   ,0    ,''N'')')
						COMMIT TRANSACTION trans
						FETCH NEXT FROM varCursor INTO @ProcessDefId
					END
				CLOSE varCursor
				DEALLOCATE varCursor
			END
		END TRY
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 1)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 81 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS(SELECT VariableId  FROM VarMappingTable WHERE SystemDefinedName = 'DBExErrDesc')
		BEGIN
			DECLARE varCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM VarMappingTable
			open varCursor
			FETCH NEXT FROM varCursor INTO @ProcessDefId
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					
					EXECUTE('insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('+@ProcessDefId+ ',  10026,    ''DBExErrDesc'',''DBExErrDesc'',     10,    ''M''    ,0,    NULL,    255   ,0    ,''N'')')
				COMMIT TRANSACTION trans
				FETCH NEXT FROM varCursor INTO @ProcessDefId
			END
			CLOSE varCursor
			DEALLOCATE varCursor
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 82 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	/* adding changes to add DBExErrCode and DBExErrDesc till here*/
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFBRMSRULESETINFO') AND  NAME = 'RULETYPE')
			BEGIN
				EXECUTE('ALTER TABLE WFBRMSRULESETINFO ADD RuleType              NVARCHAR(1)   NOT NULL DEFAULT N''P''')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into VarMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 83 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			BEGIN
				Execute ('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''iBPS_4.0_SP1'', GETDATE(), GETDATE(), N''UpgradeIBPS_A_OFserver_5.sql'', N''Y'')')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT INTO WFCabVersionTable FAILED.'')')
			SELECT @ErrMessage = 'Block 84 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'MANUALPROCESSINGFLAG')
		BEGIN
			EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD ManualProcessingFlag NVARCHAR(1) NOT NULL Default ''N''')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD ManualProcessingFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 85 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'MANUALPROCESSINGFLAG')
		BEGIN
			EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD ManualProcessingFlag NVARCHAR(1) NOT NULL Default ''N''')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD ManualProcessingFlag  FAILED.'')')
			SELECT @ErrMessage = 'Block 86 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
			
	BEGIN
	BEGIN TRY
		BEGIN TRANSACTION EXTMETHOD_TRANS
		IF ((SELECT COUNT(1) FROM EXTMETHODDEFTABLE WITH(NOLOCK) WHERE ProcessDefId = 0 and ExtMethodIndex = 1) = 0 )
		BEGIN
			DELETE FROM EXTMETHODDEFTABLE WHERE ProcessDefId > 0 and ExtMethodIndex >=1 and ExtMethodIndex <=34
			DELETE FROM EXTMETHODPARAMDEFTABLE WHERE ProcessDefId > 0 and ExtMethodIndex >=1 and ExtMethodIndex <=34

			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 1,'System','S','contains','', NULL, 12,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 2,'System','S','normalizeSpace','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 3,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 4,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 5,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 6,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 7,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 8,'System','S','stringValue','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 9,'System','S','booleanValue','', NULL, 12,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 10,'System','S','booleanValue','', NULL, 12,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 11,'System','S','startsWith','', NULL, 12,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 12,'System','S','stringLength','', NULL, 3,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 13,'System','S','subString','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 14,'System','S','subStringBefore','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 15,'System','S','subStringAfter','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 16,'System','S','translate','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 17,'System','S','concat','', NULL, 10,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 18,'System','S','numberValue','', NULL, 6,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 19,'System','S','numberValue','', NULL, 6,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 20,'System','S','numberValue','', NULL, 6,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 21,'System','S','numberValue','', NULL, 6,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 22,'System','S','numberValue','', NULL, 6,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 23,'System','S','round','', NULL, 4,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 24,'System','S','floor','', NULL, 4,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 25,'System','S','ceiling','', NULL, 4,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 26,'System','S','getCurrentDate','', NULL, 15,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 27,'System','S','getCurrentTime','', NULL, 16,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 28,'System','S','getCurrentDateTime','', NULL, 8,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 29,'System','S','getShortDate','', NULL, 15,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 30,'System','S','getTime','', NULL, 16,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 31,'System','S','roundToInt','', NULL, 3,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 32,'System','S','getElementAtIndex','', NULL, 3,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 33,'System','S','addElementToArray','', NULL, 3,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 34,'System','S','deleteChildWorkitem','', NULL, 3,'', 0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4001,'System','S','InvokeDBFuncExecuteString','',NULL,10,'',0)
			INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4002,'System','S','InvokeDBFuncExecuteInt','',NULL,3,'',0) 			

			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 1, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 1, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 2, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 3, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 4, 'Param1', 8, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 5, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 6, 'Param1', 4, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 7, 'Param1', 3, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 8, 'Param1', 12, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 9, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 10, 'Param1', 3, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 11, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 11, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 12, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 13, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 13, 'Param2', 3, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 13, 'Param3', 3, 3, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 14, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 14, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 15, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 15, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 16, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 16, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 16, 'Param3', 10, 3, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 17, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 17, 'Param2', 10, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 18, 'Param1', 10, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 19, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 20, 'Param1', 4, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 21, 'Param1', 3, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 22, 'Param1', 12, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 23, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 24, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 25, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 29, 'Param1', 8, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 30, 'Param1', 8, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 31, 'Param1', 6, 1, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 32, 'Param1', 3, 1, 0, ' ', 'Y')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 32, 'Param2', 3, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 33, 'Param1', 3, 1, 0, ' ', 'Y')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 33, 'Param2', 3, 2, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 33, 'Param3', 3, 3, 0, ' ', 'N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4001,'StoredProcedureName',10,1,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4001,'Param1',10,2,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4001,'Param2',3,3,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4001,'Param3',8,4,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4002,'StoredProcedureName',10,1,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4002,'Param1',10,2,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4002,'Param2',3,3,0,' ','N')
			INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4002,'Param3',8,4,0,' ','N')
		END
		COMMIT TRANSACTION EXTMETHOD_TRANS
	END TRY
	BEGIN CATCH
		SELECT @V_TRAN_STATUS = XACT_STATE()
		IF(@V_TRAN_STATUS > 0)
				ROLLBACK TRANSACTION EXTMETHOD_TRANS
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT EXTMETHODPARAMDEFTABLE FAILED.'')')
		SELECT @ErrMessage = 'Block 89 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF EXISTS(SELECT name from sysobjects where name='WF_GROUPMEMBER_UPD')
		BEGIN
			EXECUTE('DROP TRIGGER WF_GROUPMEMBER_UPD') 
			PRINT('Trigger dropped WF_GROUPMEMBER_UPD')
		END
		ELSE
		BEGIN
			SELECT @DELETEUSERQUEUETABLEDATA = 1
		END
		EXECUTE('CREATE TRIGGER WF_GROUPMEMBER_UPD
				ON PDBGROUPMEMBER
				AFTER DELETE, INSERT  
				AS
				DECLARE @V_USERINDEX INTEGER
				BEGIN 
					BEGIN
						DECLARE C_DELETED CURSOR FOR SELECT USERINDEX FROM DELETED
						BEGIN
							OPEN C_DELETED
							FETCH NEXT FROM C_DELETED INTO @V_USERINDEX
							WHILE(@@FETCH_STATUS = 0)
							BEGIN
								DELETE FROM USERQUEUETABLE WHERE USERID = @V_USERINDEX
								FETCH NEXT FROM C_DELETED INTO @V_USERINDEX
							END
							CLOSE C_DELETED
							DEALLOCATE C_DELETED
						END
					END

					BEGIN
						DECLARE C_INSERTED CURSOR FOR SELECT USERINDEX FROM INSERTED
						BEGIN
							OPEN C_INSERTED
							FETCH NEXT FROM C_INSERTED INTO @V_USERINDEX
							WHILE(@@FETCH_STATUS = 0)
							BEGIN
								DELETE FROM USERQUEUETABLE WHERE USERID = @V_USERINDEX
								FETCH NEXT FROM C_INSERTED INTO @V_USERINDEX
							END
							CLOSE C_INSERTED
							DEALLOCATE C_INSERTED
						END
					END
				END')
		PRINT('Trigger WF_GROUPMEMBER_UPD created')
		IF(@DELETEUSERQUEUETABLEDATA = 1)
		BEGIN
			EXECUTE('Delete from UserQueueTable')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TRIGGER WF_GROUPMEMBER_UPD FAILED.'')')
		SELECT @ErrMessage = 'Block 90 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF EXISTS(SELECT name from sysobjects where name='WF_GROUP_DEL')
		BEGIN
			EXECUTE('DROP TRIGGER WF_GROUP_DEL') 
			PRINT('Trigger dropped WF_GROUP_DEL')
		END
		EXECUTE('CREATE TRIGGER WF_GROUP_DEL
				ON PDBGROUP  
				AFTER DELETE 
				AS
				DECLARE @V_GROUPINDEX INT
				BEGIN
					SELECT @V_GROUPINDEX = DELETED.GROUPINDEX FROM DELETED
					DELETE FROM QUEUEUSERTABLE WHERE USERID = @V_GROUPINDEX AND ASSOCIATIONTYPE = 1 
				END')
		PRINT('Trigger WF_GROUP_DEL created')
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TRIGGER WF_GROUP_DEL FAILED.'')')
		SELECT @ErrMessage = 'Block 91 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE NAME = 'PDBPMS_TABLE' )
			BEGIN
				EXECUTE('CREATE TABLE PDBPMS_TABLE
				(
					Product_Name   NVARCHAR(255),
					Product_Version               NVARCHAR(255),
					Product_Type     NVARCHAR(255),
					Patch_Number   INT null,
					Install_Date    NVARCHAR(255)
				)')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE PDBPMS_TABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 92 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'WFDMSUserInfo')
		BEGIN
			EXECUTE('CREATE TABLE WFDMSUserInfo(UserName NVARCHAR(64) NOT NULL)')
			EXECUTE('INSERT INTO WFDMSUserInfo(UserName) VALUES(''Of_Sys_User'')')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFDMSUserInfo FAILED.'')')
		SELECT @ErrMessage = 'Block 93 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	--Adding queue for data exchange workstep
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemDXQueue')
		BEGIN		
			EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemDXQueue'',''A'',''System generated common Data Exchange Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''insert into QueueDefTable FAILED.'')')
		SELECT @ErrMessage = 'Block 94 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX5_QueueHistoryTable') AND object_id=OBJECT_ID('dbo.QueueHistoryTable'))
			BEGIN
				EXECUTE('CREATE INDEX  IDX5_QueueHistoryTable  ON QueueHistoryTable(Q_UserId, LockStatus)')
				PRINT('IDX5_QueueHistoryTable  Created')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX5_QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 95 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			BEGIN
				Execute ('delete from WFRoutingServerInfo')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFRoutingServerInfo FAILED.'')')
			SELECT @ErrMessage = 'Block 96 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SYS.COLUMNS WITH(NOLOCK) WHERE OBJECT_ID = OBJECT_ID('WFSystemServicesTable') AND NAME = 'RegisteredBy')
		BEGIN
			EXECUTE('ALTER TABLE WFSystemServicesTable ADD RegisteredBy NVARCHAR(64) NULL DEFAULT (''SUPERVISOR'')')
			EXECUTE('UPDATE WFSystemServicesTable SET RegisteredBy = ''SUPERVISOR''')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSystemServicesTable ADD RegisteredBy FAILED.'')')
		SELECT @ErrMessage = 'Block 97 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFCustomServicesStatusTable')
		BEGIN
			EXECUTE('
				CREATE TABLE WFCustomServicesStatusTable (
					PSID				INT NOT NULL PRIMARY KEY,
					ServiceStatus		INT NOT NULL,
					ServiceStatusMsg	NVARCHAR(100) NOT NULL,
					WorkItemCount		INT NOT NULL,
					LastUpdated			DATETIME NOT NULL DEFAULT (GETDATE())
				)
			')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFCustomServicesStatusTable FAILED.'')')
		SELECT @ErrMessage = 'Block 98 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFServiceAuditTable')
		BEGIN
			EXECUTE('
				CREATE TABLE WFServiceAuditTable (
					LogId				BIGINT IDENTITY(1, 1) NOT NULL,
					PSID				INT NOT NULL,
					ServiceName			NVARCHAR(100) NOT NULL,
					ServiceType			NVARCHAR(50) NOT NULL,
					ActionId			INT NOT NULL,
					ActionDateTime		DATETIME NOT NULL DEFAULT (GETDATE()),
					Username			NVARCHAR(64) NOT NULL,
					ServerDetails		NVARCHAR(30) NOT NULL,
					ServiceParamDetails	NVARCHAR(1000) NULL
				)
			')
			EXECUTE('CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UserName, ActionDateTime)')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFServiceAuditTable FAILED.'')')
		SELECT @ErrMessage = 'Block 99 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFServiceAuditTable_History')
		BEGIN
			EXECUTE('
				CREATE TABLE WFServiceAuditTable_History (
					LogId				BIGINT NOT NULL,
					PSID				INT NOT NULL,
					ServiceName			NVARCHAR(100) NOT NULL,
					ServiceType			NVARCHAR(50) NOT NULL,
					ActionId			INT NOT NULL,
					ActionDateTime		DATETIME NOT NULL,
					Username			NVARCHAR(64) NOT NULL,
					ServerDetails		NVARCHAR(30) NOT NULL,
					ServiceParamDetails	NVARCHAR(1000) NULL
				)
			')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFServiceAuditTable_History FAILED.'')')
		SELECT @ErrMessage = 'Block 100 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END

	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFServicesListTable')
		BEGIN
			EXECUTE('
				CREATE TABLE WFServicesListTable (
					PSID				INT NOT NULL,
					ServiceId			INT NOT NULL,
					ServiceName			NVARCHAR(50) NOT NULL,
					ServiceType			NVARCHAR(50) NOT NULL,
					ProcessDefId		INT NOT NULL,
					ActivityId			INT NOT NULL
				)
			')
			EXECUTE('INSERT INTO WFServicesListTable(PSID, ServiceId, ServiceName, ServiceType, ProcessDefId, ActivityId) SELECT PSID, ServiceId, ServiceName, ServiceType, ISNULL(ProcessDefId, 0), 0 FROM WFSystemServicesTable WITH(NOLOCK)')
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFServicesListTable FAILED.'')')
		SELECT @ErrMessage = 'Block 101 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END
	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME = 'VOLUMEID')
		BEGIN
			EXECUTE('Alter table PROCESSDEFTABLE add	VolumeId INT  NULL ')
			BEGIN
				DECLARE processCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM ProcessDefTable
				open processCursor
				FETCH NEXT FROM processCursor INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
						SELECT @v_folderIndex=WorkFlowFolderId FROM RouteFolderDefTable where ProcessDefId=@ProcessDefId
						SELECT @v_volumeId=ImageVolumeIndex FROM PDBFolder where FolderIndex=@v_folderIndex
				
						EXECUTE('UPDATE ProcessDefTable SET VolumeID = '+@v_volumeId+' where ProcessdefId='+@ProcessDefId)
						FETCH NEXT FROM processCursor INTO @ProcessDefId
				END
				CLOSE processCursor
				DEALLOCATE processCursor
			END 
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PROCESSDEFTABLE add VolumeID FAILED.'')')
		SELECT @ErrMessage = 'Block 102 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END
	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME = 'SITEID')
		BEGIN
			EXECUTE('Alter table PROCESSDEFTABLE add	SiteId INT  NULL ')
			BEGIN
				DECLARE processCursor CURSOR STATIC FOR SELECT distinct(ProcessDefId) FROM ProcessDefTable
				open processCursor
				FETCH NEXT FROM processCursor INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
						SELECT @v_folderIndex=WorkFlowFolderId FROM RouteFolderDefTable where ProcessDefId=@ProcessDefId
						SELECT @v_volumeId=ImageVolumeIndex FROM PDBFolder where FolderIndex=@v_folderIndex
					--	SELECT @v_siteId=HomeSite From ISVOLUME where VolumeId=@v_volumeId
						
						SELECT @v_cabinettype=CABINETTYPE FROM PDBCABINET;
						IF (@v_cabinettype = 'R')
						BEGIN
							SET @v_siteId = 1;
							--DBMS_OUTPUT.PUT_LINE('v_siteId AND  SCRIPT' || v_siteId );
						END;
						ELSE 
						BEGIN
							
						SELECT @v_siteId=HomeSite From ISVOLUME where VolumeId=@v_volumeId
							IF(@v_siteId IS NULL )
							BEGIN
								SET @v_siteId = 1;
							END;
						--DBMS_OUTPUT.PUT_LINE('v_siteId AND  SCRIPT' || v_siteId );
						END;
				
				
						EXECUTE('UPDATE ProcessDefTable SET SITEID = '+@v_siteId+' where ProcessdefId='+@ProcessDefId)
						FETCH NEXT FROM processCursor INTO @ProcessDefId
				END
				CLOSE processCursor
				DEALLOCATE processCursor
			END 
		END
	END TRY
	BEGIN CATCH
		EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PROCESSDEFTABLE add SiteId FAILED.'')')
		SELECT @ErrMessage = 'Block 103 ' + ERROR_MESSAGE()
		RAISERROR(@ErrMessage,16,1)
		RETURN
	END CATCH
	END
	--Added block to modify instructions column in WFTaskStatusTable from VARCHAR to NVARCHAR
	BEGIN
		BEGIN TRY
			--xtype = 167 => for data type VARCHAR in MSSQL
			--xtype = 231 => for data type NVARCHAR in MSSQL
			IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFTASKSTATUSTABLE') AND NAME = 'INSTRUCTIONS' AND xtype = 167)
			BEGIN
				EXECUTE('ALTER TABLE WFTASKSTATUSTABLE ALTER COLUMN INSTRUCTIONS NVARCHAR(2000) NULL')
				PRINT 'WFTASKSTATUSTABLE Tables INSTRUCTIONS column data type altered.'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PROCESSDEFTABLE add VolumeID FAILED.'')')
			SELECT @ErrMessage = 'Block 104 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFTASKSTATUSHISTORYTABLE') AND NAME = 'INSTRUCTIONS' AND xtype = 167)
			BEGIN
				EXECUTE('ALTER TABLE WFTASKSTATUSHISTORYTABLE ALTER COLUMN INSTRUCTIONS NVARCHAR(2000) NULL')
				PRINT 'WFTASKSTATUSHISTORYTABLE Tables INSTRUCTIONS column data type altered.'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFTASKSTATUSHISTORYTABLE ALTER COLUMN INSTRUCTIONS FAILED.'')')
			SELECT @ErrMessage = 'Block 105 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	--Added block to modify instructions column in WFTaskStatusTable from VARCHAR to NVARCHAR till here
	
	BEGIN
		BEGIN TRY
			BEGIN
				update wfactionstatustable set type ='C',status='N' where actionid in (23,24) and status = 'Y'; 
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update wfactionstatustable FAILED.'')')
			SELECT @ErrMessage = 'Block 106 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX12_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
			BEGIN
				EXECUTE('CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)')
				PRINT('IDX12_WFINSTRUMENTTABLE  Created')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 107 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
		BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX19_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
			BEGIN
				EXECUTE('CREATE INDEX IDX19_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ProcessDefId, ActivityId)')
				PRINT('IDX19_WFINSTRUMENTTABLE  Created')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX19_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 108 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX6_QueueHistoryTable') AND object_id=OBJECT_ID('dbo.QueueHistoryTable'))
			BEGIN
				EXECUTE('CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable(ProcessDefId, ActivityId)')
				PRINT('IDX6_QueueHistoryTable  Created')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 109 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX11_WFINSTRUMENTTABLE') AND object_id=OBJECT_ID('dbo.WFINSTRUMENTTABLE'))
			BEGIN
				EXECUTE('DROP INDEX IDX11_WFINSTRUMENTTABLE ON dbo.WFINSTRUMENTTABLE')
				PRINT('IDX11_WFINSTRUMENTTABLE  Dropped')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX11_WFINSTRUMENTTABLE ON dbo.WFINSTRUMENTTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 110 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX2_QueueHistoryTable') AND object_id=OBJECT_ID('dbo.QueueHistoryTable'))
			BEGIN
				EXECUTE('DROP INDEX IDX2_QueueHistoryTable ON dbo.QueueHistoryTable')
				PRINT('IDX2_QueueHistoryTable  Dropped')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX2_QueueHistoryTable ON dbo.QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 111 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX4_QueueHistoryTable') AND object_id=OBJECT_ID('dbo.QueueHistoryTable'))
			BEGIN
				EXECUTE('DROP INDEX IDX4_QueueHistoryTable ON dbo.QueueHistoryTable')
				PRINT('IDX4_QueueHistoryTable  Dropped')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX4_QueueHistoryTable ON dbo.QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 112 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * from sys.indexes where UPPER(name)=UPPER('IDX5_QueueHistoryTable') AND object_id=OBJECT_ID('dbo.QueueHistoryTable'))
			BEGIN
				EXECUTE('DROP INDEX IDX5_QueueHistoryTable ON dbo.QueueHistoryTable')
				PRINT('IDX5_QueueHistoryTable  Dropped')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX4_QueueHistoryTable ON dbo.QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 113 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
		END
		
		
		BEGIN
			BEGIN TRY
				IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WorklistTable' and xtype = 'V')
						BEGIN
							EXECUTE('DROP VIEW WorklistTable')
						END
				EXECUTE ('Create View WORKLISTTABLE
							As 
							
								SELECT ProcessInstanceId  ,WorkItemId ,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime, 
								ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,Createddatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus, 
								LockedTime,Queuename,Queuetype,NotifyStatus,Guid,Q_DivertedByUserId   
								FROM wfinstrumenttable WITH(NOLOCK)  
								where routingstatus = ''N''')
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create View WORKLISTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 114 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END	
		
		BEGIN
			BEGIN TRY						
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'PENDINGWORKLISTTABLE' and xtype = 'V')
				BEGIN
					EXECUTE('DROP VIEW PENDINGWORKLISTTABLE')
				END
			EXECUTE ('Create View PENDINGWORKLISTTABLE
				As 
		 
			SELECT ProcessInstanceId  ,WorkItemId ,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime, 
			ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,Createddatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus, 
			LockedTime,Queuename,Queuetype,NotifyStatus,
			NoOfCollectedInstances,IsPrimaryCollected,ExportStatus,Q_DivertedByUserId  
			
			FROM wfinstrumenttable WITH(NOLOCK)  
			where Processinstancestate  IN (4,5,6) OR (assignmenttype = ''Z'' OR WorkItemState IN (3,8)) ')	
			END TRY
			BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create View PENDINGWORKLISTTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 115 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				RETURN
			END CATCH
		END	
		
		
	BEGIN
		BEGIN TRY	
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'ProcessInstanceTable' and xtype = 'V')
			BEGIN
				EXECUTE('DROP VIEW ProcessInstanceTable')
			END
			EXECUTE ('Create View ProcessInstanceTable 
					As 
			
				SELECT ProcessInstanceId,ProcessDefID,Createdby,CreatedByName,CreatedDatetime,IntroducedById,
				Introducedby,IntroductionDateTime,ProcessInstanceState,ExpectedProcessDelay,IntroducedAt
				FROM wfinstrumenttable WITH(NOLOCK)  
				where workitemid = 1')	
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create View ProcessInstanceTable FAILED.'')')
			SELECT @ErrMessage = 'Block 116 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

	BEGIN
		BEGIN TRY
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'QueueDataTable' and xtype = 'V')
				BEGIN
					EXECUTE('DROP VIEW QueueDataTable')
				END
			EXECUTE ('Create View QueueDataTable 
					As 
					 
						SELECT ProcessInstanceId  ,WorkItemId ,
						VAR_INT1 ,VAR_INT2 ,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,
						VAR_FLOAT1,VAR_FLOAT2, VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,
						VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
						VAR_REC_1,VAR_REC_2, VAR_REC_3,VAR_REC_4,VAR_REC_5,InstrumentStatus, CheckListCompleteFlag,
						SaveStage, HoldStatus,Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId,
						ChildWorkitemId, ParentWorkItemID,CalendarName 				
						FROM wfinstrumenttable WITH(NOLOCK)  ')	
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create View QueueDataTable FAILED.'')')
			SELECT @ErrMessage = 'Block 117 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY		
			IF  EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WorkDoneTable' and xtype = 'V')
				BEGIN
					EXECUTE('DROP VIEW WorkDoneTable')
				END
				EXECUTE ('Create View WorkDoneTable 
					As 
					 
						SELECT ProcessInstanceId,WorkItemId ,ProcessName ,	ProcessVersion  ,ProcessDefID , LastProcessedBy, ProcessedBy, ActivityName  ,	ActivityId ,EntryDateTime ,ParentWorkItemId	,AssignmentType	 , CollectFlag	,PriorityLevel	,ValidTill ,	Q_StreamId	,Q_QueueId	, Q_UserId ,AssignedUser ,	FilterValue	, CreatedDatetime , WorkItemState ,
						Statename 	, ExpectedWorkitemDelay	, PreviousStage	 , LockedByName	,LockStatus	, LockedTime , 
						Queuename , Queuetype , NotifyStatus , Guid , Q_DivertedByUserId   
						FROM wfinstrumenttable WITH(NOLOCK) where routingstatus = ''Y'' ')
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create View WorkDoneTable FAILED.'')')
			SELECT @ErrMessage = 'Block 118 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		


	BEGIN 
		BEGIN TRY
			IF CURSOR_STATUS('global','cur_processtab') >= -1
			BEGIN
				IF CURSOR_STATUS('global','cur_processtab') > -1
					BEGIN
							CLOSE cur_processtab
					END
				DEALLOCATE cur_processtab
			END
			DECLARE cur_processtab CURSOR STATIC FOR select ProcessDefId, ActivityId, ExpiryActivity 
			from ACTIVITYTABLE with (nolock) where ExpiryActivity is not null and ExpiryActivity <> '' and ExpiryActivity <> 'previousstage'
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT into WORKSTAGELINKTABLE sTARTED.'')')
			OPEN cur_processtab
			FETCH NEXT FROM cur_processtab INTO @ProcessDefId , @ActivityId , @ExpiryActivity
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF NOT EXISTS(select * from WORKSTAGELINKTABLE  with (nolock) where type = 'X' and ProcessDefId = @processdefid and SourceId = @activityid)
					BEGIN
							select @connid = MAX(connectionid) from WORKSTAGELINKTABLE where ProcessDefId = @ProcessDefId
							select @expiryactivityid = ActivityId from ACTIVITYTABLE where ActivityName = @ExpiryActivity and ProcessDefId = @processdefid
							
						
						INSERT into WORKSTAGELINKTABLE (ProcessDefId,SourceId,TargetId,color,Type, ConnectionId)	
						values (  @ProcessDefId ,  @ActivityId ,  @expiryactivityid, 0 , 'X', @connid)
							
					END
					--Print (' else co-----'  )
					FETCH NEXT FROM cur_processtab INTO @ProcessDefId , @ActivityId , @ExpiryActivity
			END
		CLOSE cur_processtab
			DEALLOCATE cur_processtab
			
		END TRY
		BEGIN CATCH
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT into WORKSTAGELINKTABLE FAILED.'')')
				SELECT @ErrMessage = 'Block 119 ' + ERROR_MESSAGE()
				RAISERROR(@ErrMessage,16,1)
				Return
		END CATCH
	END
		--********************Add any code before this code and update the patch number**********************
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM PDBPMS_TABLE WHERE Product_Name = 'iBPS' and Product_Version='4.0' and Product_Type='SP' and Patch_Number=1  )
			BEGIN
				EXECUTE('INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(''iBPS'',''4.0'',''SP'',1,getDate())')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP INDEX IDX4_QueueHistoryTable ON dbo.QueueHistoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 120 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	/*Comment below below for iBPS 4.0 sp1*/
	/*BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT 1 FROM PDBPMS_TABLE WHERE Product_Name = 'iBPS' and Product_Version='5.0' and Product_Type='BS'  )
			BEGIN
				EXECUTE('INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(''iBPS'',''5.0'',''BS'',null,getDate())')	
			END
		END TRY
		BEGIN CATCH
			RAISERROR('Block 123 Failed.', 16, 1)
			RETURN
		END CATCH
	END
	*/
	
END	

~

EXEC Upgrade 

~

PRINT 'Executing procedure Upgrade ........... '

~

DROP PROCEDURE Upgrade

~