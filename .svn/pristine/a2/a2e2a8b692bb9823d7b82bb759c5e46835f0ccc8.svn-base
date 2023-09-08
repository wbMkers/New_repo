/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFSynchLinksData.sql (Oracle)
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
PROCEDURE WFSynchLinksData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    idblinkname     VARCHAR2,
	v_executionLogId	INTEGER,
	v_loggingEnabled 	VARCHAR2 	
 )
AS
  v_query      VARCHAR2(4000);
  v_queryStr      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_columnName VARCHAR2(256);
  existsFlag   INTEGER;
  v_processInstanceId	NVARCHAR2(63);
  v_childProcessInstanceId NVARCHAR2(63);
  v_lastInstanceId  NVARCHAR2(63);
  v_rowCounter  Integer;
  v_startTime	TimeStamp;
  v_endTime	TimeStamp;	
  v_executionTime	VARCHAR2(500);
TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
TYPE VCursor
IS
  REF
  CURSOR;
    v_Cursor VCursor;
  BEGIN
    BEGIN
	    v_lastInstanceId :='/0';

      --SAVEPOINT Migrate_Process_Data;
	--v_query := 'TRUNCATE TABLE ' || v_targetCabinet || '.WFLinksTable' ;
	 -- EXECUTE IMMEDIATE v_query;
	WHILE(1=1)
      LOOP
	v_query    := 'Select * from(SELECT a.parentprocessinstanceid, a.CHILDPROCESSINSTANCEID FROM '|| v_sourcecabinet ||'.WFLinksTable'||idblinkname||' a WHERE a.ISPARENTARCHIVED= ''Y'' and a.ISCHILDARCHIVED = ''Y'' order by a.ParentProcessInstanceId ) where ROWNUM <=100';
	
	
    v_queryStr := 'Select count(*) from(SELECT a.parentprocessinstanceid, a.CHILDPROCESSINSTANCEID FROM '|| v_sourcecabinet ||'.WFLinksTable'||idblinkname||' a WHERE a.ISPARENTARCHIVED= ''Y'' and a.ISCHILDARCHIVED = ''Y'' order by a.ParentProcessInstanceId ) where ROWNUM <=100';
	
	
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
        EXECUTE Immediate v_queryStr INTO v_rowCounter;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);
		END IF;
			IF(v_cursor%ISOPEN) THEN
				close v_cursor;
			END IF;
		OPEN v_cursor FOR TO_CHAR(v_query);
    IF(v_rowCounter=0) THEN
    close v_cursor;
          Exit;
    END IF;
        LOOP
          FETCH v_cursor INTO v_processInstanceId, v_childProcessInstanceId;
          EXIT
        WHEN v_cursor%NOTFOUND;
 		
		v_query := 'INSERT INTO ' || v_targetCabinet || '.WFLinksTable SELECT * FROM ' || v_sourceCabinet || '.WFLinksTable'||idblinkname|| '  WHERE ParentProcessInstanceId ='''||v_processInstanceId ||'''  and CHILDPROCESSINSTANCEID = ''' ||v_childProcessInstanceId||'''' ;
		
		
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
		EXECUTE IMMEDIATE v_query;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
		END IF;
		
		v_queryStr := 'Delete from '|| v_sourceCabinet||'.WFLinksTable where ParentProcessInstanceId ='''||v_processInstanceId ||'''  and CHILDPROCESSINSTANCEID = ''' ||v_childProcessInstanceId||'''' ; 
		
		SELECT current_timeStamp INTO v_startTime FROM DUAL;
		EXECUTE IMMEDIATE v_queryStr;
		SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		 IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);
		END IF;
		
		--v_lastInstanceId:= 	v_processInstanceId;
		END LOOP;
	END LOOP;
		
	
	--DBMS_OUTPUT.PUT_LINE ('Data moved for '|| v_tableName);
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
      RAISE;
    END;
  END;
END;