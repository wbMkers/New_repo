/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveAuditTrailData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for Transactional data ARCHIVAL;
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
PROCEDURE WFMoveAuditTrailData (
    v_processInstanceId                     NVarchar2,
  	v_processDefId                     		NVarchar2,
    v_sourceCabinet                         Varchar2,
    v_targetCabinet                         Varchar2,
	idblinkname								Varchar2,
	v_fromDate        						VARCHAR2,
	v_toDate								VARCHAR2,
	v_executionLogId						INTEGER,
	v_loggingEnabled						VARCHAR2

) AS
	v_query                              VARCHAR2(6000);
	v_startTime							TimeStamp;
	v_endTime							TimeStamp;
	v_executionTime	VARCHAR2(500);
	c_name VARCHAR2(800);
    c_name2 VARCHAR2(800);
	existsFlag INTEGER;
    i_flag integer;
	CURSOR c_attributemessagetable is  
      select  COLUMN_NAME  from user_tab_columns where table_name=UPPER('wfattributemessagetable');  
	BEGIN 
	v_query:=   'Insert into '||v_targetCabinet||'.WFHistoryRouteLogTable Select * from '
          ||v_sourceCabinet||'.WFCurrentRouteLogTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
	SELECT current_timeStamp INTO v_startTime FROM DUAL;    
	EXECUTE Immediate v_query ;
	SELECT current_timeStamp INTO v_endTime FROM DUAL; 
	v_executionTime:=v_endTime-v_startTime;
	IF(v_loggingEnabled='Y') THEN
		INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
	END IF;
	v_query:=   'Delete from ' 
          ||v_sourceCabinet||'.WFCurrentRouteLogTable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
	SELECT current_timeStamp INTO v_startTime FROM DUAL;     
	EXECUTE Immediate v_query ;
	SELECT current_timeStamp INTO v_endTime FROM DUAL; 
	v_executionTime:=v_endTime-v_startTime;
	IF(v_loggingEnabled='Y') THEN
		INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
	END IF;
	
	BEGIN
	OPEN c_attributemessagetable; 
    i_flag:=1;
   LOOP  
      FETCH c_attributemessagetable into c_name; 
      EXIT WHEN c_attributemessagetable%notfound;
      IF(i_flag = 1) THEN
        BEGIN
            c_name2 := c_name;
            i_flag:=2;
        END;
        else
        c_name2:=c_name2||','||c_name;
        END IF;
      --dbms_output.put_line(c_name2);  
   END LOOP;  
   CLOSE c_attributemessagetable; 
	END;
	
	v_query:=   'Insert into '||v_targetCabinet||'.WFATTRIBUTEMESSAGEHISTORYTABLE ' ||'('||c_name2||')' ||'Select '||c_name2||' from '
          ||v_sourceCabinet||'.wfattributemessagetable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
	--dbms_output.put_line(v_query);  
	SELECT current_timeStamp INTO v_startTime FROM DUAL; 
    EXECUTE Immediate v_query ;
	SELECT current_timeStamp INTO v_endTime FROM DUAL; 
	v_executionTime:=v_endTime-v_startTime;
	IF(v_loggingEnabled='Y') THEN
		INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
	END IF;
	v_query:=   'Delete from ' 
          ||v_sourceCabinet||'.wfattributemessagetable'||idblinkname||' where ProcessInstanceId='''||v_processInstanceId ||'''';
	SELECT current_timeStamp INTO v_startTime FROM DUAL; 
    EXECUTE Immediate v_query ;
	SELECT current_timeStamp INTO v_endTime FROM DUAL; 
	v_executionTime:=v_endTime-v_startTime;
	IF(v_loggingEnabled='Y') THEN
		INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
	END IF;
	Exception 
    WHEN  OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('Error in Moving audit trail data for Workitemid '||v_processInstanceId);
	--DBMS_OUTPUT.PUT_LINE('Variant table name is '||v_variantTableName);
	ROLLBACK;
	RAISE;
  END;
