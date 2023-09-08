/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Ishu Saraf
	Date written (DD/MM/YYYY)	: 16/03/2009 
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
27/03/2009	Ruhi Hira		SrNo-15, New tables added for SAP integration.
15/03/2009	Ananta Handoo		New table WFSAPAdapterAssocTable added for SAP Integration.
17/06/2009	Ishu Saraf		New tables added for OFME - WFPDATable, WFPDA_FormTable, WFPDAControlValueTable
23/06/2009	Ananta Handoo		WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
28/07/2009	Saurabh Sinha		WFS_8.0_018 Unicode[Chinese in this case] characters are not set in WFMailQueueTable. As a result mail sent contains ??? in place of unicode characters.Support for uncode characters provided in mail content.
24/08/2009	Shilpi S		HotFix_8.0_045, two new columns VariableId and VarFieldId are added in PrintFaxEmailDocTypeTable for variable support in doctype name in PFE    
31/08/2009	Ashish Mangla		WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
31/08/2009      Shilpi S                WFS_8.0_026, Workitem specific calendar.
09/09/2009	Vikas Saraswat		WFS_8.0_031	User not having rights on queue, can view the workitem in readonly mode, if he has rights on query workstep. Workitem opens based on properties of query workstep in this case. Option provided to view the workitem(in read only mode) with the properties of the queue in which workitem exists, instead of query workstep properties.
11/09/2009	Saurabh Kamal		New tables created as WFExtInterfaceConditionTable and WFExtInterfaceOperationTable
05/10/2009	Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
15/10/2009	Saurabh Kamal		WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem 
15/03/2013	Bhavneet Kaur		Delete from UserPreferencesTable where ObjectType =  U
04/02/2015	Chitvan Chhabra		Bug 53167 - Version Upgrade : Correcting printfaxemaildoctype and Printfax email and WFcalendar based issues
15/07/2015	Dinkar Kad			Bug 55876 - Showing error while checkin and check out out route in Process Modeler, after upgrading from Omniflow 8 to newer versions like OF 9 and OF 10
01/03/2016	Dinkar Kad			Bug 58528 - After upgrading a cabinet from Omniflow 8 to omniflow 10, already configured Search Variable are not visible in Advance Search.
12/09/2016	Bhupendra Singh 	Bug 62635 - procedure was unable to compile if VARIABLEID column not present in WFSEARCHVARIABLETABLE in OmniFlowVersionUpgarde
26/05/2017	Ashok Kumar			Bug 62518 - Step by Step Debugs in Version Upgrade.
_______________________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'dropdefaultconstraint' AND xType = 'P')
BEGIN
	Drop Procedure dropdefaultconstraint
	PRINT 'As Procedure dropdefaultconstraint exists dropping old procedure ........... '
END

~

PRINT 'Creating procedure dropdefaultconstraint ........... '
~


CREATE PROCEDURE dropdefaultconstraint
@tablename varchar(max),
@colname varchar(max)

AS
DECLARE @v_logStatus  NVARCHAR(10) 
	BEGIN
		SET NOCOUNT ON
		
		DECLARE @constname varchar(200) 
		
		SET @constname = ''
		SELECT  @constname  =a.name 
		FROM sys.sysobjects a INNER JOIN 
		(SELECT name, id FROM sys.sysobjects WHERE xtype = 'U') b on 
		(a.parent_obj = b.id) INNER JOIN sys.syscomments c ON (a.id = c.id) 
		INNER JOIN sys.syscolumns d ON (d.cdefault = a.id) where  b.name = @tablename and  d.name=@colname


		IF ((@constname IS NOT NULL)  AND (LEN(@constname) > 0))
		BEGIN
		PRINT ('Table '+ @tablename + ' altered, constraint '+ @constname+' dropped.')
		EXECUTE ('ALTER TABLE '+@tablename+' DROP CONSTRAINT ' + @constname)
		END
	

	END

~


If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '
~

Create Procedure Upgrade AS
BEGIN
	DECLARE @ProcessDefId		INT
	Declare @existsFlag		INT
	Declare @TableId INT
	Declare @ConstraintName VARCHAR(255)
	DECLARE @procDefId INT 
	DECLARE @CalendarId INT
	DECLARE @activity_Id INT
	DECLARE	@variable_ID INT
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	DECLARE @v_TableExists		INT
	
	SELECT @v_scriptName = 'Upgrade09_SP00_008'
		
	
	Select @v_TableExists = 0
	BEGIN 
		IF NOT EXISTS(SELECT * FROM SYSObjects 
				WHERE NAME = 'QUEUEDATATABLE')
				BEGIN
						Select @v_TableExists = 0
						PRINT 'QUEUEDATATABLE does not exists'
				End
		Else
			BEGIN
				Select @v_TableExists = 1
				
			END
	END
	
