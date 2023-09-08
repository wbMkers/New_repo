/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Phoenix
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: upgrade02.sql
		Author					: Shilpi Srivastava
		Date written(DD/MM/YYYY): 01/02/2008
		Description				: Upgrade Script for new features of Multiple Exception and Minute support
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  06/08/2013        Neeraj Sharma    Bug 41706 - Changes done in version Upgrade of OF 9.0 
  27/08/2013		Bhavneet Kaur	 Bug 41893 - Version Upgrade failed due to improper data in VarMappingTable 
  30/01/2015  		Chitvan Chhabra		Bug 53109 - Version Upgrade:preventing unnecessary update of varmapping table's variableid and moving of view from one location to other because of non availability of calendar column 
  26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
  ________________________________________________________________________________
  ________________________________________________________________________________
  ________________________________________________________________________________*/
Create OR Replace Procedure Upgrade AS
	existsFlag				INTEGER;
	v_constraintName		VARCHAR2(2000);
	v_search_Condition		VARCHAR2(2000);
	v_lastSeqValue			INTEGER;
	v_msgCount				INTEGER;
	v_cabVersion			VARCHAR2 (2000);
	v_objName				VARCHAR2 (2000);
	v_AssignedUserName		VARCHAR2 (2000);
	v_DivertedUserName		VARCHAR2 (2000);
	v_AssignedUserIndex		VARCHAR2 (2000);
	v_DivertedUserIndex		VARCHAR2 (2000);
	v_AssUserName			VARCHAR2 (2000);
	v_DivUserName			VARCHAR2 (2000);
	v_processDefid			INTEGER;
	v_SysString				VARCHAR2(2000);
	v_delimeter				VARCHAR2(1);
	v_StartPos				INTEGER;
	v_EndPos				INTEGER;
	v_length				INTEGER;
	v_count  				INTEGER;
	v_string				VARCHAR2(2000);
	v_userDefinedName		VARCHAR2(2000);
	v_activityId			INTEGER;
	v_targetActivityId		INTEGER;
	v_queueId				INTEGER;
	v_queueType				VARCHAR2(1);
	v_activityType			INTEGER;
	v_OrderID				INTEGER; 
	v_FieldName				NVARCHAR2(2000);
	v_QueryStr				NVARCHAR2(2000);
	TYPE UpgradeTabType		IS REF CURSOR; 
	v_updateCursor			UpgradeTabType;
	qws_cursor 				UpgradeTabType;
	v_QueryActivityId		INTEGER;
	v_STR1					VARCHAR2(2000);
	v_STR2					VARCHAR2(2000);
	v_STR3					VARCHAR2(2000);
	v_STR4					VARCHAR2(2000);
	v_STR5					VARCHAR2(2000);
	v_STR6					VARCHAR2(2000);
	v_STR7					VARCHAR2(2000);
	v_STR8					VARCHAR2(2000);
	v_STR9					VARCHAR2(2000);
	v_STR10					VARCHAR2(2000);
	v_STR11					VARCHAR2(2000);
	v_STR12					VARCHAR2(2000);
	v_STR13					VARCHAR2(2000);
	v_STR14					VARCHAR2(2000);
	v_STR15					VARCHAR2(2000);
	v_STR16					VARCHAR2(2000);
	v_STR17					VARCHAR2(2000);
	v_STR18					VARCHAR2(2000);
	v_STR19					VARCHAR2(2000);
	v_STR20					VARCHAR2(2000);
	v_STR21					VARCHAR2(2000);
	v_STR22					VARCHAR2(2000);
	v_STR23					VARCHAR2(2000);
	v_STR24					VARCHAR2(2000);
	v_STR25					VARCHAR2(2000);
	v_STR26					VARCHAR2(2000);
	v_STR27					VARCHAR2(2000);
	v_STR28					VARCHAR2(2000);
	v_STR29					VARCHAR2(2000);
	v_STR30					VARCHAR2(2000);
	v_STR31					VARCHAR2(2000);
	v_STR32					VARCHAR2(2000);
	v_STR33					VARCHAR2(2000);
	v_STR34					VARCHAR2(2000);
	v_STR35					VARCHAR2(2000);
	v_STR36					VARCHAR2(2000);
	v_STR37					VARCHAR2(2000);
	v_STR38					VARCHAR2(2000);
	v_STR39					VARCHAR2(2000);
	v_STR40					VARCHAR2(2000);
	v_STR41					VARCHAR2(2000);
	v_STR42					VARCHAR2(2000);
	v_STR43					VARCHAR2(2000);
	v_STR44					VARCHAR2(2000);
	v_STR45					VARCHAR2(2000);
	v_STR46					VARCHAR2(2000);
	v_STR47					VARCHAR2(2000);
	v_STR48					VARCHAR2(2000);
	v_STR49					VARCHAR2(2000);
	v_STR50					VARCHAR2(2000);
	v_STR51					VARCHAR2(2000);
	v_STR52					VARCHAR2(2000);
	v_STR53					VARCHAR2(2000);
	v_STR54					VARCHAR2(2000);
	v_STR55					VARCHAR2(2000);
	v_STR56					VARCHAR2(2000);
	v_STR57					VARCHAR2(2000);
	v_STR58					VARCHAR2(2000);
	v_STR59					VARCHAR2(2000);
	v_STR60					VARCHAR2(2000);
	v_STR61					VARCHAR2(2000);
	v_STR62					VARCHAR2(2000);
	v_STR63					VARCHAR2(2000);
	v_STR64					VARCHAR2(2000);
	v_STR65					VARCHAR2(2000);
	v_STR66					VARCHAR2(2000);
	v_STR67					VARCHAR2(2000);
	v_STR68					VARCHAR2(2000);
	v_STR69					VARCHAR2(2000);
	v_STR70					VARCHAR2(2000);
	v_STR71					VARCHAR2(2000);
	v_STR72					VARCHAR2(2000);
	v_STR73					VARCHAR2(2000);
	v_STR74					VARCHAR2(2000);
	v_STR75					VARCHAR2(2000);
	v_STR76					VARCHAR2(2000);
	v_STR77					VARCHAR2(2000);
	v_DefaultIntroductionActID	INTEGER;
	sqlcount 				INTEGER;
	v_isVariableIDUpdateRequired INTEGER;
	v_logStatus 			BOOLEAN;
	v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_003'; 

	CURSOR Constraint_CurB IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 

	CURSOR Constraint_CurC IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODPARAMDEFTABLE'; 

	--CURSOR Constraint_CurD IS /* added by Ishu Saraf*/
		--SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 
		
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
	
