/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: OmniFlow 10.x
	Module						: Transaction Server
	File Name					: WFCheckExpiry.sql (ORACLE)
	Description					: Stored procedure to check candidates for expiry
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 03/02/2016 Kahkeshan		Bug 58902 - Database got hang in case of expiry of referred workitems .
 04/02/2016 Kahkeshan		Bug 58903 - Lock Status of workitems locked by Ps being set to “N” without Q_USerId updation .
 22/09/2017	Kahkeshan		Bug 72039 - Changes for Postgres - Bug 69254 - Some fields of WFInstrumentTable not getting cleared after processed by  Expiry utility .
 27/04/2018	Ashutosh Pandey	Bug 77141  - Architecture change in expiry utility
 29/01/2020	Ravi Ranjan Kumar	Bug 90317 - Revoke functionality not working on task.
 08/04/2020	Shahzad Malik		Bug 91513 - Optimization in mailing utility.
 25/04/2020	Ravi Ranjan Kumar	Bug 92037 - WI showing in Referredto state even after the WI is expired and moved to next activity
____________________________________________________________________________________________________*/
create or replace
function WFCHECKEXPIRY
(
    v_HistoryNew VARCHAR,
    v_CSName VARCHAR,
	v_BatchCount INTEGER


) returns refcursor
AS $$
declare
    v_ProcessInstanceId VARCHAR(63);
    v_WorkitemId INTEGER;
    v_ProcessDefId INTEGER;
    v_ActivityId INTEGER;
    v_ActivityName VARCHAR(30);
    v_Q_QueueId INTEGER;
    v_ParentWorkItemId INTEGER;
    v_InsertCount INTEGER;
    v_DeleteCount INTEGER;
    v_SelectCount INTEGER;
    v_UpdateCount INTEGER;
    v_AssignmentType VARCHAR(4);
    v_ParentIdStr VARCHAR(100);
    v_ParentId INTEGER;
    v_Pos1 INTEGER;
    v_DivertedUserIndex INTEGER;
	v_DivertedProcessDefId INTEGER;
	v_DivertedActivityId INTEGER;
	v_TaskId INTEGER;
	v_SubTaskId INTEGER;
    v_DivertedUserName VARCHAR(63);
	v_assocField VARCHAR(200);
	v_AssignedTo VARCHAR(63);
    v_AssignedUserIndex INTEGER;
    v_AssignedUserName VARCHAR(63);
    v_AssignBackToDivertedUser VARCHAR(4);
    v_MyQueue VARCHAR(100);
    --TYPE EXPIRY_CURSOR IS REF CURSOR;
    v_Cursor refcursor;
    v_InnerCursor refcursor;
    v_Count INTEGER;
    v_TotalDuration INTEGER;
    v_TotalCount INTEGER;
    v_RollBackCount INTEGER;
    v_MainCode INTEGER;
    v_ResultCount INTEGER;
    csSessionId INTEGER;
	 v_ResCount  INT;
    v_CSSessionId INT;
	out_cursor	REFCURSOR;
	v_LoopCount INT;
	v_CurrentLoopCount INT;
	v_LocalBatchCount INT;
	v_ReferredByName VARCHAR(63);
