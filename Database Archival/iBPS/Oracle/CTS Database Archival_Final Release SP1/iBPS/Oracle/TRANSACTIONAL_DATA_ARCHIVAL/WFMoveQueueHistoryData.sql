/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveQueueHistoryData.sql (Oracle)
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
PROCEDURE WFMoveQueueHistoryData

  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
	v_isDbLink		VARCHAR2,
    idblinkname     VARCHAR2,
    tableVariableMap Process_Variant_Tab_Var,
    v_migrateAllProcesses   VARCHAR2,
    v_fromDate              VARCHAR2,
    v_toDate                VARCHAR2,
    v_batchSize             INTEGER,
    v_moveAuditTrailData    VARCHAR2,
    v_moveExternalProcessData VARCHAR2,
	v_loggingEnabled		VARCHAR2,
	v_moveTaskData				VARCHAR2,
	v_ExecutionLogId		INTEGER
	)
AS
  v_processDefId     INTEGER;
  v_processVariantId	INTEGER;
  v_variantId        INTEGER;
  v_variantName      VARCHAR2(400);
  v_variantTableName VARCHAR2(400);
  v_processInstanceId NVARCHAR2(63);
  v_firstProcessInstanceId NVARCHAR2(63);
  v_lastInstanceId NVARCHAR2(63);
  v_folderIndex NVARCHAR2(255);
  v_workItemId     INT;
  v_lastWorkItemId INT;
  v_localTableVariableMap Process_Variant_Tab_Var :=Process_Variant_Tab_Var();
  v_query              VARCHAR2(4000);
  v_queryStr           VARCHAR2(4000);
  v_queryStr2           VARCHAR2(4000);
  v_externalTable      VARCHAR2(255);
  v_externalTableHistory VARCHAR2(255);

  v_externalTableCount INT;
  v_externalTableHistoryCount INT;
  v_itemIndex          INTEGER;
  existsFlag           INT;
  v_folderStatus       INT;
  v_genIndex           INT;
  v_filterQueryString  VARCHAR2(1000);
  v_dateFilterString   VARCHAR2(500);
  v_defaultToDate      Date;
  v_defaultFromDate    Date;
  v_rowNum        	   INTEGER;
  v_ErrorCode		   INTEGER;
  v_ErrorMessage	   NVARCHAR2(50);
  v_remarks 		   VARCHAR2(4000);
  v_ODDBLink		   VARCHAR2(1000);
  v_tablevariableremarks	VARCHAR2(4000);
	v_startTime 			TimeStamp;
	v_endTime 				TimeStamp;
	v_executionTime	VARCHAR2(500);
TYPE ExternalTableCursor
IS
  REF
  CURSOR;
    v_externalCursor ExternalTableCursor;
    v_colStr NVARCHAR2(4000);
    v_columnName NVARCHAR2(256);
  TYPE VCursor
IS
  REF
  CURSOR;
    v_Cursor VCursor;
    v_rowCounter INTEGER;
  TYPE processCursor
IS
  REF
  CURSOR;
    v_processCursor processCursor;
	 TYPE processVariantCursor
