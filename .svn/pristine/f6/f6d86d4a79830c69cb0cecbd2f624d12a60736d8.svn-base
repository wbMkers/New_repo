/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis_iBPS
	Product / Project			: WorkFlow
	Module						: iBPS_Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Kumar       Kimil
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
11/08/2017		Mohnish Chopra		Added for Case Summary requirement
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous)
21/08/2017		Ambuj Tripathi  Added changes for the task escalation in WFEscInProcessTable table
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
14/11/2017      Kumar Kimil     Bug 73459 - Case-Registration -Search Workitems
15/11/2017      Kumar Kimil     Bug 73545 - Upgrade from OF 10.3 SP-2 to iBPS 3.2 +EAP+SQL: Associated NGF Form & iform is not showing in workitem
16/11/2017		Ambuj Tripathi	Bug 73581 - Upgrade from iBPS 3.0 SP-1+WAS+SQL to iBPS 3.2: Getting error in file WFGenerateREgistration.sql if upgrade cabinet 
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
21/11/2017      Ambuj Tripathi  Bug 73616 - Getting error in cabinet upgrade - Table or view doesnt exists, changing the logic to modify the check constraint for wfcommentstable and wfcommentsHistorytable, changes were done in SP1 script as well.
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
17/12/2017      Kumar Kimil     Bug 74205 - Weblogic+Oracle:-Unable to deploy process it shows error "request operation failed "
17/12/2017      Kumar Kimil     Bug 74204 - Weblogic+Oracle:-Under Myqueue it shows error "The request filter is invalid".
18/12/2017      Kumar Kimil     Bug 74230 - Weblogic+Oracle(Upgrade from iBPS 3.0 Patch 3+ Oracle with CM to iBPS 3.2 ):-unable to perform "Assign to me " operation on WI.
28/12/2017    Kumar Kimil     Bug 74287-EAP6.4+SQL: Search on URN is not working proper
28/12/2017    Kumar Kimil     Bug 72882-WBL+Oracle: Incorrect workitem count is showing in quick search result.
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
26/02/2018    Mohd Faizan     Bug 76093 - EAP7+sql: User filter is not working for 'Set preferences' audit log option
20/04/2018      Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
14/05/2018		Ambuj Tripathi	PRDP Bug merging : Bug 77527 - Provide upper case encrypted password while creating system user if PwdSensitivity is N
14/05/2018	Ambuj Tripathi	Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
___________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade AS
	TYPE DynamicCursor	IS REF CURSOR;
	existsFlag INT;
	v_ProcessDefId INT;
	v_ActivityId INT;
	v_ActivityType INT;
	Cursor1 DynamicCursor;
	cur_ActSeqId DynamicCursor;
	v_constraintName VARCHAR2(512);
	v_constraintName2 VARCHAR2(512);
	v_SearchCondition NVARCHAR2(5000);
	cur_ProcessDefId  DynamicCursor;
	v_STR1			        VARCHAR2(8000);
	v_rowCount INT;
	v_queryStr VARCHAR2(800);
	v_QueueId INT;
