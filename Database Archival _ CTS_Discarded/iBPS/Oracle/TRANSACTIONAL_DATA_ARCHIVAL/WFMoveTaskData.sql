/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveComplexData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for Transactional data Archival;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
create or replace
PROCEDURE WFMoveTaskData (
	v_sourceCabinet                         Varchar2,
    v_targetCabinet                         Varchar2,
	idblinkname								Varchar2,
	v_executionLogId						Integer,
	v_tableName								VARCHAR2,
	v_fromDate								VARCHAR2,
	v_toDate							VARCHAR2,
	v_loggingEnabled						Varchar2
) AS
	v_startTime 			TimeStamp;
	v_endTime 				TimeStamp;
  	v_executionTime	VARCHAR2(500);

  v_query      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_columnName VARCHAR2(256);
  existsFlag   INTEGER;
  v_rowCounter  INTEGER;
  v_filterString  VARCHAR2(1000);
  v_orderByString VARCHAR2(1000);
  TYPE TableNameCursor      				IS REF CURSOR;
	v_cursor                 				TableNameCursor;

BEGIN 

	v_filterString:=' where EntryDateTime Between '''||v_fromDate||'''' ; 
	v_filterString:= v_filterString|| ' and  '''||v_toDate||'''';
	
	begin
		v_query:='SELECT 1 FROM DBA_Tables'||idblinkname||' WHERE TABLE_NAME='''||UPPER(v_tableName)||''' AND OWNER = '''||UPPER(v_sourceCabinet)||'''';
		BEGIN --2
		  EXECUTE Immediate v_query INTO existsFlag;
		EXCEPTION
		WHEN OTHERS THEN
		  existsFlag := 0;
		END;--2
		IF(existsFlag =0 ) then
			return;
		END IF;
		
	  while(1=1) loop 
	   v_query:= ' Select count(*) from '||v_sourceCabinet||'.'||v_tableName||''||idblinkname||v_filterString ||' AND ROWNUM<=100'||v_orderByString;
	   EXECUTE Immediate v_query into v_rowCounter;
	   IF(v_rowCounter=0) THEN
		EXIT;
	   END IF;
		SELECT current_timeStamp INTO v_startTime FROM DUAL;	
	   v_query:= 'Insert into '||v_tableName||' Select * from '||v_sourceCabinet||'.'||v_tableName||idblinkname||v_filterString|| ' AND ROWNUM<=100'||v_orderByString ;
	   SELECT current_timeStamp INTO v_endTime FROM DUAL;	
	  EXECUTE Immediate v_query ;
	  v_query := 'Delete from '||v_sourceCabinet||'.'||v_tableName||idblinkname||v_filterString|| ' AND ROWNUM<=100' ;
	  EXECUTE Immediate v_query ;
	END LOOP;
	end;
	
END;
