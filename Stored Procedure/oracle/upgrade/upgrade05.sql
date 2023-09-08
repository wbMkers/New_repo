/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Phoenix
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: upgrade05.sql
		Author					: Shilpi Srivastava
		Date written(DD/MM/YYYY): 01/02/2008
		Description				: Upgrade Script for new features of Multiple Exception and Minute support
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  20/06/2014        Kanika Manik	PRD Bug 41694 - Value of Expiry before and after version upgradation are not same in case the Expiry value is present like (90 * 24 + 0) before version upgrade.
  20/06/2014        Kanika Manik    PRD Bug 41706 - Changes done in version Upgrade of OF 9.0   
________________________________________________________________________________
  ________________________________________________________________________________
  ________________________________________________________________________________*/
/*******************************************Multiple Raise/Clear of Exceptions*********************************************/
CREATE OR REPLACE PROCEDURE MultipleExceptionProc AS 
BEGIN
	UPDATE ExceptionTable SET ExcpSeqId = ExcpSeqId - 1 WHERE ActionId = 10;
		EXCEPTION  
			WHEN OTHERS THEN 
			ROLLBACK ;
END ;

~

/**********************************************Duration Changes for ProcessTurnAroundTime***********************************************/
CREATE OR REPLACE PROCEDURE ProcessTATProc AS  
	v_pId			Integer; 
	v_processTAT            Integer;
	v_durationId            Integer; 
	v_days                  Integer; 
        v_hours                 Integer;
	process_cursor		Integer;
	retVal                  Integer;
	v_mod                 Integer;
	
	BEGIN  
		process_cursor := DBMS_SQL.OPEN_CURSOR;
		
		DBMS_SQL.PARSE(
			process_cursor, 
			' SELECT processDefId, processTurnAroundTime FROM ProcessDefTABLE WHERE ProcessTurnAroundTime IS NOT NULL ',
			DBMS_SQL.NATIVE);
		
		DBMS_SQL.DEFINE_COLUMN(process_cursor, 1, v_pId);
		DBMS_SQL.DEFINE_COLUMN(process_cursor, 2, v_processTAT);
		
		retVal := DBMS_SQL.EXECUTE(process_cursor);
		
		LOOP
			IF DBMS_SQL.FETCH_ROWS(process_cursor) = 0 THEN
				EXIT;
			END IF;
			
			DBMS_SQL.COLUMN_VALUE(process_cursor, 1, v_pId);
			DBMS_SQL.COLUMN_VALUE(process_cursor, 2, v_processTAT);
			
			v_mod := MOD(v_processTAT, 24);
			v_days := floor((v_processTAT -  v_mod)/24);
			v_hours := v_mod;
			
			BEGIN
			SELECT max(durationId) INTO v_durationId FROM WFDurationTable WHERE processdefid = v_pId;
			IF v_durationId IS NULL THEN
			v_durationId :=0;
			END IF;
			
			EXCEPTION  
				WHEN NO_DATA_FOUND THEN
				v_durationId := 0;	
				
				WHEN OTHERS THEN 
				ROLLBACK ;
				
			END ;
			v_durationId := v_durationId + 1;
			
			BEGIN	
			UPDATE ProcessDefTable SET processTurnAroundTime = v_durationId WHERE processDefId = v_pId;
			EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
			END ;
			
			BEGIN
			Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) VALUES (v_pId, v_durationId, 0, 0, v_days, v_hours, 0, 0 ,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
			EXCEPTION  
				WHEN OTHERS THEN
				ROLLBACK ;
			
			END ;
			COMMIT ;
			
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(process_cursor);
	END ; 

~

/**********************************************Duration Changes for ActivityTurnAroundTime***********************************************/
CREATE OR REPLACE PROCEDURE ActivityTATProc AS  
	v_pId			Integer; 
	v_activityTAT           Integer;
	v_activityId            Integer;
	v_durationId            Integer; 
	v_days                  Integer; 
        v_hours                 Integer;
	activity_cursor         Integer;
	retVal                  Integer;
	v_mod                Integer;

	BEGIN  
		activity_cursor := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(
			activity_cursor, 
			'SELECT processDefId, activityId , activityTurnAroundTime FROM ActivityTABLE WHERE activityTurnAroundTime IS NOT NULL ',
			DBMS_SQL.NATIVE);
		
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 1, v_pId);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 2, v_activityId);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 3, v_activityTAT);
		
		retVal := DBMS_SQL.EXECUTE(activity_cursor);
		LOOP
			IF DBMS_SQL.FETCH_ROWS(activity_cursor) = 0 THEN
				EXIT;
			END IF;
			
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 1, v_pId);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 2, v_activityId);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 3, v_activityTAT);
			
			v_mod := MOD(v_activityTAT, 24);
			v_days := floor((v_activityTAT - v_mod)/24);
			v_hours := v_mod;
			
			BEGIN
			SELECT max(durationId) INTO v_durationId FROM WFDurationTable WHERE processdefid = v_pId;
			IF v_durationId IS NULL THEN
			v_durationId :=0;
			END IF;
			
			EXCEPTION  
				WHEN NO_DATA_FOUND THEN
				v_durationId := 0;

				WHEN OTHERS THEN 
				ROLLBACK ;
				
			END ;
			v_durationId := v_durationId + 1;
			
			BEGIN	
			UPDATE ActivityTable SET activityTurnAroundTime = v_durationId WHERE processDefId = v_pId and activityid = v_activityId;
			EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
			END ;
			
			BEGIN
			Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) VALUES (v_pId, v_durationId, 0, 0, v_days, v_hours, 0, 0 ,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
			EXCEPTION  
				WHEN OTHERS THEN
				ROLLBACK ;
			
			END ;

			COMMIT ;
			
			
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(activity_cursor);

	END ; 

~

/**********************************************Duration Changes for Escalation***********************************************/

CREATE OR REPLACE PROCEDURE EscalationProc AS  
	v_pId			Integer; 
	v_activityTAT           Integer;
	v_activityId            Integer;
	v_durationId            Integer; 
	v_days                  NVarchar2(200); 
        v_hourStr             NVarchar2(200);
	v_hours                 Integer; 
	v_minutes            Integer;
	v_minuteStr         NVarchar2(200);
	v_ruleType             NVarchar2(20);
	v_ruleId                Integer;
	v_param3                NVarchar2(200);
	v_expression           NVarchar2(200);  
	v_mode                  NVarchar2(200);
	v_param3Val             NVarchar2(200);
	activity_cursor         Integer;
	retVal                  Integer;
	v_index               Integer;
	v_div                   Integer;
	v_flag                 Integer;

	BEGIN  
		activity_cursor := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(
			activity_cursor, 
			'SELECT processDefId , activityId , Param3 ,  RuleId , RuleType FROM RuleOperationTABLE WHERE OperationType = 24 AND Param3 IS NOT NULL ',
			DBMS_SQL.NATIVE);
		
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 1, v_pId);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 2, v_activityId);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 3, v_param3, 2000);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 4, v_ruleId);
		DBMS_SQL.DEFINE_COLUMN(activity_cursor, 5, v_ruleType,20 );
		
		retVal := DBMS_SQL.EXECUTE(activity_cursor);
		
		LOOP
		
			IF DBMS_SQL.FETCH_ROWS(activity_cursor) = 0 THEN
				EXIT;
			END IF;
		
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 1, v_pId);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 2, v_activityId);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 3, v_param3);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 4, v_ruleId);
			DBMS_SQL.COLUMN_VALUE(activity_cursor, 5, v_ruleType);
		
			v_flag := 0;
			v_param3 := RTRIM(LTRIM(v_param3));
			IF  v_param3 is null or length(v_param3) = null or length(v_param3)  <= 0 or UPPER(v_param3) = 'NULL'  THEN
				v_flag := 1;
			ELSE
				v_index := INSTR(v_param3 , '</Expression>', 1, 1);
				IF v_index > 0 THEN
					v_expression := NVL(RTRIM(LTRIM(SUBSTR(v_param3, INSTR(v_param3 , '<Expression>', 1, 1) + 12, INSTR(v_param3 , '</Expression>', 1, 1) - INSTR(v_param3 , '<Expression>', 1, 1) - 12 ))) , '0' );
					
					v_mode := SUBSTR(v_param3, INSTR(v_param3 , '<Mode>', 1, 1));
					v_days := NVL(RTRIM(LTRIM(SUBSTR(v_expression, 1, INSTR(v_expression , '*', 1, 1) - 1))) , '0' );
					v_hourStr := NVL(RTRIM(LTRIM(SUBSTR(v_expression, INSTR(v_expression , '+', 1, 1) + 1 ))) , '0' );
					
					v_minuteStr := '0';
					
					IF UPPER(v_days) = 'NULL'  THEN
						v_days := '0';
					END IF;
					
					IF UPPER(v_hourStr) = 'NULL'    THEN
						v_hourStr := '0';
					ELSE
						v_index := INSTR(v_hourStr , '.', 1, 1);
						IF v_index > 0 THEN
							v_hours :=  SUBSTR(v_hourStr, 1, v_index - 1);
							v_minutes := SUBSTR(v_hourStr, v_index + 1 , 2);
							v_div := floor(v_minutes/10);
							IF v_div <= 0 THEN
								v_minutes := v_minutes*10;
							END IF;
							v_minutes := floor((v_minutes*60)/100);
							v_hours := v_hours + floor(v_minutes/60);
							v_minutes := MOD(v_minutes, 60);
							v_hourStr := NVL(RTRIM(LTRIM(TO_CHAR(v_hours))), '0' );
							v_minuteStr := NVL(RTRIM(LTRIM(TO_CHAR(v_minutes))), '0' );
						END IF;
					END IF;
					IF v_days = '0' and v_hourStr = '0'  and v_minuteStr = '0' THEN
						v_flag := 1;
					END IF;
					
				ELSE
					v_days := RTRIM(LTRIM(v_param3));
					v_hourStr := '0';
					v_minuteStr := '0' ;
					v_flag := 2;
				END IF;
				
			END IF;
			
			IF v_flag = 1 THEN
				BEGIN
					UPDATE RuleOperationTable SET Param3 = null, Type3 = null
						WHERE ProcessDefId = v_pId  
						and ActivityId = v_activityId 
						and RuleId = v_ruleId 
						and RuleType = v_ruleType;
				EXCEPTION  
					WHEN OTHERS THEN 
						ROLLBACK ;
				END ;
			
			ELSE
				BEGIN
					SELECT max(durationId) INTO v_durationId FROM WFDurationTable WHERE processdefid = v_pId;
					IF v_durationId IS NULL THEN
					v_durationId :=0;
					END IF;
			
				EXCEPTION  
					WHEN NO_DATA_FOUND THEN
						v_durationId := 0;

					WHEN OTHERS THEN 
						ROLLBACK ;
				END ;
				v_durationId := v_durationId + 1;
				
				IF v_flag = 2 THEN
					v_param3Val := RTRIM(LTRIM(TO_CHAR(v_durationId)));
				ELSE
					v_param3Val := '<Expression>' || RTRIM(LTRIM(TO_CHAR(v_durationId))) || '</Expression>' || v_mode;
				END IF;
				
				v_param3Val := RTRIM(LTRIM(v_param3Val));
				
				BEGIN
					UPDATE RuleOperationTable SET Param3 = v_param3Val
						WHERE ProcessDefId = v_pId  
							and ActivityId = v_activityId 
							and RuleId = v_ruleId 
							and RuleType = v_ruleType;
			
				EXCEPTION  
					WHEN OTHERS THEN 
						ROLLBACK ;
				
				END ;
				
				BEGIN
					Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) VALUES (v_pId, v_durationId, 0, 0, v_days, v_hourStr, v_minuteStr, 0 ,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
				EXCEPTION  
					WHEN OTHERS THEN
						ROLLBACK ;
				END ;

			END IF;
			
			COMMIT ;
			
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(activity_cursor);

	END ; 

~

/**********************************************Executing above made all stored procedures ***********************************************/

CREATE OR REPLACE PROCEDURE AllUPGRADE AS 

cnt Integer;
retVal Integer;
v_lastSeqValue Integer;
v_msgCount			INTEGER;

BEGIN
	cnt := 0;
	BEGIN
		Select 0 into cnt FROM WFCabVersionTable Where Remarks = 'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP';
		EXCEPTION  
				WHEN NO_DATA_FOUND THEN
				cnt := 1;
				WHEN OTHERS THEN 
				ROLLBACK ;
	END ;
	If cnt = 1 THEN
	BEGIN

		/* If WFMessageTable contains unprocessed message, Upgrade must be halted - Varun Bhansaly */
		BEGIN
			SELECT COUNT(*) INTO v_msgCount FROM WFMessageTable;
			SELECT cabVersionId.CURRVAL INTO v_lastSeqValue FROM DUAL;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				v_msgCount := 0;
		END;
		IF(v_msgCount > 0) THEN
			UPDATE WFCabVersionTable SET Remarks = Remarks || N' - Upgrade Halted! WFMessageTable contains ' || v_msgCount || N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  v_lastSeqValue;
			COMMIT;
			RAISE_APPLICATION_ERROR(-20999, 'Upgrade Halted! WFMessageTable contains ' || v_msgCount || ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.');
		END IF;
		
		
		BEGIN
		MultipleExceptionProc();
		EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
				RAISE_APPLICATION_ERROR(-20999, 'Execption encountered while execution of MultipleExceptionProc()');
		END ;
		
		
		BEGIN
		ProcessTATProc();
		EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
				RAISE_APPLICATION_ERROR(-20999, 'Execption encountered while execution of ProcessTATProc()');
		END ;
		
		BEGIN
		ActivityTATProc();
		EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
				RAISE_APPLICATION_ERROR(-20999, 'Execption encountered while execution of ActivityTATProc()');
		END ;
		
		
		BEGIN
		EscalationProc();
		EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
				RAISE_APPLICATION_ERROR(-20999, 'Execption encountered while execution of EscalationProc()');
		END ;
	
		BEGIN
			INSERT INTO WFCabVersionTable(CabVersion, CabVersionId, CreationDate, LastModified, Remarks , Status) VALUES ('MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT' , CabVersionID.NextVal, sysdate,  sysdate, 'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP', 'Y' );
		EXCEPTION  
				WHEN OTHERS THEN 
				ROLLBACK ;
		END ;
		
	END ;
	END IF;
	COMMIT ;
END ;

~
/************************************************************Execute Allupgrade************************************/
 call  AllUPGRADE()
 ~
 DROP PROCEDURE  AllUPGRADE
 ~
 DROP PROCEDURE  MultipleExceptionProc
 ~
DROP PROCEDURE  ProcessTATProc
~
DROP PROCEDURE  ActivityTATProc
~
DROP PROCEDURE  EscalationProc
~