/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis_iBPS
	Product / Project			: WorkFlow
	Module						: iBPS Server
	File NAME					: Upgrade.sql (Oracle Server)
	Author						: Sajid Ali Khan
	Date written (DD/MM/YYYY)	: 06-04-2017
	Description					: 
________________________________________________________________________________________________________________-
			CHANGE HISTORY
________________________________________________________________________________________________________________-
Date			Change By		Change Description (Bug No. (If Any))
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error.
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  .
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered   
05-05-2017		Sajid Khan		Merging Bug 55753 - There isn't any option to add Comments while ad-hoc routing of Work Item in process  
05-05-02017		Sajid Khan		Merging Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties.				
19/05/2017		Ambuj Tripathi	Create/Update the tables related to Transfer History tasks
11/06/2017		Sajid Khan		Bug 69985 - OF 10.3 SP-2 SQL upgrade: If check in process with new version, getting error.
11/06/2017		Sajid Khan		Bug 69994 - BRT forward reverse mapping lost in registered process
23/08/2017		Shubhankur Manuja	Bug 71088 - Error in upgrade cabinet for oracle versions lower than oracle 12
20/11/2017		Ambuj Tripathi	Bug 73616 - Getting error in cabinet upgrade - Table or view doesnt exists.
___________________________________________________________________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade AS
	v_STR1			        VARCHAR2(8000);
	v_constraintName VARCHAR2(512);
	v_SearchCondition NVARCHAR2(5000);
	v_SearchConditionOld NVARCHAR2(5000);
	v_SearchConditionNew NVARCHAR2(5000);
	v_IsConstraintUpdated INT;
	TYPE DynamicCursor	IS REF CURSOR;
	Cursor1 DynamicCursor;
	existsFlag INT;
	v_rowCount INT;
	v_queryStr VARCHAR2(800);
	v_ProcessDefId INTEGER;
	v_ActivityId INT;
	v_variableid	 INTEGER;
	v_QueueId INT;
	v_lastSeqValue			INTEGER;
	v_rootLogId			INTEGER;
FUNCTION checkIFColExist(v_TableName VARCHAR2,v_ColName VARCHAR2 )
	RETURN BOOLEAN
	AS
	--existsFlag NUMBER:=0;
	BEGIN
	
		SELECT COUNT(1) INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER(v_TableName) 
		AND 
		COLUMN_NAME=UPPER(v_ColName);
		
		IF(existsFlag=0) THEN
			dbms_output.put_line ('Table '||v_TableName||' is NOT having coloumn '||v_ColName);
			RETURN FALSE;		
		ELSE
			dbms_output.put_line ('Table '||v_TableName||' is ALREADY having coloumn '||v_ColName);
			RETURN TRUE;		
		END IF;
	
	END;


