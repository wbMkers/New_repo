	/*_____________________________________________________________________________________________________________________-
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED

		Group						: Genesis_iBPS
		Product / Project			: WorkFlow
		Module						: iBPS_Server
		File NAME					: Upgrade.sql (MS Sql Server)
		Author						: Kumar Kimil
		Date written (DD/MM/YYYY)	: 18-07-2017
		Description					: 
	_______________________________________________________________________________________________________________________-
				CHANGE HISTORY
	_______________________________________________________________________________________________________________________-
	Date			Change By			Change Description (Bug No. (If Any))
	06/07/2017		Ambuj Tripathi  	Added changes for the case management (WFReassignTask API)
18/07/2017      Kumar Kimil     	Multiple Precondition enhancement
24/07/2017		Shubhankur Manuja	Modifying the Check constraint on WFCommentsTable for storing decline comments
01/08/2017     Kumar Kimil        Multiple Precondition enhancement(Review Changes)
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous)
21/08/2017		Ambuj Tripathi  Added changes for the Task Escalation in WFEscInProcessTable table
22/08/2017		Ambuj Tripathi  Added columns in the wftaskstatushistorytable
25/08/2017		Ambuj Tripathi  Added Table WFTaskUserAssocTable for UserGroup feature in case Management
29/08/2017		Ambuj Tripathi  Added Table changes in WFTaskstatustable for task approval feature.
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
27/09/2017      Ambuj Tripathi  Changes for Bug#71671 in WFEventDetailsTable
04/10/2017      Ambuj Tripathi  Changes done for UT Bug fixes
04/10/2017      Ambuj Tripathi  Changes done for Bug 72218 - EAp 6.2+SQl:- Task Preferences functionality not working.
//05/10/2017	Ambuj Tripathi  Bug 72105-Specification issue While revoking a task, it doesn't ask for any confirmation. Added CommentsType as 10
09/10/2017      Ambuj Tripathi  Bug 72452 - Removed the primary key from WFTaskUserAssocTable
13/09/2017		Ambuj Tripathi	Case registeration Name changes requirement- Columns added in processdeftable and wfinstrumenttable
01/11/2017		Ambuj Tripathi	Bug 73125 Getting unnecessary error message while un-registering server, Commented insert into Currentroutelogtable line.
15/11/2017      Kumar Kimil     Bug 73545 - Upgrade from OF 10.3 SP-2 to iBPS 3.2 +EAP+SQL: Associated NGF Form & iform is not showing in workitem
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
16/11/2017		Ambuj Tripathi	Bug 73581 - Upgrade from iBPS 3.0 SP-1+WAS+SQL to iBPS 3.2: Getting error in file WFGenerateREgistration.sql if upgrade cabinet 
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
28/11/2017      Bug 73680 - Jboss EAP 6.4 + Postgres +SSL :-On Clicking on Initiate in Linked Sub Process Getting Error"You have been logged out from IBPS.""
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
20/04/2018      Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
22/04/2018  	Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
14/05/2018	Ambuj Tripathi	Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
23/08/2018	AMbuj Tripathi	Bug fix in LIC POC - UserCreation script was failing in case of Cab Upgrade from OD to OD+IBPS
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
___________________________________________________-*/


CREATE OR REPLACE FUNCTION WFUtilUnregister() RETURNS TRIGGER AS $$
DECLARE 
	PSName VARCHAR(100);
	PSData VARCHAR(50);
	v_userName VARCHAR(100);
BEGIN
		PSName := OLD.PSName;
		PSData := OLD.Data;
		IF (PSData = 'PROCESS SERVER') THEN
		BEGIN				
			Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null, LockedByName = null , LockStatus = 'N', LockedTime = null where LockedByName = PSName and LockStatus = 'Y' and RoutingStatus = 'Y';
		END;
		END IF;
		IF (PSData = 'MAILING AGENT') THEN
		BEGIN
			UPDATE WFMailQueueTable SET MailStatus = 'N', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = PSName;
		END;
		END IF;
		IF (PSData = 'MESSAGE AGENT') THEN
		BEGIN
			UPDATE WFMessageTable SET LockedBy = null, Status = 'N' where LockedBy = PSName;
		END;
		END IF;
		IF (PSData = 'PRINT,FAX & EMAIL' OR PSData = 'ARCHIVE UTILITY') THEN
		BEGIN
			Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null , LockedByName = null , LockStatus = 'N', LockedTime = null 
			 where  LockedByName = PSName and LockStatus = 'Y'  and RoutingStatus = 'N';
		END;
		END IF;
		/*Bug 73125 - Getting unnecessary error message while un-registering server	
		*
		SELECT INTO v_userName userName FROM pdbuser WHERE userindex = OLD.userindex; 
		INSERT into WFCURRENTROUTELOGTABLE (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName)VALUES(0, 0, NULL, 0, OLD.userindex, 24, CURRENT_TIMESTAMP, OLD.userindex, v_userName, NULL, v_userName); 
		*/
		RETURN NULL;
