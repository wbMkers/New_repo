/*____________________________________________________________________________________
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group				: Application – Products
	Product / Project		: WorkFlow 6.0
	Module				: Transaction Server
	File Name			: Upgrade.sql (Oracle)
	Author				: Ruhi Hira, Umesh, Puneet
	Date written (DD/MM/YYYY)	: 10/03/2005
	Description			: Upgrade Script for OF, (5.0.1 - 6.0)
_____________________________________________________________________________________
			CHANGE HISTORY
_____________________________________________________________________________________
Date		Change By		Change Description (Bug No. (If Any))
20/05/2005	Harmeet Kaur		Exec procedureName changed to Call procedureName()
29/09/2005	Ruhi Hira		SrNo-1.
29/12/2005	Ruhi Hira		SrNo-2.
03/01/2006	Ruhi Hira		WFS_6.1.2_008, WFS_6.1.2_009.
10/01/2006	Mandeep Kaur		SrNo-6.
12/01/2006	Mandeep Kaur		WFS_6.1.2_028
18/01/2006	Ruhi Hira		Bug No WFS_6.1.2_033.
19/01/2006	Harmeet Kaur		WFS_6.1.2_037
20/01/2006	Harmeet Kaur		WFS_6.1.2_042
20/01/2006	Ruhi Hira		Bug No WFS_6.1.2_044.
25/01/2006	Ashish Mangla		WFS_6.1.2_043
18/04/2006	Ruhi Hira		Bug No WFS_6.1.2_066.
02/01/2007	Ruhi Hira		SrNo-7.
09/01/2007	Varun Bhansaly	Bugzilla Bug 370
09/02/2007	Varun Bhansaly		Bugzilla Id 442
09/02/2007	Varun Bhansaly		Bugzilla Id 74
09/02/2007	Varun Bhansaly		Bugzilla Id 361
23/07/2007  Varun Bhansaly	    To counter RD bugs & To make Upgrade Script more robust. 	
21/12/2007	Varun Bhansaly		Bugzilla Id 1687 ([Cab Creation + Upgrade] WFDataStructureTable : Primary key violation)
21/12/2007	Varun Bhansaly		Bugzilla Id 1800, ([CabCreation] New parameter type 12 [boolean] to be considered)
28/01/2008	Varun Bhansaly		Bugzilla Id 1788, (index not used in WFDataStructureTable in PostgreSQL.)
11/02/2008	Varun Bhansaly		Distribute Case handled.
								WFCabVersionTable column size increased.
12/02/2008	Varun Bhansaly		CheckOutProcessesTable may not exist on all 5x cabinets, - Create it
29/08/2008	Ishu Saraf			New Parameters Type 15, 16 in ExtMethodDefTable and ExtMethodParamDefTable need to be considered as discussed with Ruhi
13/01/2009	Ishu Saraf			Changes for ProcessDefTable
14/01/2009	Ishu Saraf			Added procedure WFCollectionUpgrade
14/08/2013	Sajid Khan			existflag was renamed to existsFlag and checks applied for currentroutelog and HistoryRouteLogTable.
20/06/2014  Kanika Manik        PRD Bug 41694 - Value of Expiry before and after version upgradation are not same in case the Expiry value is present like (90 * 24 + 0)
                                before version upgrade
______________________________________________________________________________________*/

/* Procedure to Create new tables / constraints / Views / Triggers */

CREATE OR REPLACE PROCEDURE Upgrade AS
	existsFlag						INTEGER;
	exceptFlag						INTEGER;
	v_Query							NVARCHAR2(8000);
	v_varStr						NVARCHAR2(2000);
	v_aliasName						NVARCHAR2(63);
	v_param1						NVARCHAR2(50);
	v_param2						NVARCHAR2(50);
	v_operator						INTEGER;
	v_constraintName				VARCHAR2(2000);
	v_search_Condition				VARCHAR2(2000);
	v_dist_processDefId				INTEGER;
	v_dist_activityId				INTEGER;
	v_dist_targetActivityId			INTEGER;
	v_SQLCode						INTEGER;

	ret								INTEGER;
	ret1							INTEGER;
	ret2							INTEGER;
	v_dropFlag						INTEGER;
	v_ruleId						INTEGER;
	v_DistributeActivityTable_Cur	INTEGER;
	v_cursor1						INTEGER;
	v_cursor2						INTEGER;
	quoteChar						VARCHAR2(1);
	v_lastSeqValue					INTEGER;
	v_activityName					NVARCHAR2(30);
	v_msgCount						INTEGER;
	v_cabVersion					VARCHAR2 (2000);
	
	CURSOR Constraint_Cur IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'VARALIASTABLE';

	CURSOR Alias_Cur IS
		SELECT Alias, Param1, Param2, OPERATOR FROM VARALIASTABLE WHERE queueId = 0 ORDER BY id;
		
	CURSOR Constraint_CurA IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'ACTIVITYTABLE'; 

	CURSOR Constraint_CurB IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 

	CURSOR Constraint_CurC IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODPARAMDEFTABLE'; 