exec @v_logStatus= LogInsert 1,@v_scriptName,'Increasing size of columns cabVersion,Remarks in WFCabVersionTable'
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCabVersionTable')
		BEGIN
			Create Table WFCabVersionTable (
				cabVersion		NVARCHAR(255) NOT NULL,
				cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
				creationDate	DATETIME,
				lastModified	DATETIME,
				Remarks			NVARCHAR(255) NOT NULL,
				Status			NVARCHAR(1)
			)
			PRINT 'Table WFCabVersionTable created successfully'
		END
		ELSE
		BEGIN
			IF NOT EXISTS (Select 1 from syscolumns where name='cabVersion' and length = 510 and id =(SELECT id FROM sysObjects WHERE NAME = 'WFCabVersionTable'))
			begin
				EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
				PRINT 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'
			end

			IF NOT EXISTS (Select 1 from syscolumns where name='Remarks' and length = 510 and id =(SELECT id FROM sysObjects WHERE NAME = 'WFCabVersionTable'))
			begin
				EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
				PRINT 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
			end
			
			
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus= LogInsert 2,@v_scriptName,'Creating table WFSAPConnectTable'
	BEGIN
	BEGIN TRY
		/*SrNo-15, New tables added for SAP integration.*/

		IF NOT EXISTS (
				SELECT * FROM SYSObjects 
				WHERE NAME = 'WFSAPConnectTable' 
				AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 2,@v_scriptName
				EXECUTE(' 
					CREATE TABLE WFSAPConnectTable (
						ProcessDefId		INT				NOT NULL	Primary Key,
						SAPHostName			NVarChar(64)	NOT NULL,
						SAPInstance			NVarChar(2)		NOT NULL,
						SAPClient			NVarChar(3)		NOT NULL,
						SAPUserName			NVarChar(256)	    NULL,
						SAPPassword			NVarChar(512)	    NULL,
						SAPHttpProtocol		NVarChar(8)		    NULL,
						SAPITSFlag			NVarChar(1)		    NULL,
						SAPLanguage			NVarChar(8)		    NULL,
						SAPHttpPort			INT			        NULL
					)
				')
				PRINT 'Table WFSAPConnectTable created successfully.'
			END

	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 2,@v_scriptName
		RAISERROR('Block 2 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 2,@v_scriptName

exec @v_logStatus= LogInsert 3,@v_scriptName,'Adding new columns ie.TCodeType,VariableId,VarFieldId in WFSAPGUIDefTable'
	BEGIN
	BEGIN TRY
		/* Modified by Ananta Handoo - 23/06/2009 */
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSAPGUIDefTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 3,@v_scriptName
			EXECUTE(' 
				CREATE TABLE WFSAPGUIDefTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				DefinitionName		NVarChar(256)	NOT NULL,
				SAPTCode			NVarChar(64)	NOT NULL,
				TCodeType			NVarChar(1)	NOT NULL,
				VariableId			INT				NULL,
				VarFieldId			INT				NULL,
				PRIMARY KEY (ProcessDefId, DefinitionId)
				)
			')
			PRINT 'Table WFSAPGUIDefTable created successfully.'
		END
		ELSE IF EXISTS (SELECT * FROM SYSObjects WHERE NAME = 'WFSAPGUIDefTable' AND xType = 'U') 
		BEGIN
			IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIDefTable')
			AND  NAME = 'TCodeType'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 3,@v_scriptName
				EXECUTE('ALTER TABLE WFSAPGUIDefTable ADD TCodeType	NVarChar(1)	NOT NULL')
				PRINT 'Table WFSAPGUIDefTable altered with new Column TCodeType'
				EXECUTE('ALTER TABLE WFSAPGUIDefTable ADD VariableId INT NULL')
				PRINT 'Table WFSAPGUIDefTable altered with new Column VariableId'
				EXECUTE('ALTER TABLE WFSAPGUIDefTable ADD VarFieldId INT NULL')
				PRINT 'Table WFSAPGUIDefTable altered with new Column VarFieldId'
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

exec @v_logStatus= LogInsert 4,@v_scriptName,'Creating table WFSAPGUIFieldMappingTable'
	BEGIN
	BEGIN TRY		
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSAPGUIFieldMappingTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 4,@v_scriptName
			EXECUTE(' 
				CREATE TABLE WFSAPGUIFieldMappingTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				SAPFieldName		NVarChar(512)	NOT NULL,
				MappedFieldName		NVarChar(256)	NOT NULL,
				MappedFieldType		NVarChar(1)	                CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
				VariableId			INT				NULL,
				VarFieldId			INT				NULL
				)
			')
			PRINT 'Table WFSAPGUIFieldMappingTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 4,@v_scriptName
		RAISERROR('Block 4 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 4,@v_scriptName

exec @v_logStatus= LogInsert 5,@v_scriptName,'Creating Table WFSAPGUIAssocTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSAPGUIAssocTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 5,@v_scriptName
			EXECUTE('
				CREATE TABLE WFSAPGUIAssocTable (
				ProcessDefId		INT				NOT NULL,
				ActivityId			INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				Coordinates         NVarChar(255)       NULL, 
				CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
				)
			')
			PRINT 'Table WFSAPGUIAssocTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 5,@v_scriptName
		RAISERROR('Block 5 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 5,@v_scriptName

exec @v_logStatus= LogInsert 6,@v_scriptName,'Creating Table WFSAPAdapterAssocTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSAPAdapterAssocTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 6,@v_scriptName
			EXECUTE('
				CREATE TABLE WFSAPAdapterAssocTable (
				ProcessDefId		INT				 NULL,
				ActivityId			INT				 NULL,
				EXTMETHODINDEX		INT				 NULL
				)
			 ')
			PRINT 'Table WFSAPAdapterAssocTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 6,@v_scriptName
		RAISERROR('Block 6 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 6,@v_scriptName

exec @v_logStatus= LogInsert 7,@v_scriptName,'Adding new Columns i.e InputBuffer,OutputBuffer in WFWebServiceTableand changing size of columns ExceptionComments,ArgList in Exceptiontable,TEMPLATEDEFINITIONTABLE respectively '
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
			AND  NAME = 'InputBuffer'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 7,@v_scriptName
			EXECUTE('ALTER TABLE WFWebServiceTable ADD InputBuffer NTEXT')
			PRINT 'Table WFWebServiceTable altered with new Column InputBuffer'
			EXECUTE('ALTER TABLE WFWebServiceTable ADD OutputBuffer NTEXT')
			PRINT 'Table WFWebServiceTable altered with new Column OutputBuffer'
		END

		EXECUTE('ALTER TABLE ExceptionTable ALTER COLUMN ExceptionComments NVarchar(1024)')

		EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ALTER COLUMN ArgList NVarchar(2000)')
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 7,@v_scriptName
		RAISERROR('Block 7 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 7,@v_scriptName

exec @v_logStatus= LogInsert 8,@v_scriptName,'Creating Table WFPDATable'
	BEGIN
	BEGIN TRY

		/* Added by Ishu Saraf - 17/06/2009 */
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFPDATable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 8,@v_scriptName
			EXECUTE('
				CREATE TABLE WFPDATable(
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL , 
					InterfaceId			INT				NOT NULL,
					InterfaceType		NVARCHAR(1)
				)
			')
			PRINT 'Table WFPDATable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 8,@v_scriptName
		RAISERROR('Block 8 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 8,@v_scriptName

exec @v_logStatus= LogInsert 9,@v_scriptName,'Creating table WFPDA_FormTable'
	BEGIN
	BEGIN TRY
		/* Added by Ishu Saraf - 17/06/2009 */
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFPDA_FormTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 9,@v_scriptName
			EXECUTE('
				CREATE TABLE WFPDA_FormTable(
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL , 
					VariableID			INT				NOT NULL, 
					VarfieldID			INT				NOT NULL,
					ControlType			INT				NOT NULL,
					DisplayName			NVARCHAR(255), 
					MinLen				INT				NOT NULL, 
					MaxLen				INT				NOT NULL,
					Validation			INT				NOT NULL, 
					OrderId				INT				NOT NULL
				)
			')
			PRINT 'Table WFPDA_FormTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 9,@v_scriptName
		RAISERROR('Block 9 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 9,@v_scriptName

exec @v_logStatus= LogInsert 10,@v_scriptName,'Creating Table WFPDAControlValueTable'
	BEGIN
	BEGIN TRY
		/* Added by Ishu Saraf - 17/06/2009 */
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFPDAControlValueTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 10,@v_scriptName
			EXECUTE('
				CREATE TABLE WFPDAControlValueTable(
					ProcessDefId	INT			NOT NULL, 
					ActivityId		INT			NOT NULL, 
					VariableId		INT			NOT NULL,
					VarFieldId		INT			NOT NULL,
					ControlValue	NVARCHAR(255)
				)
			')
			PRINT 'Table WFPDAControlValueTable created successfully.'
		END
    END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 10,@v_scriptName
		RAISERROR('Block 10 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 10,@v_scriptName

exec @v_logStatus= LogInsert 11,@v_scriptName,'Creating Table MAILTRIGGERTABLE'
	BEGIN
	BEGIN TRY
		/* WFS_8.0_018 Start*/

		 IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'mailtriggertable'
			   and data_type = 'text'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 11,@v_scriptName
			EXECUTE(' sp_rename mailtriggertable,mailtriggertable_old ')
			PRINT 'Original mailtriggertable renamed to mailtriggertable_old'
			EXECUTE('	
				CREATE TABLE MAILTRIGGERTABLE ( 
					ProcessDefId 		INT 		NOT NULL,
					TriggerID 		SMALLINT 	NOT NULL,
					Subject 		NVARCHAR(255) 	NULL,
					FromUser		NVARCHAR(255)	NULL,
					FromUserType		NVARCHAR(1)	NULL,
					ExtObjIDFromUser 	INT 		NULL,
					VariableIdFrom		INT		NULL,
					VarFieldIdFrom		INT		NULL,
					ToUser			NVARCHAR(255)	NOT NULL,
					ToType			NVARCHAR(1)	NOT NULL,
					ExtObjIDTo		INT		NULL,
					VariableIdTo		INT		NULL,
					VarFieldIdTo		INT		NULL,
					CCUser			NVARCHAR(255)	NULL,
					CCType			NVARCHAR(1)	NULL,
					ExtObjIDCC		INT		NULL,	
					VariableIdCc		INT		NULL,
					VarFieldIdCc		INT		NULL,
					Message			NTEXT		NULL,
					PRIMARY KEY (Processdefid , TriggerID)
					)
			')
			PRINT 'New Mailtriggertable created with nText'
			EXECUTE('insert into MAILTRIGGERTABLE select ProcessDefId,TriggerID,Subject,FromUser,FromUserType,
											ExtObjIDFromUser,VariableIdFrom,VarFieldIdFrom,
											ToUser,ToType,ExtObjIDTo,VariableIdTo,VarFieldIdTo,CCUser,CCType,
											ExtObjIDCC,VariableIdCc,VarFieldIdCc,Message from mailtriggertable_old ')
			PRINT 'Table mailtriggertable updated successfully'
		END 
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 11,@v_scriptName
		RAISERROR('Block 11 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 11,@v_scriptName

exec @v_logStatus= LogInsert 12,@v_scriptName,'Creating Table WFMAILQUEUETABLE'
	BEGIN
	BEGIN TRY
		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'wfmailqueuetable'
			   and data_type = 'text'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 12,@v_scriptName
			EXECUTE(' sp_rename wfmailqueuetable,wfmailqueuetable_old ')
			PRINT 'Original wfmailqueuetable renamed to wfmailqueuetable_old'
			EXECUTE('
				CREATE TABLE WFMAILQUEUETABLE(
						TaskId 			INTEGER		PRIMARY KEY IDENTITY(1,1),
						mailFrom 		NVARCHAR(255),
						mailTo 			NVARCHAR(512), 
						mailCC 			NVARCHAR(512), 
						mailSubject 		NVARCHAR(255),
						mailMessage		NText,
						mailContentType		NVARCHAR(64),
						attachmentISINDEX 	NVARCHAR(255),
						attachmentNames		NVARCHAR(512), 
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
						noOfTrials		INTEGER		default 0
				) 
			')
			PRINT 'New wfmailqueuetable created with nText'
			EXECUTE('insert into wfmailqueuetable (mailFrom, mailTo, mailCC, mailSubject, mailMessage, 		 mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, 	 statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, 	 processDefId,	processInstanceId, workitemId, activityId, noOfTrials) 
				 select mailFrom, mailTo, mailCC, mailSubject, mailMessage, mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, processDefId,	processInstanceId, workitemId, activityId, noOfTrials from wfmailqueuetable_old ')
			PRINT 'Table wfmailqueuetable updated successfully'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 12,@v_scriptName
		RAISERROR('Block 12 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 12,@v_scriptName

exec @v_logStatus= LogInsert 13,@v_scriptName,'Creating Table USERPREFERENCESTABLE'
	BEGIN
	BEGIN TRY
		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'userpreferencestable'
			   and data_type = 'text'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 13,@v_scriptName
			EXECUTE(' sp_rename userpreferencestable,userpreferencestable_old ')
			PRINT 'Original userpreferencestable renamed to userpreferencestable_old'
			EXECUTE('
				CREATE TABLE USERPREFERENCESTABLE  (
						Userid 			SMALLINT ,
						ObjectId 		INT,
						ObjectName 		NVARCHAR(255),
						ObjectType 		NVARCHAR(30),
						NotifyByEmail 		NVARCHAR(1),
						Data			NTEXT
						CONSTRAINT Pk_User_pref1 PRIMARY KEY (Userid, ObjectId,	ObjectType),
						CONSTRAINT Uk_User_pref1 UNIQUE (Userid, Objectname,ObjectType )
				)
			')
			PRINT 'New userpreferencestable created with nText'
			EXECUTE('insert into USERPREFERENCESTABLE 
				select * from userpreferencestable_old ')
			PRINT 'Table userpreferencestable updated successfully'
		END 
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 13,@v_scriptName
		RAISERROR('Block 13 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 13,@v_scriptName

exec @v_logStatus= LogInsert 14,@v_scriptName,'Creating Table PRINTFAXEMAILTABLE'
	BEGIN
	BEGIN TRY
			exec  @v_logStatus = LogSkip 14,@v_scriptName
		IF EXISTS(select * from sysobjects where name = 'UserPreferencesTable')
		BEGIN
			Execute ('Delete From UserPreferencesTable where ObjectType = ''U''')
		END

		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'printfaxemailtable'
			   and data_type = 'text'
		)
		BEGIN

			EXECUTE(' sp_rename printfaxemailtable,printfaxemailtable_old ')
			PRINT 'Original printfaxemailtable renamed to printfaxemailtable_old'
			EXECUTE('	
				CREATE TABLE PRINTFAXEMAILTABLE (
					ProcessDefId            INT			NOT NULL,
					PFEInterfaceId          INT			NOT NULL,
					InstrumentData          NVARCHAR(1)		NULL,
					FitToPage               NVARCHAR(1)		NULL,
					Annotations             NVARCHAR(1)		NULL,
					FaxNo                   NVARCHAR(255)		NULL,
					FaxNoType               NVARCHAR(1)		NULL,
					ExtFaxNoId              INT			NULL,
					VariableIdFax		INT			NULL,
					VarFieldIdFax		INT			NULL,
					CoverSheet              NVARCHAR(50)		NULL,
					CoverSheetBuffer        IMAGE			NULL,
					ToUser                  NVARCHAR(255)		NULL,
					FromUser                NVARCHAR(255)		NULL,
					ToMailId                NVARCHAR(255)		NULL,
					ToMailIdType            NVARCHAR(1)		NULL,
					ExtToMailId             INT			NULL,
					VariableIdTo		INT			NULL,
					VarFieldIdTo		INT			NULL,
					CCMailId                NVARCHAR(255)		NULL,
					CCMailIdType            NVARCHAR(1)		NULL,
					ExtCCMailId             INT			NULL,
					VariableIdCc		INT			NULL,
					VarFieldIdCc		INT			NULL,
					SenderMailId            NVARCHAR(255)		NULL,
					SenderMailIdType        NVARCHAR(1)		NULL,
					ExtSenderMailId         INT			NULL,
					VariableIdFrom		INT			NULL,
					VarFieldIdFrom		INT			NULL,
					Message                 NTEXT			NULL,
					Subject                 NVARCHAR(255)		NULL
				) 
			')
			PRINT 'New printfaxemailtable created with nText'
			EXECUTE(' insert into PRINTFAXEMAILTABLE select * from printfaxemailtable_old ')
			PRINT 'Table printfaxemailtable updated successfully'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 14,@v_scriptName
		RAISERROR('Block 14 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 14,@v_scriptName

exec @v_logStatus= LogInsert 15,@v_scriptName,'Adding new Column VariableId,VarFieldId in PRINTFAXEMAILDOCTYPETABLE'
	BEGIN
	BEGIN TRY
		/*HotFix_8.0_045- Variable support in doctypename in PFE*/
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailDocTypeTable')
			AND  NAME = 'VariableId'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 15,@v_scriptName
			
			EXECUTE('ALTER TABLE PrintFaxEmailDocTypeTable ADD VariableId INT DEFAULT 0, VarFieldId INT DEFAULT 0')
			
			EXECUTE ('UPDATE  PrintFaxEmailDocTypeTable SET VariableId=0 WHERE  VariableId IS NULL')
			
			EXECUTE ('UPDATE  PrintFaxEmailDocTypeTable SET VarFieldId=0 WHERE  VarFieldId IS NULL')
		

			PRINT 'Table PrintFaxEmailDocTypeTable altered with new Columns VariableId and VarFieldId'
		END
		
		
		EXEC dropdefaultconstraint 'PRINTFAXEMAILDOCTYPETABLE','VARIABLEID'
		ALTER TABLE PrintFaxEmailDocTypeTable ADD CONSTRAINT DF_PFEVARIABLEFIELDID  DEFAULT 0  FOR VARIABLEID
		
		PRINT 'Table PrintFaxEmailDocTypeTable altered  Column VariableId '
		
		
		--EXEC dropdefaultconstraint 'PRINTFAXEMAILDOCTYPETABLE','VARFIELDID'
		--ALTER TABLE PrintFaxEmailDocTypeTable ADD CONSTRAINT DF_VARFIELDID DEFAULT 0   FOR VARFIELDID
		
		PRINT 'Table PrintFaxEmailDocTypeTable altered  Column  VarFieldId'

		/*WFS_8.0_026 - workitem specific calendar*/
		If @v_TableExists = 1
		Begin
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDataTable')
			AND  NAME = 'CalendarName'
			)
		BEGIN
		PRINT 'xxxxxxxxxxx '
			EXECUTE('ALTER TABLE QueueDataTable ADD CalendarName NVARCHAR(255)')
			PRINT 'Table QueueDataTable altered with new Column CalendarName'
		END
		End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 15,@v_scriptName
		RAISERROR('Block 15 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 15,@v_scriptName

exec @v_logStatus= LogInsert 16,@v_scriptName,'Inserting values in VarMappingTable '
	BEGIN
	BEGIN TRY
	   /*WFS_8.0_018 End*/
		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_CalendarName_VarMapping')
		BEGIN
			exec  @v_logStatus = LogSkip 16,@v_scriptName
			DECLARE cursor1 CURSOR STATIC FOR
			SELECT ProcessDefId FROM ProcessDefTable
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN 
				BEGIN TRANSACTION trans
					EXECUTE(' INSERT INTO VarMappingTable VALUES(' + @ProcessDefId + ', 10001 , N''CalendarName'', N''CalendarName'', 10 , N''M'', 0, NULL , NULL, 0, N''N'')' )
				COMMIT TRANSACTION trans

				FETCH NEXT FROM cursor1 INTO @ProcessDefId
			END
			CLOSE cursor1
			DEALLOCATE cursor1
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_CalendarName_VarMapping'', GETDATE(), GETDATE(), N''OmniFlow 7.2'', N''Y'')')
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 16,@v_scriptName
		RAISERROR('Block 16 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 16,@v_scriptName

exec @v_logStatus= LogInsert 17,@v_scriptName,'Creating View QUEUETABLE'
	BEGIN
	BEGIN TRY
	   /*WFS_8.0_026 - workitem specific calendar*/
	   If @v_TableExists = 1
	   Begin
	   	exec  @v_logStatus = LogSkip 17,@v_scriptName
		EXECUTE('DROP VIEW QueueTable')
		
		EXECUTE('CREATE VIEW QUEUETABLE 
		AS
		SELECT  queueTABLE1.processdefid, processname, processversion, 
			queueTABLE1.processinstanceid, queueTABLE1.processinstanceid AS processinstancename, 
			queueTABLE1.activityid, queueTABLE1.activityname, 
			QUEUEDATATABLE.parentworkitemid, queueTABLE1.workitemid, 
			processinstancestate, workitemstate, statename, queuename, queuetype,
			AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
			IntroductionDateTime, PROCESSINSTANCETABLE.CreatedDatetime AS CreatedDatetime,
			Introducedby, createdbyname, entryDATETIME,
			lockstatus, holdstatus, prioritylevel, lockedbyname, 
			lockedtime, validtill, savestage, previousstage,
			expectedworkitemdelay AS expectedworkitemdelaytime,
				expectedprocessdelay AS expectedprocessdelaytime, status, 
			var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
			var_float1, var_float2, 
			var_date1, var_date2, var_date3, var_date4, 
			var_long1, var_long2, var_long3, var_long4, 
			var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
			var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
			q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
			referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName
		FROM QUEUEDATATABLE  with (NOLOCK), 
			 PROCESSINSTANCETABLE  with (NOLOCK),
			  (SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entryDATETIME, parentworkitemid, AssignmentType,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, AssignedUser, CreatedDatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
				 FROM WORKLISTTABLE  with (NOLOCK)
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entryDATETIME, parentworkitemid, AssignmentType,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, AssignedUser, CreatedDatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
				 FROM WORKINPROCESSTABLE  with (NOLOCK)
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entryDATETIME, parentworkitemid, AssignmentType,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, AssignedUser, CreatedDatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
				 FROM WORKDONETABLE  with (NOLOCK)
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entryDATETIME, parentworkitemid, AssignmentType,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, AssignedUser, CreatedDatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
				 FROM WORKWITHPSTABLE  with (NOLOCK)
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entryDATETIME, parentworkitemid, AssignmentType,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, AssignedUser, CreatedDatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
				 FROM PENDINGWORKLISTTABLE with (NOLOCK)) queueTABLE1
		WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
		  AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
		  AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid')
		End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 17,@v_scriptName
		RAISERROR('Block 17 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 17,@v_scriptName

exec @v_logStatus= LogInsert 18,@v_scriptName,'RECREATING VIEW QUSERGROUPVIEW'
	BEGIN
	BEGIN TRY
		/*WFS_8.0_031*/
		BEGIN
			
			Select @existsFlag = 0 	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
				AND  NAME = 'QUERYPREVIEW'
				)  
			BEGIN
				exec  @v_logStatus = LogSkip 18,@v_scriptName
				ALTER TABLE QUEUEUSERTABLE ADD QUERYPREVIEW NVARCHAR(1) DEFAULT ('Y')
			END
			If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'V' and name = 'QUSERGROUPVIEW')
			Begin
				exec  @v_logStatus = LogSkip 18,@v_scriptName
				Execute('DROP view QUSERGROUPVIEW')
				Print 'View QUSERGROUPVIEW already exists, hence older one dropped ..... '
				exec('CREATE VIEW QUSERGROUPVIEW(
				QUEUEID, USERID, GROUPID, ASSIGNEDTILLDATETIME, QUERYFILTER, QUERYPREVIEW
				)
				AS 
				SELECT "QUEUEID","USERID","GROUPID","ASSIGNEDTILLDATETIME","QUERYFILTER" ,"QUERYPREVIEW" FROM 
				(SELECT queueid,userid,cast ( NULL AS INTEGER ) AS GroupId,assignedtilldatetime , queryFilter ,QueryPreview
				FROM QUEUEUSERTABLE  
				WHERE associationtype=0 
				AND ( assignedtilldatetime IS NULL OR assignedtilldatetime>=getDate() ) 
				UNION 
				SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter ,QueryPreview
				FROM QUEUEUSERTABLE,wfgroupmemberview 
				WHERE associationtype=1  AND QUEUEUSERTABLE.userid=wfgroupmemberview.groupindex)as a')
			End
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 18,@v_scriptName
		RAISERROR('Block 18 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 18,@v_scriptName

exec @v_logStatus= LogInsert 19,@v_scriptName,'Creating table WFExtInterfaceConditionTable'
	BEGIN
	BEGIN TRY
		
		/*WFS_8.0_038*/
		BEGIN
			Select @existsFlag = 0 	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
				AND  NAME = 'REFRESHINTERVAL'
				)  
			BEGIN
				exec  @v_logStatus = LogSkip 19,@v_scriptName
				ALTER TABLE QUEUEDEFTABLE ADD REFRESHINTERVAL INT NULL
			END
		END
		
		/*Added by Saurabh Kamal for Rules on External Interfaces*/
		IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFExtInterfaceConditionTable' 
			AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 19,@v_scriptName
			EXECUTE(' 
				CREATE TABLE WFExtInterfaceConditionTable (
					ProcessDefId 	    	INT		NOT NULL,
					ActivityId          	INT		NOT NULL ,
					InterFaceType           NVARCHAR(1)   	NOT NULL ,
					RuleOrderId         	INT      	NOT NULL ,
					RuleId              	INT      	NOT NULL ,
					ConditionOrderId    	INT 		NOT NULL ,
					Param1			NVARCHAR(50) 	NOT NULL ,
					Type1               	NVARCHAR(1) 	NOT NULL ,
					ExtObjID1	    	INT		NULL,
					VariableId_1		INT		NULL,
					VarFieldId_1		INT		NULL,
					Param2			NVARCHAR(255) 	NOT NULL ,
					Type2               	NVARCHAR(1) 	NOT NULL ,
					ExtObjID2	    	INT		NULL,
					VariableId_2		INT             NULL,
					VarFieldId_2		INT             NULL,
					Operator            	INT 		NOT NULL ,
					LogicalOp           	INT 		NOT NULL 
				)
			')
			PRINT 'Table WFExtInterfaceConditionTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 19,@v_scriptName
		RAISERROR('Block 19 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 19,@v_scriptName

exec @v_logStatus= LogInsert 20,@v_scriptName,'Creating Table WFExtInterfaceOperationTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFExtInterfaceOperationTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 20,@v_scriptName
			EXECUTE('
				CREATE TABLE WFExtInterfaceOperationTable(
					ProcessDefId 	    	INT		NOT NULL,
					ActivityId          	INT		NOT NULL ,
					InterFaceType           NVARCHAR(1)   	NOT NULL ,	
					RuleId              	INT      	NOT NULL , 	
					InterfaceElementId	INT		NOT NULL
				)
			')
			PRINT 'Table WFExtInterfaceOperationTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 20,@v_scriptName
		RAISERROR('Block 20 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 20,@v_scriptName

exec @v_logStatus= LogInsert 21,@v_scriptName,'Inserting Value in VarMappingTable for Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem'
	BEGIN
	BEGIN TRY
			/*WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping')
		BEGIN
			exec  @v_logStatus = LogSkip 21,@v_scriptName
			DECLARE cursor1 CURSOR STATIC FOR
			SELECT ProcessDefId FROM ProcessDefTable
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN 
				BEGIN TRANSACTION trans
					EXECUTE(' INSERT INTO VarMappingTable VALUES(' + @ProcessDefId + ', 10002 , N''ExpectedWorkitemDelay'', N''TurnAroundDateTime'', 8 , N''S'', 0, NULL , NULL, 0, N''N'')' )
				COMMIT TRANSACTION trans

				FETCH NEXT FROM cursor1 INTO @ProcessDefId
			END
			CLOSE cursor1
			DEALLOCATE cursor1
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_TurnAroundDateTime_VarMapping'', GETDATE(), GETDATE(), N''OmniFlow 7.2'', N''Y'')')
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 21,@v_scriptName
		RAISERROR('Block 21 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 21,@v_scriptName

exec @v_logStatus= LogInsert 22,@v_scriptName,'Creating TABLE WFImportFileData'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
				SELECT * FROM SYSObjects 
				WHERE NAME = 'WFImportFileData' 
				AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 22,@v_scriptName
				EXECUTE(' 
					CREATE TABLE WFImportFileData (
						FileIndex	    INT IDENTITY (1, 1),
						FileName 	    Nvarchar(256),
						FileType 	    Nvarchar(10),
						FileStatus	    Nvarchar(1),
						Message	        Nvarchar(1000),
						StartTime	    DATETIME,
						EndTime	        DATETIME,
						ProcessedBy     Nvarchar(256),
						TotalRecords    INT
					)
				')
				PRINT 'Table WFImportFileData created successfully.'
			END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 22,@v_scriptName
		RAISERROR('Block 22 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 22,@v_scriptName

exec @v_logStatus= LogInsert 23,@v_scriptName,'Creating TABLE WFPURGECRITERIATABLE'
	BEGIN
	BEGIN TRY

		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFPURGECRITERIATABLE'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 23,@v_scriptName
			EXECUTE(' 
				CREATE TABLE WFPURGECRITERIATABLE(
					PROCESSDEFID	INT		NOT NULL PRIMARY KEY,
					OBJECTNAME	NVARCHAR(255)	NOT NULL, 
					EXPORTFLAG	NVARCHAR(1)	NOT NULL, 
					DATA		TEXT, 
					CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
				)
			')
			PRINT 'Table WFPURGECRITERIATABLE created successfully.'
		END
				END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 23,@v_scriptName
		RAISERROR('Block 23 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 23,@v_scriptName

exec @v_logStatus= LogInsert 24,@v_scriptName,'Creating TABLE WFEXPORTINFOTABLE'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFEXPORTINFOTABLE'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 24,@v_scriptName
			EXECUTE(' 
				CREATE TABLE WFEXPORTINFOTABLE(	
					SOURCEUSERNAME		NVARCHAR(255)	NOT NULL,
					SOURCEPASSWORD		NVARCHAR(255),
					KEEPSOURCEIS            NVARCHAR(1),
					TARGETCABINETNAME	NVARCHAR(255)	NOT NULL,
					APPSERVERIP		NVARCHAR(20),
					APPSERVERPORT		INT,
					TARGETUSERNAME		NVARCHAR(200)	NOT NULL,
					TARGETPASSWORD		NVARCHAR(200),
					SITEID			INT ,
					VOLUMEID		INT ,
					WEBSERVERINFO		NVARCHAR(255)
				)
			')
			PRINT 'Table WFEXPORTINFOTABLE created successfully.'
		END
		END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 24,@v_scriptName
		RAISERROR('Block 24 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 24,@v_scriptName

exec @v_logStatus= LogInsert 25,@v_scriptName,'Creating TABLE WFSOURCECABINETINFOTABLE'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSOURCECABINETINFOTABLE'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 25,@v_scriptName
			EXECUTE('
				CREATE TABLE WFSOURCECABINETINFOTABLE(	
					ISSOURCEIS		NVARCHAR(1),
					SITEID			INT,
					SOURCECABINET	        NVARCHAR(255),
					APPSERVERIP		NVARCHAR(30),
					APPSERVERPORT		INT
				)
			')
			PRINT 'Table WFSOURCECABINETINFOTABLE created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 25,@v_scriptName
		RAISERROR('Block 25 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 25,@v_scriptName

exec @v_logStatus= LogInsert 26,@v_scriptName,'Creating TABLE WFFormFragmentTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFFormFragmentTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 26,@v_scriptName
			EXECUTE('
				CREATE TABLE WFFormFragmentTable(	
					ProcessDefId	int 		   NOT NULL,
					FragmentId	    int 		   NOT NULL,
					FragmentName	VARCHAR(50)    NOT NULL,
					FragmentBuffer	IMAGE          NULL,
					IsEncrypted	    VARCHAR(1)     NOT NULL,
					StructureName	VARCHAR(128)   NOT NULL,
					StructureId	    int            NOT NULL
				)
			 ')
			PRINT 'Table WFFormFragmentTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 26,@v_scriptName
		RAISERROR('Block 26 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 26,@v_scriptName

exec @v_logStatus= LogInsert 27,@v_scriptName,'Creating TABLE WFTransportDataTable'
	BEGIN
	BEGIN TRY		
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTransportDataTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 27,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTransportDataTable  (
					TMSLogId			INT				IDENTITY (1,1) PRIMARY KEY,
					RequestId     NVARCHAR(64),
					ActionId			INT				NOT NULL,
					ActionDateTime		DATETIME		NOT NULL,
					ActionComments		NVARCHAR(255),
					UserId              INT             NOT NULL,
					UserName            NVARCHAR(64)    NOT NULL,
					Released			NVARCHAR(1)    Default ''N'',
					ReleasedByUserId          INT,
					ReleasedBy       	NVARCHAR(64),
					ReleasedComments	NVARCHAR(255),
					ReleasedDateTime    DATETIME,
					Transported			NVARCHAR(1)     Default ''N'',
					TransportedByUserId INT,
					TransportedBy		NVARCHAR(64),
					TransportedDateTime DATETIME,
					ObjectName          NVARCHAR(64),
					ObjectType          NVARCHAR(1),
					ProcessDefId        INT,
					CONSTRAINT uk_TransportDataTable	UNIQUE (RequestId)    
				)
			 ')
			PRINT 'Table WFTransportDataTable created successfully.'
		END
		END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 27,@v_scriptName
		RAISERROR('Block 27 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 27,@v_scriptName

exec @v_logStatus= LogInsert 28,@v_scriptName,'creating TABLE WFTMSAddQueue'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSAddQueue'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 28,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSAddQueue (
					RequestId           NVARCHAR(64)     NOT NULL,    
					QueueName           NVARCHAR(64),
					RightFlag           NVARCHAR(64),
					QueueType           NVARCHAR(1),    
					Comments            NVARCHAR(255),
					ZipBuffer           NVARCHAR(1),
					AllowReassignment   NVARCHAR(1),
					FilterOption        INT,
					FilterValue         NVARCHAR(64),
					QueueFilter         NVARCHAR(64),
					OrderBy             INT,
					SortOrder           NVARCHAR(1),
					IsStreamOper        NVARCHAR(1)     
				)
			 ')
			PRINT 'Table WFTMSAddQueue created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 28,@v_scriptName
		RAISERROR('Block 28 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 28,@v_scriptName

exec @v_logStatus= LogInsert 29,@v_scriptName,'Creating TABLE WFTMSChangeProcessDefState'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSChangeProcessDefState'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 29,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSChangeProcessDefState(
					RequestId           NVARCHAR(64)     NOT NULL,    
					RightFlag           NVARCHAR(64),
					ProcessDefId        INT,    
					ProcessDefState  NVARCHAR(64),
					ProcessName         NVARCHAR(64)
				)
			 ')
			PRINT 'Table WFTMSChangeProcessDefState created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 29,@v_scriptName
		RAISERROR('Block 29 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 29,@v_scriptName

exec @v_logStatus= LogInsert 30,@v_scriptName,'Creating TABLE WFTMSChangeQueuePropertyEx'
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSChangeQueuePropertyEx'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 30,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSChangeQueuePropertyEx(
					RequestId           NVARCHAR(64)     NOT NULL,    
					QueueName           NVARCHAR(64),
					QueueId             INT,
					RightFlag           NVARCHAR(64),
					ZipBuffer           NVARCHAR(1),
					Description         NVARCHAR(255),
					QueueType           NVARCHAR(1),
					FilterOption        INT,
					QueueFilter         NVARCHAR(64),
					FilterValue         NVARCHAR(64),    
					OrderBy             INT,
					SortOrder           NVARCHAR(1),
					AllowReassignment   NVARCHAR(1),            
					IsStreamOper        NVARCHAR(1),
					OriginalQueueName   NVARCHAR(64)    
				)
			 ')
			PRINT 'Table WFTMSChangeQueuePropertyEx created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 30,@v_scriptName
		RAISERROR('Block 30 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 30,@v_scriptName

exec @v_logStatus= LogInsert 31,@v_scriptName,'Creating TABLE WFTMSDeleteQueue'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSDeleteQueue'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 31,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSDeleteQueue(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ZipBuffer           NVARCHAR(1),
					RightFlag           NVARCHAR(64),
					QueueId             INT     NOT NULL,
					QueueName           NVARCHAR(64)
				)
			 ')
			PRINT 'Table WFTMSDeleteQueue created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 31,@v_scriptName
		RAISERROR('Block 31 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 31,@v_scriptName

exec @v_logStatus= LogInsert 32,@v_scriptName,'Creating TABLE WFTMSStreamOperation'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSStreamOperation'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 32,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSStreamOperation(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ID                  INT,
					StreamName          NVARCHAR(64),
					ProcessDefId        INT,
					ProcessName         NVARCHAR(64),
					ActivityId          INT,
					ActivityName        NVARCHAR(64),
					Operation           NVARCHAR(1)
				)
			 ')
			PRINT 'Table WFTMSStreamOperation created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 32,@v_scriptName
		RAISERROR('Block 32 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 32,@v_scriptName

exec @v_logStatus= LogInsert 33,@v_scriptName,'Creating TABLE WFTMSSetVariableMapping'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetVariableMapping'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 33,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSSetVariableMapping(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ProcessDefId        INT,        
					ProcessName         NVARCHAR(64),
					RightFlag           NVARCHAR(64),
					ToReturn            NVARCHAR(1),
					Alias               NVARCHAR(64),
					QueueId             INT,
					QueueName           NVARCHAR(64),
					Param1              NVARCHAR(64),
					Param1Type           INT,    
					Type1               NVARCHAR(1),
					AliasRule			VARCHAR(4000)
				)
			 ')
			PRINT 'Table WFTMSSetVariableMapping created successfully.'
		END
		END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 33,@v_scriptName
		RAISERROR('Block 33 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 33,@v_scriptName

exec @v_logStatus= LogInsert 34,@v_scriptName,'Creating TABLE WFTMSSetTurnAroundTime'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetTurnAroundTime'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 34,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSSetTurnAroundTime(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ProcessDefId        INT,    
					ProcessName         NVARCHAR(64),
					RightFlag           NVARCHAR(64),
					ProcessTATMinutes   INT,           
					ProcessTATHours     INT,    
					ProcessTATDays      INT,    
					ProcessTATCalFlag   NVARCHAR(1),    
					ActivityId          INT,
					AcitivityTATMinutes INT,
					ActivityTATHours    INT,
					ActivityTATDays     INT,
					ActivityTATCalFlag  NVARCHAR(1)
				)
			 ')
			PRINT 'Table WFTMSSetTurnAroundTime created successfully.'
		END
		END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 34,@v_scriptName
		RAISERROR('Block 34 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 34,@v_scriptName

exec @v_logStatus= LogInsert 35,@v_scriptName,'Creating TABLE WFTMSSetActionList'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetActionList'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 35,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSSetActionList(
					RequestId           NVARCHAR(64)     NOT NULL,    
					RightFlag           NVARCHAR(64),
					EnabledList         NVARCHAR(255),
					DisabledList        NVARCHAR(255),
					ProcessDefId        INT,    
					ProcessName           NVARCHAR(64),
					EnabledVarList       NVARCHAR(255)    
				)
			 ')
			PRINT 'Table WFTMSSetActionList created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 35,@v_scriptName
		RAISERROR('Block 35 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 35,@v_scriptName

exec @v_logStatus= LogInsert 36,@v_scriptName,'Creating TABLE WFTMSSetDynamicConstants'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetDynamicConstants'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 36,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSSetDynamicConstants(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ProcessDefId        INT,  
					ProcessName         NVARCHAR(64),
					RightFlag           NVARCHAR(64),
					ConstantName        NVARCHAR(64),
					ConstantValue       NVARCHAR(64)
				)
			 ')
			PRINT 'Table WFTMSSetDynamicConstants created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 36,@v_scriptName
		RAISERROR('Block 36 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 36,@v_scriptName

exec @v_logStatus= LogInsert 37,@v_scriptName,'Creating TABLE WFTMSSetQuickSearchVariables'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetQuickSearchVariables'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 37,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTMSSetQuickSearchVariables(
					RequestId           NVARCHAR(64)     NOT NULL,    
					RightFlag           NVARCHAR(64),
					Name                NVARCHAR(64),
					Alias               NVARCHAR(64),
					SearchAllVersion    NVARCHAR(1),    
					ProcessDefId        INT,    
					ProcessName         NVARCHAR(64),
					Operation           NVARCHAR(1)
				)
			 ')
			PRINT 'Table WFTMSSetQuickSearchVariables created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 37,@v_scriptName
		RAISERROR('Block 37 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 37,@v_scriptName

exec @v_logStatus= LogInsert 38,@v_scriptName,'Creating TABLE WFTransportRegisterationInfo'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTransportRegisterationInfo'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 38,@v_scriptName
			EXECUTE('
				CREATE TABLE WFTransportRegisterationInfo(
					ID                          INT     PRIMARY KEY,    
					TargetEngineName           NVARCHAR(64),
					TargetAppServerIp           NVARCHAR(64),
					TargetAppServerPort         INT,       
					TargetAppServerType         NVARCHAR(64),    
					UserName                    NVARCHAR(64),    
					Password                    NVARCHAR(64)    
				)
			 ')
			PRINT 'Table WFTransportRegisterationInfo created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 38,@v_scriptName
		RAISERROR('Block 38 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 38,@v_scriptName

exec @v_logStatus= LogInsert 39,@v_scriptName,'Creating TABLE WFTMSSetCalendarData'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSSetCalendarData'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 39,@v_scriptName
			EXECUTE('
				Create TABLE WFTMSSetCalendarData(
					RequestId           NVARCHAR(64)     NOT NULL, 
					CalendarId          INT,    
					ProcessDefId        INT,
					ProcessName         NVARCHAR(64),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				)
			 ')
			PRINT 'Table WFTMSSetCalendarData created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 39,@v_scriptName
		RAISERROR('Block 39 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 39,@v_scriptName

exec @v_logStatus= LogInsert 40,@v_scriptName,'Creating TABLE WFTMSAddCalendar'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFTMSAddCalendar'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 40,@v_scriptName
			EXECUTE('
				Create TABLE WFTMSAddCalendar(
					RequestId           NVARCHAR(64)     NOT NULL,     
					ProcessDefId        INT,
					ProcessName         NVARCHAR(64),
					CalendarName        NVARCHAR(64),
					CalendarType        NVARCHAR(1),
					Comments             NVARCHAR(512),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				)

			 ')
			PRINT 'Table WFTMSAddCalendar created successfully.'
		END
		END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 40,@v_scriptName
		RAISERROR('Block 40 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 40,@v_scriptName

exec @v_logStatus= LogInsert 41,@v_scriptName,'Creating TABLE WFBPELDefTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFBPELDefTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 41,@v_scriptName
			EXECUTE('
				Create TABLE WFBPELDefTable(    
					ProcessDefId        INT     NOT NULL PRIMARY KEY,
					BPELDef             IMAGE   NOT NULL,
					XSDDef              IMAGE   NOT NULL    
				)
			 ')
			PRINT 'Table WFBPELDefTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 41,@v_scriptName
		RAISERROR('Block 41 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 41,@v_scriptName

exec @v_logStatus= LogInsert 42,@v_scriptName,'Creating TABLE WFWebServiceInfoTable'
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFWebServiceInfoTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 42,@v_scriptName
			EXECUTE('
				CREATE TABLE WFWebServiceInfoTable (
					ProcessDefId		INT				NOT NULL, 
					WSDLURLId			INT				NOT NULL,
					WSDLURL				NVARCHAR(2000)		NULL,
					USERId				NVARCHAR(255)		NULL,
					PWD					NVARCHAR(255)		NULL,
					PRIMARY KEY (ProcessDefId, WSDLURLId)
				)
			 ')
			PRINT 'Table WFWebServiceInfoTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 42,@v_scriptName
		RAISERROR('Block 42 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 42,@v_scriptName

exec @v_logStatus= LogInsert 43,@v_scriptName,'Creating TABLE WFSystemServicesTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSystemServicesTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 43,@v_scriptName
			EXECUTE('
				CREATE TABLE WFSystemServicesTable (
					ServiceId  			INT 				IDENTITY (1,1) 		PRIMARY KEY,
					PSID 				INT					NULL, 
					ServiceName  		NVARCHAR(50)		NULL, 
					ServiceType  		NVARCHAR(50)		NULL, 
					ProcessDefId 		INT					NULL, 
					EnableLog  			NVARCHAR(50)		NULL, 
					MonitorStatus 		NVARCHAR(50)		NULL, 
					SleepTime  			INT					NULL, 
					DateFormat  		NVARCHAR(50)		NULL, 
					UserName  			NVARCHAR(50)		NULL, 
					Password  			NVARCHAR(200)		NULL, 
					RegInfo   			NVARCHAR(2000)		NULL
				)
			 ')
			PRINT 'Table WFSystemServicesTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 43,@v_scriptName
		RAISERROR('Block 43 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 43,@v_scriptName

exec @v_logStatus= LogInsert 44,@v_scriptName,'Adding new Columns i.e. CommentFont,CommentForeColor,CommentBackColor,CommentBorderStyle in ProcessDefCommentTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefCommentTable')
			AND  NAME = 'CommentFont'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 44,@v_scriptName
			EXECUTE('ALTER TABLE ProcessDefCommentTable ADD CommentFont NVARCHAR(255) NULL')
			PRINT 'Table ProcessDefCommentTable altered with new Column CommentFont'
			EXECUTE('ALTER TABLE ProcessDefCommentTable ADD CommentForeColor INT NULL')
			PRINT 'Table ProcessDefCommentTable altered with new Column CommentForeColor'
			EXECUTE('ALTER TABLE ProcessDefCommentTable ADD CommentBackColor INT NULL')
			PRINT 'Table ProcessDefCommentTable altered with new Column CommentBackColor'
			EXECUTE('ALTER TABLE ProcessDefCommentTable ADD CommentBorderStyle INT NULL')
			PRINT 'Table ProcessDefCommentTable altered with new Column CommentBorderStyle'		
		END
		
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
			AND  NAME = 'RefreshInterval'
			)
		BEGIN		
			ALTER TABLE QUEUEDEFTABLE ADD RefreshInterval INT NULL
			PRINT 'Table QUEUEDEFTABLE altered with new Column RefreshInterval'
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 44,@v_scriptName
		RAISERROR('Block 44 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 44,@v_scriptName

exec @v_logStatus= LogInsert 45,@v_scriptName,'Adding new column SortOrder in QUEUEDEFTABLE'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
			AND  NAME = 'SortOrder'
			)
		BEGIN		
			exec  @v_logStatus = LogSkip 45,@v_scriptName
			ALTER TABLE QUEUEDEFTABLE ADD SortOrder NVARCHAR(1) NULL
			PRINT 'Table QUEUEDEFTABLE altered with new Column SortOrder'
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 45,@v_scriptName
		RAISERROR('Block 45 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 45,@v_scriptName

exec @v_logStatus= LogInsert 46,@v_scriptName,'Adding new Column QueryPreview in QUEUEUSERTABLE '
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
			AND  NAME = 'QueryPreview'
			)
		BEGIN	
			exec  @v_logStatus = LogSkip 46,@v_scriptName	
			ALTER TABLE QUEUEUSERTABLE ADD QueryPreview NVARCHAR(1)	NULL DEFAULT ('Y')
			PRINT 'Table QUEUEUSERTABLE altered with new Column QueryPreview'
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 46,@v_scriptName
		RAISERROR('Block 46 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 46,@v_scriptName

exec @v_logStatus= LogInsert 47,@v_scriptName,'Adding new Column QueryPreview in QUEUEUSERTABLE'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
			AND  NAME = 'QueryPreview'
			)
		BEGIN	
			exec  @v_logStatus = LogSkip 47,@v_scriptName	
			ALTER TABLE QUEUEUSERTABLE ADD QueryPreview NVARCHAR(1)	NULL DEFAULT ('Y')
			PRINT 'Table QUEUEUSERTABLE altered with new Column QueryPreview'
		END	
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 47,@v_scriptName
		RAISERROR('Block 47 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 47,@v_scriptName

exec @v_logStatus= LogInsert 48,@v_scriptName,'Adding new Column AliasRule in VarAliasTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'VARALIASTABLE')
			AND  NAME = 'AliasRule'
			)
		BEGIN		
			exec  @v_logStatus = LogSkip 48,@v_scriptName
			ALTER TABLE VARALIASTABLE ADD AliasRule NVARCHAR(2000)  NULL
			PRINT 'Table VARALIASTABLE altered with new Column AliasRule'
		END
END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 48,@v_scriptName
		RAISERROR('Block 48 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 48,@v_scriptName

exec @v_logStatus= LogInsert 49,@v_scriptName,'Adding new Column ProcessDefId in VarAliasTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
		  WHERE 
		  id = (SELECT id FROM sysObjects WHERE NAME = 'VarAliasTable')
		  AND  NAME = 'ProcessDefId'
		  )
		 BEGIN
			exec  @v_logStatus = LogSkip 49,@v_scriptName
		  EXECUTE('ALTER TABLE VarAliasTable ADD ProcessDefId INT NOT NULL DEFAULT 0')
		  PRINT 'Table VarAliasTable altered with new Column ProcessDefId'  
		 END
		 BEGIN
			 SELECT @TableId = id FROM sysobjects WHERE name = 'varaliastable'
			 SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 
			 execute('alter table varaliastable drop CONSTRAINT ' + @ConstraintName)
			 alter table varaliastable add CONSTRAINT PK__VarAliasTable PRIMARY KEY CLUSTERED (queueid, alias, processdefid)
		 END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 49,@v_scriptName
		RAISERROR('Block 49 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 49,@v_scriptName

exec @v_logStatus= LogInsert 50,@v_scriptName,'Adding new Columns i.e. SwimLaneType,SwimLaneText,SwimLaneTextColor in WFSwimLaneTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFSwimLaneTable')
			AND  NAME = 'SwimLaneType'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 50,@v_scriptName
			EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneType NVARCHAR(1) DEFAULT (''H'') NOT NULL')
			PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneType'
			EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneText NVARCHAR(255) DEFAULT (''HORIZONTAL LANE'') NOT NULL')
			PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneText'
			EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneTextColor INT DEFAULT (-16777216) NOT NULL')
			PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneTextColor'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 50,@v_scriptName
		RAISERROR('Block 50 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 50,@v_scriptName

exec @v_logStatus= LogInsert 51,@v_scriptName,'Adding new Column SortOrder in WFAuthorizeQueueDefTable and changing the size of ArgList column'
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFAuthorizeQueueDefTable')
			AND  NAME = 'SortOrder'
			)
		BEGIN		
			exec  @v_logStatus = LogSkip 51,@v_scriptName
			ALTER TABLE WFAuthorizeQueueDefTable ADD SortOrder NVARCHAR(1)     NULL
			PRINT 'Table WFAuthorizeQueueDefTable altered with new Column SortOrder'
		END	
		
		EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ALTER COLUMN ArgList NVarchar(2000)')
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 51,@v_scriptName
		RAISERROR('Block 51 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 51,@v_scriptName

exec @v_logStatus= LogInsert 52,@v_scriptName,'Creating TABLE WFQueueColorTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFQueueColorTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 52,@v_scriptName
			EXECUTE('
				CREATE TABLE WFQueueColorTable(
					Id              INT     IDENTITY(1,1)	NOT NULL,
					QueueId 		INT                     NOT NULL,
					FieldName 		VARCHAR(50)             NULL,
					Operator 		INT                     NULL,
					CompareValue	VARCHAR(255)            NULL,
					Color			VARCHAR(10)             NULL
				)
			')
			PRINT 'Table WFQueueColorTable created successfully.'
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 52,@v_scriptName
		RAISERROR('Block 52 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 52,@v_scriptName

exec @v_logStatus= LogInsert 53,@v_scriptName,'Creating TABLE WFAuthorizeQueueColorTable'
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFAuthorizeQueueColorTable'
			   AND xType = 'U'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 53,@v_scriptName
			EXECUTE('
				CREATE TABLE WFAuthorizeQueueColorTable(
					AuthorizationId INT         	NOT NULL,
					ActionId 		INT             NOT NULL,
					FieldName 		VARCHAR(50)     NULL,
					Operator 		INT             NULL,
					CompareValue	VARCHAR(255)	NULL,
					Color			VARCHAR(10)     NULL
				)
			')
			PRINT 'Table WFAuthorizeQueueColorTable created successfully.'
		END
		
		BEGIN
			DECLARE WFCalDefTableCursor CURSOR FOR SELECT processdefid, calid FROM WFCalDefTable;
				OPEN WFCalDefTableCursor 
				FETCH NEXT FROM WFCalDefTableCursor INTO @procDefId,@CalendarId
					WHILE @@FETCH_STATUS = 0
						BEGIN
						SELECT DISTINCT CALID FROM WFCalHourDefTable WHERE processdefid = @procDefId AND calid = @CalendarId
							IF @@ROWCOUNT <= 0
								BEGIN
								PRINT 'One row insertted in WFCalHourDefTable'
								EXECUTE(' INSERT INTO WFCalHourDefTable(PROCESSDEFID,CALID,CALRULEID,RANGEID,STARTTIME,ENDTIME) VALUES(' + @procDefId + ', '+ @CalendarId +' , 0, 1, 0 , 2400)' )
								END
						FETCH NEXT FROM WFCalDefTableCursor INTO @procDefId,@CalendarId
						END
				CLOSE WFCalDefTableCursor
			DEALLOCATE WFCalDefTableCursor
		END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 53,@v_scriptName
		RAISERROR('Block 53 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 53,@v_scriptName


END;


~

PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade
~			

DROP PROCEDURE Upgrade

~

