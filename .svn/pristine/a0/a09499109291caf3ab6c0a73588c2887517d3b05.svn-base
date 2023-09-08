/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveComplexData.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for Transactional data ARCHIVAL;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
10/05/2021	Sourabh Tantuway Bug 99349-iBPS 5.0 SP2 : Correcting code logic in WFMoveComplexData procedure. Data should be moved into QueuehistoryTable not WFinstrumenttable in archival cabinet.
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
create or replace
PROCEDURE WFMoveComplexData (
    v_processInstanceId                     NVarchar2,
	v_processDefId     						INTEGER,
	v_variantId        						INTEGER,
    v_sourceCabinet                         Varchar2,
    v_targetCabinet                         Varchar2,
	idblinkname								Varchar2,
	historyFlag								Varchar2,
	v_executionLogId						Integer,
	v_loggingEnabled						Varchar2
) AS
	v_queryStr                              NVARCHAR2(6000);
    v_queryStr1                             NVARCHAR2(6000);
	v_ParentObject							NVARCHAR2(50);
	v_datetime               				Date;
	v_ForeignKey							NVARCHAR2(50);
	v_ChildObject							NVARCHAR2(50);
	v_RefKey								NVARCHAR2(50);
	v_rowCount								INTEGER;
	v_tableName								NVARCHAR2(50);
	v_transactionalTable					NVARCHAR2(255);
	v_ErrorCode								INTEGER;
	v_ErrorMessage							NVARCHAR2(500);
	v_ForeignKeyValue						NVARCHAR2(50);
	Type WFComplexRecord					IS RECORD(
	ParentObject							VARCHAR2(50),
	ForeignKey								VARCHAR2(50),
	ChildObject								VARCHAR2(50),  
	RefKey									VARCHAR2(50)
	);    
	v_cmplxrecord							WFComplexRecord;
	TYPE ColumnCursor         				IS REF CURSOR;
	v_ColumnCursor            				ColumnCursor;  
	TYPE WFComplexCursor      				IS REF CURSOR;
	v_cursor                 				WFComplexCursor;
	TYPE relationCursor      				IS REF CURSOR;
	v_relationCursor              			relationCursor;
	v_InsertCondition						VARCHAR2(500);
	v_count									INT;
  v_query                 NVARCHAR2(6000);
	v_relationId            INT;
	v_startTime 			TimeStamp;
	v_endTime 				TimeStamp;
	v_executionTime	VARCHAR2(500);
