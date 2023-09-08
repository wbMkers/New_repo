/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveComplexData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for Transactional data Archival;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
create or replace
PROCEDURE WFMigrateTaskData (
	v_processDefId     						INTEGER,
    v_sourceCabinet                         Varchar2,
    v_targetCabinet                         Varchar2,
	idblinkname								Varchar2,
	v_executionLogId						Integer,
	v_fromDate								VARCHAR2,
	v_toDate							VARCHAR2,
	v_loggingEnabled						Varchar2
) AS
	v_startTime 			TimeStamp;
	v_endTime 				TimeStamp;
  	v_executionTime	VARCHAR2(500);

	v_taskId								Integer;
	v_queryStr              NVARCHAR2(6000);
	v_rowCount								INTEGER;
	v_tableName								NVARCHAR2(50);
	v_transactionalTable					NVARCHAR2(255);
	v_ErrorCode								INTEGER;
	v_ErrorMessage							NVARCHAR2(50);
	v_ForeignKeyValue						NVARCHAR2(50);
	v_filterString 						    VARCHAR2(1000);

  TYPE TableNameCursor      				IS REF CURSOR;
	v_cursor                 				TableNameCursor;

BEGIN 
	v_queryStr := 'SELECT TaskId FROM '||v_sourceCabinet||'.WFTaskDefTable'||idblinkname||' WHERE ProcessDefId = '||v_processDefId;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
		OPEN  v_cursor FOR TO_CHAR(v_queryStr);
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);
		END IF;
		LOOP
				
 		FETCH v_cursor INTO v_taskId;
		EXIT WHEN v_cursor%NOTFOUND;
				BEGIN
				v_tableName:= 'WFGenericData_'||v_processDefId ||'_' ||v_taskId;
				WFMoveTaskData(v_sourceCabinet,	v_targetCabinet ,idblinkname,v_executionLogId,v_tableName,v_fromDate,v_toDate,v_loggingEnabled);
				END;
		
		END LOOP;
			 CLOSE v_cursor;	
		
END;