BEGIN
    v_MainCode := 0;
    v_ResultCount := 0;
    csSessionId := 0;
	v_LocalBatchCount := v_BatchCount;
    IF v_CSName IS NOT NULL THEN
	BEGIN
            SELECT SessionID INTO csSessionId FROM PSRegisterationTable WHERE Type = 'C' AND PSName = v_CSName;
	END;
    END IF;

	IF(v_LocalBatchCount < 50 OR v_LocalBatchCount > 100) THEN
		v_LocalBatchCount := 100;
	END IF;

	v_LoopCount := ceiling(v_LocalBatchCount/10);

    --Going to Expire Non-Referred Workitems present in WorkListTable whose ValidTill is reached.
	v_CurrentLoopCount := 0;
        v_Count := 0;
        OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, date_part('day',CURRENT_TIMESTAMP - EntryDateTime) FROM WFInstrumentTable where RoutingStatus = 'N' AND LockStatus = 'N' AND AssignmentType != 'E' AND ValidTill < CURRENT_TIMESTAMP  LIMIT 5 FOR UPDATE;
        LOOP
			FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_TotalDuration;
			EXIT WHEN NOT FOUND;
            v_Count := 1;
            v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
			Update WFinstrumentTable set RoutingStatus = 'Y',LockStatus = 'N',WorkItemState = 6 ,Statename = 'COMPLETED' , Q_Userid = 0,Q_DivertedByUserId = 0,AssignmentType ='X',Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,ValidTill = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL where ProcessInstanceID = v_ProcessInstanceId AND WorkItemID = v_WorkitemId;
            GET DIAGNOSTICS v_InsertCount := ROW_COUNT;
			 
            v_MainCode:=WFGenerateLog(28, Cast(NULL as Integer), v_ProcessDefId, v_ActivityId, v_Q_QueueId, Cast(NULL as varchar), v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, Cast(NULL as varchar), v_WorkitemId, 0, 0, NULL , 0 ,0 ,0 , NULL,TO_CHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH12:MM:SS') );
			raise notice ' v_MainCode 1 %', v_MainCode;
            IF(v_MainCode <> 0) THEN
                  CONTINUE;
            END IF;
                v_ResultCount := v_ResultCount + 1;
			--EXIT WHEN v_LocalBatchCount = v_ResultCount;
        END LOOP;
        CLOSE v_Cursor;
        --EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;
		--v_CurrentLoopCount := v_CurrentLoopCount + 1;
	

    --Going to expire Hold WorkItems present in PendingWorkListTable whose ValidTill is reached.
	IF(5 <> v_ResultCount) THEN
	BEGIN
    v_Count := 0;
        OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, date_part('day',CURRENT_TIMESTAMP - EntryDateTime) FROM WFInstrumentTable WHERE WorkItemState = 3 AND AssignmentType = 'H' AND ValidTill < CURRENT_TIMESTAMP AND RoutingStatus = 'R' LIMIT 5 FOR UPDATE;
        LOOP
            FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_TotalDuration;
            EXIT WHEN NOT FOUND;
            v_Count := 1;
            v_TotalCount := v_TotalCount + 1;
            v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
				
				Update WFInstrumentTable set RoutingStatus = 'Y' , LockStatus = 'N' ,AssignmentType =  'X', WorkItemState = 6 , Statename = 'COMPLETED', Q_Userid = 0,Q_DivertedByUserId = 0 ,Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,ValidTill = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL
				where  ProcessInstanceID = v_ProcessInstanceId AND WorkItemID = v_WorkitemId;
				
 				v_MainCode:=WFGenerateLog(28, Cast(NULL as Integer), v_ProcessDefId, v_ActivityId, v_Q_QueueId, NULL, v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, NULL, v_WorkitemId, 0, 0, NULL, 0 ,0 ,0 , NULL,TO_CHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH12:MM:SS') );
				raise notice ' v_MainCode 2 %' ,v_MainCode;
                IF(v_MainCode <> 0) THEN
                    CONTINUE;
                END IF;
                v_ResultCount := v_ResultCount + 1;
			--EXIT WHEN v_LocalBatchCount = v_ResultCount;
            END LOOP;
        CLOSE v_Cursor;
        --EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;
		--v_CurrentLoopCount := v_CurrentLoopCount + 1;
	END;
	END IF;

    --Going to Expire Referred records present in WorkListTable whose ValidTill is reached.
    IF(5 <> v_ResultCount) THEN
	BEGIN
    v_CurrentLoopCount := 0;
  
        v_Count := 0;
        OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, ParentWorkItemId, date_part('day',CURRENT_TIMESTAMP - EntryDateTime) FROM WFInstrumentTable WHERE RoutingStatus = 'N' and LockStatus = 'N' AND AssignmentType = 'E' AND ValidTill < CURRENT_TIMESTAMP LIMIT 5 FOR UPDATE;
         <<NEXTRECORD2>>
		LOOP
			FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_ParentWorkItemId, v_TotalDuration;

            EXIT WHEN NOT FOUND;
            v_Count := 1;
            v_TotalCount := v_TotalCount + 1;
            v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
            v_ParentIdStr := ''; 
            DELETE FROM WFInstrumentTable where ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_WorkitemId;
            WHILE(1 = 1) LOOP
                SELECT ParentWorkItemId, AssignmentType,ReferredByName INTO v_ParentId, v_AssignmentType ,v_ReferredByName FROM WFInstrumentTable WHERE RoutingStatus = 'R' AND ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_ParentWorkItemId;
                GET DIAGNOSTICS    v_SelectCount := ROW_COUNT;
                IF v_SelectCount <= 0 THEN
                     CONTINUE NEXTRECORD2;
                END IF;
                IF v_AssignmentType IS NOT NULL THEN
                    v_AssignmentType := LTRIM(RTRIM(v_AssignmentType));
                END IF;
				IF v_ReferredByName IS NOT NULL AND LENGTH(v_ReferredByName)>0 THEN
				BEGIN
					DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_ParentWorkItemId;
					v_ParentWorkItemId := v_ParentId;
				END;
                ELSIF v_AssignmentType IS NULL OR v_AssignmentType <> 'E' THEN
				BEGIN
					Update WFinstrumentTable set RoutingStatus = 'Y', ValidTill=null,LockStatus = 'N', WorkItemState = 6, Statename =  'COMPLETED' , AssignmentType = 'X', Q_Userid = 0,Q_DivertedByUserId = 0,Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL ,Referredto=null,Referredtoname=null  WHERE ProcessInstanceID = v_ProcessInstanceId AND WorkItemID = v_ParentWorkItemId;
				END;
                END IF;
				 
                v_MainCode:=WFGenerateLog(28, Cast(NULL as Integer), v_ProcessDefId, v_ActivityId, v_Q_QueueId, NULL, v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, Cast(NULL as VARCHAR), v_WorkitemId, 0, 0, NULL, 0 ,0 ,0 , NULL,TO_CHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH12:MM:SS') );
                IF(v_MainCode <> 0) THEN
                     CONTINUE NEXTRECORD2;
                END IF;
                EXIT;
            END LOOP;
            v_ResultCount := v_ResultCount + 1;
			--EXIT WHEN v_LocalBatchCount = v_ResultCount;
        END LOOP;
        CLOSE v_Cursor;
        --EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;

	END;
	END IF;

    --Going to Delete entries from QueueUserTble in case Temporary User Assignment Period is reached.
	BEGIN
        DELETE FROM QueueUserTable WHERE AssignedTillDateTime < CURRENT_TIMESTAMP;
	END;

    --Going to Delete entries from UserDiversionTable in case Diversion Period is reached and also Assign back the workitems from AssignedUser to the original DivertedUser if CurrentWorkItemFlag(i.e. Assign Back Current Workitem Flag) in UserDiversionTable is 'Y' for that Diversion.
	BEGIN
        OPEN v_Cursor FOR SELECT DivertedUserIndex, DivertedUserName, AssignedUserIndex, AssignedUserName, CurrentWorkItemsFlag, ProcessDefId, ActivityId FROM UserDiversionTable WHERE ToDate < CURRENT_TIMESTAMP;
        <<NEXTRECORD3>>
		LOOP
            FETCH v_Cursor INTO v_DivertedUserIndex, v_DivertedUserName, v_AssignedUserIndex, v_AssignedUserName, v_AssignBackToDivertedUser, v_DivertedProcessDefId, v_DivertedActivityId;

            EXIT WHEN NOT FOUND;
                v_SelectCount := 0;
                IF v_AssignBackToDivertedUser = 'Y' THEN
					IF (v_DivertedProcessDefId >0 AND v_DivertedActivityId > 0) THEN
                    OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId AND ActivityId = v_DivertedActivityId;
					ELSIF (v_DivertedProcessDefId >0) THEN
					OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId;
					ELSE
					OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex;
					END IF;
                    LOOP
                        FETCH v_InnerCursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId;
                        EXIT WHEN NOT FOUND;
                        v_SelectCount := v_SelectCount + 1;
                        v_MainCode:=WFGenerateLog(123,  Cast(NULL as Integer), v_ProcessDefId, v_ActivityId, v_Q_QueueId, v_AssignedUserName, v_ActivityName, 0, v_ProcessInstanceId, v_DivertedUserIndex, v_DivertedUserName, v_WorkitemId, 0, 0, NULL , 0 ,0 ,0 , NULL,NULL);
						IF(v_MainCode <> 0) THEN
                            CLOSE v_InnerCursor; 
                            CONTINUE NEXTRECORD3;
                        END IF;
						v_MyQueue := v_DivertedUserName || '''s MyQueue';
                        UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N' AND ProcessInstanceID = v_ProcessInstanceId AND WorkitemId = v_WorkitemId;
                        
                    END LOOP;
                    CLOSE v_InnerCursor;
                   /* IF(v_SelectCount > 0) THEN
                        v_MyQueue := v_DivertedUserName || '''s MyQueue';
                        UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N';
                    GET DIAGNOSTICS    v_UpdateCount := ROW_COUNT;
                        IF(v_SelectCount <> v_UpdateCount) THEN
                            CONTINUE NEXTRECORD3;
                        END IF;
                    END IF;*/
                END IF;
				
				
				
				--added by Nikhil for task
				
				
				IF v_AssignBackToDivertedUser = 'Y' THEN
					IF (v_DivertedProcessDefId >0 AND v_DivertedActivityId > 0) THEN
                    OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N'  AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId AND ActivityId = v_DivertedActivityId;
					ELSIF (v_DivertedProcessDefId >0) THEN
					OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N'  AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId;
					ELSE
					OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N'  AND Q_DivertedByUserId = v_DivertedUserIndex;
					END IF;
                    LOOP
                        FETCH v_InnerCursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_AssignedTo, v_SubTaskId, v_TaskId;
                        EXIT WHEN NOT FOUND;
                        v_assocField := v_AssignedTo ||','||v_DivertedUserName;
                        v_MainCode:=WFGenerateLog(715,  Cast(NULL as Integer), v_ProcessDefId, v_ActivityId, v_Q_QueueId, v_AssignedUserName, v_ActivityName, 0, v_ProcessInstanceId, v_DivertedUserIndex, v_assocField, v_WorkitemId, 0, 0, NULL , 0 ,v_TaskId ,v_SubTaskId , NULL,NULL);
						IF(v_MainCode <> 0) THEN
                            CLOSE v_InnerCursor; 
                            CONTINUE NEXTRECORD3;
                        END IF;
						
						UPDATE WFTaskStatusTable SET AssignedTo = v_DivertedUserName, Q_DivertedByUserId = 0 WHERE Q_DivertedByUserId = v_DivertedUserIndex AND LockStatus = 'N' AND ProcessInstanceID =v_ProcessInstanceId AND WorkItemId = v_WorkitemId;
                        
                    END LOOP;
                    CLOSE v_InnerCursor;
                   /* IF(v_SelectCount > 0) THEN
                        v_MyQueue := v_DivertedUserName || '''s MyQueue';
                        UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N';
                    GET DIAGNOSTICS    v_UpdateCount := ROW_COUNT;
                        IF(v_SelectCount <> v_UpdateCount) THEN
                            CONTINUE NEXTRECORD3;
                        END IF;
                    END IF;*/
                END IF;
				
				
				
                DELETE FROM UserDiversionTable WHERE DivertedUserIndex = v_DivertedUserIndex;
                GET DIAGNOSTICS v_DeleteCount := ROW_COUNT;
                IF v_DeleteCount <= 0 THEN
                    CONTINUE NEXTRECORD3;
                END IF;
                IF(v_HistoryNew = 'N') THEN
                    v_MainCode:=WFGenerateLog(54,  Cast(NULL as Integer), 0, 0, 0, 'SYSTEM',  Cast(NULL as VARCHAR), 0, Cast(NULL as VARCHAR), v_DivertedUserIndex, v_DivertedUserName, 0, 0, 0, NULL , 0, 0 , 0 , NULL,NULL);
                    IF(v_MainCode <> 0) THEN
                        CONTINUE NEXTRECORD3;
                    END IF;
                END IF;
                IF(v_HistoryNew = 'Y') THEN
                    INSERT INTO WFAdminLogTable (ActionId, ActionDateTime, ProcessDefId, QueueId , QueueName, FieldId1, FieldName1, FieldId2, FieldName2, Property, UserId, UserName, OldValue, NewValue, WEFDate, ValidTillDate) VALUES (54, CURRENT_TIMESTAMP, 0, 0, NULL, v_DivertedUserIndex, v_DivertedUserName, 0, NULL, NULL, 0, 'SYSTEM', NULL, NULL, NULL, NULL);
                    GET DIAGNOSTICS v_InsertCount := ROW_COUNT;
                    IF(v_InsertCount <= 0) THEN
                        CONTINUE NEXTRECORD3;
                    END IF;
                END IF;
            END LOOP;
        CLOSE v_Cursor;
	END;
    v_ResCount := v_ResultCount;
    v_CSSessionId := csSessionId;
	Open out_cursor for Select v_ResCount,v_CSSessionId;
	return out_cursor;
END;

$$ LANGUAGE PLPGSQL;

