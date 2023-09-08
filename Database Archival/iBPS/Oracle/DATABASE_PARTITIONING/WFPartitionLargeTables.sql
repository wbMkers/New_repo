/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPartitionLargeTables.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 22 MAY 2014
Description                 : .Support for Partitioning in Archival . Called internally for Partitioning
____________________________________________________________________________________;
CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Database partitioning Solution for IBPS
* It is mandatory to compile and EXECUTE IMMEDIATE this script on target cabinet 
*
***************************************************************************************/
create or replace
PROCEDURE WFPartitionLargeTables
  (
	v_targetCabinet      VARCHAR2,
	tableVariableMap Process_Variant_Tab_Var,
	v_migrateAllData	VARCHAR2
	)
AS
  v_query VARCHAR2(4000);
  v_queryStr NVARCHAR2(2000);
  v_tableId                 INTEGER;
  v_tableName               VARCHAR2(256);
  v_partitionType			VARCHAR2(1);
  v_partitionColumn		VARCHAR2(256);
  v_tableAlias			VARCHAR2(256);
TYPE TableNameCursor
IS
  REF
  CURSOR;
	v_TableNameCursor TableNameCursor;
	v_existsFlag      INTEGER;
  BEGIN
	BEGIN
		select COUNT(*) INTO v_existsFlag From v$version where Upper(banner) like '%ENTERPRISE%';
		dbms_output.put_line(v_existsFlag);
		if(v_existsFlag=0) then
			dbms_output.put_line('Database is non enterprise edition . Hence partitioning is not possible');
			return;
		end if;
		
		select COUNT(*) INTO v_existsFlag From v$version where Upper(banner) like '%10G%';
		dbms_output.put_line(v_existsFlag);
		if(v_existsFlag=0) then
			dbms_output.put_line('Database is Oracle 10g. Hence partitioning is not supported by this script');
			return;
		end if;
		
		select COUNT(*) INTO v_existsFlag From WFCabVersionTable where Upper(CABVERSION) = 'PARTITIONING_SUPPORT';
		dbms_output.put_line('PARTITIONING_SUPPORT'||v_existsFlag);
		if(v_existsFlag=0) then
		WFCreatePartionedTables();
		end if;
		
	  v_query := 'DROP TABLE ' || v_targetCabinet || '.WFPARTITIONTABLELIST';
	  EXECUTE IMMEDIATE v_query;
	EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	END;
	v_query := 'CREATE TABLE ' || v_targetCabinet || '.WFPARTITIONTABLELIST (                            

tableId                 INT,                            

tableName               VARCHAR2(256),                            
   
partitionType VARCHAR2(1),

v_tableAlias		VARCHAR2(255),	

partitionColumnName	VARCHAR2(255),

UNIQUE (tableName)                        

)';
	EXECUTE IMMEDIATE v_query;
	BEGIN
	  v_query := 'DROP SEQUENCE ' || v_targetCabinet || '.SEQ_WFPARTITIONTABLELIST';
	  EXECUTE IMMEDIATE v_query;
	EXCEPTION
	WHEN OTHERS THEN
	 -- DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	  DBMS_OUTPUT.PUT_LINE (' ');
	END;
	v_query := 'CREATE SEQUENCE ' || v_targetCabinet || '.SEQ_WFPARTITIONTABLELIST START WITH 1 INCREMENT BY 1';
	EXECUTE IMMEDIATE v_query;
	v_query := 'CREATE OR REPLACE TRIGGER ' || v_targetCabinet || '.WFPARTITIONTABLE_ID_TRIGGER                      

BEFORE INSERT                     

ON ' || v_targetCabinet || '.WFPARTITIONTABLELIST                     

FOR EACH ROW                     

BEGIN                         

SELECT ' || v_targetCabinet || '.SEQ_WFPARTITIONTABLELIST.nextval INTO :new.tableId FROM dual;                     

END;';
	EXECUTE IMMEDIATE v_query;
	WFPopulatePartitionTableList(v_targetCabinet);
	v_query    := 'SELECT * FROM ' || v_targetCabinet || '.WFPARTITIONTABLELIST where partitionType=''C''';
	BEGIN

	  OPEN v_TableNameCursor FOR TO_CHAR(v_query);
	  LOOP
		FETCH v_TableNameCursor
		INTO v_tableId,
		  v_tableName,
		  v_partitionType,
		  v_tableAlias,
		  v_partitionColumn;
		EXIT
	  WHEN v_TableNameCursor%NOTFOUND;
		v_existsFlag := 0;
		BEGIN
		  SELECT 1
		  INTO v_existsFlag
		  FROM ALL_Tables
		  WHERE TABLE_NAME    = UPPER(v_tableName)
		  AND OWNER = UPPER(v_targetCabinet);
		EXCEPTION
		WHEN OTHERS THEN
		  v_existsFlag := 0;
		END;
		IF (v_existsFlag = 1) THEN
		  WFPartitionTable(v_targetCabinet, v_tableName,v_tableAlias,tableVariableMap,v_migrateAllData,v_partitionColumn);
		END IF;
	  END LOOP;
	  CLOSE v_TableNameCursor;
	  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
	BEGIN
	  RAISE;
	END;
  END;
END;