/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: OmniFlow
	Module						: Omniflow Server
	File NAME					: Upgrade.sql (Postgres Server)
	Author						: Saurabh Kamal
	Date written (DD/MM/YYYY)	: 08/12/2010
	Description					: Upgrade for Valus insertion in tables.
________________________________________________________________________________________________________________-
			CHANGE HISTORY
________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

________________________________________________________________________________________________________________-*/

CREATE OR REPLACE FUNCTION UpgradeInsert() Returns Text  AS '
DECLARE 
	existFlag 			INTEGER;
	v_queryStr			TEXT;
	Constraint_CurD		REFCURSOR;
	v_SysString			TEXT;
	v_SysString1		TEXT;
	v_Cursor			REFCURSOR;
	v_CursorInner		REFCURSOR;
	v_SysStringExt		TEXT;	
	v_cabVersion		VARCHAR(255);
	v_sysDefinedName	VARCHAR(255);
	v_userDefinedName	VARCHAR(64);
	v_strVar			VARCHAR(64);
	v_QueryStrExt		TEXT;
	v_AssignedUserName	VARCHAR (2000);
	v_AssignedUserIndex	INTEGER;
	v_DivertedUserIndex	INTEGER;
	v_DivertedUserName	VARCHAR (2000);
	v_DivUserName		VARCHAR (2000);
	v_AssUserName		VARCHAR (2000);
	v_constraintName	VARCHAR(2000);
	v_search_Condition	VARCHAR(2000);
	v_processDefId		INTEGER;
	v_activityId		INTEGER;
	v_queueId			INTEGER;
	v_rowCount			INTEGER;
	v_queueType			VARCHAR(1);
	v_activityType		INTEGER;	
	v_DefaultIntroductionActID	INTEGER;	
	v_CursorSearch		REFCURSOR;	
	v_QuerySearch		TEXT;
	v_fieldName			VARCHAR(255);
	v_OrderId			INTEGER;
	v_QueryQws			TEXT;
	v_CursorQws			REFCURSOR;
	v_QueryActivityId	INTEGER;
	v_targetActivityId	INTEGER;
	v_count				INTEGER;
	v_EndPos			INTEGER;
	v_STR1				VARCHAR(2000);
	v_STR2				VARCHAR(2000);
	v_STR3				VARCHAR(2000);
	v_STR4				VARCHAR(2000);
	v_STR5				VARCHAR(2000);
	v_STR6				VARCHAR(2000);
	v_STR7				VARCHAR(2000);
	v_STR8				VARCHAR(2000);
	v_STR9				VARCHAR(2000);
	v_STR10				VARCHAR(2000);
	v_STR11				VARCHAR(2000);
	v_STR12				VARCHAR(2000);
	v_STR13				VARCHAR(2000);
	v_STR14				VARCHAR(2000);
	v_STR15				VARCHAR(2000);
	v_STR16				VARCHAR(2000);
	v_STR17				VARCHAR(2000);
	v_STR18				VARCHAR(2000);
	v_STR19				VARCHAR(2000);
	v_STR20				VARCHAR(2000);
	v_STR21				VARCHAR(2000);
	v_STR22				VARCHAR(2000);
	v_STR23				VARCHAR(2000);
	v_STR24				VARCHAR(2000);
	v_STR25				VARCHAR(2000);
	v_STR26				VARCHAR(2000);
	v_STR27				VARCHAR(2000);
	v_STR28				VARCHAR(2000);
	v_STR29				VARCHAR(2000);
	v_STR30				VARCHAR(2000);
	v_STR31				VARCHAR(2000);
	v_STR32				VARCHAR(2000);
	v_STR33				VARCHAR(2000);
	v_STR34				VARCHAR(2000);
	v_STR35				VARCHAR(2000);
	v_STR36				VARCHAR(2000);
	v_STR37				VARCHAR(2000);
	v_STR38				VARCHAR(2000);
	v_STR39				VARCHAR(2000);	
	v_STR40				VARCHAR(2000);	