BEGIN
			BEGIN
			IF (checkIFColExist('WFMAILQUEUETABLE','mailto')) THEN
				 EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE MODIFY (mailto NVARCHAR2(2000))';
			END IF;
			END;

			BEGIN			
			IF (checkIFColExist('WFMAILQUEUETABLE','mailCC')) THEN
				 EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE MODIFY (mailCC NVARCHAR2(2000))';
			END IF;
			END;
			
			BEGIN
			IF (checkIFColExist('wfmailQueueHistoryTable','mailto')) THEN
				 EXECUTE IMMEDIATE 'ALTER TABLE wfmailQueueHistoryTable MODIFY (mailto NVARCHAR2(2000))';
			END IF;
			END;

			BEGIN
			IF (checkIFColExist('wfmailQueueHistoryTable','mailCC')) THEN
				 EXECUTE IMMEDIATE 'ALTER TABLE wfmailQueueHistoryTable MODIFY (mailCC NVARCHAR2(2000))';
			END IF;
			END;
		
	


			BEGIN
			IF (checkIFColExist('PROCESSDEFTABLE','OWNEREMAILID')) THEN
				dbms_output.put_line ('Table PROCESSDEFTABLE is ALREADY having coloumn OWNEREMAILID');
			ELSE
				 EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE ADD  OWNEREMAILID    NVARCHAR2(255)';
			END IF;
			END;
		

			BEGIN
			IF (checkIFColExist('PROCESSDEFTABLE','CreateWebService')) THEN
				dbms_output.put_line ('Table PROCESSDEFTABLE is ALREADY having coloumn CreateWebService');
			ELSE
				 EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE ADD CreateWebService NVARCHAR2(2) Default ''Y''';
				 EXECUTE IMMEDIATE 'UPDATE PROCESSDEFTABLE SET CreateWebService = ''Y'' WHERE CreateWebService is null';
			END IF;
			END;
		
			BEGIN
			IF (checkIFColExist('WFSystemServicesTable','AppServerId')) THEN
				dbms_output.put_line ('Table WFSystemServicesTable is ALREADY having coloumn AppServerId');
			ELSE
				 EXECUTE IMMEDIATE 'ALTER TABLE WFSystemServicesTable ADD AppServerId NVARCHAR2(100)';
			END IF;
			END;

			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFActivityMaskingInfoTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFActivityMaskingInfoTable (
						ProcessDefId 		INT 			NOT NULL,
						ActivityId 		    INT 		    NOT NULL,
						ActivityName 		NVARCHAR2(30)	NOT NULL,
						VariableId			INT 			NOT NULL,
						VarFieldId			SMALLINT		NOT NULL,
						VariableName		NVARCHAR2(255) 	NOT NULL
						)';
					dbms_output.put_line ('Table WFActivityMaskingInfoTable Created successfully');
			END;
			
			Execute Immediate 'Create or Replace view WFCabinetView as Select * from PDBCabinet';
			
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME = UPPER('VARMAPPINGTABLE') 
				AND 
				COLUMN_NAME = UPPER('IsEncrypted');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'ALTER TABLE VARMAPPINGTABLE Add (IsEncrypted  NVARCHAR2(1)    DEFAULT N''N'' NULL)';			
					EXECUTE IMMEDIATE 'ALTER TABLE VARMAPPINGTABLE Add (IsMasked   NVARCHAR2(1)    DEFAULT N''N'' NULL)';	
					EXECUTE IMMEDIATE 'ALTER TABLE VARMAPPINGTABLE Add (MaskingPattern      NVARCHAR2(10)   DEFAULT N''X'' NULL)';
				
			END;
			
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable') 
				AND 
				COLUMN_NAME = UPPER('IsEncrypted');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFUDTVarMappingTable Add (IsEncrypted  NVARCHAR2(1)    DEFAULT N''N'' NULL)';			
					EXECUTE IMMEDIATE 'ALTER TABLE WFUDTVarMappingTable Add (IsMasked   NVARCHAR2(1)    DEFAULT N''N'' NULL)';	
					EXECUTE IMMEDIATE 'ALTER TABLE WFUDTVarMappingTable Add (MaskingPattern      NVARCHAR2(10)   DEFAULT N''X'' NULL)';
				
			END;
			
			
			
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFAUDITTRAILDOCTABLE');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFAUDITTRAILDOCTABLE(
						PROCESSDEFID			INT NOT NULL,
						PROCESSINSTANCEID		NVARCHAR2(63),
						WORKITEMID				INT NOT NULL,
						ACTIVITYID				INT NOT NULL,
						DOCID					INT NOT NULL,
						PARENTFOLDERINDEX		INT NOT NULL,
						VOLID					INT NOT NULL,
						APPSERVERIP				NVARCHAR2(63) NOT NULL,
						APPSERVERPORT			INT NOT NULL,
						APPSERVERTYPE			NVARCHAR2(63) NULL,
						ENGINENAME				NVARCHAR2(63) NOT NULL,
						DELETEAUDIT				NVARCHAR2(1) Default ''N'',
						STATUS					CHAR(1)	NOT NULL,
						LOCKEDBY				NVARCHAR2(63)	NULL,
						PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID)
					)';
					dbms_output.put_line ('Table WFAUDITTRAILDOCTABLE Created successfully');
			END;
			
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME = UPPER('ARCHIVETABLE') 
				AND 
				COLUMN_NAME = UPPER('DeleteAudit');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE Add (DeleteAudit  NVARCHAR2(1) Default ''N'')';			
			END;
			

/* Dropping  the Check contraint on WFCommentsTable created through upgrade_10_3_SP2.sql*/
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('WFCOMMENTS_USER_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		--v_IsConstraintUpdated := 0;
		--v_SearchConditionOld := 'CommentsType IN (1, 2, 3,4)';
		--v_SearchConditionNew := 'CommentsType IN (1, 2, 3, 4,5)';
		
		IF (existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table WFCOMMENTS_USER_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_USER_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsTable'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_USER_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsTable'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM WFCOMMENTS_USER_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''COMMENTSTYPE%'''; 
		BEGIN
				OPEN Cursor1 FOR v_STR1;
				LOOP
					FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
					EXIT WHEN Cursor1%NOTFOUND;
					IF v_SearchCondition IS NOT NULL THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable DROP CONSTRAINT ' || v_constraintName;
					END IF;
				END LOOP;
				CLOSE Cursor1;
			END;
			EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1,2,3,4,5,6,7,8,9,10))';
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
		CLOSE Cursor1;
		raise_application_error(-20364, 'Modifying the Check contraint on WFCommentsTable Failed.');
	END;
	
  
  
  		/* Creating WFCommentsHistoryTable table*/
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFCommentsHistoryTable');
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE
				'CREATE TABLE WFCommentsHistoryTable(
					CommentsId			INT					PRIMARY KEY,
					ProcessDefId 		INT					NOT NULL,
					ActivityId 			INT					NOT NULL,
					ProcessInstanceId 	NVARCHAR2(64)		NOT NULL,
					WorkItemId 			INT					NOT NULL,
					CommentsBy			INT					NOT NULL,
					CommentsByName		NVARCHAR2(64)		NOT NULL,
					CommentsTo			INT					NOT NULL,
					CommentsToName		NVARCHAR2(64)		NOT NULL,
					Comments			NVARCHAR2(1000)		NULL,
					ActionDateTime		DATE				NOT NULL,
					CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3, 4,5,6)),
					ProcessVariantId 	INT 				DEFAULT(0) NOT NULL
				)';
			END;
		END;

	existsFlag := 0;
	/* Dropping  the Check contraint on WFCommentsHistoryTable created through upgrade_10_3_SP2.sql*/	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('WFCOMMENTS_HISTORY_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		IF (existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table WFCOMMENTS_HISTORY_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_HISTORY_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsHistoryTable'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_HISTORY_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsHistoryTable'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM WFCOMMENTS_HISTORY_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''COMMENTSTYPE%'''; 
		BEGIN
				OPEN Cursor1 FOR v_STR1;
				LOOP
					FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
					EXIT WHEN Cursor1%NOTFOUND;
					IF v_SearchCondition IS NOT NULL THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsHistoryTable DROP CONSTRAINT ' || v_constraintName;
					END IF;
				END LOOP;
				CLOSE Cursor1;
			END;
			EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsHistoryTable ADD CHECK(CommentsType IN (1,2,3,4,5,6,7,8,9,10))';
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
		CLOSE Cursor1;
		raise_application_error(-20364, 'Modifying the Check contraint on WFCommentsHistoryTable Failed.');
	END;
/*Adding ProcessVariantId to WFCOmmentsHistoryTable and updating value of CommentType from 4 to 6 , if table exists and column does not existade Case[OF Upgrade from Omniflow*/	
	existsFlag :=0;	
	BEGIN
		SELECT Count(1) INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFCommentsHistoryTable');
		IF(existsFlag=1) THEN
		BEGIN
			existsFlag :=0;	
			SELECT Count(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFCommentsHistoryTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
			IF(existsFlag=0) THEN
			BEGIN
				EXECUTE IMMEDIATE 'Update WFCommentsTable Set CommentsType = 6 Where CommentsType = 4';
				EXECUTE IMMEDIATE 'Update WFCommentsHistoryTable Set CommentsType = 6 Where CommentsType = 4';
				EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsHistoryTable ADD ProcessVariantId INT DEFAULT 0';
			END;
			END IF;
		END;
		END IF;
	END;
		
/*Adding ProcessVariantId to WFReportDataHistoryTable, if table exists and column does not exist*/	
	existsFlag :=0;	
	BEGIN
		SELECT Count(1) INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFReportDataHistoryTable');
		IF(existsFlag=1) THEN
		BEGIN
			existsFlag :=0;	
			SELECT Count(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFReportDataHistoryTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
			IF(existsFlag=0) THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFReportDataHistoryTable ADD ProcessVariantId INT DEFAULT 0';
			END;
			END IF;
		END;
		END IF;
	END;	
	
		BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME = UPPER('PSREGISTERATIONTABLE') 
				AND 
				COLUMN_NAME = UPPER('BulkPS');
				EXCEPTION
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PSREGISTERATIONTABLE Add BulkPS  NVARCHAR2(1)';			
					dbms_output.put_line ('BulkPS column added in Table PSREGISTERATIONTABLE ');
		END;     
	
/*Queeu Variabel Exntesion Work*/	
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFINSTRUMENTTABLE') and upper(column_name) = upper('VAR_STR9');
		Exception when no_data_found then 
			Execute Immediate 'ALTER TABLE WFINSTRUMENTTABLE ADD (VAR_DATE5 DATE, VAR_DATE6 DATE, VAR_LONG5 INT, VAR_LONG6 INT, 
		VAR_STR9 NVARCHAR2(512), VAR_STR10 NVARCHAR2(512), VAR_STR11 NVARCHAR2(512), VAR_STR12 NVARCHAR2(512), VAR_STR13 NVARCHAR2(512), VAR_STR14 NVARCHAR2(512), VAR_STR15 NVARCHAR2(512), VAR_STR16 NVARCHAR2(512), VAR_STR17 NVARCHAR2(512), VAR_STR18 NVARCHAR2(512), VAR_STR19 NVARCHAR2(512), VAR_STR20 NVARCHAR2(512))';
	END;
	
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('VAR_STR9');
		Exception when no_data_found then 
			Execute Immediate 'ALTER TABLE QUEUEHISTORYTABLE ADD (VAR_DATE5 DATE, VAR_DATE6 DATE, VAR_LONG5 INT, VAR_LONG6 INT, 
		VAR_STR9 NVARCHAR2(512), VAR_STR10 NVARCHAR2(512), VAR_STR11 NVARCHAR2(512), VAR_STR12 NVARCHAR2(512), VAR_STR13 NVARCHAR2(512), VAR_STR14 NVARCHAR2(512), VAR_STR15 NVARCHAR2(512), VAR_STR16 NVARCHAR2(512), VAR_STR17 NVARCHAR2(512), VAR_STR18 NVARCHAR2(512), VAR_STR19 NVARCHAR2(512), VAR_STR20 NVARCHAR2(512))';
	END;
	
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('GTEMPWORKLISTTABLE') and upper(column_name) = upper('VAR_STR9');
		Exception when no_data_found then 
			Execute Immediate 'ALTER TABLE GTEMPWORKLISTTABLE ADD (VAR_DATE5 DATE, VAR_DATE6 DATE, VAR_LONG5 INT, VAR_LONG6 INT, 
		VAR_STR9 NVARCHAR2(512), VAR_STR10 NVARCHAR2(512), VAR_STR11 NVARCHAR2(512), VAR_STR12 NVARCHAR2(512), VAR_STR13 NVARCHAR2(512), VAR_STR14 NVARCHAR2(512), VAR_STR15 NVARCHAR2(512), VAR_STR16 NVARCHAR2(512), VAR_STR17 NVARCHAR2(512), VAR_STR18 NVARCHAR2(512), VAR_STR19 NVARCHAR2(512), VAR_STR20 NVARCHAR2(512))';
	END;
	
	
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('GTempSearchTable') and upper(column_name) = upper('VAR_STR9');
		Exception when no_data_found then 
			Execute Immediate 'ALTER TABLE GTempSearchTable ADD (VAR_DATE5 DATE, VAR_DATE6 DATE, VAR_LONG5 INT, VAR_LONG6 INT, 
		VAR_STR9 VARCHAR2(512), VAR_STR10 NVARCHAR2(512), VAR_STR11 NVARCHAR2(512), VAR_STR12 NVARCHAR2(512), VAR_STR13 NVARCHAR2(512), VAR_STR14 NVARCHAR2(512), VAR_STR15 NVARCHAR2(512), VAR_STR16 NVARCHAR2(512), VAR_STR17 NVARCHAR2(512), VAR_STR18 NVARCHAR2(512), VAR_STR19 NVARCHAR2(512), VAR_STR20 NVARCHAR2(512))';
	END;
	
	--Adding extra columns to QUEUEHISTORYTABLE for Transfer History work
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('ChildProcessInstanceId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD ChildProcessInstanceId  NVARCHAR2(63) NULL');
	END;
	
	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('ChildWorkitemId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD ChildWorkitemId			INT ');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('FilterValue');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD FilterValue					INT		NULL');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('Guid');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD Guid 						NUMBER');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('NotifyStatus');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD NotifyStatus				NVARCHAR2(1)');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('Q_DivertedByUserId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD Q_DivertedByUserId   		INT');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('RoutingStatus');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD RoutingStatus				NVARCHAR2(1) ');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('NoOfCollectedInstances');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD NoOfCollectedInstances		INT DEFAULT 0');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('IsPrimaryCollected');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD IsPrimaryCollected		NVARCHAR2(1) NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('INTRODUCEDBYID');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD Introducedbyid				INT		NULL');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('INTRODUCEDAT');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD IntroducedAt				NVARCHAR2(30)');
	END;

	BEGIN
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('CREATEDBY');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE QueueHistoryTable ADD Createdby					INT	');
	END;


	--Added extra columns in QUEUEHISTORYTABLE till here
	
	--Adding new history tables for Transfer history task
	
	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTASKSTATUSHISTORYTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE (
				'CREATE TABLE WFTASKSTATUSHISTORYTABLE(
					ProcessInstanceId NVarchar2(63) NOT NULL,
					WorkItemId INT NOT NULL,
					ProcessDefId INT NOT NULL,
					ActivityId INT NOT NULL,
					TaskId  Integer NOT NULL,
					SubTaskId  Integer NOT NULL,
					TaskStatus integer NOT NULL,
					AssignedBy Nvarchar2(63) NOT NULL,
					AssignedTo Nvarchar2(63) ,
					Instructions NVARCHAR2(2000) NULL,
					ActionDateTime DATE NOT NULL,
					DueDate DATE,
					Priority  INT,
					ShowCaseVisual	NVARCHAR2(1) NOT NULL,
					ReadFlag NVARCHAR2(1) NOT NULL,
					CanInitiate	NVARCHAR2(1) NOT NULL,	
					Q_DivertedByUserId INT DEFAULT 0,
					CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId))'
				);
				dbms_output.put_line ('Table WFTASKSTATUSHISTORYTABLE Created successfully');

	END;
	
	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRTTASKINTFCASSOCHISTORY');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE (
				'create table WFRTTASKINTFCASSOCHISTORY (
				ProcessInstanceId NVarchar2(63) NOT NULL,
				WorkItemId  INT NOT NULL,
				ProcessDefId INT  NOT NULL, 
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL, 
				InterfaceId Integer NOT NULL, 
				InterfaceType NCHAR(1) NOT NULL,
				Attribute NVarchar2(2) )'
				);
				dbms_output.put_line ('Table WFRTTASKINTFCASSOCHISTORY Created successfully');

	END;

	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('RTACTIVITYINTFCASSOCHISTORY');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE (
				'CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
					ProcessInstanceId NVarchar2(63) NOT NULL,
					WorkItemId                INT NOT NULL,
					ProcessDefId             INT		NOT NULL,
					ActivityId              INT             NOT NULL,
					ActivityName            NVARCHAR2(30)    NOT NULL,
					InterfaceElementId      INT             NOT NULL,
					InterfaceType           NVARCHAR2(1)     NOT NULL,
					Attribute               NVARCHAR2(2)     NULL,
					TriggerName             NVARCHAR2(255)   NULL,
					ProcessVariantId 		INT 			DEFAULT 0 NOT NULL )'
				);
				dbms_output.put_line ('Table RTACTIVITYINTFCASSOCHISTORY Created successfully');

	END;

	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFREPORTDATAHISTORYTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE (
				'CREATE TABLE WFREPORTDATAHISTORYTABLE(
					ProcessInstanceId    Nvarchar2(63),
					WorkitemId           Integer,
					ProcessDefId         Integer Not Null,
					ActivityId           Integer,
					UserId               Integer,
					TotalProcessingTime  Integer,
					ProcessVariantId 	 INT Default(0) NOT NULL
					)'
				);
				dbms_output.put_line ('Table WFREPORTDATAHISTORYTABLE Created successfully');

	END;
	