BEGIN
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = 'WFCABVERSIONTABLE'
		;  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE
			'Create table WFCabVersionTable (
				cabVersion	NVARCHAR2(10) NOT NULL,
				cabVersionId	INT NOT NULL PRIMARY KEY,
				creationDate	DATE,
				lastModified	DATE,
				Remarks		NVARCHAR2(200) NOT NULL,
				Status		NVARCHAR2(1)
			)';
			dbms_output.put_line ('Table WFCabVersionTable Created successfully');
	END;
	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (cabVersion NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column cabVersion size increased to 255');
	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (Remarks NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column Remarks size increased to 255');
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('CABVERSIONID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
	END;
	/* If WFMessageTable contains unprocessed message, Upgrade must be halted - Varun Bhansaly */
	BEGIN
		SELECT COUNT(*) INTO v_msgCount FROM WFMessageTable;
		SELECT cabVersionId.NEXTVAL-1 INTO v_lastSeqValue FROM DUAL;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			v_msgCount := 0;
	END;
	IF(v_msgCount > 0) THEN
		UPDATE WFCabVersionTable SET Remarks = Remarks || N' - Upgrade Halted! WFMessageTable contains ' || v_msgCount || N' unprocessed messages. To process these messages run Message Agent. Run Upgrade again.' WHERE cabVersionId =  v_lastSeqValue;
		COMMIT;
		RAISE_APPLICATION_ERROR(-20999, 'Upgrade Halted! WFMessageTable contains ' || v_msgCount || ' unprocessed messages. To process these messages run Message Agent. Run Upgrade again.');
	END IF;

	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMessageTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFMessageTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFMessageTable altered with new Column ActionDateTime');
	END;

	/*Creating ExtMethodDefTable */
	existsFlag := 0;
	quoteChar  := CHR(39);
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'
			) ;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0;
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
		CREATE TABLE EXTMETHODDEFTABLE(
				ProcessDefId		INTEGER NOT NULL,
				ExtMethodIndex		INTEGER NOT NULL,
				ExtAppName		NVARCHAR2(64) NOT NULL,
				ExtAppType		NVARCHAR2(1) NOT NULL, CHECK(ExtAppType IN(N' || quoteChar || 'W' || quoteChar || ', N' || quoteChar || 'E' || quoteChar || ')),
				ExtMethodName		NVARCHAR2(64) NOT NULL,
				SearchMethod		NVARCHAR2(255),
				SearchCriteria		NVARCHAR2(2000),
				ReturnType		SMALLINT CHECK(ReturnType IN (0, 3, 4, 6, 8, 10, 11, 12)),
				PRIMARY KEY		(ProcessDefId, ExtMethodIndex)
			)';
	END IF;

	/*Creating ExtMethodParamDefTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'EXTMETHODPARAMDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	/* SrNo-2, New field DataStructureId added - Ruhi Hira */
	/* Bug No WFS_6.1.2_044, DataStrucuteId not null constraint removed - Ruhi Hira */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE EXTMETHODPARAMDEFTABLE(
				ProcessDefId		INTEGER NOT NULL,
				ExtMethodParamIndex	INTEGER NOT NULL,
				ExtMethodIndex		INTEGER NOT NULL,
				ParameterName		NVARCHAR2(64) NOT NULL,
				ParameterType		SMALLINT CHECK (ParameterType IN(0, 3, 4, 6, 8, 10, 11, 12)),
				ParameterOrder	        SMALLINT NOT NULL, 
				DataStructureId		INTEGER,
				PRIMARY KEY		(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex)
			)';
		dbms_output.put_line ('Table ExtMethodParamDefTable created successfully');
	END IF;
	
	/*Creating ExtMethodParamMappingTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'EXTMETHODPARAMMAPPINGTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE EXTMETHODPARAMMAPPINGTABLE(
				ProcessDefId		INTEGER NOT NULL,
				ActivityId		INTEGER NOT NULL,
				RuleId		        INTEGER NOT NULL,
				RuleOperationOrderId	SMALLINT NOT NULL,
				ExtMethodIndex	        INTEGER NOT NULL,
				MapType		        NVARCHAR2(1) CHECK(MapType IN(N' || quoteChar || 'F' || quoteChar || ', N' || quoteChar || 'R' || quoteChar || ', N' || quoteChar || 'C' || quoteChar || ', N' || quoteChar || 'S' || quoteChar || ', N' || quoteChar || 'I' || quoteChar || ', N' || quoteChar || 'Q' || quoteChar || ', N' || quoteChar || 'M' || quoteChar || ')),
				ExtMethodParamIndex	INTEGER NOT NULL,
				MappedField		NVARCHAR2(126),
				MappedFieldType		NVARCHAR2(1),
				DataStructureId		INTEGER
			)';
		dbms_output.put_line ('Table ExtMethodParamMappingTable created successfully');
	END IF;

	/*Creating CONSTANTDEFTABLE */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'CONSTANTDEFTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE CONSTANTDEFTABLE(
				processDefId		INTEGER NOT NULL,
				constantName		NVARCHAR2 (64) NOT NULL,
				constantValue		NVARCHAR2 (255),
				lastModifiedOn		DATE NOT NULL ,
				PRIMARY KEY		(processDefId, constantName)
			)';
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFMESSAGEINPROCESSTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	/* New table for optimizing Message agent */
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFMessageInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFMessageInProcessTable (
				messageId		INT, 
				message			CLOB, 
				lockedBy		NVARCHAR2(63), 
				status			NVARCHAR2(1),
				ActionDateTime	DATETIME
			)';

		dbms_output.put_line ('Table WFMessageInProcessTable created successfully');

		EXECUTE IMMEDIATE 'CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)';
		dbms_output.put_line ('Index on column lockedBy column of table WFMessageInProcessTable created successfully');
	ELSE
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMessageInProcessTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFMessageInProcessTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFMessageInProcessTable altered with new Column ActionDateTime');
		END;
	END IF;

	
	existsFlag :=0;
	BEGIN
	select count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('CURRENTROUTELOGTABLE');
	IF existsFlag = 1 then
 BEGIN
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_CRouteLogTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_CRouteLogTable ON CurrentRouteLogTable (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of CurrentRouteLogTable created successfully');
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
END;
END IF;
END;



BEGIN
	select count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('HistoryRouteLogTable');
	IF existsFlag = 1 then
 BEGIN
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_HRouteLogTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_HRouteLogTable ON HistoryRouteLogTable (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of HistoryRouteLogTable created successfully');
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
	END;
	END IF;
	END;
	
	
	
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueDataTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueDataTable ON QueueDataTable (var_rec_1, var_rec_2)';
		dbms_output.put_line ('Index on var_rec_1, var_rec_2 of QueueDataTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId)';
	EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				v_SQLCode := -1408;
				IF v_SQLCode <> SQLCODE THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
	END;
	dbms_output.put_line ('Index on Q_QueueId of WorkListTable created successfully');
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState)';
		dbms_output.put_line ('Index on Q_QueueId, WorkItemState of WorkListTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WorkInProcessTable ON WorkInProcessTable (Q_QueueId)';
		dbms_output.put_line ('Index on Q_QueueId of WorkInProcessTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WorkInProcessTable ON WorkInProcessTable (Q_QueueId, WorkItemState)';
		dbms_output.put_line ('Index on Q_QueueId, WorkItemState of WorkInProcessTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_QueueStreamTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)';
		dbms_output.put_line ('Index on QueueId of QueueStreamTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueDefTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (UPPER(RTRIM(QueueName)))';
		dbms_output.put_line ('Index on QueueName of QueueDefTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_VarMappingTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UPPER(RTRIM(UserDefinedName)))';
		dbms_output.put_line ('Index on UserDefinedName of VarMappingTable created successfully');
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

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IX2_WFMessageInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)';
		dbms_output.put_line ('Index on messageId of WFMessageInProcessTable created successfully');
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


	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFFAILEDMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFFailedMessageTable (
				messageId		INT, 
				message			CLOB, 
				lockedBy		NVARCHAR2(63), 
				status			NVARCHAR2(1),
				failureTime		DATE,
				ActionDateTime	DATE
			)';
		dbms_output.put_line ('Table WFFailedMessageTable created successfully');
	ELSE
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFFailedMessageTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFFailedMessageTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFFailedMessageTable altered with new Column ActionDateTime');
		END;
	END IF;

	SAVEPOINT Move;
	BEGIN
		EXECUTE IMMEDIATE
			'Insert Into WFFailedMessageTable
				SELECT messageId, message, NULL, status, SYSDATE, ActionDateTime
				FROM WFMESSAGETABLE 
				WHERE status = ''F''';

		EXECUTE IMMEDIATE 'Delete From WFMessageTable Where status = ''F''';

		EXECUTE IMMEDIATE 'Update WFMessageTable Set LockedBy = null';
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT Move;
			RETURN;
	END;
	COMMIT;

/*	Update ProcessInstanceTable set ExpectedProcessdelay = null;	*/

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFESCALATIONTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	/* New table for feature : Escalation */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFEscalationTable (
				EscalationId		INTEGER,
				ProcessInstanceId	NVARCHAR2(64),
				WorkitemId		INTEGER,
				ProcessDefId		INTEGER,
				ActivityId		INTEGER,
				EscalationMode		NVARCHAR2(20)	NOT NULL,
				ConcernedAuthInfo	NVARCHAR2(256)	NOT NULL,
				Comments		NVARCHAR2(512)	NOT NULL,
				Message			CLOB		NOT NULL,
				ScheduleTime		DATE		NOT NULL
			)';

		dbms_output.put_line ('Table WFEscalationTable created successfully');

		EXECUTE IMMEDIATE 'CREATE SEQUENCE EscalationId INCREMENT BY 1 START WITH 1';
		dbms_output.put_line ('Sequence for EscalationId created successfully');
		EXECUTE IMMEDIATE 'CREATE INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)';
		dbms_output.put_line ('Index on column EscalationMode and ScheduleTime of table WFEscalationTable created successfully');
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFESCINPROCESSTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	/* New table for feature : Escalation */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFEscInProcessTable (
				EscalationId		INTEGER PRIMARY KEY,
				ProcessInstanceId	NVARCHAR2(64),
				WorkitemId		INTEGER,
				ProcessDefId		INTEGER,
				ActivityId		INTEGER,
				EscalationMode		NVARCHAR2(20)	NOT NULL,
				ConcernedAuthInfo	NVARCHAR2(256)	NOT NULL,
				Comments		NVARCHAR2(512)	NOT NULL,
				Message			CLOB		NOT NULL,
				ScheduleTime		DATE		NOT NULL
			)';
		dbms_output.put_line ('Table WFEscInProcessTable created successfully');
	END IF;

	/* New table for feature : JMS */
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE WFJMSMESSAGETABLE (
				messageId        INTEGER, 
				message          CLOB           NOT NULL, 
				destination      NVARCHAR2(256),
				entryDateTime    DATE,
				OperationType	 NVARCHAR2(1)	
			)';

		dbms_output.put_line ('Table WFJMSMESSAGETABLE created successfully');

		EXECUTE IMMEDIATE 'CREATE SEQUENCE JMSMessageId INCREMENT BY 1 START WITH 1';
		dbms_output.put_line ('Sequence for JMSMessageId created successfully');
		
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSMESSAGEINPROCESSTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE WFJMSMESSAGEINPROCESSTABLE (
				messageId		INTEGER, 
				message		CLOB          , 
				destination		NVARCHAR2(256), 
				lockedBy		NVARCHAR2(63), 
				entryDateTime		DATE, 
				lockedTime		DATE,
				OperationType	       NVARCHAR2(1)	
			)';

		dbms_output.put_line ('Table WFJMSMessageInProcessTable created successfully');

	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSFAILEDMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE WFJMSFAILEDMESSAGETABLE (
				messageId		INTEGER, 
				message		CLOB          ,  
				destination		NVARCHAR2(256), 
				entryDateTime		DATE, 
				failureTime		DATE, 
				failureCause		NVARCHAR2(2000),
				OperationType	       NVARCHAR2(1)	
			)';

		dbms_output.put_line ('Table WFJMSFailedMessageTable created successfully');
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSDESTINFO'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFJMSDestInfo(
				destinationId		INTEGER PRIMARY KEY,
				appServerIP		NVARCHAR2(16),
				appServerPort		INTEGER,
				appServerType		NVARCHAR2(16),
				jmsDestName		NVARCHAR2(256) NOT NULL,
				jmsDestType		NVARCHAR2(1) NOT NULL
			) ';

		dbms_output.put_line ('Table WFJMSDestInfo created successfully');
	
		
	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSPUBLISHTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE WFJMSPUBLISHTABLE(
				processDefId		INTEGER,
				activityId		INTEGER,
				destinationId		INTEGER,
				TEMPLATE		CLOB
			) ';

		dbms_output.put_line ('Table WFJMSPublishTable created successfully');

	END IF;

	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSSUBSCRIBETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			CREATE TABLE WFJMSSUBSCRIBETABLE(
				processDefId		INT,
				activityId		INT,
				destinationId		INT,
				extParamName		NVARCHAR2(256),
				processVariableName	NVARCHAR2(256),
				variableProperty	NVARCHAR2(1)
			)';
		dbms_output.put_line ('Table WFJMSSubscribeTable created successfully');
	END IF;

	/* SrNo-2, New tables introduced for new feature - web service invoker - Ruhi Hira */
	/* Creating WFDataStructureTable; WFS_6.1.2_008 */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFDATASTRUCTURETABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	/* Bug # WFS_6.1.2_033, Not null constraint removed from ActivityId - Ruhi Hira */
	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1687 */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFDATASTRUCTURETABLE (
				DataStructureId		INT,
				ProcessDefId		INT		NOT NULL,
				ActivityId		INT,
				ExtMethodIndex		INT		NOT NULL,
				Name			NVARCHAR2(256)	NOT NULL,
				TYPE			SMALLINT	NOT NULL,
				ParentIndex		INT		NOT NULL,
				PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
			)';
		dbms_output.put_line ('Table WFDataStructureTable created successfully');
	END IF;

	/* Creating  WFWebServiceTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFWEBSERVICETABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFWEBSERVICETABLE(
				ProcessDefId		INT		NOT NULL,
				ActivityId		INT		NOT NULL,
				ExtMethodIndex		INT		NOT NULL,
				ProxyEnabled		NVARCHAR2(1),
				TimeOutInterval		INT,
				InvocationType		NVARCHAR2(1)	NOT NULL,
				PRIMARY KEY		(ProcessDefId, ActivityId)
			)';
		dbms_output.put_line ('Table WFWebServiceTable created successfully');
	END IF;

	/* SrNo-6 New table introduced for audit log configuration */
      /*WFS_6.1.2_028-table not being created*/
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFVARSTATUSTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFVARSTATUSTABLE (
			ProcessDefId	INT		NOT NULL ,
			VarName		NVARCHAR2(50)	NOT NULL ,
			Status		NVARCHAR2(1)	DEFAULT ''Y'' NOT NULL ,  
			CONSTRAINT  ck_VarStatus CHECK (Status = ''Y'' OR Status = ''N'' ) 
			)';
		dbms_output.put_line ('Table WFVarStatusTable created successfully');
	END IF;
	
	
	/* SrNo-6 New table introduced for audit log configuration */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFACTIONSTATUSTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFACTIONSTATUSTABLE(
			ActionId	INT		NOT NULL ,
			TYPE		NVARCHAR2(1)	DEFAULT ''C'' NOT NULL , 
			Status		NVARCHAR2(1)	DEFAULT ''Y'' NOT NULL ,
			CONSTRAINT ck_ActionType CHECK (TYPE = ''C'' OR TYPE = ''S'' ) ,
			CONSTRAINT  ck_ActionStatus CHECK (Status = ''Y'' OR Status = ''N'' ) ,
			PRIMARY KEY (ActionId)
			)';
		dbms_output.put_line ('Table WFActionStatusTable created successfully');
	END IF;

	/* SrNo-7, New tables for calendar implementation - Ruhi Hira */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFCALDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalDefTable(
				ProcessDefId	INT, 
				CalId		INT, 
				CalName		NVARCHAR2(256)	NOT NULL UNIQUE,
				GMTDiff		INT,
				LastModifiedOn	DATE,
				Comments	NVARCHAR2(1024),
				PRIMARY KEY	(ProcessDefId, CalId)
			)';
		dbms_output.put_line ('Table WFCalDefTable created successfully');

		EXECUTE IMMEDIATE 'INSERT INTO WFCALDEFTABLE VALUES(0, 1, ''DEFAULT 24/7'', 530, SYSDATE, ''This is the default calendar'')';
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFCALRULEDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalRuleDefTable(
				ProcessDefId	INT, 
				CalId		INT		NOT NULL,
				CalRuleId	INT, 
				Def		NVARCHAR2(256),
				CalDate		DATE,
				Occurrence	SMALLINT,
				WorkingMode	NVARCHAR2(1),
				DayOfWeek	SMALLINT,
				WEF		DATE,
				PRIMARY KEY	(ProcessDefId, CalId, CalRuleId)
			)';
		dbms_output.put_line ('Table WFCalRuleDefTable created successfully');

	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFCALHOURDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalHourDefTable(
				ProcessDefId	INT		NOT NULL,
				CalId		INT		NOT NULL,
				CalRuleId	INT		NOT NULL,
				RangeId		INT		NOT NULL,
				StartTime	INT,
				EndTime		INT,
				PRIMARY KEY (ProcessDefId, CalId, CalRuleId, RangeId)
			)';
		dbms_output.put_line ('Table WFCalHourDefTable created successfully');
		EXECUTE IMMEDIATE 'INSERT INTO WFCALHOURDEFTABLE VALUES (0, 1, 0, 1, 0000, 2400)';
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFCALENDARASSOCTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalendarAssocTable(
				CalId		INT		NOT NULL,
				ProcessDefId	INT		NOT NULL,
				ActivityId	INT		NOT NULL,
				CalType		NVARCHAR2(1)	NOT NULL,
				UNIQUE (processDefId, activityId)
			)';
		dbms_output.put_line ('Table WFCalendarAssocTable created successfully');
	END IF;

	/* Added By Varun Bhansaly On 23/07/2007 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('SuccessLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE SuccessLogTable (  
				LogId INT, 
				ProcessInstanceId NVARCHAR2(63) 
			)';
		dbms_output.put_line ('Table SuccessLogTable Created successfully');
	END;

	/* Added By Varun Bhansaly On 23/07/2007 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('FailureLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE FailureLogTable (  
				LogId INT, 
				ProcessInstanceId NVARCHAR2(63) 
			)';
		dbms_output.put_line ('Table FailureLogTable Created successfully');
	END;



	/* Adding column IntroducedAt in table ProcessInstanceTable*/
	existsFlag :=0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL
		WHERE 
		NOT EXISTS(
			SELECT 1 FROM USER_TAB_COLUMNS
			WHERE UPPER(COLUMN_NAME) ='INTRODUCEDAT' 
			AND TABLE_NAME = 'PROCESSINSTANCETABLE' 
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN

		EXECUTE IMMEDIATE 'ALTER TABLE ProcessInstanceTable ADD (Introducedat NVarchar2(30))';
		EXECUTE IMMEDIATE '
			UPDATE PROCESSINSTANCETABLE 
			SET introducedAt = (SELECT activityName 
						FROM ACTIVITYTABLE 
						WHERE processDefId = PROCESSINSTANCETABLE.processdefId AND activityType = 1
			)';
	END IF;

	/* SrNo-2, Adding column DataStructureId in table ExtMethodParamDefTable - Ruhi Hira */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL
		WHERE 
		NOT EXISTS(
			SELECT 1 FROM USER_TAB_COLUMNS
			WHERE UPPER(COLUMN_NAME) ='DATASTRUCTUREID' 
			AND TABLE_NAME = 'EXTMETHODPARAMDEFTABLE' 
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD (DataStructureId Int)';
		dbms_output.put_line ('Column DataStructureId added to ExtMethodParamDefTable successfully');
	END IF;

	/* SrNo-2, Adding column DataStructureId in table ExtMethodParamMappingTable - Ruhi Hira */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL
		WHERE 
		NOT EXISTS(
			SELECT 1 FROM USER_TAB_COLUMNS
			WHERE UPPER(COLUMN_NAME) ='DATASTRUCTUREID' 
			AND TABLE_NAME = 'EXTMETHODPARAMMAPPINGTABLE' 
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable ADD (DataStructureId Int)';
		dbms_output.put_line ('Column DataStructureId added to ExtMethodParamMappingTable successfully');
	END IF;

	/* For QueueUserFilter */
	existsFlag := 0;	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS  
				WHERE UPPER(TABLE_NAME) = 'QUEUEUSERTABLE'
				AND UPPER(COLUMN_NAME) = 'QUERYFILTER'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD (queryFilter NVarchar2(2000))';
	END IF;

	/* Updating ActivityTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE EXISTS( 
			SELECT 1 FROM USER_TAB_COLUMNS 
			WHERE UPPER(TABLE_NAME) = 'ACTIVITYTABLE'
		) ;  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE' UPDATE Activitytable SET primaryActivity = ' || quoteChar || 'Y' || quoteChar || ' where activityType = 1';
	END IF;

	/* Modifying ActivityTable, changing the datatype of column expiry.... */
	
	/* TODO : check for the alternative for the same... */

	/*Creating Temporary ActivityTable */
	/*
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'ACTIVITYTABLE_TEMP'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE ActivityTable_Temp(
				processDefId		INT,
				activityId		INT,
				expiry			NUMBER
			)';
	END IF;
/*
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			EXISTS( 
			SELECT 1 FROM USER_TAB_COLUMNS  
			WHERE UPPER(TABLE_NAME) = 'ACTIVITYTABLE' 
			AND UPPER(COLUMN_NAME) = 'EXPIRY' 
			AND UPPER(DATA_TYPE) = 'NUMBER'
		);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			INSERT INTO ActivityTable_Temp 
				SELECT processDefId, activityId, expiry FROM ACTIVITYTABLE
			';
		BEGIN
			EXECUTE IMMEDIATE ' ALTER TABLE ActivityTable MODIFY expiry NUMBER NULL';
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE ('Some exception occurred while making expiry as nullable ');
		END;
		EXECUTE IMMEDIATE ' Update ActivityTable SET expiry = null ';
		EXECUTE IMMEDIATE ' Alter Table ActivityTable Modify expiry NVarchar2(255) ';
		EXECUTE IMMEDIATE ' 
			UPDATE ACTIVITYTABLE SET expiry = (SELECT ' || quoteChar || '0*24+' || quoteChar || ' || TO_CHAR(Expiry) 
								FROM ActivityTable_Temp
								WHERE ActivityTable_Temp.processDefId = ACTIVITYTABLE.processDefId
								AND ActivityTable_Temp.activityId = ACTIVITYTABLE.activityId
							)

			';
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'ACTIVITYTABLE_TEMP'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'DROP TABLE ActivityTable_Temp';
	END IF;

	/* Updating RuleOperationTable for operation DISTRIBUTE TO ..... */
	exceptFlag := 0;
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag
		FROM DUAL
		WHERE
		EXISTS(
			SELECT 1 FROM USER_TABLES
			WHERE UPPER(TABLE_NAME) = 'DISTRIBUTEACTIVITYTABLE'
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	
	IF existsFlag = 1 THEN
		v_DistributeActivityTable_Cur := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(
			v_DistributeActivityTable_Cur, 
			' SELECT processDefId, activityId, targetActivityId from DistributeActivityTable ',
			DBMS_SQL.NATIVE);
		DBMS_SQL.DEFINE_COLUMN(v_DistributeActivityTable_Cur, 1, v_dist_processDefId);
		DBMS_SQL.DEFINE_COLUMN(v_DistributeActivityTable_Cur, 2, v_dist_activityId);
		DBMS_SQL.DEFINE_COLUMN(v_DistributeActivityTable_Cur, 3, v_dist_targetActivityId);
		ret := DBMS_SQL.EXECUTE(v_DistributeActivityTable_Cur);

		LOOP
			IF DBMS_SQL.FETCH_ROWS(v_DistributeActivityTable_Cur) = 0 THEN
				EXIT;
			END IF;
			DBMS_SQL.COLUMN_VALUE(v_DistributeActivityTable_Cur, 1, v_dist_processDefId);
			DBMS_SQL.COLUMN_VALUE(v_DistributeActivityTable_Cur, 2, v_dist_activityId);
			DBMS_SQL.COLUMN_VALUE(v_DistributeActivityTable_Cur, 3, v_dist_targetActivityId);
			
			BEGIN 
				EXECUTE IMMEDIATE 'SELECT activityName FROM ACTIVITYTABLE WHERE activityId = ' || TO_CHAR(v_dist_targetActivityId) || 'AND ActivityTable.processDefId = ' || TO_CHAR(v_dist_processDefId) INTO v_activityName;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
					 BEGIN
						v_activityName := NULL;
						dbms_output.put_line ('Activity with No Name!!!');
					 END;
			END;

			IF (v_activityName IS NOT NULL) THEN 
			BEGIN
				EXECUTE IMMEDIATE
				'INSERT INTO RULEOPERATIONTABLE (PROCESSDEFID, ACTIVITYID, RULETYPE, RULEID, OPERATIONTYPE, PARAM1, TYPE1, EXTOBJID1, PARAM2, TYPE2, EXTOBJID2, PARAM3, TYPE3, EXTOBJID3, OPERATOR, OPERATIONORDERID, COMMENTFLAG) VALUES(' || TO_CHAR(v_dist_processDefId) || ', ' || TO_CHAR(v_dist_activityId) ||
				', N' || quoteChar || 'D' || quoteChar || ', 1,	21, N' || quoteChar || TO_CHAR(v_activityName) || quoteChar || ',	N' || quoteChar || 'V' || quoteChar || 
				', 0, N' || quoteChar || ' ' || quoteChar || ', N' || quoteChar || 'V' || quoteChar || ', 0, N' || quoteChar || quoteChar || ', N' || quoteChar || quoteChar || ', 0, 0, NVL((SELECT (MAX(OperationOrderId) + 1) FROM RULEOPERATIONTABLE WHERE processDefId = ' || TO_CHAR(v_dist_processDefId) || ' AND activityId = ' || TO_CHAR(v_dist_activityId) || ' AND operationType = 21 AND ruleType = ' || quoteChar || 'D' || quoteChar || ' AND ruleId = 1), 1), N' || 
				quoteChar || 'N' || quoteChar || ')';
			EXCEPTION 
				WHEN OTHERS THEN
				BEGIN
					dbms_output.put_line ('Exception Inserting Data!!!');
				END;
			END;
			END IF;
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(v_DistributeActivityTable_Cur);

		v_cursor1 := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(v_cursor1, 'SELECT processDefId, activityId FROM RuleOperationTable WHERE RuleType = N''D'' group by processDefId, activityId', DBMS_SQL.NATIVE);
		DBMS_SQL.DEFINE_COLUMN(v_cursor1, 1, v_dist_processDefId);
		DBMS_SQL.DEFINE_COLUMN(v_cursor1, 2, v_dist_activityId);
		ret1 := DBMS_SQL.EXECUTE(v_cursor1);
		SAVEPOINT savepoint1;
		LOOP
			IF(DBMS_SQL.FETCH_ROWS(v_cursor1) = 0) THEN
				EXIT;
			END IF;
			DBMS_SQL.COLUMN_VALUE(v_cursor1, 1, v_dist_processDefId);
			DBMS_SQL.COLUMN_VALUE(v_cursor1, 2, v_dist_activityId);
			v_cursor2 := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(v_cursor2, 'SELECT distinct(ruleId) FROM RULEOPERATIONTABLE WHERE RuleType = N''D'' AND processDefId = ' || v_dist_processDefId || ' AND activityId = ' || v_dist_activityId, DBMS_SQL.NATIVE);
			DBMS_SQL.DEFINE_COLUMN(v_cursor2, 1, v_ruleId);
			ret2 := DBMS_SQL.EXECUTE(v_cursor2);
			LOOP
				IF(DBMS_SQL.FETCH_ROWS(v_cursor2) = 0) THEN
					EXIT;
				END IF;
				DBMS_SQL.COLUMN_VALUE(v_cursor2, 1, v_ruleId);
				BEGIN
					SELECT 1 INTO existsFlag FROM RuleConditionTable WHERE RuleType = N'D' AND ruleId = v_ruleId AND processDefId = v_dist_processDefId AND activityId = v_dist_activityId;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						INSERT INTO RuleConditionTable(
								ProcessDefId, ActivityId, RuleType, 
								RuleOrderId, RuleId, ConditionOrderId,  
								Param1,	Type1, ExtObjID1, 
								Param2, Type2, ExtObjID2, 
								Operator, LogicalOp)
						VALUES(
								v_dist_processDefId, v_dist_activityId, N'D', 
								v_ruleId, v_ruleId, v_ruleId, 
								N'ALWAYS', N'S', 0, 
								N'ALWAYS', N'S', 0, 
								4, 4);
					EXCEPTION
						WHEN OTHERS THEN
							ROLLBACK TO SAVEPOINT savepoint1;			
							DBMS_SQL.CLOSE_CURSOR(v_cursor2);
							DBMS_SQL.CLOSE_CURSOR(v_cursor1);
							RETURN;
					END;
				END;
			END LOOP;
			DBMS_SQL.CLOSE_CURSOR(v_cursor2);
		END LOOP;
		COMMIT;
		DBMS_SQL.CLOSE_CURSOR(v_cursor1);
		v_dropFlag := 1;
	END IF;

	IF(v_dropFlag = 1) THEN        
		EXECUTE IMMEDIATE 'DROP TABLE DistributeActivityTable';
	END IF;

	
	/* Modifying constraint on ActivityTable */
	OPEN Constraint_CurA;
	LOOP
		FETCH Constraint_CurA INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurA%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%SERVERINTERFACE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurA;

	EXECUTE IMMEDIATE ' ALTER TABLE ACTIVITYTABLE ADD CONSTRAINT CK_ACTTAB_SERINT CHECK (ServerInterface IN (N' || quoteChar || 'Y' || quoteChar || ', N' || quoteChar || 'N' || quoteChar || ', N' || quoteChar || 'E' || quoteChar || '))';

	/* Modifying constraint on ExtMethodDefTable, WFS_6.1.2_009 */
	OPEN Constraint_CurB;
	LOOP
		FETCH Constraint_CurB INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurB%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%RETURNTYPE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurB;

	EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_RET CHECK (ReturnType IN (0, 3, 4, 6, 8, 10, 11, 12, 15, 16))';

	/* Modifying constraint on ExtMethodParamDefTable */
	OPEN Constraint_CurC;
	LOOP
		FETCH Constraint_CurC INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurC%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%PARAMETERTYPE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurC;

	EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM CHECK (ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 15, 16))';
	
	/* Altering table UserWorkAuditTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'USERWORKAUDITTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE '
			ALTER TABLE USERWORKAUDITTABLE MODIFY(WORKITEMCOUNT	NVARCHAR2(100))
		';
		BEGIN
			DBMS_OUTPUT.PUT_LINE('USERWORKAUDITTABLE column length altered ... ');
		END;
	END IF;

	/* Change for ProcessDefTable - Changes done by Ishu Saraf 13/01/09 */ 
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ProcessDefTable') 
		AND 
		COLUMN_NAME=UPPER('CreatedOn');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		BEGIN
			EXECUTE IMMEDIATE '
				ALTER TABLE PROCESSDEFTABLE ADD(
					CreatedOn		DATE,
					WSFont			NVARCHAR2(255), 
					WSColor			INTEGER, 
					CommentsFont	NVARCHAR2(255), 
					CommentsColor	INTEGER, 
					BackColor		INTEGER
				)';

			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('ProcessDefTable') 
				AND 
				COLUMN_NAME=UPPER('LastModifiedOn');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'ALTER TABLE ProcessDefTable ADD LastModifiedOn DATE';
					EXECUTE IMMEDIATE 'UPDATE ProcessDefTable SET LastModifiedOn = SYSDATE, CreatedOn = SYSDATE';
			END;
				
			IF existsFlag = 1 THEN
			BEGIN	
				EXECUTE IMMEDIATE 'UPDATE ProcessDefTable SET CreatedOn = LastModifiedOn';
			END;
			END IF;
			
		END;

		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ProcessDefTable';
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					EXECUTE IMMEDIATE 'Alter Table ProcessDefTable rename to TempProcessDefTable';
					EXECUTE IMMEDIATE 
						'CREATE TABLE ProcessDefTable (
							ProcessDefId			INT				NOT NULL	PRIMARY KEY ,
							VersionNo				SMALLINT		NOT NULL ,
							ProcessName				NVARCHAR2 (30)	NOT NULL ,
							ProcessState			NVARCHAR2 (10)		NULL ,
							RegPrefix				NVARCHAR2 (20)	NOT NULL ,
							RegSuffix				NVARCHAR2 (20)		NULL ,
							RegStartingNo			INT					NULL,
							ProcessTurnAroundTime	INT					NULL,
							RegSeqLength			INT					NULL,
							createdOn				DATE				NULL , 
							lastModifiedOn			DATE				NULL ,
							WSFont					NVARCHAR2(255)		NULL,
							WSColor					INT					NULL,
							CommentsFont			NVARCHAR2(255)		NULL,
							CommentsColor			INT					NULL,
							Backcolor				INT					NULL
						)';
						DBMS_OUTPUT.PUT_LINE ('Table ProcessDefTable Created successfully.....'	);
						SAVEPOINT save;
							EXECUTE IMMEDIATE 'INSERT INTO ProcessDefTable SELECT ProcessDefId, VersionNo, ProcessName, ProcessState, RegPrefix, RegSuffix, RegStartingNo, ProcessTurnAroundTime, RegSeqLength, CreatedOn, LastModifiedOn, WSFont, WSColor, CommentsFont, CommentsColor, Backcolor FROM TempProcessDefTable ';
							EXECUTE IMMEDIATE 'DROP TABLE TempProcessDefTable';
							DBMS_OUTPUT.PUT_LINE ('Table TempProcessDefTable dropped successfully...........'	);
							EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ProcessDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
						COMMIT;
				END;	
		END;
	END;

	/* Dropping constraint on Type1 column of VarAliasTable */
	OPEN Constraint_Cur;
	LOOP
		FETCH Constraint_Cur INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_Cur%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%TYPE1%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
			BEGIN
				dbms_output.put_line('Dropping constraint on VarAliasTable ... ');
			END;
		END IF;
	 END LOOP;
	 CLOSE Constraint_Cur;
	
	/* Trigger UPDATE_FINALIZATION_STATUS disabled */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			EXISTS( 
				SELECT 1 FROM USER_TRIGGERS
				WHERE UPPER(TRIGGER_NAME) = 'UPDATE_FINALIZATION_STATUS'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALter Trigger Update_Finalization_Status Disable';
		BEGIN
			dbms_output.put_line('Trigger Update_Finalization_Status created ... ');
		END;
	END IF;

	/* Modifying Trigger TR_LOG_PDBCONNECTION */
/* Checks applioed for currentroutelog and wfcurrentroutelogtable*/
existsFlag :=0;
BEGIN
	Select count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('CURRENTROUTELOGTABLE');
	IF existsFlag = 1 then	
	EXECUTE IMMEDIATE '
		CREATE OR REPLACE TRIGGER TR_LOG_PDBCONNECTION
			AFTER DELETE OR INSERT
			ON PDBCONNECTION 
			FOR EACH ROW 
		DECLARE 
			v_userName CURRENTROUTELOGTABLE.USERNAME%TYPE; 
		BEGIN 
			IF INSERTING THEN 
				SELECT TRIM(userName) INTO v_userName FROM PDBUSER WHERE userindex = :NEW.userindex; 
				INSERT INTO CURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId ,ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :NEW.userindex, 24, SYSDATE, :NEW.userindex, v_userName, NULL, v_userName); 
			ELSIF DELETING THEN 
				SELECT TRIM(userName) INTO v_userName FROM PDBUSER WHERE userindex = :OLD.userindex; 
				INSERT INTO CURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :OLD.userindex, 23, SYSDATE, :OLD.userindex, v_userName, NULL, v_userName); 
			END IF; 
		END;
	';
	BEGIN
		dbms_output.put_line('Trigger TR_LOG_PDBCONNECTION created ... ');
	END;
	END IF;
END;
	

	
existsFlag :=0;
BEGIN
	Select Count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('WFCURRENTROUTELOGTABLE');
	IF existsFlag = 1 then	
	EXECUTE IMMEDIATE '
		CREATE OR REPLACE TRIGGER TR_LOG_PDBCONNECTION
			AFTER DELETE OR INSERT
			ON PDBCONNECTION 
			FOR EACH ROW 
		DECLARE 
			v_userName WFCURRENTROUTELOGTABLE.USERNAME%TYPE; 
		BEGIN 
			IF INSERTING THEN 
				SELECT TRIM(userName) INTO v_userName FROM PDBUSER WHERE userindex = :NEW.userindex; 
				INSERT INTO WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId ,ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :NEW.userindex, 24, SYSDATE, :NEW.userindex, v_userName, NULL, v_userName); 
			ELSIF DELETING THEN 
				SELECT TRIM(userName) INTO v_userName FROM PDBUSER WHERE userindex = :OLD.userindex; 
				INSERT INTO WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :OLD.userindex, 23, SYSDATE, :OLD.userindex, v_userName, NULL, v_userName); 
			END IF; 
		END;
	';
	
	BEGIN
		dbms_output.put_line('Trigger TR_LOG_PDBCONNECTION created ... ');
	END;
	
	END IF;
END;
	
	
	
	/* Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
		NOT EXISTS( 
			SELECT 1 FROM QUEUESTREAMTABLE
			GROUP BY ProcessDefId, ActivityId, StreamId
			HAVING COUNT(*) > 1 
		);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		SELECT constraint_name INTO v_constraintName FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'QUEUESTREAMTABLE';
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE DROP Constraint ' || v_constraintName;
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE ADD CONSTRAINT QST_PRIM PRIMARY KEY (ProcessDefId, ActivityId, StreamId)';
		dbms_output.put_line ('Primary Key updated for QueueStreamTable');
	ELSE
		dbms_output.put_line ('Invalid Data in QueueStreamTable'); 
	END IF;

	/* END Altering Constraint on QueueStreamTable WFS_6.1.2_043 */

	/* Modifying view  QUserGroupView */

	EXECUTE IMMEDIATE 
		' CREATE OR REPLACE VIEW QUSERGROUPVIEW  
		 AS 
			SELECT * FROM (  
				SELECT queueid, userid, cast ( NULL AS INTEGER ) AS GroupId, assignedtilldatetime, queryFilter 
				FROM QUEUEUSERTABLE  
				WHERE associationtype = 0 
				AND ( 
					assignedtilldatetime IS NULL OR assignedtilldatetime> = SYSDATE 
				) 
				UNION 
				SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter 
				FROM QUEUEUSERTABLE, wfgroupmemberview 
				WHERE associationtype = 1  
				AND QUEUEUSERTABLE.userid = wfgroupmemberview.groupindex 
			      )a'; 

	/* SrNo-1, For license implementation, type of column data is changed from CLOB to NVarchar2(2000) - Ruhi */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE EXISTS(
			SELECT	1
			FROM	USER_TAB_COLUMNS
			WHERE	TABLE_NAME	= 'PSREGISTERATIONTABLE'
			AND	COLUMN_NAME	= 'DATA'
			AND	DATA_TYPE	= 'CLOB'
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			' CREATE TABLE TempPSRegisterationTable
			AS
			SELECT PSId, PSName, TYPE, SessionId, ProcessDefId, TO_NCHAR(Data) Data
			FROM PSREGISTERATIONTABLE';

		EXECUTE IMMEDIATE 'DROP TABLE PSRegisterationTable';

		EXECUTE IMMEDIATE 'RENAME TempPSRegisterationTable TO PSRegisterationTable';
	END IF;
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_PS_ID_TRIGGER BEFORE INSERT ON PSREGISTERATIONTABLE FOR EACH ROW BEGIN SELECT PSID.nextval INTO :new.PSID FROM dual;END;';

	/* Modifying view QueueTable */
	EXECUTE IMMEDIATE ' 
		CREATE OR REPLACE VIEW QueueTable
		AS
			SELECT  queuetable1.processdefid, processname, processversion, 
				queuetable1.processinstanceid, queuetable1.processinstanceid AS processinstancename, 
				queuetable1.activityid, queuetable1.activityname, 
				QUEUEDATATABLE.parentworkitemid, queuetable1.workitemid, 
				processinstancestate, workitemstate, statename, queuename, queuetype,
				assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
				introductiondatetime, PROCESSINSTANCETABLE.createddatetime AS createddatetime,
				introducedby, createdbyname, entrydatetime,
				lockstatus, holdstatus, prioritylevel, lockedbyname, 
				lockedtime, validtill, savestage, previousstage,
				expectedworkitemdelay AS expectedworkitemdelaytime,
				expectedprocessdelay AS expectedprocessdelaytime, status, 
				var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 
				var_float1, var_float2, 
				var_date1, var_date2, var_date3, var_date4, 
				var_long1, var_long2, var_long3, var_long4, 
				var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
				var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
				q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
				referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime
			FROM QUEUEDATATABLE, 
			PROCESSINSTANCETABLE,
			  (SELECT processinstanceid, workitemid, processname, processversion,
				  processdefid, LastProcessedBy, processedby, activityname, activityid,
				  entrydatetime, parentworkitemid, assignmenttype,
				  collectflag, prioritylevel, validtill, q_streamid,
				  q_queueid, q_userid, assigneduser, createddatetime,
				  workitemstate, expectedworkitemdelay, previousstage,
				  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
				  statename
			     FROM WORKLISTTABLE
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
				  processdefid, LastProcessedBy, processedby, activityname, activityid,
				  entrydatetime, parentworkitemid, assignmenttype,
				  collectflag, prioritylevel, validtill, q_streamid,
				  q_queueid, q_userid, assigneduser, createddatetime,
				  workitemstate, expectedworkitemdelay, previousstage,
				  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
				  statename
			     FROM WORKINPROCESSTABLE
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
				  processdefid, LastProcessedBy, processedby, activityname, activityid,
				  entrydatetime, parentworkitemid, assignmenttype,
				  collectflag, prioritylevel, validtill, q_streamid,
				  q_queueid, q_userid, assigneduser, createddatetime,
				  workitemstate, expectedworkitemdelay, previousstage,
				  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
				  statename
			     FROM WORKDONETABLE
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
				  processdefid, LastProcessedBy, processedby, activityname, activityid,
				  entrydatetime, parentworkitemid, assignmenttype,
				  collectflag, prioritylevel, validtill, q_streamid,
				  q_queueid, q_userid, assigneduser, createddatetime,
				  workitemstate, expectedworkitemdelay, previousstage,
				  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
				  statename
			     FROM WORKWITHPSTABLE
			   UNION ALL
			   SELECT processinstanceid, workitemid, processname, processversion,
				  processdefid, LastProcessedBy, processedby, activityname, activityid,
				  entrydatetime, parentworkitemid, assignmenttype,
				  collectflag, prioritylevel, validtill, q_streamid,
				  q_queueid, q_userid, assigneduser, createddatetime,
				  workitemstate, expectedworkitemdelay, previousstage,
				  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
				  statename
			     FROM PENDINGWORKLISTTABLE) queuetable1
		    WHERE QUEUEDATATABLE.processinstanceid = queuetable1.processinstanceid
		      AND QUEUEDATATABLE.workitemid = queuetable1.workitemid
		      AND queuetable1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid
	';
	BEGIN
		dbms_output.put_line('View QueueTable created ... ');
	END;


	/* Modifying view QueueView 
	EXECUTE IMMEDIATE ' 
		CREATE OR REPLACE VIEW QueueView 
		AS 
			SELECT * FROM QueueTable
			UNION ALL 
			SELECT * FROM QUEUEHISTORYTABLE
	';
	BEGIN
		dbms_output.put_line('View QueueView created ... ');
	END;
	*/
	/* Modifying WFWorkListView_0 */
	BEGIN
		dbms_output.put_line('Modifying WFWorkListView_0 ... ');
	END;

	v_varStr := '';
	v_aliasName := '';

	OPEN Alias_Cur;
	LOOP
		FETCH Alias_Cur INTO v_aliasName, v_param1, v_param2, v_operator;
		EXIT WHEN Alias_Cur%NOTFOUND;

		IF UPPER(v_param1) = 'CURRENTDATETIME' THEN 
			v_varStr := v_varStr + ', sysDate';
		ELSE
			v_varStr := v_varStr || ', ' || v_param1;
		END IF;
		
		IF v_param2 IS NOT NULL AND v_operator IS NOT NULL THEN 
			IF v_operator = 11 THEN 
				v_varStr := v_varStr || ' + ';
			END IF;
			IF v_operator = 12 THEN 
				v_varStr := v_varStr || ' - ';
			END IF;
			IF v_operator = 13 THEN 
				v_varStr := v_varStr || ' * ';
			END IF;
			IF v_operator = 14 THEN 
				v_varStr := v_varStr || ' / ';
			END IF;
			
			IF v_param2 = 'Currentdatetime' THEN
				v_varStr := v_varStr || ', sysDate';
			ELSIF v_param2 = 'CreatedDateTime' THEN 
				v_varStr := v_varStr || ' Processinstancetable.' || v_param2;
			ELSE
				v_varStr := v_varStr || v_param2;
			END IF;
		END IF;

		v_varStr := v_varStr || ' as ' || v_aliasName;
	
	END LOOP;
	CLOSE Alias_Cur;

	v_Query := 
		' CREATE OR REPLACE VIEW WFWORKLISTVIEW_0 AS ' ||
		' Select Worklisttable.ProcessInstanceId, Worklisttable.ProcessInstanceId as ProcessInstanceName, Worklisttable.ProcessDefId, ' ||
		' ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, ' ||
		' LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, Statename, CheckListCompleteFlag, ' ||
		' EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, Worklisttable.WorkItemId, ' ||
		' QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ' ||
		' (ExpectedWorkItemDelay - entrydatetime) * 24.0 as TurnaroundTime, ReferredByname, null ReferTo, ' ||
		' Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, Worklisttable.ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, ' ||
		' WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, ' ||
		' VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, ' ||
		' VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 ' ||  
		v_varStr ||
		' from Worklisttable, ProcessInstanceTable, QueueDatatable ' ||
		' where Worklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId ' ||
		' and Worklisttable.Workitemid =QueueDatatable.Workitemid ' ||
		' and Worklisttable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId  ' ||
		' UNION ALL ' ||
		' Select PendingWorklisttable.ProcessInstanceId, PendingWorklisttable.ProcessInstanceId as ProcessInstanceName, ' ||
		' PendingWorklisttable.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, ' ||
		' LockStatus, LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, Statename, CheckListCompleteFlag, ' ||
		' EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, PendingWorklisttable.WorkItemId, ' ||
		' QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ' ||
		' (ExpectedWorkItemDelay - entrydatetime) * 24.0 as TurnaroundTime, ReferredByname, ' ||
		' null ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, PendingWorklisttable.ParentWorkItemId, ProcessedBy, ' ||
		' LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, ' ||
		' VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, ' ||
		' VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 ' ||  
		v_varStr ||
		' from PendingWorklisttable, ProcessInstanceTable, QueueDatatable ' ||
		' where ' ||
		' PendingWorklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId ' ||
		' and PendingWorklisttable.Workitemid = QueueDatatable.Workitemid ' ||
		' and PendingWorklisttable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId ' ||
		' UNION ALL ' ||
		' Select WorkInProcessTable.ProcessInstanceId, WorkInProcessTable.ProcessInstanceId as ProcessInstanceName, ' ||
		' WorkInProcessTable.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, ' ||
		' InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, ' ||
		' Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, ' ||
		' IntroducedBy, AssignedUser, WorkInProcessTable.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, ' ||
		' QueueType, Status, Q_QueueID, (ExpectedWorkItemDelay - entrydatetime) * 24.0 as TurnaroundTime, ' ||
		' ReferredByname, null ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, WorkInProcessTable.ParentWorkItemId, ' ||
		' ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, ' ||
		' VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, ' ||
		' VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 ' ||  
		v_varStr || 
		' from WorkInProcessTable, ProcessInstanceTable, QueueDatatable where ' ||
		' WorkInProcessTable.ProcessInstanceid = QueueDatatable.ProcessInstanceId ' ||
		' and WorkInProcessTable.Workitemid = QueueDatatable.Workitemid ' ||
		' and WorkInProcessTable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId ';
	BEGIN
		dbms_output.put_line('WFWorkListView_0 created ... ' );
	END;
	EXECUTE IMMEDIATE TO_CHAR(v_query); 

	/* SrNo-7, Changes for calendar implementation - Ruhi Hira */
	/* Altering Table ProccessDefTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'PROCESSDEFTABLE' 
				AND UPPER(column_Name) = 'TATCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table PROCESSDEFTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ProcessDefTable set TATCalFlag = N''N''';
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ProcessDefTable ... ');
		END;
	END IF;

	/* Altering Table ActivityTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'ACTIVITYTABLE' 
				AND UPPER(column_Name) = 'TATCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(TATCalFlag NVARCHAR2(1) NULL, 
					ExpCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set TATCalFlag = N''N'', ExpCalFlag = N''N'' ';
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ActivityTable ... ');
		END;
	END IF;


	/* Altering Table RuleOperationTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'RULEOPERATIONTABLE' 
				AND UPPER(column_Name) = 'RULECALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table RULEOPERATIONTABLE ADD(RuleCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update RuleOperationTable set RuleCalFlag = N''N''';
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Column RuleCalFlag added to RuleOperationTable ... ');
		END;
	END IF;
	/* Added By   : Varun Bhansaly
	   Added On   : 09/01/2007
	   Reason     : Bugzilla Bug 370
	   *****************************
	   IMPORTANT :: IN FUTURE, WHEN MAIL LOGGING FEATURE IS IMPLEMENTED IN OMNIFLOW (v7.X OR LATER) 
					THE SQL STATEMENTS WRITTEN BELOW SHOULD BE REMOVED FROM THIS FILE.
	   ****************************
    */
	/* actionId for WFL_Constant_Updated = 78 */
	/* Checks appied for currentroutelog and wfcurrentorutelogtable*/
	existsFlag :=0;
BEGIN
	Select count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('CURRENTROUTELOGTABLE');
	IF existsFlag = 1 then
	BEGIN
		EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionId = 78 WHERE actionId = 70';
	/* actionId for WFL_WorkItemSuspended = 79 */
		Execute Immediate 'UPDATE CURRENTROUTELOGTABLE SET actionId = 79 WHERE actionId = 71';
	END;
	END IF;
END;

	existsFlag :=0;
BEGIN
	select 1 into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('WFCURRENTROUTELOGTABLE');
	IF existsFlag = 1 then
	BEGIN
		EXECUTE IMMEDIATE 'UPDATE WFCURRENTROUTELOGTABLE SET actionId = 78 WHERE actionId = 70';
	/* actionId for WFL_WorkItemSuspended = 79 */
	EXECUTE IMMEDIATE 'UPDATE WFCURRENTROUTELOGTABLE SET actionId = 79 WHERE actionId = 71';
	END;
	END IF;
END;


	/* Added By Varun Bhansaly On 23/07/2007 */
	UPDATE ActivityTable SET expiry = ('0*24 + ' || expiry) WHERE expiry IS NOT NULL AND expiry != '0' AND INSTR(expiry, '*', 1) = 0;
    UPDATE ActivityTable SET expiry = null where expiry = '0';

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('CheckOutProcessesTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE CheckOutProcessesTable( 
				ProcessDefId            INTEGER			NOT NULL,
				ProcessName             NVARCHAR2(30)	NOT NULL, 
				CheckOutIPAddress       VARCHAR2(50)	NOT NULL, 
				CheckOutPath            NVARCHAR2(255)  NOT NULL,
				ProcessStatus			NVARCHAR2(1)	NULL
			)';
			DBMS_OUTPUT.PUT_LINE('Table CheckOutProcessesTable Created successfully');
	END;

END; 

~ 
	Call Upgrade() 
~
	Drop Procedure Upgrade 
~

/* Procedure to add folders / documents for rights management ( if required ) */

Create OR Replace PROCEDURE Upgradation_RightsManagement AS
	v_ProcessFolderName		varchar2(30);
	v_QueueFolderName		varchar2(30);
	v_imageVolumeIndex		int;
	v_processName			varchar2(30);
	v_queueName			varchar2(63);
	v_folderId			int;
	v_documentId			int;
	v_order				int;
	existsFlag			int;
	quoteChar			VARCHAR2(1);

	CURSOR process_cursor IS
		Select Distinct(ProcessName) From ProcessDefTable;
	CURSOR queue_cursor IS
		Select QueueName From QueueDefTable; 
Begin
	v_imageVolumeIndex	:= null;
	v_ProcessFolderName	:= 'ProcessFolder';
	v_QueueFolderName	:= 'QueueFolder';
	quoteChar		:= CHR(39);

	Update PDBDocument set appname = 'TXT' where Upper(RTRIM(appname)) = 'TX';
	
	Select imageVolumeIndex into v_imageVolumeIndex from PDBFolder Where FolderIndex = 0;

	If v_imageVolumeIndex is null THEN
		/* TODO : some return value required, to check the error. */
		Begin
			dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
			dbms_output.put_line('ERROR : Check this case No Record Found in PDBFolder for FolderIndex 0 ');
			dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
		End;
		return;
	END IF;

	existsFlag := 0;
	BEGIN
		Select 1 INTO existsFlag 
		FROM DUAL 
		WHERE NOT EXISTS 
		(
			Select * 
			from PDBFolder 
			where RTRIM(UPPER(Name)) = UPPER(v_ProcessFolderName)
		);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
	END;
	IF existsFlag = 1 THEN
		SAVEPOINT PROCESS_TRANS;
			Insert Into PDBFolder(
				FolderIndex,
				ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
				AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
				FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
				EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,
				FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
				LockMessage, FolderLevel 
				)
			values (
				FolderId.NEXTVAL,
				0, v_ProcessFolderName, 1, sysDate, sysDate,
				sysDate, 0, 'S', v_imageVolumeIndex,
				'G', 'N', null, 'G', TO_DATE('2055/12/31', 'yyyy/mm/dd'),
				'N', TO_DATE('2055/12/31', 'yyyy/mm/dd'), '', null, 'G1#010000, ', 'N',
				sysDate, 0, 'N', 0, 'N',
				null, 2 
				);

			Select FolderIndex INTO v_folderId from PDBFolder Where RTRIM(UPPER(Name)) = UPPER(v_ProcessFolderName);

			OPEN process_cursor;
			v_order := 0;
			LOOP
				FETCH process_cursor INTO v_processName;
				EXIT WHEN process_cursor%NOTFOUND;
				
				existsFlag := 0;
				Begin
					Select 1 INTO existsFlag 
					FROM DUAL WHERE 
					NOT EXISTS (		
						Select * FROM pdbdocument 
						INNER JOIN pdbdocumentcontent
						ON pdbdocument.documentIndex = pdbdocumentContent.documentIndex 
						AND parentFolderindex = v_folderId 
						AND name = v_processName
					);
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						existsFlag := 0;
				END;
				If existsFlag = 1 THEN
					v_order := v_order + 1;
					BEGIN
						Insert Into PDBDocument	(
							DocumentIndex,
							VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
							RevisedDateTime, AccessedDateTime, DataDefinitionIndex,
							Versioning, AccessType, DocumentType, CreatedbyApplication,
							CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,
							FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
							DocumentLock, LockByUser, Commnt, Author, TextImageIndex,
							TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
							FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,
							CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,
							AppName, MainGroupId, PullPrintFlag, ThumbNailFlag, 
							LockMessage 
							) 
						values(
							DocumentId.NEXTVAL,
							1.0, 'Original', v_processName, 1, sysDate,
							sysDate, sysDate, 0,
							'N', 'S', 'N', 0, 
							1, -1, -1, 0, 0,
							0, 'not defined', 'N', 
							'N', null, '', 'supervisor', 0, 
							0, 'XX', 'A', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 
							'N', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 0, 'N',
							0, null, null, 'not defined', 'N',
							'txt', 0, 'N', 'N', 
							null
							);
			
						Select DocumentIndex INTO v_documentId from PDBDocument 
						Where Name = v_processName;
						
						Insert Into PDBDocumentContent	(
							ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
							DocumentOrderNo, RefereceFlag, DocStatus
							) 
						values(
							v_folderId, v_documentId, 1, sysDate,
							v_order, 'O', 'A'
							);
					EXCEPTION
						WHEN OTHERS THEN 
							ROLLBACK TO SAVEPOINT PROCESS_TRANS;
							dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
							dbms_output.put_line('  Check this case Some Exception occurred while creating document for ' || v_processName);
							dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
							EXIT;
					END;

				ELSE
					/*
					TODO : Add debug prints here as document with the 
					same name already exists in the folder.
					*/
					Begin
						dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
						dbms_output.put_line('  Check this case Some Document exists with name ' || quoteChar || v_ProcessName || quoteChar);
						dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
					End;
				END IF;
			
			END LOOP;
			CLOSE process_cursor;
		
		COMMIT;
	ELSE
		/*
		TODO : Add debug prints here as folder with 
		name 'ProcessFolder' already exists in the folder.
		*/
		Begin
			dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
			dbms_output.put_line('  Check this case Some Folder exists with name ' || quoteChar || v_ProcessFolderName || quoteChar);
			dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
		End;
	END IF;
	
	existsFlag := 0;
	Begin
		Select 1 INTO existsFlag FROM DUAL WHERE 
		NOT EXISTS (Select * from PDBFolder where RTRIM(UPPER(Name)) = UPPER(v_QueueFolderName));
	Exception
		WHEN NO_DATA_FOUND THEN
			existsFlag := 0;
	END;
	IF existsFlag = 1 THEN
			Insert Into PDBFolder(
				FolderIndex,
				ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
				AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
				FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
				EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,
				FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
				LockMessage, FolderLevel 
			) 
			values (
				FolderId.NEXTVAL,
				0, v_QueueFolderName, 1, sysDate, sysDate,
				sysDate, 0, 'S', v_imageVolumeIndex,
				'G', 'N', null, 'G', TO_DATE('2055/12/31', 'yyyy/mm/dd'),
				'N', TO_DATE('2055/12/31', 'yyyy/mm/dd'), '', null, 'G1#010000, ', 'N',
				sysDate, 0, 'N', 0, 'N',
				null, 2 
			);
	 END IF;
	
	Select FolderIndex INTO v_folderId from PDBFolder Where UPPER(Name) = UPPER(v_QueueFolderName);
			v_order := 0;
	OPEN queue_cursor;
	LOOP
	FETCH queue_cursor INTO v_queueName;
	EXIT WHEN queue_cursor%NOTFOUND;
		Begin
			Select 1 INTO existsFlag FROM DUAL WHERE NOT EXISTS (Select * from pdbdocument where UPPER(Name) = UPPER(v_queueName));
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					existsFlag := 0;
			END;
			If existsFlag = 1 THEN
			        Insert Into PDBDocument	(
						DocumentIndex,VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
						RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,
						CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
						DocumentLock, LockByUser, Commnt, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
						FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId, PullPrintFlag, ThumbNailFlag,LockMessage)
					values(DocumentId.NEXTVAL,1.0, 'Original', v_queueName, 1, sysDate,sysDate, sysDate, 0,
						'N', 'S', 'N', 0,1, -1, -1, 0, 0,0, 'not defined', 'N', 
						'N', null, '', 'supervisor', 0,0, 'XX', 'A', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 
						'N', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 0, 'N',0, null, null, 'not defined', 'N',
						'txt', 0, 'N', 'N',null);
			END IF;
			
			Select DocumentIndex INTO v_documentId from PDBDocument Where RTRIM(UPPER(Name)) = RTRIM(UPPER(v_queueName));
			
			existsFlag := 0;
			Begin
				Select 1 INTO existsFlag FROM DUAL WHERE NOT EXISTS (Select * from PDBDocumentContent where ParentFolderIndex=v_folderId and DocumentIndex=v_documentId);
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					existsFlag := 0;
			END;
			If existsFlag = 1 THEN	
					select max(DocumentOrderNo)+1 into v_order from PDBDocumentContent where ParentFolderIndex=v_folderId;
					Insert Into PDBDocumentContent(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
						DocumentOrderNo, RefereceFlag, DocStatus)
					values(v_folderId, v_documentId, 1, sysDate,v_order, 'O', 'A');
			 END IF;
	END LOOP;
	CLOSE queue_cursor;
	COMMIT;
End; 
~ 
	Call Upgradation_RightsManagement() 
~ 
	Drop Procedure Upgradation_RightsManagement 
~

/*Added by Ishu Saraf - 14/01/2009*/
CREATE OR REPLACE PROCEDURE WFCollectionUpgrade  AS 
	v_ProcessInstanceId	NVARCHAR2(126);
	v_WorkItemId		INTEGER;
	v_ParentWorkItemId	INTEGER;
	v_PreviousStage		NVARCHAR2(60);
	v_PrimaryActivity	NVARCHAR2(60);
	collection_cursor	INTEGER;
	v_queryStr			NVARCHAR2(3000);
	v_status            INTEGER;
	v_RowsFetched       INTEGER;
	existsFlag			INTEGER;
	v_DBStatus			INTEGER;
	v_STR1				VARCHAR2(2000);
	
BEGIN
	BEGIN
		existsFlag := 0;	
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
					WHERE UPPER(TABLE_NAME) = 'PENDINGWORKLISTTABLE'
					AND UPPER(COLUMN_NAME) = 'NOOFCOLLECTEDINSTANCES'			
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
			EXECUTE IMMEDIATE '
				ALTER TABLE PendingWorkListTable 
				ADD NoOfCollectedInstances	INT				DEFAULT 0 NOT NULL
					IsPrimaryCollected		NVARCHAR2(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))
			'; 
		END IF;

		COMMIT;
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFCollectUpgradeTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCollectUpgradeTable (
				ProcessInstanceId	NVARCHAR2(63)  	NOT NULL ,
				WorkItemId 			INT 			NOT NULL 
			)';
		dbms_output.put_line ('Table WFTypeDescTable Created successfully');
	END;

	v_queryStr := ' SELECT A.ProcessInstanceID, A.WorkitemID, A.ParentWorkitemID, ' ||
		      ' A.PreviousStage, B.PrimaryActivity ' ||
		      '	FROM PendingWorkListTable A, ActivityTable B ' ||
		      '	WHERE A.ProcessDefID = B.ProcessDefID and A.ActivityID = B.ActivityID ' ||
		      ' and B.ActivityType = 6 ';

	collection_cursor := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(collection_cursor, TO_CHAR(v_queryStr), DBMS_SQL.NATIVE);
	
	DBMS_SQL.DEFINE_COLUMN(collection_cursor, 1, v_ProcessInstanceId, 126); 
	DBMS_SQL.DEFINE_COLUMN(collection_cursor, 2, v_WorkItemId);
	DBMS_SQL.DEFINE_COLUMN(collection_cursor, 3, v_ParentWorkItemId);
	DBMS_SQL.DEFINE_COLUMN(collection_cursor, 4, v_PreviousStage, 60);
	DBMS_SQL.DEFINE_COLUMN(collection_cursor, 5, v_PrimaryActivity, 60);

	v_status := DBMS_SQL.EXECUTE(collection_cursor);
	v_RowsFetched := 0;
	v_RowsFetched := DBMS_SQL.FETCH_ROWS(collection_cursor);
	IF (v_RowsFetched = 0) THEN 
		DBMS_SQL.CLOSE_CURSOR(collection_cursor); 
		RETURN; 
	END IF;

	BEGIN
		WHILE(v_RowsFetched <> 0) LOOP 
		BEGIN
			SAVEPOINT TRAN_COLLECT_UPGRADE;

			BEGIN
				DBMS_SQL.COLUMN_VALUE(collection_cursor, 1, v_ProcessInstanceId); 
				DBMS_SQL.COLUMN_VALUE(collection_cursor, 2, v_WorkItemId);
				DBMS_SQL.COLUMN_VALUE(collection_cursor, 3, v_ParentWorkItemId);
				DBMS_SQL.COLUMN_VALUE(collection_cursor, 4, v_PreviousStage);
				DBMS_SQL.COLUMN_VALUE(collection_cursor, 5, v_PrimaryActivity);

				DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_WorkItemId;
				IF SQL%ROWCOUNT <= 0 THEN
					DBMS_OUTPUT.put_line('Deletion from PendingWorkListTable failed for ' || v_ProcessInstanceId);
					ROLLBACK TO SAVEPOINT TRAN_COLLECT_UPGRADE;
					SAVEPOINT TRAN_FAILED_WI;
						EXECUTE IMMEDIATE ' INSERT INTO WFCollectUpgradeTable VALUES( N''' || v_ProcessInstanceId || ''', ' || v_WorkItemId || ')';
					COMMIT;
					GOTO ProcessNext;
				END IF;

				DELETE FROM QueueDataTable WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_WorkItemId;
				IF SQL%ROWCOUNT <= 0 THEN
					DBMS_OUTPUT.put_line('Deletion from QueueDataTable failed for ' || v_ProcessInstanceId);
					ROLLBACK TO SAVEPOINT TRAN_COLLECT_UPGRADE;
					SAVEPOINT TRAN_FAILED_WI;
						EXECUTE IMMEDIATE ' INSERT INTO WFCollectUpgradeTable VALUES( N''' || v_ProcessInstanceId || ''', ' || v_WorkItemId || ')';
					COMMIT;
					GOTO ProcessNext;
				END IF;

				v_STR1 := ' UPDATE PendingWorkListTable SET NoOfCollectedInstances = NoOfCollectedInstances + 1 WHERE ProcessInstanceId = N''' || v_ProcessInstanceId || ''' AND WorkItemId = ' || TO_CHAR(v_ParentWorkItemId);
				EXECUTE IMMEDIATE v_STR1;
				IF SQL%ROWCOUNT <= 0 THEN
					DBMS_OUTPUT.put_line('Updation of NoOfCollectedInstances failed for ' || v_ProcessInstanceId);
					ROLLBACK TO SAVEPOINT TRAN_COLLECT_UPGRADE;
					SAVEPOINT TRAN_FAILED_WI;
						EXECUTE IMMEDIATE ' INSERT INTO WFCollectUpgradeTable VALUES( N''' || v_ProcessInstanceId || ''', ' || v_WorkItemId || ')';
					COMMIT;
					GOTO ProcessNext;
				END IF;

				IF (v_PreviousStage = v_PrimaryActivity) THEN
				BEGIN
					v_STR1 := ' UPDATE PendingWorkListTable SET IsPrimaryCollected = ''Y'' WHERE ProcessInstanceId = N''' || v_ProcessInstanceId || ''' AND WorkItemId = ' || TO_CHAR(v_ParentWorkItemId);
					EXECUTE IMMEDIATE v_STR1;
					IF SQL%ROWCOUNT <= 0 THEN 
					BEGIN
						DBMS_OUTPUT.put_line('Updation of IsPrimaryCollected failed for ' || v_ProcessInstanceId);
						ROLLBACK TO SAVEPOINT TRAN_COLLECT_UPGRADE;
						SAVEPOINT TRAN_FAILED_WI;
							EXECUTE IMMEDIATE ' INSERT INTO WFCollectUpgradeTable VALUES( N''' || v_ProcessInstanceId || ''', ' || v_WorkItemId || ')';
						COMMIT;
						GOTO ProcessNext;
					END;
					END IF;
				END;
				END IF;

			EXCEPTION
				WHEN OTHERS THEN 
				BEGIN
					ROLLBACK TO SAVEPOINT TRANDATA;
				END;
			END;

			COMMIT;

			<<ProcessNext>>
				v_RowsFetched := DBMS_SQL.fetch_rows(collection_cursor);
		END;
		END LOOP;

		DBMS_SQL.CLOSE_CURSOR(collection_cursor);

	EXCEPTION
		WHEN OTHERS THEN 
		BEGIN
			DBMS_SQL.CLOSE_CURSOR(collection_cursor); 
			RETURN;
		END;
	END;
END;

~

CALL WFCollectionUpgrade()

~

DROP PROCEDURE WFCollectionUpgrade

~