BEGIN	
	v_SysString := ''VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,'' ||
		 ''VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,'' ||
		 ''VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,sysdate,CreatedDateTime,'' ||
		 ''EntryDateTime,ValidTill,ProcessInstanceName,CreatedByName,PreviousStage,SaveStage,IntroductionDateTime,'' ||
		 ''IntroducedBy,InstrumentStatus,PriorityLevel,HoldStatus,ProcessInstanceState,WorkItemState,'' ||
		 ''Status,ActivityId,QueueType,QueueName,LockedByName,LockedTime,LockStatus,ActivityName,'' ||
		 ''CheckListCompleteFlag,AssignmentType,ProcessedBy,VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5'';
		 
	BEGIN
		SELECT 1 INTO existflag
		from pg_constraint where conname = LOWER(''CK_EXTMETHOD_RET'');
		IF(NOT FOUND) THEN
			ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_RET CHECK (ReturnType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16));
		END IF;			
	END;	 
	
	BEGIN
		SELECT 1 INTO existflag
		from pg_constraint where conname = LOWER(''CK_EXTMETHODPARAM_PARAM'');
		IF(NOT FOUND) THEN
			ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM CHECK (ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16));
		END IF;			
	END;	 
		
	BEGIN
		v_QueryStr := ''SELECT ProcessDefId FROM ProcessDefTable'';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
		FETCH v_Cursor INTO v_processDefId;
			IF(NOT FOUND) THEN
					EXIT;
			END IF;
			v_count := 1;
			v_EndPos := 1;
			v_QueryStrExt := ''SELECT SystemDefinedName FROM VarmappingTable WHERE processdefid = '' || v_processdefid || '' AND ExtObjId = 1'';
			OPEN v_CursorInner FOR EXECUTE v_QueryStrExt; 
				v_SysString1 := v_SysString;
				LOOP
					FETCH v_CursorInner INTO v_sysDefinedName;
					IF(NOT FOUND) THEN
						EXIT;
					END IF;
					v_SysString1 := v_SysString1 || '','' || v_sysDefinedName;
				END LOOP;
			CLOSE v_CursorInner;
			
			WHILE(v_EndPos > 0) LOOP		
				v_EndPos := STRPOS(v_SysString1, '','');		
				IF(v_EndPos <= 0) THEN			
					v_strVar := v_SysString1;
				ELSE 	
					v_strVar := SUBSTR(v_SysString1, 1, v_EndPos - 1);
					v_SysString1 := SUBSTR(v_SysString1, v_EndPos + 1);			
				END IF;
				RAISE NOTICE ''TEST  % '', v_strVar;
				v_strVar := LTRIM(RTRIM(v_strVar));
				SELECT INTO v_userDefinedName UserDefinedName FROM VarMappingTable 
				WHERE ProcessDefid = v_ProcessDefId  
				AND VariableId = 0 AND SystemDefinedName = v_strVar;
				
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				RAISE NOTICE ''ROWCOUNT ::  % '', v_rowCount;
				IF(v_rowCount > 0) THEN
					BEGIN
						RAISE NOTICE ''DEBUG v_STR2 % '', v_strVar;
						v_STR2 := '' UPDATE VarMappingTable SET VariableId = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and SystemDefinedName = '' || quote_literal(v_strVar);						
						v_STR3 := '' UPDATE ActivityAssociationTable SET VariableId = '' || v_count ||
								  '' where ProcessDefId =  '' || v_ProcessDefId ||
								  '' and FieldName = '' || quote_literal(v_userDefinedName); 
						v_STR4 := '' UPDATE RuleOperationTable SET VariableId_1 = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and OperationType in (1, 18, 19, 23, 24) and Type1 != ''''C'''' and Param1 = '' || quote_literal(v_userDefinedName); 
						v_STR5 := '' UPDATE RuleOperationTable SET VariableId_2 = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and OperationType in (1, 18, 19, 23, 24) and Type2 != ''''C'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR6 := '' UPDATE RuleOperationTable SET VariableId_3 = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and OperationType in (1, 18, 19, 23, 24) and Type3 != ''''C'''' and Param3 = '' || quote_literal(v_userDefinedName);
						v_STR7 := '' UPDATE RuleConditionTable SET VariableId_1 = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and Type1 != ''''C'''' and Type1 != ''''S'''' and Param1 = '' || quote_literal(v_userDefinedName);
						v_STR8 := '' UPDATE RuleConditionTable SET VariableId_2 = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and Type2 != ''''C'''' and Type2 != ''''S'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR9 := '' UPDATE ExtMethodParamMappingTable SET VariableId = '' || v_count ||
								  '' where ProcessDefId = '' || v_ProcessDefId ||
								  '' and MappedFieldType in (''''S'''', ''''Q'''', ''''M'''', ''''I'''', ''''U'''')'' ||
								  '' and MappedField = '' || quote_literal(v_userDefinedName);
						v_STR10 := '' UPDATE ActionOperationTable SET VariableId_1 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and OperationType in (1, 18, 19, 23, 24) and Type1 != ''''C'''' and Param1 = '' || quote_literal(v_userDefinedName); 
						v_STR11 := '' UPDATE ActionOperationTable SET VariableId_2 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and OperationType in (1, 18, 19, 23, 24) and Type2 != ''''C'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR12 := '' UPDATE ActionOperationTable SET VariableId_3 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and OperationType in (1, 18, 19, 23, 24) and Type3 != ''''C'''' and Param3 = '' || quote_literal(v_userDefinedName);
						v_STR13 := '' UPDATE ActionConditionTable SET VariableId_1 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Type1 != ''''C'''' and Type1 != ''''S'''' and Param1 = '' || quote_literal(v_userDefinedName);
						v_STR14 := '' UPDATE ActionConditionTable SET VariableId_2 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Type2 != ''''C'''' and Type2 != ''''S'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR15	:= '' UPDATE DataSetTriggerTable SET VariableId_1 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Param1 = '' || quote_literal(v_userDefinedName);
						v_STR16	:= '' UPDATE DataSetTriggerTable SET VariableId_2 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Type2 != ''''C'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR17	:= '' UPDATE ScanActionsTable SET VariableId_1 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Param1 = '' || quote_literal(v_userDefinedName);
						v_STR18	:= '' UPDATE ScanActionsTable SET VariableId_2 = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and Type2 != ''''C'''' and Param2 = '' || quote_literal(v_userDefinedName);
						v_STR19	:= '' UPDATE WFDataMapTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and DocTypeDefId = 0 and MappedFieldName = '' || quote_literal(v_userDefinedName);
						v_STR20	:= '' UPDATE DataEntryTriggerTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and VariableName = '' || quote_literal(v_userDefinedName);
						v_STR21	:= '' UPDATE ArchiveDataMapTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and AssocVar = '' || quote_literal(v_userDefinedName);
						v_STR22	:= '' UPDATE WFJMSSubscribeTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and processVariableName = '' || quote_literal(v_userDefinedName);
						v_STR23	:= '' UPDATE ToDoListDefTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and AssociatedField = '' || quote_literal(v_userDefinedName);
						v_STR24	:= '' UPDATE MailTriggerTable SET VariableIdTo = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and ToType != ''''C'''' and ToUser = '' || quote_literal(v_userDefinedName);
						v_STR25	:= '' UPDATE MailTriggerTable SET VariableIdFrom = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and FromUserType != ''''C'''' and FromUser = '' || quote_literal(v_userDefinedName);
						v_STR26	:= '' UPDATE MailTriggerTable SET VariableIdCC = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and CCType != ''''C'''' and CCUser = '' || quote_literal(v_userDefinedName);
						v_STR27	:= '' UPDATE PrintFaxEmailTable SET VariableIdTo = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and ToMailIdType != ''''C'''' and ToMailId = '' || quote_literal(v_userDefinedName);
						v_STR28	:= '' UPDATE PrintFaxEmailTable SET VariableIdFrom = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and SenderMailIdType != ''''C'''' and SenderMailId = '' || quote_literal(v_userDefinedName);
						v_STR29	:= '' UPDATE PrintFaxEmailTable SET VariableIdCC = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and CCMailIdType != ''''C'''' and CCMailId = '' || quote_literal(v_userDefinedName);
						v_STR30	:= '' UPDATE PrintFaxEmailTable SET VariableIdFax = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and FaxNoType != ''''C'''' and FaxNo = '' || quote_literal(v_userDefinedName);
						v_STR31	:= '' UPDATE ImportedProcessDefTable SET VariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and FieldType != ''''D'''' and ImportedFieldName = '' || quote_literal(v_userDefinedName);
						v_STR32	:= '' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and FieldType != ''''D'''' and ImportedFieldName = '' || quote_literal(v_userDefinedName);
						v_STR33	:= '' UPDATE InitiateWorkItemDefTable SET MappedVariableId = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and FieldType != ''''D'''' and MappedFieldName = '' || quote_literal(v_userDefinedName);	
						v_STR34	:= '' UPDATE WFDurationTable SET VariableId_Years = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFYears = '' || quote_literal(v_userDefinedName);	
						v_STR35	:= '' UPDATE WFDurationTable SET VariableId_Months = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFMonths = '' || quote_literal(v_userDefinedName);	
						v_STR36	:= '' UPDATE WFDurationTable SET VariableId_Days = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFDays = '' || quote_literal(v_userDefinedName);	
						v_STR37	:= '' UPDATE WFDurationTable SET VariableId_Hours = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFHours = '' || quote_literal(v_userDefinedName);	
						v_STR38	:= '' UPDATE WFDurationTable SET VariableId_Minutes = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFMinutes = '' || quote_literal(v_userDefinedName);	
						v_STR39	:= '' UPDATE WFDurationTable SET VariableId_Seconds = '' || v_count ||
								   '' where ProcessDefId = '' || v_ProcessDefId ||
								   '' and WFSeconds = '' || quote_literal(v_userDefinedName);
						
						EXECUTE v_STR2;
						IF(v_UserDefinedName IS NOT NULL) THEN
						BEGIN
							EXECUTE v_str3;
							EXECUTE v_str4;
							EXECUTE v_str5;
							EXECUTE v_str6;
							EXECUTE v_str7;
							EXECUTE v_str8;
							EXECUTE v_str9;
							EXECUTE v_str10;
							EXECUTE v_str11;
							EXECUTE v_str12;
							EXECUTE v_str13;
							EXECUTE v_str14;
							EXECUTE v_str15;
							EXECUTE v_str16;
							EXECUTE v_str17;
							EXECUTE v_str18;
							EXECUTE v_str19;
							EXECUTE v_str20;
							EXECUTE v_str21;
							EXECUTE v_str22;
							EXECUTE v_str23;
							EXECUTE v_str24;
							EXECUTE v_str25;
							EXECUTE v_str26;
							EXECUTE v_str27;
							EXECUTE v_str28;
							EXECUTE v_str29;
							EXECUTE v_str30;
							EXECUTE v_str31;
							EXECUTE v_str32;
							EXECUTE v_str33;
							EXECUTE v_str34;
							EXECUTE v_str35;
							EXECUTE v_str36;
							EXECUTE v_str37;
							EXECUTE v_str38;
							EXECUTE v_str39;
						END;
						END IF;
					END;
				END IF;
			--	RAISE NOTICE ''Variable Name % '', v_strVar;
				v_count := v_count + 1;
			END LOOP;			
		END LOOP;
	CLOSE v_Cursor;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_VarMappingTable'';
		IF(NOT FOUND) THEN
			BEGIN
				BEGIN
					SELECT 1 INTO existFlag FROM  VarMappingTable GROUP BY ProcessDefID, SystemDefinedName HAVING COUNT(*) > 1;
					IF(NOT FOUND) THEN
						ALTER TABLE varmappingtable DROP CONSTRAINT pk_varmappingtable ;
						Alter Table VarMappingTable DROP CONSTRAINT CK_VarMappin_VarScope;
					END IF;
				END;
				Alter Table VarMappingTable rename to TempVarMappingTable;
				
				CREATE TABLE VARMAPPINGTABLE(
					ProcessDefId 		INTEGER 		NOT NULL,
					VariableId			INTEGER			NOT NULL,
					SystemDefinedName	VARCHAR(50) 	NOT NULL,
					UserDefinedName		VARCHAR(50)		NULL,
					VariableType 		INTEGER 		NOT NULL,
					VariableScope 		VARCHAR(1) 		NOT NULL,
					ExtObjId 			INTEGER			NULL ,
					DefaultValue		VARCHAR(255)	NULL ,
					VariableLength  	INTEGER			NULL,
					VarPrecision		INTEGER			NULL,
					Unbounded			VARCHAR(1) 	NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')),
					CONSTRAINT Ck_VarMappin_VarScope CHECK(VariableScope = ''M'' OR (VariableScope = ''I'' OR (VariableScope = ''U'' OR (VariableScope = ''S'')))),
					CONSTRAINT Pk_VarMappingTable PRIMARY KEY(ProcessDefId, VariableId)
				);
				
				INSERT INTO VarMappingTable SELECT ProcessDefId, VariableId, SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded FROM TempVarMappingTable;
				DROP TABLE TempVarMappingTable;
				
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_VarMappingTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_SearchCriteria'';
		IF(NOT FOUND) THEN
			BEGIN				
				
				ALTER TABLE ExtMethodDefTable DROP CONSTRAINT extmethoddeftable_pkey;
				Alter Table ExtMethodDefTable rename to TempExtMethodDefTable;
				
				CREATE TABLE EXTMETHODDEFTABLE(
					ProcessDefId		INTEGER			NOT NULL,
					ExtMethodIndex		INTEGER			NOT NULL,	
					ExtAppName			VARCHAR(64)		NOT NULL, 
					ExtAppType			VARCHAR(1)		NOT NULL CHECK(ExtAppType IN (''E'', ''W'', ''S'', ''Z'')), 
					ExtMethodName		VARCHAR(64)		NOT NULL, 
					SearchMethod		VARCHAR(255)	NULL, 
					SearchCriteria		INTEGER 		NULL,
					ReturnType			INTEGER			CHECK(ReturnType IN (0,3,4,6,8,10,11,12,14,15,16)),
					MappingFile			VARCHAR(1),
					PRIMARY KEY(ProcessDefId, ExtMethodIndex)
				);
				
				INSERT INTO EXTMETHODDEFTABLE SELECT ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, TO_NUMBER(SearchCriteria, ''99999''), ReturnType, MappingFile FROM TempExtMethodDefTable;
				DROP TABLE TempExtMethodDefTable;
				
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SearchCriteria'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_RuleOperationTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table RuleOperationTable rename to TempRuleOperationTable;
				
				CREATE TABLE RULEOPERATIONTABLE(
					ProcessDefId 	 	INTEGER			NOT NULL, 
					ActivityId       	INTEGER       	NOT NULL, 
					RuleType            VARCHAR(1)    	NOT NULL, 
					RuleId              INTEGER       	NOT NULL, 
					OperationType       INTEGER       	NOT NULL, 
					Param1				VARCHAR(50)   	NOT NULL, 
					Type1               VARCHAR(1)    	NOT NULL, 
					ExtObjId1	 		INTEGER			NULL,
					VariableId_1		INTEGER			NULL,
					VarFieldId_1		INTEGER			NULL,
					Param2				VARCHAR(255)  	NOT NULL, 
					Type2               VARCHAR(1)    	NOT NULL, 
					ExtObjId2	  		INTEGER			NULL, 
					VariableId_2		INTEGER			NULL,
					VarFieldId_2		INTEGER			NULL,
					Param3              VARCHAR(255)	NULL, 
					Type3               VARCHAR(1)		NULL, 
					ExtObjId3	   		INTEGER	   		NULL,
					VariableId_3		INTEGER			NULL,
					VarFieldId_3		INTEGER			NULL,
					Operator            INTEGER 		NOT NULL, 
					OperationOrderId    INTEGER       	NOT NULL, 
					CommentFlag         VARCHAR(1)    	NULL, 
					RuleCalFlag			VARCHAR(1)		NULL,
					FunctionType		VARCHAR(1)		NOT NULL	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L'')),
					PRIMARY KEY(ProcessDefId, ActivityId, RuleType, RuleId,OperationOrderId)
				);
				
				INSERT INTO RuleOperationTable SELECT ProcessDefId, ActivityId, RuleType, RuleId, OperationType, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Param3, Type3, ExtObjID3, VariableId_3, VarFieldId_3, Operator, OperationOrderId, CommentFlag, RuleCalFlag, FunctionType FROM TempRuleOperationTable;
				
				DROP TABLE TempRuleOperationTable;
				
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleOperationTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_RuleConditionTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter table RuleConditionTable rename to TempRuleConditionTable;
				
				CREATE TABLE RULECONDITIONTABLE(
					ProcessDefId 	    INTEGER			NOT NULL,
					ActivityId          INTEGER			NOT NULL,
					RuleType            VARCHAR(1)   	NOT NULL,
					RuleOrderId         INTEGER      	NOT NULL,
					RuleId              INTEGER      	NOT NULL,
					ConditionOrderId    INTEGER 		NOT NULL,
					Param1				VARCHAR(50) 	NOT NULL,
					Type1               VARCHAR(1) 		NOT NULL,
					ExtObjId1	    	INTEGER			NULL,
					VariableId_1		INTEGER			NULL,
					VarFieldId_1		INTEGER			NULL,
					Param2				VARCHAR(255) 	NOT NULL,
					Type2               VARCHAR(1) 		NOT NULL,
					ExtObjId2	    	INTEGER			NULL,
					VariableId_2		INTEGER			NULL,
					VarFieldId_2		INTEGER			NULL,
					Operator            INTEGER 		NOT NULL,
					LogicalOp           INTEGER 		NOT NULL 
				);
				
				INSERT INTO RuleConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempRuleConditionTable;
				DROP TABLE TempRuleConditionTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleConditionTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');

			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_ExtMethodParamMappingTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table ExtMethodParamMappingTable rename to TempExtMethodParamMappingTable;
				
				CREATE TABLE EXTMETHODPARAMMAPPINGTABLE(
					ProcessDefId			INTEGER		NOT NULL, 
					ActivityId				INTEGER		NOT NULL,
					RuleId					INTEGER		NOT NULL,
					RuleOperationOrderId	INTEGER		NOT NULL,
					ExtMethodIndex			INTEGER		NOT NULL,
					MapType					VARCHAR(1)	CHECK(MapType IN (''F'', ''R'')),
					ExtMethodParamIndex		INTEGER		NOT NULL,
					MappedField				VARCHAR(255),
					MappedFieldType			VARCHAR(1)	CHECK(MappedFieldType IN(''Q'', ''F'', ''C'', ''S'', ''I'', ''M'', ''U'')),
					VariableId				INTEGER,
					VarFieldId				INTEGER,
					DataStructureId			INTEGER
				);
				
				INSERT INTO ExtMethodParamMappingTable SELECT ProcessDefId, ActivityId, RuleId, RuleOperationOrderId, ExtMethodIndex, MapType, ExtMethodParamIndex, MappedField, MappedFieldType, VariableId, VarFieldId, DataStructureId FROM TempExtMethodParamMappingTable;
				DROP TABLE TempExtMethodParamMappingTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ExtMethodParamMappingTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_ActionConditionTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table ActionConditionTable rename to TempActionConditionTable;
				
				CREATE TABLE ACTIONCONDITIONTABLE(
					ProcessDefId            INTEGER			NOT NULL,
					ActivityId              INTEGER			NOT NULL,
					RuleType				VARCHAR(1)		NOT NULL,
					RuleOrderId				INTEGER			NOT NULL,
					RuleId					INTEGER			NOT NULL,
					ConditionOrderId		INTEGER			NOT NULL,
					Param1					VARCHAR(50)		NOT NULL,
					Type1					VARCHAR(1)		NOT NULL,
					ExtObjId1				INTEGER			NULL,
					VariableId_1			INTEGER			NULL,
					VarFieldId_1			INTEGER			NULL,
					Param2					VARCHAR(255)	NOT NULL,
					Type2					VARCHAR(1)      NOT NULL,
					ExtObjId2				INTEGER			NULL,
					VariableId_2			INTEGER			NULL,
					VarFieldId_2			INTEGER			NULL,
					Operator				INTEGER         NOT NULL,
					LogicalOp				INTEGER         NOT NULL
				);
				
				INSERT INTO ActionConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempActionConditionTable;
				
				DROP TABLE TempActionConditionTable;
				
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ActionConditionTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_MailTriggerTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table MailTriggerTable rename to TempMailTriggerTable;
				
				CREATE TABLE MAILTRIGGERTABLE( 
					ProcessDefId 		INTEGER 		NOT NULL,
					TriggerId 			INTEGER 		NOT NULL,
					Subject 			VARCHAR(255) 	NULL,
					FromUser			VARCHAR(255)	NULL,
					FromUserType		VARCHAR(1)		NULL,
					ExtObjIdFromUser 	INTEGER 		NULL,
					VariableIdFrom		INTEGER			NULL,
					VarFieldIdFrom		INTEGER			NULL,
					ToUser				VARCHAR(255)	NOT NULL,
					ToType				VARCHAR(1)		NOT NULL,
					ExtObjIdTo			INTEGER			NULL,
					VariableIdTo		INTEGER			NULL,
					VarFieldIdTo		INTEGER			NULL,
					CCUser				VARCHAR(255)	NULL,
					CCType				VARCHAR(1)		NULL,
					ExtObjIdCC			INTEGER			NULL,	
					VariableIdCc		INTEGER			NULL,
					VarFieldIdCc		INTEGER			NULL,
					Message				TEXT			NULL,
					PRIMARY KEY(ProcessdefId, TriggerId)
				);
				
				INSERT INTO MailTriggerTable SELECT ProcessDefId, TriggerID, Subject, FromUser, FromUserType, ExtObjIDFromUser, VariableIdFrom, VarFieldIdFrom, ToUser, ToType, ExtObjIDTo, VariableIdTo, VarFieldIdTo, CCUser, CCType, ExtObjIDCC, VariableIdCc, VarFieldIdCc, Message FROM TempMailTriggerTable;
					DROP TABLE TempMailTriggerTable;
					INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_MailTriggerTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,  N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion  FROM WFCabVersionTable WHERE CabVersion = ''7.2_DataSetTriggerTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table DataSetTriggerTable rename to TempDataSetTriggerTable;
				
				CREATE TABLE DATASETTRIGGERTABLE( 
					ProcessDefId 	INTEGER 		NOT NULL,
					TriggerId 		INTEGER 		NOT NULL,
					Param1			VARCHAR(50)		NOT NULL,
					Type1			VARCHAR(1)		NOT NULL,
					ExtObjId1		INTEGER			NULL,
					VariableId_1	INTEGER					NULL,
					VarFieldId_1	INTEGER					NULL,
					Param2			VARCHAR(255) 	NOT NULL,
					Type2			VARCHAR(1)		NOT NULL,
					ExtObjId2		INTEGER			NULL,
					VariableId_2	INTEGER					NULL,
					VarFieldId_2	INTEGER					NULL
				);
				
				INSERT INTO DataSetTriggerTable SELECT ProcessDefId, TriggerID, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2 FROM TempDataSetTriggerTable;
				DROP TABLE TempDataSetTriggerTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_DataSetTriggerTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion  FROM WFCabVersionTable WHERE CabVersion = ''7.2_PrintFaxEmailTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table PrintFaxEmailTable rename to TempPrintFaxEmailTable;
				
				CREATE TABLE PRINTFAXEMAILTABLE(
					ProcessDefId            INTEGER			NOT NULL,
					PFEInterfaceId          INTEGER			NOT NULL,
					InstrumentData          VARCHAR(1)		NULL,
					FitToPage               VARCHAR(1)		NULL,
					Annotations             VARCHAR(1)		NULL,
					FaxNo                   VARCHAR(255)	NULL,
					FaxNoType               VARCHAR(1)		NULL,
					ExtFaxNoId              INTEGER			NULL,
					VariableIdFax			INTEGER			NULL,
					VarFieldIdFax			INTEGER			NULL,
					CoverSheet              VARCHAR(50)		NULL,
					CoverSheetBuffer        OID				NULL,
					ToUser                  VARCHAR(255)	NULL,
					FromUser                VARCHAR(255)	NULL,
					ToMailId                VARCHAR(255)	NULL,
					ToMailIdType            VARCHAR(1)		NULL,
					ExtToMailId             INTEGER			NULL,
					VariableIdTo			INTEGER			NULL,
					VarFieldIdTo			INTEGER			NULL,
					CCMailId                VARCHAR(255)	NULL,
					CCMailIdType            VARCHAR(1)		NULL,
					ExtCCMailId             INTEGER			NULL,
					VariableIdCc			INTEGER			NULL,
					VarFieldIdCc			INTEGER			NULL,
					SenderMailId            VARCHAR(255)	NULL,
					SenderMailIdType        VARCHAR(1)		NULL,
					ExtSenderMailId         INTEGER			NULL,
					VariableIdFrom			INTEGER			NULL,
					VarFieldIdFrom			INTEGER			NULL,
					Message                 TEXT			NULL,
					Subject                 VARCHAR(255)	NULL
				);
				
				INSERT INTO PrintFaxEmailTable SELECT ProcessDefId, PFEInterfaceId, InstrumentData, FitToPage, Annotations, FaxNo, FaxNoType, ExtFaxNoId, VariableIdFax, VarFieldIdFax, CoverSheet, CoverSheetBuffer, ToUser, FromUser, ToMailId, ToMailIdType, ExtToMailId, VariableIdTo, VarFieldIdTo, CCMailId, CCMailIdType, ExtCCMailId, VariableIdCc, VarFieldIdCc, SenderMailId, SenderMailIdType, ExtSenderMailId, VariableIdFrom, VarFieldIdFrom, Message, Subject FROM TempPrintFaxEmailTable;
				DROP TABLE TempPrintFaxEmailTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_PrintFaxEmailTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_ScanActionsTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table ScanActionsTable rename to TempScanActionsTable;
				
				CREATE TABLE SCANACTIONSTABLE(
					ProcessDefId		INTEGER         NOT NULL,
					DocTypeId			INTEGER         NOT NULL,
					ActivityId			INTEGER         NOT NULL,
					Param1				VARCHAR(50)		NOT NULL,
					Type1				VARCHAR(1)		NOT NULL,
					ExtObjId1			INTEGER         NOT NULL,
					VariableId_1		INTEGER					NULL,
					VarFieldId_1		INTEGER					NULL,
					Param2				VARCHAR(255)	NOT NULL,
					Type2				VARCHAR(1)		NOT NULL,
					ExtObjId2			INTEGER			NOT NULL,
					VariableId_2		INTEGER					NULL,
					VarFieldId_2		INTEGER					NULL
				);
				
				INSERT INTO ScanActionsTable SELECT ProcessDefId, DocTypeId, ActivityId, Param1, Type1, ExtObjId1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjId2, VariableId_2, VarFieldId_2 FROM TempScanActionsTable;
				DROP TABLE TempScanActionsTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ScanActionsTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_ToDoListDefTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table ToDoListDefTable rename to TempToDoListDefTable;
				
				CREATE TABLE TODOLISTDEFTABLE(
					ProcessDefId		INTEGER			NOT NULL,
					ToDoId				INTEGER			NOT NULL,
					ToDoName			VARCHAR(255)	NOT NULL,
					Description			VARCHAR(255)	NOT NULL,
					Mandatory			VARCHAR(1)		NOT NULL,
					ViewType			VARCHAR(1)		NULL,
					AssociatedField		VARCHAR(255)	NULL,
					ExtObjId			INTEGER			NULL,
					VariableId			INTEGER			NULL,
					VarFieldId			INTEGER			NULL,
					TriggerName			VARCHAR(50)		NULL
				);
				
				INSERT INTO ToDoListDefTable SELECT ProcessDefId, ToDoId, ToDoName, Description, Mandatory, ViewType, AssociatedField, ExtObjID, VariableId, VarFieldId, TriggerName FROM TempToDoListDefTable;
				DROP TABLE TempToDoListDefTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ToDoListDefTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_ImportedProcessDefTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table ImportedProcessDefTable rename to TempImportedProcessDefTable;
				
				CREATE TABLE IMPORTEDPROCESSDEFTABLE(
					ProcessDefId 			INTEGER 			NOT NULL,
					ActivityId				INTEGER				NOT NULL,
					ImportedProcessName 	VARCHAR(30)			NOT NULL,
					ImportedFieldName 		VARCHAR(63)			NOT NULL,
					FieldDataType			INTEGER				NULL,	
					FieldType				VARCHAR(1)			NOT NULL,
					VariableId				INTEGER				NULL,
					VarFieldId				INTEGER				NULL,
					DisplayName				VARCHAR(2000)		NULL
				);
				
				INSERT INTO ImportedProcessDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, FieldDataType, FieldType, VariableId, VarFieldId, DisplayName FROM TempImportedProcessDefTable;
				DROP TABLE TempImportedProcessDefTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ImportedProcessDefTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_InitiateWorkitemDefTable'';
		IF(NOT FOUND) THEN
			BEGIN				
				Alter Table InitiateWorkitemDefTable rename to TempInitiateWorkitemDefTable;
				
				CREATE TABLE INITIATEWORKITEMDEFTABLE( 
					ProcessDefId 		INTEGER				NOT NULL,
					ActivityId			INTEGER				NOT NULL,
					ImportedProcessName VARCHAR(30)			NOT NULL,
					ImportedFieldName 	VARCHAR(63)			NOT NULL,
					ImportedVariableId	INTEGER				NULL,
					ImportedVarFieldId	INTEGER				NULL,
					MappedFieldName		VARCHAR(63)			NOT NULL,	
					MappedVariableId	INTEGER 			NULL,
					MappedVarFieldId	INTEGER				NULL,
					FieldType			VARCHAR(1)			NOT NULL,
					MapType				VARCHAR(1)			NULL,
					DisplayName			VARCHAR(2000)		NULL	
				);
				
				INSERT INTO InitiateWorkitemDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, ImportedVariableId, ImportedVarFieldId, MappedFieldName, MappedVariableId, MappedVarFieldId, FieldType, MapType, DisplayName FROM TempInitiateWorkitemDefTable;
				DROP TABLE TempInitiateWorkitemDefTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_InitiateWorkitemDefTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''Complex Data Type Support'', N''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_WFDurationTable'';
		IF(NOT FOUND) THEN
			BEGIN
				BEGIN
					Alter Table WFDurationTable DROP CONSTRAINT UK_WFDurationTable;
				END;
				
				Alter Table WFDurationTable rename to TempWFDurationTable;
				
				CREATE TABLE WFDurationTable(
					ProcessDefId		INTEGER			NOT NULL,
					DurationId			INTEGER			NOT NULL,
					WFYears				VARCHAR(256),
					VariableId_Years	INTEGER	,
					VarFieldId_Years	INTEGER	,
					WFMonths			VARCHAR(256),
					VariableId_Months   INTEGER	,
					VarFieldId_Months	INTEGER	,
					WFDays				VARCHAR(256),
					VariableId_Days		INTEGER	,
					VarFieldId_Days		INTEGER	,
					WFHours				VARCHAR(256), 
					VariableId_Hours	INTEGER	,
					VarFieldId_Hours	INTEGER	,
					WFMinutes			VARCHAR(256), 
					VariableId_Minutes	INTEGER	,
					VarFieldId_Minutes	INTEGER	,
					WFSeconds			VARCHAR(256),
					VariableId_Seconds	INTEGER	,
					VarFieldId_Seconds	INTEGER	,
					CONSTRAINT UK_WFDurationTable UNIQUE(ProcessDefId, DurationId)
				);
				
				INSERT INTO WFDurationTable SELECT ProcessDefId, DurationId, WFYears, VariableId_Years, VarFieldId_Years, WFMonths, VariableId_Months, VarFieldId_Months, WFDays, VariableId_Days, VarFieldId_Days, WFHours, VariableId_Hours, VarFieldId_Hours, WFMinutes, VariableId_Minutes, VarFieldId_Minutes, WFSeconds, VariableId_Seconds, VarFieldId_Seconds FROM TempWFDurationTable;
				DROP TABLE TempWFDurationTable;					  
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_WFDurationTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;
		END IF;
	END;

	BEGIN
		v_QueryStr := ''SELECT DivertedUserIndex, AssignedUserIndex FROM Userdiversiontable'';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_DivertedUserIndex, v_AssignedUserIndex;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			SELECT INTO v_AssignedUserName AssignedUserName FROM UserDiversionTable
			where AssignedUserIndex = v_AssignedUserIndex
			and DivertedUserIndex = v_DivertedUserIndex; 
			
			SELECT INTO v_DivertedUserName DivertedUserName FROM UserDiversionTable
			where AssignedUserIndex = v_AssignedUserIndex ||
			and DivertedUserIndex = v_DivertedUserIndex; 
			
			IF(v_DivertedUserName IS NULL or v_AssignedUserName IS NULL) THEN
				BEGIN
					SELECT INTO v_DivUserName UserName  FROM WFUserView
					WHERE userindex = v_DivertedUserIndex;

					SELECT INTO v_AssUserName UserName FROM WFUserView
					WHERE userindex = v_AssignedUserIndex;

					v_STR1 := '' UPDATE UserDiversionTable SET DivertedUserName = '' || v_DivUserName ||
							  '' WHERE DivertedUserIndex = '' || v_DivertedUserIndex;
					v_STR2 := '' UPDATE UserDiversionTable SET AssignedUserName = '' || v_AssUserName ||
							  '' WHERE AssignedUserIndex = '' || v_AssignedUserIndex;
					
					EXECUTE v_str1;
					EXECUTE v_str2;	
				END;
			END IF;
		END LOOP;
		CLOSE v_Cursor;		
	END;
		
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_UserDiversionTable'';
		IF(NOT FOUND) THEN
			BEGIN
				v_QueryStr := ''select CONNAME FROM pg_constraint, pg_class where relname = ''''userdiversiontable'''' AND conrelid = pg_class.oid'';
				OPEN v_Cursor FOR EXECUTE v_QueryStr;
				LOOP
					FETCH v_Cursor INTO v_constraintName;
					IF(NOT FOUND) THEN
						EXIT;
					END IF;
					EXECUTE ''Alter Table UserDiversionTable Drop Constraint '' || v_constraintName;
				END LOOP;
				CLOSE v_Cursor;
				
				Alter Table UserDiversionTable rename to TEMP_UserDiversionTable;
				
				CREATE TABLE USERDIVERSIONTABLE( 
					DivertedUserIndex 		INTEGER, 
					DivertedUserName		VARCHAR(64), 
					AssignedUserindex 		INTEGER, 
					AssignedUserName		VARCHAR(64), 
					FromDate				TIMESTAMP, 
					ToDate					TIMESTAMP, 
					CurrentWorkItemsFlag 	VARCHAR(1) CHECK(CurrentWorkItemsFlag  IN (''Y'', ''N'')),
					CONSTRAINT Pk_UserDiversion PRIMARY KEY(DivertedUserIndex, AssignedUserIndex, FromDate) 
				);
				
				INSERT INTO UserDiversionTable SELECT Diverteduserindex, DivertedUserName, AssignedUserindex, AssignedUserName, fromdate, todate, currentworkitemsflag FROM TEMP_UserDiversionTable;
				DROP Table TEMP_UserDiversionTable;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_UserDiversionTable'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N''BPEL Compliant OmniFlow'', N''Y'');
			END;			
		END IF;
	END;
		
	BEGIN	
		v_QueryStr := ''select CONNAME, CONSRC FROM pg_constraint, pg_class where relname = ''''extmethoddeftable''''
AND conrelid = pg_class.oid and consrc LIKE ''''%extapptype%'''' '';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_constraintName, v_search_Condition;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			EXECUTE ''ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT '' || v_constraintName;
		END LOOP;
		CLOSE v_Cursor;
		
		BEGIN
			SELECT 1 INTO existflag
			from pg_constraint where conname = LOWER(''CK_EXTMETHOD_EXTAP'');
			IF(NOT FOUND) THEN
				ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_EXTAP CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z''));
			END IF;			
		END;				
	END;
	
	BEGIN	
		v_QueryStr := ''SELECT ProcessDefId, ActivityId FROM ActivityTable WHERE ActivityType = 11'';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_processDefId, v_activityId;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			BEGIN
				SELECT INTO v_queueId QueueId FROM QueueStreamTable WHERE ProcessDefid =  v_processdefid AND ActivityId = v_activityId;
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount > 0) THEN
					SELECT INTO v_queueType QueueType FROM QueueDefTable WHERE QueueId = v_queueId;
					IF(v_queueType != ''Q'') THEN
						UPDATE QueueDefTable SET QueueType = ''Q'' WHERE QueueId = v_QueueId;
					END IF;
				END IF;
			END;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	BEGIN	
		v_QueryStr := ''SELECT ProcessDefId, ActivityId FROM WFJMSSubscribeTable'';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_processDefId, v_activityId;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			BEGIN
				SELECT INTO v_activityType ActivityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId; 
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount > 0) THEN
					IF(v_activityType != 21) THEN 
						UPDATE ActivityTable SET ActivityType = 21 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
					END IF;
				END IF;
			END;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	BEGIN	
		v_QueryStr := ''SELECT ProcessDefId, ActivityId FROM WFWebServiceTable'';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_processDefId, v_activityId;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			BEGIN
				SELECT INTO v_activityType ActivityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount > 0) THEN
					IF(v_activityType != 22) THEN
						UPDATE ActivityTable SET ActivityType = 22 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
					END IF;	
				END IF;
			END;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	BEGIN	
		v_QueryStr := ''Select ProcessDefID, ActivityID From ActivityTable Where ActivityType = 1 '' ||
					  '' and PrimaryActivity = ''''Y'''' '';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_ProcessDefID, v_DefaultIntroductionActID;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			v_QuerySearch := ''Select FieldName From ActivityAssociationTable Where ProcessDefID = '' || v_ProcessDefID || 
							 '' And ActivityID = '' || v_DefaultIntroductionActID || 
							 '' And DefinitionType in ( ''''I'''' , ''''Q'''' , ''''N'''' ) And Attribute in ( ''''O'''', ''''B'''' , ''''R'''' , ''''M'''' ) '';			
			OPEN v_CursorSearch FOR EXECUTE v_QuerySearch;
			v_OrderId := 1;
			LOOP
				FETCH v_CursorSearch INTO v_fieldName;
				IF(NOT FOUND) THEN
					EXIT;
				END IF;
				INSERT INTO WFSearchVariableTable(ProcessDefID, ActivityID, FieldName, Scope, OrderID) VALUES (v_ProcessDefID, v_DefaultIntroductionActID, v_fieldName, ''C'', v_OrderID);
				INSERT INTO WFSearchVariableTable(ProcessDefID, ActivityID, FieldName, Scope, OrderID) VALUES (v_ProcessDefID, v_DefaultIntroductionActID, v_fieldName, ''R'', v_OrderID);
				v_OrderId := v_OrderId + 1;
			END LOOP;
			CLOSE v_CursorSearch;
			
			v_QueryQws := ''SELECT ActivityID FROM ActivityTable WHERE ProcessDefId = '' || v_ProcessDefID || '' AND ActivityType = 11''; 
			OPEN v_CursorQws FOR EXECUTE v_QueryQws;
			LOOP
				FETCH v_CursorQws INTO v_QueryActivityId;
				IF(NOT FOUND) THEN
					EXIT;
				END IF;
				INSERT INTO WFSearchVariableTable
				SELECT ProcessdefId, v_QueryActivityId, FieldName, Scope, OrderId 
				FROM wfsearchVariableTable
				WHERE ProcessDefId = v_ProcessDefID  AND ActivityId = v_DefaultIntroductionActID;					
			END LOOP;
			CLOSE v_CursorQws;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	BEGIN	
		v_QueryStr := ''SELECT ActivityId FROM WFWebServiceTable WHERE InvocationType = ''''A'''' ''; 			/* ActivityId FROM WFWebServiceTable is selected*/
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_activityId;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			BEGIN
				SELECT INTO v_targetActivityId TargetActivityId FROM ActivityTable WHERE ActivityId = v_activityId;
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount > 0) THEN
					IF(v_activityType != 22) THEN
						UPDATE ActivityTable SET AssociatedActivityId = v_targetActivityId WHERE ActivityId = v_activityId;
					END IF;	
				END IF;
			END;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_STAT_USER_INDEXES WHERE indexrelname  = LOWER(''IDX1_WFWSAsyncResponseTable'');
		IF(NOT FOUND) THEN 
			CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1);	
		END IF; 
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_CalendarName_VarMapping'';
		IF(NOT FOUND) THEN
			BEGIN
				v_QueryStr := ''SELECT ProcessDefId FROM ProcessDefTable'';
				OPEN v_Cursor FOR EXECUTE v_QueryStr;
				LOOP
					FETCH v_Cursor INTO v_processDefId;
					IF(NOT FOUND) THEN
						EXIT;
					END IF;
					BEGIN
						v_STR1 := ''INSERT INTO VarMappingTable VALUES( '' || v_processDefId || 
						'' , 10001 , ''''CalendarName'''', ''''CalendarName'''', 10 , ''''M'''', 0, NULL , NULL, 0, ''''N'''') '';
						EXECUTE v_STR1;
					END;
				END LOOP;
				CLOSE v_Cursor;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (''7.2_CalendarName_VarMapping'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''OmniFlow 7.2'', ''Y'');
			END;
		END IF;
	END;
	
	BEGIN
		SELECT INTO v_cabVersion CabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_TurnAroundDateTime_VarMapping'';
		IF(NOT FOUND) THEN
			BEGIN
				v_QueryStr := ''SELECT ProcessDefId FROM ProcessDefTable'';
				OPEN v_Cursor FOR EXECUTE v_QueryStr;
				LOOP
					FETCH v_Cursor INTO v_processDefId;
					IF(NOT FOUND) THEN
						EXIT;
					END IF;
					BEGIN
						v_STR1 := ''INSERT INTO VarMappingTable VALUES( '' || v_processDefId || 
						'' , 10002 , ''''ExpectedWorkitemDelay'''', ''''TurnAroundDateTime'''', 10 , ''''M'''', 0, NULL , NULL, 0, ''''N'''') '';
						EXECUTE v_STR1;
					END;
				END LOOP;
				CLOSE v_Cursor;
				INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (''7.2_TurnAroundDateTime_VarMapping'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''OmniFlow 7.2'', ''Y'');
			END;
		END IF;
	END;

	UPDATE wfdurationtable SET VariableId_Years = 0, VarFieldId_Years = 0,
		VariableId_Months = 0, VarFieldId_Months = 0,
		VariableId_Days = 0, VarFieldId_Days = 0,
		VariableId_Hours = 0, VarFieldId_Hours = 0,
		VariableId_Minutes = 0, VarFieldId_Minutes = 0,
		VariableId_Seconds = 0, VarFieldId_Seconds = 0;		
	
return 1;
END; 
'LANGUAGE 'plpgsql';

~

SELECT UpgradeInsert();

~

DROP FUNCTION UpgradeInsert();
