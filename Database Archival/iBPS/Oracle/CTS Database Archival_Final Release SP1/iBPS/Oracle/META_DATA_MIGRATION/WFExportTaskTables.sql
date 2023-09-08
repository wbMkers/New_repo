/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFExportTaskTables.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 29 June 2016
    Description                 : Stored procedure for Meta data Migration . Will export task tables for Case Management
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFExportTaskTables
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
    idblinkname     VARCHAR2,
    v_processDefId  INTEGER,
	v_migrateAllData VARCHAR2,
	v_isRunTimeTable VARCHAR2
)
AS
  v_query       VARCHAR2(4000);
  v_queryStr    VARCHAR2(4000);
  v_createQuery VARCHAR2(4000);
  v_filterQueryString VARCHAR2(1000);
  v_ddlQuery VARCHAR2(4000);
  v_executeDDLQuery VARCHAR2(32767);
TYPE TableCursor
IS
  REF
  CURSOR;
    v_TableCursor TableCursor;
    v_tableName          VARCHAR2(256);
	v_localProcessDefId  INTEGER;
	v_taskId			 Integer;
    v_existsFlag         INTEGER;
	v_scope 			 VARCHAR2(1);
  BEGIN --1

	IF(v_migrateAllData ='Y') THEN
	v_filterQueryString := ' WHERE 1=1 ';
	Else 
	v_filterQueryString := ' WHERE PROCESSDEFID= '|| v_ProcessDefId;
	END IF;
	
	IF(v_isRunTimeTable ='Y') THEN
	v_scope:='U';
	ELSE
	v_scope:='P';
	END IF;
	v_filterQueryString := v_filterQueryString || ' And SCOPE = '''|| v_scope||'''';
	
	
	v_query             := 'SELECT PROCESSDEFID,TASKID FROM ' || v_sourceCabinet || '.' || 'WFTASKDEFTABLE'||idblinkname||v_filterQueryString;
    OPEN v_TableCursor FOR TO_CHAR(v_query);
    LOOP
      FETCH v_TableCursor INTO v_localProcessDefId,v_taskId;
    EXIT
  WHEN v_TableCursor%NOTFOUND;
  v_tableName:= 'WFGenericData_'||v_localProcessDefId||'_' ||v_taskId;
  v_queryStr:='SELECT 1 FROM DBA_Tables'||idblinkname||' WHERE TABLE_NAME='''||UPPER(v_tableName)||''' AND OWNER = '''||UPPER(v_sourceCabinet)||'''';
    BEGIN --2
      EXECUTE Immediate v_queryStr INTO v_existsFlag;
    EXCEPTION
    WHEN OTHERS THEN
      v_existsFlag := 0;
    END;--2
    IF (v_existsFlag = 1) THEN
      DECLARE
        name_in_use EXCEPTION;                      --declare a user defined exception
        pragma exception_init( name_in_use, -955 ); --bind the error code to the above
      BEGIN--3
        v_createQuery :='CREATE TABLE '||v_tableName||' AS SELECT * FROM ' || v_sourceCabinet ||'.'||v_tableName||idblinkname||' WHERE 1=2';
        EXECUTE IMMEDIATE v_createQuery;
      EXCEPTION
      WHEN NAME_IN_USE THEN
        DBMS_OUTPUT.PUT_LINE(v_tableName||' Table already exists ');
	  WHEN Others then 
		BEGIN
		v_ddlQuery:='Select Generate_DDL_FNC'||idblinkname||'(''TABLE'','''||UPPER(v_tableName)||''','''||UPPER(v_sourceCabinet)||''','''||UPPER(v_targetCabinet)||''') from dual';
   -- DBMS_OUTPUT.PUT_LINE(v_ddlQuery);
    Execute Immediate(v_ddlQuery) into v_executeDDLQuery;
   -- DBMS_OUTPUT.PUT_LINE(v_executeDDLQuery);
    Execute Immediate(v_executeDDLQuery);
    DBMS_OUTPUT.PUT_LINE('done');
--		v_ddlQuery
		EXCEPTION
    WHEN NAME_IN_USE THEN
       DBMS_OUTPUT.PUT_LINE(v_tableName||' Table already exists ');
    WHEN Others then 
		DBMS_OUTPUT.PUT_LINE('Error in creating table  '||v_tableName);
		END;
      END; --3
    END IF;
  END LOOP;
  CLOSE v_TableCursor;
END;--1