/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveMetaData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFMoveMetaData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    v_tableName     VARCHAR2,
    v_processDefId  INTEGER,
    idblinkname     VARCHAR2,
	v_migrateAllData VARCHAR2,
	v_copyForceFully VARCHAR2,
	v_existingProcessString VARCHAR2,
  v_ExecutionLogId INTEGER
  )
AS
  v_query      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_FilterQueryString VARCHAR2(1000);
  v_columnName VARCHAR2(256);
TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
	v_remarks VARCHAR2(4000);
  BEGIN
    BEGIN
     -- SAVEPOINT Move_Meta_Data;
      v_query := 'SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER(''' || v_tableName || ''') AND OWNER = UPPER(''' || v_targetCabinet || ''')';
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
	--dbms_output.put_line(v_tableName);
	IF(v_migrateAllData ='Y') THEN
		IF(v_copyForceFully ='Y') THEN
		 v_query := 'Truncate Table ' || v_targetCabinet || '.' || v_tableName;
		 EXECUTE IMMEDIATE v_query;
		v_FilterQueryString:= ' WHERE 1=1';
		
		Else
		v_FilterQueryString:= ' WHERE processdefid not in ('||v_existingProcessString||')';
		END IF;
	ELSE
		IF(v_copyForceFully ='Y') THEN
		v_query := 'Delete FROM ' || v_targetCabinet || '.' || v_tableName ||' Where processdefid = '||v_processDefId;
		EXECUTE IMMEDIATE v_query;
		END IF;
		v_FilterQueryString:= ' WHERE PROCESSDEFID= '||v_processDefId;
		
	END IF;
    v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||v_FilterQueryString;
    EXECUTE IMMEDIATE v_query;
    /*v_query := 'UPDATE ' || v_targetCabinet || '.WFMETADATATABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' || v_tableName || '''';
    EXECUTE IMMEDIATE v_query;*/
  	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status )values(v_ExecutionLogId, current_timestamp,v_processDefId, v_tableName,'Process MetaData');
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
	ROLLBACK ;
	  v_remarks:= 'Error in metadata migration for processdefid '||v_processdefid ||' and table '||v_tableName;
	   INSERT INTO WFFailedMetaDataMigrationLog (ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, v_processDefId,v_remarks);
	   commit;
	RAISE;
    END;
  END;
END;