/*Adding ProcessVariantId to WFATTRIBUTEMESSAGEHISTORYTABLE , if table exists and column does not existade Case[OF Upgrade from Omniflow*/	
	existsFlag :=0;	
	BEGIN
		SELECT Count(1) INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFATTRIBUTEMESSAGEHISTORYTABLE');
		IF(existsFlag=1) THEN
		BEGIN
			existsFlag :=0;	
			SELECT Count(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFATTRIBUTEMESSAGEHISTORYTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
			IF(existsFlag=0) THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ADD ProcessVariantId INT DEFAULT 0';
			END;
			END IF;
		END;
		END IF;
	END;
		

	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFATTRIBUTEMESSAGEHISTORYTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE (
				'CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ( 
					ProcessDefID		INT		NOT NULL,
					ProcessVariantId 	INT DEFAULT(0)  NOT NULL ,
					ProcessInstanceID	NVARCHAR2 (63)  NOT NULL ,
					WorkitemId		    INTEGER		NOT NULL,
					MESSAGEID		    INTEGER         NOT NULL, 
					MESSAGE			    CLOB            NOT NULL, 
					LOCKEDBY		    NVARCHAR2(63), 
					STATUS			    NVARCHAR2(1) , 
					ActionDateTime		DATE,  
					CONSTRAINT chk_status_attribHist CHECK (status in (N''N'', N''F'')),
					CONSTRAINT PK_WFATTRIBUTEMESSAGETABLEHist PRIMARY KEY (MESSAGEID ) )'
				);
				dbms_output.put_line ('Table WFATTRIBUTEMESSAGEHISTORYTABLE Created successfully');
	END;
	
	--Added new history tables till here
	
	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW QUEUETABLE 
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
		FROM	WFINSTRUMENTTABLE';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW QUEUEVIEW 
		AS 
		SELECT * FROM QUEUETABLE	
		UNION ALL	
		SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME,	ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, 	QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME,CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,  VAR_LONG5, VAR_LONG6,VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE';	
	END;
	
	
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('Var_Str9');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT QueueExtension;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values('||To_Char(v_ProcessDefId)|| '	, 10006, ''VAR_DATE5'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')';

				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values('||To_Char(v_ProcessDefId)|| ', 10007, ''VAR_DATE6'', '''', 8, ''U'', 0, '''', NULL, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values('||To_Char(v_ProcessDefId)|| ', 10008, ''VAR_LONG5'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values('||To_Char(v_ProcessDefId)|| ', 10009, ''VAR_LONG6'', '''', 4, ''U'', 0, '''', NULL, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10010, ''VAR_STR9'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10011, ''VAR_STR10'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10012, ''VAR_STR11'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10013, ''VAR_STR12'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10014, ''VAR_STR13'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10015, ''VAR_STR14'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10016, ''VAR_STR15'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10017, ''VAR_STR16'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10018, ''VAR_STR17'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10019, ''VAR_STR18'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10020, ''VAR_STR19'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';

				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded) 
				values(' ||To_Char(v_ProcessDefId)|| ', 10021, ''VAR_STR20'', '''', 10, ''U'', 0, '''', 255, 0, ''N'')';
				
				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT QueueExtension;
		CLOSE Cursor1;
	END;
	END IF;
	
	/* Transfering these alter quries to separate script*/
	
	/*
	BEGIN
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR1 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR2 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR3 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR4 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR5 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR6 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR7 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY VAR_STR8 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE QUEUEHISTORYTABLE MODIFY Status nvarchar2(255)');
		
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR1 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR2 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR3 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR4 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR5 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR6 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR7 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTEMPWORKLISTTABLE MODIFY VAR_STR8 nvarchar2(512)');
		
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR1 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR2 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR3 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR4 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR5 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR6 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR7 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE GTempSearchTable MODIFY VAR_STR8 nvarchar2(512)');
		
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR1 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR2 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR3 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR4 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR5 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR6 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR7 nvarchar2(512)');
		EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE MODIFY VAR_STR8 nvarchar2(512)');
		
	END;
	*/
	
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('VarAliasTable') AND COLUMN_NAME=UPPER('DisplayFlag');
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		BEGIN
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD (DisplayFlag NVARCHAR2(1), SortFlag NVARCHAR2(1), SearchFlag NVARCHAR2(1))';
			EXECUTE IMMEDIATE 'UPDATE VarAliasTable SET DisplayFlag = ''Y'', SortFlag = ''Y'', SearchFlag = ''Y''';
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable MODIFY (DisplayFlag NVARCHAR2(1) NOT NULL, SortFlag NVARCHAR2(1) NOT NULL, SearchFlag NVARCHAR2(1) NOT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD (CONSTRAINT CK_DisplayFlag CHECK (DisplayFlag = N''Y'' OR DisplayFlag = N''N''), CONSTRAINT CK_SortFlag CHECK (SortFlag = N''Y'' OR SortFlag = N''N''), CONSTRAINT CK_SearchFlag CHECK (SearchFlag = N''Y'' OR SearchFlag = N''N''))';
		END;
	END;
	/*Queeu Variabel Exntesion Work Ends*/
	
/*Deassocaition of User  from System Queues and aggregations of worktiems and queues to SystemPFE and System Archieve */	
	BEGIN
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A'  AND QueueName =  'SystemPFEQueue';
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount > 0) THEN --If SystemPFEQueue queue exists then Deassocaite this queue from WFUserObjAssocTable 
	BEGIN
		SAVEPOINT WSInvoker;
			EXECUTE IMMEDIATE 'Delete from WFUserObjAssocTable Where  ObjectTypeId = 2 and ObjectId  = '||v_QueueId ;--ObjectTypeId = 2 ; Queue
			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 10 And ActivitySubType = 1';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

				EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemPFEQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT WSInvoker;
		CLOSE Cursor1;
	END;
	END IF;
	
/*Deassocaition of User  from SystemArchiveQueue and aggregations of worktiems and queues to SystemPFE and System Archieve */	
	BEGIN
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A'  AND QueueName =  'SystemArchiveQueue';
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount > 0) THEN --If SystemArchiveQueue queue exists then Deassocaite this queue from WFUserObjAssocTable 
	BEGIN
		SAVEPOINT WSInvoker;
			EXECUTE IMMEDIATE 'Delete from WFUserObjAssocTable Where  ObjectTypeId = 2 and ObjectId  = '||v_QueueId ;--ObjectTypeId = 2 ; Queue
			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 10 And ActivitySubType = 4';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

				EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemArchiveQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT WSInvoker;
		CLOSE Cursor1;
	END;
	END IF;	
	
	
	/*Sysytem Queuue Creation and assocaition*/
	/* Adding WebService Queue, QueueType A*/
	BEGIN
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemWSQueue';
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT WSInvoker;
			SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
			EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemWSQueue'',''A'',''System generated common WebService Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for WebServiceInvoker Utility is added successfully');

			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 22';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

				EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT WSInvoker;
		CLOSE Cursor1;
	END;
	END IF;
	
	
	/* Adding SAP Queue, QueueType A*/
	BEGIN
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemSAPQueue';
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT SAPInvoker;
		SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
		EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemSAPQueue'',''A'',''System generated common SAP Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
		DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for SAPInvoker Utility is added successfully');

		v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 29';
		OPEN Cursor1 FOR v_queryStr;
		LOOP
			FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
			EXIT WHEN Cursor1%NOTFOUND;

			EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

			EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemSAPQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';
			
		END LOOP;
		CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT SAPInvoker;
		CLOSE Cursor1;
	END;
	END IF;
	
	/* Adding BRMS Queue, QueueType A*/
	BEGIN
		SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemBRMSQueue';
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT WSInvoker;
			SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
			EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemBRMSQueue'',''A'',''System generated common BRMS Queue'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for WebServiceInvoker Utility is added successfully');

			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 31';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

				EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT WSInvoker;
		CLOSE Cursor1;
	END;
	END IF;
	
	

	/* Adding FailRecords column in WFImportFileData table*/
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFImportFileData') AND COLUMN_NAME = UPPER('FailRecords');
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'UPDATE WFImportFileData SET FileStatus = ''S'' WHERE FileStatus = ''I''';
		EXECUTE IMMEDIATE 'ALTER TABLE WFImportFileData ADD FailRecords INT DEFAULT 0';
		EXECUTE IMMEDIATE 'UPDATE WFImportFileData SET FailRecords = 0';
		DBMS_OUTPUT.PUT_LINE('Table WFImportFileData altered with new Column FailRecords');
	END;		
			
			
	/* Creating WFFailFileRecords table*/
	/* Creating WFFailFileRecords table*/
	existsFlag := 0;
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFFailFileRecords');
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'CREATE TABLE WFFailFileRecords (
					FailRecordId INT NOT NULL,
					FileIndex INT,
					RecordNo INT,
					RecordData NVARCHAR2(2000),
					Message NVARCHAR2(1000),
					EntryTime TIMESTAMP DEFAULT SYSDATE
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFFailFileRecords Created successfully');
			
				BEGIN
					SELECT LAST_NUMBER INTO v_lastSeqValue
					FROM USER_SEQUENCES
					WHERE SEQUENCE_NAME = UPPER('WFFailFileRecords_SEQ');
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							EXECUTE IMMEDIATE 'CREATE SEQUENCE WFFailFileRecords_SEQ';
							dbms_output.put_line ('Sequence WFFailFileRecords_SEQ Created successfully');
				END;
				
				EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WFFailFileRecords_TRG BEFORE INSERT ON WFFailFileRecords FOR EACH ROW BEGIN SELECT WFFailFileRecords_SEQ.NEXTVAL INTO :NEW.FailRecordId FROM DUAL; END;';
				DBMS_OUTPUT.PUT_LINE('Trigger WFFailFileRecords_TRG Created successfully');
			END;
		END;
	END;
	
