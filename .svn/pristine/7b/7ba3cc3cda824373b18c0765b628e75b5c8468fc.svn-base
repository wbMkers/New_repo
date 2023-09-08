/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE Upgrade AS
	
	v_logStatus 			BOOLEAN;
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_006_Transaction';
	v_tablexistence 				NUMBER;
		
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
		v_logStatus := LogInsert(1,'Creating VIEW WFWORKLISTVIEW_0');
		BEGIN
		v_logStatus := LogSkip(1);
		
		EXECUTE IMMEDIATE '
			CREATE OR REPLACE VIEW WFWORKLISTVIEW_0 
			AS 
				SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, WORKLISTTABLE.ProcessDefId, 
					 ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
					 LockStatus, LockedByName, ValidTill, CreatedByName, 
					 PROCESSINSTANCETABLE.CreatedDateTime, Statename, CheckListCompleteFlag, 
					 EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, 
					 AssignedUser, WORKLISTTABLE.WorkItemId, QueueName, AssignmentType, 
					 ProcessInstanceState, QueueType, Status, Q_QueueID,
					 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
					 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, 
					 CollectFlag, WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
					 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay , 
					 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
				FROM	WORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
				WHERE	WORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
				AND	WORKLISTTABLE.Workitemid =QueueDatatable.Workitemid 
				AND	WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
				UNION ALL
				SELECT PENDINGWORKLISTTABLE.ProcessInstanceId, 
					 PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
					 PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, 
					 PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, 
					 CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime, Statename, 
					 CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, 
					 IntroducedBy, AssignedUser, PENDINGWORKLISTTABLE.WorkItemId, 
					 QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
					 Q_QueueID,(ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
					 ReferredByname, referredTo AS ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, 
					 PENDINGWORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
					 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
					 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
				FROM	PENDINGWORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE   
				WHERE   PENDINGWORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId  
				AND	PENDINGWORKLISTTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
				AND	PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId	
				UNION	ALL
				SELECT WORKINPROCESSTABLE.ProcessInstanceId, 
					 WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
					 WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, 
					 ActivityName, PriorityLevel,InstrumentStatus, LockStatus, LockedByName, 
					 ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime,  
					 Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, 
					 IntroductionDateTime, IntroducedBy, AssignedUser, 
					 WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, 
					 ProcessInstanceState, QueueType, Status, Q_QueueID, 
					 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime,  
					 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag,
					 WORKINPROCESSTABLE.ParentWorkItemId,ProcessedBy, LastProcessedBy, 
					 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
					 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
				FROM	WORKINPROCESSTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
				WHERE	WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
				AND	WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
				AND	WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 
				';
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(1);   
				raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
		END;
		v_logStatus := LogUpdate(1);
		
		v_logStatus := LogInsert(2,'Creating VIEW WFWORKINPROCESSVIEW_0 ');
		BEGIN
		v_logStatus := LogSkip(2);
		EXECUTE IMMEDIATE '	
			CREATE OR REPLACE VIEW WFWORKINPROCESSVIEW_0 
			AS 
				SELECT WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS WorkItemName,WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
					LockStatus,LockedByName,Validtill,CreatedByName,
					PROCESSINSTANCETABLE.CreatedDateTime,Statename,
					CheckListCompleteFlag,EntryDateTime,LockedTime,
					IntroductionDateTime,IntroducedBy,AssignedUser,
					WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,
					ProcessInstanceState,QueueType,	Status,Q_QueueId, 
					(ExpectedWorkItemDelay - entrydatetime)*24  AS TurnaroundTime,
					ReferredByname,NULL ReferTo, guid,Q_userId 
				FROM   WORKINPROCESSTABLE,PROCESSINSTANCETABLE,QUEUEDATATABLE 
				WHERE  WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId
				AND    WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
				AND    WORKINPROCESSTABLE.ProcessInstanceid = PROCESSINSTANCETABLE.ProcessInstanceId ';
				
		EXCEPTION
			WHEN OTHERS THEN
				v_logStatus := LogUpdateError(2);   
				raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
		END;
		v_logStatus := LogUpdate(2);	
	END IF;

	


END;
~

call Upgrade()

~

Drop Procedure Upgrade