BEGIN 
	v_InsertCondition:=' Where ';
	SELECT current_TimeStamp INTO v_datetime FROM DUAL;
    --DBMS_OUTPUT.PUT_LINE (TO_CHAR(v_datetime));
	--IF(historyFlag='Y') THEN
		v_transactionalTable:= 'QUEUEHISTORYTABLE';
	--ELSE
	--	v_transactionalTable:= 'WFINSTRUMENTTABLE';
	--END IF;
	v_queryStr := 'SELECT tableName FROM '||v_sourceCabinet||'.extdbconftable'||idblinkname||' WHERE ProcessDefId = '||v_processDefId||' and ProcessVariantId = '||v_variantId||' AND extobjid>1';	
	SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
	OPEN v_ColumnCursor FOR TO_CHAR(v_queryStr);	
	SELECT current_timeStamp INTO v_endTime FROM DUAL; 
		 v_executionTime:=v_endTime-v_startTime;
		IF(v_loggingEnabled='Y') THEN
			INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

		END IF;
	LOOP
		FETCH v_ColumnCursor INTO v_tableName;
                EXIT WHEN v_ColumnCursor%NOTFOUND;
				IF (UPPER(v_tableName) IS NOT NULL OR UPPER(v_tableName) <>'')  THEN	
				v_query := 'SELECT RelationId FROM '||v_sourceCabinet||'.WFVarRelationTable'||idblinkname||' WHERE processDefId = '||v_processDefId ||' and ProcessVariantId = '||v_variantId|| ' and childobject='''|| v_tablename||'''';
        --dbms_output.put_line(v_query);
				SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
				OPEN  v_relationCursor FOR TO_CHAR(v_query);
				SELECT current_timeStamp INTO v_endTime FROM DUAL; 
				v_executionTime:=v_endTime-v_startTime;
				IF(v_loggingEnabled='Y') THEN
					INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_query,v_endTime,v_executionTime);
				END IF;
				LOOP --TO CLOSE
					FETCH v_relationCursor INTO v_relationId;
					EXIT WHEN v_relationCursor%NOTFOUND;
				BEGIN
        v_count:=0;
		
				v_queryStr := 'SELECT ParentObject,ForeignKey,ChildObject,RefKey FROM '||v_sourceCabinet||'.WFVarRelationTable'||idblinkname||' WHERE processDefId = '||v_processDefId ||' and ProcessVariantId = '||v_variantId||' and RelationId= '||v_relationId;
				SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
				OPEN  v_cursor FOR TO_CHAR(v_queryStr);
				SELECT current_timeStamp INTO v_endTime FROM DUAL; 
				v_executionTime:=v_endTime-v_startTime;
				IF(v_loggingEnabled='Y') THEN
					INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

				END IF;

				LOOP
				
 					FETCH v_cursor INTO v_cmplxrecord;
					EXIT WHEN v_cursor%NOTFOUND;
					v_ParentObject := v_cmplxrecord.ParentObject;
					v_ForeignKey := v_cmplxrecord.ForeignKey;
					v_ChildObject := v_cmplxrecord.ChildObject;
					v_RefKey := v_cmplxrecord.RefKey;
					IF v_ForeignKey = 'ITEMINDEX' THEN
					  v_ForeignKey :='VAR_REC_1';
				   END IF;
					IF v_ForeignKey = 'ITEMTYPE' THEN
					  v_ForeignKey :='VAR_REC_2';
				   END IF;
				   
				   
				    IF (UPPER(v_ForeignKey) IS NOT NULL OR UPPER(v_ForeignKey) <>'')  THEN
						v_queryStr1 :='SELECT '||v_ForeignKey||' FROM '||v_targetCabinet||'.'||v_transactionalTable||' WHERE processinstanceid=N'''||v_processInstanceId||''' and workitemid=1';				  
					SELECT current_timeStamp INTO v_startTime FROM DUAL;	 
  					EXECUTE IMMEDIATE TO_CHAR(v_queryStr1) INTO v_ForeignKeyValue;
					SELECT current_timeStamp INTO v_endTime FROM DUAL; 
					v_executionTime:=v_endTime-v_startTime;
					IF(v_loggingEnabled='Y') THEN
						INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr1,v_endTime,v_executionTime);
					END IF;
        
         IF (UPPER(v_ForeignKeyValue) IS NOT NULL OR UPPER(v_ForeignKeyValue) <>'')  THEN
          if v_count >0 then
            v_InsertCondition:=v_InsertCondition||' AND ';
          end if;
					v_count:=v_count+1;
					v_InsertCondition:=	v_InsertCondition||v_RefKey||'='''||v_ForeignKeyValue||'''';
					END IF;
				END IF;
				END LOOP;
			 CLOSE v_cursor;
			
				    IF v_count > 0 THEN
						v_queryStr:='insert into '||v_targetCabinet||'.'||v_ChildObject||' SELECT * from '||v_sourceCabinet||'.'||v_ChildObject||idblinkname||v_InsertCondition;
						SELECT current_timeStamp INTO v_startTime FROM DUAL;	
						EXECUTE IMMEDIATE TO_CHAR(v_queryStr);
						SELECT current_timeStamp INTO v_endTime FROM DUAL; 
						v_executionTime:=v_endTime-v_startTime;
						IF(v_loggingEnabled='Y') THEN
							INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

						END IF;
					v_count := sql%rowcount;
					END IF;
				
				    
				    IF v_count > 0 THEN              
						v_queryStr:='DELETE FROM '||v_sourceCabinet||'.'||v_ChildObject||idblinkname||v_InsertCondition;
						SELECT current_timeStamp INTO v_startTime FROM DUAL;	
						EXECUTE IMMEDIATE TO_CHAR(v_queryStr);
						SELECT current_timeStamp INTO v_endTime FROM DUAL; 
						v_executionTime:=v_endTime-v_startTime;
						IF(v_loggingEnabled='Y') THEN
							INSERT INTO WFQueryLogTable (ExecutionLogId,query,queryExecutionDateTime,executionTime) VALUES(v_executionLogId,v_queryStr,v_endTime,v_executionTime);

						END IF;
					v_InsertCondition:=' Where ';

				    END IF;
				    EXCEPTION
				    WHEN OTHERS THEN  
						BEGIN 
					    v_ErrorCode:= SQLCODE;
					    v_ErrorMessage:=SQLERRM;								
					    DBMS_OUTPUT.PUT_LINE('Exception Occurs while moving complex data in to Target cabinet !!'); 
					    DBMS_OUTPUT.PUT_LINE('Error Code : '||v_ErrorCode);
					    DBMS_OUTPUT.PUT_LINE('v_ErrorMessage : '||v_ErrorMessage);
					    ROLLBACK;
					    CLOSE v_cursor;
					    RAISE; 
				   END;
				   END;
			 END LOOP;
			 CLOSE v_relationCursor;								
			 END IF;
	END LOOP;
	CLOSE v_ColumnCursor;
END;
