/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveTransData.sql (Oracle)
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
/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveTransData.sql (Oracle)
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
PROCEDURE WFMoveTransData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
	v_isDBLink		VARCHAR2,	
    idblinkname     VARCHAR2,
    tableVariableMap Process_Variant_Tab_Var,
    v_migrateAllProcesses   VARCHAR2,
    v_fromDate              VARCHAR2,
    v_toDate                VARCHAR2,
    v_batchSize             INTEGER,
    v_moveAuditTrailData    VARCHAR2,
    v_moveExternalProcessData VARCHAR2,
	v_loggingEnabled			VARCHAR2,
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
  v_externalTable      VARCHAR2(255);
  v_tablevariableremarks	VARCHAR2(4000);
  v_externalTableCount INT;
  v_itemIndex          INTEGER;
  existsFlag           INT;
  v_folderStatus       INT;
  v_genIndex           INT;
  v_filterQueryString  VARCHAR2(1000);
  v_dateFilterString   VARCHAR2(500);
  v_defaultToDate                   Date;
  v_defaultFromDate                   Date;
  v_count 			   INT;
  v_ErrorCode								INTEGER;
  v_ErrorMessage							NVARCHAR2(50);
  v_remarks 			VARCHAR2(4000);
  v_ODDBLink			VARCHAR2(1000);
  v_rowNum				INTEGER;
  v_startTime			TimeStamp;
  v_endTime				TimeStamp;
  v_executionTime		VARCHAR2(500);
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
	TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
  BEGIN --1
	--Fetch common columns of WFInstrumentTable and QueueHistoryTable for movement only once 
	v_query := 'SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER(''WFInstrumentTable'') AND OWNER = UPPER(''' || v_targetCabinet || ''')
			 Intersect SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER(''QueueHistoryTable'') AND OWNER = UPPER(''' || v_targetCabinet || ''')';
			  OPEN v_ColumnCursor FOR TO_CHAR(v_query);
			  v_colStr := '';
			  LOOP
				FETCH v_ColumnCursor INTO v_columnName;
			  EXIT
			WHEN v_ColumnCursor%NOTFOUND;
			  v_colStr := v_colStr ||v_columnName||',';
			END LOOP;
			v_colStr:=trim(trailing ',' FROM v_colStr);
			CLOSE v_ColumnCursor;
  
  v_tablevariableremarks:='';
	FOR cur_row IN 1 .. tableVariableMap.Count LOOP
		--DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
		v_tablevariableremarks:=v_tablevariableremarks||'(' ||tableVariableMap(cur_row).ProcessDefId||' --'||tableVariableMap(cur_row).ProcessVariantID||'),' ;
	END LOOP;
		   v_tablevariableremarks:=trim(trailing ',' FROM v_tablevariableremarks);

	v_remarks := 'v_sourceCabinet:'|| v_sourceCabinet||',v_targetCabinet:'|| v_targetCabinet||',idblinkname:'|| idblinkname||',tableVariableMap:'|| v_tablevariableremarks||',v_migrateAllProcesses:'   ||v_migrateAllProcesses|| ',v_fromDate:'||v_fromDate||',v_toDate:'||v_toDate ||',v_batchSize:'||v_batchSize||',v_moveAuditTrailData:'    ||v_moveAuditTrailData||',v_moveFromHistoryData:''N'',v_moveExternalProcessData:'||v_moveExternalProcessData||',v_moveTaskData:'||v_moveTaskData;
		
  	  insert into WFMigrationLogTable(ExecutionLogId,actionDateTime,remarks) values(v_executionLogId, sysdate,'Transactional migration starts ,Parameters are : '|| v_remarks);
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
		 SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_externalTable:='';
        END;  --3 
		v_query := 'SELECT count(TABLENAME) FROM '|| v_sourcecabinet ||'.EXTDBCONFTABLE'||idblinkname||' where ProcessDefId='||v_ProcessDefId|| ' and EXTOBJID=1 ';
	    SELECT current_timeStamp INTO v_startTime FROM DUAL;
        EXECUTE Immediate v_query INTO v_externalTableCount;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
      END IF;
      IF(v_variantId         = 0 ) THEN
        v_filterQueryString :='';
      ELSE
        v_filterQueryString :=' and a.ProcessVariantId='||v_variantId;
      END IF;
	if(v_fromDate is null) then
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
		v_query:='Select Min(CreatedDateTime) from '|| v_sourcecabinet ||'.WFInstrumentTable@'||idblinkname;
		Execute immediate v_query into v_defaultfromDate ;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		dbms_output.put_line (v_defaultfromDate);
		v_dateFilterString:= ' and a.CreatedDateTime Between '''||v_defaultfromDate||'''';
    else 
		v_dateFilterString:= ' and a.CreatedDateTime Between '''||v_fromDate||'''';
       -- v_dateFilterString:= ' and  a.CreatedDateTime >to_date( '''||v_fromDate||''''||',''DD-MM-YYYY'')   ';
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
		v_dateFilterString:= v_dateFilterString|| ' and  '''||v_toDate||'''';
	end if;
	  
	  
    FOR loop_counter IN  REVERSE 4..6  --For Loop starts
      LOOP
	    WHILE(1=1)	   
			LOOP
        v_query    := 'Select processinstanceid,VAR_REC_1,rn FROM(
						SELECT a.processinstanceid,a.VAR_REC_1,RowNum as rn FROM '|| v_sourcecabinet ||'.WFInstrumentTable'||idblinkname||' a WHERE  a.processinstancestate ='||loop_counter||v_dateFilterString||' and a.workitemid=1 and a.ProcessDefId='||v_ProcessDefId||v_filterQueryString||' order by processInstanceState, createdDateTime, processInstanceId,workitemId, ProcessDefId) where rn <='||v_batchSize;
        v_queryStr := 'Select count(*) FROM(
						SELECT a.processinstanceid,a.VAR_REC_1,RowNum as rn FROM '|| v_sourcecabinet ||'.WFInstrumentTable'||idblinkname||' a WHERE  a.processinstancestate ='||loop_counter||v_dateFilterString||' and a.workitemid=1 and a.ProcessDefId='||v_ProcessDefId||v_filterQueryString||' order by processInstanceState, createdDateTime, processInstanceId,workitemId, ProcessDefId) where rn <='||v_batchSize;
						
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
        EXECUTE Immediate v_queryStr INTO v_rowCounter;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

		END IF;
		v_firstProcessInstanceId:='';
		IF(v_cursor%ISOPEN) THEN
			close v_cursor;
		END IF;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
        OPEN v_cursor FOR TO_CHAR(v_query);
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
        LOOP
          FETCH v_cursor INTO v_processInstanceId,v_folderIndex,v_rowNum;
          EXIT
        WHEN v_cursor%NOTFOUND;
          IF v_folderIndex IS NULL THEN
            --  v_lastInstanceId:=v_processInstanceId;
            --CONTINUE;
			dbms_output.put_line('Folder index for ProcessInstanceId '|| v_processInstanceId ||' is null which should never be the case ');
          END IF;
          IF(v_firstProcessInstanceId is NULL) THEN
            v_firstProcessInstanceId := v_processInstanceId;
          END IF;
          
          v_query:= 'Insert into '||v_targetCabinet||'.TODOSTATUSHISTORYTABLE                             
Select * from '||v_sourceCabinet||'.TODOSTATUSTABLE'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from '||v_sourceCabinet||'.TODOSTATUSTABLE'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
         EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Insert into '||v_targetCabinet||'.EXCEPTIONHISTORYTABLE                          
Select * from '||v_sourceCabinet||'.ExceptionTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from '||v_sourceCabinet||'.ExceptionTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Insert into '||v_targetCabinet||'.WFCommentsHistoryTable 
Select  * from '||v_sourceCabinet||'.WFCommentsTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
		v_query:= 'Delete from '||v_sourceCabinet||'.WFCommentsTable'||idblinkname||' where ProcessInstanceId='''|| v_processInstanceId ||'''';
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          IF((v_variantId         =0) AND (v_moveExternalProcessData='Y')) THEN
            IF(v_externalTableCount>0) THEN
              v_query             := 'Insert into '||v_targetCabinet||'.'||v_externalTable||' Select * from '||v_sourceCabinet||'.'||v_externalTable||''||idblinkname||' where  ItemIndex = '''||v_folderIndex||'''' ;
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
            /* ELSE
            WFMoveVariantData(v_processInstanceId,v_variantTableName,v_sourceCabinet,v_targetCabinet,idblinkname) ; */
          END IF;
		  v_query := 'INSERT INTO ' || v_targetCabinet || '.QueueHistoryTable ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.WFInstrumentTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		 SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.WFInstrumentTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		/* Added for Case Management--Archival of task DATA */ 
		IF(v_moveTaskData='Y') THEN
		 v_query:= 'Insert into '||v_targetCabinet||'.WFRTTASKINTFCASSOCHISTORY Select * from ' ||v_sourceCabinet||'.WFRTTaskInterfaceAssocTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.WFRTTaskInterfaceAssocTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		
		 v_query:= 'Insert into '||v_targetCabinet||'.RTACTIVITYINTFCASSOCHISTORY Select * from ' ||v_sourceCabinet||'.RTACTIVITYINTERFACEASSOCTABLE
'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.RTACTIVITYINTERFACEASSOCTABLE'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		
		 v_query:= 'Insert into '||v_targetCabinet||'.WFTASKSTATUSHISTORYTABLE Select * from ' ||v_sourceCabinet||'.WFTaskStatusTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
           SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
          v_query:= 'Delete from ' ||v_sourceCabinet||'.WFTaskStatusTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;	
          EXECUTE Immediate v_query ;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		
		END IF;
		/* Added for Case Management--Archival of task DATA */ 
		
          IF(v_moveExternalProcessData='Y') THEN
            WFMoveComplexData(v_processInstanceId,v_processDefId,v_variantId,v_sourceCabinet,v_targetCabinet,idblinkname,'N',v_executionLogId,v_loggingEnabled) ;
          END IF;
          IF((v_moveAuditTrailData!='N') AND (v_moveAuditTrailData!='n')) THEN
            WFMoveAuditTrailData(v_processInstanceId,v_processDefId,v_sourceCabinet,v_targetCabinet,idblinkname,v_fromDate,v_toDate,v_executionLogId,v_loggingEnabled) ;
          END IF;
		  ----Custom Data Procedure Start----
		   WFMoveCustomData(v_sourceCabinet,v_targetCabinet,idblinkname,v_processDefId,v_processInstanceId) ;
		  ----Custom Data Procedure end------
		 if(v_isDBLink='Y') then
		  v_ODDBLink:= idblinkname;
		  v_ODDBLink:= trim(leading '@' FROM v_ODDBLink); 
		  else
		  v_ODDBLink:='';
		  end if;
          MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDBLink, v_ODDBLink,TO_NUMBER(v_folderIndex), 'Y','N','Y',v_genIndex,v_folderStatus);
          IF (v_folderStatus <> 0) THEN
            ROLLBACK;
            dbms_output.put_line('Error code while migrating folder '||v_folderIndex|| 'is ' || v_folderStatus);
            RETURN;
          END IF;
		  v_query:= 'Select  count(*) from '||v_sourceCabinet||'.WFLinksTable'||idblinkname||' where ParentProcessInstanceId='''|| v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL; 
		  Execute Immediate v_query into v_count;
		   SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		  IF(v_count>0) then 
			  v_query:= 'Update '||v_sourceCabinet||'.WFLinksTable'||idblinkname||' set IsParentArchived =''Y'' where ParentProcessInstanceId='''|| v_processInstanceId ||'''';
			  SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
			  Execute Immediate v_query ;
			  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
			  v_query:= 'Update WFLinksTable set IsParentArchived =''Y'' where ParentProcessInstanceId='''|| v_processInstanceId ||'''';
			  SELECT current_timeStamp INTO v_startTime FROM DUAL;
			  Execute Immediate v_query ;
			  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		  End if;
		  
		  v_query:= 'Select  count(*) from '||v_sourceCabinet||'.WFLinksTable'||idblinkname||' where ChildProcessInstanceId='''|| v_processInstanceId ||'''';
		  SELECT current_timeStamp INTO v_startTime FROM DUAL;
		  Execute Immediate v_query into v_count;
		  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		  IF(v_count>0) then 
			  v_query:= 'Update '||v_sourceCabinet||'.WFLinksTable'||idblinkname||' set IsChildArchived =''Y'' where ChildProcessInstanceId='''|| v_processInstanceId ||'''';
			  SELECT current_timeStamp INTO v_startTime FROM DUAL;
			  Execute Immediate v_query ;
			  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
			  v_executionTime:=v_endTime-v_startTime;
				IF(v_loggingEnabled='Y') THEN
					INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
				END IF;
			  v_query:= 'Update WFLinksTable set IsChildArchived =''Y'' where ChildProcessInstanceId='''|| v_processInstanceId ||'''';
			  SELECT current_timeStamp INTO v_startTime FROM DUAL;
			  Execute Immediate v_query ;
			  SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		  v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		  End if;
		  v_lastInstanceId:=v_processInstanceId;
        END LOOP; 
		IF(v_rowCounter=0) THEN
          CLOSE v_cursor;
          EXIT;
        END IF;
		Insert into WFTxnDataMigrationProgressLog(ExecutionLogId,actionDateTime,ProcessDefId,BatchStartProcessInstanceId,BatchEndProcessInstanceId,Remarks) values (v_ExecutionLogId,sysdate,v_processDefId,v_firstProcessInstanceId,v_lastInstanceId,'Transactional Data Migration');
		COMMIT;

		END LOOP;--For loop Ends
      END LOOP;
	 IF(v_moveTaskData = 'Y') THEN
 		WFExportTaskTables(v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,'N','Y');
		WFMigrateTaskData(v_processDefId,v_sourceCabinet,v_targetCabinet,idblinkname,v_executionLogId,v_fromDate,v_toDate,v_loggingEnabled) ;
   END IF;
      DBMS_OUTPUT.PUT_LINE('Stored Procedure WFMoveTransData executed successfully for '|| v_processDefId);
    END LOOP ;
	WFSynchLinksData(v_sourceCabinet,v_targetCabinet,idblinkname,v_ExecutionLogId, v_loggingEnabled);
  DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
  WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
  DBMS_OUTPUT.PUT_LINE('Stored Procedure executed successfully........');
EXCEPTION
WHEN OTHERS THEN
  BEGIN--4
  	    v_ErrorCode:= SQLCODE;
	    v_ErrorMessage:=SQLERRM;								
	    DBMS_OUTPUT.PUT_LINE('Error Code : '||v_ErrorCode);
	    DBMS_OUTPUT.PUT_LINE('v_ErrorMessage : '||v_ErrorMessage);
	ROLLBACK; 
	v_remarks:= 'Transactional Data Migration Failed . Error Code is '|| v_ErrorCode ||' and Error message is '||v_ErrorMessage;
	 INSERT INTO WFFailedTxnDataMigrationLog(ExecutionLogId,actionDateTime,ProcessDefId,ProcessInstanceId,Remarks) VALUES (v_ExecutionLogId, sysdate, v_processDefId,v_processInstanceId,v_remarks);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE('Check!! Check!! An Exception occurred while execution of Stored WFMoveTransData WFTransferData........');
    WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
	DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
    
    RAISE;
  END;--4
END;--2
END;--1
