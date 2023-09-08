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
_______________________________________________________________________________________________________________________-*/

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
		EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'
		EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
	END

/*SrNo-15, New tables added for SAP integration.*/

	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSAPConnectTable' 
			AND xType = 'U'
		)
		BEGIN
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


/* Modified by Ananta Handoo - 23/06/2009 */
	IF NOT EXISTS (
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFSAPGUIDefTable'
		   AND xType = 'U'
	)
	BEGIN
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
		
	IF NOT EXISTS (
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFSAPGUIFieldMappingTable'
		   AND xType = 'U'
	)
	BEGIN
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
	
	IF NOT EXISTS(
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFSAPGUIAssocTable'
		   AND xType = 'U'
	)
	BEGIN
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
	
	IF NOT EXISTS (
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFSAPAdapterAssocTable'
		   AND xType = 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFSAPAdapterAssocTable (
			ProcessDefId		INT				 NULL,
			ActivityId			INT				 NULL,
			EXTMETHODINDEX		INT				 NULL
			)
		 ')
		PRINT 'Table WFSAPAdapterAssocTable created successfully.'
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
		AND  NAME = 'InputBuffer'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFWebServiceTable ADD InputBuffer NTEXT')
		PRINT 'Table WFWebServiceTable altered with new Column InputBuffer'
		EXECUTE('ALTER TABLE WFWebServiceTable ADD OutputBuffer NTEXT')
		PRINT 'Table WFWebServiceTable altered with new Column OutputBuffer'
	END

	EXECUTE('ALTER TABLE ExceptionTable ALTER COLUMN ExceptionComments NVarchar(512)')
	EXECUTE('ALTER TABLE ExceptionHistoryTable ALTER COLUMN ExceptionComments NVarchar(512)')
	EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ALTER COLUMN ArgList NVarchar(2000)')


	/* Added by Ishu Saraf - 17/06/2009 */
	IF NOT EXISTS(
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFPDATable'
		   AND xType = 'U'
	)
	BEGIN
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

	/* Added by Ishu Saraf - 17/06/2009 */
	IF NOT EXISTS(
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFPDA_FormTable'
		   AND xType = 'U'
	)
	BEGIN
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

	/* Added by Ishu Saraf - 17/06/2009 */
	IF NOT EXISTS(
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFPDAControlValueTable'
		   AND xType = 'U'
	)
	BEGIN
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
    
	/* WFS_8.0_018 Start*/

	 IF EXISTS(
		   select *
		   from information_schema.columns where table_name = 'mailtriggertable'
		   and data_type = 'text'
	)
	BEGIN
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
		EXECUTE('insert into MAILTRIGGERTABLE select * from mailtriggertable_old ')
		PRINT 'Table mailtriggertable updated successfully'
	END 

	IF EXISTS(
		   select *
		   from information_schema.columns where table_name = 'wfmailqueuetable'
		   and data_type = 'text'
	)
	BEGIN
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
					noOfTrials		INTEGER		default 0,
					zipFlag 			nvarchar(1)		NULL,
					zipName 			nvarchar(255)	NULL,
					maxZipSize 			int				NULL,
					alternateMessage 	ntext			NULL
			) 
		')
		PRINT 'New wfmailqueuetable created with nText'
		EXECUTE('insert into wfmailqueuetable (mailFrom, mailTo, mailCC, mailSubject, mailMessage, 		 mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, 	 statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, 	 processDefId,	processInstanceId, workitemId, activityId, noOfTrials) 
			 select mailFrom, mailTo, mailCC, mailSubject, mailMessage, mailContentType, attachmentISINDEX, attachmentNames, attachmentExts, mailPriority, mailStatus, statusComments, lockedBy, successTime, LastLockTime, insertedBy, mailActionType, insertedTime, processDefId,	processInstanceId, workitemId, activityId, noOfTrials from wfmailqueuetable_old ')
		PRINT 'Table wfmailqueuetable updated successfully'
	END

	IF EXISTS(
		   select *
		   from information_schema.columns where table_name = 'userpreferencestable'
		   and data_type = 'text'
	)
	BEGIN
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

	IF EXISTS(
		   select *
		   from information_schema.columns where table_name = 'wfmailqueuehistorytable'
		   and data_type = 'text'
	)
	BEGIN
		EXECUTE(' sp_rename wfmailqueuehistorytable,wfmailqueuehistorytable_old ')
		PRINT 'Original wfmailqueuehistorytable renamed to wfmailqueuehistorytable_old'
		EXECUTE('
			CREATE TABLE WFMAILQUEUEHISTORYTABLE(
				TaskId 			INTEGER		PRIMARY KEY,
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
		 PRINT 'New wfmailqueuehistorytable created with nText'
		 EXECUTE('insert into WFMAILQUEUEHISTORYTABLE select * from wfmailqueuehistorytable_old ')
		PRINT 'Table wfmailqueuehistorytable updated successfully'
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
	
	/*HotFix_8.0_045- Variable support in doctypename in PFE*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailDocTypeTable')
		AND  NAME = 'VariableId'
		)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailDocTypeTable ADD VariableId INT, VarFieldId INT')
		PRINT 'Table PrintFaxEmailDocTypeTable altered with new Columns VariableId and VarFieldId'
	END

	/*WFS_8.0_026 - workitem specific calendar*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDataTable')
		AND  NAME = 'CalendarName'
		)
	BEGIN
		EXECUTE('ALTER TABLE QueueDataTable ADD CalendarName NVARCHAR(255)')
		PRINT 'Table QueueDataTable altered with new Column CalendarName'
	END

	/*WFS_8.0_026 - workitem specific calendar*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
		AND  NAME = 'CalendarName'
		)
	BEGIN
		EXECUTE('ALTER TABLE QueueHistoryTable ADD CalendarName NVARCHAR(255)')
		PRINT 'Table QueueHistoryTable altered with new Column CalendarName'
	END

   /*WFS_8.0_018 End*/
	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_CalendarName_VarMapping')
	BEGIN
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

   /*WFS_8.0_026 - workitem specific calendar*/
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

	/*WFS_8.0_031*/
	BEGIN
		Select @existsFlag = 0 	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
			AND  NAME = 'QUERYPREVIEW'
			)  
		BEGIN
			ALTER TABLE QUEUEUSERTABLE ADD QUERYPREVIEW NVARCHAR(1) DEFAULT ('Y')
		END
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'V' and name = 'QUSERGROUPVIEW')
		Begin
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
	/*WFS_8.0_038*/
	BEGIN
		Select @existsFlag = 0 	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
			AND  NAME = 'REFRESHINTERVAL'
			)  
		BEGIN
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

	IF NOT EXISTS(
		   SELECT * FROM SYSObjects 
		   WHERE NAME = 'WFExtInterfaceOperationTable'
		   AND xType = 'U'
	)
	BEGIN
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
	/*WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping')
	BEGIN
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
	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDocTypeFieldMapping')
	BEGIN
		CREATE TABLE WFDocTypeFieldMapping(
		ProcessDefId int NOT NULL,
		DocID int NOT NULL,
		DCName nvarchar (30) NOT NULL,
		FieldName nvarchar (30) NOT NULL,
		FieldID int NOT NULL,
		VariableID int NOT NULL,
		VarFieldID int NOT NULL,
		MappedFieldType nvarchar(1) NOT NULL,
		MappedFieldName nvarchar(255) NOT NULL,
		FieldType int NOT NULL
		)
		PRINT 'Table WFDocTypeFieldMapping created successfully'
	END
	
	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDocTypeSearchMapping')
	BEGIN
		CREATE TABLE WFDocTypeSearchMapping(
		ProcessDefId int NOT NULL,
		ActivityID int NOT NULL,
		DCName nvarchar(30) NULL,
		DCField nvarchar(30) NOT NULL,
		VariableID int NOT NULL,
		VarFieldID int NOT NULL,
		MappedFieldType nvarchar(1) NOT NULL,
		MappedFieldName nvarchar(255) NOT NULL,
		FieldType int NOT NULL
		)
		PRINT 'Table WFDocTypeSearchMapping created successfully'
	END

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDataclassUserInfo')
	BEGIN
		CREATE TABLE WFDataclassUserInfo(
		ProcessDefId int NOT NULL,
		CabinetName nvarchar(30) NOT NULL,
		UserName nvarchar(30) NOT NULL,
		SType nvarchar(1) NOT NULL,
		UserPWD varchar(255) NOT NULL
		)
		PRINT 'Table WFDataclassUserInfo created successfully'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFCOMMENTTABLE')
		AND  NAME in ('CommentFont','CommentForeColor','CommentBackColor','CommentBorderStyle')
		)
	BEGIN
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentFont NVARCHAR(255) NOT NULL')
		PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentFont'
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentForeColor INT NOT NULL')
		PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentForeColor'
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentBackColor INT NOT NULL')
		PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentBackColor'
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentBorderStyle INT NOT NULL')
		PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new CommentBorderStyle'
	END
	
	BEGIN
		EXECUTE('alter table WFCURRENTROUTELOGTABLE alter column NewValue NVARCHAR(2000)')
		PRINT 'Table WFCURRENTROUTELOGTABLE altered with Column NewValue size as 2000'
		EXECUTE('alter table WFHISTORYROUTELOGTABLE alter column NewValue NVARCHAR(2000)')
		PRINT 'Table WFHISTORYROUTELOGTABLE altered with Column NewValue size as 2000'
		EXECUTE('alter table WFFormFragmentTable alter column FragmentName	NVARCHAR(50)')
		PRINT 'Table WFFormFragmentTable altered with Column FragmentName size as NVARCHAR(50)'
		EXECUTE('alter table WFFormFragmentTable alter column IsEncrypted NVARCHAR(1)')
		PRINT 'Table WFFormFragmentTable altered with Column IsEncrypted size as NVARCHAR(1)'
		EXECUTE('alter table WFFormFragmentTable alter column StructureName	NVARCHAR(128)')
		PRINT 'Table WFFormFragmentTable altered with Column StructureName size as NVARCHAR(128)'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
		AND  NAME = 'SortOrder'
		)
	BEGIN
		EXECUTE('ALTER TABLE QUEUEDEFTABLE ADD SortOrder NVARCHAR(1)')
		PRINT 'Table QUEUEDEFTABLE altered with new Column SortOrder'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'VARALIASTABLE')
		AND  NAME = 'AliasRule'
		)
	BEGIN
		EXECUTE('ALTER TABLE VARALIASTABLE ADD AliasRule NVARCHAR(2000)')
		PRINT 'Table VARALIASTABLE altered with new Column AliasRule'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'DOCUMENTTYPEDEFTABLE')
		AND  NAME = 'DCName'
		)
	BEGIN
		EXECUTE('ALTER TABLE DOCUMENTTYPEDEFTABLE ADD DCName NVARCHAR(64)')
		PRINT 'Table DOCUMENTTYPEDEFTABLE altered with new Column DCName'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFSwimLaneTable')
		AND  NAME in ('SwimLaneType','SwimLaneText','SwimLaneTextColor')
		)
	BEGIN
		EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneType NVARCHAR(1) NOT NULL')
		PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneType'
		EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneText NVARCHAR(255) NOT NULL')
		PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneText'
		EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneTextColor INT NOT NULL')
		PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneTextColor'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
		AND  NAME in ('EXTMETHODINDEX','ALIGNMENT')
		)
	BEGIN
		EXECUTE('ALTER TABLE WFDataMapTable ADD EXTMETHODINDEX INT')
		PRINT 'Table WFDataMapTable altered with new Column EXTMETHODINDEX'
		EXECUTE('ALTER TABLE WFDataMapTable ADD ALIGNMENT NVARCHAR(5)')
		PRINT 'Table WFDataMapTable altered with new Column ALIGNMENT'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFAuthorizeQueueDefTable')
		AND  NAME = 'SortOrder'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFAuthorizeQueueDefTable ADD SortOrder NVARCHAR(1)')
		PRINT 'Table WFAuthorizeQueueDefTable altered with new Column SortOrder'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFTMSSetVariableMapping')
		AND  NAME = 'AliasRule'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFTMSSetVariableMapping ADD AliasRule	VARCHAR(4000)')
		PRINT 'Table WFTMSSetVariableMapping altered with new Column AliasRule'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFWebServiceInfoTable' 
			AND xType = 'U'
		)
		BEGIN
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
		
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSystemServicesTable' 
			AND xType = 'U'
		)
		BEGIN
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
		
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFQueueColorTable' 
			AND xType = 'U'
		)
		BEGIN
			EXECUTE(' 
				CREATE TABLE WFQueueColorTable(
				Id              INT     IDENTITY(1,1)	NOT NULL		PRIMARY KEY,
				QueueId 		INT                     NOT NULL,
				FieldName 		VARCHAR(50)             NULL,
				Operator 		INT                     NULL,
				CompareValue	VARCHAR(255)            NULL,
				Color			VARCHAR(10)             NULL
				)
			')
			PRINT 'Table WFQueueColorTable created successfully.'
		END
		
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFAuthorizeQueueColorTable' 
			AND xType = 'U'
		)
		BEGIN
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
		IF EXISTS ( SELECT * FROM sysObjects 
		WHERE NAME = 'TransportDataTable'
		)
		BEGIN
			IF NOT EXISTS ( SELECT id FROM sysObjects 
			WHERE NAME = 'WFTransportDataTable'
			)
				BEGIN
					EXECUTE(' sp_rename TransportDataTable,WFTransportDataTable ')
					PRINT 'Original TransportDataTable renamed to WFTransportDataTable'
				END
			ELSE
				BEGIN
					PRINT 'TransportDataTable and WFTransportDataTable both present,check..'
				END
		END
		
		IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFTransportDataTable')
		AND  NAME in ('UserId','UserName','ReleasedByUserId','ReleasedDateTime','TransportedByUserId','TransportedDateTime')
		)
		BEGIN
			EXECUTE('ALTER TABLE WFTransportDataTable ADD UserId INT NOT NULL')
			PRINT 'Table WFTransportDataTable altered with new Column UserId'
			EXECUTE('ALTER TABLE WFTransportDataTable ADD UserName NVARCHAR(64) NOT NULL')
			PRINT 'Table WFTransportDataTable altered with new Column UserName'
			EXECUTE('ALTER TABLE WFTransportDataTable ADD ReleasedByUserId INT')
			PRINT 'Table WFTransportDataTable altered with new Column ReleasedByUserId'
			EXECUTE('ALTER TABLE WFTransportDataTable ADD ReleasedDateTime DATETIME')
			PRINT 'Table WFTransportDataTable altered with new Column ReleasedDateTime'
			EXECUTE('ALTER TABLE WFTransportDataTable ADD TransportedByUserId INT')
			PRINT 'Table WFTransportDataTable altered with new Column TransportedByUserId'
			EXECUTE('ALTER TABLE WFTransportDataTable ADD TransportedDateTime DATETIME')
			PRINT 'Table WFTransportDataTable altered with new Column TransportedDateTime'
		END
	END
	
	BEGIN
		IF EXISTS ( SELECT * FROM sysObjects 
		WHERE NAME = 'TransportRegisterationInfo'
		AND xType = 'U'
		)
		BEGIN
			IF NOT EXISTS ( SELECT id FROM sysObjects 
			WHERE NAME = 'WFTransportRegisterationInfo'
			AND xType = 'U'
			)
				BEGIN
					EXECUTE(' sp_rename TransportRegisterationInfo,WFTransportRegisterationInfo ')
					PRINT 'Original TransportRegisterationInfo renamed to WFTransportRegisterationInfo'
				END
			ELSE
				BEGIN
					PRINT 'TransportRegisterationInfo and WFTransportRegisterationInfo both present,check..'
				END
		END
		
		IF EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFTransportRegisterationInfo')
		AND  NAME = 'TargetCabinetName'
		)
		BEGIN
			EXECUTE('sp_rename ''WFTransportRegisterationInfo.TargetCabinetName'',''WFTransportRegisterationInfo.TargetEngineName''')
			PRINT 'Table WFTransportRegisterationInfo renamed column to TargetEngineName'
		END
	END
	
END;


~

PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade
~			

DROP PROCEDURE Upgrade

~