Begin
	v_logStatus := LogInsert(1,'CREATING SEQUENCE CABVERSIONID');
	BEGIN
		v_SysString := 'VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,' ||
		 'VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,' ||
		 'VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,sysdate,CreatedDateTime,' ||
		 'EntryDateTime,ValidTill,ProcessInstanceName,CreatedByName,PreviousStage,SaveStage,IntroductionDateTime,' ||
		 'IntroducedBy,InstrumentStatus,PriorityLevel,HoldStatus,ProcessInstanceState,WorkItemState,' ||
		 'Status,ActivityId,QueueType,QueueName,LockedByName,LockedTime,LockStatus,ActivityName,' ||
		 'CheckListCompleteFlag,AssignmentType,ProcessedBy,VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5';

		v_delimeter := ',' ;
			
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('cabVersionId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(1);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
	END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

	v_logStatus := LogInsert(2,'Adding new Column queryFilter in QUEUEUSERTABLE');
	BEGIN
		/* Adding column QueryFilter to table QueueUserTable - Ruhi Hira */
		existsFlag := 0;	
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS  
					WHERE Upper(TABLE_NAME) = 'QUEUEUSERTABLE'
					AND Upper(COLUMN_NAME) = 'QUERYFILTER'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		
		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(2);
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD (queryFilter NVarchar2(2000))';
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2); 
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);

	v_logStatus := LogInsert(3,'Adding column DataStructureId in table ExtMethodParamDefTable');
	BEGIN
		/* SrNo-2, Adding column DataStructureId in table ExtMethodParamDefTable - Ruhi Hira */
		existsflag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM DUAL
			WHERE 
			NOT EXISTS(
				SELECT 1 FROM USER_TAB_COLUMNS
				where upper(COLUMN_NAME) ='DATASTRUCTUREID' 
				AND TABLE_NAME = 'EXTMETHODPARAMDEFTABLE' 
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(3);
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD (DataStructureId Int)';
			dbms_output.put_line ('Column DataStructureId added to ExtMethodParamDefTable successfully');
		END IF;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3); 
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);	
	
	v_logStatus := LogInsert(4,'Adding column DataStructureId in table ExtMethodParamMappingTable');
	BEGIN
		/* SrNo-2, Adding column DataStructureId in table ExtMethodParamMappingTable - Ruhi Hira */
		existsflag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM DUAL
			WHERE 
			NOT EXISTS(
				SELECT 1 FROM USER_TAB_COLUMNS
				where upper(COLUMN_NAME) ='DATASTRUCTUREID' 
				AND TABLE_NAME = 'EXTMETHODPARAMMAPPINGTABLE' 
			);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN
			v_logStatus := LogSkip(4);
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable ADD (DataStructureId Int)';
			dbms_output.put_line ('Column DataStructureId added to ExtMethodParamMappingTable successfully');
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4); 
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);	
	
	v_logStatus := LogInsert(5,'Altering Constraint QST_PRIM PRIMARY KEY (ProcessDefId, ActivityId, StreamId) on QueueStreamTable');
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
				HAVING Count(*) > 1 
			);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END;
		v_logStatus := LogSkip(5);
		IF existsFlag = 1 THEN     
			
			SELECT constraint_name into v_constraintName FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'QUEUESTREAMTABLE';
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE DROP Constraint ' || v_constraintName;
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE ADD CONSTRAINT QST_PRIM PRIMARY KEY (ProcessDefId, ActivityId, StreamId)';
			dbms_output.put_line ('Primary Key updated for QueueStreamTable');
		ELSE
			dbms_output.put_line ('Invalid Data in QueueStreamTable'); 
		END IF;

		/* END Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5); 
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);

	v_logStatus := LogInsert(6,'ADDING CONSTRAINT CK_EXTMETHODPARAM_PARAM CHECK On ParameterType IN ExtMethodParamDefTable');
	BEGIN
		v_logStatus := LogSkip(6);
		/* Modifying constraint on ExtMethodDefTable, WFS_6.1.2_009 */
		/*OPEN Constraint_CurB;
		LOOP
			FETCH Constraint_CurB INTO v_constraintName, v_search_Condition;
			EXIT WHEN Constraint_CurB%NOTFOUND;
			IF (UPPER(v_search_Condition) LIKE '%RETURNTYPE%') THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
			END IF;
		END LOOP;
		CLOSE Constraint_CurB;

		EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_RET CHECK (ReturnType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))';
		*/
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

		EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM CHECK (ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))';

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6); 
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);
	
	v_logStatus := LogInsert(7,'Recreating PSRegisterationTable');
	BEGIN
		/* SrNo-1, WFS_6.1_039, For license implementation, type of column data is changed from CLOB to NVarchar2(2000) - Ruhi */
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
			v_logStatus := LogSkip(7);
			EXECUTE IMMEDIATE
				' CREATE TABLE TempPSRegisterationTable
				AS
				SELECT PSId, PSName, TYPE, SessionId, ProcessDefId, TO_NCHAR(Data) Data
				FROM PSREGISTERATIONTABLE';

			EXECUTE IMMEDIATE 'DROP TABLE PSRegisterationTable';

			EXECUTE IMMEDIATE 'RENAME TempPSRegisterationTable TO PSRegisterationTable';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7); 
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);
		
	v_logStatus := LogInsert(8,'type of column data is changed from CLOB to NVarchar2(2000) in PSRegisterationTable , Modifying TRIGGER WF_PS_ID_TRIGGER BEFORE INSERT ON PSREGISTERATIONTABLE');
	BEGIN
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME='PSRegisterationTable'
					AND 
					COLUMN_NAME=UPPER('PSName')
					and
					DATA_TYPE='NVARCHAR2'
					AND 
					DATA_LENGTH=126;
					existsFlag:=1;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						 existsFlag := 0;
				END;
				IF existsFlag = 0 THEN
					v_logStatus := LogSkip(8);
					EXECUTE IMMEDIATE 'ALTER TABLE PSRegisterationTable MODIFY (PSName NVARCHAR2(63))';
					DBMS_OUTPUT.PUT_LINE('Table PSRegisterationTable altered with Column PSName size increased to 63');
				END IF;
				
		v_logStatus := LogSkip(8);
		
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_PS_ID_TRIGGER BEFORE INSERT ON PSREGISTERATIONTABLE FOR EACH ROW BEGIN SELECT PSID.nextval INTO :new.PSID FROM dual;END;';
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);  
			raise_application_error(-20208,v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);
		
	v_logStatus := LogInsert(9,'Adding new column TATCalFlag in PROCESSDEFTABLE ');
	BEGIN
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
		v_logStatus := LogSkip(9);
			EXECUTE IMMEDIATE 'Alter Table PROCESSDEFTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ProcessDefTable set TATCalFlag = N''N''';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ProcessDefTable ... ');
			End;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9); 
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);
	
	v_logStatus := LogInsert(10,'Creating Table GTempProcessTable ');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempProcessTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(10);
				EXECUTE IMMEDIATE 
				'CREATE GLOBAL TEMPORARY TABLE GTempProcessTable (	
					TempProcessDefId		Int, 
					TempProcessName			NVarchar2(64), 
					TempVersionNo			NVarchar2(8), 
					TempNoofInstances		Int, 
					TempNoofInstancesCompleted	Int, 
					TempNoofInstancesDiscarded	Int,
					TempNoofInstancesDelayed	Int, 
					TempStateSince			NVarchar2(10), 
					TempState			NVarchar2(10), 
					ProcessTurnAroundTime		Int,
					TATCalFlag		        NVarchar2(1)	NULL
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempProcessTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10); 
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);
	
	v_logStatus := LogInsert(11,'ADDING column TATCalFlag in GTempProcessTable');
	BEGIN	
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS 
					WHERE 
					UPPER(table_name) = UPPER('GTempProcessTable')
					AND UPPER(column_Name) = UPPER('TATCALFLAG')
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN  
		v_logStatus := LogSkip(11);
			EXECUTE IMMEDIATE 'Alter Table GTempProcessTable ADD TATCalFlag NVARCHAR2(1) NULL';
			EXECUTE IMMEDIATE 'Update GTempProcessTable set TATCalFlag = N''N''';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to GTempProcessTable ... ');
			End;
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11); 
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);
	
	v_logStatus := LogInsert(12,'ADDING column TATCalFlag in ActivityTable');
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
		v_logStatus := LogSkip(12);
			EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set TATCalFlag = N''N''';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ActivityTable ... ');
			End;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12); 
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);
	
	v_logStatus := LogInsert(13,'ADDING column ExpCalFlag in ActivityTable');
	BEGIN
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS 
					WHERE 
					UPPER(table_name) = 'ACTIVITYTABLE' 
					AND UPPER(column_Name) = 'EXPCALFLAG'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN      
		v_logStatus := LogSkip(13);
			EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(ExpCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set ExpCalFlag = N''N'' ';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column ExpCalFlag added to ActivityTable ... ');
			End;
		END IF;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13); 
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);	

	v_logStatus := LogInsert(14,'ADDING column RuleCalFlag in RuleOperationTable');
	BEGIN
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
		v_logStatus := LogSkip(14);
			EXECUTE IMMEDIATE 'Alter Table RULEOPERATIONTABLE ADD(RuleCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update RuleOperationTable set RuleCalFlag = N''N''';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column RuleCalFlag added to RuleOperationTable ... ');
			End;
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14); 
            raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);

	v_logStatus := LogInsert(15,'ADDING column ActionCalFlag in ActionOperationTable');
	BEGIN
		/* Altering Table ActionOperationTable for Calendar Implementation */
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS 
					WHERE 
					UPPER(table_name) = 'ACTIONOPERATIONTABLE' 
					AND UPPER(column_Name) = 'ACTIONCALFLAG'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 

		IF existsFlag = 1 THEN  
		v_logStatus := LogSkip(15);
			EXECUTE IMMEDIATE 'Alter Table ACTIONOPERATIONTABLE ADD(ActionCalFlag NVARCHAR2(1) NULL)';
			EXECUTE IMMEDIATE 'Update ACTIONOPERATIONTABLE set ActionCalFlag = N''N''';
			Begin
				DBMS_OUTPUT.PUT_LINE('Column ActionCalFlag added to ActionOperationTable ... ');
			End;
		END IF;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15); 
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);

	v_logStatus := LogInsert(16,'ADDING column AppServerIP in ArchiveTable');
	BEGIN
		/* Bugzilla Id 458 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveTable') 
			AND 
			COLUMN_NAME=UPPER('AppServerIP');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(16);
				EXECUTE IMMEDIATE
				'	ALTER TABLE ArchiveTable ADD AppServerIP NVARCHAR2(15) NULL
				';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerIP');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);

	v_logStatus := LogInsert(17,'ADDING column AppServerPort in ArchiveTable');
	BEGIN
		/* Bugzilla Id 458 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveTable') 
			AND 
			COLUMN_NAME=UPPER('AppServerPort');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(17);
				EXECUTE IMMEDIATE
				'	ALTER TABLE ArchiveTable ADD AppServerPort NVARCHAR2(4) NULL
				';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerPort');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);    
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);
		
	v_logStatus := LogInsert(18,'ADDING column AppServerType in ArchiveTable');
	BEGIN
		/* Bugzilla Id 458 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveTable') 
			AND 
			COLUMN_NAME=UPPER('AppServerType');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(18);
				EXECUTE IMMEDIATE
				'	ALTER TABLE ArchiveTable ADD AppServerType NVARCHAR2(255) NULL
				';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerType');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18); 
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);	

	v_logStatus := LogInsert(19,'Updating TABLE archivetable');
	BEGIN
		/* Bugzilla Id 458 */
		v_logStatus := LogSkip(19);
		EXECUTE IMMEDIATE
		'	UPDATE archivetable set AppServerIP = IPAddress , AppServerPort = PortID , AppServerType = null where AppServerIP is null or AppServerPort is null
		';
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19); 
            raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);
	
	v_logStatus := LogInsert(20,'CREATING TABLE TemplateMultiLanguageTable');
	BEGIN
		/* 28/05/2007	Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('TemplateMultiLanguageTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(20);
				EXECUTE IMMEDIATE 
					'CREATE TABLE TemplateMultiLanguageTable (
						ProcessDefId	INT				NOT NULL,
						TemplateId		INT				NOT NULL,
						Locale			NCHAR(5)		NOT NULL,
						TemplateBuffer	LONG RAW			NULL
					)';
					DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20); 
            raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);
	
	v_logStatus := LogInsert(21,'CREATING TABLE InterfaceDescLanguageTable');
	BEGIN
		/* 28/05/2007	Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('InterfaceDescLanguageTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(21);
				EXECUTE IMMEDIATE 
					'CREATE TABLE InterfaceDescLanguageTable (
						ProcessDefId	INT			NOT NULL,		
						ElementId		INT			NOT NULL,
						InterfaceID		INT			NOT NULL,
						Locale			NCHAR(5)	NOT NULL,
						Description		NVARCHAR2(255)	NOT NULL
					)';
					DBMS_OUTPUT.PUT_LINE('Table InterfaceDescLanguageTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);  
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);

	v_logStatus := LogInsert(22,'CREATING TABLE WFActivityReportTable');
	BEGIN
		/* 28/05/2007 Bugzilla Id 442 Varun Bhansaly */ 
		existsflag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('WFActivityReportTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(22);
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFActivityReportTable(
						ProcessDefId         Integer,
						ActivityId           Integer,
						ActivityName         Nvarchar2(30),
						ActionDatetime       Date,
						TotalWICount         Integer,
						TotalDuration        NUMBER,
						TotalProcessingTime  NUMBER
					)';
					DBMS_OUTPUT.PUT_LINE('Table WFActivityReportTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22); 
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);	

	v_logStatus := LogInsert(23,'Modifying Columns TotalDuration,TotalProcessingTime in WFActivityReportTable');
	BEGIN	
		IF existsFlag = 1 THEN 
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME='WFActivityReportTable'
					AND 
					COLUMN_NAME=UPPER('TotalDuration')
					and
					DATA_TYPE='NUMBER';
					existsFlag:=1;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						 existsFlag := 0;
				END;
				IF existsFlag = 0 THEN
					v_logStatus := LogSkip(23);
					EXECUTE IMMEDIATE 'ALTER TABLE WFActivityReportTable MODIFY (TotalDuration NUMBER)';
				END IF;
				
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME='WFActivityReportTable'
					AND 
					COLUMN_NAME=UPPER('TotalProcessingTime')
					and
					DATA_TYPE='NUMBER';
					existsFlag:=1;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						 existsFlag := 0;
				END;
				IF existsFlag = 0 THEN
					v_logStatus := LogSkip(23);
					EXECUTE IMMEDIATE 'ALTER TABLE WFActivityReportTable MODIFY (TotalProcessingTime NUMBER)';
				END IF;
					
		END IF;
		
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);  
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);	

	v_logStatus := LogInsert(24,'CREATING TABLE WFReportDataTable');
	BEGIN
		/* 28/05/2007 Bugzilla Id 442 Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('WFReportDataTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(24);
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFReportDataTable(
						ProcessInstanceId    Nvarchar2(63),
						WorkitemId           Integer,
						ProcessDefId         Integer Not Null,
						ActivityId           Integer,
						UserId               Integer,
						TotalProcessingTime  Integer
					)';
					DBMS_OUTPUT.PUT_LINE('Table WFReportDataTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24); 
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);
		
	v_logStatus := LogInsert(25,'CREATING GLOBAL TEMPORARY TABLE GTEMPWORKLISTTABLE');
	BEGIN
			/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('GTempWorkListTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(25);
				EXECUTE IMMEDIATE 
					'CREATE GLOBAL TEMPORARY TABLE GTEMPWORKLISTTABLE(
						PROCESSINSTANCEID	NVARCHAR2(63)          NOT NULL,
						PROCESSDEFID		INTEGER                NOT NULL,
						PROCESSNAME		NVARCHAR2(30)          NOT NULL,
						ACTIVITYID		INTEGER,
						ACTIVITYNAME		NVARCHAR2(30),
						PRIORITYLEVEL		INTEGER,
						INSTRUMENTSTATUS	NVARCHAR2(1),
						LOCKSTATUS		NVARCHAR2(1)           NOT NULL,
						LOCKEDBYNAME		NVARCHAR2(63),
						VALIDTILL		DATE,
						CREATEDBYNAME		NVARCHAR2(63),
						CREATEDDATETIME		DATE                   NOT NULL,
						STATENAME		NVARCHAR2(255),
						CHECKLISTCOMPLETEFLAG	NVARCHAR2(1),
						ENTRYDATETIME		DATE,
						LOCKEDTIME		DATE,
						INTRODUCTIONDATETIME	DATE,
						INTRODUCEDBY		NVARCHAR2(63),
						ASSIGNEDUSER		NVARCHAR2(63),
						WORKITEMID		INTEGER                NOT NULL,
						QUEUENAME		NVARCHAR2(63),
						ASSIGNMENTTYPE		NVARCHAR2(1),
						PROCESSINSTANCESTATE	INTEGER,
						QUEUETYPE		NVARCHAR2(1),
						STATUS			NVARCHAR2(255),
						Q_QUEUEID		INTEGER,
						REFERREDBYNAME		NVARCHAR2(63),
						REFERREDTO		INTEGER,
						Q_USERID		INTEGER,
						FILTERVALUE		INTEGER,
						Q_STREAMID		INTEGER,
						COLLECTFLAG		NVARCHAR2(1),
						PARENTWORKITEMID	INTEGER,
						PROCESSEDBY		NVARCHAR2(63),
						LASTPROCESSEDBY		INTEGER,
						PROCESSVERSION		INTEGER,
						WORKITEMSTATE		INTEGER,
						PREVIOUSSTAGE		NVARCHAR2(30),
						EXPECTEDWORKITEMDELAY	DATE,
						VAR_INT1		INTEGER,
						VAR_INT2		INTEGER,
						VAR_INT3		INTEGER,
						VAR_INT4		INTEGER,
						VAR_INT5		INTEGER,
						VAR_INT6		INTEGER,
						VAR_INT7		INTEGER,
						VAR_INT8		INTEGER,
						VAR_FLOAT1		NUMBER(15,2),
						VAR_FLOAT2		NUMBER(15,2),
						VAR_DATE1		DATE,
						VAR_DATE2		DATE,
						VAR_DATE3		DATE,
						VAR_DATE4		DATE,
						VAR_LONG1		INTEGER,
						VAR_LONG2		INTEGER,
						VAR_LONG3		INTEGER,
						VAR_LONG4		INTEGER,
						VAR_STR1	        NVARCHAR2(255),
						VAR_STR2		NVARCHAR2(255),
						VAR_STR3		NVARCHAR2(255),
						VAR_STR4		NVARCHAR2(255),
						VAR_STR5		NVARCHAR2(255),
						VAR_STR6		NVARCHAR2(255),
						VAR_STR7		NVARCHAR2(255),
						VAR_STR8		NVARCHAR2(255),
						Primary Key		(PROCESSINSTANCEID, WORKITEMID)
					) ON COMMIT PRESERVE ROWS';
					DBMS_OUTPUT.PUT_LINE('Table GTempWorkListTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25); 
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);

	v_logStatus := LogInsert(26,'CREATING GLOBAL TEMPORARY TABLE WFTempSearchTable');
	BEGIN
		/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('WFTempSearchTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(26);
				EXECUTE IMMEDIATE 
					'CREATE GLOBAL TEMPORARY TABLE WFTempSearchTable(
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
						VAR_DATE3			DATE,
						VAR_DATE4			DATE,
						VAR_LONG1			INT,
						VAR_LONG2			INT,
						VAR_LONG3			INT,
						VAR_LONG4			INT,
						VAR_STR1			NVARCHAR2(255),
						VAR_STR2			NVARCHAR2(255),
						VAR_STR3			NVARCHAR2(255),
						VAR_STR4			NVARCHAR2(255),
						VAR_STR5			NVARCHAR2(255),
						VAR_STR6			NVARCHAR2(255),
						VAR_STR7			NVARCHAR2(255),
						VAR_STR8			NVARCHAR2(255),
						VAR_REC_1			NVARCHAR2(255),
						VAR_REC_2			NVARCHAR2(255),
						VAR_REC_3			NVARCHAR2(255),
						VAR_REC_4			NVARCHAR2(255),
						VAR_REC_5			NVARCHAR2(255),
						PRIMARY KEY			(ProcessInstanceId, WorkitemId)
					) ON COMMIT PRESERVE ROWS';
					DBMS_OUTPUT.PUT_LINE('Table WFTempSearchTable Created successfully');
		END;

	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);    
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);

	v_logStatus := LogInsert(27,'Adding new column DeleteOnCollect in ACTIVITYTABLE');
	BEGIN
			BEGIN 
			SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS 
			WHERE UPPER(table_name) = 'ACTIVITYTABLE' 
				AND UPPER(column_Name) = UPPER('DeleteOnCollect');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(27);
			EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(DeleteOnCollect NVarChar2(1) NULL)';
			EXECUTE IMMEDIATE 'UPDATE ActivityTable set DeleteOnCollect = N''N'' where ActivityType = 6';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column DeleteOnCollect');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);    
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);

	v_logStatus := LogInsert(28,'CREATING TABLE WFParamMappingBuffer');
	BEGIN
		/* 28/05/2007 Bugzilla Id 690 Varun Bhansaly */ 
		/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE UPPER(TABLE_NAME) = UPPER('WFParamMappingBuffer');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(28);
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFParamMappingBuffer(
						processDefId    INT,
						extMethodId     INT,
						paramMappingBuffer      CLOB,
						UNIQUE(processdefid, extmethodid)
					)';
					DBMS_OUTPUT.PUT_LINE('Table WFParamMappingBuffer Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28); 
			raise_application_error(-20228,v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);

	v_logStatus := LogInsert(29,'Adding new column MappingFile in ExtMethodDefTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = 'EXTMETHODDEFTABLE' 
			AND 
			COLUMN_NAME = 'MAPPINGFILE';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(29);
				EXECUTE IMMEDIATE
					'ALTER TABLE ExtMethodDefTable ADD MappingFile NVarChar2(1)';
				dbms_output.put_line ('Table ExtMethodDefTable altered with new Column MappingFile');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);     
			raise_application_error(-20229,v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);

	v_logStatus := LogInsert(30,'CREATING TABLE SuccessLogTable');
	BEGIN
		/* Added By Varun Bhansaly On 23/07/2007 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('SuccessLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(30);
				EXECUTE IMMEDIATE 
				'CREATE TABLE SuccessLogTable (  
					LogId INT, 
					ProcessInstanceId NVARCHAR2(63) 
				)';
			dbms_output.put_line ('Table SuccessLogTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30); 
			raise_application_error(-20230,v_scriptName ||' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);	

	v_logStatus := LogInsert(31,'CREATING TABLE FailureLogTable');
	BEGIN
		/* Added By Varun Bhansaly On 23/07/2007 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('FailureLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(31);
				EXECUTE IMMEDIATE 
				'CREATE TABLE FailureLogTable (  
					LogId INT, 
					ProcessInstanceId NVARCHAR2(63) 
				)';
			dbms_output.put_line ('Table FailureLogTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31); 
            raise_application_error(-20231,v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);

	v_logStatus := LogInsert(32,'Modifying Password size ,Adding new column SecurityFlag in archivetable');
	BEGIN
		/* Bugzilla Id 1645 */
			
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='ArchiveTable'
			AND 
			COLUMN_NAME=UPPER('passwd')
			and
			DATA_TYPE='NVARCHAR2'
			AND 
			DATA_LENGTH=512;
			existsFlag:=1;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			existsFlag := 0;
		END;
		IF existsFlag = 0 THEN
			v_logStatus := LogSkip(32);
			EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (passwd NVARCHAR2(256))';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with Column passwd size increased to 256');
		END IF;
		

		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveTable') 
			AND 
			COLUMN_NAME=UPPER('SecurityFlag');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(32);
				EXECUTE IMMEDIATE 'ALTER TABLE archivetable ADD SecurityFlag NVARCHAR2(1) CHECK (SecurityFlag IN (N''Y'', N''y'', N''N'', N''n''))';
				EXECUTE IMMEDIATE 'Update archivetable set SecurityFlag = N''N''';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column SecurityFlag');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);   
			raise_application_error(-20232,v_scriptName ||' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);

	v_logStatus := LogInsert(33,'Adding new column SecurityFlag in ExtDBConfTable');
	BEGIN
		/* Bugzilla Id 1645 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('extdbconftable') 
			AND 
			COLUMN_NAME=UPPER('SecurityFlag');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(33);
				EXECUTE IMMEDIATE 'ALTER TABLE extdbconftable ADD SecurityFlag NVARCHAR2(1) CHECK (SecurityFlag IN(N''Y'', N''y'', N''N'', N''n''))';
				EXECUTE IMMEDIATE 'Update extdbconftable set SecurityFlag = N''N''';
				DBMS_OUTPUT.PUT_LINE('Table ExtDBConfTable altered with new Column SecurityFlag');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);  
            raise_application_error(-20233,v_scriptName ||' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);

	v_logStatus := LogInsert(34,'Updating Primary Key for WFDataStructureTable');
	BEGIN
		/** Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1687
		 ** Bugzilla Id 1687 modified according to Bugzilla Id 1788
		 **/
		BEGIN
			v_logStatus := LogSkip(34);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFDataStructureTable') and constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table WFDataStructureTable Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table WFDataStructureTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ExtMethodIndex, DataStructureId)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFDataStructureTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFDataStructureTable');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(34); 
            raise_application_error(-20234,v_scriptName ||' BLOCK 34 FAILED');
	END;
	v_logStatus := LogUpdate(34);

	v_logStatus := LogInsert(35,'CREATING TABLE WFQuickSearchTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFQuickSearchTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(35);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFQuickSearchTable(
					VariableId			INT,
					ProcessDefId		INT				NOT NULL,
					VariableName		NVARCHAR2(64)	NOT NULL,
					Alias				NVARCHAR2(64)	NOT NULL,
					SearchAllVersion	NVARCHAR2(1)	NOT NULL,
					CONSTRAINT UK_WFQuickSearchTable UNIQUE (Alias)
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFQuickSearchTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(35);   
            raise_application_error(-20235,v_scriptName ||' BLOCK 35 FAILED');
	END;
	v_logStatus := LogUpdate(35);

	v_logStatus := LogInsert(36,'CREATING SEQUENCE VARIABLEID');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('VARIABLEID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(36);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE VARIABLEID INCREMENT BY 1 START WITH 1';
				DBMS_OUTPUT.PUT_LINE('SEQUENCE VARIABLEID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(36);  
            raise_application_error(-20236,v_scriptName ||' BLOCK 36 FAILED');
	END;
	v_logStatus := LogUpdate(36);

	v_logStatus := LogInsert(37,'CREATING TRIGGER WF_Variable_ID_Trigger BEFORE INSERT ON WFQUICKSEARCHTABLE ');
	BEGIN
		v_logStatus := LogSkip(37);
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_Variable_ID_Trigger
				BEFORE INSERT ON WFQUICKSEARCHTABLE 	
				FOR EACH ROW 
				BEGIN 		
					SELECT VARIABLEID.NEXTVAL INTO :NEW.VARIABLEID FROM dual; 	
				END;';
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(37); 
			raise_application_error(-20237,v_scriptName ||' BLOCK 37 FAILED');
	END;
	v_logStatus := LogUpdate(37);

	v_logStatus := LogInsert(38,'CREATING TABLE WFDurationTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDurationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(38);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFDurationTable(
				ProcessDefId		INT				NOT NULL, 
				DurationId			INT				NOT NULL,
				WFYears				NVARCHAR2(256),
				VariableId_Years	INT	,
				VarFieldId_Years	INT	,
				WFMonths			NVARCHAR2(256),
				VariableId_Months   INT	,
				VarFieldId_Months	INT	,
				WFDays				NVARCHAR2(256),
				VariableId_Days		INT	,
				VarFieldId_Days		INT	,
				WFHours				NVARCHAR2(256),
				VariableId_Hours	INT	,
				VarFieldId_Hours	INT	,
				WFMinutes			NVARCHAR2(256),
				VariableId_Minutes	INT	,
				VarFieldId_Minutes	INT	,
				WFSeconds			NVARCHAR2(256),
				VariableId_Seconds	INT	,
				VarFieldId_Seconds	INT ,
				CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(38);    
			raise_application_error(-20238,v_scriptName ||' BLOCK 38 FAILED');
	END;
	v_logStatus := LogUpdate(38);

	v_logStatus := LogInsert(39,'CREATING TABLE WFCommentsTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFCommentsTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(39);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFCommentsTable(
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
					CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3))
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFCommentsTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(39);    
			raise_application_error(-20239,v_scriptName ||' BLOCK 39 FAILED');
	END;
	v_logStatus := LogUpdate(39);

	v_logStatus := LogInsert(40,'CREATING SEQUENCE COMMENTSID');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('COMMENTSID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(40);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE COMMENTSID INCREMENT BY 1 START WITH 1';
				DBMS_OUTPUT.PUT_LINE('SEQUENCE COMMENTSID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(40);     
			raise_application_error(-20240,v_scriptName ||' BLOCK 40 FAILED');
	END;
	v_logStatus := LogUpdate(40);

	v_logStatus := LogInsert(41,'Creating TRIGGER WF_Comments_ID_TRIGGER BEFORE INSERT ON WFCOMMENTSTABLE');
	BEGIN
		v_logStatus := LogSkip(41);
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_Comments_ID_TRIGGER 	
				BEFORE INSERT ON WFCOMMENTSTABLE 	
				FOR EACH ROW 
				BEGIN 		
					SELECT CommentsId.NEXTVAL INTO :NEW.CommentsId FROM dual; 	
				END;';

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(41); 
			raise_application_error(-20241,v_scriptName ||' BLOCK 41 FAILED');
	END;
	v_logStatus := LogUpdate(41);

	v_logStatus := LogInsert(42,'CREATING TABLE WFFilterTable');
	BEGIN
		/* Added By Varun Bhansaly On 29/10/2007 */
		/** 
		 * Algortihm :-
		 * If WFFilterTable doesnot exist, then 
		 *	1. if FilterTable exists, rename filterTable To WFFilterTable, rename columns also.
		 *  2. if FilterTable doesnot exist, create WFFilterTable with default columns.
		 */
		v_logStatus := LogSkip(42);
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFFilterTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
		END;

		IF(existsFlag = 0) THEN
		BEGIN
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('FilterTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0;
			END;
			IF(existsFlag = 1)THEN
			BEGIN
				EXECUTE IMMEDIATE 'RENAME FilterTable TO WFFilterTable'; 
				EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable RENAME COLUMN ID TO ObjectIndex';
				EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable RENAME COLUMN Type TO ObjectType';
				/**
				 * Issue Converting Varchar2 Type NULL column to NVarchar2 NOT NULL column.
				 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL, gives Error
					 ORA-00604: error occurred at recursive SQL level 1
					 ORA-12714: invalid national character set specified
				 * Though the commands
				 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1)
				 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL,
				 * solves the issue.
				 * - Varun Bhansaly
				 */
				EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1)';
				BEGIN
					EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL';
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE('Unable to modify ObjectType to NOT NULL');
				END;
				DBMS_OUTPUT.PUT_LINE('Table FilterTable successfully renamed to WFFilterTable');
			END;
			ELSE
			BEGIN
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFFilterTable(
						ObjectIndex			NUMBER(5)		NOT NULL,
						ObjectType			NVARCHAR2(1)	NOT NULL
					)';
				DBMS_OUTPUT.PUT_LINE('Table WFFilterTable Created successfully');
			END;
			END IF;
		END;
		END IF;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(42);        
			raise_application_error(-20242,v_scriptName ||' BLOCK 42 FAILED');
	END;
	v_logStatus := LogUpdate(42);

	v_logStatus := LogInsert(43,'Adding new column ProcessStatus in CheckOutProcessesTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('CheckOutProcessesTable') 
			AND 
			COLUMN_NAME=UPPER('ProcessStatus');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(43);
				EXECUTE IMMEDIATE 'ALTER TABLE CheckOutProcessesTable Add ProcessStatus NVARCHAR2(1) NULL';
				DBMS_OUTPUT.PUT_LINE('Table CheckOutProcessesTable altered with new Column ProcessStatus');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(43);   
			raise_application_error(-20243,v_scriptName ||' BLOCK 43 FAILED');
	END;
	v_logStatus := LogUpdate(43);

	v_logStatus := LogInsert(44,'CREATING TABLE WFSwimLaneTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSwimLaneTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(44);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSwimLaneTable(
					ProcessDefId    INTEGER		NOT NULL,
					SwimLaneId      INTEGER     NOT NULL,
					SwimLaneWidth   INTEGER     NOT NULL,
					SwimLaneHeight  INTEGER     NOT NULL,
					ITop            INTEGER     NOT NULL,
					ILeft           INTEGER     NOT NULL,
					BackColor       NUMBER      NOT NULL
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFSwimLaneTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(44);            
			raise_application_error(-20244,v_scriptName ||' BLOCK 44 FAILED');
	END;
	v_logStatus := LogUpdate(44);	

	v_logStatus := LogInsert(45,'Adding new Column QueueFilter in QueueDefTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('QueueDefTable') 
			AND 
			COLUMN_NAME=UPPER('QueueFilter');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(45);
				EXECUTE IMMEDIATE 'ALTER TABLE QueueDefTable Add QueueFilter NVARCHAR2(2000)	NULL';
				DBMS_OUTPUT.PUT_LINE('Table QueueDefTable altered with new Column QueueFilter');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(45);    
			raise_application_error(-20245,v_scriptName ||' BLOCK 45 FAILED');
	END;
	v_logStatus := LogUpdate(45);

	v_logStatus := LogInsert(46,'CREATING GLOBAL TEMPORARY TABLE GTempProcessName');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempProcessName');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(46);
				EXECUTE IMMEDIATE 
				'CREATE GLOBAL TEMPORARY TABLE GTempProcessName (
					TempProcessName			NVarchar2(64)
					) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempProcessName Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(46);     
			raise_application_error(-20246,v_scriptName ||' BLOCK 46 FAILED');
	END;
	v_logStatus := LogUpdate(46);

	v_logStatus := LogInsert(47,'CREATING GLOBAL TEMPORARY TABLE GTempQueueName');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempQueueName');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(47);
				EXECUTE IMMEDIATE 
				
				'CREATE GLOBAL TEMPORARY TABLE GTempQueueName (
					TempQueueName			NVarchar2(64)
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempQueueName Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(47);     
			raise_application_error(-20247,v_scriptName ||' BLOCK 47 FAILED');
	END;
	v_logStatus := LogUpdate(47);

	v_logStatus := LogInsert(48,'CREATING GLOBAL TEMPORARY TABLE GTempQueueTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempQueueTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(48);
				EXECUTE IMMEDIATE 
				'CREATE GLOBAL TEMPORARY TABLE GTempQueueTable (
					TempQueueId			Int, 
					TempQueueName			NVarchar2(64), 
					TempQueueType			Char(1), 
					TempAllowReassignment		Char(1), 
					TempFilterOption		Int, 
					TempFilterValue			NVarchar2(64),
					TempAssignedTillDatetime	Date, 
					TotalWorkItems			Int, 
					TotalActiveUsers		Int, 
					LoginUsers			Int, 
					Delayed				Int, 
					totalassignedtouser		Int,
					totalusers			Int
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempQueueTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(48); 
			raise_application_error(-20248,v_scriptName ||' BLOCK 48 FAILED');
	END;
	v_logStatus := LogUpdate(48);

	v_logStatus := LogInsert(49,'CREATING GLOBAL TEMPORARY TABLE GTempUserTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempUserTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(49);
				EXECUTE IMMEDIATE 
					
				'CREATE GLOBAL TEMPORARY TABLE GTempUserTable (
					TempUserindex			Int		PRIMARY KEY, 
					TempUserName			NVarchar2(64), 
					TempPersonalName		NVarchar2(256), 
					TempFamilyName			NVarchar2(256), 
					TempMailId			NVarchar2(512), 
					TempStatus			Int, 
					PersonalQueueStatus		Int, 
					SystemAssignedWorkItems		Int, 
					WorkItemsProcessed		Int, 
					SharedQueueStatus		Int, 
					QueueAssignment			Date
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempUserTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(49); 
            raise_application_error(-20249,v_scriptName ||' BLOCK 49 FAILED');
	END;
	v_logStatus := LogUpdate(49);

	v_logStatus := LogInsert(50,'CREATING TABLE WFExportTable');
	BEGIN
		/* Added By Varun Bhansaly On 19/12/2007 SrNo-11 WFExportTable */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFExportTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(50);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFExportTable(
					ProcessDefId		INTEGER,
					ActivityId			INTEGER,
					DatabaseType		NVARCHAR2(10),
					DatabaseName		NVARCHAR2(50),
					UserId				NVARCHAR2(50),
					UserPwd				NVARCHAR2(255),
					TableName			NVARCHAR2(50),
					CSVType				INTEGER,
					NoOfRecords			INTEGER,
					HostName			NVARCHAR2(255),
					ServiceName			NVARCHAR2(255),
					Port				NVARCHAR2(255),
					Header				NVARCHAR2(1),
					CSVFileName			NVARCHAR2(255),
					OrderBy				NVARCHAR2(255),
					FileExpireTrigger	NVARCHAR2(1),
					BreakOn				NVARCHAR2(1)
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFExportTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(50); 
			raise_application_error(-20250,v_scriptName ||' BLOCK 50 FAILED');
	END;
	v_logStatus := LogUpdate(50);	

	v_logStatus := LogInsert(51,'CREATING TABLE WFDataMapTable');
	BEGIN
		/* Added By Varun Bhansaly On 19/12/2007 SrNo-12, WFDataMapTable */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDataMapTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(51);
				EXECUTE IMMEDIATE 
				
				'CREATE TABLE WFDataMapTable(
					ProcessDefId		INTEGER,
					ActivityId			INTEGER,
					OrderId				INTEGER,
					FieldName			NVARCHAR2(255),
					MappedFieldName		NVARCHAR2(255),
					FieldLength			INTEGER,
					DocTypeDefId		INTEGER,
					DateTimeFormat		NVARCHAR2(50),
					QuoteFlag			NVARCHAR2(1)
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(51);       
			raise_application_error(-20251,v_scriptName ||' BLOCK 51 FAILED');
	END;
	v_logStatus := LogUpdate(51);	

	v_logStatus := LogInsert(52,'CREATING TABLE WFRoutingServerInfo');
	BEGIN
		/* Added By Varun Bhansaly On 21/12/2007 SrNo-13, WFRoutingServerInfo */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFRoutingServerInfo');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(52);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFRoutingServerInfo( 
					InfoId				INT, 
					DmsUserIndex			INT, 
					DmsUserName			NVARCHAR2(64), 
					DmsUserPassword			NVARCHAR2(255), 
					DmsSessionId			INT, 
					Data				NVARCHAR2(128) 
				) ';
				DBMS_OUTPUT.PUT_LINE('Table WFRoutingServerInfo Created successfully');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(52);      
			raise_application_error(-20252,v_scriptName ||' BLOCK 52 FAILED');
	END;
	v_logStatus := LogUpdate(52);

	v_logStatus := LogInsert(53,'CREATING SEQUENCE INFOID  ');
	BEGIN
		
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('INFOID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(53);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE INFOID INCREMENT BY 1 START WITH 1 ';
				dbms_output.put_line ('SEQUENCE INFOID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(53);     
			raise_application_error(-20253,v_scriptName ||' BLOCK 53 FAILED');
	END;
	v_logStatus := LogUpdate(53);

	v_logStatus := LogInsert(54,'Adding new Column isEncrypted in TemplateDefinitionTable');
	BEGIN
		/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('TemplateDefinitionTable') 
			AND 
			COLUMN_NAME=UPPER('isEncrypted');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(54);
				EXECUTE IMMEDIATE 'ALTER TABLE TemplateDefinitionTable Add isEncrypted NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table TemplateDefinitionTable altered with new Column isEncrypted');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(54);   
			raise_application_error(-20254,v_scriptName ||' BLOCK 54 FAILED');
	END;
	v_logStatus := LogUpdate(54);
	
	v_logStatus := LogInsert(55,'Adding new Column isEncrypted in ActionDefTable');
	BEGIN
		/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionDefTable') 
			AND 
			COLUMN_NAME=UPPER('isEncrypted');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(55);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionDefTable Add isEncrypted NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table ActionDefTable altered with new Column isEncrypted');
		END;
	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(55);            
			raise_application_error(-20255,v_scriptName ||' BLOCK 55 FAILED');
	END;
	v_logStatus := LogUpdate(55);
	
	v_logStatus := LogInsert(56,'Adding new Column isEncrypted in WFForm_Table');
	BEGIN
			/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFForm_Table') 
			AND 
			COLUMN_NAME=UPPER('isEncrypted');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(56);
				EXECUTE IMMEDIATE 'ALTER TABLE WFForm_Table Add isEncrypted NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table WFForm_Table altered with new Column isEncrypted');
				
				DBMS_OUTPUT.PUT_LINE('UPDATING  WFForm_Table column isEncrypted');			
				EXECUTE IMMEDIATE 'UPDATE WFForm_Table SET isEncrypted=N''N'' WHERE isEncrypted IS NULL';	
				COMMIT;
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(56);            
			raise_application_error(-20256,v_scriptName ||' BLOCK 56 FAILED');
	END;
	v_logStatus := LogUpdate(56);

	v_logStatus := LogInsert(57,'Adding new Column isEncrypted in TemplateMultiLanguageTable');
	BEGIN
		/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('TemplateMultiLanguageTable') 
			AND 
			COLUMN_NAME=UPPER('isEncrypted');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(57);
				EXECUTE IMMEDIATE 'ALTER TABLE TemplateMultiLanguageTable Add isEncrypted NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable altered with new Column isEncrypted');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(57);    
			raise_application_error(-20257,v_scriptName ||' BLOCK 57 FAILED');
	END;
	v_logStatus := LogUpdate(57);	
		
	v_logStatus := LogInsert(58,'CREATING SEQUENCE JMSMessageId');
	BEGIN
		/* Added By Varun Bhansaly On 28/01/2008 Bugzilla Id 1775 */
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('JMSMessageId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_lastSeqValue := -1; /* Sequence JMSMessageId doesnot exist */
		END;

		IF(v_lastSeqValue = 1 OR v_lastSeqValue = -1) THEN
			v_logStatus := LogSkip(58);
			IF(v_lastSeqValue <> -1) THEN
				EXECUTE IMMEDIATE 'DROP SEQUENCE JMSMessageId';
			END IF;
			SELECT (MAX(MessageId) + 1) INTO v_lastSeqValue FROM WFJMSMessageTable;
			EXECUTE IMMEDIATE 'CREATE SEQUENCE JMSMessageId INCREMENT BY 1 START WITH ' || TO_CHAR(COALESCE(v_lastSeqValue, 1));
			DBMS_OUTPUT.PUT_LINE('SEQUENCE JMSMessageId Successfully Created');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(58);     
			raise_application_error(-20258,v_scriptName ||' BLOCK 58 FAILED');
	END;
	v_logStatus := LogUpdate(58);
		
	v_logStatus := LogInsert(59,'Modifying PRIMARY KEY CONSTRAINT in StreamDefTable');
	BEGIN
		/* Added By Varun Bhansaly On 28/01/2008 Bugzilla Id 1774 */
		v_logStatus := LogSkip(59);
		BEGIN
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('StreamDefTable') AND CONSTRAINT_TYPE = 'U' AND CONSTRAINT_NAME = 'U_SDTABLE';
			EXECUTE IMMEDIATE 'ALTER TABLE StreamDefTable DROP CONSTRAINT U_SDTABLE';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE('No Unique Constraints with the name U_SDTABLE Exists for StreamDefTable');
		END;

		BEGIN
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('StreamDefTable') and constraint_type = 'P';
			EXECUTE IMMEDIATE 'Alter Table StreamDefTable Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table StreamDefTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ActivityId, StreamId)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for StreamDefTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter Table StreamDefTable Add Constraint U_SDTABLE Primary Key (ProcessDefId, ActivityId, StreamId)';
				DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for StreamDefTable..Hence Primary Key Added.');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(59);
			raise_application_error(-20259,v_scriptName ||' BLOCK 59 FAILED');
	END;
	v_logStatus := LogUpdate(59);
		
	v_logStatus := LogInsert(60,'Adding new column ParameterScope in ExtMethodParamDefTable,Adding new column ClassName in WFDataStructureTable,And updating both tables,INSERTING Value in  WFCabVersionTable for Bugzilla_Id_3682');
	BEGIN
		/* Added By Varun Bhansaly On 06/02/2008 Bugzilla Id 3682 */
		Upgrade1(N'Bugzilla_Id_3682', existsFlag);
		v_logStatus := LogSkip(60);
		SAVEPOINT savepoint3;
		IF(existsFlag <> 0) THEN /* Not Found */
			Upgrade_CheckColumnExistence('ExtMethodParamDefTable', 'ParameterScope', existsFlag);
			IF(existsFlag <> 0) THEN /* Not Found */
				EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD ParameterScope NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamDefTable altered with new Column ParameterScope');
			END IF;

			Upgrade_CheckColumnExistence('WFDataStructureTable', 'ClassName', existsFlag);
			IF(existsFlag <> 0) THEN /* Not Found */
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable ADD ClassName NVARCHAR2(255)';  /* Bugzilla Bug Id 7588 Changed By Ishu Saraf */
				DBMS_OUTPUT.PUT_LINE('Table WFDataStructureTable altered with new Column ClassName');
			END IF;

			BEGIN
				EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET parameterScope = N''O'' WHERE parameterOrder = 0 OR parameterName = N''Fault'' and extAppType != N''E''';

				EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET parameterScope = N''I'' WHERE parameterOrder != 0 AND parameterName != N''Fault'' and extAppType != ''E''';
				
				EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET ParameterName = (SELECT extMethodName FROM ExtMethodDefTable WHERE extMethodParamDefTable.processDefId = ExtMethodDefTable.processDefId AND ExtMethodParamDefTable.extMethodIndex = ExtMethodDefTable.extMethodIndex) WHERE parameterOrder = 0';
				
				EXECUTE IMMEDIATE 'UPDATE WFDataStructureTable SET ClassName = WFDataStructureTable.Name WHERE type = 11 AND ParentIndex = 0';

				EXECUTE IMMEDIATE 'UPDATE WFDataStructureTable SET WFDataStructureTable.Name = (SELECT parameterName FROM ExtMethodParamDefTable WHERE WFDataStructureTable.processDefId = ExtMethodParamDefTable.processDefId	AND WFDataStructureTable.extMethodIndex = ExtMethodParamDefTable.extMethodIndex	AND parameterOrder = 0) WHERE ParentIndex = 0';
				
				EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''Bugzilla_Id_3682'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Enhancements in Web Services'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('Successfully Applied Bugzilla_Id_3682 !!');
			EXCEPTION 
			WHEN OTHERS THEN 
				DBMS_OUTPUT.PUT_LINE('Check !! Check !! Execution encountered while applying Bugzilla_Id_3682');
				DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint3');
				ROLLBACK TO SAVEPOINT savepoint3;
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(60); 
			raise_application_error(-20260,v_scriptName ||' BLOCK 60 FAILED');
	END;
	v_logStatus := LogUpdate(60);
		
	v_logStatus := LogInsert(61,'Adding new column VariableLength in VarMappingTable,and Updating VarMappingTable');
	BEGIN
		/* Added By Varun Bhansaly ON 08/02/2008 for Bugzilla Id 3284, inherited from HotFix_5.0_SP4_79 */
		Upgrade_CheckColumnExistence('VarMappingTable', 'VariableLength', existsFlag);
		IF(existsFlag <> 0) THEN /* Not Found */
			v_logStatus := LogSkip(61);
			EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable ADD VariableLength  INT	NULL';
			DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VariableLength');
			BEGIN
				SAVEPOINT savepoint4;
				EXECUTE IMMEDIATE 'UPDATE VarMappingTable SET VariableLength = 255 WHERE SystemDefinedName IN (''VAR_STR1'', ''VAR_STR2'', ''VAR_STR3'', ''VAR_STR4'', ''VAR_STR5'', ''VAR_STR6'', ''VAR_STR7'', ''VAR_STR8'') OR SystemDefinedName IN (''VAR_REC_1'',''VAR_REC_2'',''VAR_REC_3'',''VAR_REC_4'',''VAR_REC_5'')';
				EXECUTE IMMEDIATE 'UPDATE VarMappingTable SET VariableLength = 1024 WHERE VariableScope = ''I'' AND VariableType = 10 AND ExtObjId = 1';
				COMMIT;
			EXCEPTION
			When Others THEN
				Rollback to SAVEPOINT savepoint4;
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(61); 
			raise_application_error(-20261,v_scriptName ||' BLOCK 61 FAILED');
	END;
	v_logStatus := LogUpdate(61);
		
	v_logStatus := LogInsert(62,'Modifyiny column size of AppServerPort,PortId in ArchiveTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='ArchiveTable'
			AND 
			COLUMN_NAME=UPPER('AppServerPort')
			and
			DATA_TYPE='NVARCHAR2'
			AND 
			DATA_LENGTH=10;
			existsFlag:=1;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			existsFlag := 0;
		END;
		IF existsFlag = 0 THEN
			v_logStatus := LogSkip(62);
			EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (AppServerPort NVARCHAR2(5))';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with Column AppServerPort size increased to 5');
		END IF;
		
		BEGIN		
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='ArchiveTable'
			AND 
			COLUMN_NAME=UPPER('PortId')
			AND
			DATA_TYPE='NVARCHAR2'
			AND 
			DATA_LENGTH=10;
			existsFlag:=1;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			 existsFlag := 0;
		END;
		IF existsFlag = 0 THEN
			v_logStatus := LogSkip(62);
			EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (PortId NVARCHAR2(5))';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with Column PortId size increased to 5');
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(62);   
			raise_application_error(-20262,v_scriptName ||' BLOCK 62 FAILED');
	END;
	v_logStatus := LogUpdate(62);
		
	v_logStatus := LogInsert(63,'CREATE TABLE WFTypeDescTable');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTypeDescTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(63);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTypeDescTable (
					ProcessDefId			INT				NOT NULL,
					TypeId					SMALLINT		NOT NULL,
					TypeName				NVARCHAR2(128)	NOT NULL, 
					ExtensionTypeId			SMALLINT			NULL,
					PRIMARY KEY (ProcessDefId, TypeId)
				)';
			dbms_output.put_line ('Table WFTypeDescTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(63);        
			raise_application_error(-20263,v_scriptName ||' BLOCK 63 FAILED');
	END;
	v_logStatus := LogUpdate(63);
		
	v_logStatus := LogInsert(64,'CREATE TABLE WFTypeDefTable');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTypeDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(64);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTypeDefTable (
					ProcessDefId		INT				NOT NULL,
					ParentTypeId		SMALLINT		NOT NULL,
					TypeFieldId			SMALLINT		NOT NULL,
					FieldName			NVARCHAR2(128)	NOT NULL, 
					WFType				SMALLINT		NOT NULL,
					TypeId				SMALLINT		NOT NULL,
					Unbounded			NVARCHAR2(1)	DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))   NOT NULL,
					ExtensionTypeId			SMALLINT,
					PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId)
				)';
			dbms_output.put_line ('Table WFTypeDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(64);            
			raise_application_error(-20264,v_scriptName ||' BLOCK 64 FAILED');
	END;
	v_logStatus := LogUpdate(64);
		
	v_logStatus := LogInsert(65,'CREATE TABLE WFUDTVarMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(65);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFUDTVarMappingTable (
					ProcessDefId 		INT 			NOT NULL,
					VariableId			INT 			NOT NULL,
					VarFieldId			SMALLINT		NOT NULL,
					TypeId				SMALLINT		NOT NULL,
					TypeFieldId			SMALLINT		NOT NULL,
					ParentVarFieldId	SMALLINT		NOT NULL,
					MappedObjectName	NVARCHAR2(256) 		NULL,
					ExtObjId 			INT					NULL,
					MappedObjectType	NVARCHAR2(1)		NULL,
					DefaultValue		NVARCHAR2(256)		NULL,
					FieldLength			INT					NULL,
					VarPrecision		INT					NULL,
					RelationId			INT 				NULL,
					PRIMARY KEY (ProcessDefId, VariableId, VarFieldId)
				)';
			dbms_output.put_line ('Table WFUDTVarMappingTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(65);   
			raise_application_error(-20265,v_scriptName ||' BLOCK 65 FAILED');
	END;
	v_logStatus := LogUpdate(65);
		
	v_logStatus := LogInsert(66,'CREATE TABLE WFVarRelationTable ');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFVarRelationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(66);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFVarRelationTable (
					ProcessDefId 		INT 				NOT NULL,
					RelationId			INT 				NOT NULL,
					OrderId				INT 				NOT NULL,
					ParentObject		NVARCHAR2(256)		NOT NULL,
					Foreignkey			NVARCHAR2(256)		NOT NULL,
					FautoGen			NVARCHAR2(1)		    NULL,
					ChildObject			NVARCHAR2(256)		NOT NULL,
					Refkey				NVARCHAR2(256)		NOT NULL,
					RautoGen			NVARCHAR2(1)		    NULL,
					PRIMARY KEY (ProcessDefId, RelationId, OrderId)
				)';
			dbms_output.put_line ('Table WFVarRelationTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(66);   
			raise_application_error(-20266,v_scriptName ||' BLOCK 66 FAILED');
	END;
	v_logStatus := LogUpdate(66);
		
	v_logStatus := LogInsert(67,'CREATE TABLE WFDataObjectTable');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDataObjectTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(67);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFDataObjectTable (
					ProcessDefId 		INT 			NOT NULL,
					iId					INT,
					xLeft				INT,
					yTop				INT,
					Data				NVARCHAR2(255),
					PRIMARY KEY (ProcessDefId, iId)
				)';
			dbms_output.put_line ('Table WFDataObjectTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(67);
			raise_application_error(-20267,v_scriptName ||' BLOCK 67 FAILED');
	END;
	v_logStatus := LogUpdate(67);
		
	v_logStatus := LogInsert(68,'CREATE TABLE WFGroupBoxTable');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFGroupBoxTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(68);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFGroupBoxTable (
					ProcessDefId 			INT 			NOT NULL,
					GroupBoxId				INT,
					GroupBoxWidth			INT,
					GroupBoxHeight			INT,
					iTop					INT,
					iLeft					INT,
					BlockName			NVARCHAR2(255)		NOT NULL,
					PRIMARY KEY (ProcessDefId, GroupBoxId)
				)';
			dbms_output.put_line ('Table WFGroupBoxTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(68);
			raise_application_error(-20268,v_scriptName ||' BLOCK 68 FAILED');
	END;
	v_logStatus := LogUpdate(68);
		
	v_logStatus := LogInsert(69,'CREATE TABLE WFAdminLogTable ');
	BEGIN
		/* Added By Ishu Saraf On 31/07/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAdminLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(69);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAdminLogTable  (
					AdminLogId				INT			NOT NULL	PRIMARY KEY,
					ActionId				INT			NOT NULL,
					ActionDateTime			DATE		NOT NULL,
					ProcessDefId			INT,
					QueueId					INT,
					QueueName       		NVARCHAR2(64),
					FieldId1				INT,
					FieldName1				NVARCHAR2(255),
					FieldId2				INT,
					FieldName2      		NVARCHAR2(255),
					Property        		NVARCHAR2(64),
					UserId					INT,
					UserName				NVARCHAR2(64),
					OldValue				NVARCHAR2(255),
					NewValue				NVARCHAR2(255),
					WEFDate         		DATE,
					ValidTillDate   		DATE
				)';
			dbms_output.put_line ('Table WFAdminLogTable Created successfully');
			EXECUTE IMMEDIATE 'CREATE SEQUENCE AdminLogId INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('SEQUENCE AdminLogId Successfully Created');
			EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_ADMIN_LOG_ID_TRIGGER BEFORE INSERT ON WFAdminLogTable FOR EACH ROW BEGIN SELECT AdminLogId.nextval INTO :new.AdminLogId FROM dual; END;';
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(69);             
			raise_application_error(-20269,v_scriptName ||' BLOCK 69 FAILED');
	END;
	v_logStatus := LogUpdate(69);
		
	v_logStatus := LogInsert(70,'Adding new column FunctionType with check constraint in WFWebServiceTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
			AND 
			COLUMN_NAME=UPPER('FunctionType');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(70);
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add FunctionType NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column FunctionType');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(70);   
			raise_application_error(-20270,v_scriptName ||' BLOCK 70 FAILED');
	END;
	v_logStatus := LogUpdate(70);
	
	v_logStatus := LogInsert(71,'Adding new column VariableId in ActivityAssociationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityAssociationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(71);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityAssociationTable Add VariableId INT DEFAULT 0 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table ActivityAssociationTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(71);   
			raise_application_error(-20271,v_scriptName ||' BLOCK 71 FAILED');
	END;
	v_logStatus := LogUpdate(71);
	
	v_logStatus := LogInsert(72,'Adding new column VarPrecision in VarMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarMappingTable') 
			AND 
			COLUMN_NAME=UPPER('VarPrecision');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(72);
				EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add VarPrecision INT DEFAULT 0';
				DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VarPrecision');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(72);   
			raise_application_error(-20272,v_scriptName ||' BLOCK 72 FAILED');
	END;
	v_logStatus := LogUpdate(72);
	

	
	v_logStatus := LogInsert(73,'Adding new column Unbounded in VarMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarMappingTable') 
			AND 
			COLUMN_NAME=UPPER('Unbounded');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(73);
				EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add Unbounded NVARCHAR2(1) DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')) NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column Unbounded');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(73);   
			raise_application_error(-20273,v_scriptName ||' BLOCK 73 FAILED');
	END;
	v_logStatus := LogUpdate(73);
		
	v_logStatus := LogInsert(74,'Adding new column VariableId in VarMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarMappingTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
			v_isVariableIDUpdateRequired:=0;
			DBMS_OUTPUT.PUT_LINE('!!!!!!!!!!No requirement for changing the variable_id !!!!!!!!!!!!!!!');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(74);
			--ForMayankSir
			v_isVariableIDUpdateRequired:=1;
			
				EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add VariableId INT DEFAULT 0 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(74);   
			raise_application_error(-20274,v_scriptName ||' BLOCK 74 FAILED');
	END;
	v_logStatus := LogUpdate(74);
		
	v_logStatus := LogInsert(75,'Adding new column VariableId_1 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(75);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(75);   
			raise_application_error(-20275,v_scriptName ||' BLOCK 75 FAILED');
	END;
	v_logStatus := LogUpdate(75);
		
	v_logStatus := LogInsert(76,'Adding new column VarFieldId_1 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(76);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(76);   
			raise_application_error(-20276,v_scriptName ||' BLOCK 76 FAILED');
	END;
	v_logStatus := LogUpdate(76);
			
	v_logStatus := LogInsert(77,'Adding new column VariableId_2 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(77);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(77);   
			raise_application_error(-20277,v_scriptName ||' BLOCK 77 FAILED');
	END;
	v_logStatus := LogUpdate(77);
		
	v_logStatus := LogInsert(78,'Adding new column VarFieldId_2 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(78);		
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(78);   
			raise_application_error(-20278,v_scriptName ||' BLOCK 78 FAILED');
	END;
	v_logStatus := LogUpdate(78);
			
	v_logStatus := LogInsert(79,'Adding new column VariableId_3 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_3');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(79);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_3 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_3 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_3');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(79);   
			raise_application_error(-20279,v_scriptName ||' BLOCK 79 FAILED');
	END;
	v_logStatus := LogUpdate(79);
			
	v_logStatus := LogInsert(80,'Adding new column VarFieldId_3 in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_3');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(80);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_3 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_3 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_3');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(80);   
			raise_application_error(-20280,v_scriptName ||' BLOCK 80 FAILED');
	END;
	v_logStatus := LogUpdate(80);
	
	v_logStatus := LogInsert(81,'Adding new column FunctionType in RuleOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleOperationTable') 
			AND 
			COLUMN_NAME=UPPER('FunctionType');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(81);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add FunctionType NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column FunctionType');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(81);   
			raise_application_error(-20281,v_scriptName ||' BLOCK 81 FAILED');
	END;
	v_logStatus := LogUpdate(81);
		
	v_logStatus := LogInsert(82,'Adding new column VariableId_1 in RuleConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(82);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(82);   
			raise_application_error(-20282,v_scriptName ||' BLOCK 82 FAILED');
	END;
	v_logStatus := LogUpdate(82);
		
	v_logStatus := LogInsert(83,'Adding new column VarFieldId_1 in RuleConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(83);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(83);   
			raise_application_error(-20283,v_scriptName ||' BLOCK 83 FAILED');
	END;
	v_logStatus := LogUpdate(83);
		
	v_logStatus := LogInsert(84,'Adding new column VariableId_2 in RuleConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(84);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(84);   
			raise_application_error(-20284,v_scriptName ||' BLOCK 84 FAILED');
	END;
	v_logStatus := LogUpdate(84);
		
	v_logStatus := LogInsert(85,'Adding new column VarFieldId_2 in RuleConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('RuleConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(85);
				EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(85);   
			raise_application_error(-20285,v_scriptName ||' BLOCK 85 FAILED');
	END;
	v_logStatus := LogUpdate(85);
		
	v_logStatus := LogInsert(86,'Adding new column VariableId in ExtMethodParamMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ExtMethodParamMappingTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(86);
				EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE ExtMethodParamMappingTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamMappingTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(86);   
			raise_application_error(-20286,v_scriptName ||' BLOCK 86 FAILED');
	END;
	v_logStatus := LogUpdate(86);
		
	v_logStatus := LogInsert(87,'Adding new column VarFieldId in ExtMethodParamMappingTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ExtMethodParamMappingTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(87);
				EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE ExtMethodParamMappingTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamMappingTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(87);   
			raise_application_error(-20287,v_scriptName ||' BLOCK 87 FAILED');
	END;
	v_logStatus := LogUpdate(87);
		
	v_logStatus := LogInsert(88,'Adding new column VariableId_1 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(88);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(88);   
			raise_application_error(-20288,v_scriptName ||' BLOCK 88 FAILED');
	END;
	v_logStatus := LogUpdate(88);
		
	v_logStatus := LogInsert(89,'Adding new column VarFieldId_1 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(89);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(89);   
			raise_application_error(-20289,v_scriptName ||' BLOCK 89 FAILED');
	END;
	v_logStatus := LogUpdate(89);
		
	v_logStatus := LogInsert(90,'Adding new column VariableId_2 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(90);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(90);   
			raise_application_error(-20290,v_scriptName ||' BLOCK 90 FAILED');
	END;
	v_logStatus := LogUpdate(90);
		
	v_logStatus := LogInsert(91,'Adding new column VarFieldId_2 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(91);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(91);   
			raise_application_error(-20291,v_scriptName ||' BLOCK 91 FAILED');
	END;
	v_logStatus := LogUpdate(91);
		
	v_logStatus := LogInsert(92,'Adding new column VariableId_3 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_3');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(92);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_3 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_3 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_3');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(92);   
			raise_application_error(-20292,v_scriptName ||' BLOCK 92 FAILED');
	END;
	v_logStatus := LogUpdate(92);
		
	v_logStatus := LogInsert(93,'Adding new column VarFieldId_3 in ActionOperationTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionOperationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_3');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(93);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_3 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_3 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_3');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(93);   
			raise_application_error(-20293,v_scriptName ||' BLOCK 93 FAILED');
	END;
	v_logStatus := LogUpdate(93);
		
	v_logStatus := LogInsert(94,'Adding new column VariableId_1 in ActionConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(94);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(94);   
			raise_application_error(-20294,v_scriptName ||' BLOCK 94 FAILED');
	END;
	v_logStatus := LogUpdate(94);	
		
	v_logStatus := LogInsert(95,'Adding new column VarFieldId_1 in ActionConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(95);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(95);   
			raise_application_error(-20295,v_scriptName ||' BLOCK 95 FAILED');
	END;
	v_logStatus := LogUpdate(95);
		
	v_logStatus := LogInsert(96,'Adding new column VariableId_2 in ActionConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(96);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(96);   
			raise_application_error(-20296,v_scriptName ||' BLOCK 96 FAILED');
	END;
	v_logStatus := LogUpdate(96);
		
	v_logStatus := LogInsert(97,'Adding new column VarFieldId_2 in ActionConditionTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActionConditionTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(97);
				EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(97);   
			raise_application_error(-20297,v_scriptName ||' BLOCK 97 FAILED');
	END;
	v_logStatus := LogUpdate(97);
		
	v_logStatus := LogInsert(98,'Adding new column VariableId_1 in DataSetTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(98);
				EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(98);   
			raise_application_error(-20298,v_scriptName ||' BLOCK 98 FAILED');
	END;
	v_logStatus := LogUpdate(98);
		
	v_logStatus := LogInsert(99,'Adding new column VarFieldId_1 in DataSetTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(99);
				EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(99);   
			raise_application_error(-20299,v_scriptName ||' BLOCK 99 FAILED');
	END;
	v_logStatus := LogUpdate(99);
		
	v_logStatus := LogInsert(100,'Adding new column VariableId_2 in DataSetTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(100);
				EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(100);   
			raise_application_error(-20300,v_scriptName ||' BLOCK 100 FAILED');
	END;
	v_logStatus := LogUpdate(100);
		
	v_logStatus := LogInsert(101,'Adding new column VarFieldId_2 in DataSetTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(101);
				EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(101);   
			raise_application_error(-20301,v_scriptName ||' BLOCK 101 FAILED');
	END;
	v_logStatus := LogUpdate(101);
		
	v_logStatus := LogInsert(102,'Adding new column VariableId_1 in ScanActionsTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ScanActionsTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(102);
				EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VariableId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VariableId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VariableId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(102);   
			raise_application_error(-20302,v_scriptName ||' BLOCK 102 FAILED');
	END;
	v_logStatus := LogUpdate(102);
		
	v_logStatus := LogInsert(103,'Adding new column VarFieldId_1 in ScanActionsTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ScanActionsTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(103);
				EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VarFieldId_1 INT';
				EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VarFieldId_1 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VarFieldId_1');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(103);   
			raise_application_error(-20303,v_scriptName ||' BLOCK 103 FAILED');
	END;
	v_logStatus := LogUpdate(103);
		
	v_logStatus := LogInsert(104,'Adding new column VariableId_2 in ScanActionsTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ScanActionsTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(104);
				EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VariableId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VariableId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VariableId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(104);   
			raise_application_error(-20304,v_scriptName ||' BLOCK 104 FAILED');
	END;
	v_logStatus := LogUpdate(104);
		
	v_logStatus := LogInsert(105,'Adding new column VarFieldId_2 in ScanActionsTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ScanActionsTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(105);
				EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VarFieldId_2 INT';
				EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VarFieldId_2 = 0';
				DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VarFieldId_2');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(105);   
			raise_application_error(-20305,v_scriptName ||' BLOCK 105 FAILED');
	END;
	v_logStatus := LogUpdate(105);
		
	v_logStatus := LogInsert(106,'Adding new column VariableId in WFDataMapTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDataMapTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(106);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(106);   
			raise_application_error(-20306,v_scriptName ||' BLOCK 106 FAILED');
	END;
	v_logStatus := LogUpdate(106);
		
	v_logStatus := LogInsert(107,'Adding new column VarFieldId in WFDataMapTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDataMapTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(107);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(107);   
			raise_application_error(-20307,v_scriptName ||' BLOCK 107 FAILED');
	END;
	v_logStatus := LogUpdate(107);
		
	v_logStatus := LogInsert(108,'Adding new column VariableId in DataEntryTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataEntryTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(108);
				EXECUTE IMMEDIATE 'ALTER TABLE DataEntryTriggerTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE DataEntryTriggerTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataEntryTriggerTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(108);   
			raise_application_error(-20308,v_scriptName ||' BLOCK 108 FAILED');
	END;
	v_logStatus := LogUpdate(108);
		
	v_logStatus := LogInsert(109,'Adding new column VarFieldId in DataEntryTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DataEntryTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(109);
				EXECUTE IMMEDIATE 'ALTER TABLE DataEntryTriggerTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE DataEntryTriggerTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table DataEntryTriggerTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(109);   
			raise_application_error(-20309,v_scriptName ||' BLOCK 109 FAILED');
	END;
	v_logStatus := LogUpdate(109);
		
	v_logStatus := LogInsert(110,'Adding new column VariableId in ArchiveDataMapTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveDataMapTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(110);
				EXECUTE IMMEDIATE 'ALTER TABLE ArchiveDataMapTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE ArchiveDataMapTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveDataMapTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(110);   
			raise_application_error(-20310,v_scriptName ||' BLOCK 110 FAILED');
	END;
	v_logStatus := LogUpdate(110);
		
	v_logStatus := LogInsert(111,'Adding new column VarFieldId in ArchiveDataMapTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ArchiveDataMapTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(111);
				EXECUTE IMMEDIATE 'ALTER TABLE ArchiveDataMapTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE ArchiveDataMapTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ArchiveDataMapTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(111);   
			raise_application_error(-20311,v_scriptName ||' BLOCK 111 FAILED');
	END;
	v_logStatus := LogUpdate(111);
		
	v_logStatus := LogInsert(112,'Adding new column VariableId in WFJMSSubscribeTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFJMSSubscribeTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(112);
				EXECUTE IMMEDIATE 'ALTER TABLE WFJMSSubscribeTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE WFJMSSubscribeTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFJMSSubscribeTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(112);   
			raise_application_error(-20312,v_scriptName ||' BLOCK 112 FAILED');
	END;
	v_logStatus := LogUpdate(112);
		
	v_logStatus := LogInsert(113,'Adding new column VarFieldId in WFJMSSubscribeTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFJMSSubscribeTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(113);
				EXECUTE IMMEDIATE 'ALTER TABLE WFJMSSubscribeTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE WFJMSSubscribeTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFJMSSubscribeTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(113);   
			raise_application_error(-20313,v_scriptName ||' BLOCK 113 FAILED');
	END;
	v_logStatus := LogUpdate(113);
		
	v_logStatus := LogInsert(114,'Adding new column VariableId in ToDoListDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ToDoListDefTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(114);
				EXECUTE IMMEDIATE 'ALTER TABLE ToDoListDefTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE ToDoListDefTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ToDoListDefTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(114);   
			raise_application_error(-20314,v_scriptName ||' BLOCK 114 FAILED');
	END;
	v_logStatus := LogUpdate(114);
		
	v_logStatus := LogInsert(115,'Adding new column VarFieldId in ToDoListDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ToDoListDefTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(115);
				EXECUTE IMMEDIATE 'ALTER TABLE ToDoListDefTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE ToDoListDefTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ToDoListDefTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(115);   
			raise_application_error(-20315,v_scriptName ||' BLOCK 115 FAILED');
	END;
	v_logStatus := LogUpdate(115);
		
	v_logStatus := LogInsert(116,'Adding new column VariableId in ImportedProcessDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(116);
				EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add VariableId INT';
				EXECUTE IMMEDIATE 'UPDATE ImportedProcessDefTable SET VariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column VariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(116);   
			raise_application_error(-20316,v_scriptName ||' BLOCK 116 FAILED');
	END;
	v_logStatus := LogUpdate(116);
		
	v_logStatus := LogInsert(117,'Adding new column VarFieldId in ImportedProcessDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(117);
				EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add VarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE ImportedProcessDefTable SET VarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column VarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(117);   
			raise_application_error(-20317,v_scriptName ||' BLOCK 117 FAILED');
	END;
	v_logStatus := LogUpdate(117);
		
	v_logStatus := LogInsert(118,'Adding new column DisplayName in ImportedProcessDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
			AND 
			COLUMN_NAME=UPPER('DisplayName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(118);
				EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add DisplayName NVARCHAR2(2000)';
				DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column DisplayName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(118);   
			raise_application_error(-20318,v_scriptName ||' BLOCK 118 FAILED');
	END;
	v_logStatus := LogUpdate(118);
		
	v_logStatus := LogInsert(119,'Adding new column VariableIdTo in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdTo');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(119);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdTo INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdTo = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdTo');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(119);   
			raise_application_error(-20319,v_scriptName ||' BLOCK 119 FAILED');
	END;
	v_logStatus := LogUpdate(119);
		
	v_logStatus := LogInsert(120,'Adding new column VarFieldIdTo in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdTo');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(120);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdTo INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdTo = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdTo');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(120);   
			raise_application_error(-20320,v_scriptName ||' BLOCK 120 FAILED');
	END;
	v_logStatus := LogUpdate(120);
		
	v_logStatus := LogInsert(121,'Adding new column VariableIdFrom in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdFrom');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(121);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdFrom INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdFrom = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdFrom');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(121);   
			raise_application_error(-20321,v_scriptName ||' BLOCK 121 FAILED');
	END;
	v_logStatus := LogUpdate(121);
		
	v_logStatus := LogInsert(122,'Adding new column VarFieldIdFrom in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdFrom');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(122);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdFrom INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdFrom = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdFrom');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(122);   
			raise_application_error(-20322,v_scriptName ||' BLOCK 122 FAILED');
	END;
	v_logStatus := LogUpdate(122);
		
	v_logStatus := LogInsert(123,'Adding new column VariableIdCc in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdCc');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(123);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdCc INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdCc = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdCc');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(123);   
			raise_application_error(-20323,v_scriptName ||' BLOCK 123 FAILED');
	END;
	v_logStatus := LogUpdate(123);
		
	v_logStatus := LogInsert(124,'Adding new column VarFieldIdCc in MailTriggerTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MailTriggerTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdCc');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(124);
				EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdCc INT';
				EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdCc = 0';
				DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdCc');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(124);   
			raise_application_error(-20324,v_scriptName ||' BLOCK 124 FAILED');
	END;
	v_logStatus := LogUpdate(124);
		
	v_logStatus := LogInsert(125,'Adding new column VariableIdTo in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdTo');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(125);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdTo INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdTo = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdTo');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(125);   
			raise_application_error(-20325,v_scriptName ||' BLOCK 125 FAILED');
	END;
	v_logStatus := LogUpdate(125);
		
	v_logStatus := LogInsert(126,'Adding new column VarFieldIdTo in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdTo');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(126);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdTo INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdTo = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdTo');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(126);   
			raise_application_error(-20326,v_scriptName ||' BLOCK 126 FAILED');
	END;
	v_logStatus := LogUpdate(126);
		
	v_logStatus := LogInsert(127,'Adding new column VariableIdFrom in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdFrom');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(127);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdFrom INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdFrom = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdFrom');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(127);   
			raise_application_error(-20327,v_scriptName ||' BLOCK 127 FAILED');
	END;
	v_logStatus := LogUpdate(127);
		
	v_logStatus := LogInsert(128,'Adding new column VarFieldIdFrom in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdFrom');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(128);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdFrom INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdFrom = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdFrom');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(128);   
			raise_application_error(-20328,v_scriptName ||' BLOCK 128 FAILED');
	END;
	v_logStatus := LogUpdate(128);
		
	v_logStatus := LogInsert(129,'Adding new column VariableIdCc in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdCc');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(129);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdCc INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdCc = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdCc');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(129);   
			raise_application_error(-20329,v_scriptName ||' BLOCK 129 FAILED');
	END;
	v_logStatus := LogUpdate(129);
		
	v_logStatus := LogInsert(130,'Adding new column VarFieldIdCc in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdCc');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(130);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdCc INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdCc = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdCc');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(130);   
			raise_application_error(-20330,v_scriptName ||' BLOCK 130 FAILED');
	END;
	v_logStatus := LogUpdate(130);
		
	v_logStatus := LogInsert(131,'Adding new column VariableIdFax in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VariableIdFax');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(131);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdFax INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdFax = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdFax');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(131);   
			raise_application_error(-20331,v_scriptName ||' BLOCK 131 FAILED');
	END;
	v_logStatus := LogUpdate(131);
		
	v_logStatus := LogInsert(132,'Adding new column VarFieldIdFax in PrintFaxEmailTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldIdFax');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(132);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdFax INT';
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdFax = 0';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdFax');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(132);   
			raise_application_error(-20332,v_scriptName ||' BLOCK 132 FAILED');
	END;
	v_logStatus := LogUpdate(132);
		
	v_logStatus := LogInsert(133,'Adding new column ImportedVariableId in InitiateWorkItemDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
			AND 
			COLUMN_NAME=UPPER('ImportedVariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(133);
				EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add ImportedVariableId INT';
				EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET ImportedVariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column ImportedVariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(133);   
			raise_application_error(-20333,v_scriptName ||' BLOCK 133 FAILED');
	END;
	v_logStatus := LogUpdate(133);
		
	v_logStatus := LogInsert(134,'Adding new column ImportedVarFieldId in InitiateWorkItemDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
			AND 
			COLUMN_NAME=UPPER('ImportedVarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(134);
				EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add ImportedVarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET ImportedVarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column ImportedVarFieldId');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(134);   
			raise_application_error(-20334,v_scriptName ||' BLOCK 134 FAILED');
	END;
	v_logStatus := LogUpdate(134);
		
	v_logStatus := LogInsert(135,'Adding new column MappedVariableId in InitiateWorkItemDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
			AND 
			COLUMN_NAME=UPPER('MappedVariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(135);
				EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add MappedVariableId INT';
				EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET MappedVariableId = 0';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column MappedVariableId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(135);   
			raise_application_error(-20335,v_scriptName ||' BLOCK 135 FAILED');
	END;
	v_logStatus := LogUpdate(135);
		
	v_logStatus := LogInsert(136,'Adding new column MappedVarFieldId in InitiateWorkItemDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
			AND 
			COLUMN_NAME=UPPER('MappedVarFieldId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(136);
				EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add MappedVarFieldId INT';
				EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET MappedVarFieldId = 0';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column MappedVarFieldId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(136);   
			raise_application_error(-20336,v_scriptName ||' BLOCK 136 FAILED');
	END;
	v_logStatus := LogUpdate(136);
		
	v_logStatus := LogInsert(137,'Adding new column DisplayName in InitiateWorkItemDefTable');
	BEGIN
		/* Added By Ishu Saraf On 21/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
			AND 
			COLUMN_NAME=UPPER('DisplayName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(137);
				EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add DisplayName NVARCHAR2(2000)';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column DisplayName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(137);   
			raise_application_error(-20337,v_scriptName ||' BLOCK 137 FAILED');
	END;
	v_logStatus := LogUpdate(137);	
		
	v_logStatus := LogInsert(138,'Adding new column WFYears in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('WFYears');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(138);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFYears NVARCHAR2(256)';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFYears = NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFYears');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(138);   
			raise_application_error(-20338,v_scriptName ||' BLOCK 138 FAILED');
	END;
	v_logStatus := LogUpdate(138);
		
	v_logStatus := LogInsert(139,'Adding new column WFMonths in WFDurationTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('WFMonths');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(139);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFMonths NVARCHAR2(256)';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFMonths = NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFMonths');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(139);   
			raise_application_error(-20339,v_scriptName ||' BLOCK 139 FAILED');
	END;
	v_logStatus := LogUpdate(139);	
		
	v_logStatus := LogInsert(140,'Adding new column WFSeconds in WFDurationTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('WFSeconds');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(140);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFSeconds NVARCHAR2(256)';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFSeconds = NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFSeconds');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(140);   
			raise_application_error(-20340,v_scriptName ||' BLOCK 140 FAILED');
	END;
	v_logStatus := LogUpdate(140);	
		
	v_logStatus := LogInsert(141,'Adding new column VariableId_Years in WFDurationTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Years');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(141);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Years INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Years = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Years');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(141);   
			raise_application_error(-20341,v_scriptName ||' BLOCK 141 FAILED');
	END;
	v_logStatus := LogUpdate(141);	
		
	v_logStatus := LogInsert(142,'Adding new column VarFieldId_Years in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Years');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(142);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Years INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Years = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Years');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(142);   
			raise_application_error(-20342,v_scriptName ||' BLOCK 142 FAILED');
	END;
	v_logStatus := LogUpdate(142);
		
	v_logStatus := LogInsert(143,'Adding new column VariableId_Months in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Months');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(143);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Months INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Months = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Months');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(143);   
			raise_application_error(-20343,v_scriptName ||' BLOCK 143 FAILED');
	END;
	v_logStatus := LogUpdate(143);
		
	v_logStatus := LogInsert(144,'Adding new column VarFieldId_Months in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Months');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(144);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Months INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Months = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Months');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(144);   
			raise_application_error(-20344,v_scriptName ||' BLOCK 144 FAILED');
	END;
	v_logStatus := LogUpdate(144);
		
	v_logStatus := LogInsert(145,'Adding new column VariableId_Days in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Days');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(145);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Days INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Days = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Days');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(145);   
			raise_application_error(-20345,v_scriptName ||' BLOCK 145 FAILED');
	END;
	v_logStatus := LogUpdate(145);
		
	v_logStatus := LogInsert(146,'Adding new column VarFieldId_Days in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Days');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(146);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Days INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Days = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Days');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(146);   
			raise_application_error(-20346,v_scriptName ||' BLOCK 146 FAILED');
	END;
	v_logStatus := LogUpdate(146);
		
	v_logStatus := LogInsert(147,'Adding new column VariableId_Hours in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Hours');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(147);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Hours INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Hours = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Hours');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(147);   
			raise_application_error(-20347,v_scriptName ||' BLOCK 147 FAILED');
	END;
	v_logStatus := LogUpdate(147);
		
	v_logStatus := LogInsert(148,'Adding new column VarFieldId_Hours in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Hours');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(148);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Hours INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Hours = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Hours');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(148);   
			raise_application_error(-20348,v_scriptName ||' BLOCK 148 FAILED');
	END;
	v_logStatus := LogUpdate(148);
		
	v_logStatus := LogInsert(149,'Adding new column VariableId_Minutes in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Minutes');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(149);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Minutes INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Minutes = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Minutes');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(149);   
			raise_application_error(-20349,v_scriptName ||' BLOCK 149 FAILED');
	END;
	v_logStatus := LogUpdate(149);
		
	v_logStatus := LogInsert(150,'Adding new column VarFieldId_Minutes in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Minutes');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(150);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Minutes INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Minutes = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Minutes');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(150);   
			raise_application_error(-20350,v_scriptName ||' BLOCK 150 FAILED');
	END;
	v_logStatus := LogUpdate(150);
		
	v_logStatus := LogInsert(151,'Adding new column VariableId_Seconds in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId_Seconds');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(151);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Seconds INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Seconds = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Seconds');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(151);   
			raise_application_error(-20351,v_scriptName ||' BLOCK 151 FAILED');
	END;
	v_logStatus := LogUpdate(151);
		
	v_logStatus := LogInsert(152,'Adding new column VarFieldId_Seconds in WFDurationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDurationTable') 
			AND 
			COLUMN_NAME=UPPER('VarFieldId_Seconds');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(152);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Seconds INT';
				EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Seconds = 0';
				DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Seconds');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(152);   
			raise_application_error(-20352,v_scriptName ||' BLOCK 152 FAILED');
	END;
	v_logStatus := LogUpdate(152);
		
	v_logStatus := LogInsert(153,'CREATE TABLE WFSAPGUIDefTable');
	BEGIN
		/* Added By Ananta Handoo on 22/04/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(153);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIDefTable (
					ProcessDefId		INT					NOT NULL,
					DefinitionId		INT					NOT NULL,
					DefinitionName		NVARCHAR2(256)		NOT NULL,
					SAPTCode			NVARCHAR2(64)		NOT NULL,
					TCodeType			NVARCHAR2(1)	NOT NULL,
					VariableId			INT				NULL,
					VarFieldId			INT				NULL,
					PRIMARY KEY (ProcessDefId, DefinitionId)
				)';
			dbms_output.put_line ('Table WFSAPGUIDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(153);   
			raise_application_error(-20353,v_scriptName ||' BLOCK 153 FAILED');
	END;
	v_logStatus := LogUpdate(153);
		
	v_logStatus := LogInsert(154,'CREATE TABLE WFSAPGUIFieldMappingTable');
	BEGIN
		 /* Added By Ananta Handoo on 22/04/2009 */

			BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIFieldMappingTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(154);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIFieldMappingTable (
					ProcessDefId		INT				NOT NULL,
					DefinitionId		INT				NOT NULL,
					SAPFieldName		NVARCHAR2(512)	                NOT NULL,
					MappedFieldName		NVARCHAR2(256)	                NOT NULL,
					MappedFieldType		NVARCHAR2(1)	                CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
					VariableId		INT				NULL,
					VarFieldId		INT				NULL
				)';
			dbms_output.put_line ('Table WFSAPGUIFieldMappingTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(154);   
			raise_application_error(-20354,v_scriptName ||' BLOCK 154 FAILED');
	END;
	v_logStatus := LogUpdate(154);
		   
	v_logStatus := LogInsert(155,'CREATE TABLE WFSAPGUIAssocTable');
	BEGIN
		/* Added By Ananta Handoo on 22/04/2009 */

		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(155);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIAssocTable (
					ProcessDefId		INT				NOT NULL,
					ActivityId		INT				NOT NULL,
					DefinitionId		INT				NOT NULL,
					Coordinates             NVARCHAR2(255)                  NULL, 
					CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
				)';
			dbms_output.put_line ('Table WFSAPGUIAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(155);   
			raise_application_error(-20355,v_scriptName ||' BLOCK 155 FAILED');
	END;
	v_logStatus := LogUpdate(155);
		
	v_logStatus := LogInsert(156,'CREATE TABLE WFSAPAdapterAssocTable');
	BEGIN
		/* Added By Ananta Handoo on 22/04/2009 */

		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(156);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPAdapterAssocTable (
					ProcessDefId		INT				 NULL,
					ActivityId		INT				 NULL,
					EXTMETHODINDEX		INT				 NULL
				)';
			dbms_output.put_line ('Table WFSAPAdapterAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(156);   
			raise_application_error(-20356,v_scriptName ||' BLOCK 156 FAILED');
	END;
	v_logStatus := LogUpdate(156);
		
	v_logStatus := LogInsert(157,'Making Variable Update Attempt');
	BEGIN
		IF(v_isVariableIDUpdateRequired=1)
		
		THEN
		--Variableid updation Block
			BEGIN
				v_logStatus := LogSkip(157);
				DECLARE
				CURSOR cursor1 IS SELECT ProcessDefId FROM ProcessDefTable;
				BEGIN
					OPEN cursor1;
					LOOP
						FETCH cursor1 INTO v_processDefId;
						EXIT WHEN cursor1%NOTFOUND;
						BEGIN
							v_count := 1;
							v_StartPos := 1;
							v_EndPos := -1;
							WHILE v_EndPos != 0
							LOOP
								v_EndPos := INSTR(v_SysString, ',' , v_startpos);   
								IF v_EndPos != 0 THEN
									v_length := v_EndPos - v_StartPos;
								ELSE 
									v_length := LENGTH(v_SysString);
								END IF;
								v_string := SUBSTR(v_SysString, v_StartPos, v_length);
								BEGIN
								EXECUTE IMMEDIATE 'SELECT UserDefinedName FROM VarMappingTable ' ||
												  'WHERE ProcessDefid = ' || TO_CHAR(v_ProcessDefId)  ||
												  'AND VariableId = 0 AND SystemDefinedName = N''' || v_string || '''' INTO v_userDefinedName;
								sqlcount := SQL%ROWCOUNT;
								EXCEPTION 
									WHEN NO_DATA_FOUND THEN
										sqlcount := -1;
								END;
								IF(SQL%ROWCOUNT > 0) THEN
								BEGIN 
									v_STR2 := ' UPDATE VarMappingTable SET VariableId = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and SystemDefinedName = N''' || v_string || '''' ;
									v_STR3 := ' UPDATE ActivityAssociationTable SET VariableId = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and FieldName = N''' || v_userDefinedName || '''';
									v_STR4 := ' UPDATE RuleOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
									v_STR5 := ' UPDATE RuleOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR6 := ' UPDATE RuleOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
									v_STR7 := ' UPDATE RuleConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
									v_STR8 := ' UPDATE RuleConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR9 := ' UPDATE ExtMethodParamMappingTable SET VariableId = ' || TO_CHAR(v_count) ||
											  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											  ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' ||
											  ' and MappedField = N''' || v_userDefinedName || '''';
									v_STR10 := ' UPDATE ActionOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
									v_STR11 := ' UPDATE ActionOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR12 := ' UPDATE ActionOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
									v_STR13 := ' UPDATE ActionConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
									v_STR14 := ' UPDATE ActionConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR15	:= ' UPDATE DataSetTriggerTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Param1 = N''' || v_userDefinedName || '''';
									v_STR16	:= ' UPDATE DataSetTriggerTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR17	:= ' UPDATE ScanActionsTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Param1 = N''' || v_userDefinedName || '''';
									v_STR18	:= ' UPDATE ScanActionsTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR19	:= ' UPDATE WFDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and DocTypeDefId = 0 and MappedFieldName = N''' || v_userDefinedName || '''';
									v_STR20	:= ' UPDATE DataEntryTriggerTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and VariableName = N''' || v_userDefinedName || '''';
									v_STR21	:= ' UPDATE ArchiveDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and AssocVar = N''' || v_userDefinedName || '''';
									v_STR22	:= ' UPDATE WFJMSSubscribeTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and processVariableName = N''' || v_userDefinedName || '''';
									v_STR23	:= ' UPDATE ToDoListDefTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and AssociatedField = N''' || v_userDefinedName || '''';
									v_STR24	:= ' UPDATE MailTriggerTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and ToType != N''C'' and ToUser = N''' || v_userDefinedName || '''';
									v_STR25	:= ' UPDATE MailTriggerTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FromUserType != N''C'' and FromUser = N''' || v_userDefinedName || '''';
									v_STR26	:= ' UPDATE MailTriggerTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and CCType != N''C'' and CCUser = N''' || v_userDefinedName || '''';
									v_STR27	:= ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and ToMailIdType != N''C'' and ToMailId = N''' || v_userDefinedName || '''';
									v_STR28	:= ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and SenderMailIdType != N''C'' and SenderMailId = N''' || v_userDefinedName || '''';
									v_STR29	:= ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and CCMailIdType != N''C'' and CCMailId = N''' || v_userDefinedName || '''';
									v_STR30	:= ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FaxNoType != N''C'' and FaxNo = N''' || v_userDefinedName || '''';
									v_STR31	:= ' UPDATE ImportedProcessDefTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
									v_STR32	:= ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
									v_STR33	:= ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and MappedFieldName = N''' || v_userDefinedName || '''';	
									v_STR34	:=	'UPDATE WFDurationTable SET VariableId_Years = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFYears = N''' || v_userDefinedName || '''';	
									v_STR35	:=	'UPDATE WFDurationTable SET VariableId_Months = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFMonths = N''' || v_userDefinedName || '''';	
									v_STR36	:=	'UPDATE WFDurationTable SET VariableId_Days = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFDays = N''' || v_userDefinedName || '''';	
									v_STR37	:=	'UPDATE WFDurationTable SET VariableId_Hours = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFHours = N''' || v_userDefinedName || '''';	
									v_STR38	:=	'UPDATE WFDurationTable SET VariableId_Minutes = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFMinutes = N''' || v_userDefinedName || '''';	
									v_STR39	:=	'UPDATE WFDurationTable SET VariableId_Seconds = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFSeconds = N''' || v_userDefinedName || '''';	
									SAVEPOINT var_id1;
									EXECUTE IMMEDIATE v_str2;
									IF(v_UserDefinedName IS NOT NULL) THEN
									BEGIN
										EXECUTE IMMEDIATE v_str3;
										EXECUTE IMMEDIATE v_str4;
										EXECUTE IMMEDIATE v_str5;
										EXECUTE IMMEDIATE v_str6;
										EXECUTE IMMEDIATE v_str7;
										EXECUTE IMMEDIATE v_str8;
										EXECUTE IMMEDIATE v_str9;
										EXECUTE IMMEDIATE v_str10;
										EXECUTE IMMEDIATE v_str11;
										EXECUTE IMMEDIATE v_str12;
										EXECUTE IMMEDIATE v_str13;
										EXECUTE IMMEDIATE v_str14;
										EXECUTE IMMEDIATE v_str15;
										EXECUTE IMMEDIATE v_str16;
										EXECUTE IMMEDIATE v_str17;
										EXECUTE IMMEDIATE v_str18;
										EXECUTE IMMEDIATE v_str19;
										EXECUTE IMMEDIATE v_str20;
										EXECUTE IMMEDIATE v_str21;
										EXECUTE IMMEDIATE v_str22;
										EXECUTE IMMEDIATE v_str23;
										EXECUTE IMMEDIATE v_str24;
										EXECUTE IMMEDIATE v_str25;
										EXECUTE IMMEDIATE v_str26;
										EXECUTE IMMEDIATE v_str27;
										EXECUTE IMMEDIATE v_str28;
										EXECUTE IMMEDIATE v_str29;
										EXECUTE IMMEDIATE v_str30;
										EXECUTE IMMEDIATE v_str31;
										EXECUTE IMMEDIATE v_str32;
										EXECUTE IMMEDIATE v_str33;
										EXECUTE IMMEDIATE v_str34;
										EXECUTE IMMEDIATE v_str35;
										EXECUTE IMMEDIATE v_str36;
										EXECUTE IMMEDIATE v_str37;
										EXECUTE IMMEDIATE v_str38;
										EXECUTE IMMEDIATE v_str39;
										COMMIT;
									EXCEPTION WHEN OTHERS THEN 
									BEGIN
										dbms_output.put_line('SQLCODE: '||SQLCODE);
										dbms_output.put_line('Message: '||SQLERRM);

										DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to var_id1');
										ROLLBACK TO SAVEPOINT var_id1;
									END;
									END;
									--ELSE
										--DBMS_OUTPUT.PUT_LINE('UserDefinedName is null');
									END IF;
								END;
								ELSE
									DBMS_OUTPUT.PUT_LINE('no value for userDefinedName');
								END IF;
								v_StartPos := v_EndPos + 1; 
								v_count := v_count + 1;
							END LOOP;

						DECLARE
						CURSOR cursor2 IS SELECT UserDefinedName INTO v_userDefinedName FROM VarmappingTable WHERE processdefid = v_processdefid AND ExtObjId = 1;
						BEGIN
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_userDefinedName;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_STR40 := 'UPDATE VarmappingTable SET VariableId = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId =' || TO_CHAR(v_ProcessDefId) ||
											   ' and ExtObjId = 1 and UPPER(RTRIM(UserDefinedName)) = N''' || UPPER(RTRIM(v_userDefinedName)) || '''' ||
											   ' and VariableId = 0';
									v_STR41 := 'UPDATE ActivityAssociationTable SET VariableId = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefid= ' || TO_CHAR(v_ProcessDefId) ||
											   ' and ExtObjId = 1 and FieldName = N''' || v_userDefinedName || '''' ||
											   ' and VariableId = 0';
									v_STR42 := ' UPDATE RuleOperationTable SET VariableId_1 = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) ' ||
											   ' and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || '''' ;
									v_STR43 := ' UPDATE RuleOperationTable SET VariableId_2 = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) ' ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''' ;
									v_STR44 := ' UPDATE RuleOperationTable SET VariableId_3 = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24) ' ||
											   ' and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''' ;
									v_STR45 := ' UPDATE RuleConditionTable SET VariableId_1 = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type1 != N''C'' and Type1 != N''S''' ||
											   ' and Param1 = N''' || v_userDefinedName || '''' ;
									v_STR46 := ' UPDATE RuleConditionTable SET VariableId_2 = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Type2 != N''S'''  ||
											   ' and Param2 = N''' || v_userDefinedName || '''' ;
									v_STR47 := ' UPDATE ExtMethodParamMappingTable SET VariableId = ' ||  TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' ||
											   ' and MappedField = N''' || v_userDefinedName || '''' ;
									v_STR48 := ' UPDATE ActionOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24)' ||
											   ' and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
									v_STR49 := ' UPDATE ActionOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24)' ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR50 := ' UPDATE ActionOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and OperationType in (1, 18, 19, 23, 24)' ||
											   ' and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
									v_STR51 := ' UPDATE ActionConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
									v_STR52 := ' UPDATE ActionConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR53	:= ' UPDATE DataSetTriggerTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Param1 = N''' || v_userDefinedName || '''';
									v_STR54	:= ' UPDATE DataSetTriggerTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR55	:= ' UPDATE ScanActionsTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Param1 = N''' || v_userDefinedName || '''';
									v_STR56	:= ' UPDATE ScanActionsTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
									v_STR57	:= ' UPDATE WFDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and DocTypeDefId = 0 and MappedFieldName = N''' || v_userDefinedName || '''';
									v_STR58	:= ' UPDATE DataEntryTriggerTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and VariableName = N''' || v_userDefinedName || '''';
									v_STR59	:= ' UPDATE ArchiveDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and AssocVar = N''' || v_userDefinedName || '''';
									v_STR60	:= ' UPDATE WFJMSSubscribeTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and processVariableName = N''' || v_userDefinedName || '''';
									v_STR61	:= ' UPDATE ToDoListDefTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and AssociatedField = N''' || v_userDefinedName || '''';
									v_STR62	:= ' UPDATE MailTriggerTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and ToType != N''C'' and ToUser = N''' || v_userDefinedName || '''';
									v_STR63	:= ' UPDATE MailTriggerTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FromUserType != N''C'' and FromUser = N''' || v_userDefinedName || '''';
									v_STR64	:= ' UPDATE MailTriggerTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and CCType != N''C'' and CCUser = N''' || v_userDefinedName || '''';
									v_STR65	:= ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and ToMailIdType != N''C'' and ToMailId = N''' || v_userDefinedName || '''';
									v_STR66	:= ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and SenderMailIdType != N''C'' and SenderMailId = N''' || v_userDefinedName || '''';
									v_STR67	:= ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and CCMailIdType != N''C'' and CCMailId = N''' || v_userDefinedName || '''';
									v_STR68	:= ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FaxNoType != N''C'' and FaxNo = N''' || v_userDefinedName || '''';
									v_STR69	:= ' UPDATE ImportedProcessDefTable SET VariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
									v_STR70	:= ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
									v_STR71	:= ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and FieldType != N''D'' and MappedFieldName = N''' || v_userDefinedName || '''';
									v_STR72	:= 'UPDATE WFDurationTable SET VariableId_Years = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFYears = N''' || v_userDefinedName || '''';	
									v_STR73	:= 'UPDATE WFDurationTable SET VariableId_Months = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFMonths = N''' || v_userDefinedName || '''';	
									v_STR74	:= 'UPDATE WFDurationTable SET VariableId_Days = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFDays = N''' || v_userDefinedName || '''';	
									v_STR75	:= 'UPDATE WFDurationTable SET VariableId_Hours = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFHours = N''' || v_userDefinedName || '''';	
									v_STR76	:= 'UPDATE WFDurationTable SET VariableId_Minutes = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFMinutes = N''' || v_userDefinedName || '''';	
									v_STR77	:= 'UPDATE WFDurationTable SET VariableId_Seconds = ' || TO_CHAR(v_count) ||
											   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
											   ' and WFSeconds = N''' || v_userDefinedName || '''';	
									SAVEPOINT var_id2;
									
									EXECUTE IMMEDIATE v_str40;
									EXECUTE IMMEDIATE v_str41;
									EXECUTE IMMEDIATE v_str42;
									EXECUTE IMMEDIATE v_str43;
									EXECUTE IMMEDIATE v_str44;
									EXECUTE IMMEDIATE v_str45;
									EXECUTE IMMEDIATE v_str46;
									EXECUTE IMMEDIATE v_str47;
									EXECUTE IMMEDIATE v_str48;
									EXECUTE IMMEDIATE v_str49;
									EXECUTE IMMEDIATE v_str50;
									EXECUTE IMMEDIATE v_str51;
									EXECUTE IMMEDIATE v_str52;
									EXECUTE IMMEDIATE v_str53;
									EXECUTE IMMEDIATE v_str54;
									EXECUTE IMMEDIATE v_str55;
									EXECUTE IMMEDIATE v_str56;
									EXECUTE IMMEDIATE v_str57;
									EXECUTE IMMEDIATE v_str58;
									EXECUTE IMMEDIATE v_str59;
									EXECUTE IMMEDIATE v_str60;
									EXECUTE IMMEDIATE v_str61;
									EXECUTE IMMEDIATE v_str62;
									EXECUTE IMMEDIATE v_str63;
									EXECUTE IMMEDIATE v_str64;
									EXECUTE IMMEDIATE v_str65;
									EXECUTE IMMEDIATE v_str66;
									EXECUTE IMMEDIATE v_str67;
									EXECUTE IMMEDIATE v_str68;
									EXECUTE IMMEDIATE v_str69;
									EXECUTE IMMEDIATE v_str70;
									EXECUTE IMMEDIATE v_str71;
									EXECUTE IMMEDIATE v_str72;
									EXECUTE IMMEDIATE v_str73;
									EXECUTE IMMEDIATE v_str74;
									EXECUTE IMMEDIATE v_str75;
									EXECUTE IMMEDIATE v_str76;
									EXECUTE IMMEDIATE v_str77;
									COMMIT;
									v_count := v_count + 1;
									EXCEPTION WHEN OTHERS THEN 
									BEGIN
										DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to var_id2');
										ROLLBACK TO SAVEPOINT var_id2;
									END;	
									END;
							END LOOP;
							CLOSE cursor2;
							EXCEPTION WHEN OTHERS THEN
								IF cursor2%ISOPEN THEN
									CLOSE cursor2;
								END IF;
						END;
						END;
					END LOOP;
					CLOSE cursor1;
					EXCEPTION WHEN OTHERS THEN
						IF cursor1%ISOPEN THEN
							CLOSE cursor1;
						END IF;
				END;
			END;
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(157);   
			raise_application_error(-20357,v_scriptName ||' BLOCK 157 FAILED');
	END;
	v_logStatus := LogUpdate(157);
		
		
	v_logStatus := LogInsert(158,'Recreating VarMappingTable,and inserting value in WFCabVersionTable for 7.2_VarMappingTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			v_logStatus := LogSkip(158);
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_VarMappingTable' AND ROWNUM <= 1;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					existsflag := 0;
					BEGIN
						SELECT 1 INTO existsFlag FROM USER_CONSTRAINTS  WHERE TABLE_NAME = 'VARMAPPINGTABLE' AND CONSTRAINT_NAME = UPPER('CK_VarMappin_VarScope');
						EXCEPTION 
							WHEN NO_DATA_FOUND THEN 
								existsFlag := 0; 
					END;
					IF existsFlag = 1 THEN        
						EXECUTE IMMEDIATE 'Alter Table VarMappingTable DROP CONSTRAINT CK_VarMappin_VarScope';
					END IF;
				BEGIN
				existsflag := 0;
				BEGIN
					SELECT 1 INTO existsFlag FROM USER_CONSTRAINTS  WHERE TABLE_NAME = 'VARMAPPINGTABLE'  AND CONSTRAINT_TYPE = 'P';
					EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END;
				IF existsFlag = 1 THEN       
					EXECUTE IMMEDIATE 'Alter Table VarMappingTable DROP PRIMARY KEY';
				END IF;
				END;
				EXECUTE IMMEDIATE 'CREATE TABLE TempVarMappingTable AS Select ProcessDefId, VariableId, SystemDefinedName, UserDefinedName, VariableType, 
				VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded  From VarMappingTable
				where ProcessDefId In (Select ProcessDefId from ProcessDefTable)';
				EXECUTE IMMEDIATE 'Alter Table VarMappingTable rename to VarMappingTable_BKP';
				EXECUTE IMMEDIATE 
					'CREATE TABLE VarMappingTable (
						ProcessDefId		INT		NOT NULL,
						VariableId		INT 		NOT NULL ,
						SystemDefinedName	NVARCHAR2(50)	NOT NULL ,
						UserDefinedName		NVARCHAR2(50)	NULL ,
						VariableType		SMALLINT	NOT NULL ,
						variableScope		NVARCHAR2(1)	NOT NULL ,
						ExtObjId		INT		NULL ,
						DefaultValue		NVARCHAR2(255)	NULL ,
						VariableLength  	INT		NULL,
						VarPrecision		INT		NULL,
						Unbounded		NVARCHAR2(1) DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')) NOT NULL,
						CONSTRAINT CK_VarMappin_VarScope CHECK (VariableScope = N''M'' OR (VariableScope = N''I'' OR (VariableScope = N''U'' OR (VariableScope = N''S'')))),
						PRIMARY KEY(ProcessDefId,VariableId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table VarMappingTable Created successfully.....'	);
				SAVEPOINT save;
					  EXECUTE IMMEDIATE 'INSERT INTO VarMappingTable SELECT ProcessDefId, VariableId, SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded FROM TempVarMappingTable';
					  EXECUTE IMMEDIATE 'DROP TABLE TempVarMappingTable';
					  DBMS_OUTPUT.PUT_LINE ('Table TempVarMappingTable dropped successfully...........'	);
					  DBMS_OUTPUT.PUT_LINE ('Table VarMappingTable altered with new Column VariableId'	);
					  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_VarMappingTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(158);   
			raise_application_error(-20358,v_scriptName ||' BLOCK 158 FAILED');
	END;
	v_logStatus := LogUpdate(158);
		
	v_logStatus := LogInsert(159,'Recreating RuleOperationTable and inserting value in WFCabVersionTable for 7.2_RuleOperationTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleOperationTable' AND ROWNUM <= 1;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(159);
					EXECUTE IMMEDIATE 'Alter Table RuleOperationTable rename to TempRuleOperationTable';
					EXECUTE IMMEDIATE 
						'CREATE TABLE RuleOperationTable (
							ProcessDefId 	   	INT 				NOT NULL,
							ActivityId			INT       			NOT NULL ,
							RuleType            NVARCHAR2 (1)    	NOT NULL ,
							RuleId              SMALLINT       		NOT NULL ,
							OperationType       SMALLINT       		NOT NULL ,
							Param1              NVARCHAR2 (50)   	NOT NULL ,
							Type1               NVARCHAR2 (1)    	NOT NULL ,
							ExtObjID1	    	INT						NULL,
							VariableId_1		INT						NULL,
							VarFieldId_1		INT						NULL,
							Param2              NVARCHAR2 (255) 	NOT NULL ,
							Type2               NVARCHAR2 (1)    	NOT NULL ,
							ExtObjID2	    	INT						NULL,
							VariableId_2		INT						NULL,
							VarFieldId_2		INT						NULL,
							Param3				NVARCHAR2(255)			NULL,
							Type3				NVARCHAR2(1)			NULL,
							ExtObjId3			INT						NULL,
							VariableId_3		INT						NULL,
							VarFieldId_3		INT						NULL,
							Operator			SMALLINT			NOT NULL,		
							OperationOrderId    SMALLINT       		NOT NULL ,
							CommentFlag         NVARCHAR2 (1)    		NULL, 
							RuleCalFlag			NVARCHAR2(1)			NULL,
							FunctionType		NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL,
							PRIMARY KEY (ProcessDefId , ActivityId , RuleType , RuleId,OperationOrderId)
						)';
					DBMS_OUTPUT.PUT_LINE ('Table RuleOperationTable Created successfully.....'	);
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO RuleOperationTable SELECT ProcessDefId, ActivityId, RuleType, RuleId, OperationType, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Param3, Type3, ExtObjID3, VariableId_3, VarFieldId_3, Operator, OperationOrderId, CommentFlag, RuleCalFlag, FunctionType FROM TempRuleOperationTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempRuleOperationTable';
						DBMS_OUTPUT.PUT_LINE ('Table TempRuleOperationTable dropped successfully...........'	);
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleOperationTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
					COMMIT;
				END;	
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(159);   
			raise_application_error(-20359,v_scriptName ||' BLOCK 159 FAILED');
	END;
	v_logStatus := LogUpdate(159);
		
	v_logStatus := LogInsert(160,'Recreating RuleConditionTable and inserting value in WFCabVersionTable for 7.2_RuleConditionTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleConditionTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(160);
					EXECUTE IMMEDIATE 'Alter table RuleConditionTable rename to TempRuleConditionTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE RuleConditionTable (
							ProcessDefId 		INT				NOT NULL,
							ActivityId			INT				NOT NULL ,
							RuleType			NVARCHAR2 (1)   NOT NULL ,
							RuleOrderId			SMALLINT		NOT NULL ,
							RuleId				SMALLINT		NOT NULL ,
							ConditionOrderId	SMALLINT		NOT NULL ,
							Param1				NVARCHAR2 (50)	NOT NULL ,
							Type1				NVARCHAR2 (1)	NOT NULL ,
							ExtObjID1			INT					NULL,
							VariableId_1		INT					NULL,
							VarFieldId_1		INT					NULL,
							Param2				NVARCHAR2 (255) NOT NULL ,
							Type2				NVARCHAR2 (1)	NOT NULL ,
							ExtObjID2			INT					NULL,
							VariableId_2		INT					NULL,
							VarFieldId_2		INT					NULL,
							Operator			SMALLINT		NOT NULL ,
							LogicalOp			SMALLINT		NOT NULL 
						)';
					DBMS_OUTPUT.PUT_LINE ('Table RuleConditionTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO RuleConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempRuleConditionTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempRuleConditionTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleConditionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ('Table TempRuleConditionTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(160);   
			raise_application_error(-20360,v_scriptName ||' BLOCK 160 FAILED');
	END;
	v_logStatus := LogUpdate(160);
		
	v_logStatus := LogInsert(161,'Recreating ExtMethodParamMappingTable and inserting value in WFCabVersionTable for 7.2_ExtMethodParamMappingTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ExtMethodParamMappingTable' AND ROWNUM <= 1; /* check entry in WFCabVersionTable */ 
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(161);
					EXECUTE IMMEDIATE 'Alter Table ExtMethodParamMappingTable rename to TempExtMethodParamMappingTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE ExtMethodParamMappingTable (
							ProcessDefId			INTEGER		NOT NULL , 
							ActivityId				INTEGER		NOT NULL ,
							RuleId					INTEGER		NOT NULL ,
							RuleOperationOrderId	SMALLINT	NOT NULL ,
							ExtMethodIndex			INTEGER		NOT NULL ,
							MapType					NVARCHAR2(1)	CHECK (MapType in (N''F'',N''R'')),
							ExtMethodParamIndex		Integer		NOT NULL ,
							MappedField				NVARCHAR2(255) ,
							MappedFieldType			NVARCHAR2(1)	CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
							VariableId				INT,
							VarFieldId				INT,
							DataStructureId			INTEGER
						)';
					DBMS_OUTPUT.PUT_LINE ('Table ExtMethodParamMappingTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamMappingTable SELECT ProcessDefId, ActivityId, RuleId, RuleOperationOrderId, ExtMethodIndex, MapType, ExtMethodParamIndex, MappedField, MappedFieldType, VariableId, VarFieldId, DataStructureId FROM TempExtMethodParamMappingTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempExtMethodParamMappingTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ExtMethodParamMappingTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
					COMMIT; 
					DBMS_OUTPUT.PUT_LINE ('Table TempExtMethodParamMappingTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(161);   
			raise_application_error(-20361,v_scriptName ||' BLOCK 161 FAILED');
	END;
	v_logStatus := LogUpdate(161);
		
	v_logStatus := LogInsert(162,'Recreating ActionConditionTable and inserting value in WFCabVersionTable for 7.2_ActionConditionTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ActionConditionTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(162);
					EXECUTE IMMEDIATE 'Alter Table ActionConditionTable rename to TempActionConditionTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE ActionConditionTable (
							ProcessDefId            INT             NOT NULL,
							ActivityId              INT             NOT NULL,
							RuleType                NVARCHAR2(1)    NOT NULL,
							RuleOrderId             INT             NOT NULL,
							RuleId                  INT             NOT NULL,
							ConditionOrderId        INT             NOT NULL,
							Param1                  NVARCHAR2(50)   NOT NULL,
							Type1                   NVARCHAR2(1)    NOT NULL,
							ExtObjID1               INT					NULL,
							VariableId_1			INT					NULL,
							VarFieldId_1			INT					NULL,
							Param2                  NVARCHAR2(255)  NOT NULL,
							Type2                   NVARCHAR2(1)    NOT NULL,
							ExtObjID2               INT					NULL,
							VariableId_2			INT					NULL,
							VarFieldId_2			INT					NULL,
							Operator                INT             NOT NULL,
							LogicalOp               INT             NOT NULL
						)';
					DBMS_OUTPUT.PUT_LINE ('Table ActionConditionTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO ActionConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempActionConditionTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempActionConditionTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ActionConditionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ('Table TempActionConditionTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(162);   
			raise_application_error(-20362,v_scriptName ||' BLOCK 162 FAILED');
	END;
	v_logStatus := LogUpdate(162);
		
	v_logStatus := LogInsert(163,'Recreating DataSetTriggerTable and inserting value in WFCabVersionTable for 7.2_DataSetTriggerTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_DataSetTriggerTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(163);
					EXECUTE IMMEDIATE 'Alter Table DataSetTriggerTable rename to TempDataSetTriggerTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE DataSetTriggerTable (
							ProcessDefId 		INT 			NOT NULL,
							TriggerID 			SMALLINT 		NOT NULL,
							Param1				NVARCHAR2(50) 	NOT NULL,
							Type1				NVARCHAR2(1)	NOT NULL,
							ExtObjID1			INT					NULL,
							VariableId_1		INT					NULL,
							VarFieldId_1		INT					NULL,
							Param2				NVARCHAR2(255) 	NOT NULL,
							Type2				NVARCHAR2(1)	NOT NULL,
							ExtObjID2			INT					NULL,
							VariableId_2		INT					NULL,
							VarFieldId_2		INT					NULL
						)';
					DBMS_OUTPUT.PUT_LINE ( 'Table DataSetTriggerTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO DataSetTriggerTable SELECT ProcessDefId, TriggerID, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2 FROM TempDataSetTriggerTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempDataSetTriggerTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_DataSetTriggerTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ( 'Table TempDataSetTriggerTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(163);   
			raise_application_error(-20363,v_scriptName ||' BLOCK 163 FAILED');
	END;
	v_logStatus := LogUpdate(163);
		
	v_logStatus := LogInsert(164,'Recreating PrintFaxEmailTable and inserting value in WFCabVersionTable for 7.2_PrintFaxEmailTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_PrintFaxEmailTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(164);
					EXECUTE IMMEDIATE 'Alter Table PrintFaxEmailTable rename to TempPrintFaxEmailTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE PrintFaxEmailTable (
							ProcessDefId            INT			NOT NULL,
							PFEInterfaceId          INT			NOT NULL,
							InstrumentData          NVARCHAR2(1)    NULL,
							FitToPage               NVARCHAR2(1)    NULL,
							Annotations             NVARCHAR2(1)    NULL,
							FaxNo                   NVARCHAR2(255)  NULL,
							FaxNoType               NVARCHAR2(1)    NULL,
							ExtFaxNoId              INT				NULL,
							VariableIdFax			INT				NULL,
							VarFieldIdFax			INT				NULL,
							CoverSheet              NVARCHAR2(50)   NULL,
							CoverSheetBuffer        BLOB			NULL,
							ToUser                  NVARCHAR2(255)  NULL,
							FromUser                NVARCHAR2(255)  NULL,
							ToMailId                NVARCHAR2(255)  NULL,
							ToMailIdType            NVARCHAR2(1)    NULL,
							ExtToMailId             INT				NULL,
							VariableIdTo			INT				NULL,
							VarFieldIdTo			INT				NULL,
							CCMailId                NVARCHAR2(255)  NULL,
							CCMailIdType            NVARCHAR2(1)    NULL,
							ExtCCMailId             INT				NULL,
							VariableIdCc			INT				NULL,
							VarFieldIdCc			INT				NULL,
							SenderMailId            NVARCHAR2(255)  NULL,
							SenderMailIdType        NVARCHAR2(1)    NULL,
							ExtSenderMailId         INT				NULL,
							VariableIdFrom			INT				NULL,
							VarFieldIdFrom			INT				NULL,
							Message                 NVARCHAR2(2000) NULL,
							Subject                 NVARCHAR2(255)  NULL
						)';
					DBMS_OUTPUT.PUT_LINE ( 'Table PrintFaxEmailTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO PrintFaxEmailTable SELECT ProcessDefId, PFEInterfaceId, InstrumentData, FitToPage, Annotations, FaxNo, FaxNoType, ExtFaxNoId, VariableIdFax, VarFieldIdFax, CoverSheet, CoverSheetBuffer, ToUser, FromUser, ToMailId, ToMailIdType, ExtToMailId, VariableIdTo, VarFieldIdTo, CCMailId, CCMailIdType, ExtCCMailId, VariableIdCc, VarFieldIdCc, SenderMailId, SenderMailIdType, ExtSenderMailId, VariableIdFrom, VarFieldIdFrom, Message, Subject FROM TempPrintFaxEmailTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempPrintFaxEmailTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_PrintFaxEmailTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ( 'Table TempPrintFaxEmailTable dropped successfully...........');	
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(164);   
			raise_application_error(-20364,v_scriptName ||' BLOCK 164 FAILED');
	END;
	v_logStatus := LogUpdate(164);
		
	v_logStatus := LogInsert(165,'Recreating ScanActionsTable and inserting value in WFCabVersionTable for 7.2_ScanActionsTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ScanActionsTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(165);
					EXECUTE IMMEDIATE 'Alter Table ScanActionsTable rename to TempScanActionsTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE ScanActionsTable (
							ProcessDefId	INT             NOT NULL,
							DocTypeId		INT             NOT NULL,
							ActivityId		INT             NOT NULL,
							Param1			NVARCHAR2(50)   NOT NULL,
							Type1			NVARCHAR2(1)    NOT NULL,
							ExtObjId1		INT             NOT NULL,
							VariableId_1	INT					NULL,
							VarFieldId_1	INT					NULL,
							Param2			NVARCHAR2(255)  NOT NULL,
							Type2			NVARCHAR2(1)    NOT NULL,
							ExtObjId2		INT             NOT NULL,
							VariableId_2	INT					NULL,
							VarFieldId_2	INT					NULL
						)';
					DBMS_OUTPUT.PUT_LINE ( 'Table ScanActionsTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO ScanActionsTable SELECT ProcessDefId, DocTypeId, ActivityId, Param1, Type1, ExtObjId1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjId2, VariableId_2, VarFieldId_2 FROM TempScanActionsTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempScanActionsTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ScanActionsTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ( 'Table TempScanActionsTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(165);   
			raise_application_error(-20365,v_scriptName ||' BLOCK 165 FAILED');
	END;
	v_logStatus := LogUpdate(165);
		
	v_logStatus := LogInsert(166,'Recreating ToDoListDefTable and inserting value in WFCabVersionTable for 7.2_ToDoListDefTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion  FROM WFCabVersionTable WHERE CabVersion = '7.2_ToDoListDefTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(166);
					EXECUTE IMMEDIATE 'Alter Table ToDoListDefTable rename to TempToDoListDefTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE ToDoListDefTable (
							ProcessDefId	INTEGER				NOT NULL,
							ToDoId			INTEGER				NOT NULL,
							ToDoName		NVARCHAR2(255)		NOT NULL,
							Description		NVARCHAR2(255)		NOT NULL,
							Mandatory		NVARCHAR2(1)		NOT NULL,
							ViewType		NVARCHAR2(1)			NULL,
							AssociatedField	NVARCHAR2(255)			NULL,
							ExtObjID		INTEGER					NULL,
							VariableId		INTEGER					NULL,
							VarFieldId		INTEGER					NULL,
							TriggerName		NVARCHAR2(50)			NULL
						)';
					DBMS_OUTPUT.PUT_LINE ( 'Table ToDoListDefTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO ToDoListDefTable SELECT ProcessDefId, ToDoId, ToDoName, Description, Mandatory, ViewType, AssociatedField, ExtObjID, VariableId, VarFieldId, TriggerName FROM TempToDoListDefTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempToDoListDefTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ToDoListDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ( 'Table TempToDoListDefTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(166);   
			raise_application_error(-20366,v_scriptName ||' BLOCK 166 FAILED');
	END;
	v_logStatus := LogUpdate(166);
		
	v_logStatus := LogInsert(167,'Recreating ImportedProcessDefTable and inserting value in WFCabVersionTable for 7.2_ImportedProcessDefTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ImportedProcessDefTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(167);
					EXECUTE IMMEDIATE 'Alter Table ImportedProcessDefTable rename to TempImportedProcessDefTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE ImportedProcessDefTable (
							ProcessDefID 		INT 			NOT NULL ,
							ActivityId			INT				NOT NULL ,
							ImportedProcessName NVARCHAR2(30)	NOT NULL ,
							ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
							FieldDataType		INT					NULL ,	
							FieldType			NVARCHAR2(1)	NOT NULL,
							VariableId			INT					NULL,
							VarFieldId			INT					NULL,
							DisplayName			NVARCHAR2(2000)	    NULL
						)';
					DBMS_OUTPUT.PUT_LINE ( 'Table ImportedProcessDefTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO ImportedProcessDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, FieldDataType, FieldType, VariableId, VarFieldId, DisplayName FROM TempImportedProcessDefTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempImportedProcessDefTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ImportedProcessDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE ( 'Table TempImportedProcessDefTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(167);   
			raise_application_error(-20367,v_scriptName ||' BLOCK 167 FAILED');
	END;
	v_logStatus := LogUpdate(167);
		
	v_logStatus := LogInsert(168,'Recreating ImportedProcessDefTable and inserting value in WFCabVersionTable for 7.2_InitiateWorkitemDefTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_InitiateWorkitemDefTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					v_logStatus := LogSkip(168);
					EXECUTE IMMEDIATE 'Alter Table InitiateWorkitemDefTable rename to TempInitiateWorkitemDefTable';
					EXECUTE IMMEDIATE
						'CREATE TABLE InitiateWorkitemDefTable (
							ProcessDefID 		INT				NOT NULL ,
							ActivityId			INT				NOT NULL ,
							ImportedProcessName NVARCHAR2(30)	NOT NULL ,
							ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
							ImportedVariableId	INT					NULL,
							ImportedVarfieldId	INT					NULL,
							MappedFieldName		NVARCHAR2(63)	NOT NULL ,
							MappedVariableId	INT					NULL,
							MappedVarFieldId	INT					NULL,
							FieldType			NVARCHAR2(1)	NOT NULL ,
							MapType				NVARCHAR2(1)		NULL,
							DisplayName			NVARCHAR2(2000)		NULL
					)';
					DBMS_OUTPUT.PUT_LINE('Table InitiateWorkitemDefTable Created successfully.....');
					SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO InitiateWorkitemDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, ImportedVariableId, ImportedVarFieldId, MappedFieldName, MappedVariableId, MappedVarFieldId, FieldType, MapType, DisplayName FROM TempInitiateWorkitemDefTable';
						EXECUTE IMMEDIATE 'DROP TABLE TempInitiateWorkitemDefTable';
						EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_InitiateWorkitemDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
					COMMIT;
					DBMS_OUTPUT.PUT_LINE('Table TempInitiateWorkitemDefTable dropped successfully...........');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(168);   
			raise_application_error(-20368,v_scriptName ||' BLOCK 168 FAILED');
	END;
	v_logStatus := LogUpdate(168);
		
	v_logStatus := LogInsert(169,'Adding new column Width in ActivityTable');
	BEGIN
		/*BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_WFDurationTable';
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					BEGIN
							EXECUTE IMMEDIATE 'Alter Table WFDurationTable DROP CONSTRAINT UK_WFDurationTable';
					END;
					EXECUTE IMMEDIATE 'Alter Table WFDurationTable rename to TempWFDurationTable';
					EXECUTE IMMEDIATE 
						'CREATE TABLE WFDurationTable(
							ProcessDefId		INT				NOT NULL, 
							DurationId			INT				NOT NULL,
							WFYears				NVARCHAR2(256),
							VariableId_Years	INT	,
							VarFieldId_Years	INT	,
							WFMonths			NVARCHAR2(256),
							VariableId_Months   INT	,
							VarFieldId_Months	INT	,
							WFDays				NVARCHAR2(256),
							VariableId_Days		INT	,
							VarFieldId_Days		INT	,
							WFHours				NVARCHAR2(256),
							VariableId_Hours	INT	,
							VarFieldId_Hours	INT	,
							WFMinutes			NVARCHAR2(256),
							VariableId_Minutes	INT	,
							VarFieldId_Minutes	INT	,
							WFSeconds			NVARCHAR2(256),
							VariableId_Seconds	INT	,
							VarFieldId_Seconds	INT	,
							CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
						)';
					DBMS_OUTPUT.PUT_LINE ('Table WFDurationTable Created successfully.....'	);
					SAVEPOINT save;
						  EXECUTE IMMEDIATE 'INSERT INTO WFDurationTable SELECT ProcessDefId, DurationId, WFYears, VariableId_Years, VarFieldId_Years, WFMonths, VariableId_Months, VarFieldId_Months, WFDays, VariableId_Days, VarFieldId_Days, WFHours, VariableId_Hours, VarFieldId_Hours, WFMinutes, VariableId_Minutes, VarFieldId_Minutes, WFSeconds, VariableId_Seconds, VarFieldId_Seconds FROM TempWFDurationTable';
						  EXECUTE IMMEDIATE 'DROP TABLE TempWFDurationTable';
						  DBMS_OUTPUT.PUT_LINE ('Table TempWFDurationTable dropped successfully...........'	);
						  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_WFDurationTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
					COMMIT;
				END;	
		END;*/
		

		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('Width');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(169);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add Width INT DEFAULT 100 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column Width');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(169);   
			raise_application_error(-20369,v_scriptName ||' BLOCK 169 FAILED');
	END;
	v_logStatus := LogUpdate(169);
		
	v_logStatus := LogInsert(170,'Adding new column Height in ActivityTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('Height');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(170);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add Height INT DEFAULT 50 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column Height');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(170);   
			raise_application_error(-20370,v_scriptName ||' BLOCK 170 FAILED');
	END;
	v_logStatus := LogUpdate(170);
		
	v_logStatus := LogInsert(171,'Adding new column BlockId in ActivityTable');
	BEGIN
		/* Added By Ishu Saraf On 1/09/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('BlockId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(171);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add BlockId INT DEFAULT 0 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column BlockId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(171);   
			raise_application_error(-20371,v_scriptName ||' BLOCK 171 FAILED');
	END;
	v_logStatus := LogUpdate(171);
		
	v_logStatus := LogInsert(172,'Adding new column associatedUrl in ActivityTable');
	BEGIN
		/* Added By Ishu Saraf On 30/10/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('associatedUrl');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(172);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add associatedUrl NVARCHAR2(255)';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column associatedUrl');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(172);   
			raise_application_error(-20372,v_scriptName ||' BLOCK 172 FAILED');
	END;
	v_logStatus := LogUpdate(172);
		
	v_logStatus := LogInsert(173,'Adding new column Unbounded in EXTMethodParamDefTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('EXTMethodParamDefTable') 
			AND 
			COLUMN_NAME=UPPER('Unbounded');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(173);
				EXECUTE IMMEDIATE 'ALTER TABLE EXTMethodParamDefTable Add Unbounded NVARCHAR2(1)      DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))    NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table EXTMethodParamDefTable altered with new Column Unbounded');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(173);   
			raise_application_error(-20373,v_scriptName ||' BLOCK 173 FAILED');
	END;
	v_logStatus := LogUpdate(173);
		
	v_logStatus := LogInsert(174,'Adding new column Unbounded in WFDataStructureTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFDataStructureTable') 
			AND 
			COLUMN_NAME=UPPER('Unbounded');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(174);
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable Add Unbounded NVARCHAR2(1) 	DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))   NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFDataStructureTable altered with new Column Unbounded');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(174);   
			raise_application_error(-20374,v_scriptName ||' BLOCK 174 FAILED');
	END;
	v_logStatus := LogUpdate(174);
		
	v_logStatus := LogInsert(175,'Adding new column DivertedUserName in UserDiversionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('UserDiversionTable') 
			AND 
			COLUMN_NAME=UPPER('DivertedUserName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(175);
				EXECUTE IMMEDIATE 'ALTER TABLE UserDiversionTable Add DivertedUserName NVARCHAR2(64)';
				DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable altered with new Column DivertedUserName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(175);   
			raise_application_error(-20375,v_scriptName ||' BLOCK 175 FAILED');
	END;
	v_logStatus := LogUpdate(175);
		
	v_logStatus := LogInsert(176,'Adding new column AssignedUserName in UserDiversionTable');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('UserDiversionTable') 
			AND 
			COLUMN_NAME=UPPER('AssignedUserName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(176);
				EXECUTE IMMEDIATE 'ALTER TABLE UserDiversionTable Add AssignedUserName NVARCHAR2(64)';
				DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable altered with new Column AssignedUserName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(176);   
			raise_application_error(-20376,v_scriptName ||' BLOCK 176 FAILED');
	END;
	v_logStatus := LogUpdate(176);
		
	v_logStatus := LogInsert(177,'Update UserDiversionTable');
	BEGIN
		v_logStatus := LogSkip(177);
		DECLARE
			CURSOR cursor1 IS SELECT DivertedUserIndex, AssignedUserIndex FROM Userdiversiontable;
			BEGIN
				OPEN cursor1;
				LOOP
				FETCH cursor1 INTO v_DivertedUserIndex, v_AssignedUserIndex;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					EXECUTE IMMEDIATE ' SELECT AssignedUserName FROM UserDiversionTable' ||
									  ' where AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex) ||
									  ' and DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex) INTO v_AssignedUserName ;

					EXECUTE IMMEDIATE ' SELECT DivertedUserName FROM UserDiversionTable' ||
									  ' where AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex) ||
									  ' and DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex) INTO v_DivertedUserName ;

					IF(v_DivertedUserName is null or v_AssignedUserName is null) THEN
					BEGIN
						SELECT UserName INTO v_DivUserName FROM WFUserView
						WHERE userindex = v_DivertedUserIndex;

						SELECT UserName INTO v_AssUserName FROM WFUserView
						WHERE userindex = v_AssignedUserIndex;

						v_STR1 := ' UPDATE UserDiversionTable SET DivertedUserName = N''' || v_DivUserName || '''' ||
								  ' WHERE DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex);
						v_STR2 := ' UPDATE UserDiversionTable SET AssignedUserName = N''' || v_AssUserName || '''' ||
								  ' WHERE AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex);
						SAVEPOINT user_name;
							EXECUTE IMMEDIATE v_str1;
							EXECUTE IMMEDIATE v_str2;
						COMMIT;
						EXCEPTION
							WHEN OTHERS THEN 
							BEGIN
								DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to user_name');
								ROLLBACK TO SAVEPOINT user_name;
							END;
					END;
					END IF;
				END;
				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
				  IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				  END IF;
			END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(177);   
			raise_application_error(-20377,v_scriptName ||' BLOCK 177 FAILED');
	END;
	v_logStatus := LogUpdate(177);
		
	v_logStatus := LogInsert(178,'Recreating UserDiversionTable and inserting value in WFCabVersionTable for 7.2_UserDiversionTable');
	BEGIN
		BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_UserDiversionTable' AND ROWNUM <= 1; /* Check entry in WFCabVersionTable */
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
			BEGIN
				v_logStatus := LogSkip(178);
				existsflag := 0;
					BEGIN
					SELECT 1 INTO existsflag FROM USER_CONSTRAINTS WHERE TABLE_NAME = UPPER('UserDiversionTable') and CONSTRAINT_NAME = UPPER('uk_userdiversion');
					EXCEPTION 
							WHEN NO_DATA_FOUND THEN 
								existsFlag := 0; 
					END;
					IF existsFlag = 1 THEN        
						EXECUTE IMMEDIATE 'Alter Table UserDiversionTable Drop Constraint uk_userdiversion';
					END IF;
					existsFlag := 0;
					BEGIN
						Select 1 into existsflag from user_indexes where index_name = upper('uk_userdiversion');
					EXCEPTION 
						WHEN NO_DATA_FOUND THEN 
							existsFlag := 0; 
					END;
					IF existsFlag = 1 THEN         
						EXECUTE IMMEDIATE 'DROP INDEX uk_userdiversion';
					END IF;
				EXECUTE IMMEDIATE 'Alter Table UserDiversionTable rename to TEMP_UserDiversionTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE USERDIVERSIONTABLE ( 
						Diverteduserindex		SMALLINT , 
						DivertedUserName		NVARCHAR2(64), 
						AssignedUserindex		SMALLINT, 
						AssignedUserName		NVARCHAR2(64),	
						fromdate				DATE, 
						todate					DATE, 
						currentworkitemsflag	NVARCHAR2(1) check ( currentworkitemsflag  in (N''Y'',N''N'')), 
						CONSTRAINT uk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate) 
					)';
				DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO UserDiversionTable SELECT Diverteduserindex, DivertedUserName, AssignedUserindex, AssignedUserName, fromdate, todate, currentworkitemsflag FROM TEMP_UserDiversionTable';
					EXECUTE IMMEDIATE 'DROP Table TEMP_UserDiversionTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_UserDiversionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
				END;
			END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(178);   
			raise_application_error(-20378,v_scriptName ||' BLOCK 178 FAILED');
	END;
	v_logStatus := LogUpdate(178);
			
	v_logStatus := LogInsert(179,'DROP Table WFParamMappingBuffer');
	BEGIN
		/* Added By Ishu Saraf On 1/08/2008 */
		BEGIN
			v_logStatus := LogSkip(179);
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFParamMappingBuffer');

			EXECUTE IMMEDIATE 'DROP Table WFParamMappingBuffer'; 
			dbms_output.put_line ('Dropped WFParamMappingBuffer....');
			
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
					dbms_output.put_line ('WFParamMappingBuffer doesnot exist...');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(179);   
			raise_application_error(-20379,v_scriptName ||' BLOCK 179 FAILED');
	END;
	v_logStatus := LogUpdate(179);
		
	v_logStatus := LogInsert(180,'Adding new column VarPrecision in ExtDBFieldDefinitionTable');
	BEGIN
		/* Modifying constraint on ExtMethodDefTable - Ishu Saraf */
		/*Altering constraint on ExtMethodDefTable SrNo-15 by Ananta Handoo*/
		/*OPEN Constraint_CurD;
		LOOP
			FETCH Constraint_CurD INTO v_constraintName, v_search_Condition;
			EXIT WHEN Constraint_CurD%NOTFOUND;
			IF (UPPER(v_search_Condition) LIKE '%EXTAPPTYPE%') THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
			END IF;
		END LOOP;
		CLOSE Constraint_CurD;

		EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_EXTAP CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z''))';*/

		/* Added By Ishu Saraf On 1/09/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ExtDBFieldDefinitionTable') 
			AND 
			COLUMN_NAME=UPPER('VarPrecision');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(180);
				EXECUTE IMMEDIATE 'ALTER TABLE ExtDBFieldDefinitionTable Add VarPrecision INT';
				DBMS_OUTPUT.PUT_LINE('Table ExtDBFieldDefinitionTable altered with new Column VarPrecision');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(180);   
			raise_application_error(-20380,v_scriptName ||' BLOCK 180 FAILED');
	END;
	v_logStatus := LogUpdate(180);
		
	v_logStatus := LogInsert(181,'CREATE TABLE WFAutoGenInfoTable ');
	BEGIN
		/* Added By Ishu Saraf On 06/10/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAutoGenInfoTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(181);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAutoGenInfoTable (
					TableName			NVARCHAR2(30), 
					ColumnName			NVARCHAR2(30), 
					Seed				INT,
					IncrementBy			INT, 
					CurrentSeqNo		INT,
					UNIQUE(TableName, ColumnName)
				)';
			dbms_output.put_line ('Table WFAutoGenInfoTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(181);   
			raise_application_error(-20381,v_scriptName ||' BLOCK 181 FAILED');
	END;
	v_logStatus := LogUpdate(181);
		
	v_logStatus := LogInsert(182,'Changing QueueType for Query workstep in QueueDefTable');
	BEGIN
		/* Added By Ishu Saraf On 07/10/2008 - Changing QueueType for Query workstep in QueueDefTable*/
		BEGIN
			v_logStatus := LogSkip(182);
			DECLARE
			CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM ActivityTable WHERE ActivityType = 11;
			BEGIN
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_processDefId, v_activityId;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
						SELECT QueueId INTO v_queueId FROM QueueStreamTable WHERE ProcessDefid =  v_processdefid
						AND ActivityId = v_activityId;
						IF(SQL%ROWCOUNT != 0) THEN
							SELECT QueueType INTO v_queueType FROM QueueDefTable WHERE QueueId = v_queueId;
							IF(v_queueType != 'Q') THEN
								UPDATE QueueDefTable SET QueueType = 'Q' WHERE QueueId = v_QueueId;
							END IF;
						END IF;
					END;
				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
					IF cursor1%ISOPEN THEN
						CLOSE cursor1;
					END IF;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(182);   
			raise_application_error(-20382,v_scriptName ||' BLOCK 182 FAILED');
	END;
	v_logStatus := LogUpdate(182);
	
	v_logStatus := LogInsert(183,'Changing ActivityType of JMS Subscriber from 19 to 21');
	BEGIN
		/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of JMS Subscriber from 19 to 21*/
		BEGIN
			v_logStatus := LogSkip(183);
			DECLARE
			CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM WFJMSSubscribeTable; /* ProcessDefId, ActivityId FROM WFJMSSubscribeTable is selected*/
			BEGIN
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_processDefId, v_activityId;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
						SELECT ActivityType INTO v_activityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId; /* ActivityType from activitytable is selected corresponding to the ProcessDefId, ActivityId fetched */
						IF(SQL%ROWCOUNT != 0) THEN
						BEGIN
							IF(v_activityType != 21) THEN /* If ActivityType != 21 then it is updated */
								UPDATE ActivityTable SET ActivityType = 21 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
							END IF;
						END;
						END IF;
					END;
				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(183);   
			raise_application_error(-20383,v_scriptName ||' BLOCK 183 FAILED');
	END;
	v_logStatus := LogUpdate(183);
		
	v_logStatus := LogInsert(184,'Changing ActivityType of Webservice Invoker from 19 to 22');
	BEGIN
		/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of Webservice Invoker from 19 to 22*/
		BEGIN
			v_logStatus := LogSkip(184);
			DECLARE
			CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM WFWebServiceTable;
			BEGIN
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_processDefId, v_activityId;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
						SELECT ActivityType INTO v_activityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
						IF(SQL%ROWCOUNT != 0) THEN
						BEGIN
							IF(v_activityType != 22) THEN
								UPDATE ActivityTable SET ActivityType = 22 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
							END IF;
						END;
						END IF;
					END;
				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(184);   
			raise_application_error(-20384,v_scriptName ||' BLOCK 184 FAILED');
	END;
	v_logStatus := LogUpdate(184);
		
	v_logStatus := LogInsert(185,'CREATE TABLE WFProxyInfo');
	BEGIN
		/* Added By Ishu Saraf On 08/10/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFProxyInfo');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(185);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFProxyInfo (
					ProxyHost			NVARCHAR2(200)				NOT NULL,
					ProxyPort			NVARCHAR2(200)				NOT NULL,
					ProxyUser			NVARCHAR2(200)				NOT NULL,
					ProxyPassword		NVARCHAR2(512),
					DebugFlag			NVARCHAR2(200),				
					ProxyEnabled		NVARCHAR2(200)
				)';
			dbms_output.put_line ('Table WFProxyInfo Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(185);   
			raise_application_error(-20385,v_scriptName ||' BLOCK 185 FAILED');
	END;
	v_logStatus := LogUpdate(185);
		
	v_logStatus := LogInsert(186,'CREATE TABLE WFSearchVariableTable and Updating WFSEARCHVARIABLETABLE');
	BEGIN
		/* Added By Ishu Saraf 21/10/2008 - Search criteria in WFSearchVariableTable */
		existsflag :=0;
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TABLES  
					WHERE UPPER(TABLE_NAME) = 'WFSEARCHVARIABLETABLE'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN     
		v_logStatus := LogSkip(186);
			BEGIN
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFSearchVariableTable (
						ProcessDefID 		INT				NOT NULL,
						ActivityID 			INT				NOT NULL,
						FieldName			NVARCHAR2(2000)	NOT NULL,
						Scope				NVARCHAR2(1)	NOT NULL	CHECK (Scope = N''C'' OR Scope = N''F'' OR Scope = N''R''),
						OrderID 			INT				NOT NULL,
						PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFSearchVariableTable created successfully');

				v_QueryStr := ' Select ProcessDefID, ActivityID ' ||
						  ' From ActivityTable ' ||
						  ' Where ActivityType = 1 ' ||
						  ' and PrimaryActivity = ''Y'' ';

				OPEN v_updateCursor FOR TO_CHAR(v_QueryStr); 
				LOOP
					FETCH v_updateCursor INTO v_ProcessDefID, v_DefaultIntroductionActID;
					dbms_output.put_line(v_ProcessDefID);
					dbms_output.put_line(v_DefaultIntroductionActID);			
					EXIT WHEN v_updateCursor%NOTFOUND; 

					SAVEPOINT TRANDATA;
					BEGIN
						EXECUTE IMMEDIATE (' Insert Into WFSEARCHVARIABLETABLE(ProcessDefID, ActivityID, FieldName, Scope, OrderID) ' ||
						' Select ' || TO_CHAR(v_ProcessDefID) || ', ' || TO_CHAR(v_DefaultIntroductionActID) || ', ' || ' FieldName, ''C'', RowNum - 1 ' ||
						' From ActivityAssociationTable ' ||
						' Where ProcessDefID = ' || TO_CHAR(v_ProcessDefID) ||
						' And ActivityID = ' || TO_CHAR(v_DefaultIntroductionActID) ||
						' And DefinitionType in ( ''I'' , ''Q'' , ''N'' ) And Attribute in ( ''O'', ''B'' , ''R'' , ''M'' ) ');

						EXECUTE IMMEDIATE (' Insert Into WFSEARCHVARIABLETABLE(ProcessDefID, ActivityID, FieldName, Scope, OrderID) ' ||
						' Select ' || TO_CHAR(v_ProcessDefID) || ', ' || TO_CHAR(v_DefaultIntroductionActID) || ', ' || ' FieldName, ''R'', RowNum - 1 ' ||
						' From ActivityAssociationTable ' ||
						' Where ProcessDefID = ' || TO_CHAR(v_ProcessDefID) ||
						' And ActivityID = ' || TO_CHAR(v_DefaultIntroductionActID) ||
						' And DefinitionType in ( ''I'' , ''Q'' , ''N'' ) And Attribute in ( ''O'', ''B'' , ''R'' , ''M'' ) ');
					EXCEPTION
						WHEN OTHERS THEN 
						BEGIN
							ROLLBACK TO SAVEPOINT TRANDATA;
						END;
					END;
					COMMIT;

					v_QueryStr := ' Select ActivityID ' ||
								  ' From ActivityTable ' ||
								  ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefID) ||
								  ' And ActivityType = 11 ';
					
					OPEN qws_cursor FOR TO_CHAR(v_QueryStr);
					LOOP
						FETCH qws_cursor INTO v_QueryActivityId;
						EXIT WHEN qws_cursor%NOTFOUND;
						
						EXECUTE IMMEDIATE ' INSERT INTO WFSearchVariableTable ' ||
						' SELECT ProcessdefId, ' || TO_CHAR(v_QueryActivityId) || ' , FieldName, Scope, OrderId ' || 
						' FROM wfsearchVariableTable ' || 
						' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefID) || 
						' And ActivityId = ' || TO_CHAR(v_DefaultIntroductionActID);

					END LOOP;	
					CLOSE qws_cursor;

				END LOOP; 
				CLOSE v_updateCursor; 
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(186);   
			raise_application_error(-20386,v_scriptName ||' BLOCK 186 FAILED');
	END;
	v_logStatus := LogUpdate(186);
		
	v_logStatus := LogInsert(187,'Adding new column ArgList in GenerateResponseTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		existsflag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('GenerateResponseTable') 
			AND 
			COLUMN_NAME=UPPER('ArgList');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsflag := 0;
		END;

		IF existsFlag = 1 THEN       
		v_logStatus := LogSkip(187);
			EXECUTE IMMEDIATE 'ALTER TABLE GenerateResponseTable DROP COLUMN ArgList';
			DBMS_OUTPUT.PUT_LINE ('Column ArgList dropped successfully........');
			EXECUTE IMMEDIATE 'ALTER TABLE TemplateDefinitionTable ADD ArgList NVARCHAR2(512) NULL';
			DBMS_OUTPUT.PUT_LINE ('Table TemplateDefinitionTable altered with new column ArgList.........');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(187);   
			raise_application_error(-20387,v_scriptName ||' BLOCK 187 FAILED');
	END;
	v_logStatus := LogUpdate(187);
		
	v_logStatus := LogInsert(188,'CREATE TABLE WFAuthorizationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(188);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizationTable (
					AuthorizationID	INT 			PRIMARY KEY,
					EntityType		NVARCHAR2(1)	CHECK (EntityType = N''Q'' or EntityType = N''P''),
					EntityID		INT				NULL,
					EntityName		NVARCHAR2(63)	NOT NULL,
					ActionDateTime	DATE			NOT NULL,
					MakerUserName	NVARCHAR2(256)	NOT NULL,
					CheckerUserName	NVARCHAR2(256)	NULL,
					Comments		NVARCHAR2(2000)	NULL,
					Status			NVARCHAR2(1)	CHECK (Status = N''P'' or Status = N''R'' or Status = N''I'')						
				)';
			dbms_output.put_line ('Table WFAuthorizationTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(188);   
			raise_application_error(-20388,v_scriptName ||' BLOCK 188 FAILED');
	END;
	v_logStatus := LogUpdate(188);
		
	v_logStatus := LogInsert(189,'CREATE TABLE WFAuthorizeQueueDefTable ');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeQueueDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(189);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizeQueueDefTable (
					AuthorizationID		INT				NOT NULL,
					ActionId			INT				NOT NULL,	
					QueueType			NVARCHAR2(1)	NULL,
					Comments			NVARCHAR2(255)	NULL,
					AllowReASsignment 	NVARCHAR2(1)	NULL,
					FilterOption		INT				NULL,
					FilterValue			NVARCHAR2(63)	NULL,
					OrderBy				INT				NULL,
					QueueFilter			NVARCHAR2(2000)	NULL
				)';
			dbms_output.put_line ('Table WFAuthorizeQueueDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(189);   
			raise_application_error(-20389,v_scriptName ||' BLOCK 189 FAILED');
	END;
	v_logStatus := LogUpdate(189);
		
	v_logStatus := LogInsert(190,'CREATE TABLE WFAuthorizeQueueStreamTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeQueueStreamTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(190);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizeQueueStreamTable (
					AuthorizationID	INT				NOT NULL,
					ActionId		INT				NOT NULL,	
					ProcessDefID 	INT				NOT NULL,
					ActivityID 		INT				NOT NULL,
					StreamId 		INT				NOT NULL,
					StreamName		NVARCHAR2(30)	NOT NULL
				)';
			dbms_output.put_line ('Table WFAuthorizeQueueStreamTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(190);   
			raise_application_error(-20390,v_scriptName ||' BLOCK 190 FAILED');
	END;
	v_logStatus := LogUpdate(190);
		
	v_logStatus := LogInsert(191,'CREATE TABLE WFAuthorizeQueueUserTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeQueueUserTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(191);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizeQueueUserTable (
					AuthorizationID			INT			NOT NULL,
					ActionId				INT			NOT NULL,	
					Userid 					SMALLINT 	NOT NULL,
					ASsociationType 		SMALLINT 	NULL,
					ASsignedTillDATETIME	DATE		NULL, 
					QueryFilter				NVARCHAR2(2000)	NULL,
					UserName				NVARCHAR2(256)	NOT NULL
				)';
			dbms_output.put_line ('Table WFAuthorizeQueueUserTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(191);   
			raise_application_error(-20391,v_scriptName ||' BLOCK 191 FAILED');
	END;
	v_logStatus := LogUpdate(191);
		
	v_logStatus := LogInsert(192,'CREATE TABLE WFAuthorizeProcessDefTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeProcessDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(192);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizeProcessDefTable (
					AuthorizationID	INT				NOT NULL,
					ActionId		INT				NOT NULL,	
					VersionNo		SMALLINT		NOT NULL,
					ProcessState	NVARCHAR2(10)	NOT NULL 
				)';
			dbms_output.put_line ('Table WFAuthorizeProcessDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(192);   
			raise_application_error(-20392,v_scriptName ||' BLOCK 192 FAILED');
	END;
	v_logStatus := LogUpdate(192);
		
	v_logStatus := LogInsert(193,'CREATE TABLE WFSoapReqCorrelationTable');
	BEGIN
		/* Added By Ishu Saraf On 22/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSoapReqCorrelationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(193);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSoapReqCorrelationTable (
				   Processdefid     INT					NOT NULL,
				   ActivityId       INT					NOT NULL,
				   PropAlias        NVARCHAR2(255)		NOT NULL,
				   VariableId       INT					NOT NULL,
				   VarFieldId       INT					NOT NULL,
				   SearchField      NVARCHAR2(255)		NOT NULL,
				   SearchVariableId INT					NOT NULL,
				   SearchVarFieldId INT					NOT NULL
				)';
			dbms_output.put_line ('Table WFSoapReqCorrelationTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(193);   
			raise_application_error(-20393,v_scriptName ||' BLOCK 193 FAILED');
	END;
	v_logStatus := LogUpdate(193);
		
	v_logStatus := LogInsert(194,'Adding new column ReplyPath in WFWebServiceTable');
	BEGIN
		/* Added By Ishu Saraf On 27/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
			AND 
			COLUMN_NAME=UPPER('ReplyPath');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(194);
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add ReplyPath NVARCHAR2(256) ';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column ReplyPath');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(194);   
			raise_application_error(-20394,v_scriptName ||' BLOCK 194 FAILED');
	END;
	v_logStatus := LogUpdate(194);
		
	v_logStatus := LogInsert(195,'Adding new column AssociatedActivityId in WFWebServiceTable');
	BEGIN
		/* Added By Ishu Saraf On 27/11/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
			AND 
			COLUMN_NAME=UPPER('AssociatedActivityId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(195);
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add AssociatedActivityId INT ';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column AssociatedActivityId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(195);   
			raise_application_error(-20395,v_scriptName ||' BLOCK 195 FAILED');
	END;
	v_logStatus := LogUpdate(195);
		
	v_logStatus := LogInsert(196,'CREATE TABLE WFWSAsyncResponseTable');
	BEGIN
		/* Added By Ishu Saraf On 27/11/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFWSAsyncResponseTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(196);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFWSAsyncResponseTable (
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL, 
					ProcessInstanceId	Nvarchar2(64)	NOT NULL, 
					WorkitemId			INT				NOT NULL, 
					CorrelationId1		Nvarchar2(100)		NULL, 
					CorrelationId2		Nvarchar2(100)		NULL, 
					Response			CLOB				NULL,
					CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE (ActivityId, ProcessInstanceId, WorkitemId)
				)';
			dbms_output.put_line ('Table WFWSAsyncResponseTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(196);   
			raise_application_error(-20396,v_scriptName ||' BLOCK 196 FAILED');
	END;
	v_logStatus := LogUpdate(196);
		
	v_logStatus := LogInsert(197,'Adding new column allowSOAPRequest in ActivityTable');
	BEGIN
		/* Added By Ishu Saraf On 06/12/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('allowSOAPRequest');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(197);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add allowSOAPRequest NVarChar2(1) DEFAULT N''N'' CHECK (allowSOAPRequest IN (N''Y'' , N''N'')) NOT NULL ';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column allowSOAPRequest');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(197);   
			raise_application_error(-20397,v_scriptName ||' BLOCK 197 FAILED');
	END;
	v_logStatus := LogUpdate(197);
		
	v_logStatus := LogInsert(198,'Adding new column ActivityTable in AssociatedActivityId');
	BEGIN
		/* Added By Ishu Saraf On 08/12/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('AssociatedActivityId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(198);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add AssociatedActivityId INT ';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column AssociatedActivityId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(198);   
			raise_application_error(-20398,v_scriptName ||' BLOCK 198 FAILED');
	END;
	v_logStatus := LogUpdate(198);
		
	v_logStatus := LogInsert(199,'Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation ');
	BEGIN
		/* Added By Ishu Saraf On 06/12/2008 - Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation */
		BEGIN
			v_logStatus := LogSkip(199);
			DECLARE
			CURSOR cursor1 IS SELECT ActivityId FROM WFWebServiceTable WHERE InvocationType = 'A'; /* ActivityId FROM WFWebServiceTable is selected*/
			BEGIN
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_activityId;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
						EXECUTE IMMEDIATE 'SELECT TargetActivityId INTO v_targetActivityId FROM ActivityTable WHERE ActivityId = v_activityId'; /* TargetActivityId from activitytable is selected corresponding to the ActivityId fetched */
						IF(SQL%ROWCOUNT != 0) THEN
						BEGIN
							v_STR1 := ' UPDATE ActivityTable SET AssociatedActivityId = ' || TO_CHAR(v_targetActivityId) || ' WHERE ActivityId = ' || TO_CHAR(v_activityId);
							EXECUTE IMMEDIATE v_STR1;
						END;
						END IF;
					END;
				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(199);   
			raise_application_error(-20399,v_scriptName ||' BLOCK 199 FAILED');
	END;
	v_logStatus := LogUpdate(199);
		
	v_logStatus := LogInsert(200,'CREATE SEQUENCE WFRemId,CREATE TRIGGER REM_ID_TRIGGER BEFORE INSERT');
	BEGIN
		/* Added By Ishu Saraf On 06/12/2008 - Sequence WFRemId Bugzilla Bug Id - 7066*/
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('WFRemId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(200);
				SELECT (MAX(RemIndex) + 1) INTO v_lastSeqValue FROM WFReminderTable;
				EXECUTE IMMEDIATE 'CREATE SEQUENCE WFRemId INCREMENT BY 1 START WITH ' || TO_CHAR(COALESCE(v_lastSeqValue, 1));
				DBMS_OUTPUT.PUT_LINE('SEQUENCE WFRemId Successfully Created');
				EXECUTE IMMEDIATE '
					CREATE OR REPLACE TRIGGER REM_ID_TRIGGER 
					BEFORE INSERT ON  WFREMINDERTABLE 
					FOR EACH ROW 
					BEGIN	 
						SELECT WFRemId.nextval INTO :new.RemIndex FROM dual; 
					END;
				';
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(200);   
			raise_application_error(-20400,v_scriptName ||' BLOCK 200 FAILED');
	END;
	v_logStatus := LogUpdate(200);
		
	v_logStatus := LogInsert(201,'CREATE SEQUENCE SEQ_AuthorizationID ');
	BEGIN
		/* Added by Ishu Saraf 08/12/2008 */
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('SEQ_AuthorizationID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(201);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_AuthorizationID INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE SEQ_AuthorizationID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(201);   
			raise_application_error(-20401,v_scriptName ||' BLOCK 201 FAILED');
	END;
	v_logStatus := LogUpdate(201);
		
	v_logStatus := LogInsert(202,'CREATE TABLE WFScopeDefTable');
	BEGIN
		/* Added By Ishu Saraf On 15/12/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFScopeDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(202);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFScopeDefTable (
					ProcessDefId		INT				NOT NULL,
					ScopeId				INT				NOT NULL,
					ScopeName			NVarChar2(256)	NOT NULL,
					PRIMARY KEY (ProcessDefId, ScopeId)
				)';
			dbms_output.put_line ('Table WFScopeDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(202);   
			raise_application_error(-20402,v_scriptName ||' BLOCK 202 FAILED');
	END;
	v_logStatus := LogUpdate(202);
		
	v_logStatus := LogInsert(203,'CREATE TABLE WFEventDefTable');
	BEGIN
		/* Added By Ishu Saraf On 15/12/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFEventDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(203);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFEventDefTable (
					ProcessDefId				INT					NOT NULL,
					EventId						INT					NOT NULL,
					ScopeId						INT					NULL,
					EventType					NVarChar2(1)		DEFAULT N''M'' CHECK (EventType IN (N''A'' , N''M'')),
					EventDuration				INT					NULL,
					EventFrequency				NVarChar2(1)		CHECK (EventFrequency IN (N''O'' , N''M'')),
					EventInitiationActivityId	INT					NOT NULL,
					EventName					NVarChar2(64)		NOT NULL,
					associatedUrl				NVarChar2(255)		NULL,
					PRIMARY KEY (ProcessDefId, EventId)
				)';
			dbms_output.put_line ('Table WFEventDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(203);   
			raise_application_error(-20403,v_scriptName ||' BLOCK 203 FAILED');
	END;
	v_logStatus := LogUpdate(203);
		
	v_logStatus := LogInsert(204,'CREATE TABLE WFActivityScopeAssocTable');
	BEGIN
		/* Added By Ishu Saraf On 15/12/2008 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFActivityScopeAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(204);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFActivityScopeAssocTable (
					ProcessDefId		INT			NOT NULL,
					ScopeId				INT			NOT NULL,
					ActivityId			INT			NOT NULL,
					CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
				)';
			dbms_output.put_line ('Table WFActivityScopeAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(204);   
			raise_application_error(-20404,v_scriptName ||' BLOCK 204 FAILED');
	END;
	v_logStatus := LogUpdate(204);
		
	v_logStatus := LogInsert(205,'Adding new column EventId in ActivityTable');
	BEGIN
		/* Added By Ishu Saraf On 15/12/2008 */
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ActivityTable') 
			AND 
			COLUMN_NAME=UPPER('EventId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(205);
				EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add EventId INT ';
				DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column EventId');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(205);   
			raise_application_error(-20405,v_scriptName ||' BLOCK 205 FAILED');
	END;
	v_logStatus := LogUpdate(205);
		

	v_logStatus := LogInsert(206,'Renaming WFTempSearchTable TO GTempSearchTable ');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('GTempSearchTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(206);
				EXECUTE IMMEDIATE 'RENAME WFTempSearchTable TO GTempSearchTable';
				DBMS_OUTPUT.PUT_LINE('Table WFTempSearchTable successfully renamed to GTempSearchTable');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(206);   
			raise_application_error(-20406,v_scriptName ||' BLOCK 206 FAILED');
	END;
	v_logStatus := LogUpdate(206);	
		
	
End;


~

call Upgrade()

~

Drop Procedure Upgrade

~