BEGIN
			
		/*Inactive user is not showing in Rights Management while it showing in Omnidocs admin*/
		BEGIN
			v_STR1 := 'CREATE OR REPLACE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
						  EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
						  COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
						  MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
			AS 
			SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
				CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
				PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
				MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
				FROM PDBUSER  WHERE DELETEDFLAG = ''N'' ';
				
			EXECUTE IMMEDIATE v_STR1;		
			--DBMS_OUTPUT.PUT_LINE ('VIEW WFALLUSERVIEW Created');
		END;	
		
		/* Adding changes into tables for Case Management Tasks */
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('LockStatus');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD LockStatus VARCHAR2(1) DEFAULT ''N'' NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('InitiatedBy');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD InitiatedBy VARCHAR2(63) NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('TaskEntryDateTime');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD TaskEntryDateTime DATE NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('ValidTill');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD ValidTill DATE NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('LockStatus');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable ADD LockStatus VARCHAR2(1) DEFAULT ''N'' NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('InitiatedBy');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable ADD InitiatedBy VARCHAR2(63) NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('TaskEntryDateTime');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable ADD TaskEntryDateTime DATE NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('ValidTill');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable ADD ValidTill DATE NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCommentsTable') and upper(column_name) = upper('TaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFCommentsTable add TaskId INT DEFAULT 0 NOT NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCommentsTable') and upper(column_name) = upper('SubTaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFCommentsTable add SubTaskId INT DEFAULT 0 NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCommentsHistoryTable') and upper(column_name) = upper('TaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFCommentsHistoryTable add TaskId INT DEFAULT 0 NOT NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCommentsHistoryTable') and upper(column_name) = upper('SubTaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFCommentsHistoryTable add SubTaskId INT DEFAULT 0 NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('ACTIVITYTABLE') and upper(column_name) = upper('GenerateCaseDoc');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table ACTIVITYTABLE add GenerateCaseDoc NVARCHAR2(1) DEFAULT N''N'' NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('DOCUMENTTYPEDEFTABLE') and upper(column_name) = upper('DocType');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table DOCUMENTTYPEDEFTABLE add DocType NVARCHAR2(1) DEFAULT ''D''  NOT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFEscalationTable') and upper(column_name) = upper('TaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFEscalationTable add TaskId INT NULL');
		END;

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFEscInProcessTable') and upper(column_name) = upper('TaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('alter table WFEscInProcessTable add TaskId INT NULL');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFLinkstable') and upper(column_name) = upper('TaskId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('ALTER table WFLinkstable add TaskId integer  default 0 not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WfTaskDefTable') and upper(column_name) = upper('TaskMode');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WfTaskDefTable Add TaskMode Varchar2(1)');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('ApprovalRequired');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable Add ApprovalRequired Varchar2(1) default ''N'' not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('ApprovalSentBy');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable Add ApprovalSentBy Varchar2(63) null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKSTATUSHISTORYTABLE') and upper(column_name) = upper('ApprovalRequired');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTASKSTATUSHISTORYTABLE Add ApprovalRequired Varchar2(1) default ''N'' not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKSTATUSHISTORYTABLE') and upper(column_name) = upper('ApprovalSentBy');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTASKSTATUSHISTORYTABLE Add ApprovalSentBy Varchar2(63) null');
		END;		

		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('ACTIVITYTABLE') and upper(column_name) = upper('DoctypeId');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table ACTIVITYTABLE Add DoctypeId INT DEFAULT -1 NOT NULL');
		END;		
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskDefTable') and upper(column_name) = upper('UseSeparateTable');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskDefTable Add UseSeparateTable Varchar2(1) default ''Y'' not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKSTATUSTABLE') and upper(column_name) = upper('AllowReassignment');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTASKSTATUSTABLE add AllowReassignment Varchar2(1) default ''Y'' not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKSTATUSTABLE') and upper(column_name) = upper('AllowDecline');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTASKSTATUSTABLE Add AllowDecline Varchar2(1) default ''Y'' not  null');
		END;
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKSTATUSTABLE') and upper(column_name) = upper('EscalatedFlag');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('ALTER Table WFTaskStatusTable Add EscalatedFlag Varchar2(1)');
		END;
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('AllowReassignment');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable add AllowReassignment Varchar2(1) default ''Y'' not  null');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('AllowDecline');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('Alter table WFTaskStatusHistoryTable Add AllowDecline Varchar2(1) default ''Y'' not  null');
		END;
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusHistoryTable') and upper(column_name) = upper('EscalatedFlag');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('ALTER Table WFTaskStatusHistoryTable Add EscalatedFlag Varchar2(1)');
		END;
		
		BEGIN
			existsFlag :=0;	
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFAuthorizeQueueDefTable') and upper(column_name) = upper('QueueName');
			Exception when no_data_found then
				EXECUTE IMMEDIATE ('ALTER Table WFAuthorizeQueueDefTable Add QueueName		NVARCHAR2(63)	NULL ');
		END;
		
		BEGIN
			existsFlag :=0;	
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFForm_table') 
			AND 
			COLUMN_NAME=UPPER('FormType');
			EXCEPTION
			WHEN NO_DATA_FOUND THEN

				EXECUTE IMMEDIATE 'Alter table WFForm_table add FormType nvarchar2(1) default ''P'' not null ';
				--DBMS_OUTPUT.PUT_LINE('Table WFForm_table altered with new Column FormType');
				
		END;
		
				/* Task Management changes till here */
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskruleOperationTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFTaskruleOperationTable(
						ProcessDefId     INT    NOT NULL,
						ActivityId     INT     NOT NULL, 
						TaskId     INT     NOT NULL, 
						RuleId     SMALLINT     NOT NULL, 
						OperationType     SMALLINT     NOT NULL, 
						Param1 nvarchar2(255) NOT NULL,
						Type1 nvarchar2(1) NOT NULL,
						ExtObjID1 int  NULL,
						VariableId_1 int  NULL,
						VarFieldId_1 int  NULL,    
						Param2 nvarchar2(255) NOT NULL,
						Type2 nvarchar2(1) NOT NULL,
						ExtObjID2 int  NULL,
						VariableId_2 int  NULL,
						VarFieldId_2 int  NULL,
						Param3 nvarchar2(255) NULL,
						Type3 nvarchar2(1) NULL,
						ExtObjID3 int  NULL,
						VariableId_3 int  NULL,
						VarFieldId_3 int  NULL,    
						Operator     SMALLINT     NOT NULL, 
						AssignedTo    nvarchar2(63),    
						OperationOrderId     SMALLINT     NOT NULL, 
						RuleCalFlag nvarchar2(1) NULL,
						CONSTRAINT pk_WFTaskruleOperationTable PRIMARY KEY  (ProcessDefId,ActivityId,TaskId,RuleId,OperationOrderId ) 
 
					)';
					--dbms_output.put_line ('Table WFTaskruleOperationTable Created successfully');
		END;
		

		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskPropertyTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'Create Table WFTaskPropertyTable(
						ProcessDefId integer NOT NULL,
						ActivityId INT NOT NULL ,
						TaskId  integer NOT NULL,
						DefaultStatus integer NOT NULL,
						AllowReassignment varchar2(1),
						AllowDecline varchar2(1),
						ApprovalRequired varchar2(1),
						MandatoryText varchar2(255),
						CONSTRAINT pk_WFTaskPropertyTable PRIMARY KEY  ( ProcessDefId,ActivityId ,TaskId)
						)';
					--dbms_output.put_line ('Table WFTaskPropertyTable Created successfully');
		END;
		
		
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskPreConditionResultTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'Create Table WFTaskPreConditionResultTable(
						ProcessInstanceId	varchar2(63)  	NOT NULL ,
						WorkItemId 		INT 		NOT NULL ,
						ActivityId INT NOT NULL ,
						TaskId  integer NOT NULL,
						Ready Integer  null,
						Mandatory varchar2(1),
						CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
						)';
					--dbms_output.put_line ('Table WFTaskPreConditionResultTable Created successfully');
		END;
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskPreCondResultHistory');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'Create Table WFTaskPreCondResultHistory(
						ProcessInstanceId	varchar2(63)  	NOT NULL ,
						WorkItemId 		INT 		NOT NULL ,
						ActivityId INT NOT NULL ,
						TaskId  integer NOT NULL,
						Ready Integer  null,
						Mandatory varchar2(1),
						CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
						)';
					--dbms_output.put_line ('Table WFTaskPreCondResultHistory Created successfully');
		END;		
		
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskPreCheckTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'Create Table WFTaskPreCheckTable(
						ProcessInstanceId	varchar2(63)  	NOT NULL ,
						WorkItemId 		INT 		NOT NULL ,
						ActivityId INT NOT NULL ,
						checkPreCondition varchar2(1),
						CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
						)';
					--dbms_output.put_line ('Table WFTaskPreCheckTable Created successfully');
		END;

		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFTaskPreCheckHistory');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'Create Table WFTaskPreCheckHistory(
						ProcessInstanceId	varchar2(63)  	NOT NULL ,
						WorkItemId 		INT 		NOT NULL ,
						ActivityId INT NOT NULL ,
						checkPreCondition varchar2(1),
						CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
						)';
					--dbms_output.put_line ('Table WFTaskPreCheckHistory Created successfully');
		END;

		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFCaseSummaryDetailsHistory');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFCaseSummaryDetailsHistory(
						ProcessInstanceId NVarchar2(63) NOT NULL,
						WorkItemId INT NOT NULL,
						ProcessDefId INT             NOT NULL,
						ActivityId INT NOT NULL,
						ActivityName NVARCHAR2(30)    NOT NULL,
						Status INT NOT NULL,
						NoOfRetries INT NOT NULL,
						EntryDateTime 			DATE	NOT 	NULL ,
						LockedBy	NVARCHAR2(1000) NULL,
						CONSTRAINT PK_WFCaseSummaryDetailsHistory PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
					)';	
		--dbms_output.put_line ('Table WFCaseSummaryDetailsHistory Created successfully');
		END;
				BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFCaseSummaryDetailsTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFCaseSummaryDetailsTable(
						ProcessInstanceId NVarchar2(63) NOT NULL,
						WorkItemId INT NOT NULL,
						ProcessDefId INT             NOT NULL,
						ActivityId INT NOT NULL,
						ActivityName NVARCHAR2(30)    NOT NULL,
						Status INT NOT NULL,
						NoOfRetries INT NOT NULL,
						EntryDateTime 			DATE	NOT	NULL ,
						LockedBy	NVARCHAR2(1000) NULL,
						CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
					)';	
		--dbms_output.put_line ('Table WFCaseSummaryDetailsTable Created successfully');
		END;

		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFGenericServicesTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFGenericServicesTable	 (
					ServiceId  			INT 				NOT NULL,
					GenServiceId		INT					NOT NULL, 
					GenServiceName  		NVARCHAR2(50)		NULL, 
					GenServiceType  		NVARCHAR2(50)		NULL, 
					ProcessDefId 		INT					NULL, 
					EnableLog  			NVARCHAR2(50)		NULL, 
					MonitorStatus 		NVARCHAR2(50)		NULL, 
					SleepTime  			INT					NULL, 
					RegInfo   			CLOB				NULL,
					CONSTRAINT PK_WFGenericServicesTable PRIMARY KEY(ServiceId,GenServiceId)
				)';	
		--dbms_output.put_line ('Table WFGenericServicesTable Created successfully');
		END;
		
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFCaseDocStatusTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFCaseDocStatusTable(
					    ProcessInstanceId NVarchar2(63) NOT NULL,
					    WorkItemId INT NOT NULL,
					    ProcessDefId INT NOT NULL,
					    ActivityId INT NOT NULL,
					    TaskId  Integer NOT NULL,
						SubTaskId  Integer NOT NULL,
						DocumentType NVarchar2(63)  NULL,
						DocumentIndex NVarchar2(63) NOT NULL,
						ISIndex NVarchar2(63) NOT NULL,
						CompleteStatus	NVARCHAR2(1) DEFAULT ''N'' NOT NULL
					)';	
		--dbms_output.put_line ('Table WFCaseDocStatusTable Created successfully');
		END;
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFCaseDocStatusHistory');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFCaseDocStatusHistory(
						ProcessInstanceId NVarchar2(63) NOT NULL,
						WorkItemId INT NOT NULL,
						ProcessDefId INT NOT NULL,
						ActivityId INT NOT NULL,
						TaskId  Integer NOT NULL,
						SubTaskId  Integer NOT NULL,
						DocumentType NVarchar2(63) NOT NULL,
						DocumentIndex NVarchar2(63) NOT NULL,
						ISIndex NVarchar2(63) NOT NULL,
						CompleteStatus	NVARCHAR2(1) DEFAULT ''N'' NOT NULL
				)';	
		--dbms_output.put_line ('Table WFCaseDocStatusHistory Created successfully');
		END;			
		BEGIN 
			SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFCaseInfoVariableTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFCaseInfoVariableTable (
					ProcessDefId            INT             NOT NULL,
					ActivityID				INT				NOT NULL,
					VariableId		INT 		NOT NULL ,
					DisplayName			NVARCHAR2(2000)		NULL,
					CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
				)';	
		--dbms_output.put_line ('Table WFCaseInfoVariableTable Created successfully');
		END;
		
		/* Dropping and recreating the check constraint on WFCommentsTable created through upgrade_10_3_SP2.sql*/	
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
			SAVEPOINT ModifyCheckConstrntComments;
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
			ROLLBACK TO SAVEPOINT ModifyCheckConstrntComments;
			CLOSE Cursor1;
			raise_application_error(-20364, 'Modifying the Check contraint on WFCommentsTable Failed.');
		END;


		/* Dropping and recreating the check constraint on WFCommentsHistoryTable created through upgrade_10_3_SP2.sql*/	
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM TAB
			WHERE TNAME = UPPER('WFCOMMENTS_HISTORY_CONSTRAINTS') ;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
			existsFlag := 0;
		END;

		BEGIN
			SAVEPOINT ModifyCheckConstrntHistory;
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
			ROLLBACK TO SAVEPOINT ModifyCheckConstrntHistory;
			CLOSE Cursor1;
			raise_application_error(-20364, 'Modifying the Check contraint on WFCommentsHistoryTable Failed.');
		END;
		/* Dropping and recreating the check constraint on comments tables ends here*/
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTaskExpiryOperation');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFTaskExpiryOperation(
						ProcessDefId            INT                 NOT NULL,
						TaskId                  INT                 NOT NULL,
						NeverExpireFlag         VARCHAR2(1)         NOT NULL,
						ExpireUntillVariable    VARCHAR2(255)       NULL,
						ExtObjID                INT                 NULL,
						ExpCalFlag              VARCHAR2(1)         NULL,
						Expiry                  INT                 NOT NULL,
						ExpiryOperation         INT                 NOT NULL,
						ExpiryOpType            VARCHAR2(64)        NOT NULL,
						ExpiryOperator          INT                 NOT NULL,
						UserType                VARCHAR2(1)         NOT NULL,
						VariableId              INT                 NULL,
						VarFieldId              INT                 NULL,
						Value                   VARCHAR2(255)		NULL,
						TriggerID               Int                 NULL,
						PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
					)';	
		--dbms_output.put_line ('Table WFTaskExpiryOperation Created successfully');
		END;
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('CaseINITIATEWORKITEMTABLE');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE CaseINITIATEWORKITEMTABLE ( 
						ProcessDefID 		INT				NOT NULL ,
						TaskId          INT    DEFAULT 0 NOT NULL,
						ImportedProcessName NVARCHAR2(30)	NOT NULL  ,
						ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
						ImportedVariableId	INT					NULL,
						ImportedVarFieldId	INT					NULL,
						MappedFieldName		NVARCHAR2(63)	NOT NULL ,
						MappedVariableId	INT					NULL,
						MappedVarFieldId	INT					NULL,
						FieldType			NVARCHAR2(1)		NOT NULL,
						MapType				NVARCHAR2(1)			NULL,
						DisplayName			NVARCHAR2(2000)		NULL,
						ImportedProcessDefId	INT				NULL,
						EntityType NVARCHAR2(1) DEFAULT ''A''  NOT NULL
					)';	
		--dbms_output.put_line ('Table CaseINITIATEWORKITEMTABLE Created successfully');
		END;
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('CaseIMPORTEDPROCESSDEFTABLE');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE (
						ProcessDefID 			INT 			NOT NULL,
						TaskId          INT   DEFAULT 0 NOT NULL ,
						ImportedProcessName 	NVARCHAR2(30)	NOT NULL ,
						ImportedFieldName 		NVARCHAR2(63)	NOT NULL ,
						FieldDataType			INT					NULL ,	
						FieldType				NVARCHAR2(1)		NOT NULL,
						VariableId				INT					NULL,
						VarFieldId				INT					NULL,
						DisplayName				NVARCHAR2(2000)		NULL,
						ImportedProcessDefId	INT					NULL,
						ProcessType				NVARCHAR2(1)		DEFAULT (N''R'')	NULL   	
					) ';	
		--dbms_output.put_line ('Table CaseIMPORTEDPROCESSDEFTABLE Created successfully');
		END;
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTaskUserAssocTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFTaskUserAssocTable(
						ProcessDefId int,
						ActivityId int,
						TaskId int,
						UserId int,
						AssociationType int
					)';	
		--dbms_output.put_line ('Table WFTaskUserAssocTable Created successfully');
		END;
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDefaultTaskUser');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFDefaultTaskUser(
						processdefid int,
						activityid int,
						taskid int,
						CaseManagerId int,
						userid int,
						constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
					)';
		--dbms_output.put_line ('Table WFDefaultTaskUser Created successfully');
		END;
		
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFUserLogTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFUserLogTable  (
						UserLogId			INT			PRIMARY KEY,
						ActionId			INT			NOT NULL,
						ActionDateTime		DATE		NOT NULL,
						UserId				INT,
						UserName			NVARCHAR2(64),
						Message				NVARCHAR2(1000)
					)';
					--dbms_output.put_line ('Table WFUserLogTable Created successfully');
		END;
		
		Begin
		v_STR1:= 'Select distinct b.processdefid ProcessDefId from activitytable a inner join  processdeftable b on a.processdefid = b.processdefid where a.activitytype= 32 order by processdefid';
		OPEN cur_ActSeqId FOR v_STR1;
		LOOP
			FETCH cur_ActSeqId INTO v_ProcessDefId;
			EXIT WHEN cur_ActSeqId%NOTFOUND;
			BEGIN
				BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFAdhocTaskData_'||v_ProcessDefId);
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						EXECUTE IMMEDIATE 
						'create table WFAdhocTaskData_'||v_ProcessDefId||' (ProcessInstanceId NVARCHAR2(63) NOT NULL , WorkItemId  INT NOT NULL ,ActivityId INT NOT NULL, TaskId Int NOT NULL,TaskVariableName NVARCHAR2(255) NOT NULL,VariableType INT NOT NULL, Value NVARCHAR2(2000) NOT NULL)
						';
				--dbms_output.put_line ('Table WFAdhocTaskData_'||v_ProcessDefId||' Created successfully');
				END;
				BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFAdhocTaskHistoryData_'||v_ProcessDefId);
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						EXECUTE IMMEDIATE 
						'create table WFAdhocTaskHistoryData_'||v_ProcessDefId||' (ProcessInstanceId NVARCHAR2(63) NOT NULL , WorkItemId  INT NOT NULL ,ActivityId INT NOT NULL, TaskId Int NOT NULL,TaskVariableName NVARCHAR2(255) NOT NULL,VariableType INT NOT NULL, Value NVARCHAR2(2000) NOT NULL)
						';
				--dbms_output.put_line ('Table WFAdhocTaskHistoryData_'||v_ProcessDefId||' Created successfully');
				END;
				
				
			END;
		END LOOP;
		CLOSE cur_ActSeqId;
	    END;
		
