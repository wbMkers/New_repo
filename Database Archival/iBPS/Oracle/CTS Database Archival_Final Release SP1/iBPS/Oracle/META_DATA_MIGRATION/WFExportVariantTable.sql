/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFExportVariantTable.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace PROCEDURE WFExportVariantTable
  (
    v_sourceCabinet      VARCHAR2,
    v_targetCabinet      VARCHAR2,
    idblinkname          VARCHAR2,
    v_processDefId 		INTEGER,
	v_processVariantId  INTEGER   
	)
AS
  v_query       VARCHAR2(4000);
  v_queryStr    VARCHAR2(4000);
  v_createQuery VARCHAR2(4000);
TYPE VariantCursor
IS
  REF
  CURSOR; 
    v_VariantCursor VariantCursor;

	v_processVariantName VARCHAR2(255);
  TYPE TableCursor
IS
  REF
  CURSOR;
    v_TableCursor TableCursor;
    v_tableName  VARCHAR2(256);
	v_transactionalTable VARCHAR2(256);
    v_existsFlag INTEGER;
  BEGIN
    BEGIN
      v_queryStr := 'SELECT ProcessVariantName FROM ' || v_sourceCabinet || '.' || 'WFProcessVariantDefTable'||idblinkname||' where processdefid = '|| v_ProcessDefId || ' and ProcessVariantId = '||v_processVariantId ;
      Execute Immediate v_queryStr into v_processVariantName;
      BEGIN
     	v_tableName :='WFPV_'||  v_processVariantName;
		   v_queryStr:='SELECT 1 FROM DBA_Tables'||idblinkname||' WHERE TABLE_NAME='''||UPPER(v_tableName)||''' AND OWNER = '''||UPPER(v_sourceCabinet)||'''';
          BEGIN
            EXECUTE Immediate v_queryStr INTO v_existsFlag;
          EXCEPTION
          WHEN OTHERS THEN
            v_existsFlag := 0;
          END;
		  
		 IF (v_existsFlag = 1) THEN
            DECLARE
              name_in_use EXCEPTION;                      --declare a user defined exception
              pragma exception_init( name_in_use, -955 ); --bind the error code to the above
            BEGIN
              v_createQuery :='CREATE TABLE '||v_tableName||' AS SELECT * FROM ' || v_sourceCabinet ||'.'||v_tableName||idblinkname||' WHERE 1=2';
              EXECUTE IMMEDIATE v_createQuery;
            EXCEPTION
            WHEN NAME_IN_USE THEN
              DBMS_OUTPUT.PUT_LINE(v_tableName||'Table already exists ');
            END;
          END IF;
        
        CLOSE v_VariantCursor;
    END;
  END;
END;
