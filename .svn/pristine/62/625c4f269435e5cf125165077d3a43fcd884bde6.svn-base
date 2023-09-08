/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMigrateTxnCabinetData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for cabinet level Transactional data ARCHIVAL;
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
CREATE OR REPLACE
PROCEDURE WFMigrateTxnCabinetData
  (
	v_sourceCabinet      VARCHAR2,
	v_targetCabinet      VARCHAR2,
	v_isDBLink			VARCHAR2,	
	idblinkname          VARCHAR2,
	v_beforeDate              VARCHAR2			
	)
AS
  v_query VARCHAR2(4000);
  v_queryStr NVARCHAR2(2000);
  v_tableId                 INTEGER;
  v_tableName               VARCHAR2(256);
  v_dataMigrationSuccessful VARCHAR2(1);
  v_idblinkname          VARCHAR2(256);

TYPE TableNameCursor
IS
  REF
  CURSOR;
	v_TableNameCursor TableNameCursor;
	v_existsFlag      INTEGER;
  BEGIN
	BEGIN
	if(v_isDBLink='Y') then
	v_idblinkname:= '@'||idblinkname;
	else
	v_idblinkname:='';
	end if;
	WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'D',v_idblinkname);
	DBMS_OUTPUT.PUT_LINE('Triggers disabled');
	  v_query := 'DROP TABLE ' || v_targetCabinet || '.WFTXNCABINETBLELIST';
	  EXECUTE IMMEDIATE v_query;
	EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	END;
	v_query := 'CREATE TABLE ' || v_targetCabinet || '.WFTXNCABINETBLELIST (                            

tableId                 INT,                            

tableName               VARCHAR2(256),                            
   
dataMigrationSuccessful VARCHAR2(1)                        

)';
	EXECUTE IMMEDIATE v_query;
	BEGIN
	  v_query := 'DROP SEQUENCE ' || v_targetCabinet || '.SEQ_WFTXNCABINETBLELIST';
	  EXECUTE IMMEDIATE v_query;
	EXCEPTION
	WHEN OTHERS THEN
	 -- DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	  DBMS_OUTPUT.PUT_LINE (' ');
	END;
	v_query := 'CREATE SEQUENCE ' || v_targetCabinet || '.SEQ_WFTXNCABINETBLELIST START WITH 1 INCREMENT BY 1';
	EXECUTE IMMEDIATE v_query;
	v_query := 'CREATE OR REPLACE TRIGGER ' || v_targetCabinet || '.WFTXNCABINETBLELIST_ID_TRIGGER                      

BEFORE INSERT                     

ON ' || v_targetCabinet || '.WFTXNCABINETBLELIST                     

FOR EACH ROW                     

BEGIN                         

SELECT ' || v_targetCabinet || '.SEQ_WFTXNCABINETBLELIST.nextval INTO :new.tableId FROM dual;                     

END;';
	EXECUTE IMMEDIATE v_query;
	WFPopulateTxnCabinetTableList(v_targetCabinet);
	v_query    := 'SELECT * FROM ' || v_targetCabinet || '.WFTXNCABINETBLELIST';
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
		  AND TABLESPACE_NAME = UPPER(v_targetCabinet);
		EXCEPTION
		WHEN OTHERS THEN
		  v_existsFlag := 0;
		END;
		IF (v_existsFlag = 1) THEN
		  WFMoveTxnCabinetData (v_sourceCabinet, v_targetCabinet, v_tableName,v_idblinkname,v_beforeDate);
		END IF;
	  END LOOP;
	  CLOSE v_TableNameCursor;
	  COMMIT;
	DBMS_OUTPUT.PUT_LINE('Transactional cabinet data migrated !');
	WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',v_idblinkname);
	DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
  EXCEPTION
  WHEN OTHERS THEN
	BEGIN
		WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',v_idblinkname);
		DBMS_OUTPUT.PUT_LINE('Triggers Enabled');
		DBMS_OUTPUT.PUT_LINE('Error in executing WFMigrateTxnCabinetData !');
	  RAISE;
	END;
  END;
END;