/*Common Code Synchronization Changes Starts*/
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFEscalationTable') AND COLUMN_NAME=UPPER('EscalationType');
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable ADD EscalationType NVARCHAR2(1) DEFAULT ''F''';
			EXECUTE IMMEDIATE Q'{UPDATE WFEscalationTable SET EscalationType ='F' WHERE EscalationType IS NULL}';
			--DBMS_OUTPUT.PUT_LINE ('Table WFEscalationTable ADD COL EscalationType ROWCOUNT:'||SQL%ROWCOUNT);
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20433, 'Add new column EscalationType to WFEscalationTable Failed.');
		RETURN;
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFEscalationTable') AND COLUMN_NAME=UPPER('ResendDurationMinutes');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable ADD ResendDurationMinutes INTEGER';
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20434, 'Add new column ResendDurationMinutes to WFEscalationTable Failed.');
		RETURN;
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFEscinProcessTable') AND COLUMN_NAME=UPPER('EscalationType');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscinProcessTable ADD EscalationType NVARCHAR2(1) DEFAULT ''F''';
				EXECUTE IMMEDIATE Q'{UPDATE WFEscinProcessTable SET EscalationType ='F' WHERE EscalationType IS NULL}';
				--DBMS_OUTPUT.PUT_LINE ('Table WFEscinProcessTable ADD COL EscalationType ROWCOUNT:'||SQL%ROWCOUNT);
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20433, 'Add new column EscalationType to WFEscinProcessTable Failed.');
		RETURN;
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFEscInProcessTable') AND COLUMN_NAME=UPPER('ResendDurationMinutes');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscinProcessTable ADD ResendDurationMinutes INTEGER';
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20434, 'Add new column ResendDurationMinutes to WFEscinProcessTable Failed.');
		RETURN;
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFExportTable') AND COLUMN_NAME=UPPER('DateTimeFormat');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable ADD DateTimeFormat NVARCHAR2(50)';
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20434, 'Add new column DateTimeFormat to WFExportTable Failed.');
		RETURN;
	END;
	
	/* Bug# 71671 */
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFEventDetailsTable') AND COLUMN_NAME=UPPER('Description');
			IF existsFlag = 1 THEN
				EXECUTE IMMEDIATE 'alter table WFEventDetailsTable modify Description nvarchar2(400)';
			END IF;	
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'alter table WFEventDetailsTable ADD Description nvarchar2(400)';
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20434, 'Add new column Description to WFEventDetailsTable Failed.');
		RETURN;
	END;
	
	/*UT BugFix#72218 */

	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_UTIL_UNREGISTER
			AFTER DELETE 
			ON PSREGISTERATIONTABLE 
			FOR EACH ROW
			DECLARE
				PSName NVARCHAR2(100);
				PSData NVARCHAR2(50);
			BEGIN
				PSName := :OLD.PSName;
				PSData := :OLD.Data;
				IF (PSData = ''PROCESS SERVER'') THEN
				BEGIN				
					Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null, LockedByName = null , LockStatus = ''N'', LockedTime = null where LockedByName = PSName and LockStatus = ''Y'' and RoutingStatus = ''Y'';
				END;
				END IF;
				IF (PSData = ''MAILING AGENT'') THEN
				BEGIN
					UPDATE WFMailQueueTable SET MailStatus = ''N'', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = PSName;
				END;
				END IF;
				IF (PSData = ''MESSAGE AGENT'') THEN
				BEGIN
					UPDATE WFMessageTable SET LockedBy = null, Status = ''N'' where LockedBy = PSName;
				END;
				END IF;
				IF (PSData = ''PRINT,FAX & EMAIL'' OR PSData = ''ARCHIVE UTILITY'') THEN
				BEGIN
					Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null , LockedByName = null , LockStatus = N''N'' , LockedTime = null 
					 where  LockedByName = PSName and LockStatus = ''Y''  and RoutingStatus = ''N'';
				END;
				END IF;
			END;';
		--DBMS_OUTPUT.PUT_LINE ('Trigger WF_UTIL_UNREGISTER created');
	END;

