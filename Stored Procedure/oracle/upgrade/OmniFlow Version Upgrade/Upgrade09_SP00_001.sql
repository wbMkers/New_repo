/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
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
	activity_ID                     INTEGER;
	processDef_Id                   INTEGER;
	v_logStatus 					BOOLEAN;
	v_scriptName                    NVARCHAR2(100) := 'Upgrade09_SP00_001';
	
	
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
		
	CURSOR Constraint_CurD IS /* added by Ishu Saraf*/
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 
		
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
	
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag from USER_TABLES where upper(table_name) = upper('WFVERSIONUPGRADELOGTABLE');
			IF(existsFlag = 1) THEN
				BEGIN
					SELECT 1 INTO existsFlag from user_tab_columns where upper(table_name) = upper('WFVERSIONUPGRADELOGTABLE') and upper(column_name) = upper('SCRIPTNAME');					
				EXCEPTION WHEN no_data_found THEN 
					EXECUTE IMMEDIATE 'DROP TABLE WFVERSIONUPGRADELOGTABLE' ;
					
					EXECUTE IMMEDIATE 'CREATE TABLE WFVERSIONUPGRADELOGTABLE(STEPNUMBER NUMBER,SCRIPTNAME NVARCHAR2(100) NOT NULL, STEPDETAILS NVARCHAR2(1000),  STARTDATE timestamp, ENDDATE timestamp, STATUS NVARCHAR2(20), CONSTRAINT PK_CabinetUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))';
				END;				
			END IF;		
		EXCEPTION WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFVERSIONUPGRADELOGTABLE(STEPNUMBER NUMBER,SCRIPTNAME NVARCHAR2(100) NOT NULL, STEPDETAILS NVARCHAR2(1000),  STARTDATE timestamp, ENDDATE timestamp, STATUS NVARCHAR2(20), CONSTRAINT PK_VersionUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))';
		END;		
		EXECUTE IMMEDIATE 'DELETE FROM WFVERSIONUPGRADELOGTABLE';
		
	END;
	
	v_logStatus := LogInsert(1,'Creating table WFCabVersionTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = 'WFCABVERSIONTABLE'
			;  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(1);
		
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);
			raise_application_error(-20201, v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);
	
	v_logStatus := LogInsert(2,'Adding new columns cabVersion, Remarks In WFCabVersionTable if exist ,Else Create WFCabVersionTable table');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFCabVersionTable') 
			AND 
			COLUMN_NAME=UPPER('cabVersion')
			AND
			DATA_TYPE=UPPER('NVARCHAR2')
			AND DATA_LENGTH >= 510;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(2);
			EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (cabVersion NVARCHAR2(255))';
			DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column cabVersion size increased to 255');
		END;
		
		BEGIN
			
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFCabVersionTable') 
			AND 
			COLUMN_NAME=UPPER('Remarks')
			AND
			DATA_TYPE=UPPER('NVARCHAR2')
			AND DATA_LENGTH >= 510;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(2);
		
			EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (Remarks NVARCHAR2(255))';
			DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column Remarks size increased to 255');
		END;
		
	EXCEPTION 
		WHEN OTHERS THEN		
			v_logStatus := LogUpdateError(2);
			raise_application_error(-20202, v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);
	
	v_logStatus := LogInsert(3,'Creating Sequence CabVersionId');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('CABVERSIONID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(3);
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);
			raise_application_error(-20203, v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);
	
	v_logStatus := LogInsert(4,'Adding new Column ACTIONDATETIME In WFMESSAGETABLE');
	BEGIN
		existsflag :=0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM DUAL
			WHERE 
			NOT EXISTS(
				SELECT 1 FROM USER_TAB_COLUMNS
				WHERE UPPER(COLUMN_NAME) ='ACTIONDATETIME' 
				AND TABLE_NAME = 'WFMESSAGETABLE' 
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
		v_logStatus := LogSkip(4);

		EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGETABLE ADD (ACTIONDATETIME DATE)';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4);
			raise_application_error(-20204, v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);
	
	v_logStatus := LogInsert(5,'Adding new Column ACTIONDATETIME In WFMESSAGEINPROCESSTABLE');
	BEGIN
		existsflag :=0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM DUAL
			WHERE 
			NOT EXISTS(
				SELECT 1 FROM USER_TAB_COLUMNS
				WHERE UPPER(COLUMN_NAME) ='ACTIONDATETIME' 
				AND TABLE_NAME = 'WFMESSAGEINPROCESSTABLE' 
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
		BEGIN
		v_logStatus := LogSkip(5);

			EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGEINPROCESSTABLE ADD (ACTIONDATETIME DATE)';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		v_logStatus := LogUpdateError(5);
		raise_application_error(-20205, v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);
	
	v_logStatus := LogInsert(6,'Adding new column ActionDateTime In WFFAILEDMESSAGETABLE if exists ,Else Create WFFailedMessageTable table; Deleting reord where status =''F'' And Updating column lockedBy to null in WFFAILEDMESSAGETABLE');
	BEGIN
		existsFlag := 0;
		BEGIN 
		v_logStatus := LogSkip(6);
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

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6);
			raise_application_error(-20206, v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);
	
	v_logStatus := LogInsert(7,'CREATING TABLE EXTMETHODDEFTABLE');
	BEGIN
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
		v_logStatus := LogSkip(7);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);
			raise_application_error(-20207, v_scriptName ||' BLOCK 7 FAILED');
	END;
			
	v_logStatus := LogUpdate(7);
	
	v_logStatus := LogInsert(8,'CREATING TABLE EXTMETHODPARAMDEFTABLE');
	BEGIN
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
			v_logStatus := LogSkip(8);
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
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);
			raise_application_error(-20208, v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);
		
	v_logStatus := LogInsert(9,'CREATING TABLE EXTMETHODPARAMMAPPINGTABLE');
	BEGIN
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
			v_logStatus := LogSkip(9);
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

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);
			raise_application_error(-20209, v_scriptName ||' BLOCK 9 FAILED');
	END;
	
	v_logStatus := LogUpdate(9);
		
	v_logStatus := LogInsert(10,'CREATING TABLE CONSTANTDEFTABLE');
	BEGIN
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
			v_logStatus := LogSkip(10);
			EXECUTE IMMEDIATE'
				CREATE TABLE CONSTANTDEFTABLE(
					processDefId		INTEGER NOT NULL,
					constantName		NVARCHAR2 (64) NOT NULL,
					constantValue		NVARCHAR2 (255),
					lastModifiedOn		DATE NOT NULL ,
					PRIMARY KEY		(processDefId, constantName)
				)';
		END IF;
		COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);
			raise_application_error(-20210, v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);
	
	v_logStatus := LogInsert(11,'Creating Table WFEscalationTable,Creating SEQUENCE EscalationId,Creating Index on column EscalationMode and ScheduleTime of table WFEscalationTable ');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(11);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11);
			raise_application_error(-20211, v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);
		
	v_logStatus := LogInsert(12,'Creating Table WFEscInProcessTable ');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(12);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12);
			raise_application_error(-20212, v_scriptName ||' BLOCK 12 FAILED');
	END;
	
	v_logStatus := LogUpdate(12);
		
	v_logStatus := LogInsert(13,'CREATING TABLE WFJMSMESSAGETABLE,Creating Sequence for JMSMessageId');
	BEGIN
		/* New table for feature : JMS */
		existsflag :=0;
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
			v_logStatus := LogSkip(13);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13);
			raise_application_error(-20213, v_scriptName ||' BLOCK 13 FAILED');
	END;
		
	v_logStatus := LogUpdate(13);
		
	v_logStatus := LogInsert(14,'Creating TABLE WFJMSMESSAGEINPROCESSTABLE ');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(14);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);
			raise_application_error(-20214, v_scriptName ||' BLOCK 14 FAILED');
	END;
		
	v_logStatus := LogUpdate(14);
		
	v_logStatus := LogInsert(15,'Creating Table WFJMSFailedMessageTable');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(15);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);
			raise_application_error(-20215, v_scriptName ||' BLOCK 15 FAILED');
	END;
		
	v_logStatus := LogUpdate(15);
		
	v_logStatus := LogInsert(16,'Creating Table WFJMSDestInfo');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(16);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);
			raise_application_error(-20216, v_scriptName ||' BLOCK 16 FAILED');
	END;
		
	v_logStatus := LogUpdate(16);
		
	v_logStatus := LogInsert(17,'Creating Table WFJMSPublishTable');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(17);
			EXECUTE IMMEDIATE '
				CREATE TABLE WFJMSPUBLISHTABLE(
					processDefId		INTEGER,
					activityId		INTEGER,
					destinationId		INTEGER,
					TEMPLATE		CLOB
				) ';

			dbms_output.put_line ('Table WFJMSPublishTable created successfully');

		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);
			raise_application_error(-20217, v_scriptName ||' BLOCK 17 FAILED');
	END;
		
	v_logStatus := LogUpdate(17);
		
	v_logStatus := LogInsert(18,'Creating Table WFJMSSubscribeTable');
	BEGIN
		existsflag :=0;
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
			v_logStatus := LogSkip(18);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18);
			raise_application_error(-20218, v_scriptName ||' BLOCK 18 FAILED');
	END;
		
	v_logStatus := LogUpdate(18);
		
	v_logStatus := LogInsert(19,'Creating Table WFDataStructureTable');
	BEGIN
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
			v_logStatus := LogSkip(19);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19);
			raise_application_error(-20219, v_scriptName ||' BLOCK 19 FAILED');
	END;
		
	v_logStatus := LogUpdate(19);
		
	v_logStatus := LogInsert(20,'Creating Table WFWebServiceTable');
	BEGIN
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
			v_logStatus := LogSkip(20);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);
			raise_application_error(-20220, v_scriptName ||' BLOCK 20 FAILED');
	END;
		
	v_logStatus := LogUpdate(20);
		
	v_logStatus := LogInsert(21,'Creating Table WFVarStatusTable');
	BEGIN
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
			v_logStatus := LogSkip(21);
			EXECUTE IMMEDIATE'
				CREATE TABLE WFVARSTATUSTABLE (
				ProcessDefId	INT		NOT NULL ,
				VarName		NVARCHAR2(50)	NOT NULL ,
				Status		NVARCHAR2(1)	DEFAULT ''Y'' NOT NULL ,  
				CONSTRAINT  ck_VarStatus CHECK (Status = ''Y'' OR Status = ''N'' ) 
				)';
			dbms_output.put_line ('Table WFVarStatusTable created successfully');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);
			raise_application_error(-20221, v_scriptName ||' BLOCK 21 FAILED');
	END;
		
		
	v_logStatus := LogUpdate(21);
		
	v_logStatus := LogInsert(22,'Creating Table WFActionStatusTable');
	BEGIN
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
			v_logStatus := LogSkip(22);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);
			raise_application_error(-20222, v_scriptName ||' BLOCK 22 FAILED');
	END;	
		
	v_logStatus := LogUpdate(22);
		
	v_logStatus := LogInsert(23,'Creating Table WFCalDefTable ');
	BEGIN
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
			v_logStatus := LogSkip(23);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);
			raise_application_error(-20223, v_scriptName ||' BLOCK 23 FAILED');
	END;
		
	v_logStatus := LogUpdate(23);
		
	v_logStatus := LogInsert(24,'Creating Table WFCalRuleDefTable');
	BEGIN
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
			v_logStatus := LogSkip(24);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);
			raise_application_error(-20224, v_scriptName ||' BLOCK 24 FAILED');
	END;
		
	v_logStatus := LogUpdate(24);
		
	v_logStatus := LogInsert(25,'Creating Table WFCalHourDefTable');
	BEGIN
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
			v_logStatus := LogSkip(25);
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

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25);
			raise_application_error(-20225, v_scriptName ||' BLOCK 25 FAILED');
	END;

	v_logStatus := LogUpdate(25);	
	v_logStatus := LogInsert(26,'Creating Table WFCalendarAssocTable ');
	BEGIN
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
			v_logStatus := LogSkip(26);
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

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);
			raise_application_error(-20226, v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);	
	v_logStatus := LogInsert(27,'Creating Table SuccessLogTable');
	BEGIN
		/* Added By Varun Bhansaly On 23/07/2007 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('SuccessLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(27);
				EXECUTE IMMEDIATE 
				'CREATE TABLE SuccessLogTable (  
					LogId INT, 
					ProcessInstanceId NVARCHAR2(63) 
				)';
			dbms_output.put_line ('Table SuccessLogTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);
			raise_application_error(-20227, v_scriptName ||' BLOCK 27 FAILED');
	END;

	v_logStatus := LogUpdate(27);	

	v_logStatus := LogInsert(28,'Creating Table FailureLogTable');
	BEGIN
		/* Added By Varun Bhansaly On 23/07/2007 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('FailureLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(28);
				EXECUTE IMMEDIATE 
				'CREATE TABLE FailureLogTable (  
					LogId INT, 
					ProcessInstanceId NVARCHAR2(63) 
				)';
			dbms_output.put_line ('Table FailureLogTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28);
			raise_application_error(-20228, v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);	

	v_logStatus := LogInsert(29,'Adding Column DataStructureId  to ExtMethodParamDefTable ');
	BEGIN
		/* SrNo-2, Adding column DataStructureId in table ExtMethodParamDefTable - Ruhi Hira */
		existsflag := 0;
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
			v_logStatus := LogSkip(29);
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD (DataStructureId Int)';
			dbms_output.put_line ('Column DataStructureId added to ExtMethodParamDefTable successfully');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);
			raise_application_error(-20229, v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);
		
	v_logStatus := LogInsert(30,'Adding column DataStructureId in table ExtMethodParamMappingTable');
	BEGIN
		/* SrNo-2, Adding column DataStructureId in table ExtMethodParamMappingTable - Ruhi Hira */
		existsflag := 0;
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
			v_logStatus := LogSkip(30);
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable ADD (DataStructureId Int)';
			dbms_output.put_line ('Column DataStructureId added to ExtMethodParamMappingTable successfully');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);
			raise_application_error(-20230, v_scriptName ||' BLOCK 30 FAILED');
	END;

	v_logStatus := LogUpdate(30);	

	v_logStatus := LogInsert(31,'Adding column queryFilter in table QUEUEUSERTABLE');
	BEGIN
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
			v_logStatus := LogSkip(31);
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD (queryFilter NVarchar2(2000))';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31);
			raise_application_error(-20231, v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);	

	v_logStatus := LogInsert(32,'Updating ActivityTable');
	BEGIN
			/* Updating ActivityTable */
		existsFlag := 0;
		BEGIN 
			v_logStatus := LogSkip(32);
			Declare CURSOR Activity_Cursor IS 
			SELECT min(a.activityid),a.processdefid FROM Activitytable a INNER JOIN processdeftable b on a.processdefid=b.processdefid where a.activityType= 1 GROUP BY a.processdefid;
			BEGIN
				Open Activity_Cursor;
					LOOP
						FETCH Activity_Cursor INTO activity_ID,processDef_Id;
						EXIT WHEN Activity_Cursor%NOTFOUND;
						BEGIN
							EXECUTE IMMEDIATE 'select * from activitytable where activityType = 1 And primaryActivity = ''Y'' and processDefId = ' || TO_CHAR(processDef_Id);
							IF(SQL%ROWCOUNT != 0) THEN
								FETCH Activity_Cursor INTO activity_ID,processDef_Id;
							ElSE
								BEGIN
									EXECUTE IMMEDIATE 'UPDATE Activitytable SET primaryActivity = ''Y'' WHERE activityType=1 and processDefId = ' || TO_CHAR(processDef_Id) || ' and activityid =' ||  TO_CHAR(activity_ID) ;
									FETCH Activity_Cursor INTO activity_ID,processDef_Id;
								END;
							END IF;
						END;         
					END LOOP;
				Close  Activity_Cursor;
				EXCEPTION 
					   WHEN OTHERS THEN 
				Close  Activity_Cursor; 
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);
			raise_application_error(-20232, v_scriptName ||' BLOCK 32 FAILED');
	END;

	v_logStatus := LogUpdate(32);	

	v_logStatus := LogInsert(33,'making expiry as nullable in ActivityTable');
	BEGIN
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
		*/
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

		IF existsflag = 1 THEN
			v_logStatus := LogSkip(33);
			/*EXECUTE IMMEDIATE '
				INSERT INTO ActivityTable_Temp 
					SELECT processDefId, activityId, expiry FROM ACTIVITYTABLE
				';*/
			BEGIN
				EXECUTE IMMEDIATE ' ALTER TABLE ActivityTable MODIFY expiry NVarchar2(255) NULL';
			EXCEPTION
				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE ('Some exception occurred while making expiry as nullable ');
			END;
			UPDATE ActivityTable SET expiry = NULL where UPPER(expiry) = 'NULL';		
			/*EXECUTE IMMEDIATE ' Update ActivityTable SET expiry = null ';
			EXECUTE IMMEDIATE ' Alter Table ActivityTable Modify expiry NVarchar2(255) ';
			EXECUTE IMMEDIATE ' 
				UPDATE ACTIVITYTABLE SET expiry = (SELECT ' || quoteChar || '0*24+' || quoteChar || ' || TO_CHAR(Expiry) 
									FROM ActivityTable_Temp
									WHERE ActivityTable_Temp.processDefId = ACTIVITYTABLE.processDefId
									AND ActivityTable_Temp.activityId = ACTIVITYTABLE.activityId
								)

				';*/
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);
			raise_application_error(-20233, v_scriptName ||' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);	

	v_logStatus := LogInsert(34,'Updating RuleOperationTable for operation DISTRIBUTE TO ');
	BEGIN
		
		/*
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
		*/
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
			v_logStatus := LogSkip(34);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(34);
			raise_application_error(-20234, v_scriptName ||' BLOCK 34 FAILED');
	END;
		
	v_logStatus := LogUpdate(34);	

	v_logStatus := LogInsert(35,'Modifying constraint on ActivityTable');
	BEGIN
		v_logStatus := LogSkip(35);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(35);
			raise_application_error(-20235, v_scriptName ||' BLOCK 35 FAILED');
	END;
	v_logStatus := LogUpdate(35);	

	v_logStatus := LogInsert(36,'Modifying constraint on ExtMethodDefTable');
	BEGIN
		v_logStatus := LogSkip(36);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(36);
			raise_application_error(-20236, v_scriptName ||' BLOCK 36 FAILED');
	END;

		
	v_logStatus := LogUpdate(36);	

	v_logStatus := LogInsert(37,'Modifying constraint on ExtMethodParamDefTable');
	BEGIN
		v_logStatus := LogSkip(37);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(37);
			raise_application_error(-20237, v_scriptName ||' BLOCK 37 FAILED');
	END;
	v_logStatus := LogUpdate(37);	

	v_logStatus := LogInsert(38,'Modifying constraint on EXTMETHODDEFTABLE');
	BEGIN
		v_logStatus := LogSkip(38);
		OPEN Constraint_CurD;
		LOOP
			FETCH Constraint_CurD INTO v_constraintName, v_search_Condition;
			EXIT WHEN Constraint_CurD%NOTFOUND;
			IF (UPPER(v_search_Condition) LIKE '%EXTAPPTYPE%') THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
			END IF;
		END LOOP;
		CLOSE Constraint_CurD;

		EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_EXTAP CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z''))';
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(38);
			raise_application_error(-20238, v_scriptName ||' BLOCK 38 FAILED');
	END;	
	v_logStatus := LogUpdate(38);
		
	v_logStatus := LogInsert(39,'Modifying WORKITEMCOUNT To NVARCHAR2(100) IN USERWORKAUDITTABLE');
	BEGIN
		/* Altering table UserWorkAuditTable */
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS  
					WHERE UPPER(TABLE_NAME) = 'USERWORKAUDITTABLE'
					AND UPPER(COLUMN_NAME) = 'WORKITEMCOUNT' 
					AND UPPER(DATA_TYPE) = 'NVARCHAR2'
					AND DATA_LENGTH = 200
					
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(39);
			EXECUTE IMMEDIATE '
				ALTER TABLE USERWORKAUDITTABLE MODIFY(WORKITEMCOUNT	NVARCHAR2(100))
			';
			BEGIN
				DBMS_OUTPUT.PUT_LINE('USERWORKAUDITTABLE column length altered ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(39);
			raise_application_error(-20239, v_scriptName ||' BLOCK 39 FAILED');
	END;
	v_logStatus := LogUpdate(39);	

	v_logStatus := LogInsert(40,'Adding new column LastModifiedOn,CreatedOn In PROCESSDEFTABLE if exists ,Else Create PROCESSDEFTABLE table');
	BEGIN
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
			v_logStatus := LogSkip(40);
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
				SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ProcessDefTable' AND ROWNUM <= 1;
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(40);
			raise_application_error(-20240, v_scriptName ||' BLOCK 40 FAILED');
	END;
	v_logStatus := LogUpdate(40);	

	v_logStatus := LogInsert(41,'Dropping constraint on Type1 column of VarAliasTable');
	BEGIN
		v_logStatus := LogSkip(41);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(41);
			raise_application_error(-20241, v_scriptName ||' BLOCK 41 FAILED');
	END;

		
	v_logStatus := LogUpdate(41);	
	v_logStatus := LogInsert(42,'DISABLE Trigger UPDATE_FINALIZATION_STATUS');
	BEGIN
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
			v_logStatus := LogSkip(42);
			EXECUTE IMMEDIATE 'ALter Trigger Update_Finalization_Status Disable';
			BEGIN
				dbms_output.put_line('Trigger Update_Finalization_Status created ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(42);
			raise_application_error(-20242, v_scriptName ||' BLOCK 42 FAILED');
	END;
	v_logStatus := LogUpdate(42);	

	v_logStatus := LogInsert(43,'DROP TRIGGER WF_LOG_ID_TRIGGER');
	BEGIN
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				EXISTS( 
					SELECT 1 FROM USER_TRIGGERS
					WHERE UPPER(TRIGGER_NAME) = UPPER('WF_LOG_ID_trigger')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(43);
			EXECUTE IMMEDIATE 'DROP TRIGGER WF_LOG_ID_TRIGGER';
			BEGIN
				dbms_output.put_line('Trigger WF_LOG_ID_TRIGGER has been droped ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(43);
			raise_application_error(-20243, v_scriptName ||' BLOCK 43 FAILED');
	END;

		
	v_logStatus := LogUpdate(43);
		
	v_logStatus := LogInsert(44,'Altering Constraint PRIMARY KEY  (ProcessDefId, ActivityId, StreamId) on QueueStreamTable');
	BEGIN
		/* Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
		existsflag := 0;
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
			v_logStatus := LogSkip(44);
			SELECT constraint_name INTO v_constraintName FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'QUEUESTREAMTABLE';
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE DROP Constraint ' || v_constraintName;
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE ADD CONSTRAINT QST_PRIM PRIMARY KEY (ProcessDefId, ActivityId, StreamId)';
			dbms_output.put_line ('Primary Key updated for QueueStreamTable');
		ELSE
			dbms_output.put_line ('Invalid Data in QueueStreamTable'); 
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(44);
			raise_application_error(-20244, v_scriptName ||' BLOCK 44 FAILED');
	END;
	v_logStatus := LogUpdate(44);
		
	v_logStatus := LogInsert(45,'type of column data is changed from CLOB to NVarchar2(2000) in TempPSRegisterationTable');
	BEGIN
		/* SrNo-1, For license implementation, type of column data is changed from CLOB to NVarchar2(2000) - Ruhi */
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE NOT EXISTS(
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
			v_logStatus := LogSkip(45);
			EXECUTE IMMEDIATE
				' CREATE TABLE TempPSRegisterationTable
				AS
				SELECT PSId, PSName, TYPE, SessionId, ProcessDefId, TO_NCHAR(Data) Data
				FROM PSREGISTERATIONTABLE';

			EXECUTE IMMEDIATE 'DROP TABLE PSRegisterationTable';

			EXECUTE IMMEDIATE 'RENAME TempPSRegisterationTable TO PSRegisterationTable';
		END IF;
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_PS_ID_TRIGGER BEFORE INSERT ON PSREGISTERATIONTABLE FOR EACH ROW BEGIN SELECT PSID.nextval INTO :new.PSID FROM dual;END;';
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(45);
			raise_application_error(-20245, v_scriptName ||' BLOCK 45 FAILED');
	END;
	v_logStatus := LogUpdate(45);
		
	v_logStatus := LogInsert(46,'Adding UNIQUE CONSTRAINT On SESSIONID In PSREGISTERATIONTABLE');
	BEGIN
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE NOT EXISTS(
				Select 1 from user_constraints where constraint_name = 'U_PSREGTABLE'
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(46);
			EXECUTE IMMEDIATE 'ALTER TABLE PSREGISTERATIONTABLE ADD CONSTRAINT U_PSREGTABLE UNIQUE (SESSIONID)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(46);
			raise_application_error(-20246, v_scriptName ||' BLOCK 46 FAILED');
	END;	
	v_logStatus := LogUpdate(46);
		
	v_logStatus := LogInsert(47,'ADD CONSTRAINT PS_REG_TYPE CHECK (TYPE = ''C'' OR TYPE = ''P'' ) In PSREGISTERATIONTABLE');
	BEGIN
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE NOT EXISTS(
				Select 1 from user_constraints where constraint_name = 'PS_REG_TYPE'
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(47);
			EXECUTE IMMEDIATE 'ALTER TABLE PSREGISTERATIONTABLE ADD CONSTRAINT PS_REG_TYPE CHECK (TYPE = ''C'' OR TYPE = ''P'' )';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(47);
			raise_application_error(-20247, v_scriptName ||' BLOCK 47 FAILED');
	END;
		
		
	v_logStatus := LogUpdate(47);
		
	v_logStatus := LogInsert(48,'Adding CONSTRAINT PK_PSREGISTERATIONTABLE PRIMARY KEY (PSNAME , TYPE) in PSREGISTERATIONTABLE');
	BEGIN
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE NOT EXISTS(
				Select 1 from user_constraints where constraint_name = 'PK_PSREGISTERATIONTABLE'
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(48);
			EXECUTE IMMEDIATE 'ALTER TABLE PSREGISTERATIONTABLE ADD CONSTRAINT PK_PSREGISTERATIONTABLE PRIMARY KEY (PSNAME , TYPE)';
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(48);
			raise_application_error(-20248, v_scriptName ||' BLOCK 48 FAILED');
	END;
		
		
	v_logStatus := LogUpdate(48);
		
	v_logStatus := LogInsert(49,'Adding Column TATCalFlag to ProcessDefTable');
	BEGIN
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
			v_logStatus := LogSkip(49);
			EXECUTE IMMEDIATE 'Alter Table PROCESSDEFTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ProcessDefTable set TATCalFlag = N''N''';
			BEGIN
				DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ProcessDefTable ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(49);
			raise_application_error(-20249, v_scriptName ||' BLOCK 49 FAILED');
	END;
	v_logStatus := LogUpdate(49);
		
	v_logStatus := LogInsert(50,'Adding Column TATCalFlag to ActivityTable');
	BEGIN
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
			v_logStatus := LogSkip(50);
			EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(TATCalFlag NVARCHAR2(1) NULL, 
						ExpCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set TATCalFlag = N''N'', ExpCalFlag = N''N'' ';
			BEGIN
				DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ActivityTable ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(50);
			raise_application_error(-20250, v_scriptName ||' BLOCK 50 FAILED');
	END;
	v_logStatus := LogUpdate(50);
		
	v_logStatus := LogInsert(51,'Adding Column RuleCalFlag to RuleOperationTable');
	BEGIN
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
			v_logStatus := LogSkip(51);
			EXECUTE IMMEDIATE 'Alter Table RULEOPERATIONTABLE ADD(RuleCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update RuleOperationTable set RuleCalFlag = N''N''';
			BEGIN
				DBMS_OUTPUT.PUT_LINE('Column RuleCalFlag added to RuleOperationTable ... ');
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(51);
			raise_application_error(-20251, v_scriptName ||' BLOCK 51 FAILED');
	END;	
	v_logStatus := LogUpdate(51);
		
	v_logStatus := LogInsert(52,'Creating TABLE CheckOutProcessesTable');
	BEGIN		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('CheckOutProcessesTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(52);
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
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(52);
			raise_application_error(-20252, v_scriptName ||' BLOCK 52 FAILED');
	END;
	v_logStatus := LogUpdate(52);
		
	v_logStatus := LogInsert(53,'Updating expiry coloumn and Setting expiry column from 0 to null in ActivityTable ');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'WFDURATIONTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(53);
				/* Added By Varun Bhansaly On 23/07/2007 */
			UPDATE ActivityTable SET expiry = ('0*24 + ' || expiry) WHERE expiry IS NOT NULL AND expiry != '0' AND INSTR(expiry, '*', 1) = 0;
			UPDATE ActivityTable SET expiry = null where expiry = '0';

			dbms_output.put_line ('ActivityTable expiry coloumn set sucessfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(53);
			raise_application_error(-20253, v_scriptName ||' BLOCK 53 FAILED');
	END;	
	v_logStatus := LogUpdate(53);



END; 

~

Call Upgrade() 

~

Drop Procedure Upgrade
	
~

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
	v_logStatus 		BOOLEAN;
	v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_001';
	
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
	v_logStatus := LogInsert(54,'Adding new columns NoOfCollectedInstances,IsPrimaryCollected in PendingWorkListTable ');
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
				v_logStatus := LogSkip(54);
				EXECUTE IMMEDIATE 'ALTER TABLE PendingWorkListTable	ADD NoOfCollectedInstances	INT	DEFAULT 0 NOT NULL';
				EXECUTE IMMEDIATE 'ALTER TABLE PendingWorkListTable	ADD IsPrimaryCollected NVARCHAR2(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))'; 
			END IF;
			COMMIT;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(54);
			raise_application_error(-20254, v_scriptName ||' BLOCK 54 FAILED');
	END;	
	v_logStatus := LogUpdate(54);


	
	v_logStatus := LogInsert(55,'Creating table WFCollectUpgradeTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFCollectUpgradeTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(55);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFCollectUpgradeTable (
					ProcessInstanceId	NVARCHAR2(63)  	NOT NULL ,
					WorkItemId 			INT 			NOT NULL 
				)';
			dbms_output.put_line ('Table WFTypeDescTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(55);
			raise_application_error(-20255, v_scriptName ||' BLOCK 55 FAILED');
	END;	
	v_logStatus := LogUpdate(55);

	

	v_logStatus := LogInsert(56,'Updating table WFCollectUpgradeTable');
	BEGIN
	
		v_logStatus := LogSkip(56);
			
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
			v_logStatus := LogUpdate(56);
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

					EXECUTE IMMEDIATE 'DELETE FROM PendingWorkListTable WHERE ProcessInstanceId ='''|| v_ProcessInstanceId||''' AND WorkItemId = '||v_WorkItemId||')';
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
				v_logStatus := LogUpdate(56);
				RETURN;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(56);
			raise_application_error(-20256, v_scriptName ||' BLOCK 56 FAILED');
	END;	
	v_logStatus := LogUpdate(56);

	
END;

~

DECLARE 
v_tableExists INTEGER;
v_procedureExists INTEGER;
BEGIN
	BEGIN 
		SELECT 1 INTO v_tableExists 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = 'PENDINGWORKLISTTABLE';  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			v_tableExists:= 0;
			dbms_output.put_line ('PendingWorkListTable does not exists');
	END;
  
  	BEGIN 
		SELECT 1 INTO v_procedureExists 
		FROM USER_PROCEDURES  
		WHERE UPPER(object_name) = 'WFCOLLECTIONUPGRADE';  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			v_procedureExists:= 0;
			dbms_output.put_line ('WFCOLLECTIONUPGRADE does not exists');
	END;

  IF (v_tableExists = 1 and v_procedureExists = 1) 
		THEN
		EXECUTE IMMEDIATE 'CALL WFCOLLECTIONUPGRADE()';
    dbms_output.put_line ('Procedure WFCollectionUpgrade executed');
	END if;
  
  IF  v_procedureExists = 1
  THEN
	EXECUTE IMMEDIATE 'DROP PROCEDURE WFCollectionUpgrade';
  END IF;
	
END;

~
