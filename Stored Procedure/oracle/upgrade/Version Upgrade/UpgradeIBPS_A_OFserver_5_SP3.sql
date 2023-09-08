/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: TableScript.sql (Oracle Server)
	Author						: Satyanarayan Sharma
	Date written (DD/MM/YYYY)	: 05/12/2022
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp2_01
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))

 ______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE PROCEDURE TableScript AS
	v_existsFlag INT;
	existsFlag	INTEGER:=0;
BEGIN
	BEGIN
		v_existsFlag := 0;
		SELECT COUNT(1) INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name) = UPPER('IDX1_WFInitiationAgentReportTable') AND upper(table_name) = upper('WFInitiationAgentReportTable');
		IF(v_existsFlag <= 0)THEN
			EXECUTE IMMEDIATE('CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable(processDefId, IAId, AccountName, EmailFileName)');
		END IF;
	END;

	
	BEGIN
	       existsflag :=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('PRINTFAXEMAILTABLE') 
			AND COLUMN_NAME = UPPER('CoverSheetBuffer');
			EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE DROP COLUMN CoverSheetBuffer ';
			DBMS_OUTPUT.PUT_LINE('Column CoverSheetBuffer Dropped');			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Column Does Not exist');
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE UPPER (TABLE_NAME)=UPPER('WFINSTRUMENTTABLE') 
		AND 
		UPPER(COLUMN_NAME)=UPPER('ProcessingTime');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE ADD ProcessingTime INT NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskUserAssocTable') and upper(column_name) = upper('FilterId');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFTaskUserAssocTable ADD  FilterId INT DEFAULT -1 NOT NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCOMPLETEUSERVIEW') and upper(column_name) = upper('UserIndex');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('CREATE OR REPLACE VIEW WFCOMPLETEUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX
	FROM PDBUSER');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFUSERVIEW') and upper(column_name) = upper('UserIndex');
			EXECUTE IMMEDIATE ('CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX   ) 
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX
	FROM PDBUSER where deletedflag = ''N'' and UserAlive = ''Y'' and expirydatetime > sysdate');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('WFUSERVIEW Does Not exist');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTaskUserFilterTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFTaskUserFilterTable( 				
			    ProcessDefId INT NOT NULL,
				FilterId INT NOT NULL,
				RuleType NVARCHAR2(1) NOT NULL,
				RuleOrderId INT  NOT NULL,
				RuleId INT  NOT NULL,
				ConditionOrderId INT  NOT NULL,
				Param1 NVARCHAR2(255) NOT NULL,
				Type1 NVARCHAR2(1) NOT NULL,
				ExtObjID1 INT  NULL,
				VariableId_1 INT  NOT NULL,
				VarFieldId_1 INT  NULL,
				Param2 NVARCHAR2(255) NULL,
				Type2 NVARCHAR2(1)  NULL,
				ExtObjID2 INT  NULL,
				VariableId_2 INT  NULL,
				VarFieldId_2 INT  NULL,
				Operator INT NULL,
				LogicalOp INT  NOT NULL  
				)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 1 FAILED');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskDefTable') and upper(column_name) = upper('InitiateWI');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFTaskDefTable ADD InitiateWI nvarchar2(1) Default ''Y'' NOT NULL');
	END;
	
	BEGIN
			
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCurrentRouteLogTable') and upper(column_name) = upper('ProcessingTime');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFCurrentRouteLogTable ADD ProcessingTime INT NULL');
	END;
	
    BEGIN
			
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCurrentRouteLogTable') and upper(column_name) = upper('TAT');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFCurrentRouteLogTable ADD TAT INT NULL');
	END;	
	
     BEGIN
			
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFCurrentRouteLogTable') and upper(column_name) = upper('DelayTime');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFCurrentRouteLogTable ADD DelayTime INT NULL');
	END;
	
    BEGIN
		
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFHISTORYROUTELOGTABLE') and upper(column_name) = upper('ProcessingTime');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFHISTORYROUTELOGTABLE ADD ProcessingTime INT NULL');
	END;	
	
    BEGIN
		
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFHISTORYROUTELOGTABLE') and upper(column_name) = upper('TAT');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFHISTORYROUTELOGTABLE ADD TAT INT NULL');
	END;	
	
    BEGIN
			
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFHISTORYROUTELOGTABLE') and upper(column_name) = upper('DelayTime');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFHISTORYROUTELOGTABLE ADD DelayTime INT NULL');
	END;
	/*chnages for QueueHistoryTable*/
    BEGIN
		
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QueueHistoryTable') and upper(column_name) = upper('ProcessingTime');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table QueueHistoryTable ADD ProcessingTime INT NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('ChildProcessInstanceId');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD  ChildProcessInstanceId NVARCHAR2(63) NULL ');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFTaskStatusTable') and upper(column_name) = upper('ChildWorkitemId');
		EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE ('Alter table WFTaskStatusTable ADD  ChildWorkitemId INT ');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEDEFTABLE') and upper(column_name) = upper('QueueType');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE('UPDATE QUEUEDEFTABLE set QueueType = N''G'', QueueFilter = null where QueueType = N''T''');
		END IF;
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEDEFTABLE') and upper(column_name) = upper('QueueType');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE('UPDATE QUEUEDEFTABLE set QueueType = N''N'' where QueueType = N''M''');
		END IF;
	END;
	
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFSYSTEMSERVICESTABLE') and upper(column_name) = upper('APPSERVERID');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE('DELETE FROM WFSYSTEMSERVICESTABLE WHERE APPSERVERID IS NULL');
		END IF;
	END;
	
	
     BEGIN
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_INDEXES WHERE INDEX_NAME = UPPER('IDX14_WFINSTRUMENTTABLE');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE 'DROP Index IDX14_WFINSTRUMENTTABLE';
		END IF;
		EXECUTE IMMEDIATE 'CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)';
		
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_INDEXES WHERE INDEX_NAME = UPPER('IDX15_WFINSTRUMENTTABLE');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE 'DROP Index IDX15_WFINSTRUMENTTABLE';
		END IF;
		EXECUTE IMMEDIATE 'CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId,WorkitemId)';
		
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_INDEXES WHERE INDEX_NAME = UPPER('IDX16_WFINSTRUMENTTABLE');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE 'DROP Index IDX16_WFINSTRUMENTTABLE';
		END IF;
		EXECUTE IMMEDIATE 'CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)';
		
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_INDEXES WHERE INDEX_NAME = UPPER('IDX17_WFINSTRUMENTTABLE');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE 'DROP Index IDX17_WFINSTRUMENTTABLE';
		END IF;
		EXECUTE IMMEDIATE 'CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)';
		
	END;
	BEGIN
		existsFlag :=0;		
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('USERDIVERSIONTABLE');
		IF(existsFlag > 0)THEN
			EXECUTE IMMEDIATE ('ALTER TABLE USERDIVERSIONTABLE ADD  ProcessDefId int');
			EXECUTE IMMEDIATE ('ALTER TABLE USERDIVERSIONTABLE ADD  ActivityId int');
			EXECUTE IMMEDIATE ('ALTER TABLE USERDIVERSIONTABLE ADD  ProcessName nvarchar(30)');
			EXECUTE IMMEDIATE ('ALTER TABLE USERDIVERSIONTABLE ADD  ActivityName nvarchar(30)');
			EXECUTE IMMEDIATE ('ALTER TABLE USERDIVERSIONTABLE ADD  DiversionId int');
			EXECUTE IMMEDIATE ('CREATE SEQUENCE DiversionId INCREMENT BY 1 START WITH 1 NOCACHE');
			EXECUTE IMMEDIATE ('UPDATE USERDIVERSIONTABLE SET ProcessdefId=0, Activityid=0, DiversionId=DiversionId.nextval');
		END IF;
	END;
	
END;

~
call TableScript()

~

DROP PROCEDURE TableScript

~