END;
$$LANGUAGE plpgsql;

~

CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE 
v_QueryStr        	VARCHAR(8000);
v_STR1        		VARCHAR(8000);
v_constraintName  	VARCHAR(160);
v_constraintName2  	VARCHAR(160);
Cursor1 			REFCURSOR;
adhocTaskCursor		REFCURSOR;
v_tableName			VARCHAR(512);
v_ProcessDefId		INTEGER;
existflag			INTEGER;
BEGIN
		
	 
		/* Adding changes into tables for Case Management Tasks */
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('LockStatus');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusTable ADD LockStatus VARCHAR(1) DEFAULT ''N'' NOT NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('InitiatedBy');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusTable ADD InitiatedBy VARCHAR(63) NULL');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('TaskEntryDateTime');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusTable ADD TaskEntryDateTime TIMESTAMP NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('ValidTill');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusTable ADD ValidTill TIMESTAMP NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('LockStatus');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusHistoryTable ADD LockStatus VARCHAR(1) DEFAULT ''N'' NOT NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('InitiatedBy');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusHistoryTable ADD InitiatedBy VARCHAR(63) NULL');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('TaskEntryDateTime');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusHistoryTable ADD TaskEntryDateTime TIMESTAMP NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('ValidTill');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WFTaskStatusHistoryTable ADD ValidTill TIMESTAMP NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFCommentsTable') and UPPER(column_name)=UPPER('TaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFCommentsTable add TaskId INTEGER DEFAULT 0 NOT NULL');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFCommentsTable') and UPPER(column_name)=UPPER('SubTaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFCommentsTable add SubTaskId INTEGER DEFAULT 0 NOT NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFCommentsHistoryTable') and UPPER(column_name)=UPPER('TaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFCommentsHistoryTable add TaskId INTEGER DEFAULT 0 NOT NULL');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFCommentsHistoryTable') and UPPER(column_name)=UPPER('SubTaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFCommentsHistoryTable add SubTaskId INTEGER DEFAULT 0 NOT NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('DOCUMENTTYPEDEFTABLE') and UPPER(column_name)=UPPER('DocType');
			IF(NOT FOUND) THEN 
				Execute ('alter table DOCUMENTTYPEDEFTABLE add DocType VARCHAR(1)		NOT NULL DEFAULT ''D''');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('ACTIVITYTABLE') and UPPER(column_name)=UPPER('GenerateCaseDoc');
			IF(NOT FOUND) THEN 
				Execute ('alter table ACTIVITYTABLE add GenerateCaseDoc	varchar(1) NOT NULL DEFAULT N''N''');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFEscalationTable') and UPPER(column_name)=UPPER('TaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFEscalationTable add TaskId INTEGER NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFLinkstable') and UPPER(column_name)=UPPER('TaskId');
			IF(NOT FOUND) THEN 
				Execute ('ALTER table WFLinkstable add TaskId integer not  null default 0');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WfTaskDefTable') and UPPER(column_name)=UPPER('TaskMode');
			IF(NOT FOUND) THEN 
				Execute ('Alter table WfTaskDefTable Add TaskMode Varchar(1)');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFEscInProcessTable') and UPPER(column_name)=UPPER('TaskId');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFEscInProcessTable add TaskId INTEGER NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('ApprovalRequired');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFTaskStatusTable add ApprovalRequired Varchar(1) NOT NULL DEFAULT N''N''');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('ApprovalSentBy');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFTaskStatusTable add ApprovalSentBy VARCHAR(63) NULL');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('ApprovalRequired');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFTaskStatusHistoryTable add ApprovalRequired Varchar(1) NOT NULL DEFAULT N''N''');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('ApprovalSentBy');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFTaskStatusHistoryTable add ApprovalSentBy VARCHAR(63) NULL');
			END IF;

			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('ACTIVITYTABLE') and UPPER(column_name)=UPPER('DoctypeId');
			IF(NOT FOUND) THEN 
				Execute ('alter table ACTIVITYTABLE add DoctypeId INT NOT NULL DEFAULT -1');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFTaskDefTable') and UPPER(column_name)=UPPER('UseSeparateTable');
			IF(NOT FOUND) THEN 
				Execute ('alter table WFTaskDefTable add UseSeparateTable Varchar(1) NOT NULL DEFAULT N''Y''');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFForm_table') and UPPER(column_name)=UPPER('FormType');
			IF(NOT FOUND) THEN 
				EXECUTE  ('alter table WFForm_table add FormType varchar(1) default ''P'' not null ');
			END IF;
			
			existflag := 0;
			SELECT 1 INTO existflag
			FROM information_schema.columns  
			WHERE UPPER(table_name) = UPPER('WFWebServiceTable') and UPPER(column_name)=UPPER('OrderId');
			IF(NOT FOUND) THEN 
				EXECUTE  ('alter table WFWebServiceTable add OrderId INT NOT null DEFAULT 1 ');
			END IF;
			
			EXECUTE 'select constraint_name from information_schema.table_constraints where UPPER(table_name)=UPPER(''WFWebServiceTable'') and constraint_type=''PRIMARY KEY''' INTO v_constraintName2;
			EXECUTE 'ALTER TABLE WFWebServiceTable DROP CONSTRAINT '||v_constraintName2;	
			EXECUTE 'ALTER TABLE WFWebServiceTable ADD CONSTRAINT '|| v_constraintName2 || ' PRIMARY KEY (ProcessDefId, ActivityId, ExtMethodIndex)';
			
			/* Adding changes into tables for Case Management Tasks */
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskruleOperationTable');
			IF (NOT FOUND) THEN
				Execute 'create table WFTaskruleOperationTable(
							ProcessDefId     INT    NOT NULL,
							ActivityId     INT     NOT NULL, 
							TaskId     INT     NOT NULL, 
							RuleId     SMALLINT     NOT NULL, 
							OperationType     SMALLINT     NOT NULL, 
							Param1 varchar(255) NOT NULL,
							Type1 varchar(1) NOT NULL,
							ExtObjID1 int  NULL,
							VariableId_1 int  NULL,
							VarFieldId_1 int  NULL,    
							Param2 varchar(255) NOT NULL,
							Type2 varchar(1) NOT NULL,
							ExtObjID2 int  NULL,
							VariableId_2 int  NULL,
							VarFieldId_2 int  NULL,
							Param3 varchar(255) NULL,
							Type3 varchar(1) NULL,
							ExtObjID3 int  NULL,
							VariableId_3 int  NULL,
							VarFieldId_3 int  NULL,    
							Operator     SMALLINT     NOT NULL, 
							AssignedTo    varchar(63),    
							OperationOrderId     SMALLINT     NOT NULL, 
							RuleCalFlag	varchar(1) NULL,
							CONSTRAINT pk_WFTaskruleOperationTable PRIMARY KEY  (ProcessDefId,ActivityId,TaskId,RuleId,OperationOrderId ) 
						 
						)';
			END IF;

			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskPropertyTable');
			IF (NOT FOUND) THEN
				Execute 'Create Table WFTaskPropertyTable(
							ProcessDefId integer NOT NULL,
							ActivityId INT NOT NULL ,
							TaskId  integer NOT NULL,
							DefaultStatus integer NOT NULL,
							AllowReassignment varchar(1),
							AllowDecline varchar(1),
							ApprovalRequired varchar(1),
							MandatoryText varchar(255),
							CONSTRAINT pk_WFTaskPropertyTable PRIMARY KEY  ( ProcessDefId,ActivityId ,TaskId)
							)';
			END IF;
			
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskPreConditionResultTable');
			IF (NOT FOUND) THEN
				Execute 'Create Table WFTaskPreConditionResultTable(
							ProcessInstanceId	varchar(63)  	NOT NULL ,
							WorkItemId 		INT 		NOT NULL ,
							ActivityId INT NOT NULL ,
							TaskId  integer NOT NULL,
							Ready Integer  null,
							Mandatory varchar(1),
							CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
							)';
			END IF;
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskPreCondResultHistory');
			IF (NOT FOUND) THEN
				Execute 'Create Table WFTaskPreCondResultHistory(
							ProcessInstanceId	varchar(63)  	NOT NULL ,
							WorkItemId 		INT 		NOT NULL ,
							ActivityId INT NOT NULL ,
							TaskId  integer NOT NULL,
							Ready Integer  null,
							Mandatory varchar(1),
							CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
							)';
			END IF;
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskPreCheckTable');
			IF (NOT FOUND) THEN
				Execute 'Create Table WFTaskPreCheckTable(
							ProcessInstanceId	varchar(63)  	NOT NULL ,
							WorkItemId 		INT 		NOT NULL ,
							ActivityId INT NOT NULL ,
							checkPreCondition varchar(1),
							CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
							)';
			END IF;
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskPreCheckHistory');
			IF (NOT FOUND) THEN
				Execute 'Create Table WFTaskPreCheckHistory(
							ProcessInstanceId	varchar(63)  	NOT NULL ,
							WorkItemId 		INT 		NOT NULL ,
							ActivityId INT NOT NULL ,
							checkPreCondition varchar(1),
							CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
							)';
			END IF;
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCaseSummaryDetailsTable');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFCaseSummaryDetailsTable(
					ProcessInstanceId VARCHAR(63) NOT NULL,
					WorkItemId INTEGER NOT NULL,
					ProcessDefId INTEGER NOT NULL,
					ActivityId INTEGER NOT NULL,
					ActivityName VARCHAR(30)    NOT NULL,
					Status INTEGER NOT NULL,
					NoOfRetries INTEGER NOT NULL,
					EntryDateTime 			TIMESTAMP	NOT	NULL ,
					LockedBy	VARCHAR(1000) NULL,
					CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
				)';
			END IF;
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCaseSummaryDetailsHistory');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFCaseSummaryDetailsHistory(
					ProcessInstanceId VARCHAR(63) NOT NULL,
					WorkItemId INTEGER NOT NULL,
					ProcessDefId INTEGER NOT NULL,
					ActivityId INTEGER NOT NULL,
					ActivityName VARCHAR(30)    NOT NULL,
					Status INTEGER NOT NULL,
					NoOfRetries INTEGER NOT NULL,
					EntryDateTime 			TIMESTAMP	NOT	NULL ,
					LockedBy	VARCHAR(1000) NULL,
					CONSTRAINT PK_WFCaseSummaryDetailsHistory PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
				)';
			END IF;
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFGenericServicesTable');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFGenericServicesTable	 (
				ServiceId  			INTEGER 				NOT NULL,
				GenServiceId		INTEGER					NOT NULL, 
				GenServiceName  		VARCHAR(50)		NULL, 
				GenServiceType  		VARCHAR(50)		NULL, 
				ProcessDefId 		INTEGER					NULL, 
				EnableLog  			VARCHAR(50)		NULL, 
				MonitorStatus 		VARCHAR(50)		NULL, 
				SleepTime  			INTEGER					NULL, 
				RegInfo   			TEXT				NULL,
				CONSTRAINT PK_WFGenericServicesTable PRIMARY KEY(ServiceId,GenServiceId)
			)';
			END IF;
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCaseDocStatusTable');
			IF (NOT FOUND) THEN
				Execute 'create table WFCaseDocStatusTable(
					ProcessInstanceId VARCHAR(63) NOT NULL,
					WorkItemId INTEGER NOT NULL,
					ProcessDefId INTEGER NOT NULL,
					ActivityId INTEGER NOT NULL,
					TaskId  INTEGER NOT NULL,
					SubTaskId  INTEGER NOT NULL,
					DocumentType VARCHAR(63)  NULL,
					DocumentIndex VARCHAR(63) NOT NULL,
					ISIndex VARCHAR(63) NOT NULL,
					CompleteStatus	VARCHAR(1) default ''N'' NOT NULL
				)';
			END IF;

			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCaseDocStatusHistory');
			IF (NOT FOUND) THEN
				Execute 'create table WFCaseDocStatusHistory(
					ProcessInstanceId VARCHAR(63) NOT NULL,
					WorkItemId INTEGER NOT NULL,
					ProcessDefId INTEGER NOT NULL,
					ActivityId INTEGER NOT NULL,
					TaskId  INTEGER NOT NULL,
					SubTaskId  INTEGER NOT NULL,
					DocumentType VARCHAR(63) NOT NULL,
					DocumentIndex VARCHAR(63) NOT NULL,
					ISIndex VARCHAR(63) NOT NULL,
					CompleteStatus	VARCHAR(1) default ''N'' NOT NULL
				)';
			END IF;

			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFCaseInfoVariableTable');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFCaseInfoVariableTable (
						ProcessDefId            INTEGER             NOT NULL,
						ActivityID				INTEGER				NOT NULL,
						VariableId		INTEGER 		NOT NULL ,
						DisplayName			VARCHAR(2000)		NULL,
						CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
					)';
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
			
			v_QueryStr := 'SELECT conname FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER(''WFCommentsHistoryTable'')) and conname like ''wfcommentshistorytable_commentstype_check%''';	
			BEGIN
				OPEN Cursor1 FOR EXECUTE v_QueryStr;
				LOOP
					FETCH Cursor1 INTO v_constraintName;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					EXECUTE 'ALTER TABLE WFCommentsHistoryTable DROP CONSTRAINT '||v_constraintName;
				END LOOP;
				CLOSE Cursor1;
			END;
		 
			EXECUTE 'ALTER TABLE WFCommentsHistoryTable ADD CONSTRAINT wfcommentshistorytable_commentstype_check CHECK (CommentsType IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))';

			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskExpiryOperation');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFTaskExpiryOperation(
					ProcessDefId            INT                 NOT NULL,
					TaskId                  INT                 NOT NULL,
					NeverExpireFlag         VARCHAR(1)         NOT NULL,
					ExpireUntillVariable    VARCHAR(255)       NULL,
					ExtObjID                INT                 NULL,
					ExpCalFlag              VARCHAR(1)         NULL,
					Expiry                  INT                 NOT NULL,
					ExpiryOperation         INT                 NOT NULL,
					ExpiryOpType            VARCHAR(64)        NOT NULL,
					ExpiryOperator          INT                 NOT NULL,
					UserType                VARCHAR(1)         NOT NULL,
					VariableId              INT                 NULL,
					VarFieldId              INT                 NULL,
					Value                   VARCHAR(255)        NULL,
					TriggerID               Int                 NULL,
					PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
				)';
			END IF;
			
			existflag := 0;
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('CaseINITIATEWORKITEMTABLE');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE CaseINITIATEWORKITEMTABLE ( 
						ProcessDefID 		INT				NOT NULL ,
						TaskId          INT    DEFAULT 0 NOT NULL,
						ImportedProcessName VARCHAR(30)	NOT NULL  ,
						ImportedFieldName 	VARCHAR(63)	NOT NULL ,
						ImportedVariableId	INT					NULL,
						ImportedVarFieldId	INT					NULL,
						MappedFieldName		VARCHAR(63)	NOT NULL ,
						MappedVariableId	INT					NULL,
						MappedVarFieldId	INT					NULL,
						FieldType			VARCHAR(1)		NOT NULL,
						MapType				VARCHAR(1)			NULL,
						DisplayName			VARCHAR(2000)		NULL,
						ImportedProcessDefId	INT				NULL,
						EntityType VARCHAR(1) DEFAULT ''A''  NOT NULL
					)';
		END IF;

		existflag := 0;
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFUserLogTable');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE WFUserLogTable  (
						UserLogId			Serial			PRIMARY KEY,
						ActionId			INTEGER			NOT NULL,
						ActionDateTime		TIMESTAMP		NOT NULL,
						UserId				INTEGER,
						UserName			VARCHAR(64),
						Message				VARCHAR(1000)
					)';
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('AllowReassignment');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTASKSTATUSTABLE add AllowReassignment Varchar(1) NOT NULL DEFAULT ''Y''');
		END IF;
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('AllowDecline');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTASKSTATUSTABLE add AllowDecline Varchar(1) NOT NULL DEFAULT ''Y''');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('AllowReassignment');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskStatusHistoryTable add AllowReassignment Varchar(1) NOT NULL DEFAULT ''Y''');
		END IF;
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('AllowDecline');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskStatusHistoryTable add AllowDecline Varchar(1) NOT NULL DEFAULT ''Y''');
		END IF;

		existflag := 0;
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('CaseIMPORTEDPROCESSDEFTABLE');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE (
						ProcessDefID 			INT 			NOT NULL,
						TaskId          INT   DEFAULT 0 NOT NULL ,
						ImportedProcessName 	VARCHAR(30)	NOT NULL ,
						ImportedFieldName 		VARCHAR(63)	NOT NULL ,
						FieldDataType			INT					NULL ,	
						FieldType				VARCHAR(1)		NOT NULL,
						VariableId				INT					NULL,
						VarFieldId				INT					NULL,
						DisplayName				VARCHAR(2000)		NULL,
						ImportedProcessDefId	INT					NULL,
						ProcessType				VARCHAR(1)		DEFAULT (N''R'')	NULL   	
					)';
		END IF;
			
			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFTaskUserAssocTable');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFTaskUserAssocTable (
							ProcessDefId int,
							ActivityId int,
							TaskId int,
							UserId int,
							AssociationType int
						)';
			END IF;

			existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFDefaultTaskUser');
			IF (NOT FOUND) THEN
				Execute 'create table WFDefaultTaskUser(
							processdefid int,
							activityid int,
							taskid int,
							CaseManagerId int,
							userid int,
							constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
						)';
			END IF;
			BEGIN 
			v_QueryStr := 'Select distinct b.processdefid ProcessDefId from activitytable a inner join  processdeftable b on a.processdefid = b.processdefid where a.activitytype= 32 order by processdefid';
			OPEN adhocTaskCursor FOR EXECUTE v_QueryStr;
			LOOP
				FETCH adhocTaskCursor INTO v_ProcessDefId;
				IF(NOT FOUND) THEN
						EXIT;
				END IF;
				existflag:=0;
				v_tableName:= 'WFAdhocTaskData_'||v_ProcessDefId;
				select 1 into existflag from information_schema.tables where upper(table_name) =  UPPER(v_tableName);
				IF(NOT FOUND) THEN
					BEGIN
						v_STR1 := 'CREATE Table '||v_tableName  || '(ProcessInstanceId varchar(63) NOT NULL , WorkItemId  INTEGER NOT NULL ,ActivityId INTEGER NOT NULL, TaskId INTEGER NOT NULL,TaskVariableName varchar(255) NOT NULL,VariableType INTEGER NOT NULL, Value VARCHAR(2000) NOT NULL)';
						--RAISE NOTICE 'v str1 %',v_STR1;
						Execute  v_STR1;
					END;
					
				END IF;
			
				existflag:=0;
				v_tableName:= 'WFAdhocTaskHistoryData_'||v_ProcessDefId;
				select 1 into existflag from information_schema.tables where upper(table_name) =  UPPER(v_tableName);
				IF(NOT FOUND) THEN
					BEGIN
						v_STR1 := 'CREATE Table '||v_tableName  || '(ProcessInstanceId VARCHAR(63) NOT NULL , WorkItemId  INTEGER NOT NULL ,ActivityId INTEGER NOT NULL, TaskId INTEGER NOT NULL,TaskVariableName VARCHAR(255) NOT NULL,VariableType INTEGER NOT NULL, 	Value VARCHAR(2000) NOT NULL)';
						--RAISE NOTICE 'v str1 %',v_STR1;
						Execute  v_STR1;
					END;
					
				END IF;
			END LOOP;
			CLOSE adhocTaskCursor;
			END;
