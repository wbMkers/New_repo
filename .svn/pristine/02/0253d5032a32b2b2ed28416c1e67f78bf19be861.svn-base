/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFTransferData.sql
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 13/12/2007
	Description					: Script to move data to history tables for workitems
									- Reached exit workstep
									- Aborted
									- Discarded
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
08/02/2008		Ashish Mangla		Bugzilla Bug 3326 (ProcessInstanceState for Discarded Workitems was going as that of completed)

_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFTransferData() RETURNS INTEGER AS '
	DECLARE 
			v_CRLLogId					INTEGER; 
			v_exitSignal				INTEGER;
			v_CRLProcessInstanceId		VARCHAR(64); 
			v_queryStr					VARCHAR(1024); 
			cursor1						REFCURSOR;
	BEGIN 
		RAISE NOTICE ''WFTransfer() - Execution Begins''; 
		v_CRLLogId := 0;
		v_exitSignal := 1;
--		v_ProcessInstanceDiscarded := 3;
--		v_ProcessInstanceRouted	:= 5;
--		v_ProcessInstanceCompleted := 20;
			
		WHILE(v_exitSignal = 1) LOOP 
			v_queryStr := ''SELECT  LogId, ProcessInstanceId FROM CURRENTROUTELOGTABLE WHERE ActionId IN (3, 5, 20) AND LogId > '' || v_CRLLogId || '' ORDER BY LogId LIMIT 100''; 
			OPEN cursor1 FOR EXECUTE v_queryStr;
			LOOP
				FETCH cursor1 INTO v_CRLLogId, v_CRLProcessInstanceId;
				IF(NOT FOUND) THEN
					v_exitSignal := 0;
					EXIT;
				END IF;

				INSERT INTO QueueHistoryTable 
					(ProcessDefId, ProcessName, ProcessVersion, ProcessInstanceId, 
					ProcessInstanceName, ActivityId, ActivityName, ParentWorkItemId, 
					WorkItemId, ProcessInstanceState, WorkItemState, Statename, 
					QueueName, QueueType, AssignedUser, AssignmentType, InstrumentStatus, 
					CheckListCompleteFlag, IntroductionDateTime, CreatedDateTime, 
					IntroducedBy, CreatedByName, EntryDateTime, LockStatus, HoldStatus, 
					PriorityLevel, LockedByName, LockedTime, ValidTill, SaveStage, 
					PreviousStage, ExpectedWorkItemDelayTime, ExpectedProcessDelayTime, 
					Status, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, 
					VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, 
					VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, 
					VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, 
					Q_StreamId, Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, ReferredTo, 
					ReferredToName, ReferredBy, ReferredByName, CollectFlag, CompletionDateTime) 
				SELECT 
					a.ProcessDefId, ProcessName, ProcessVersion, a.ProcessInstanceId, 
					a.ProcessInstanceId, ActivityId, ActivityName, a.ParentWorkItemId, 
					a.WorkItemId, ProcessInstanceState, WorkItemState, Statename, QueueName, 
					QueueType, AssignedUser, AssignmentType, InstrumentStatus, 
					CheckListCompleteFlag, IntroductionDateTime, a.CreatedDateTime, 
					IntroducedBy, CreatedByName, EntryDateTime, LockStatus, HoldStatus, 
					PriorityLevel, LockedByName, LockedTime, ValidTill, SaveStage, 
					PreviousStage, ExpectedWorkItemDelay, ExpectedProcessDelay, 
					Status, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, 
					VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, 
					VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, 
					VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,VAR_REC_5, 
					Q_StreamId, Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, 
					ReferredTo, ReferredToName, ReferredBy, ReferredByName, CollectFlag, NULL 
					FROM pendingworklisttable a, queuedatatable b, ProcessInstanceTable c 
					WHERE a.ProcessInstanceId = v_CRLProcessInstanceId 
					AND a.workitemid = 1 
					AND a.ProcessInstanceId = c.ProcessInstanceId 
					AND a.ProcessInstanceId = b.ProcessInstanceId 
					AND a.WorkItemId = b.WorkItemId; 

				-- Can Use ROW_COUNT to find no. of affected rows and act accordingly..discuss
				DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM QueueDataTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM ProcessInstanceTable WHERE ProcessInstanceId =  v_CRLProcessInstanceId; 

				DELETE FROM WorkDoneTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
 
				DELETE FROM WorkListTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM WorkWithPSTable WHERE ProcessInstanceId =  v_CRLProcessInstanceId; 

				DELETE FROM WorkInProcessTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				INSERT INTO EXCEPTIONHISTORYTABLE 
					SELECT	ProcessDefId, ExcpSeqId, WorkitemId, Activityid, ActivityName, 
							ProcessInstanceId, UserId, UserName, ActionId, ActionDateTime, ExceptionId, 
							ExceptionName, FinalizationStatus, ExceptionComments 
					FROM	EXCEPTIONTABLE 
					WHERE	EXCEPTIONTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM EXCEPTIONTABLE WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				INSERT INTO TODOSTATUSHISTORYTABLE 
					SELECT ProcessDefId, ProcessInstanceId, ToDoValue 
					FROM TODOSTATUSTABLE 
					WHERE TODOSTATUSTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM TODOSTATUSTABLE	WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				INSERT INTO HISTORYROUTELOGTABLE 
					SELECT	LogId, ProcessDefId, ActivityId, ProcessInstanceId, 
							WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, 
							AssociatedFieldName, ActivityName, UserName 
					FROM CURRENTROUTELOGTABLE 
					WHERE CURRENTROUTELOGTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM CURRENTROUTELOGTABLE WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM WFESCALATIONTABLE WHERE ProcessInstanceId = v_CRLProcessInstanceId; 

				DELETE FROM WFESCINPROCESSTABLE	WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			END LOOP; 
		END LOOP; 
		CLOSE cursor1;
		RAISE NOTICE ''WFTransferData() - Execution Successful !!''; 
		RETURN 0;
	END; 
'
LANGUAGE 'plpgsql';