/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveProcessData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFMoveProcessData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    v_tableName     VARCHAR2,
    idblinkname     VARCHAR2,
	v_overRideCabinetData	VARCHAR2,
	v_ExecutionLogId	INTEGER
 )
AS
  v_query      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_columnName VARCHAR2(256);
  existsFlag   INTEGER;
TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
	v_remarks VARCHAR2(4000);
  BEGIN
    BEGIN
      --SAVEPOINT Migrate_Process_Data;
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
	if(v_overRideCabinetData='Y') then
    begin
	v_query := 'TRUNCATE TABLE ' || v_targetCabinet || '.' || v_tableName||'' ;
    EXECUTE IMMEDIATE v_query;
    v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||'' ;
    EXECUTE IMMEDIATE v_query;
    v_query := 'UPDATE ' || v_targetCabinet || '.WFPROCESSTABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' || v_tableName || '''';
    EXECUTE IMMEDIATE v_query;
	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,0, v_tableName,'Cabinet Level MetaData');
	end;
	else
		v_query := 'Select count(*) from ' || v_targetCabinet || '.' || v_tableName||'' ;
		EXECUTE IMMEDIATE v_query into existsFlag;
		  IF(existsFlag = 0 ) then
		v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||'' ;
		EXECUTE IMMEDIATE v_query;
		insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,0, v_tableName,'Cabinet Level MetaData');
		  END IF;
	END IF;
	
	--DBMS_OUTPUT.PUT_LINE ('Data moved for '|| v_tableName);
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
	  v_remarks:= 'Error in Cabinet level metadata migration for table '||v_tableName;
    
	   INSERT INTO WFFailedMetaDataMigrationLog(ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, 0,v_remarks);
     
	   commit;
      RAISE;
    END;
  END;
END;