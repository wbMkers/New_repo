/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: iBPS Server
	File Name					: Upgrade.sql
	Author						: Sajid Ali Khan
	Date written (DD/MM/YYYY)	: 06- 04- 2017
	Description					: 
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable
18/4/2017       Kumar Kimil     Bug 63461-System is allowing to assign cases to deactivated User
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  .
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered   
05-05-2017		Sajid Khan		Merging Bug 55753 - There isn't any option to add Comments while ad-hoc routing of Work Item in process manager
05-05-2017		Sajid Khan		Merging  Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
23/05/2017     Kumar Kimil      Transfer Data for IBPS(Transaction Tables including Case Management)
11/06/20117		Sajid Khan		Bug 69985 - OF 10.3 SP-2 SQL upgrade: If check in process with new version, getting error.
11/06/2017		Sajid Khan		Bug 69994 - BRT forward reverse mapping lost in registered process 
________________________________________________________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE 
existFlag 			INTEGER;
v_QueryStr        	VARCHAR(8000);
v_constraintName  	VARCHAR(160);
v_QueueId 			INTEGER;
v_rowCount 			INTEGER;
Cursor1 			REFCURSOR;
v_ProcessDefId 		INTEGER;
v_ActivityId 		INTEGER;
existsFlag 			INTEGER;
v_variableid 		INTEGER;
--Declarations
BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('wfmailQueueTable');
		IF(FOUND) THEN 
			Alter Table wfmailQueueTable Alter Column  mailto Type VARCHAR(2000);
		END IF;

		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('wfmailQueueHistoryTable');
		IF(FOUND) THEN 
			Alter Table wfmailQueueHistoryTable Alter Column  mailto Type VARCHAR(2000);
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existFlag
		FROM PG_VIEWS
		WHERE UPPER(VIEWNAME) = 'WFUSERVIEW';
		IF(FOUND) THEN
			DROP VIEW WFUSERVIEW;
			CREATE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
			EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
			COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
			MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
				AS 
			SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
			FROM PDBUSER where deletedflag = 'N' and UserAlive='Y';
		ELSE
			CREATE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
			EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
			COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
			MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
				AS 
			SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
			FROM PDBUSER where deletedflag = 'N' and UserAlive='Y';
		END IF;
		
	    existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('PROCESSDEFTABLE') and UPPER(column_name)=UPPER('OWNEREMAILID');
		IF(NOT FOUND) THEN 
			Execute('Alter Table PROCESSDEFTABLE ADD  OWNEREMAILID  VARCHAR(2000)');
		END IF;
	--19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  .	
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('PROCESSDEFTABLE') and UPPER(column_name)=UPPER('CreateWebService');
		IF(NOT FOUND) THEN 
			Execute ('Alter Table PROCESSDEFTABLE ADD  CreateWebService  VARCHAR(2)  DEFAULT ''Y''');
			Execute ('UPDATE PROCESSDEFTABLE SET CreateWebService = ''Y'' WHERE CreateWebService is null');
		END IF;
		
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFFailFileRecords');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE WFFailFileRecords (
				FailRecordId INT NOT NULL,
				FileIndex INT,
				RecordNo INT,
				RecordData VARCHAR(2000),
				Message VARCHAR(1000),
				EntryTime TIMESTAMP DEFAULT current_timestamp
			)';
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFImportFileData') and UPPER(column_name)=UPPER('FailRecords');
		IF(NOT FOUND) THEN 
			EXECUTE  ('UPDATE WFImportFileData SET FileStatus = ''S'' WHERE FileStatus = ''I''');
			EXECUTE  ('ALTER TABLE WFImportFileData ADD FailRecords INT DEFAULT 0');
			EXECUTE  ('UPDATE WFImportFileData SET FailRecords = 0');
		END IF;
		
		
		IF NOT EXISTS (SELECT 1 FROM pg_class where Upper(relname) = 'WFFAILFILERECORDS_SEQ' )
		THEN
			CREATE SEQUENCE WFFailFileRecords_SEQ INCREMENT BY 1 START WITH 1;
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFSystemServicesTable') and UPPER(column_name)=UPPER('AppServerId');
		IF(NOT FOUND) THEN 
			Execute ('Alter Table WFSystemServicesTable ADD  AppServerId  VARCHAR(100)');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('VARMAPPINGTABLE') and UPPER(column_name)=UPPER('IsEncrypted');
		IF(NOT FOUND) THEN 
			Execute ('Alter Table VARMAPPINGTABLE ADD  IsEncrypted      VARCHAR(1)    DEFAULT ''N'',
						ADD IsMasked           	VARCHAR(1)	  DEFAULT ''N'',
						ADD MaskingPattern      VARCHAR(10)   DEFAULT ''X''');
						
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFUDTVarMappingTable') and UPPER(column_name)=UPPER('IsEncrypted');
		IF(NOT FOUND) THEN 
			Execute ('Alter Table WFUDTVarMappingTable ADD  IsEncrypted      VARCHAR(1)    DEFAULT ''N'',
						ADD IsMasked           	VARCHAR(1)	  DEFAULT ''N'',
						ADD MaskingPattern      VARCHAR(10)   DEFAULT ''X''');
		END IF;

		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFActivityMaskingInfoTable');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE WFActivityMaskingInfoTable (
			ProcessDefId 		INT 			NOT NULL,
			ActivityId 		    INT 		    NOT NULL,
			ActivityName 		VARCHAR(30)	NOT NULL,
			VariableId			INT 			NOT NULL,
			VarFieldId			INTEGER		    NOT NULL,
			VariableName		VARCHAR(255) 	NOT NULL
			)';
		END IF;
		
		Execute 'Create or replace view WFCabinetView as Select * from PDBCabinet';
		
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFAUDITTRAILDOCTABLE');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE WFAUDITTRAILDOCTABLE(
				PROCESSDEFID			INTEGER NOT NULL,
				PROCESSINSTANCEID		VARCHAR(63),
				WORKITEMID				INTEGER NOT NULL,
				ACTIVITYID				INTEGER NOT NULL,
				DOCID					INTEGER NOT NULL,
				PARENTFOLDERINDEX		INTEGER NOT NULL,
				VOLID					INTEGER NOT NULL,
				APPSERVERIP				VARCHAR(63) NOT NULL,
				APPSERVERPORT			INTEGER NOT NULL,
				APPSERVERTYPE			VARCHAR(63) NULL,
				ENGINENAME				VARCHAR(63) NOT NULL,
				DELETEAUDIT				VARCHAR(1) Default ''N'',
				STATUS					CHAR(1)	NOT NULL,
				LOCKEDBY				VARCHAR(63)	NULL,
				PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID)
			)';
		END IF;
		
		existFlag := 0;
		SELECT 1 INTO existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('ARCHIVETABLE') and UPPER(column_name)=UPPER('DeleteAudit');
		IF(NOT FOUND) THEN 
			Execute ('Alter Table ARCHIVETABLE ADD  DeleteAudit	VARCHAR(1) 	Default ''N''');
		END IF;
		
		/* Modifying the Check contraint on WFCommentsTable */
		v_QueryStr := 'SELECT conname FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER(''WFCOMMENTSTABLE'')) and conname like ''wfcommentstable_commentstype_check%''';	
		BEGIN
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_constraintName;
				IF (NOT FOUND) THEN
                    EXIT;
                END IF;
				EXECUTE 'ALTER TABLE WFCommentsTable DROP CONSTRAINT '||v_constraintName;
			END LOOP;
			CLOSE Cursor1;
		END;
		
		EXECUTE 'ALTER TABLE WFCommentsTable ADD CONSTRAINT wfcommentstable_commentstype_check CHECK (CommentsType IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))';
		
		
		/*Creatiing Table WFCommentHisotryTable*/
		existFlag := 0;
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCommentsHistoryTable');
		IF (not found) then 
			 Execute  'CREATE TABLE WFCommentsHistoryTable(
					CommentsId			SERIAL			PRIMARY KEY,
					ProcessDefId 		INTEGER 		NOT NULL,
					ActivityId 			INTEGER 		NOT NULL,
					ProcessInstanceId 	VARCHAR(64)		NOT NULL,
					WorkItemId 			INTEGER 		NOT NULL,
					CommentsBy			INTEGER 		NOT NULL,
					CommentsByName		VARCHAR(64)		NOT NULL,
					CommentsTo			INTEGER 		NOT NULL,
					CommentsToName		VARCHAR(64)		NOT NULL,
					Comments			VARCHAR(1000)	NULL,
					ActionDateTime		TIMESTAMP		NOT NULL,
					CommentsType		INTEGER			NOT NULL CHECK(CommentsType IN (1, 2, 3, 4,5,6)),
					ProcessVariantId 	INTEGER DEFAULT 0 NOT NULL
				)';
		End if;
		
		existFlag := 0;
			SELECT 1 INTO existFlag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('PSREGISTERATIONTABLE') and UPPER(column_name)=UPPER('BulkPS');
			IF(NOT FOUND) THEN 
				Execute ('Alter Table PSREGISTERATIONTABLE ADD  BulkPS	VARCHAR(1) 	');
				RAISE NOTICE 'BulkPS COLUMN ADDED IN Table PSREGISTERATIONTABLE';
		END IF;
		