/*Common Code Synchronization Changes Starts*/
	/*updating Q_UserId and Assigned user after PS is being unregistered */
		DROP TRIGGER IF EXISTS WF_UTIL_UNREGISTER ON PSREGISTERATIONTABLE;
		CREATE TRIGGER WF_UTIL_UNREGISTER 
		AFTER DELETE ON PSREGISTERATIONTABLE FOR EACH ROW
			EXECUTE PROCEDURE WFUtilUnregister();
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFEscalationTable') and UPPER(column_name)=UPPER('EscalationType');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFEscalationTable ADD EscalationType VARCHAR(2) DEFAULT ''F''');
			EXECUTE  ('UPDATE WFEscalationTable SET EscalationType = ''F'' WHERE EscalationType IS NULL');
		END IF;
		
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFEscalationTable') and UPPER(column_name)=UPPER('ResendDurationMinutes');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFEscalationTable ADD  ResendDurationMinutes INTEGER');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFEscinProcessTable') and UPPER(column_name)=UPPER('EscalationType');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFEscinProcessTable ADD EscalationType VARCHAR(2) DEFAULT ''F''');
			EXECUTE  ('UPDATE WFEscinProcessTable SET EscalationType = ''F'' WHERE EscalationType IS NULL');
		END IF;
		
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFEscinProcessTable') and UPPER(column_name)=UPPER('ResendDurationMinutes');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFEscinProcessTable ADD  ResendDurationMinutes INTEGER');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFExportTable') and UPPER(column_name)=UPPER('DateTimeFormat');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFExportTable ADD  DateTimeFormat VARCHAR(50)');
		END IF;
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('EscalatedFlag');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFTaskStatusTable Add EscalatedFlag Varchar(1)');
		END IF;
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskStatusHistoryTable') and UPPER(column_name)=UPPER('EscalatedFlag');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFTaskStatusHistoryTable Add EscalatedFlag Varchar(1)');
		END IF;

		/*UT BugFix#72218*/


	/*Error while checkin/register if TableName and ForeignKey in VarRelationtable has length greater than 30*/	
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFAutoGenInfoTable') and UPPER(column_name)=UPPER('TableName');
		IF(FOUND) THEN 
			EXECUTE  ('alter table WFAutoGenInfoTable alter column TableName type VARCHAR(256)');
		END IF;	
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFAutoGenInfoTable') and UPPER(column_name)=UPPER('ColumnName');
		IF(FOUND) THEN 
			EXECUTE  ('alter table WFAutoGenInfoTable alter column  ColumnName Type VARCHAR(256)');
		END IF;	
		
