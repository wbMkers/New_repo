/*----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
26/10/2005		Harmeet Kaur		WFS_5_076 - SP Written
17/05/2013		Shweta Singhal		Process Variant Support Changes
8/01/2014       Anwar Ali Danish  Changes done for code optimization
------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE WFLockWorkItem (
	in_PIWIIds		 	NVARCHAR2,
	temp_in_lockedByName			NVARCHAR2,
	Status 				OUT		INT
)
AS
	v_status			INT;
	v_PIWIId			NVARCHAR2(80);
	v_processInstanceId		NVARCHAR2(64);
	v_workItemId			INT;
	v_len				INT;
	v_tempPIWIIds			NVARCHAR2(4000);
	v_index				INT;
	v_userId			INT;
	v_DBStatus			INT;
	v_rowCount			INT;	
	in_lockedByName			NVARCHAR2(510);
BEGIN	

	v_status := 0; -- 0 for success, 1 for error
	v_len := 0;
	v_tempPIWIIds := in_PIWIIds;
	v_DBStatus := -1;
	v_rowCount := -1;
	
	IF(temp_in_lockedByName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_in_lockedByName) into in_lockedByName FROM dual;
	END IF;

	BEGIN
		SELECT userIndex INTO v_userId FROM PDBUser WHERE UPPER(LTRIM(RTRIM(userName))) = UPPER(LTRIM(RTRIM(in_lockedByName)));
		v_rowcount := SQL%ROWCOUNT; 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowcount := 0; 
	END; 

	If(v_rowcount <= 0) THEN
	BEGIN
		Status := 1;
		RETURN;
	END;
	END IF;
	
	WHILE (LENGTH(RTRIM(LTRIM(v_tempPIWIIds))) > 0)	LOOP
	BEGIN
		v_len := INSTR(v_tempPIWIIds,'#');
		IF(v_len <= 0) THEN
		BEGIN
			v_PIWIId := v_tempPIWIIds;
			v_tempPIWIIds := '';
		END;
		ELSE
			v_PIWIId := SUBSTR(v_tempPIWIIds, 1, v_len-1);
		END IF;
		
		v_tempPIWIIds := SUBSTR(v_tempPIWIIds, v_len + 1, LENGTH(v_tempPIWIIds) - v_len);
		v_index := INSTR(v_PIWIId,',');
		v_processInstanceId := SUBSTR(v_PIWIId, 1, v_index-1);
		v_workItemId := SUBSTR(v_PIWIId, v_index + 1, LENGTH(v_PIWIId) - v_index);

		SAVEPOINT WorkList_To_WorkInProcess;
			/*Insert into WorkInProcessTable(
				ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, 
				ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, 
				ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
				CollectFlag, PriorityLevel, ValidTill, Q_StreamId, 
				Q_QueueId, Q_UserId, AssignedUser, FilterValue, 
				CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, 
				PreviousStage, LockedByName, LockStatus, LockedTime, 
				Queuename, Queuetype, NotifyStatus, Guid, ProcessVariantId
				) 
				Select 
				ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, 
				ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
				ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
				CollectFlag, PriorityLevel, ValidTill, Q_StreamId, 
				Q_QueueId, v_userId, AssignedUser, FilterValue, 
				CreatedDateTime, 2, Statename, ExpectedWorkitemDelay, 
				PreviousStage, in_lockedByName, 'Y', SYSDATE, 
				Queuename, Queuetype, NotifyStatus, null, ProcessVariantId
				From Worklisttable Where ProcessInstanceID = v_processInstanceId
				and WorkItemID = TO_NUMBER(v_workItemId);*//*Process Variant Support*/
				
				Update WFINSTRUMENTTABLE set Q_UserId = v_userId , WorkItemState = 2 , 
					LockedByName = in_lockedByName , LockStatus = 'Y' , LockedTime = SYSDATE ,
					Guid = null Where ProcessInstanceID = v_processInstanceId
					and WorkItemID = TO_NUMBER(v_workItemId) and LockStatus = 'N' and 
					RoutingStatus = 'N';		
			
				v_rowcount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
				 
			IF( v_DBStatus <> 0 OR v_rowcount <= 0 ) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT WorkList_To_WorkInProcess;
				Status := 1;
				RETURN;
			END;
			END IF;

			/*DELETE FROM WorkListTable WHERE ProcessInstanceID = v_processInstanceId 
				and WorkItemID = TO_NUMBER(v_workItemId);
				
				v_rowcount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
				 
			IF( v_DBStatus <> 0 OR v_rowcount <= 0 ) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT WorkList_To_WorkInProcess;
				Status := 1;
				RETURN;
			END;
			END IF;*/
		COMMIT;
	END;	
	END LOOP;
	
	Status := v_status;
	RETURN;
END;