/*Common Code Synchronization Changes Ends*/	

/*Rest Implementation*/
BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFRestServiceInfoTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFRestServiceInfoTable (
						ProcessDefId		INT				NOT NULL, 
						ResourceId			INT				NOT NULL,
						ResourceName 		NVARCHAR2(255)  NOT NULL ,
						BaseURI             NVARCHAR2(2000)  NULL,
						ResourcePath        NVARCHAR2(2000)  NULL,
						ResponseType		NVARCHAR2(2)		NULL,		
						ContentType			NVARCHAR2(2)		NULL,		
						OperationType		NVARCHAR2(50)		NULL,	
						AuthenticationType	NVARCHAR2(500)		NULL,	
						AuthUser			NVARCHAR2(1000)		NULL,
						AuthPassword		NVARCHAR2(1000)		NULL,
						AuthenticationDetails			NVARCHAR2(2000) NULL,
						AuthToken			NVARCHAR2(2000)		NULL,
						ProxyEnabled		NVARCHAR2(2)		NULL,
						SecurityFlag		NVARCHAR2(1)		NULL,
						PRIMARY KEY (ProcessDefId,ResourceId)
					)';
					
					--dbms_output.put_line ('Table WFRestServiceInfoTable Created successfully');
			END;
			
			
			
			
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFRestActivityAssocTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFRestActivityAssocTable(
					   ProcessDefId integer NOT NULL,
					   ActivityId integer NOT NULL,
					   ExtMethodIndex integer NOT NULL,
					   OrderId integer NOT NULL,
					   TimeoutDuration integer NOT NULL,
					   CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
					) ';
					--dbms_output.put_line ('Table WFRestActivityAssocTable Created successfully');
			END;
			
			
			


	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('ExtAppType_USER_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		
		IF (existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table ExtAppType_USER_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table ExtAppType_USER_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''EXTMETHODDEFTABLE'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table ExtAppType_USER_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''EXTMETHODDEFTABLE'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM ExtAppType_USER_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''ExtAppType%'''; 
		BEGIN
			OPEN Cursor1 FOR v_STR1;
			LOOP
				FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
				EXIT WHEN Cursor1%NOTFOUND;
				IF v_SearchCondition IS NOT NULL THEN
					EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || v_constraintName;
				END IF;
			END LOOP;
			CLOSE Cursor1;
		END;
		EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE ADD CHECK(ExtAppType IN (N''E'', N''W'', N''S'', N''Z'',N''B'',N''R''))';
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
			CLOSE Cursor1;
			raise_application_error(-20364, 'Modifying the Check contraint on EXTMETHODDEFTABLE Failed.');
	END;
	
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('ExtUnbound_USER_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraintExt;
		
		IF (existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table ExtUnbound_USER_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table ExtUnbound_USER_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''EXTMETHODPARAMDEFTABLE'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table ExtUnbound_USER_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''EXTMETHODPARAMDEFTABLE'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM ExtUnbound_USER_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''Unbounded%'''; 
		BEGIN
			OPEN Cursor1 FOR v_STR1;
			LOOP
				FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
				EXIT WHEN Cursor1%NOTFOUND;
				IF v_SearchCondition IS NOT NULL THEN
					EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT ' || v_constraintName;
				END IF;
			END LOOP;
			CLOSE Cursor1;
		END;
		EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK(Unbounded IN (N''N'', N''Y'', N''X'', N''Z'',N''M'',N''P''))';
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT ModifyCheckConstraintExt;
			CLOSE Cursor1;
			raise_application_error(-20364, 'Modifying the Check contraint on EXTMETHODPARAMDEFTABLE Failed.');
	END;
	
	
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('DSUnbound_USER_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraintDS;
		
		IF (existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table DSUnbound_USER_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table DSUnbound_USER_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFDataStructureTable'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table DSUnbound_USER_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFDataStructureTable'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM DSUnbound_USER_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''Unbounded%'''; 
		BEGIN
			OPEN Cursor1 FOR v_STR1;
			LOOP
				FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
				EXIT WHEN Cursor1%NOTFOUND;
				IF v_SearchCondition IS NOT NULL THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable DROP CONSTRAINT ' || v_constraintName;
				END IF;
			END LOOP;
			CLOSE Cursor1;
		END;
		EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable ADD CHECK(Unbounded IN (N''N'', N''Y'', N''X'', N''Z'',N''M'',N''P''))';
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT ModifyCheckConstraintDS;
			CLOSE Cursor1;
			raise_application_error(-20364, 'Modifying the Check contraint on WFDataStructureTable Failed.');
	END;
/*End of Rest IMplementation*/		
	/*Case registeration Name changes requirement*/
	BEGIN
		existsFlag :=0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('PROCESSDEFTABLE') and upper(column_name) = upper('DisplayName');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table PROCESSDEFTABLE add DisplayName	NVARCHAR2(20)	NULL');
	END;
	
	BEGIN
		existsFlag :=0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('GTempProcessTable') and upper(column_name) = upper('DisplayName');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table GTempProcessTable add DisplayName	NVARCHAR2(20)	NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFINSTRUMENTTABLE') and upper(column_name) = upper('URN');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE add URN NVARCHAR2(63)  NULL ');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('URN');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE add URN NVARCHAR2(63)  NULL ');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFHISTORYROUTELOGTABLE') and upper(column_name) = upper('URN');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFHISTORYROUTELOGTABLE add URN NVARCHAR2(63)  NULL ');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCurrentRouteLogTable') and upper(column_name) = upper('URN');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFCurrentRouteLogTable add URN NVARCHAR2(63)  NULL ');
	END;
	/*Case registeration Name changes requirement ends here*/
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFWebServiceTable') and upper(column_name) = upper('OrderId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFWebServiceTable add OrderId INT DEFAULT 1 NOT NULL ');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName2
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFWebServiceTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFWebServiceTable Drop Constraint ' || TO_CHAR(v_constraintName2);
		EXECUTE IMMEDIATE 'Alter Table WFWebServiceTable Add Constraint ' || TO_CHAR(v_constraintName2) || ' Primary Key (ProcessDefId, ActivityId, ExtMethodIndex)';		
		
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is not Created in WFWebServiceTable'')';
	END;
	
/*Error while checkin/register if TableName and ForeignKey in VarRelationtable has length greater than 30*/
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFAutoGenInfoTable') and upper(column_name) = upper('TableName');
		If(existsFlag=1) THEN
		 BEGIN
			EXECUTE IMMEDIATE ('alter table WFAutoGenInfoTable MODIFY TableName NVARCHAR2(256)');
		 END;
		 END IF;
	END;	
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFAutoGenInfoTable') and upper(column_name) = upper('ColumnName');
		If(existsFlag=1) THEN
		 BEGIN
			EXECUTE IMMEDIATE ('alter table WFAutoGenInfoTable MODIFY ColumnName NVARCHAR2(256)');
		 END;
		 END IF;
	END;
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskPreCheckTable') and upper(column_name) = upper('ProcessDefId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('alter table WFTaskPreCheckTable Add ProcessDefId integer');
		
	END;
	
	BEGIN
	EXECUTE IMMEDIATE('UPDATE PROCESSDEFTABLE SET FormViewerApp=''J'' where FormViewerApp=''A'' ');
	end ;
	
	BEGIN
	EXECUTE IMMEDIATE('update WFActionStatusTable set Type=''S'',Status=''Y'' where ActionId>=700 and ActionId<=714 ');
	end ;
	
	BEGIN
		existsFlag :=0;	
		SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('GTempSearchTable');
		If(existsFlag=1) THEN 
			EXECUTE IMMEDIATE ('drop tABLE GTempSearchTable');
		EXECUTE IMMEDIATE('	CREATE GLOBAL TEMPORARY TABLE GTempSearchTable(
						PROCESSINSTANCEID		NVARCHAR2(63),
						QUEUENAME			NVARCHAR2(63),
						PROCESSNAME			NVARCHAR2(30),
						PROCESSVERSION			NUMBER,
						ACTIVITYNAME			NVARCHAR2(30),
						STATENAME			NVARCHAR2(255),
						CHECKLISTCOMPLETEFLAG		NVARCHAR2(1),
						ASSIGNEDUSER			NVARCHAR2(63),
						ENTRYDATETIME			DATE,
						VALIDTILL                       DATE,
						WORKITEMID			NUMBER,
						PRIORITYLEVEL			NUMBER,
						PARENTWORKITEMID		NUMBER,
						PROCESSDEFID			NUMBER,
						ACTIVITYID			NUMBER,
						INSTRUMENTSTATUS		NVARCHAR2(1),
						LOCKSTATUS			NVARCHAR2(1),
						LOCKEDBYNAME			NVARCHAR2(63),
						CREATEDBYNAME			NVARCHAR2(63),
						CREATEDDATETIME			DATE,
						LOCKEDTIME			DATE,
						INTRODUCTIONDATETIME		DATE,
						INTRODUCEDBY			NVARCHAR2(63),
						ASSIGNMENTTYPE			NVARCHAR2(1),
						PROCESSINSTANCESTATE		NUMBER,
						QUEUETYPE			NVARCHAR2(1),
						STATUS				NVARCHAR2(255),
						Q_QUEUEID			NUMBER,
						TURNAROUNDTIME			NUMBER,
						REFERREDBY			NUMBER,
						REFERREDTO			NUMBER,
						EXPECTEDPROCESSDELAYTIME	DATE,
						EXPECTEDWORKITEMDELAYTIME	DATE,
						PROCESSEDBY			NVARCHAR2(63),
						Q_USERID			NUMBER,
						WORKITEMSTATE			NUMBER,
						ACTIVITYTYPE	    INT,
						URN		NVARCHAR2(63),
						VAR_INT1			SMALLINT,
						VAR_INT2			SMALLINT,
						VAR_INT3			SMALLINT,
						VAR_INT4			SMALLINT,
						VAR_INT5			SMALLINT,
						VAR_INT6			SMALLINT,
						VAR_INT7			SMALLINT,
						VAR_INT8			SMALLINT,
						VAR_FLOAT1			NUMERIC(15, 2),
						VAR_FLOAT2			NUMERIC(15, 2),
						VAR_DATE1			DATE,
						VAR_DATE2			DATE,
						VAR_DATE5			DATE,
						VAR_DATE6			DATE,
						VAR_DATE3			DATE,
						VAR_DATE4			DATE,
						VAR_LONG1			INT,
						VAR_LONG2			INT,
						VAR_LONG3			INT,
						VAR_LONG4			INT,
						VAR_LONG5			INT,
						VAR_LONG6			INT,
						VAR_STR1			NVARCHAR2(255),
						VAR_STR2			NVARCHAR2(255),
						VAR_STR3			NVARCHAR2(255),
						VAR_STR4			NVARCHAR2(255),
						VAR_STR5			NVARCHAR2(255),
						VAR_STR6			NVARCHAR2(255),
						VAR_STR7			NVARCHAR2(255),
						VAR_STR8			NVARCHAR2(255),
						VAR_STR9			NVARCHAR2(255),
						VAR_STR10			NVARCHAR2(255),
						VAR_STR11			NVARCHAR2(255),
						VAR_STR12			NVARCHAR2(255),
						VAR_STR13			NVARCHAR2(255),
						VAR_STR14			NVARCHAR2(255),
						VAR_STR15			NVARCHAR2(255),
						VAR_STR16			NVARCHAR2(255),
						VAR_STR17			NVARCHAR2(255),
						VAR_STR18			NVARCHAR2(255),
						VAR_STR19			NVARCHAR2(255),
						VAR_STR20			NVARCHAR2(255),
						VAR_REC_1			NVARCHAR2(255),
						VAR_REC_2			NVARCHAR2(255),
						VAR_REC_3			NVARCHAR2(255),
						VAR_REC_4			NVARCHAR2(255),
						VAR_REC_5			NVARCHAR2(255),
						PRIMARY KEY			(ProcessInstanceId, WorkitemId)
						) ON COMMIT PRESERVE ROWS ');
		END IF;
		
	END;
		existsFlag :=0;	
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFInitiationAgentReportTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFInitiationAgentReportTable(
							LogId INT ,
							EmailReceivedDateTime DATE,
							MailFrom NVARCHAR2(2000),
							MailTo NVARCHAR2(2000),
							MailSubject NVARCHAR2(2000),
							MailCC NVARCHAR2(2000),
							EmailFileName NVARCHAR2(200),
							EMailStatus NVARCHAR2(100),
							ActionDateTime DATE,
							ProcessInstanceId NVARCHAR2(200),
							ActionDescription NVARCHAR2(2000),
							ProcessDefId INT,
							ActivityId INT
							)';	
		--dbms_output.put_line ('Table WFInitiationAgentReportTable Created successfully');
		END;
	/* seq_userlogid for Bug 76093 - EAP7+sql: User filter is not working for 'Set preferences' audit log option */
	existsFlag :=0;
    BEGIN
		SELECT 1 INTO existsFlag 
				FROM USER_SEQUENCES  
				WHERE Upper(SEQUENCE_NAME) = UPPER('seq_userlogid');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE seq_userlogid START WITH 1 INCREMENT BY 1 NOCACHE';
			--dbms_output.put_line ('Sequence seq_userlogid Created successfully');
    END;

/* seq_userlogid for Bug 76093 - EAP7+sql: User filter is not working for 'Set preferences' audit log option */

	existsFlag :=0;
    BEGIN
		SELECT 1 INTO existsFlag 
				FROM USER_SEQUENCES  
				WHERE Upper(SEQUENCE_NAME) = UPPER('seq_userlogid');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE seq_userlogid START WITH 1 INCREMENT BY 1 NOCACHE';
			--dbms_output.put_line ('Sequence seq_userlogid Created successfully');
		
    END;
	
	/* Bug 77151*/
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTASKRULEPRECONDITIONTABLE') and upper(column_name) = upper('Param1');
		If(existsFlag=1) THEN
		 BEGIN
			EXECUTE IMMEDIATE ('ALTER TABLE WFTASKRULEPRECONDITIONTABLE MODIFY Param1 NVARCHAR2(255)');
			--dbms_output.put_line ('Table WFTASKRULEPRECONDITIONTABLE altered successfully');
		 END;
		 END IF;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
			BEGIN
				EXECUTE IMMEDIATE ('ALTER TABLE WFTASKRULEPRECONDITIONTABLE ADD Param1 NVARCHAR2(255)');
				--dbms_output.put_line ('Table TEMPLATEDEFINITIONTABLE altered successfully');
			END;
	END;
	
	/* Added index on URN in WFInstrumentTable*/
	BEGIN 
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX13_WFINSTRUMENTTABLE');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX  IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (URN)';
		END;
	END;
	/* Added index on URN in WFInstrumentTable*/
	
	BEGIN 
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag
			FROM WFSYSTEMPROPERTIESTABLE 
			WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SHAREPOINTFLAG'',''N'')';
		END;
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = 'WFDMSLIBRARY' and upper(column_name) = 'DOMAINNAME';
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('alter table WFDMSLIBRARY ADD DOMAINNAME	NVARCHAR2(64)	NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = 'WFARCHIVEINSHAREPOINT' and upper(column_name) = 'DOMAINNAME';
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('alter table WFARCHIVEINSHAREPOINT ADD DOMAINNAME	NVARCHAR2(64)	NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = 'WFSHAREPOINTDOCASSOCTABLE' and upper(column_name) = 'TARGETDOCNAME';
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('alter table WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME	NVARCHAR2(255)	NULL');
	END;
	
	/*Making entry in WFCabVersionTable for iBPS_3.0_SP1*/	
	BEGIN
		 existsFlag :=0;	
		 SELECT Count(1) INTO existsFlag FROM WFCabVersionTable WHERE UPPER(cabVersion) = UPPER('iBPS_4.0');
		 If(existsFlag=0) THEN
		 BEGIN
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_4.0', cabVersionId.nextVal, SYSDATE, SYSDATE, N'iBPS_4.0', N'Y');
		 END;
		 END IF;
	END;
	
END;
~
CALL Upgrade()
~

DROP PROCEDURE Upgrade
~
