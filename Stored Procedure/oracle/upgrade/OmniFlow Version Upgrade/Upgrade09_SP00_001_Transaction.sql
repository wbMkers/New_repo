/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE Upgrade AS
	existsFlag						INTEGER;
	v_Query							NVARCHAR2(8000);
	v_varStr						NVARCHAR2(2000);
	v_aliasName						NVARCHAR2(63);
	v_param1						NVARCHAR2(50);
	v_param2						NVARCHAR2(50);
	v_operator						INTEGER;
	v_tablexistence 				NUMBER;
	v_logStatus 					BOOLEAN;
	v_scriptName                    NVARCHAR2(100) := 'Upgrade09_SP00_001_Transaction';
	
	CURSOR Alias_Cur IS
		SELECT Alias, Param1, Param2, OPERATOR FROM VARALIASTABLE WHERE queueId = 0 ORDER BY id;
	
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
	v_logStatus := LogInsert(1,'Adding column IntroducedAt in table ProcessInstanceTable');
	BEGIN
		/* Adding column IntroducedAt in table ProcessInstanceTable*/
		SELECT COUNT(1) INTO  v_tablexistence FROM user_tables WHERE UPPER(table_name) = UPPER('PROCESSINSTANCETABLE');
		IF v_tablexistence > 0
		THEN
			existsflag :=0;
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM DUAL
				WHERE 
				NOT EXISTS(
					SELECT 1 FROM USER_TAB_COLUMNS
					WHERE UPPER(COLUMN_NAME) ='INTRODUCEDAT' 
					AND TABLE_NAME = 'PROCESSINSTANCETABLE' 
				);
			EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
			END; 

			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(1);
				EXECUTE IMMEDIATE 'ALTER TABLE ProcessInstanceTable ADD (Introducedat NVarchar2(30))';
				EXECUTE IMMEDIATE '
					UPDATE PROCESSINSTANCETABLE 
					SET introducedAt = (SELECT activityName 
							FROM ACTIVITYTABLE 
							WHERE processDefId = PROCESSINSTANCETABLE.processdefId AND activityType = 1
					)';
			END IF;
		
		END IF;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;	
	v_logStatus := LogUpdate(1);

		
	v_logStatus := LogInsert(2,'Modifying view QueueTable');
	BEGIN
		v_logStatus := LogSkip(2);
		/* Modifying view QueueTable */
		SELECT COUNT(1) INTO  v_tablexistence FROM user_tables WHERE UPPER(table_name) = UPPER('PROCESSINSTANCETABLE');
		IF v_tablexistence > 0
		THEN
			EXECUTE IMMEDIATE ' 
			CREATE OR REPLACE VIEW QueueTable
			AS
				SELECT  queuetable1.processdefid, processname, processversion, 
					queuetable1.processinstanceid, queuetable1.processinstanceid AS processinstancename, 
					queuetable1.activityid, queuetable1.activityname, 
					QUEUEDATATABLE.parentworkitemid, queuetable1.workitemid, 
					processinstancestate, workitemstate, statename, queuename, queuetype,
					assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
					introductiondatetime, PROCESSINSTANCETABLE.createddatetime AS createddatetime,
					introducedby, createdbyname, entrydatetime,
					lockstatus, holdstatus, prioritylevel, lockedbyname, 
					lockedtime, validtill, savestage, previousstage,
					expectedworkitemdelay AS expectedworkitemdelaytime,
					expectedprocessdelay AS expectedprocessdelaytime, status, 
					var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 
					var_float1, var_float2, 
					var_date1, var_date2, var_date3, var_date4, 
					var_long1, var_long2, var_long3, var_long4, 
					var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
					var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
					q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
					referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime
				FROM QUEUEDATATABLE, 
				PROCESSINSTANCETABLE,
				  (SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entrydatetime, parentworkitemid, assignmenttype,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, assigneduser, createddatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
					 FROM WORKLISTTABLE
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entrydatetime, parentworkitemid, assignmenttype,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, assigneduser, createddatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
					 FROM WORKINPROCESSTABLE
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entrydatetime, parentworkitemid, assignmenttype,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, assigneduser, createddatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
					 FROM WORKDONETABLE
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entrydatetime, parentworkitemid, assignmenttype,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, assigneduser, createddatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
					 FROM WORKWITHPSTABLE
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
					  processdefid, LastProcessedBy, processedby, activityname, activityid,
					  entrydatetime, parentworkitemid, assignmenttype,
					  collectflag, prioritylevel, validtill, q_streamid,
					  q_queueid, q_userid, assigneduser, createddatetime,
					  workitemstate, expectedworkitemdelay, previousstage,
					  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					  statename
					 FROM PENDINGWORKLISTTABLE) queuetable1
				WHERE QUEUEDATATABLE.processinstanceid = queuetable1.processinstanceid
				  AND QUEUEDATATABLE.workitemid = queuetable1.workitemid
				  AND queuetable1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid
			';
			BEGIN
				dbms_output.put_line('View QueueTable created ... ');
			END;
		END IF;
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);
		
			
	
END;
	

~
	Call Upgrade() 
~
	Drop Procedure Upgrade 
~
	