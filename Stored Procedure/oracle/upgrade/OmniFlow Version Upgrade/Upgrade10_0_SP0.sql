/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
05/06/2017		Sanal Grover		Bug 69853 - WorkinprocessTable and Workwithpstable handling in version upgrade for IBPS upgrade.
*/
create or replace
PROCEDURE Upgrade AS
existsFlag          INT;
v_fields			VARCHAR2(4000);
v_ErrorMessage	    VARCHAR2(100);
v_TableName		    VARCHAR2(50);
v_ViewName		    VARCHAR2(50);
v_ConstarintName	VARCHAR2(100);
v_DepricatedTables  VARCHAR2(200);
v_ProcessDefID		INT;
v_SeqStartNo		INT;
Type Ref_Cur IS REF CURSOR;
ConstraintsCursor   Ref_Cur;
TableCursor         Ref_Cur;
v_SeqName       		VARCHAR2(50);
v_IsArray       	 	VARCHAR2(1);
v_ComplexTable  	  	VARCHAR2(100);
v_ParentObject     		VARCHAR2(100);
v_CurrentSeqNo  	  INT;
v_ExtObjID      	  INT;
v_ForignKey     	  VARCHAR2(50);
v_Query         	  VARCHAR2(4000);
v_cabVersion		  VARCHAR2(50);
v_insertionorderid	  VARCHAR2(50);
v_crtSeqLastNum		  INT;
v_count				  INT;
v_logStatus 			BOOLEAN;
v_scriptName        	NVARCHAR2(100) := 'Upgrade10_SP0';
		
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
			--dbms_output.put_line ('dbQuery '|| dbQuery);	
		EXECUTE IMMEDIATE dbQuery using v_stepNumber,v_scriptName,v_stepDetails;
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogInsert completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogSkip(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogUpdate(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery1 VARCHAR2(1000);
	dbQuery2 VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery1 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery1);
		EXECUTE IMMEDIATE (dbQuery2);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
	FUNCTION LogUpdateError(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN;
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdateError completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
BEGIN
	v_logStatus := LogInsert(1,'Checking Cabinet is at service pack 6 level or not');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT COUNT(*) INTO existsFlag
		  FROM WFCabVersionTable where cabVersion = '9.0_SU6' AND ROWNUM <= 1;
			IF(existsFlag = 0)
			THEN
				v_logStatus := LogSkip(1);
				BEGIN
				  DBMS_OUTPUT.PUT_LINE ('UPGRADE Failed. Cabinet is not at Service Pack 6 level');
				  RETURN;
				END;
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
		v_logStatus := LogUpdateError(1);   
		raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);
		
	v_logStatus := LogInsert(2,'Checking Message Agent is running or not');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT COUNT(*) INTO existsFlag
		  FROM wfmessagetable;
			IF(existsFlag > 0)
			THEN
				v_logStatus := LogSkip(2);
				BEGIN
				  DBMS_OUTPUT.PUT_LINE ('UPGRADE Failed. Run Message Agent first before upgrade execution');
				  RETURN;
				END;
			END IF;
		END;
		EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);	
		

	/*    
		BEGIN
		  select 1 into existsFlag
		  from Workinprocesstable;
		IF(existsFlag = 1)
		  THEN
			DBMS_OUTPUT.PUT_LINE ('UPGRADE Failed. Some workitem locked by user');
			ROLLBACK 'DataMovement';
			RETURN;
		END IF;
		END;
		
		BEGIN
		  SELECT 1 INTO existsFlag
		  FROM WorkWithPSTable;
		IF(existsFlag = 1)
		  THEN
			DBMS_OUTPUT.PUT_LINE ('UPGRADE Failed. Some workitem locked by PS');
			ROLLBACK 'DataMovement';
			RETURN;
		END IF;
		END;
	*/
	v_logStatus := LogInsert(3,'CREATING TABLE WFINSTRUMENTTABLE');
	BEGIN
		BEGIN
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WFINSTRUMENTTABLE';
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(3);
			EXECUTE IMMEDIATE ('CREATE TABLE WFINSTRUMENTTABLE (
			ProcessInstanceID			NVARCHAR2 (63)  NOT NULL ,
			ProcessDefID				INT		NOT NULL,
			Createdby					INT		NOT NULL ,
			CreatedByName				NVARCHAR2(63)	NULL ,
			Createddatetime				DATE		NOT NULL ,
			Introducedbyid				INT		NULL ,
			Introducedby				NVARCHAR2(63)	NULL ,
			IntroductionDatetime		DATE		NULL ,
			ProcessInstanceState		INT		NULL ,
			ExpectedProcessDelay		DATE		NULL ,
			IntroducedAt				NVARCHAR2(30)	NOT NULL ,
			WorkItemId					INT		NOT NULL ,
			VAR_INT1					SMALLINT	NULL ,
			VAR_INT2					SMALLINT	NULL ,
			VAR_INT3					SMALLINT	NULL ,
			VAR_INT4					SMALLINT	NULL ,
			VAR_INT5					SMALLINT	NULL ,
			VAR_INT6					SMALLINT	NULL ,
			VAR_INT7					SMALLINT	NULL ,
			VAR_INT8					SMALLINT	NULL ,
			VAR_FLOAT1					NUMERIC(15, 2)	NULL ,
			VAR_FLOAT2					NUMERIC(15, 2)	NULL ,
			VAR_DATE1					DATE		NULL ,
			VAR_DATE2					DATE		NULL ,
			VAR_DATE3					DATE		NULL ,
			VAR_DATE4					DATE		NULL ,
			VAR_LONG1					INT		NULL ,
			VAR_LONG2					INT		NULL ,
			VAR_LONG3					INT		NULL ,
			VAR_LONG4					INT		NULL ,
			VAR_STR1					NVARCHAR2(255)  NULL ,
			VAR_STR2					NVARCHAR2(255)  NULL ,
			VAR_STR3					NVARCHAR2(255)  NULL ,
			VAR_STR4					NVARCHAR2(255)  NULL ,
			VAR_STR5					NVARCHAR2(255)  NULL ,
			VAR_STR6					NVARCHAR2(255)  NULL ,
			VAR_STR7					NVARCHAR2(255)  NULL ,
			VAR_STR8					NVARCHAR2(255)  NULL ,
			VAR_REC_1					NVARCHAR2(255)  NULL ,
			VAR_REC_2					NVARCHAR2(255)  NULL ,
			VAR_REC_3					NVARCHAR2(255)  NULL ,
			VAR_REC_4					NVARCHAR2(255)  NULL ,
			VAR_REC_5					NVARCHAR2(255)  NULL ,
			InstrumentStatus			NVARCHAR2(1)	NULL, 
			CheckListCompleteFlag		NVARCHAR2(1)	NULL ,
			SaveStage					NVARCHAR2(30)	NULL ,
			HoldStatus					INT		NULL,
			Status						NVARCHAR2(255)  NULL ,
			ReferredTo					INT		NULL ,
			ReferredToName				NVARCHAR2(63)	NULL ,
			ReferredBy					INT		NULL ,
			ReferredByName				NVARCHAR2(63)	NULL ,
			ChildProcessInstanceId		NVARCHAR2(63)	NULL,
			ChildWorkitemId				INT,
			ParentWorkItemID			INT,
			CalendarName    			NVARCHAR2(255) NULL,  
			ProcessName 				NVARCHAR2(30)	NOT NULL ,
			ProcessVersion  			SMALLINT,
			LastProcessedBy 			INT		NULL ,
			ProcessedBy					NVARCHAR2(63)	NULL,	
			ActivityName 				NVARCHAR2(30)	NULL ,
			ActivityId 					INT		NULL ,
			EntryDateTime 				DATE		NULL ,
			AssignmentType				NVARCHAR2 (1)	NULL ,
			CollectFlag					NVARCHAR2 (1)	NULL ,
			PriorityLevel				SMALLINT	NULL ,
			ValidTill					DATE		NULL ,
			Q_StreamId					INT		NULL ,
			Q_QueueId					INT		NULL ,
			Q_UserId					INT	NULL ,
			AssignedUser				NVARCHAR2(63)	NULL,	
			FilterValue					INT		NULL ,
			WorkItemState				INT		NULL ,
			Statename 					NVARCHAR2(255),
			ExpectedWorkitemDelay		DATE		NULL ,
			PreviousStage				NVARCHAR2 (30)  NULL ,
			LockedByName				NVARCHAR2(63)	NULL,	
			LockStatus					NVARCHAR2(1) NOT NULL,
			RoutingStatus				NVARCHAR2(1) NOT NULL,	
			LockedTime					DATE		NULL , 
			Queuename 					NVARCHAR2(63),
			Queuetype 					NVARCHAR2(1),
			NotifyStatus				NVARCHAR2(1),	  
			Guid 						NUMBER,
			NoOfCollectedInstances		INT DEFAULT 0 NOT NULL,
			IsPrimaryCollected			NVARCHAR2(1) NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N'')),
			ExportStatus				NVARCHAR2(1) DEFAULT ''N'',
			ProcessVariantId 			INT DEFAULT(0) NOT NULL ,
			Q_DivertedByUserId			INT NULL ,
			CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
			  (
				ProcessInstanceID,WorkitemId
			  )
			)');
		  DBMS_OUTPUT.PUT_LINE ('Table WFInstrumentTable created successfully...');
     END; 
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);  

	v_logStatus := LogInsert(4,'Creating Indexes on WFINSTRUMENTTABLE ');
	BEGIN
    BEGIN
		v_logStatus := LogSkip(4);
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX1_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2)');
		END IF;
		 
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX2_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)');
		END IF;
		 
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX3_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)');
		END IF;
		
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX4_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('CREATE INDEX IDX4_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (UPPER(ProcessInstanceId),WorkitemId)');
		END IF;
		
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX5_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId  ,  WorkItemState  , LockStatus  ,RoutingStatus,EntryDATETIME)');
		END IF;
		 
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX6_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (ProcessDefId, RoutingStatus, LockStatus)');
		END IF;
		 
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX7_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)');
		END IF; 
		 
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX8_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)');
		END IF; 
		  
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX9_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QUEUEID, LOCKSTATUS,ENTRYDATETIME,PROCESSINSTANCEID,WORKITEMID)');
		END IF;
		  
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX10_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(childprocessinstanceid, childworkitemid)');
		END IF;
		
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX11_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)');
		END IF;	  
		
		SELECT COUNT(*) INTO v_count FROM user_indexes WHERE index_name = 'IDX12_WFINSTRUMENTTABLE';
		IF v_count = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE ,VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)');
		END IF;	  
		
		  
		  DBMS_OUTPUT.PUT_LINE ('Indexes created on WFINSTRUMENTTABLE...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4);   
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);        

	 
	v_logStatus := LogInsert(5,'CREATING INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)');
	BEGIN
			/*Creating  New Indexes*/
		
		existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_ActivityTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(5);
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)';
			dbms_output.put_line ('Index on ActivityType of ActivityTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5); 

	v_logStatus := LogInsert(6,'CREATING INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable(ProcessInstanceId, ActionDateTime, LogID)');
	/* BEGIN
		
		 DECLARE 
		existsflag INT;
		CRouteLogTableFlag INT;
		WFCRouteLogTableFlag INT;
		BEGIN
      CRouteLogTableFlag :=0;
      WFCRouteLogTableFlag :=0;
			select count(1) into CRouteLogTableFlag from user_tables where table_name = upper('CurrentRouteLogTable');
			select count(1) into WFCRouteLogTableFlag from user_tables where table_name = upper('WFCurrentRouteLogTable');

			If CRouteLogTableFlag = 1 Then
				dbms_output.put_line('CurrentRouteLogTable Exists');
				BEGIN 
					existsflag :=0;
					SELECT 1 INTO existsFlag 
					FROM DUAL 
					WHERE 
						NOT EXISTS( 
							SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_CRouteLogTable')
						);  
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END; 
				IF existsFlag = 1 THEN
				BEGIN
					v_logStatus := LogSkip(6);
					EXECUTE IMMEDIATE 'CREATE INDEX IDX4_CRouteLogTable ON CurrentRouteLogTable(ProcessInstanceId, ActionDateTime, LogID)';
					dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of CurrentRouteLogTable created successfully');
				EXCEPTION 
					WHEN OTHERS THEN 
					BEGIN 
						IF SQLCODE <> -1408 THEN
						BEGIN
							RAISE;
						END;
						END IF;
					END;
				END;
				END IF;
			end if;

			If WFCRouteLogTableFlag = 1 Then
				dbms_output.put_line('WFCurrentRouteLogTable Exists');
				BEGIN 
					existsflag :=0;
					SELECT 1 INTO existsFlag 
					FROM DUAL 
					WHERE 
						NOT EXISTS( 
							SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_CRouteLogTable')
						);  
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END; 
				IF existsFlag = 1 THEN
				BEGIN
					dbms_output.put_line ('before');
					v_logStatus := LogSkip(6);
					dbms_output.put_line ('before');
					EXECUTE IMMEDIATE 'CREATE INDEX IDX4_CRouteLogTable ON CurrentRouteLogTable(ProcessInstanceId, ActionDateTime, LogID)';
					dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of CurrentRouteLogTable created successfully');
				EXCEPTION 
					WHEN OTHERS THEN 
					BEGIN 
						IF SQLCODE <> -1408 THEN
						BEGIN
							RAISE;
						END;
						END IF;
					END;
				END;
				END IF;
			end if; 

		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6);    
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	*/
	v_logStatus := LogUpdate(6);	
	
	v_logStatus := LogInsert(7,'CREATING INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE(ProcessInstanceId, ActionDateTime, LogID)');
	/*BEGIN
		
		 existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_WFHRouteLogTABLE')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(7);
			EXECUTE IMMEDIATE 'CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE(ProcessInstanceId, ActionDateTime, LogID)';
			dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of WFHISTORYROUTELOGTABLE created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED'); 
	END;*/
	v_logStatus := LogUpdate(7);	
 
	v_logStatus := LogInsert(8,'CREATING INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)');
	BEGIN
			existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueHistoryTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(8);
			EXECUTE IMMEDIATE 'CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)';
			dbms_output.put_line ('Index on ActivityName of QueueHistoryTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);   
			raise_application_error(-20208,v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);	
		

	v_logStatus := LogInsert(9,'CREATING INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1,VAR_REC_2)');
	BEGIN
			existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_QueueHistoryTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(9);
			EXECUTE IMMEDIATE 'CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1,VAR_REC_2)';
			dbms_output.put_line ('Index on VAR_REC_1,VAR_REC_2 of QueueHistoryTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);   
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);	

	v_logStatus := LogInsert(10,'CREATING INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)');
	BEGIN
		existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_QueueHistoryTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(10);
			EXECUTE IMMEDIATE 'CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)';
			dbms_output.put_line ('Index on Q_QueueId of QueueHistoryTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);   
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);	
		

	v_logStatus := LogInsert(11,'CREATING INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)');
	BEGIN
		existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueStreamTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(11);
			EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)';
			dbms_output.put_line ('Index on Activityid, Streamid of QueueStreamTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11);   
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);	

	v_logStatus := LogInsert(12,'CREATING INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)');
	BEGIN
			existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_ExceptionTable')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(12);
			EXECUTE IMMEDIATE 'CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)';
			dbms_output.put_line ('Index on ProcessDefId, ActivityId of ExceptionTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12);   
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);	
		

	v_logStatus := LogInsert(13,'CREATING INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)');
	BEGIN
			existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_TODOSTATUSTABLE')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(13);
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)';
			dbms_output.put_line ('Index on ProcessInstanceId of TODOSTATUSTABLE created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13);   
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);	

	v_logStatus := LogInsert(14,'CREATING INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)');
	BEGIN
		
		existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_TODOSTATUSTABLE')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(14);
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)';
			dbms_output.put_line ('Index on ProcessInstanceId of TODOSTATUSTABLE created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);   
			raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);	
		
	v_logStatus := LogInsert(15,'Transferring Data from Processinstancetable and Queuedatatable into WFInstrumentTable.');
	BEGIN
		/*End Of Creating  New Indexes*/	

		BEGIN
		  existsFlag := 0;	
		  SELECT COUNT(*) INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME IN ('PROCESSINSTANCETABLE','QUEUEDATATABLE');
		IF(existsFlag > 0)
		  THEN
			v_logStatus := LogSkip(15);
			EXECUTE IMMEDIATE 'INSERT INTO WFInstrumentTable (ProcessInstanceID, ProcessDefID, Createdby, CreatedByName, Createddatetime, Introducedbyid, Introducedby, IntroductionDATETIME, ProcessInstanceState, ExpectedProcessDelay, IntroducedAt, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId, ChildWorkitemId, ParentWorkItemID, CalENDarName, ProcessName, LockStatus, RoutingStatus)
			(SELECT Processinstancetable.ProcessInstanceID, ProcessDefID, Createdby, CreatedByName, Createddatetime, Introducedbyid, Introducedby, IntroductionDATETIME, ProcessInstanceState, ExpectedProcessDelay, IntroducedAt, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId, ChildWorkitemId, ParentWorkItemID, CalENDarName, ''NA'', ''N'', ''R'' from Processinstancetable , Queuedatatable where Processinstancetable.ProcessInstanceID = Queuedatatable.ProcessInstanceID)';
			EXECUTE IMMEDIATE 'truncate table Processinstancetable';
			EXECUTE IMMEDIATE 'truncate table Queuedatatable';
			DBMS_OUTPUT.PUT_LINE ('Data transfered from Processinstancetable and Queuedatatable into WFInstrumentTable...');
		END IF;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		  DBMS_OUTPUT.PUT_LINE ('Table PROCESSINSTANCETABLE does not exists...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);   
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);	

	v_logStatus := LogInsert(16,'Transferring Data from WORKLISTTABLE into WFInstrumentTable and Deleting table ');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WORKLISTTABLE';
		IF(existsFlag = 1)
		  THEN
			v_logStatus := LogSkip(16);
			  EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable WIT SET (ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, RoutingStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Q_DivertedByUserId) =
				(select ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, (CASE WHEN WLT.AssignmentType = ''F'' THEN WLT.Q_UserId ELSE 0 END), AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', N''N'', null, Queuename, Queuetype, NotifyStatus, Q_DivertedByUserId 
				FROM Worklisttable WLT where WIT.ProcessInstanceID = WLT.ProcessInstanceID AND WIT.WorkItemId = WLT.WorkItemId)
				WHERE EXISTS (SELECT 1
							FROM Worklisttable WLT where WIT.ProcessInstanceID = WLT.ProcessInstanceID AND WIT.WorkItemId = WLT.WorkItemId)';
				
			EXECUTE IMMEDIATE 'truncate table Worklisttable';
			DBMS_OUTPUT.PUT_LINE ('Data transfered from WORKLISTTABLE into WFInstrumentTable and table deleted...');
		END IF;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('Table WORKLISTTABLE does not exists...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);    

	v_logStatus := LogInsert(17,'Transferring Data from WorkInProcessTable into WFInstrumentTable and deleting table ');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WORKINPROCESSTABLE';
		IF(existsFlag = 1)
		  THEN		
			v_logStatus := LogSkip(17);
			EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable WIT SET (ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, RoutingStatus, LockedTime, Queuename, Queuetype, NotifyStatus, GUID, Q_DivertedByUserId) =
			(select ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, (CASE WHEN WIP.AssignmentType = ''F'' THEN WIP.Q_UserId ELSE 0 END), AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', N''N'', null, Queuename, Queuetype, NotifyStatus, GUID, Q_DivertedByUserId 
			FROM WorkInProcessTable WIP where WIT.ProcessInstanceID = WIP.ProcessInstanceID AND WIT.WorkItemId = WIP.WorkItemId)
			WHERE EXISTS (SELECT 1
						FROM WorkInProcessTable WIP where WIT.ProcessInstanceID = WIP.ProcessInstanceID AND WIT.WorkItemId = WIP.WorkItemId)';
			
			EXECUTE IMMEDIATE 'truncate table WorkInProcessTable';
			DBMS_OUTPUT.PUT_LINE ('Data transfered from WorkInProcessTable into WFInstrumentTable and table deleted...');
		END IF;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('Table WorkInProcessTable does not exists...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);   
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);	

	v_logStatus := LogInsert(18,'Transferring Data from Workdonetable into WFInstrumentTable and deleting table ');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
			WHERE TABLE_NAME = 'WORKDONETABLE';
		IF(existsFlag = 1)
		  THEN
			v_logStatus := LogSkip(18);
			EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable WIT SET (ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, RoutingStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Q_DivertedByUserId) =
			(SELECT ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 0, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', N''Y'', null, Queuename, Queuetype, NotifyStatus, Q_DivertedByUserId 
			FROM Workdonetable WDT where WIT.ProcessInstanceID = WDT.ProcessInstanceID AND WIT.WorkItemId = WDT.WorkItemId)
			WHERE EXISTS (SELECT 1
						FROM Workdonetable WDT where WIT.ProcessInstanceID = WDT.ProcessInstanceID AND WIT.WorkItemId = WDT.WorkItemId)';
			
			EXECUTE IMMEDIATE 'truncate table Workdonetable';
			DBMS_OUTPUT.PUT_LINE ('Data transfered from Workdonetable into WFInstrumentTable and table deleted...');
		End If;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('Table Workdonetable does not exists...');
		End;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18);   
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);    

	v_logStatus := LogInsert(19,'Transferring Data from WorkWithPSTable into WFInstrumentTable and deleting table ');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
			WHERE TABLE_NAME = 'WORKWITHPSTABLE';
		IF(existsFlag = 1)
		  THEN
			v_logStatus := LogSkip(19);
			EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable WIT SET (ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, RoutingStatus, LockedTime, Queuename, Queuetype, NotifyStatus, GUID, Q_DivertedByUserId) =
			(SELECT ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 0, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', N''Y'', null, Queuename, Queuetype, NotifyStatus, GUID, Q_DivertedByUserId 
			FROM WorkWithPSTable WPST WHERE WIT.ProcessInstanceID = WPST.ProcessInstanceID AND WIT.WorkItemId = WPST.WorkItemId)
			WHERE EXISTS (SELECT 1
						FROM WorkWithPSTable WPST WHERE WIT.ProcessInstanceID = WPST.ProcessInstanceID AND WIT.WorkItemId = WPST.WorkItemId)';
			
			EXECUTE IMMEDIATE 'truncate table WorkWithPSTable';
			DBMS_OUTPUT.PUT_LINE ('Data transfered from WorkWithPSTable into WFInstrumentTable and table deleted...');
		END IF;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('Table WorkWithPSTable does not exists...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19);   
			raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);	

	v_logStatus := LogInsert(20,'Transferring Data from PENDINGWORKLISTTABLE into WFInstrumentTable and deleting table ');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
			WHERE TABLE_NAME = 'PENDINGWORKLISTTABLE';
			IF(existsFlag = 1)
			  THEN
			  v_logStatus := LogSkip(20);
			  EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable WIT SET (ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, RoutingStatus, LockedTime, Queuename, Queuetype, NotifyStatus, NoOfCollectedInstances, IsPrimaryCollected, ExportStatus, Q_DivertedByUserId ) =
				(SELECT ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDATETIME, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, (CASE WHEN LockStatus is null THEN N''N'' ELSE LockStatus END), N''R'', LockedTime, Queuename, Queuetype, NotifyStatus, NoOfCollectedInstances, IsPrimaryCollected, ExportStatus, Q_DivertedByUserId 
				FROM PendingWorkListTable PWT WHERE WIT.ProcessInstanceID = PWT.ProcessInstanceID AND WIT.WorkItemId = PWT.WorkItemId)
				WHERE EXISTS (SELECT 1
							FROM PendingWorkListTable PWT WHERE WIT.ProcessInstanceID = PWT.ProcessInstanceID AND WIT.WorkItemId = PWT.WorkItemId)';
				
				EXECUTE IMMEDIATE 'truncate table PendingWorkListTable';
				DBMS_OUTPUT.PUT_LINE ('Data transfered from PendingWorkListTable into WFInstrumentTable and table deleted...');
			END IF;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('Table PENDINGWORKLISTTABLE does not exists...');
		END;
	  COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);   
			raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);    

	v_logStatus := LogInsert(21,'Dropping Constraint from depricated tables PROCESSINSTANCETABLE,QUEUEDATATABLE,WORKLISTTABLE,WORKINPROCESSTABLE,WORKDONETABLE,WORKWITHPSTABLE,PENDINGWORKLISTTABLE');
	BEGIN
	  v_DepricatedTables := '''PROCESSINSTANCETABLE'',''QUEUEDATATABLE'',''WORKLISTTABLE'',''WORKINPROCESSTABLE'',''WORKDONETABLE'',''WORKWITHPSTABLE'',''PENDINGWORKLISTTABLE''';
	  
	  v_Query := 'select table_name, constraint_name from user_constraints where table_name in (' || v_DepricatedTables || ')';
	  BEGIN
		v_logStatus := LogSkip(21);
		OPEN ConstraintsCursor FOR v_query;
		LOOP
		FETCH ConstraintsCursor INTO v_TableName, v_ConstarintName;
		EXIT WHEN ConstraintsCursor%NOTFOUND;
		  BEGIN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || v_TableName || ' DROP CONSTRAINT ' || v_ConstarintName;
		  END;
		END LOOP;
		CLOSE ConstraintsCursor;
		DBMS_OUTPUT.PUT_LINE ('Constraints on depricated tables dropped successfully.'); 
	  END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);   
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);  

	v_logStatus := LogInsert(22,'Deleting tables PROCESSINSTANCETABLE,QUEUEDATATABLE,WORKLISTTABLE,WORKINPROCESSTABLE,WORKDONETABLE,WORKWITHPSTABLE,PENDINGWORKLISTTABLE');
	BEGIN
		v_logStatus := LogSkip(22);
		v_Query := 'select table_name from user_tables where table_name in (' || v_DepricatedTables || ')';
		BEGIN
		OPEN TableCursor FOR v_Query;
		LOOP
		FETCH TableCursor INTO v_TableName;
		EXIT WHEN TableCursor%NOTFOUND;
		  BEGIN
			EXECUTE IMMEDIATE 'Drop table ' || v_TableName;
		  END;
		END LOOP;  
		CLOSE TableCursor;
		DBMS_OUTPUT.PUT_LINE ('Depricated tables dropped successfully.');   
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);   
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);  

	v_logStatus := LogInsert(23,'CREATING TRIGGER WF_UTIL_UNREGISTER
			AFTER DELETE 
			ON PSREGISTERATIONTABLE 
			FOR EACH ROW');
	BEGIN
	  BEGIN  
		v_logStatus := LogSkip(23);
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
					Update WFInstrumentTable set LockedByName = null , LockStatus = ''N'', LockedTime = null where LockedByName = PSName and LockStatus = ''Y'' and RoutingStatus = ''Y'';
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
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);   
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);  

	v_logStatus := LogInsert(24,'CREATING VIEW QUEUETABLE ');
	BEGIN
	  BEGIN
		v_logStatus := LogSkip(24);
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
			 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, 
			 var_long1, var_long2, var_long3, var_long4, 
			 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,
			 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
			 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
			 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, ProcessVariantId
		  FROM	WFINSTRUMENTTABLE';
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);   
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);  

	v_logStatus := LogInsert(25,'Adding new column LastModifiedOn in QUEUEDEFTABLE');
	BEGIN
	  BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('QUEUEDEFTABLE')
			AND UPPER(COLUMN_NAME)=UPPER('LastModifiedOn');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(25);
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE ADD LastModifiedOn DATE DEFAULT sysdate';
			DBMS_OUTPUT.PUT_LINE ('Table QUEUEDEFTABLE altered with new Column LastModifiedOn');   
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25);   
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);  

	v_logStatus := LogInsert(26,'Creating TRIGGER WF_USR_DEL AFTER UPDATE ON PDBUSER FOR EACH ROW');
	BEGIN
	  BEGIN
		v_logStatus := LogSkip(26);
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_USR_DEL
		  AFTER UPDATE 
		  ON PDBUSER 
		  FOR EACH ROW
		  DECLARE
			v_DeletedFlag NVARCHAR2(1);
		  BEGIN
		  IF(UPDATING( ''DELETEDFLAG'' ))
		  THEN
		  UPDATE WFInstrumentTable 
		  SET	AssignedUser = NULL, AssignmentType = NULL,	LockStatus = N''N'' , 
				LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 ,
				QueueName = (SELECT QUEUEDEFTABLE.QueueName 
			FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
			WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
			AND    StreamID = Q_StreamID
			AND    QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
			AND    QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
			QueueType = (SELECT QUEUEDEFTABLE.QueueType 
			  FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
			  WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
			  AND    StreamID = Q_StreamID
			  AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
			  AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
			Q_QueueID = (SELECT QueueId 
			  FROM QUEUESTREAMTABLE 
			  WHERE StreamID = Q_StreamID
			  AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
			  AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId)	
			WHERE Q_UserId = :OLD.UserIndex AND RoutingStatus =''N'' AND LockStatus = ''N'';
		  UPDATE WFInstrumentTable 
			SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = N''N'' ,
			LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
			WHERE  AssignmentType != N''F'' AND Q_UserId = :OLD.UserIndex AND LockStatus = ''N'' AND RoutingStatus = ''N'';
		  DELETE FROM QUEUEUSERTABLE  
			WHERE  UserID = :OLD.UserIndex 
			AND    Associationtype = 0;
		  DELETE FROM USERPREFERENCESTABLE WHERE  UserID = :OLD.UserIndex;
		  DELETE FROM USERDIVERSIONTABLE WHERE  Diverteduserindex = :OLD.UserIndex 
			OR AssignedUserindex = :OLD.UserIndex;
		  DELETE FROM USERWORKAUDITTABLE WHERE  Userindex = :OLD.UserIndex 
			OR Auditoruserindex = :OLD.UserIndex;
		  END IF;	
		  END;';
		  DBMS_OUTPUT.PUT_LINE ('Trigger WF_USR_DEL created.');  
	  END;		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);   
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);  

	v_logStatus := LogInsert(27,'Deleting WFWorkInProcess and WFWorkList related views');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(27);
			DECLARE CURSOR VIEW_CURSOR
			  IS 
				SELECT view_name FROM USER_VIEWS WHERE (UPPER(view_name) LIKE UPPER('WFWorkinProcessView_%') OR UPPER(view_name) LIKE UPPER('WFWORKLISTVIEW_%'));
			BEGIN
			  OPEN VIEW_CURSOR;
			  LOOP
				FETCH VIEW_CURSOR INTO v_ViewName;
				EXIT WHEN VIEW_CURSOR%NOTFOUND;
				BEGIN
				  EXECUTE IMMEDIATE 'Drop view ' || v_ViewName;
				END;
			  END LOOP;  
			  CLOSE VIEW_CURSOR;
			  DBMS_OUTPUT.PUT_LINE ('WFWorkInProcess and WFWorkList related views deleted successfully.');
			END;  
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);   
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);  
	  
	v_logStatus := LogInsert(28,'CREATE TABLE WFATTRIBUTEMESSAGETABLE');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
			FROM USER_TABLES
			WHERE UPPER(TABLE_NAME) = UPPER('WFATTRIBUTEMESSAGETABLE');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(28);
			EXECUTE IMMEDIATE 'CREATE TABLE WFATTRIBUTEMESSAGETABLE ( 
			  ProcessDefID		INT		NOT NULL,
			  ProcessInstanceID	NVARCHAR2 (63)  NOT NULL ,
			  WorkitemId		    INTEGER		NOT NULL,
			  MESSAGEID		INTEGER NOT NULL, 
			  MESSAGE			CLOB NOT NULL, 
			  LOCKEDBY		NVARCHAR2(63), 
			  STATUS			NVARCHAR2(1) CHECK (status in (N''N'', N''F'')), 
			  ActionDateTime	DATE,  
			  CONSTRAINT PK_WFATTRIBUTEMESSAGETABLE2 PRIMARY KEY (MESSAGEID ) 
			)';
			DBMS_OUTPUT.PUT_LINE ('Table WFATTRIBUTEMESSAGETABLE created successfully...');   
			
			 EXECUTE IMMEDIATE ('CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)	');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28);   
			raise_application_error(-20228,v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);  
	  
	v_logStatus := LogInsert(29,'Adding new columns overflow,message in WFMessageTable');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag
			from USER_TAB_COLUMNS 
			WHERE UPPER(table_name) = UPPER('WFMessageTable') and UPPER(column_name) = UPPER('message')
			AND UPPER(data_type) = UPPER('NVARCHAR2');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN	   
			v_logStatus := LogSkip(29);
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageTable DROP COLUMN message';
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageTable ADD overflow';
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageTable ADD message NVARCHAR2(2000) NOT NULL';
			DBMS_OUTPUT.PUT_LINE ('WFMessageTable column message type altered.');  
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);   
			raise_application_error(-20229,v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);   

	v_logStatus := LogInsert(30,'CREATING SEQUENCE SEQ_ATTRIBMESSAGEID');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag
			FROM USER_SEQUENCES
			WHERE UPPER(sequence_name) = UPPER('SEQ_ATTRIBMESSAGEID');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
		  v_logStatus := LogSkip(30);
		  EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_ATTRIBMESSAGEID INCREMENT BY 1 START WITH 1 NOCACHE';
		  DBMS_OUTPUT.PUT_LINE ('Sequence SEQ_ATTRIBMESSAGEID created successfully...');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);   
			raise_application_error(-20230,v_scriptName ||' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);  

	v_logStatus := LogInsert(31,'Creating SEQUENCE seq_rootlogid');
	BEGIN
	  BEGIN
		SELECT 1 INTO existsFlag
			FROM USER_SEQUENCES
			WHERE UPPER(sequence_name) = UPPER('seq_rootlogid');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
		  v_logStatus := LogSkip(31);
		  SELECT last_number INTO v_crtSeqLastNum
		  FROM USER_SEQUENCES WHERE UPPER(sequence_name) = UPPER('logid');
		  v_crtSeqLastNum := v_crtSeqLastNum + 1;
		  
		  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_rootlogid INCREMENT BY 1 START WITH ' || TO_CHAR(v_crtSeqLastNum) ||  ' NOCACHE';
		  DBMS_OUTPUT.PUT_LINE ('Sequence seq_rootlogid created successfully...');
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31);   
			raise_application_error(-20231,v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);  

	v_logStatus := LogInsert(32,'Creating SEQUENCE MapIdSeqGenerator');
	BEGIN
	  BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag
			FROM USER_SEQUENCES
			WHERE UPPER(sequence_name) = UPPER('MapIdSeqGenerator');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(32);
		  EXECUTE IMMEDIATE 'CREATE SEQUENCE MapIdSeqGenerator INCREMENT BY 1 START WITH 1 NOCACHE';
		  DBMS_OUTPUT.PUT_LINE ('Sequence MapIdSeqGenerator created successfully...');
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);   
			raise_application_error(-20232,v_scriptName ||' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);  

	v_logStatus := LogInsert(33,'Adding new column SeqName in WFAUTOGENINFOTABLE');
	BEGIN
	  BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFAutoGenInfoTable')
			AND UPPER(COLUMN_NAME)=UPPER('SeqName');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(33);
			EXECUTE IMMEDIATE 'ALTER TABLE WFAutoGenInfoTable ADD SeqName NVARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE ('Table WFAutoGenInfoTable altered with new Column SeqName');   
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);   
			raise_application_error(-20233,v_scriptName ||' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);  

	v_logStatus := LogInsert(34,'Inserting values in WFCabVersionTable for 7.2_ProcessDefTable, 7.2_SystemCatalog');
	BEGIN
	  BEGIN
		v_logStatus := LogSkip(34);
		EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ProcessDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''7.2_ProcessDefTable'', N''Y'')';
		EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SystemCatalog'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''7.2_SystemCatalog'', N''Y'')';
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(34);   
			raise_application_error(-20234,v_scriptName ||' BLOCK 34 FAILED');
	END;
	v_logStatus := LogUpdate(34);  

	v_logStatus := LogInsert(35,'Deleting PS Data from psregisterationtable');
	BEGIN
	  BEGIN
		existsFlag := 0;
		SELECT count(1) INTO existsFlag
			FROM psregisterationtable 
			WHERE UPPER(data) = 'PROCESS SERVER';
		IF(existsFlag > 0)
			THEN
			BEGIN
				v_logStatus := LogSkip(35);
				EXECUTE IMMEDIATE 'DELETE FROM psregisterationtable WHERE UPPER(data) = ''PROCESS SERVER''';
				DBMS_OUTPUT.PUT_LINE ('PS Data from psregisterationtable deleted successfully...');
			END;
		END IF;
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(35);   
			raise_application_error(-20235,v_scriptName ||' BLOCK 35 FAILED');
	END;
	v_logStatus := LogUpdate(35);  

	v_logStatus := LogInsert(36,'Creating SEQUENCE PSID');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag
			FROM USER_SEQUENCES
			WHERE UPPER(sequence_name) = UPPER('PSID') AND last_number >= 10000000;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			BEGIN
				v_logStatus := LogSkip(36);	
				EXECUTE IMMEDIATE 'DROP SEQUENCE PSID';
				EXECUTE IMMEDIATE 'CREATE SEQUENCE PSID INCREMENT BY 1 START WITH 10000000';
				DBMS_OUTPUT.PUT_LINE ('Sequence PSID created successfully...');
			END;
	  END; 
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(36);   
			raise_application_error(-20236,v_scriptName ||' BLOCK 36 FAILED');
	END;
	v_logStatus := LogUpdate(36);  

	v_logStatus := LogInsert(37,'CREATE SEQUENCE SEQ_RegistrationNumber_');
	BEGIN
		BEGIN
		v_logStatus := LogSkip(37);
		DECLARE CURSOR REG_SEQ_CURSOR
		  IS 
			SELECT processdefid, regstartingno+1 AS seq_start_no FROM processdeftable ORDER BY processdefid;
		BEGIN
		  OPEN REG_SEQ_CURSOR;
		  LOOP
			FETCH REG_SEQ_CURSOR INTO v_ProcessDefID, v_SeqStartNo;
			EXIT WHEN REG_SEQ_CURSOR%NOTFOUND;
			BEGIN
			  existsFlag := 0;
			  SELECT 1 INTO existsFlag
				  FROM USER_SEQUENCES
				  WHERE UPPER(sequence_name) = UPPER('SEQ_RegistrationNumber_'||v_ProcessDefID);
			  EXCEPTION
				  WHEN NO_DATA_FOUND THEN
				  BEGIN
					  EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_RegistrationNumber_' || v_ProcessDefID || ' INCREMENT BY 1 START WITH ' || v_SeqStartNo || ' NOCACHE ';
					  DBMS_OUTPUT.PUT_LINE ('Registration sequence SEQ_RegistrationNumber_'|| v_ProcessDefID ||' created successfully...');
				  END;
			END;
		  END LOOP;  
		  CLOSE REG_SEQ_CURSOR;
		END;  
	  END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(37);   
			raise_application_error(-20237,v_scriptName ||' BLOCK 37 FAILED');
	END;
	v_logStatus := LogUpdate(37);  

	v_logStatus := LogInsert(38,'Updating WFVarRelationTable for parentobject column ' );
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT count(*) INTO existsFlag 
			FROM WFVarRelationTable
			WHERE UPPER(parentobject) = UPPER('QUEUEDATATABLE');
		IF(existsFlag > 0)
		  THEN
			BEGIN
				v_logStatus := LogSkip(38);
				EXECUTE IMMEDIATE 'UPDATE WFVarRelationTable SET parentobject = ''WFINSTRUMENTTABLE'' WHERE UPPER(parentobject) = ''QUEUEDATATABLE''';
				DBMS_OUTPUT.PUT_LINE ('WFVarRelationTable updated for parentobject column...');   
			END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(38);   
			raise_application_error(-20238,v_scriptName ||' BLOCK 38 FAILED');
	END;
	v_logStatus := LogUpdate(38);  

	 v_logStatus := LogInsert(39,'Updating WFVarRelationTable for childobject column');
	BEGIN
		  /* Bug 55338 changes begin */
		BEGIN
		existsFlag := 0;
		SELECT count(*) INTO existsFlag 
			FROM WFVarRelationTable
			WHERE UPPER(childobject) = UPPER('QUEUEDATATABLE');
		IF(existsFlag > 0)
		  THEN
			BEGIN
				v_logStatus := LogSkip(39);
				EXECUTE IMMEDIATE 'UPDATE WFVarRelationTable SET childobject = ''WFINSTRUMENTTABLE'' WHERE UPPER(childobject) = ''QUEUEDATATABLE''';
				DBMS_OUTPUT.PUT_LINE ('WFVarRelationTable updated for childobject column...');   
			END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(39);   
			raise_application_error(-20239,v_scriptName ||' BLOCK 39 FAILED');
	END;
	v_logStatus := LogUpdate(39); 

	 v_logStatus := LogInsert(40,'Updating WFUdtvarmappingtable for MappedObjectName column');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT count(*) INTO existsFlag 
			FROM WFUdtvarmappingtable
			WHERE UPPER(MappedObjectName) = UPPER('QUEUEDATATABLE');
		IF(existsFlag > 0)
		  THEN
			BEGIN
				v_logStatus := LogSkip(40);
				EXECUTE IMMEDIATE 'UPDATE WFUdtvarmappingtable SET MappedObjectName = ''WFINSTRUMENTTABLE'' WHERE UPPER(MappedObjectName) = ''QUEUEDATATABLE''';
				DBMS_OUTPUT.PUT_LINE ('WFUdtvarmappingtable updated for MappedObjectName column...');   
			END;
		END IF;
		END;
		EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(40);   
			raise_application_error(-20240,v_scriptName ||' BLOCK 40 FAILED');
	END;
	v_logStatus := LogUpdate(40); 
	 
	  /* Bug 55338 changes end */
	 v_logStatus := LogInsert(41,'Updating wfautogeninfotable for tablename column');
	BEGIN
		BEGIN
		existsFlag := 0;
		SELECT count(*) INTO existsFlag 
			FROM wfautogeninfotable
			WHERE UPPER(tablename) = UPPER('QueueDataTable');
		IF(existsFlag > 0)
		  THEN
			BEGIN
				v_logStatus := LogSkip(41);
				EXECUTE IMMEDIATE 'UPDATE wfautogeninfotable SET tablename = ''WFINSTRUMENTTABLE'' WHERE UPPER(tablename) = ''QUEUEDATATABLE''';
				DBMS_OUTPUT.PUT_LINE ('wfautogeninfotable updated for tablename column...');   
			END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(41);   
			raise_application_error(-20241,v_scriptName ||' BLOCK 41 FAILED');
	END;
	v_logStatus := LogUpdate(41); 

	v_logStatus := LogInsert(42,'Adding new Column SeqName in WFAUTOGENINFOTABLE');
	BEGIN
		 BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFAUTOGENINFOTABLE')
			AND UPPER(COLUMN_NAME)=UPPER('SEQNAME');
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(42);
			EXECUTE IMMEDIATE 'ALTER TABLE WFAUTOGENINFOTABLE ADD SeqName NVARCHAR2(30) NULL';
			DBMS_OUTPUT.PUT_LINE ('Table WFAUTOGENINFOTABLE altered with new Column SeqName...');   
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(42);   
			raise_application_error(-20242,v_scriptName ||' BLOCK 42 FAILED');
	END;
	v_logStatus := LogUpdate(42);  

	v_logStatus := LogInsert(43,'Updating wfautogeninfotable');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(43);
		  DECLARE CURSOR CMPLX_SEQ_CURSOR
			IS 
			  SELECT VMT.processdefid, VMT.unbounded, VMT.extobjid, VRT.parentobject, VRT.foreignkey, VRT.childobject AS ComplexTable
			  FROM VARMAPPINGTABLE VMT, WFVARRELATIONTABLE VRT
			  WHERE VMT.processdefid = VRT.processdefid AND VMT.extobjid > 1  
			  AND (VRT.fautogen = 'Y' OR VRT.rautogen = 'Y');
		  BEGIN
			OPEN CMPLX_SEQ_CURSOR;
			LOOP
			  FETCH CMPLX_SEQ_CURSOR INTO v_ProcessDefID, v_IsArray, v_ExtObjID, v_ParentObject, v_ForignKey, v_complextable;
			  EXIT WHEN CMPLX_SEQ_CURSOR%NOTFOUND;
			  BEGIN
				IF (v_IsArray = 'Y')
				  THEN
					BEGIN
						 v_insertionorderid := 'insertionorderid';
						 existsFlag := 0;
						 v_Query :=  ' SELECT count(*) FROM USER_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER( '''  || v_complextable || ''' )
						 AND UPPER(COLUMN_NAME)=UPPER(''' ||  v_insertionorderid || ''' ) ';
						 EXECUTE IMMEDIATE (v_Query) INTO existsFlag ;
						 if(existsFlag = 1)THEN
						 BEGIN
							  v_Query := 'SELECT max(insertionorderid) FROM '||v_complextable;
							  EXECUTE IMMEDIATE (v_Query) INTO v_SeqStartNo;
							  SELECT 'WFSEQ_ARRAY_' || v_ProcessDefID || '_' || v_ExtObjID INTO v_SeqName FROM dual;
							  SELECT 1 INTO existsFlag
								  FROM USER_SEQUENCES
								  WHERE UPPER(sequence_name) = UPPER(v_SeqName);
							  EXCEPTION
								WHEN NO_DATA_FOUND THEN
								BEGIN 
								  EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_SeqName || ' INCREMENT BY 1 START WITH ' || v_SeqStartNo || ' NOCACHE';
								  EXCEPTION WHEN OTHERS THEN
									BEGIN
										EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_SeqName || ' INCREMENT BY 1 START WITH 1 NOCACHE';
									END;
								END;  	
						END;
						END IF;
					END;                
				END IF;
				BEGIN
				  EXECUTE IMMEDIATE 'SELECT MapIdSeqGenerator.NEXTVAL FROM dual' INTO v_CurrentSeqNo;
				  SELECT 'WFS_SEQ_' || v_CurrentSeqNo INTO v_SeqName FROM dual;
				  SELECT currentseqno+1 INTO v_SeqStartNo FROM wfautogeninfotable WHERE UPPER(tablename) = UPPER(v_ParentObject) AND UPPER(columnname) = UPPER(v_ForignKey);
				  SELECT 1 INTO existsFlag
					FROM USER_SEQUENCES
					WHERE UPPER(sequence_name) = UPPER(v_SeqName);
				  EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN  
					  EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_SeqName || ' INCREMENT BY 1 START WITH ' || v_SeqStartNo || ' NOCACHE ';
					END;
				  EXECUTE IMMEDIATE 'UPDATE wfautogeninfotable SET SeqName = ''' || v_SeqName || ''' WHERE UPPER(tablename) = UPPER(''' || v_ParentObject || ''') AND UPPER(columnname) = UPPER(''' || v_ForignKey || ''')';
				END;
			  END;
			END LOOP;  
			CLOSE CMPLX_SEQ_CURSOR;
		END;
	  END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(43);   
			raise_application_error(-20243,v_scriptName ||' BLOCK 43 FAILED');
	END;
	v_logStatus := LogUpdate(43);

	v_logStatus := LogInsert(44,'Creating Table WFBRMSConnectTable');
	BEGIN
		-- Tables added for BRMS workstep
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WFBRMSCONNECTTABLE';
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(44);
			EXECUTE IMMEDIATE ('create table WFBRMSConnectTable(
						   ConfigName nvarchar2(128) NOT NULL,
						   ServerIdentifier integer NOT NULL,
						   ServerHostName nvarchar2(128) NOT NULL,
						   ServerPort integer NOT NULL,
						   ServerProtocol nvarchar2(32) NOT NULL,
						   URLSuffix nvarchar2(32) NOT NULL,
						   UserName nvarchar2(128) NULL,
						   Password nvarchar2(128) NULL,
						   ProxyEnabled nvarchar2(1) NOT NULL,
						   CONSTRAINT pk_WFBRMSConnectTable PRIMARY KEY(ServerIdentifier)
			)');
			DBMS_OUTPUT.PUT_LINE ('Table WFBRMSConnectTable created successfully...'); 
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(44);   
			raise_application_error(-20244,v_scriptName ||' BLOCK 44 FAILED');
	END;
	v_logStatus := LogUpdate(44);  

	v_logStatus := LogInsert(45,'Creating Table WFBRMSRuleSetInfo');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WFBRMSRULESETINFO';
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(45);
			EXECUTE IMMEDIATE ('create table WFBRMSRuleSetInfo(
						   ExtMethodIndex integer NOT NULL,
						   ServerIdentifier integer NOT NULL,
						   RuleSetName nvarchar2(128) NOT NULL,
						   VersionNo nvarchar2(5) NOT NULL,
						   InvocationMode nvarchar2(128) NOT NULL,
						   CONSTRAINT pk_WFBRMSRuleSetInfo PRIMARY KEY(ExtMethodIndex)
			)');
			DBMS_OUTPUT.PUT_LINE ('Table WFBRMSRuleSetInfo created successfully...'); 
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(45);   
			raise_application_error(-20245,v_scriptName ||' BLOCK 45 FAILED');
	END;
	v_logStatus := LogUpdate(45);  

	v_logStatus := LogInsert(46,'Creating Table WFBRMSActivityAssocTable');
	BEGIN
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WFBRMSACTIVITYASSOCTABLE';
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(46);
			EXECUTE IMMEDIATE ('create table WFBRMSActivityAssocTable(
						   ProcessDefId integer NOT NULL,
						   ActivityId integer NOT NULL,
						   ExtMethodIndex integer NOT NULL,
						   OrderId integer NOT NULL,
						   TimeoutDuration integer NOT NULL,
						   CONSTRAINT pk_WFBRMSActivityAssocTable PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
			)');
			DBMS_OUTPUT.PUT_LINE ('Table WFBRMSActivityAssocTable created successfully...'); 
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(46);   
			raise_application_error(-20246,v_scriptName ||' BLOCK 46 FAILED');
	END;
	v_logStatus := LogUpdate(46);  

	v_logStatus := LogInsert(47,'Creating Table WFSYSTEMPROPERTIESTABLE');
	BEGIN
		-- WFSYSTEMPROPERTIESTABLE creation
		BEGIN
		  existsFlag := 0;
		  SELECT 1 INTO existsFlag
		  FROM USER_TABLES
		  WHERE TABLE_NAME = 'WFSYSTEMPROPERTIESTABLE';
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(47);
			EXECUTE IMMEDIATE ('create table WFSYSTEMPROPERTIESTABLE(
								PROPERTYKEY NVARCHAR2(255), 
								PROPERTYVALUE NVARCHAR2(1000) NOT NULL, 
								PRIMARY KEY (PROPERTYKEY)
			)');
			EXECUTE IMMEDIATE ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SystemEmailId'',''system_emailid@domain.com'')');
			EXECUTE IMMEDIATE ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''AdminEmailId'',''admin_emailid@domain.com'')');
			DBMS_OUTPUT.PUT_LINE ('Table WFSYSTEMPROPERTIESTABLE created successfully...'); 
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(47);   
			raise_application_error(-20247,v_scriptName ||' BLOCK 47 FAILED');
	END;
	v_logStatus := LogUpdate(47);  
	  
	v_logStatus := LogInsert(48,'Creating Table PMSVERSIONINFO');
	BEGIN
		BEGIN 
		  SELECT 1 INTO existsFlag 
		  FROM USER_TABLES  
		  WHERE TABLE_NAME = 'PMSVERSIONINFO';
		EXCEPTION 
		  WHEN NO_DATA_FOUND THEN 
		  v_logStatus := LogSkip(48);
		   EXECUTE IMMEDIATE 
		   'CREATE TABLE pmsversioninfo(
				product_acronym varchar2(100) not null,
				label varchar2(100) not null,
				previouslabel varchar2(100),
				updatedon date DEFAULT sysdate
				)';
		   dbms_output.put_line ('Table PMSVERSIONINFO Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(48);   
			raise_application_error(-20248,v_scriptName ||' BLOCK 48 FAILED');
	END;
	v_logStatus := LogUpdate(48);  
	 
	v_logStatus := LogInsert(49,'Inserting value in pmsversioninfo ');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(49);
			EXECUTE IMMEDIATE Q'{SELECT 1  
			FROM pmsversioninfo  
			WHERE label = 'LBL_SUP_000_28012015' AND product_acronym='OF'}' INTO  existsFlag;
		EXCEPTION 
		WHEN OTHERS THEN 
			EXECUTE IMMEDIATE Q'{INSERT INTO pmsversioninfo(product_acronym,label) VALUES ('OF','LBL_SUP_000_28012015')}';
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
		v_logStatus := LogUpdateError(49);   
		raise_application_error(-20249,v_scriptName ||' BLOCK 49 FAILED');
	END;
	v_logStatus := LogUpdate(49);		


	v_logStatus := LogInsert(50,'inserting value in WFCabVersionTable for END of Omniflow 10.0');
	BEGIN
		v_logStatus := LogSkip(50);
		INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('10.2' ,cabversionid.nextval, sysdate,sysdate , 'END of Omniflow 10.0','Y');
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
		v_logStatus := LogUpdateError(50);   
		raise_application_error(-20250,v_scriptName ||' BLOCK 50 FAILED');
	END;
	v_logStatus := LogUpdate(50);		
		
END;


~

call Upgrade()

~

Drop procedure Upgrade

~