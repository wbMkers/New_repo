/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : SetAndMigrateTransactionalData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for Transactional data ARCHIVAL;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
create or replace
Procedure SetAndMigrateTransactionalData
(
    v_sourceCabinet      VARCHAR2,
    v_targetCabinet      VARCHAR2,
	v_isDBLink			VARCHAR2,
    idblinkname          VARCHAR2,
	v_migrateAllProcesses	VARCHAR2,
    v_fromDate           VARCHAR2,
	v_toDate			VARCHAR2,
    v_batchSize          INTEGER,
	v_moveAuditTrailData 	VARCHAR2,
	v_moveFromHistoryData 	VARCHAR2,
	v_moveExternalProcessData 	VARCHAR2,
	v_loggingEnabled			VARCHAR2,
	v_moveTaskData        VARCHAR2,
	v_processDefidString      VARCHAR2
	)

AS
v_idblinkname VARCHAR2(400);
tableVariableMap Process_Variant_Tab_Var := Process_Variant_Tab_Var();
v_ExecutionLogId	INTEGER;
v_pos				INT; 
v_pid               INT;
v_processString VARCHAR2(400);
BEGIN
	IF ( (UPPER(v_isDBLink) NOT IN ('Y','N')) OR (UPPER(v_migrateAllProcesses) NOT IN ('Y','N')) OR (UPPER(v_moveAuditTrailData) NOT IN ('Y','N')) or (UPPER(v_moveFromHistoryData) NOT IN ('Y','N')) or (UPPER(v_moveExternalProcessData) NOT IN ('Y','N')) or (UPPER(v_loggingEnabled) NOT IN ('Y','N')) or (UPPER(v_moveTaskData) NOT IN ('Y','N')))
	THEN
		dbms_output.put_line('Invalid parameter passed');
		Raise OraExcpPkg.Excp_Invalid_Parameter;
	END IF; 

	-- Code to extract processdefids from the v_processDefidString, and pass to tableVariableMap
	v_processString := RTRIM(v_processDefidString);
	IF(v_processString is not NULL ) THEN
		WHILE LENGTH(v_processString) > 0 LOOP  
			BEGIN 
				v_pos := INSTR( v_processString,',',1); 
				IF v_pos = 0 THEN  
				BEGIN  
					v_pid := TO_NUMBER(RTRIM(v_processString));
					tableVariableMap.extend;
					tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(v_pid, 0);
					--dbms_output.put_line('processDefId : ' || v_pid);
					EXIT; 
				END;
				ELSE
				BEGIN
					v_pid := TO_NUMBER(RTRIM(SUBSTR(v_processString, 1, v_pos-1)));
					tableVariableMap.extend;
					tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(v_pid, 0);
					--dbms_output.put_line('processDefId : ' || v_pid);
					v_processString := SUBSTR(v_processString, v_pos + 1); 	
				END;
				END IF;	
			END;
		END LOOP;
	ELSE
	/*Modify SetAndMigrateTransactionalData to specify processdefid and processvariantid’s to be migrated in case you are passing v_processDefidString as Null or Blank String:*/
		dbms_output.put_line('Using default processDefIds');
		tableVariableMap.extend;
		tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(1, 1);
		tableVariableMap.extend;
		tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(1, 2);
	END IF;

IF(v_isDBLink='Y') THEN
	v_idblinkname:= '@'||idblinkname;
	ELSE
	v_idblinkname:='';
END IF;
--Print out contents of collection
FOR cur_row IN 1 .. tableVariableMap.Count LOOP
DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
END LOOP;
Select	SEQ_migrationLog.nextval INTO v_ExecutionLogId from dual; 

IF(v_moveFromHistoryData='Y') THEN
    WFMoveQueueHistoryData(v_sourceCabinet,v_targetCabinet,v_isDBLink,v_idblinkname,tableVariableMap,v_migrateAllProcesses,v_fromDate,v_toDate,v_batchSize,v_moveAuditTrailData,v_moveExternalProcessData,UPPER(v_loggingEnabled),UPPER(v_moveTaskData),v_ExecutionLogId );
  ELSE
	WFMoveTransData(v_sourceCabinet,v_targetCabinet,UPPER(v_isDBLink),v_idblinkname,tableVariableMap ,UPPER(v_migrateAllProcesses),v_fromDate,v_toDate,v_batchSize,UPPER(v_moveAuditTrailData),UPPER(v_moveExternalProcessData),UPPER(v_loggingEnabled),UPPER(v_moveTaskData),v_ExecutionLogId);
END IF;
END; 