/*Queue Variable Extension Starts*/
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('WFINSTRUMENTTABLE') and upper(column_name) = upper('VAR_STR9');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE WFINSTRUMENTTABLE ADD VAR_DATE5 TIMESTAMP, Add VAR_DATE6 TIMESTAMP, Add VAR_LONG5 INTEGER, Add VAR_LONG6 INTEGER, 
		Add VAR_STR9 VARCHAR(512), Add VAR_STR10 VARCHAR(512), Add VAR_STR11 VARCHAR(512), Add VAR_STR12 VARCHAR(512), Add VAR_STR13 VARCHAR(512), Add VAR_STR14 VARCHAR(512), Add VAR_STR15 VARCHAR(512), Add VAR_STR16 VARCHAR(512), Add VAR_STR17 VARCHAR(512), Add VAR_STR18 VARCHAR(512), Add VAR_STR19 VARCHAR(512), Add VAR_STR20 VARCHAR(512)';
	    END IF;
		
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('VAR_STR9');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE QUEUEHISTORYTABLE Add VAR_DATE5 TIMESTAMP, Add VAR_DATE6 TIMESTAMP, Add VAR_LONG5 INTEGER, Add VAR_LONG6 INTEGER, 
		Add VAR_STR9 VARCHAR(512), Add VAR_STR10 VARCHAR(512), Add VAR_STR11 VARCHAR(512), Add VAR_STR12 VARCHAR(512), Add VAR_STR13 VARCHAR(512), Add VAR_STR14 VARCHAR(512), Add VAR_STR15 VARCHAR(512), Add VAR_STR16 VARCHAR(512), Add VAR_STR17 VARCHAR(512), Add VAR_STR18 VARCHAR(512), Add VAR_STR19 VARCHAR(512), Add VAR_STR20 VARCHAR(512)';
	    END IF;
	--Postgres restricts any alteration in the view if it is being used hence first drop the same and then proceed		
	    existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('WFSEARCHVIEW_0') ;
		IF (FOUND) THEN
			drop view WFSEARCHVIEW_0;
	    END IF;
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('queueview') ;
		IF (FOUND) THEN
			drop view queueview;
	    END IF;
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('queuetable') ;
		IF (FOUND) THEN
			drop view queuetable;
	    END IF;
		
		
		
		
		CREATE OR REPLACE VIEW QUEUETABLE 
			AS
		SELECT processdefid, processname, processversion,processinstanceid,
		 processinstanceid AS processinstancename, 
		 activityid, activityname, 
		 parentworkitemid, workitemid, 

		 processinstancestate, workitemstate, statename, queuename, queuetype,
		 assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
		 introductiondatetime, createddatetime,
		 introducedby, createdbyname, entrydatetime,lockstatus, holdstatus, 


		 prioritylevel, lockedbyname, lockedtime, validtill, savestage, 

		 previousstage,	expectedworkitemdelay AS expectedworkitemdelaytime,
			 expectedprocessdelay AS expectedprocessdelaytime, status, 
		 var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 

		 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, var_date5, var_date6, 
		 var_long1, var_long2, var_long3, var_long4, var_long5, var_long6, 
		 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,var_str9, var_str10, var_str11,
		 var_str12, var_str13, var_str14, var_str15, var_str16, var_str17, var_str18, var_str19, var_str20,
		 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
		 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
			 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, ProcessVariantId
		FROM	WFINSTRUMENTTABLE;
				
		CREATE OR REPLACE VIEW queueview AS 
		 SELECT queuetable.processdefid,
			queuetable.processname,
			queuetable.processversion,
			queuetable.processinstanceid,
			queuetable.processinstancename,
			queuetable.activityid,
			queuetable.activityname,
			queuetable.parentworkitemid,
			queuetable.workitemid,
			queuetable.processinstancestate,
			queuetable.workitemstate,
			queuetable.statename,
			queuetable.queuename,
			queuetable.queuetype,
			queuetable.assigneduser,
			queuetable.assignmenttype,
			queuetable.instrumentstatus,
			queuetable.checklistcompleteflag,
			queuetable.introductiondatetime,
			queuetable.createddatetime,
			queuetable.introducedby,
			queuetable.createdbyname,
			queuetable.entrydatetime,
			queuetable.lockstatus,
			queuetable.holdstatus,
			queuetable.prioritylevel,
			queuetable.lockedbyname,
			queuetable.lockedtime,
			queuetable.validtill,
			queuetable.savestage,
			queuetable.previousstage,
			queuetable.expectedworkitemdelaytime,
			queuetable.expectedprocessdelaytime,
			queuetable.status,
			queuetable.var_int1,
			queuetable.var_int2,
			queuetable.var_int3,
			queuetable.var_int4,
			queuetable.var_int5,
			queuetable.var_int6,
			queuetable.var_int7,
			queuetable.var_int8,
			queuetable.var_float1,
			queuetable.var_float2,
			queuetable.var_date1,
			queuetable.var_date2,
			queuetable.var_date3,
			queuetable.var_date4,
			queuetable.var_date5,
			queuetable.var_date6,
			queuetable.var_long1,
			queuetable.var_long2,
			queuetable.var_long3,
			queuetable.var_long4,
			queuetable.var_long5,
			queuetable.var_long6,
			queuetable.var_str1,
			queuetable.var_str2,
			queuetable.var_str3,
			queuetable.var_str4,
			queuetable.var_str5,
			queuetable.var_str6,
			queuetable.var_str7,
			queuetable.var_str8,
			queuetable.var_str9,
			queuetable.var_str10,
			queuetable.var_str11,
			queuetable.var_str12,
			queuetable.var_str13,
			queuetable.var_str14,
			queuetable.var_str15,
			queuetable.var_str16,
			queuetable.var_str17,
			queuetable.var_str18,
			queuetable.var_str19,
			queuetable.var_str20,
			queuetable.var_rec_1,
			queuetable.var_rec_2,
			queuetable.var_rec_3,
			queuetable.var_rec_4,
			queuetable.var_rec_5,
			queuetable.q_streamid,
			queuetable.q_queueid,
			queuetable.q_userid,
			queuetable.lastprocessedby,
			queuetable.processedby,
			queuetable.referredto,
			queuetable.referredtoname,
			queuetable.referredby,
			queuetable.referredbyname,
			queuetable.collectflag,
			queuetable.completiondatetime,
			queuetable.calendarname,
			queuetable.processvariantid
		   FROM queuetable
		UNION ALL
		 SELECT queuehistorytable.processdefid,
			queuehistorytable.processname,
			queuehistorytable.processversion,
			queuehistorytable.processinstanceid,
			queuehistorytable.processinstanceid AS processinstancename,
			queuehistorytable.activityid,
			queuehistorytable.activityname,
			queuehistorytable.parentworkitemid,
			queuehistorytable.workitemid,
			queuehistorytable.processinstancestate,
			queuehistorytable.workitemstate,
			queuehistorytable.statename,
			queuehistorytable.queuename,
			queuehistorytable.queuetype,
			queuehistorytable.assigneduser,
			queuehistorytable.assignmenttype,
			queuehistorytable.instrumentstatus,
			queuehistorytable.checklistcompleteflag,
			queuehistorytable.introductiondatetime,
			queuehistorytable.createddatetime,
			queuehistorytable.introducedby,
			queuehistorytable.createdbyname,
			queuehistorytable.entrydatetime,
			queuehistorytable.lockstatus,
			queuehistorytable.holdstatus,
			queuehistorytable.prioritylevel,
			queuehistorytable.lockedbyname,
			queuehistorytable.lockedtime,
			queuehistorytable.validtill,
			queuehistorytable.savestage,
			queuehistorytable.previousstage,
			queuehistorytable.expectedworkitemdelaytime,
			queuehistorytable.expectedprocessdelaytime,
			queuehistorytable.status,
			queuehistorytable.var_int1,
			queuehistorytable.var_int2,
			queuehistorytable.var_int3,
			queuehistorytable.var_int4,
			queuehistorytable.var_int5,
			queuehistorytable.var_int6,
			queuehistorytable.var_int7,
			queuehistorytable.var_int8,
			queuehistorytable.var_float1,
			queuehistorytable.var_float2,
			queuehistorytable.var_date1,
			queuehistorytable.var_date2,
			queuehistorytable.var_date3,
			queuehistorytable.var_date4,
			queuehistorytable.var_date5,
			queuehistorytable.var_date6,
			queuehistorytable.var_long1,
			queuehistorytable.var_long2,
			queuehistorytable.var_long3,
			queuehistorytable.var_long4,
			queuehistorytable.var_long5,
			queuehistorytable.var_long6,
			queuehistorytable.var_str1,
			queuehistorytable.var_str2,
			queuehistorytable.var_str3,
			queuehistorytable.var_str4,
			queuehistorytable.var_str5,
			queuehistorytable.var_str6,
			queuehistorytable.var_str7,
			queuehistorytable.var_str8,
			queuehistorytable.var_str9,
			queuehistorytable.var_str10,
			queuehistorytable.var_str11,
			queuehistorytable.var_str12,
			queuehistorytable.var_str13,
			queuehistorytable.var_str14,
			queuehistorytable.var_str15,
			queuehistorytable.var_str16,
			queuehistorytable.var_str17,
			queuehistorytable.var_str18,
			queuehistorytable.var_str19,
			queuehistorytable.var_str20,
			queuehistorytable.var_rec_1,
			queuehistorytable.var_rec_2,
			queuehistorytable.var_rec_3,
			queuehistorytable.var_rec_4,
			queuehistorytable.var_rec_5,
			queuehistorytable.q_streamid,
			queuehistorytable.q_queueid,
			queuehistorytable.q_userid,
			queuehistorytable.lastprocessedby,
			queuehistorytable.processedby,
			queuehistorytable.referredto,
			queuehistorytable.referredtoname,
			queuehistorytable.referredby,
			queuehistorytable.referredbyname,
			queuehistorytable.collectflag,
			NULL::text AS completiondatetime,
			queuehistorytable.calendarname,
			queuehistorytable.processvariantid
		   FROM queuehistorytable;		
		
		/*CREATE OR REPLACE VIEW WFSEARCHVIEW_0 
		AS 
		SELECT QUEUEVIEW.ProcessInstanceId,QUEUEVIEW.QueueName,	QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValIdTill,QUEUEVIEW.workitemId,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemId,QUEUEVIEW.processdefId,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby ,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype ,
		Status ,Q_QueueId , EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelayTime) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelayTime) AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  
		ProcessedBy ,  Q_UserId , WorkItemState 
		FROM QUEUEVIEW ;
		*/
		

		SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('Var_Str9');
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF (NOT FOUND) THEN 
			v_rowCount := 0;
		END IF;
		IF(v_rowCount < 1) THEN
				v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
				OPEN Cursor1 FOR EXECUTE v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;

					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values('||CAST(v_ProcessDefId AS VARCHAR)|| '	, 10006, ''VAR_DATE5'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')';

					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values('||CAST(v_ProcessDefId AS VARCHAR)|| ', 10007, ''VAR_DATE6'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values('||CAST(v_ProcessDefId AS VARCHAR)|| ', 10008, ''VAR_LONG5'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values('||CAST(v_ProcessDefId AS VARCHAR)|| ', 10009, ''VAR_LONG6'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10010, ''VAR_STR9'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10011, ''VAR_STR10'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10012, ''VAR_STR11'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10013, ''VAR_STR12'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10014, ''VAR_STR13'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10015, ''VAR_STR14'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10016, ''VAR_STR15'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10017, ''VAR_STR16'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10018, ''VAR_STR17'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10019, ''VAR_STR18'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
					
					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10020, ''VAR_STR19'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';

					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
					values(' ||CAST(v_ProcessDefId AS VARCHAR)|| ', 10021, ''VAR_STR20'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
		
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('VarAliasTable') and upper(column_name) = upper('DisplayFlag');
		IF (NOT FOUND) THEN
			EXECUTE 'ALTER TABLE VarAliasTable ADD DisplayFlag VARCHAR(1), Add SortFlag VARCHAR(1), Add SearchFlag VARCHAR(1)';
			EXECUTE 'UPDATE VarAliasTable SET DisplayFlag = ''Y'', SortFlag = ''Y'', SearchFlag = ''Y''';
			EXECUTE 'ALTER TABLE VarAliasTable 
					Alter Column DisplayFlag  SET NOT NULL,Alter Column SortFlag  SET NOT NULL, 
					Alter Column SearchFlag SET NOT NULL';
			EXECUTE 'ALTER TABLE VarAliasTable ADD CONSTRAINT CK_DisplayFlag 
					CHECK (DisplayFlag = ''Y'' OR DisplayFlag = ''N''), 
					add CONSTRAINT CK_SortFlag CHECK (SortFlag = ''Y'' OR SortFlag = ''N''),
					add CONSTRAINT CK_SearchFlag CHECK (SearchFlag = ''Y'' OR SearchFlag = ''N'')';
	    END IF;
		/*Queue varaible Extension Ends*/

/*USer deassocaition with from System Queues and PFE and Archival handling if missed */
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemPFEQueue';
		 GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		 IF (NOT FOUND) THEN 
			 v_rowCount := 0;
		 END IF;
		 IF(v_rowCount > 0) THEN
			 EXECUTE 'Delete from WFUserObjAssocTable Where  ObjectTypeId = 2 and ObjectId  = '||CAST(v_QueueId AS VARCHAR); --ObjectTypeId = 2 ; Queue
			 v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 10 And ActivitySubType = 1 ';
			 OPEN Cursor1 FOR EXECUTE v_queryStr;
			 LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					EXECUTE 'Update QueueStreamTable set QueueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = '||CAST(v_ProcessDefId AS VARCHAR);

					EXECUTE 'Update WFInstrumentTable set QueueName = ''SystemPFEQueue'' ,Q_queueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and RoutingStatus =''N'' ';

			END LOOP;			 
			CLOSE Cursor1;
		 END IF;
		 
		 
		 SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemArchiveQueue';
		 GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		 IF (NOT FOUND) THEN 
			 v_rowCount := 0;
		 END IF;
		 IF(v_rowCount > 0) THEN
			 EXECUTE 'Delete from WFUserObjAssocTable Where  ObjectTypeId = 2 and ObjectId  = '||CAST(v_QueueId AS VARCHAR); --ObjectTypeId = 2 ; Queue
			 v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 10 And ActivitySubType = 4 ';
			 OPEN Cursor1 FOR EXECUTE v_queryStr;
			 LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					EXECUTE 'Update QueueStreamTable set QueueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = '||CAST(v_ProcessDefId AS VARCHAR);

					EXECUTE 'Update WFInstrumentTable set QueueName = ''SystemArchiveQueue'' ,Q_queueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and RoutingStatus =''N'' ';

			END LOOP;			 
			CLOSE Cursor1;
		 END IF;
		
		/*System Queue Creation and Association */
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemWSQueue';
		 GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		 IF (NOT FOUND) THEN 
			 v_rowCount := 0;
		 END IF;
		 IF(v_rowCount < 1) THEN
			 EXECUTE  'INSERT INTO QueueDefTable (QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(''SystemWSQueue'',''A'',''Queue of QueueType A for WebServiceInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			 SELECT currval('queuedeftable_queueid_seq') INTO v_QueueId;
			 RAISE NOTICE 'Queue of QueueType A for WebServiceInvoker Utility is added successfully';
			 v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 22';
			 OPEN Cursor1 FOR EXECUTE v_queryStr;
			 LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					EXECUTE 'Update QueueStreamTable set QueueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = '||CAST(v_ProcessDefId AS VARCHAR);

					EXECUTE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and RoutingStatus =''N'' ';

			END LOOP;			 
			CLOSE Cursor1;
		 END IF;	
	 
	 
	
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemSAPQueue';
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	    IF (NOT FOUND) THEN 
         v_rowCount := 0;
	    END IF;
	    IF(v_rowCount < 1) THEN
			EXECUTE 'INSERT INTO QueueDefTable (QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values( ''SystemSAPQueue'',''A'',''Queue of QueueType A for SAPInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			RAISE NOTICE'Queue of QueueType A for SAPInvoker Utility is added successfully';
			SELECT currval('queuedeftable_queueid_seq') INTO v_QueueId;
			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 29';
			OPEN Cursor1 FOR EXECUTE v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				IF (NOT FOUND) THEN
						EXIT;
					END IF;

				EXECUTE 'Update QueueStreamTable set QueueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = '||CAST(v_ProcessDefId AS VARCHAR);

				EXECUTE 'Update WFInstrumentTable set QueueName = ''SystemSAPQueue'' ,Q_queueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and RoutingStatus =''N'' ';
				
			END LOOP;
			CLOSE Cursor1;
	    END IF;
	 
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemBRMSQueue';
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	    IF (NOT FOUND) THEN 
          v_rowCount := 0;
	    END IF;
	    IF(v_rowCount < 1) THEN
			EXECUTE  'INSERT INTO QueueDefTable (QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values( ''SystemBRMSQueue'',''A'',''Queue of QueueType A for WebServiceInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			RAISE NOTICE'Queue of QueueType A for WebServiceInvoker Utility is added successfully';
			SELECT currval('queuedeftable_queueid_seq') INTO v_QueueId;
			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 31';
			OPEN Cursor1 FOR EXECUTE v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				IF (NOT FOUND) THEN
                    EXIT;
                END IF;
				EXECUTE 'Update QueueStreamTable set QueueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = '||CAST(v_ProcessDefId AS VARCHAR);

				EXECUTE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || CAST(v_QueueId AS VARCHAR) || ' where activityId = ' || CAST(v_ActivityId AS VARCHAR) || ' and processDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and RoutingStatus =''N'' ';

			END LOOP;
			CLOSE Cursor1;
		END IF;
		/*System Queue Creation and Association ENDS*/
		
/*Making entry in WFCabVersionTable for iBPS_3.0_SP1*/	
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('WFReportDataHistoryTable');
		IF(NOT FOUND) THEN 
			CREATE TABLE WFReportDataHistoryTable(
			ProcessInstanceId	VARCHAR(63),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER		NOT NULL,
	ActivityId			INTEGER,
	UserId				INTEGER,
	TotalProcessingTime	INTEGER,
	ProcessVariantId 	 INTEGER DEFAULT 0 NOT NULL
		);
		RAISE NOTICE 'Table WFReportDataHistoryTable created successfully';
		END IF;
		
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('WFTaskStatusHistoryTable');
		IF(NOT FOUND) THEN 
			create table WFTaskStatusHistoryTable(
					
			ProcessInstanceId VARCHAR(63) NOT NULL,
			WorkItemId INTEGER NOT NULL,
			ProcessDefId INTEGER NOT NULL,
			ActivityId INTEGER NOT NULL,
			TaskId  INTEGER NOT NULL,
			SubTaskId  INTEGER NOT NULL,
			TaskStatus INTEGER NOT NULL,
			AssignedBy VARCHAR(63) NOT NULL,
			AssignedTo VARCHAR(63) ,
			Instructions VARCHAR(2000) NULL,
			ActionDateTime TIMESTAMP NOT NULL,
			DueDate TIMESTAMP,
			Priority  INTEGER, 
			ShowCaseVisual	VARCHAR(1) DEFAULT 'N' NOT NULL,
			ReadFlag VARCHAR(1) default 'N' NOT NULL,
			CanInitiate	VARCHAR(1) default 'N' NOT NULL,	
			Q_DivertedByUserId INTEGER DEFAULT 0,
			CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
				);
		RAISE NOTICE 'Table WFTaskStatusHistoryTable created successfully';
		END IF;
		
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('WFRTTASKINTFCASSOCHISTORY');
		IF(NOT FOUND) THEN 
			create table WFRTTASKINTFCASSOCHISTORY (
			 ProcessInstanceId VARCHAR(63) NOT NULL,
				WorkItemId  INTEGER NOT NULL,
				ProcessDefId INTEGER  NOT NULL, 
				ActivityId INTEGER NOT NULL,
				TaskId INTEGER NOT NULL, 
				InterfaceId INTEGER NOT NULL, 
				InterfaceType NCHAR(1) NOT NULL,
				Attribute VARCHAR(2)
		);
		RAISE NOTICE 'Table WFRTTASKINTFCASSOCHISTORY created successfully';
		END IF;
		
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('RTACTIVITYINTFCASSOCHISTORY');
		IF(NOT FOUND) THEN 
			CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
			ProcessInstanceId VARCHAR(63) NOT NULL,
			WorkItemId                INTEGER NOT NULL,
			ProcessDefId             INTEGER		NOT NULL,
			ActivityId              INTEGER             NOT NULL,
			ActivityName            VARCHAR(30)    NOT NULL,
			InterfaceElementId      INTEGER             NOT NULL,
			InterfaceType           VARCHAR(1)     NOT NULL,
			Attribute               VARCHAR(2)     NULL,
			TriggerName             VARCHAR(255)   NULL,
			ProcessVariantId 		INTEGER 			DEFAULT 0 NOT NULL 
		);
		RAISE NOTICE 'Table RTACTIVITYINTFCASSOCHISTORY created successfully';
		END IF;
		
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER('WFATTRIBUTEMESSAGEHISTORYTABLE');
		IF(NOT FOUND) THEN 
			CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ( 
				ProcessDefID		INTEGER		NOT NULL,
				ProcessVariantId 		INTEGER DEFAULT 0  NOT NULL, 
				ProcessInstanceID	VARCHAR (63)  NOT NULL ,
				WorkitemId		    INTEGER		NOT NULL,
				MESSAGEID		INTEGER NOT NULL, 
				MESSAGE			TEXT NOT NULL, 
				LOCKEDBY		VARCHAR(63), 
				STATUS			VARCHAR(1) CHECK (status in ('N', 'F')), 
				ActionDateTime	DATE,  
				CONSTRAINT PK_WFATTRIBUTEMESSAGEHISTORYTABLE PRIMARY KEY (MESSAGEID ) 
		);
		RAISE NOTICE 'Table WFATTRIBUTEMESSAGEHISTORYTABLE created successfully';
		END IF;
		
		 existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('ChildProcessInstanceId');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD ChildProcessInstanceId		VARCHAR(63)	NULL');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD ChildProcessInstanceId		VARCHAR(63)	NULL';
		
		 existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('ChildWorkitemId');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		ChildWorkitemId				INT');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 		ChildWorkitemId				INT';
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('FilterValue');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		FilterValue					INT		NULL ');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	FilterValue					INT		NULL ';
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('Guid');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		Guid 						BIGINT ');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	Guid 						BIGINT ';
		
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('NotifyStatus');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		NotifyStatus				VARCHAR(1)');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	NotifyStatus				VARCHAR(1)';
		
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('Q_DivertedByUserId');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		Q_DivertedByUserId   		INT NULL				');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	Q_DivertedByUserId				INT NULL';
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('RoutingStatus');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 	RoutingStatus				VARCHAR(1) ');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	RoutingStatus				VARCHAR (1)';
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('NoOfCollectedInstances');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		NoOfCollectedInstances		INT DEFAULT 0');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	NoOfCollectedInstances			INT DEFAULT 0';
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('IsPrimaryCollected');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		IsPrimaryCollected			VARCHAR(1) NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	IsPrimaryCollected			VARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))';
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('Introducedbyid');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		Introducedbyid				INTEGER		NULL ');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	Introducedbyid				INTEGER		NULL ';
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('IntroducedAt');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		IntroducedAt				VARCHAR(30)	 NULL');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	IntroducedAt				VARCHAR(30)	 NULL';
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('Createdby');
		IF(NOT FOUND) THEN 
			Execute('ALTER TABLE QueueHistoryTable ADD 		Createdby					INTEGER		 NULL');
		END IF;
		RAISE NOTICE 'ALTER TABLE QueueHistoryTable ADD 	Createdby					INTEGER		 NULL';
	
