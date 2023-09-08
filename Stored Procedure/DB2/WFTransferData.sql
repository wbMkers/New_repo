/*-----------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 7.0
	Module				: Transaction Server
	File Name			: WFTransferData.sql
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 14/06/2006
	Description			: Script to move data to history tables for workitems
						- Reached exit workstep
						- Aborted
						- Discarded
-------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
08/02/2008		Ashish Mangla	Bugzilla Bug 3326 (ProcessInstanceState for Discarded Workitems was going as that of completed)

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE WFTransferData ()
LANGUAGE SQL
BEGIN
	DECLARE v_CRLLogId              INTEGER; 
	DECLARE v_CRLProcessInstanceId  VARGRAPHIC(64); 
	DECLARE v_valcur                INTEGER; 
	DECLARE v_retval                INTEGER; 
	DECLARE existsFlag              INTEGER; 
	DECLARE v_QueryStr              VARGRAPHIC(2000); 
	DECLARE v_DBStatus              INTEGER; 
	DECLARE v_status                INTEGER; 
	DECLARE SQLCODE			INTEGER;
 	DECLARE v_Cursor_str		VARCHAR(4000);
	DECLARE v_Cur_stmt		STATEMENT;
	DECLARE v_Var_Cursor		CURSOR FOR v_Cur_stmt;

	set v_Cursor_str = 'SELECT LogId, ProcessInstanceId FROM CURRENTROUTELOGTABLE WHERE ActionId IN (3, 5, 20) AND LogId > '
			|| CHAR(v_CRLLogId) || ' ORDER BY LogId FETCH FIRST 100 ROWS ONLY';

	PREPARE v_Cur_stmt FROM v_Cursor_str;
	OPEN v_Var_Cursor;
	

	WHILE (1=1) Do
	BEGIN 
		set v_Cursor_str = 'SELECT LogId, ProcessInstanceId FROM CURRENTROUTELOGTABLE WHERE ActionId IN (3, 5, 20) AND LogId > '
				|| CHAR(v_CRLLogId) || ' ORDER BY LogId FETCH FIRST 100 ROWS ONLY';

		PREPARE v_Cur_stmt FROM v_Cursor_str;
		OPEN v_Var_Cursor;

		set v_DBStatus = SQLCODE;

		WHILE(v_status <> 0) DO
			SAVEPOINT TranWorkItem On ROLLBACK Retain Cursors; 

			FETCH v_Var_Cursor into v_CRLLogId, v_CRLProcessInstanceId;

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
				ReferredTo, ReferredToName, ReferredBy, ReferredByName, CollectFlag, cast(NULL as timestamp)
				FROM pendingworklisttable a, queuedatatable b, ProcessInstanceTable c 
				WHERE a.ProcessInstanceId = v_CRLProcessInstanceId 
				AND a.workitemid = 1 
				AND a.ProcessInstanceId = c.ProcessInstanceId 
				AND a.ProcessInstanceId = b.ProcessInstanceId 
				AND a.WorkItemId = b.WorkItemId ; 
			set v_DBStatus = SQLCODE; 

			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 

			
			------------------------------------------------------------------------------------------
			DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 

			DELETE FROM QueueDataTable WHERE ProcessInstanceId = v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM ProcessInstanceTable WHERE ProcessInstanceId =  v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM WorkDoneTable WHERE ProcessInstanceId = v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM WorkListTable WHERE ProcessInstanceId = v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM WorkWithPSTable WHERE ProcessInstanceId =  v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM WorkInProcessTable WHERE ProcessInstanceId = v_CRLProcessInstanceId ; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			------------------------------------------------------------------------------------------



			------------------------------------------------------------------------------------------
			INSERT INTO EXCEPTIONHISTORYTABLE 
				SELECT ProcessDefId, ExcpSeqId, WorkitemId, Activityid, ActivityName, 
					ProcessInstanceId, UserId, UserName, ActionId, ActionDateTime, ExceptionId, 
					ExceptionName, FinalizationStatus, ExceptionComments 
				FROM EXCEPTIONTABLE 
				WHERE EXCEPTIONTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			
			DELETE FROM EXCEPTIONTABLE 
				WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 

			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			------------------------------------------------------------------------------------------

			
			------------------------------------------------------------------------------------------
			INSERT INTO TODOSTATUSHISTORYTABLE 
				SELECT ProcessDefId, ProcessInstanceId, ToDoValue 
					FROM TODOSTATUSTABLE 
					WHERE TODOSTATUSTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 

			DELETE FROM TODOSTATUSTABLE 
				WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			------------------------------------------------------------------------------------------


			------------------------------------------------------------------------------------------
			INSERT INTO HISTORYROUTELOGTABLE 
				SELECT LogId, ProcessDefId, ActivityId, ProcessInstanceId, 
					WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, 
					AssociatedFieldName, ActivityName, UserName 
				FROM CURRENTROUTELOGTABLE 
				WHERE CURRENTROUTELOGTABLE.ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM CURRENTROUTELOGTABLE 
			WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			------------------------------------------------------------------------------------------


			------------------------------------------------------------------------------------------
			DELETE FROM WFESCALATIONTABLE 
			WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			DELETE FROM WFESCINPROCESSTABLE 
			WHERE ProcessInstanceId = v_CRLProcessInstanceId; 
			set v_DBStatus = SQLCODE; 
			IF v_DBStatus <> 0 THEN 
				ROLLBACK TO SAVEPOINT TranWorkItem; 
				INSERT INTO FailureLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
				GOTO ProcessNext; 
			END IF; 
			------------------------------------------------------------------------------------------


			INSERT INTO SuccessLogTable Values(v_CRLLogId, char(v_CRLProcessInstanceId)); 
			COMMIT ; 
ProcessNext:
			IF v_DBStatus <> 0 THEN 
				CLOSE v_Var_Cursor; 		
				RETURN; 
			END IF; 
		END WHILE; 
		CLOSE v_Var_Cursor; 
	END; 
	END WHILE; 
END