/*Seq_rootlogid changes*/
	    v_rootLogId:=0;
		v_lastSeqValue:=0;
		EXECUTE IMMEDIATE ' SELECT * FROM (SELECT logid FROM WFCURRENTROUTELOGTABLE  ORDER BY logid DESC) WHERE ROWNUM = 1 ' INTO v_rootLogId;
		v_rootLogId:=v_rootLogId+1;
		BEGIN	
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE Upper(SEQUENCE_NAME) = UPPER('seq_rootlogid');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_rootlogid START WITH '|| v_rootLogId||' INCREMENT BY 1 NOCACHE';
				dbms_output.put_line ('Sequence seq_rootlogid Created successfully');
		END;		
	
		IF(v_lastSeqValue!=0) THEN --seq_rootlogid exists but value conflicts
			EXECUTE IMMEDIATE 'DROP SEQUENCE seq_rootlogid';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_rootlogid START WITH '|| v_rootLogId||' INCREMENT BY 1 NOCACHE';
			dbms_output.put_line ('Sequence seq_rootlogid Created successfully');
		END IF;
		
				
		EXECUTE IMMEDIATE'CREATE OR REPLACE TRIGGER WF_LOG_ID_TRIGGER BEFORE INSERT  ON WFCURRENTROUTELOGTABLE FOR EACH ROW 	 
						BEGIN 		
							SELECT seq_rootlogid.nextval INTO :new.LOGID FROM dual;
						END;';	
	