IS
  REF
  CURSOR;
	v_processVariantCursor processVariantCursor;
  BEGIN --1

  v_tablevariableremarks:='';
  	FOR cur_row IN 1 .. tableVariableMap.Count LOOP
		--DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
		v_tablevariableremarks:=v_tablevariableremarks||'(' ||tableVariableMap(cur_row).ProcessDefId||' --'||tableVariableMap(cur_row).ProcessVariantID||'),' ;
	END LOOP;
		   v_tablevariableremarks:=trim(trailing ',' FROM v_tablevariableremarks);

	v_remarks := 'v_sourceCabinet:'|| v_sourceCabinet||',v_targetCabinet:'|| v_targetCabinet||',idblinkname:'|| idblinkname||',tableVariableMap:'|| v_tablevariableremarks||',v_migrateAllProcesses:'   ||v_migrateAllProcesses|| ',v_fromDate:'||v_fromDate||',v_toDate:'||v_toDate ||',v_batchSize:'||v_batchSize||',v_moveAuditTrailData:'    ||v_moveAuditTrailData||',v_moveExternalProcessData:'||v_moveExternalProcessData||',v_moveTaskData:'||v_moveTaskData;

	  insert into WFMigrationLogTable(executionLogId,actionDateTime,remarks)values(v_ExecutionLogId, sysdate,'History data migration starts ,Parameters are : '|| v_remarks);
	  commit;
    WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'D',idblinkname);
    DBMS_OUTPUT.PUT_LINE('Triggers Disabled');
    v_lastInstanceId :='/0';
    BEGIN --2
      IF(v_migrateAllProcesses='Y') THEN
			v_query              := 'Select ProcessDefId from ProcessDefTable'|| idblinkname||' where ProcessType= ''S''';
			SELECT current_timeStamp INTO v_startTime FROM DUAL;
			OPEN v_processCursor FOR TO_CHAR(v_query);
			SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
			LOOP
			  FETCH v_processCursor INTO v_processdefid;
			EXIT
		   WHEN v_processCursor%NOTFOUND;
		  v_localTableVariableMap.extend;
			v_localTableVariableMap(v_localTableVariableMap.Last) := Process_Variant_Type(v_processdefid,0);
		  END LOOP;
		  CLOSE v_processCursor ;
	  v_query              := 'Select ProcessDefId from ProcessDefTable'|| idblinkname||' where ProcessType= ''M''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
        OPEN v_processCursor FOR TO_CHAR(v_query);
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
        LOOP
          FETCH v_processCursor INTO v_processdefid;
        EXIT
      WHEN v_processCursor%NOTFOUND;
		v_queryStr := 'Select ProcessVariantId FROM WFPROCESSVARIANTDEFTABLE'|| idblinkname||' where processdefid = '||v_processdefid;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
		OPEN v_processVariantCursor FOR TO_CHAR(v_queryStr);
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

		END IF;
        LOOP
          FETCH v_processVariantCursor INTO v_processVariantid;
        EXIT
      WHEN v_processVariantCursor%NOTFOUND;
        v_localTableVariableMap.extend;
        v_localTableVariableMap(v_localTableVariableMap.Last) := Process_Variant_Type(v_processdefid,v_processVariantid);
      END LOOP;
      CLOSE v_processVariantCursor ;
	  END LOOP;
	CLOSE v_processCursor ; 
    ELSE
      v_localTableVariableMap:=tableVariableMap;
    END IF;
  
    v_lastInstanceId :='/0';

    FOR cur_row IN 1 .. v_localTableVariableMap.Count
    LOOP
      DBMS_OUTPUT.put_line(v_localTableVariableMap(cur_row).ProcessDefId || ' ' || v_localTableVariableMap(cur_row).ProcessVariantId);
      v_ProcessDefId  :=v_localTableVariableMap(cur_row).ProcessDefId ;
      v_variantId     :=v_localTableVariableMap(cur_row).ProcessVariantId ;
      IF((v_variantId =0) AND (v_moveExternalProcessData='Y')) THEN

        BEGIN --3
          v_externalTable:= '';
          v_query        := 'SELECT TABLENAME FROM '|| v_sourcecabinet ||'.EXTDBCONFTABLE'||idblinkname||' where ProcessDefId='||v_ProcessDefId|| ' and EXTOBJID=1 ' ;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;		  
          EXECUTE Immediate v_query INTO v_externalTable;
		  v_externalTableCount:=1;
        EXCEPTION
	
        WHEN NO_DATA_FOUND THEN
          v_externalTable:='';
		  v_externalTableCount:=0;
        END;
		v_externalTableHistory:=v_externalTable||'_History';

		BEGIN
		existsFlag := 0;
		v_externalTableHistoryCount:=1;
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER(v_externalTableHistory);
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
		v_externalTableHistory:='';
		v_externalTableHistoryCount:=0;
		END;
		
     
      END IF;

	IF(v_variantId         = 0 ) THEN
        v_filterQueryString :='';
      ELSE
        v_filterQueryString :=' and a.ProcessVariantId='||v_variantId;
      END IF;
	if(v_fromDate is null) then
		v_query:='Select Min(CreatedDateTime) from '|| v_sourcecabinet ||'.WFInstrumentTable@'||idblinkname;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;		
		Execute immediate v_query into v_defaultfromDate ;
		dbms_output.put_line (v_defaultfromDate);
		v_dateFilterString:= ' and a.CreatedDateTime Between '''||v_defaultfromDate||'''';
    else 
			v_dateFilterString:= ' and a.CreatedDateTime Between '''||v_fromDate||'''';

    end if;
	if(v_toDate is null) then
		v_query:='Select (Sysdate -365) from dual';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;		
		Execute immediate v_query into v_defaultToDate ;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
    dbms_output.put_line (v_defaultToDate );  
    v_dateFilterString:= v_dateFilterString||' and '''||v_defaultToDate||'''';
    else
	v_dateFilterString:= v_dateFilterString||' and '''||v_toDate||'''';
    end if;


	FOR loop_counter IN  REVERSE 4..6 --For loop starts
      LOOP
		WHILE(1=1)
			LOOP
		v_query    := 'Select processinstanceid,VAR_REC_1,rn FROM(
						SELECT a.processinstanceid,a.VAR_REC_1,RowNum as rn FROM '|| v_sourcecabinet ||'.queuehistorytable'||idblinkname||' a WHERE  a.processinstancestate ='||loop_counter||v_dateFilterString||' and a.workitemid=1 and a.ProcessDefId='||v_ProcessDefId||v_filterQueryString||' order by processInstanceState, createdDateTime, processInstanceId,workitemId, ProcessDefId) where rn <='||v_batchSize;
        v_queryStr := 'Select count(*) FROM(
						SELECT a.processinstanceid,a.VAR_REC_1,RowNum as rn FROM '|| v_sourcecabinet ||'.queuehistorytable'||idblinkname||' a WHERE  a.processinstancestate ='||loop_counter||v_dateFilterString||' and a.workitemid=1 and a.ProcessDefId='||v_ProcessDefId||v_filterQueryString||' order by processInstanceState, createdDateTime, processInstanceId,workitemId, ProcessDefId) where rn <='||v_batchSize;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;				
        EXECUTE Immediate v_queryStr INTO v_rowCounter;
		 SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		v_firstProcessInstanceId:='';
		IF(v_cursor%ISOPEN) THEN
			close v_cursor;
		END IF;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
        OPEN v_cursor FOR TO_CHAR(v_query);
        LOOP
          FETCH v_cursor INTO v_processInstanceId,v_folderIndex,v_rowNum;
          EXIT
        WHEN v_cursor%NOTFOUND;
          IF v_folderIndex  IS NULL THEN
          --  v_lastInstanceId:=v_processInstanceId;
          --CONTINUE;
		  dbms_output.put_line('Folder index for ProcessInstanceId '|| v_processInstanceId ||' is null which should never be the case ');
          END IF;
      	 IF(v_firstProcessInstanceId is null) THEN
            v_firstProcessInstanceId := v_processInstanceId;
          END IF;
          v_query:= 'Insert into '||v_targetCabinet||'.ToDoStatusHistoryTable Select * from '||v_sourceCabinet||'.ToDoStatusHistoryTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
		  
          v_query:= 'Delete from '||v_sourceCabinet||'.ToDoStatusHistoryTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Insert into '||v_targetCabinet||'.ExceptionHistoryTable                            
Select * from '||v_sourceCabinet||'.ExceptionHistoryTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from '||v_sourceCabinet||'.ExceptionHistoryTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
          SELECT current_timeStamp INTO v_startTime FROM DUAL;
		  EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		
		
		
		IF(v_moveTaskData='Y') THEN
		 v_query:= 'Insert into '||v_targetCabinet||'.WFTASKSTATUSHISTORYTABLE Select * from ' ||v_sourceCabinet||'.WFTASKSTATUSHISTORYTABLE'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.WFTASKSTATUSHISTORYTABLE'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
		
		 v_query:= 'Insert into '||v_targetCabinet||'.WFRTTASKINTFCASSOCHISTORY Select * from ' ||v_sourceCabinet||'.WFRTTASKINTFCASSOCHISTORY '||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.WFRTTASKINTFCASSOCHISTORY'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
		
		 v_query:= 'Insert into '||v_targetCabinet||'.RTACTIVITYINTFCASSOCHISTORY Select * from ' ||v_sourceCabinet||'.RTACTIVITYINTFCASSOCHISTORY
'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.RTACTIVITYINTFCASSOCHISTORY'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
			IF(v_loggingEnabled='Y') THEN
				INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
			END IF;
		
		END IF;
		
		
          IF((v_variantId=0) AND (v_moveExternalProcessData='Y')) THEN
				IF(v_externalTableCount>0) THEN
					v_query             := 'Insert into '||v_targetCabinet||'.'||v_externalTable||' Select * from '||v_sourceCabinet||'.'||v_externalTable||''||idblinkname||' where  ItemIndex = '''||v_folderIndex ||'''';
					SELECT current_timeStamp INTO v_startTime FROM DUAL;
					EXECUTE Immediate v_query ;
					SELECT current_timeStamp INTO v_endTime FROM DUAL; 
					v_executionTime:=v_endTime-v_startTime;
					IF(v_loggingEnabled='Y') THEN
						INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
					END IF;
					v_query := 'Delete from '||v_sourceCabinet||'.'||v_externalTable||idblinkname||' where  ItemIndex = '''||v_folderIndex ||'''';
					SELECT current_timeStamp INTO v_startTime FROM DUAL;
					EXECUTE Immediate v_query ;
					SELECT current_timeStamp INTO v_endTime FROM DUAL; 
					v_executionTime:=v_endTime-v_startTime;
					IF(v_loggingEnabled='Y') THEN
						INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
					END IF;
				END IF;
				
				IF(v_externalTableHistoryCount>0) THEN
					v_query             := 'Insert into '||v_targetCabinet||'.'||v_externalTableHistory||' Select * from '||v_sourceCabinet||'.'||v_externalTableHistory||''||idblinkname||' where  ItemIndex = '''||v_folderIndex ||'''';
					SELECT current_timeStamp INTO v_startTime FROM DUAL;
					EXECUTE Immediate v_query ;
					SELECT current_timeStamp INTO v_endTime FROM DUAL; 
					v_executionTime:=v_endTime-v_startTime;
					IF(v_loggingEnabled='Y') THEN
						INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
					END IF;
					v_query := 'Delete from '||v_sourceCabinet||'.'||v_externalTableHistory||idblinkname||' where  ItemIndex = '''||v_folderIndex ||'''';
					SELECT current_timeStamp INTO v_startTime FROM DUAL;
					EXECUTE Immediate v_query ;
					SELECT current_timeStamp INTO v_endTime FROM DUAL; 
					v_executionTime:=v_endTime-v_startTime;
					IF(v_loggingEnabled='Y') THEN
						INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
					END IF;
				END IF;
			

				/* ELSE
            WFMoveVariantData(v_processInstanceId,v_variantTableName,v_sourceCabinet,v_targetCabinet,idblinkname) ; */
          END IF;
		  v_query:= 'Insert into '||v_targetCabinet||'.QueueHistoryTable Select * from ' ||v_sourceCabinet||'.QueueHistoryTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.QueueHistoryTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          IF(v_moveExternalProcessData='Y') THEN
            WFMoveComplexData(v_processInstanceId,v_processDefId,v_variantId,v_sourceCabinet,v_targetCabinet,idblinkname,'Y',v_executionLogId,v_loggingEnabled) ;
          END IF;
          IF((v_moveAuditTrailData!='N') AND (v_moveAuditTrailData!='n') )THEN
            WFMoveHistoryAuditTrailData(v_processInstanceId,v_processDefId,v_sourceCabinet,v_targetCabinet,idblinkname,v_fromDate,v_toDate,v_executionLogId,v_loggingEnabled) ;
          END IF;
		  IF(v_isDbLink = 'Y') THEN 
		  v_ODDBLink:= idblinkname;
		  v_ODDBLink:= trim(leading '@' FROM v_ODDBLink); 
		  ELSE
		  v_ODDBLink:='';
		  END IF;
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
          MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDbLink, v_ODDBLink,TO_NUMBER(v_folderIndex), 'Y','N','Y',v_genIndex,v_folderStatus);
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		 INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,'Call Procedure MoveDocDB',v_endTime,v_executionTime);
          IF (v_folderStatus <> 0) THEN
            ROLLBACK;
            dbms_output.put_line('Error code while migrating folder '||v_folderIndex|| 'is ' || v_folderStatus);
            RETURN;
          END IF;
          v_lastInstanceId:=v_processInstanceId;
        END LOOP; --end of loop for v_cursor
		IF(v_rowCounter=0) THEN
          CLOSE v_cursor;
          EXIT;
        END IF;
		Insert into WFTxnDataMigrationProgressLog(ExecutionLogId,actionDateTime,ProcessDefId,BatchStartProcessInstanceId,BatchEndProcessInstanceId,Remarks) values (v_ExecutionLogId,sysdate,v_processDefId,v_firstProcessInstanceId,v_lastInstanceId,'History Data Migration');
		COMMIT; 
  		END LOOP; --For loop ends
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('Stored Procedure WFMoveQueueHistoryData executed successfully for '|| v_processDefId);
    END LOOP ; --table variable loop 
   DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
  WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
  DBMS_OUTPUT.PUT_LINE('Stored Procedure executed successfully........');

EXCEPTION
WHEN OTHERS THEN
  BEGIN
      v_ErrorCode:= SQLCODE;
      v_ErrorMessage:=SQLERRM;								
	  DBMS_OUTPUT.PUT_LINE('Error Code : '||v_ErrorCode);
	  DBMS_OUTPUT.PUT_LINE('v_ErrorMessage : '||v_ErrorMessage);
      v_remarks:= 'History Data Migration Failed . Error Code is '|| v_ErrorCode ||' and Error message is '||v_ErrorMessage;
    ROLLBACK;
    INSERT INTO WFFailedTxnDataMigrationLog(ExecutionLogId,actionDateTime,ProcessDefId,ProcessInstanceId,Remarks) VALUES (v_ExecutionLogId, sysdate, v_processDefId,v_processInstanceId,'History Data Migration');
    commit;
    WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
  	DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
    DBMS_OUTPUT.PUT_LINE('Check!! Check!! An Exception occurred while execution of Stored WFMoveTransData WFTransferData........');
    RAISE;
  END; 
END; 
END;
