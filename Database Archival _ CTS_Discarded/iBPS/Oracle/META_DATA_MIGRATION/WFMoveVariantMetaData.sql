/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveVariantMetaData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
PROCEDURE WFMoveVariantMetaData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    v_tableName     VARCHAR2,
    v_processDefId		INTEGER,
	v_processVariantId  INTEGER,
    idblinkname     VARCHAR2 ,
	v_migrateAllData 	VARCHAR2,
	v_copyForceFully    VARCHAR2,
	v_existingVariantString VARCHAR2,
	v_executionLogId	INTEGER
	)
AS
  v_query      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_columnName VARCHAR2(256);
  v_FilterQueryString VARCHAR2(1000);
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
	IF(v_migrateAllData ='Y') THEN
		IF(v_copyForceFully ='Y') THEN
		 v_query := 'Truncate Table ' || v_targetCabinet || '.' || v_tableName;
		 EXECUTE IMMEDIATE v_query;
		v_FilterQueryString:= ' WHERE 1=1';
		
		Else
		v_FilterQueryString:= ' WHERE ProcessVariantId not in ('||v_existingVariantString||')';
		END IF;
	ELSE
		v_FilterQueryString:= ' WHERE processDefId ='||v_processDefId ||' and processVariantId= '||v_processVariantId;
		IF(v_copyForceFully ='Y') THEN
		v_query := 'Delete FROM ' || v_targetCabinet || '.' || v_tableName ||' Where processdefid = '||v_processDefId ||' and ProcessVariantId = '||v_processVariantId;
		EXECUTE IMMEDIATE v_query;
		END IF;
	END IF;
    v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||v_FilterQueryString;
    EXECUTE IMMEDIATE v_query;
    /*v_query := 'UPDATE ' || v_targetCabinet || '.WFMETADATATABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' || v_tableName || '''';
    EXECUTE IMMEDIATE v_query; */
	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,v_processDefId, v_tableName,'Variant MetaData'||v_processVariantId );

  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
	   v_remarks:= 'Error in metadata migration for variant id  '||v_processVariantId ||' and table '||v_tableName;
	   INSERT INTO WFFailedMetaDataMigrationLog (ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, v_processDefId,v_remarks);
	   COMMIT;
      RAISE;
    END;
  END;
END;