/*Common Code Synchronization Changes Ends*/			
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFEventDetailsTable') and UPPER(column_name)=UPPER('Description');
		IF (existflag=1) THEN
			EXECUTE  ('alter table WFEventDetailsTable alter column Description set data type VARCHAR(400)');
		END IF;
		IF(NOT FOUND) THEN 
			EXECUTE  ('alter table WFEventDetailsTable add column Description VARCHAR(400)');
		END IF;
		
		/*Case registeration Name changes requirement*/
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('PROCESSDEFTABLE') and UPPER(column_name)=UPPER('DisplayName');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table PROCESSDEFTABLE ADD DisplayName	VARCHAR(20)	NULL');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('URN');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFINSTRUMENTTABLE ADD URN	VARCHAR (63)  NULL');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('URN');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table QUEUEHISTORYTABLE ADD URN	VARCHAR (63)  NULL');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFCURRENTROUTELOGTABLE') and UPPER(column_name)=UPPER('URN');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFCURRENTROUTELOGTABLE ADD URN	VARCHAR (63)  NULL');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFHISTORYROUTELOGTABLE') and UPPER(column_name)=UPPER('URN');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFHISTORYROUTELOGTABLE ADD URN	VARCHAR (63)  NULL');
		END IF;
		/*Case registeration Name changes requirement ends here*/
		BEGIN
		EXECUTE ('UPDATE PROCESSDEFTABLE SET FormViewerApp=''J'' where FormViewerApp=''A'' ');
		end ;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFAuthorizeQueueDefTable') and UPPER(column_name)=UPPER('QueueName');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFAuthorizeQueueDefTable ADD QueueName			VARCHAR(63) 	NULL');
		END IF;
		
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFTaskPreCheckTable') and UPPER(column_name)=UPPER('ProcessDefId');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFTaskPreCheckTable ADD ProcessDefId			INTEGER');
		END IF;
