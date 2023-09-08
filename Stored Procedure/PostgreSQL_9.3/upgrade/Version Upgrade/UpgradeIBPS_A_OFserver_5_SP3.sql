/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade.sql
	Author						: Satyanarayan Sharma
	Date written (DD/MM/YYYY)	: 05/12/2022
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp2_01
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))
18/06/2023 Satyanarayan Sharma Bug 124581 - iBPS5.0SP3+Postgre-----In WFATTRIBUTEMESSAGETABLE and WFATTRIBUTEMESSAGEHISTORYTABLE for ActionDateTime column datatype changed from DATE to TIMESTAMP.
 ______________________________________________________________________________________________________________________-*/


CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE
	v_existFlag			INTEGER;
BEGIN
  BEGIN
	  v_existFlag := 0;
	  SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFInitiationAgentReportTable') and upper(indexname) = upper('IDX1_WFInitiationAgentReportTable');
	  IF(NOT FOUND) THEN 
		EXECUTE('CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable(processDefId, IAId, AccountName, EmailFileName)');
	  END IF;
   END;
   
   BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('PRINTFAXEMAILTABLE') and UPPER(column_name)=UPPER('CoverSheetBuffer');
		IF(FOUND) THEN 
			Execute ('Alter table PRINTFAXEMAILTABLE DROP COLUMN CoverSheetBuffer');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('ProcessingTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFINSTRUMENTTABLE ADD ProcessingTime Int  NULL');
		END IF;
	END;
	/*chnages for QueueHistoryTable*/
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('QueueHistoryTable') and UPPER(column_name)=UPPER('ProcessingTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table QueueHistoryTable ADD ProcessingTime Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFCURRENTROUTELOGTABLE') and UPPER(column_name)=UPPER('ProcessingTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFCURRENTROUTELOGTABLE ADD ProcessingTime Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFCURRENTROUTELOGTABLE') and UPPER(column_name)=UPPER('TAT');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFCURRENTROUTELOGTABLE ADD TAT Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFCURRENTROUTELOGTABLE') and UPPER(column_name)=UPPER('DelayTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFCURRENTROUTELOGTABLE ADD DelayTime Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFHISTORYROUTELOGTABLE') and UPPER(column_name)=UPPER('ProcessingTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFHISTORYROUTELOGTABLE ADD ProcessingTime Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFHISTORYROUTELOGTABLE') and UPPER(column_name)=UPPER('TAT');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFHISTORYROUTELOGTABLE ADD TAT Int  NULL');
		END IF;
	END;
	
	BEGIN
	
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFHISTORYROUTELOGTABLE') and UPPER(column_name)=UPPER('DelayTime');
		IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER Table WFHISTORYROUTELOGTABLE ADD DelayTime Int  NULL');
		END IF;
	END;
	
	
	
	 BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFTaskUserAssocTable') and UPPER(column_name)=UPPER('FilterId');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskUserAssocTable ADD FilterId INTEGER DEFAULT -1 NOT NULL');
		END IF;
	END; 
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFCOMPLETEUSERVIEW') and UPPER(column_name)=UPPER('UserIndex');
		IF(NOT FOUND) THEN 
			Execute ('CREATE OR REPLACE VIEW WFCOMPLETEUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''''))) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  
	FROM PDBUSER ');
		END IF;
	END; 
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFUSERVIEW') and UPPER(column_name)=UPPER('UserIndex');
		IF(FOUND) THEN 
			Execute ('CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX   ) 
AS 
	SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''''))) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
	FROM PDBUSER where deletedflag = ''N'' and UserAlive=''Y'' and expirydatetime > CURRENT_TIMESTAMP ');
		END IF;
	END; 
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = UPPER('WFTaskUserFilterTable');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFTaskUserFilterTable( 
				ProcessDefId INTEGER NOT NULL,
				FilterId INTEGER NOT NULL,
				RuleType VARCHAR(1) NOT NULL,
				RuleOrderId INTEGER  NOT NULL,
				RuleId INTEGER  NOT NULL,
				ConditionOrderId INTEGER  NOT NULL,
				Param1 VARCHAR(255) NOT NULL,
				Type1 VARCHAR(1) NOT NULL,
				ExtObjID1 INTEGER  NULL,
				VariableId_1 INTEGER  Not NULL,
				VarFieldId_1 INTEGER  NULL,
				Param2 VARCHAR(255) NULL,
				Type2 VARCHAR(1)  NULL,
				ExtObjID2 INTEGER  NULL,
				VariableId_2 INTEGER  NULL,
				VarFieldId_2 INTEGER  NULL,
				Operator INTEGER NULL,
				LogicalOp INTEGER  NOT NULL
			)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFTaskDefTable') and UPPER(column_name)=UPPER('InitiateWI');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskDefTable ADD InitiateWI VARCHAR(1) Default ''Y'' NOT NULL');
		END IF;
	END; 
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFATTRIBUTEMESSAGETABLE') and UPPER(column_name)=UPPER('ActionDateTime') and UPPER(DATA_TYPE)=UPPER('DATE');
		IF(FOUND) THEN 
			Execute ('Alter table WFATTRIBUTEMESSAGETABLE ALTER COLUMN ActionDateTime TYPE TIMESTAMP');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFATTRIBUTEMESSAGEHISTORYTABLE') and UPPER(column_name)=UPPER('ActionDateTime') and UPPER(DATA_TYPE)=UPPER('DATE');
		IF(FOUND) THEN 
			Execute ('Alter table WFATTRIBUTEMESSAGEHISTORYTABLE ALTER COLUMN ActionDateTime TYPE TIMESTAMP');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('ChildProcessInstanceId');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskStatusTable ADD ChildProcessInstanceId VARCHAR(63)	NULL ');
		END IF;
	END; 
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFTaskStatusTable') and UPPER(column_name)=UPPER('ChildWorkitemId');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFTaskStatusTable ADD ChildWorkitemId INT ');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEDEFTABLE') and UPPER(column_name)=UPPER('QueueType');
		IF(FOUND) THEN 
			Execute ('UPDATE QUEUEDEFTABLE set QueueType = N''G'', QueueFilter = null where QueueType = N''T''');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEDEFTABLE') and UPPER(column_name)=UPPER('QueueType');
		IF(FOUND) THEN 
			Execute ('UPDATE QUEUEDEFTABLE set QueueType = N''N'' where QueueType = N''M''');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFSystemServicesTable') and UPPER(column_name)=UPPER('AppServerId');
		IF(FOUND) THEN 
			Execute ('Delete from WFSystemServicesTable where AppServerId is NULL');
		END IF;
	END;
	
	BEGIN 
    v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX14_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX14_WFINSTRUMENTTABLE');
	END IF;
	EXECUTE  ('CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)');
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX15_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX15_WFINSTRUMENTTABLE');
	END IF;
	EXECUTE  ('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId,WorkitemId)');
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX16_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX16_WFINSTRUMENTTABLE');
	END IF;
	EXECUTE  ('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)');
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX17_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX17_WFINSTRUMENTTABLE');
	END IF;
	EXECUTE  ('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)');
	
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('USERDIVERSIONTABLE');
		IF(FOUND) THEN 
			Execute ('ALTER TABLE USERDIVERSIONTABLE ADD COLUMN ProcessDefId int');
			Execute ('ALTER TABLE USERDIVERSIONTABLE ADD COLUMN ActivityId int');
			Execute ('ALTER TABLE USERDIVERSIONTABLE ADD COLUMN ActivityName varchar(30)');
			Execute ('ALTER TABLE USERDIVERSIONTABLE ADD COLUMN ProcessName varchar(30)');
			Execute ('ALTER TABLE USERDIVERSIONTABLE ADD COLUMN DiversionId INT');
			Execute ('CREATE SEQUENCE DiversionId INCREMENT BY 1 START WITH 1 ');
			Execute ('UPDATE USERDIVERSIONTABLE SET ProcessdefId=0, Activityid=0, DiversionId = nextval(''DiversionId'')');
		END IF;
	END;
	
END;
$$LANGUAGE plpgsql;
~
SELECT Upgrade();
~
DROP FUNCTION Upgrade();
~