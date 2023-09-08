/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveTxnCabinetData.sql (Oracle)
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
create or replace
PROCEDURE WFMoveTxnCabinetData
  (
	v_sourceCabinet VARCHAR2,
	v_targetCabinet VARCHAR2,
	v_tableName     VARCHAR2,
	idblinkname     VARCHAR2,
	v_beforeDate	VARCHAR2
 )
AS
  v_query      VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_columnName VARCHAR2(256);
  existsFlag   INTEGER;
  v_rowCounter  INTEGER;
  v_filterString  VARCHAR2(1000);
  v_orderByString VARCHAR2(1000);
  TYPE ColumnCursor
IS
  REF
  CURSOR;
    v_ColumnCursor ColumnCursor;
  BEGIN
	BEGIN
	  --SAVEPOINT Migrate_Process_Data;

	v_filterString := '';
	IF((Upper(v_tableName) = 'SUMMARYTABLE') OR (Upper(v_tableName) = 'WFACTIVITYREPORTTABLE')) THEN
	v_filterString := ' where ActionDateTime < to_date( '''||v_beforeDate||''''||',''DD-MM-YYYY'')  ';
	v_orderByString :=' order by ActionDateTime';
	Elsif(Upper(v_tableName) = 'WFRECORDEDCHATS') THEN
	v_filterString := ' where SaveDat < to_date( '''||v_beforeDate||''''||',''DD-MM-YYYY'')  ';
	v_orderByString :=' order by SaveDat';
	Elsif(Upper(v_tableName) = 'WFUSERRATINGLOGTABLE') THEN 
	v_filterString := ' where RatingDateTime < to_date( '''||v_beforeDate||''''||',''DD-MM-YYYY'')  ';
	v_orderByString :=' order by RatingDateTime';
	Elsif(Upper(v_tableName) = 'WFMAILQUEUEHISTORYTABLE') THEN
	v_filterString := ' where SuccessTime < to_date( '''||v_beforeDate||''''||',''DD-MM-YYYY'')  ';	
	v_orderByString :=' order by SuccessTime';
	END IF;
	
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
	 begin
	  while(1=1) loop 
	   v_query:= ' Select count(*) from '||v_sourceCabinet||'.'||v_tableName||''||idblinkname||v_filterString ||' AND ROWNUM<=100'||v_orderByString;
	   EXECUTE Immediate v_query into v_rowCounter;
	   IF(v_rowCounter=0) THEN
		EXIT;
	   END IF;
	   v_query:= 'Insert into '||v_tableName||' ('||v_colStr||') Select '||v_colStr||'  from '||v_sourceCabinet||'.'||v_tableName||idblinkname||v_filterString|| ' AND ROWNUM<=100'||v_orderByString ;
	  EXECUTE Immediate v_query ;
	  v_query := 'Delete from '||v_sourceCabinet||'.'||v_tableName||idblinkname||v_filterString|| ' AND ROWNUM<=100' ;
	  EXECUTE Immediate v_query ;
	END LOOP;
	v_query := 'UPDATE ' || v_targetCabinet || '.WFTXNCABINETBLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' || v_tableName || '''';
	EXECUTE IMMEDIATE v_query;
	end;
	
	EXCEPTION
  WHEN OTHERS THEN
	BEGIN
	  ROLLBACK ;
	  RAISE;
	END;
  END;
END;