/*Rest Implementation*/
	select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFRestServiceInfoTable');
		IF (NOT FOUND) THEN
			Execute 'CREATE TABLE WFRestServiceInfoTable (
				ProcessDefId		INT				NOT NULL, 
				ResourceId			INT 			NOT NULL, 
				ResourceName 		VARCHAR(255) 	NOT NULL ,
				BaseURI             VARCHAR(2000)  NULL,
				ResourcePath        VARCHAR(2000)  NULL,
				ResponseType		VARCHAR(2)			NULL,	
				ContentType			VARCHAR(2)			NULL,	
				OperationType		VARCHAR(50)			NULL,	
				AuthenticationType	VARCHAR(500)		NULL,	
				AuthUser			VARCHAR(1000)		NULL,
				AuthPassword		VARCHAR(1000)		NULL,
				AuthenticationDetails			VARCHAR(2000) NULL,
				AuthToken			VARCHAR(2000)		NULL,
				ProxyEnabled			VARCHAR(2)		NULL,
				SecurityFlag		VARCHAR(1)		    NULL,
				PRIMARY KEY (ProcessDefId,ResourceId)
			)';

			END IF;
		
		
		select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFRestActivityAssocTable');
		IF (NOT FOUND) THEN
			Execute 'create table WFRestActivityAssocTable(
			   ProcessDefId integer ,
			   ActivityId integer ,
			   ExtMethodIndex integer ,
			   OrderId integer ,
			   TimeoutDuration integer ,
			   CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
			) ';
		END IF;
		
		
		/* Modifying the Check contraint on EXTMETHODDEFTABLE */
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
	 
		EXECUTE 'ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT extmethoddeftable_extapptype_check 
					CHECK (ExtAppType IN (''E'', ''W'', ''S'', ''Z'', ''B'', ''R''))';
					
	/* Modifying the Check contraint on EXTMETHODPARAMDEFTABLE */
		v_QueryStr := 'SELECT conname FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER(''EXTMETHODPARAMDEFTABLE'')) and conname like ''extmethodparamdeftable_unbounded_check%''';	
		BEGIN
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_constraintName;
				IF (NOT FOUND) THEN
                    EXIT;
                END IF;
				EXECUTE 'ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT '||v_constraintName;
			END LOOP;
			CLOSE Cursor1;
		END;
	 
		EXECUTE 'ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT extmethodparamdeftable_unbounded_check 
					CHECK (Unbounded IN (''N'', ''Y'', ''X'', ''Z'', ''M'', ''P''))';
		
	/*Inactive user is not showing in Rights Management while it showing in Omnidocs admin*/
		existflag := 0;
		SELECT 1 INTO existFlag
		FROM PG_VIEWS
		WHERE UPPER(VIEWNAME) = 'WFALLUSERVIEW';
		IF(FOUND) THEN
			DROP VIEW WFALLUSERVIEW;
			CREATE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
			EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
			COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
			MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
				AS 
			SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
			FROM PDBUSER where deletedflag = 'N';
		ELSE
			CREATE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
			EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
			COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
			MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
				AS 
			SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
			FROM PDBUSER where deletedflag = 'N';
		END IF;
		
		EXECUTE 'update WFActionStatusTable set Type=''S'',Status=''Y'' where ActionId>=700 and ActionId<=714';
		
	/* Modifying the Check contraint on WFDataStructureTable */
		v_QueryStr := 'SELECT conname FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER(''WFDataStructureTable'')) and conname like ''wfdatastructuretable_unbounded_check%''';	
		BEGIN
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_constraintName;
				IF (NOT FOUND) THEN
                    EXIT;
                END IF;
				EXECUTE 'ALTER TABLE WFDataStructureTable DROP CONSTRAINT '||v_constraintName;
			END LOOP;
			CLOSE Cursor1;
		END;
	 
		EXECUTE 'ALTER TABLE WFDataStructureTable ADD CONSTRAINT wfdatastructuretable_unbounded_check 
					CHECK (Unbounded IN (''N'', ''Y'', ''X'', ''Z'', ''M'', ''P''))';	
