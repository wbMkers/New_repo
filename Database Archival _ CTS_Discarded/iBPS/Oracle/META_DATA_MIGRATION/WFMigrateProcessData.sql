/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMigrateProcessData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
PROCEDURE WFMigrateProcessData
  (
    v_sourceCabinet      VARCHAR2,
    v_targetCabinet      VARCHAR2,
    idblinkname          VARCHAR2,
	v_overRideCabinetData	VARCHAR2,
	v_moveTaskData    VARCHAR2,
	v_ExecutionLogId	INTEGER
	)
AS
  v_query VARCHAR2(4000);
  v_queryStr NVARCHAR2(2000);
  v_tableId                 INTEGER;
  v_tableName               VARCHAR2(256);
  v_dataMigrationSuccessful VARCHAR2(1);
TYPE TableNameCursor
IS
  REF
  CURSOR;
    v_TableNameCursor TableNameCursor;
    v_existsFlag      INTEGER;
  BEGIN
    BEGIN
	WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'D',idblinkname);
    DBMS_OUTPUT.PUT_LINE('Triggers disabled');
      v_query := 'DROP TABLE ' || v_targetCabinet || '.WFPROCESSTABLELIST';
      EXECUTE IMMEDIATE v_query;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
    END;
    v_query := 'CREATE TABLE ' || v_targetCabinet || '.WFPROCESSTABLELIST (                            

tableId                 INT,                            

tableName               VARCHAR2(256),                            
   
dataMigrationSuccessful VARCHAR2(1),
UNIQUE (tableName)                        

)';
    EXECUTE IMMEDIATE v_query;
    BEGIN
      v_query := 'DROP SEQUENCE ' || v_targetCabinet || '.SEQ_WFPROCESSTABLELIST';
      EXECUTE IMMEDIATE v_query;
    EXCEPTION
    WHEN OTHERS THEN
     -- DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	  DBMS_OUTPUT.PUT_LINE (' ');
    END;
    v_query := 'CREATE SEQUENCE ' || v_targetCabinet || '.SEQ_WFPROCESSTABLELIST START WITH 1 INCREMENT BY 1';
    EXECUTE IMMEDIATE v_query;
    v_query := 'CREATE OR REPLACE TRIGGER ' || v_targetCabinet || '.WFPROCESSTABLELIST_ID_TRIGGER                      

BEFORE INSERT                     

ON ' || v_targetCabinet || '.WFPROCESSTABLELIST                     

FOR EACH ROW                     

BEGIN                         

SELECT ' || v_targetCabinet || '.SEQ_WFPROCESSTABLELIST.nextval INTO :new.tableId FROM dual;                     

END;';
    EXECUTE IMMEDIATE v_query;
    WFPopulateProcessDataList(v_targetCabinet,v_moveTaskData);
    v_query    := 'SELECT * FROM ' || v_targetCabinet || '.WFPROCESSTABLELIST';
    BEGIN

      OPEN v_TableNameCursor FOR TO_CHAR(v_query);
      LOOP
        FETCH v_TableNameCursor
        INTO v_tableId,
          v_tableName,
          v_dataMigrationSuccessful;
        EXIT
      WHEN v_TableNameCursor%NOTFOUND;
        v_existsFlag := 0;
        BEGIN
          SELECT 1
          INTO v_existsFlag
          FROM DBA_Tables
          WHERE TABLE_NAME    = UPPER(v_tableName)
          AND OWNER = UPPER(v_targetCabinet);
        EXCEPTION
        WHEN OTHERS THEN
          v_existsFlag := 0;
        END;
        IF (v_existsFlag = 1) THEN
          WFMoveProcessData (v_sourceCabinet, v_targetCabinet, v_tableName,idblinkname,v_overRideCabinetData,v_ExecutionLogId);
        END IF;
      END LOOP;
      CLOSE v_TableNameCursor;
      COMMIT;
  	DBMS_OUTPUT.PUT_LINE('process Global data migrated !');
	WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
	DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
		WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
		DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
		DBMS_OUTPUT.PUT_LINE('Error in executing WFMigrateProcessDataScript !');
      RAISE;
    END;
  END;
END;
