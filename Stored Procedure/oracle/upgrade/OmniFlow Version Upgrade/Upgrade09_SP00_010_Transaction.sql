/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE Upgrade07 AS
	existsFlag			INTEGER;
	v_logStatus 		BOOLEAN;
	v_tablexistence 	NUMBER;
	v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_010_Transaction';
	
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


	SELECT COUNT(1) INTO  v_tablexistence FROM user_tables WHERE UPPER(table_name) = UPPER('WORKLISTTABLE');
	IF v_tablexistence > 0
	THEN
		v_logStatus := LogInsert(1,'Adding new column CalendarName in QueueDataTable');
		BEGIN
			/*WFS_8.0_026 - workitem specific calendar*/
			
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('QueueDataTable') 
				AND 
				COLUMN_NAME=UPPER('CalendarName');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(1);
					EXECUTE IMMEDIATE 'ALTER TABLE QueueDataTable Add ( CalendarName NVARCHAR2(255) )';
					DBMS_OUTPUT.PUT_LINE('Table QueueDataTable altered with a new Column CalendarName');
			END;
			
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(1);   
				raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
		END;
		v_logStatus := LogUpdate(1);

		v_logStatus := LogInsert(2,'Adding new column ExportStatus in PENDINGWORKLISTTABLE');
		BEGIN
			BEGIN
			existsFlag := 0;	
				BEGIN 
					SELECT 1 INTO existsFlag 
					FROM DUAL 
					WHERE 
						NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
							WHERE UPPER(TABLE_NAME) = 'PENDINGWORKLISTTABLE'
							AND UPPER(COLUMN_NAME) = 'EXPORTSTATUS'			
						);  
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END; 
				IF existsFlag = 1 THEN
					v_logStatus := LogSkip(2);
					EXECUTE IMMEDIATE 'ALTER TABLE "PENDINGWORKLISTTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
				END IF;
			END;
			
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(2);   
				raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
		END;
		v_logStatus := LogUpdate(2);

		v_logStatus := LogInsert(3,'Adding new column ExportStatus in PENDINGWORKLISTTABLE');
		BEGIN
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('PENDINGWORKLISTTABLE') 
				AND 
				COLUMN_NAME=UPPER('ExportStatus');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(3);
					EXECUTE IMMEDIATE 'ALTER TABLE PENDINGWORKLISTTABLE ADD ExportStatus NVARCHAR2(1) DEFAULT (N''N'')';
					DBMS_OUTPUT.PUT_LINE('Table PENDINGWORKLISTTABLE altered with new Column ExportStatus');
			END;
				
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(3);   
				raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
		END;
		v_logStatus := LogUpdate(3);




		v_logStatus := LogInsert(4,'Create VIEW QUEUETABLE');
		BEGIN
			BEGIN
				v_logStatus := LogSkip(4);
				EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW QUEUETABLE 
				AS
				SELECT queuetable1.processdefid, processname, processversion,queuetable1.processinstanceid,
				 queuetable1.processinstanceid AS processinstancename, 
				 queuetable1.activityid, queuetable1.activityname, 
				 QUEUEDATATABLE.parentworkitemid, queuetable1.workitemid, 
				 processinstancestate, workitemstate, statename, queuename, queuetype,
				 assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
				 introductiondatetime, PROCESSINSTANCETABLE.createddatetime AS createddatetime,
				 introducedby, createdbyname, entrydatetime,lockstatus, holdstatus, 
				 prioritylevel, lockedbyname, lockedtime, validtill, savestage, 
				 previousstage,	expectedworkitemdelay AS expectedworkitemdelaytime,
					 expectedprocessdelay AS expectedprocessdelaytime, status, 
				 var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 
				 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, 
				 var_long1, var_long2, var_long3, var_long4, 
				 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,
				 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
				 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
				 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName
				FROM	QUEUEDATATABLE, 
				PROCESSINSTANCETABLE,
				(SELECT processinstanceid, workitemid, processname, processversion,
					 processdefid, LastProcessedBy, processedby, activityname, activityid,
					 entrydatetime, parentworkitemid, assignmenttype,
					 collectflag, prioritylevel, validtill, q_streamid,
					 q_queueid, q_userid, assigneduser, createddatetime,
					 workitemstate, expectedworkitemdelay, previousstage,
					 lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					 statename
				FROM	WORKLISTTABLE
					UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,collectflag, 
					prioritylevel, validtill, q_streamid,q_queueid, q_userid, 
					assigneduser, createddatetime,workitemstate, expectedworkitemdelay, 
					previousstage,lockedbyname, lockstatus, lockedtime, queuename, 
					queuetype,statename
				FROM   WORKINPROCESSTABLE
					UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   WORKDONETABLE
				UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   WORKWITHPSTABLE
				UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   PENDINGWORKLISTTABLE) queuetable1
				WHERE   QUEUEDATATABLE.processinstanceid = queuetable1.processinstanceid
				AND	QUEUEDATATABLE.workitemid = queuetable1.workitemid
				AND	queuetable1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid';
			END;
				
			
				
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(4);   
				raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
		END;
		v_logStatus := LogUpdate(4);
	END IF;
	
	
	
END;

~
call Upgrade07()

~

DROP PROCEDURE Upgrade07

~