/*End of Rest Implementation*/
		existflag := 0;
			select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('WFInitiationAgentReportTable');
			IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFInitiationAgentReportTable(
					LogId SERIAL NOT NULL,
					EmailReceivedDateTime TIMESTAMP NULL,
					MailFrom VARCHAR(4000) NULL,
					MailTo VARCHAR(4000) NULL,
					MailSubject VARCHAR(4000) NULL,
					MailCC VARCHAR(4000) NULL,
					EmailFileName VARCHAR(200) NULL,
					EMailStatus VARCHAR(100) NULL,
					ActionDateTime TIMESTAMP NULL,
					ProcessInstanceId VARCHAR(200) NULL,
					ActionDescription VARCHAR(4000) NULL,
					ProcessDefId INTEGER ,
					ActivityId INTEGER 
				)';
			END IF;
	
	/* Bug 77151*/
	BEGIN
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns 
		WHERE UPPER(table_name) = UPPER('WFTASKRULEPRECONDITIONTABLE') and UPPER(column_name)=UPPER('PARAM1');
		IF(FOUND) THEN 
			EXECUTE  ('ALTER Table WFTASKRULEPRECONDITIONTABLE ALTER COLUMN PARAM1 TYPE VARCHAR(255)');
		END IF;
	END;

	/* Added index in WFInstrumentTable*/
	BEGIN
		existflag := 0;
		SELECT 1 INTO existflag
		FROM pg_indexes
		WHERE UPPER(tablename) = 'WFINSTRUMENTTABLE' AND UPPER(INDEXNAME) = 'IDX13_WFINSTRUMENTTABLE';
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(URN)');
		END IF;
	END;
	/* Added index in WFInstrumentTable*/
	
	existflag :=0;	
	BEGIN
		 SELECT Count(1) INTO existflag FROM WFSYSTEMPROPERTIESTABLE WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG';
		 If(existflag=0) THEN
		 BEGIN
			INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SHAREPOINTFLAG','N');
		 END;
		 END IF;
	END;
	
	BEGIN
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns 
		WHERE UPPER(table_name) = UPPER('WFDMSLIBRARY') and UPPER(column_name)=UPPER('DOMAINNAME');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFDMSLIBRARY ADD DOMAINNAME	VARCHAR(64)	NULL');
		END IF;
	END;
	
	BEGIN
		existflag := 0;
		SELECT 1 INTO existflag
		FROM information_schema.columns 
		WHERE UPPER(table_name) = UPPER('WFARCHIVEINSHAREPOINT') and UPPER(column_name)=UPPER('DOMAINNAME');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFARCHIVEINSHAREPOINT ADD DOMAINNAME	VARCHAR(64)	NULL');
		END IF;
	END;
	
	/*Entry in WFCabVersionTable- THIS SHOULD BE THE LAST CODE OF THIS FILE*/				

	BEGIN
		 existflag :=0;	
		 SELECT Count(1) INTO existflag FROM WFCabVersionTable WHERE UPPER(cabVersion) = UPPER('iBPS_4.0');
		 If(existflag=0) THEN
		 BEGIN
			INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_4.0',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'iBPS_4.0', N'Y');
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