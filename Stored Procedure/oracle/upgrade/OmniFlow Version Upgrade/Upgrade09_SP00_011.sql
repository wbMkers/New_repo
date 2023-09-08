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
  Date (DD/MM/YYYY)		Change By		Change Description (Bug No. (If Any))  
  05/12/2013			Preeti Awasthi	Bug 42697 - Data in ActivityTable's Expiry column should not be updated if version upgrade is from 7.1 or 8.0
  05/02/2015			chitvan Chhabra Bug 53167 - Version Upgrade : Correcting printfaxemaildoctype and Printfax email and Wduration based issues
  26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
  ________________________________________________________________________________*/
CREATE OR REPLACE PROCEDURE ActivityExpiryProc AS  
	v_pId					Integer; 
	v_expiry                NVarchar2(200);
	v_activityId            Integer;
	v_durationId            Integer; 
	v_days                  NVarchar2(200); 
    v_hours                 Integer;
	v_hourStr        	    NVarchar2(200);
	v_minutes        		Integer; 
	v_minuteStr     	    NVarchar2(200);
	activity_cursor         Integer;
	retVal                  Integer;
	v_index            		Integer; 
    v_div                   Integer; 
	v_flag            	    Integer;
	existsFlag				Integer;
	v_logStatus 			BOOLEAN;
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_011';	
	
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
		--dbms_output.put_line ('dbQuery '|| dbQuery);	
		EXECUTE IMMEDIATE dbQuery using v_stepNumber,v_scriptName,v_stepDetails;
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogInsert completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogSkip(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogUpdate(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery1 VARCHAR2(1000);
	dbQuery2 VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery1 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery1);
		EXECUTE IMMEDIATE (dbQuery2);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
	FUNCTION LogUpdateError(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN;
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdateError completed with status: ');
		RETURN DBString;
		END;
	END;
	
BEGIN
	
	v_logStatus := LogInsert(1,'Upadting WFDurationTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			Select 1 INTO existsFlag FROM DUAL WHERE EXISTS (Select * from WFCABVERSIONTABLE  WHERE CABVERSION IN ('7.1','8.0'));
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					existsFlag := 0;
		END;
		IF existsFlag = 0 THEN
		BEGIN
			v_logStatus := LogSkip(1);
			activity_cursor := DBMS_SQL.OPEN_CURSOR;
		
			DBMS_SQL.PARSE(
				activity_cursor, 
				'SELECT ProcessDefId, ActivityId , Expiry FROM ActivityTABLE WHERE Expiry IS NOT NULL  ',
				DBMS_SQL.NATIVE);
			
			DBMS_SQL.DEFINE_COLUMN(activity_cursor, 1, v_pId);
			DBMS_SQL.DEFINE_COLUMN(activity_cursor, 2, v_activityId);
			DBMS_SQL.DEFINE_COLUMN(activity_cursor, 3, v_expiry, 2000);
			
			retVal := DBMS_SQL.EXECUTE(activity_cursor);
			
			LOOP
				IF DBMS_SQL.FETCH_ROWS(activity_cursor) = 0 THEN
					EXIT;
				END IF;
			
				DBMS_SQL.COLUMN_VALUE(activity_cursor, 1, v_pId);
				DBMS_SQL.COLUMN_VALUE(activity_cursor, 2, v_activityId);
				DBMS_SQL.COLUMN_VALUE(activity_cursor, 3, v_expiry);
				v_expiry := RTRIM(LTRIM(v_expiry));
				v_flag := 0;
				IF  v_expiry is null or LENGTH(v_expiry ) =  null or LENGTH(v_expiry) <= 0   or UPPER(v_expiry) = 'NULL'  THEN
					v_flag := 1;
				ELSE
					v_days := NVL(RTRIM(LTRIM(SUBSTR(v_expiry, 1, INSTR(v_expiry , '*', 1, 1) - 1))) , '0' );
					v_hourStr := NVL(RTRIM(LTRIM(SUBSTR(v_expiry, INSTR(v_expiry , '+', 1, 1) + 1 ))) , '0' );
					v_minuteStr := '0';
					IF UPPER(v_days) = 'NULL'  THEN
						v_days := '0';
					END IF;

					IF UPPER( v_hourStr) = 'NULL'  THEN
						v_hourStr := '0';	
					ELSE
						v_index := INSTR(v_hourStr , '.', 1, 1); 
						IF v_index > 0 THEN
							v_hours := SUBSTR(v_hourStr, 1, v_index - 1);
							v_minutes := SUBSTR(v_hourStr, v_index + 1 , 2 );
							v_div := floor(v_minutes/10);
							IF v_div <= 0 THEN
								v_minutes := v_minutes*10;
							END IF;
							v_minutes := floor((v_minutes*60)/100);
							v_hours := v_hours + floor(v_minutes/60);
							v_minutes := MOD(v_minutes, 60);
							v_hourStr := NVL(RTRIM(LTRIM(TO_CHAR(v_hours))) , '0' );
							v_minuteStr := NVL(RTRIM(LTRIM(TO_CHAR(v_minutes))), '0' );
						END IF;
					END IF;
					IF v_days = '0'  and v_hourStr != '0'
					THEN
						--v_days:=floor(v_minutes/60);
						
						--dbms_output.put_line('Attempting to Update days');
						v_index := INSTR(v_hourStr , '.', 1, 1); 
						IF v_index > 0 THEN
							NULL;
						ELSE
							v_hours :=v_hourStr;
							v_days:=floor(v_hours/24);
							v_hours:=MOD(v_hours, 24);
							v_hourStr:=v_hours;
							--dbms_output.put_line('days updated');
							
						END IF;	
						
					
					END IF;
					
					IF v_days = '0'  and v_hourStr = '0'  and v_minuteStr = '0' THEN
						v_flag := 1;
					END IF;
				END IF;

				IF v_flag = 1 THEN
					BEGIN	
					UPDATE ActivityTable SET Expiry = null , HoldTillVariable = null , NeverExpireFlag = 'N' 
						WHERE ProcessDefId = v_pId
						and ActivityId = v_activityId;

					EXCEPTION  
						WHEN OTHERS THEN 
						ROLLBACK ;
						RAISE;
					END ;
				ELSE
					BEGIN
					SELECT max(durationId) INTO v_durationId FROM WFDurationTable WHERE processdefid = v_pId;
					
					EXCEPTION  
						WHEN NO_DATA_FOUND THEN
						v_durationId := 0;
						
						WHEN OTHERS THEN 
						ROLLBACK ;
						RAISE;
						
					END ;
					IF (v_durationId IS NULL) THEN 
						v_durationId := 0;
					END IF;
					v_durationId := v_durationId + 1;
					
					BEGIN	
					UPDATE ActivityTable SET Expiry = RTRIM(LTRIM(TO_CHAR(v_durationId))) 
						WHERE ProcessDefId = v_pId
						and ActivityId = v_activityId;

					EXCEPTION  
						WHEN OTHERS THEN 
						ROLLBACK ;
						RAISE;
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
						RAISE;
					
					END ;
				END IF;


				COMMIT ;
			
				
			END LOOP;
			DBMS_SQL.CLOSE_CURSOR(activity_cursor);
		END;
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

END;
	
	 
~
call ActivityExpiryProc()
~
Drop Procedure ActivityExpiryProc
~