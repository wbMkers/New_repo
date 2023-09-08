/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveQueueData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
PROCEDURE WFMoveQueueData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    v_processDefId  INTEGER,
    idblinkname     VARCHAR2,
	v_migrateAllData VARCHAR2,
	v_copyForceFully VARCHAR2,
	v_existingProcessString VARCHAR2
  )
AS
  v_query           VARCHAR2(4000);
  v_queryStr        VARCHAR2(4000);
  v_tableName       VARCHAR2(256);
  v_colStrQueueDef  VARCHAR2(4000);
  v_colStrQueueUser VARCHAR2(4000);
  v_columnName      VARCHAR2(256);
  v_FilterQueryString VARCHAR2(1000);
  existsFlag        INTEGER;
TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
  TYPE QueueCursor
IS
  REF
  CURSOR;
    v_QueueCursor QueueCursor;
    v_queueId INTEGER;
  BEGIN
    BEGIN
    --  SAVEPOINT Move_Queue_Data;
      v_tableName:='QUEUEDEFTABLE';
      v_query    := 'SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER(''' || v_tableName || ''') AND OWNER = UPPER(''' || v_targetCabinet || ''')';
      OPEN v_ColumnCursor FOR TO_CHAR(v_query);
      v_colStrQueueDef := '';
      LOOP
        FETCH v_ColumnCursor INTO v_columnName;
      EXIT
    WHEN v_ColumnCursor%NOTFOUND;
      v_colStrQueueDef := v_colStrQueueDef ||v_columnName||',';
    END LOOP;
    v_colStrQueueDef:=trim(trailing ',' FROM v_colStrQueueDef);
    CLOSE v_ColumnCursor;
 
	IF(v_migrateAllData ='Y') THEN
		IF(v_copyForceFully ='Y') THEN
		 --If All data is to be replaced
		 v_query := 'Truncate Table ' || v_targetCabinet || '.QUEUEDEFTABLE';
		 EXECUTE IMMEDIATE v_query;
		 v_FilterQueryString:= ' WHERE 1=1';
		Else
		--If all data is to be migrated except for existing data
		v_FilterQueryString:= ' WHERE processdefid not in ('||v_existingProcessString||')';
		END IF;
	ELSE
		v_FilterQueryString:= ' WHERE PROCESSDEFID= '||v_processDefId;
		IF(v_copyForceFully ='Y') THEN
		v_query:= 'Delete from '|| v_targetCabinet || '. QueueDefTable where queueid in( Select QueueId from '|| v_sourceCabinet || '.QueueStreamTable' ||idblinkname||v_FilterQueryString||')';
		 EXECUTE IMMEDIATE v_query;
		--v_query:= 'Delete from '|| v_targetCabinet || '. QueueUserTable where queueid in( Select QueueId from '|| v_sourceCabinet || '.QueueStreamTable' ||idblinkname||v_FilterQueryString||')';
		 EXECUTE IMMEDIATE v_query;
		END IF;
--					v_FilterQueryString:= ' WHERE PROCESSDEFID= '||v_processDefId;
	END IF;
    v_query:= 'Select distinct QueueId from '|| v_sourceCabinet || '.QueueStreamTable' ||idblinkname||v_FilterQueryString;
    OPEN v_QueueCursor FOR TO_CHAR(v_query);
    LOOP
      FETCH v_QueueCursor INTO v_queueId;
      EXIT
    WHEN v_QueueCursor%NOTFOUND;
      v_tableName:='QUEUEDEFTABLE';
      v_queryStr:= 'Select Count(*) from '|| v_targetCabinet || '.' || v_tableName||' where QueueId = '|| v_queueId;
      Execute Immediate v_queryStr into existsFlag;
      IF(existsFlag = 0 ) then
      v_queryStr := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '||v_colStrQueueDef||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||' WHERE QUEUEID= '||v_queueId;
      EXECUTE IMMEDIATE v_queryStr;
      END IF;
      
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
      RAISE;
    END;
  END;
END;