/*Updating default value for variable length and variable precision*/		
	UPDATE Varmappingtable set variablelength=255 where variablescope='U' and VariableType=10 and userdefinedname is not NULL  and variablelength is NULL;
	UPDATE Varmappingtable set variablelength=15,VarPrecision=2 where variablescope='U' and VariableType=6 and userdefinedname is not NULL  and variablelength is NULL;
	UPDATE Varmappingtable set variablelength=2 where variablescope='U' and VariableType=3 and userdefinedname is not NULL  and variablelength is NULL;
	UPDATE Varmappingtable set variablelength=4 where variablescope='U' and VariableType=4 and userdefinedname is not NULL  and variablelength is NULL;
	UPDATE Varmappingtable set variablelength=8 where variablescope='U' and VariableType=8 and userdefinedname is not NULL  and variablelength is NULL;
	
/* Modifiying   the Check contraint on EXTMETHODDEFTABLE*/

		BEGIN
			SAVEPOINT ModifyCheckConstraint;
			v_IsConstraintUpdated := 0;
			v_SearchConditionOld := 'ExtAppType in (N''E'', N''W'', N''S'', N''Z'')';
			v_SearchConditionNew := 'ExtAppType in (N''E'', N''W'', N''S'', N''Z'',N''B'')';
			DECLARE CURSOR Cursor1 IS SELECT constraint_name, search_condition FROM user_constraints WHERE table_name = UPPER('EXTMETHODDEFTABLE') AND constraint_type = 'C';
			BEGIN
				OPEN Cursor1;
				LOOP
					FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
					EXIT WHEN Cursor1%NOTFOUND;
					IF (v_SearchCondition IS NOT NULL) THEN
					BEGIN
						IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionOld) THEN
							EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || v_constraintName;
						END IF;
						IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionNew) THEN
							v_IsConstraintUpdated := 1;
						END IF;
					END;	
					END IF;
				END LOOP;
				CLOSE Cursor1;
			END;
			IF v_IsConstraintUpdated = 0 THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE ADD CHECK(ExtAppType in (N''E'', N''W'', N''S'', N''Z'',N''B'',N''R''))';
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
			CLOSE Cursor1;
		END;
		
	
		--EXECUTE IMMEDIATE 'TRUNCATE TABLE WFMAILQUEUEHISTORYTABLE';