/* Modifying the Check contraint on EXTMETHODDEFTABLE for B type */
		v_QueryStr := 'SELECT conname FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER(''EXTMETHODDEFTABLE'')) and conname like ''extmethoddeftable_extapptype_check%''';	
		BEGIN
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_constraintName;
				IF (NOT FOUND) THEN
                    EXIT;
                END IF;
				EXECUTE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT '||v_constraintName;
			END LOOP;
			CLOSE Cursor1;
		END;	
		EXECUTE 'ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT extmethoddeftable_extapptype_check CHECK (ExtAppType IN (''E'', ''W'', ''S'', ''Z'', ''B'',''R''))';
	
	--EXECUTE 'TRUNCATE TABLE WFMAILQUEUEHISTORYTABLE';
	
	existsFlag :=0;	
	BEGIN
		 SELECT Count(1) INTO existsFlag FROM WFCabVersionTable WHERE UPPER(cabVersion) = UPPER('iBPS_3.0_SP1');
		 If(existsFlag=0) THEN
		 BEGIN
			INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.0_SP1',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'iBPS_3.0_SP1', N'Y');
		 END;
		 END IF;
	END;
		
END;
$$ LANGUAGE plpgsql;

~

select Upgrade();

~

Drop FUNCTION Upgrade();

~