/*Dropping Extra columns from WFmessageTable, WFMessageInPorcessTable and WFFailedMessageTable which is not required in SP1*/
	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMESSAGETABLE') 
			AND COLUMN_NAME = UPPER('ProcessInstanceId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGETABLE DROP COLUMN ProcessInstanceId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;

	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMessageInProcessTable') 
			AND COLUMN_NAME = UPPER('ProcessInstanceId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageInProcessTable DROP COLUMN ProcessInstanceId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;	

	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFFailedMessageTable') 
			AND COLUMN_NAME = UPPER('ProcessInstanceId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFFailedMessageTable DROP COLUMN ProcessInstanceId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessInstanceId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;		
	
	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMESSAGETABLE') 
			AND COLUMN_NAME = UPPER('ActionId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGETABLE DROP COLUMN ActionId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;
	
	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMessageInProcessTable') 
			AND COLUMN_NAME = UPPER('ActionId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageInProcessTable DROP COLUMN ActionId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;
	
	existsFlag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFFailedMessageTable') 
			AND COLUMN_NAME = UPPER('ActionId');
			EXECUTE IMMEDIATE 'ALTER TABLE WFFailedMessageTable DROP COLUMN ActionId ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActionId Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;
		
/*Making entry in WFCabVersionTable for iBPS_3.0_SP1*/	
	existsFlag :=0;	
	BEGIN
		 SELECT Count(1) INTO existsFlag FROM WFCabVersionTable WHERE UPPER(cabVersion) = UPPER('iBPS_3.0_SP1');
		 If(existsFlag=0) THEN
		 BEGIN
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.0_SP1', cabVersionId.nextVal, SYSDATE, SYSDATE, N'iBPS_3.0_SP1', N'Y');
		 END;
		 END IF;
	END;
			
		
END;
~
call Upgrade()

~

DROP PROCEDURE Upgrade

~
