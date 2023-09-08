/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: OmniFlow 10.x
	Module						: Transaction Server
	File Name					: WFCheckExpiry.sql (ORACLE)
	Author						: Kahkeshan	
	Date written (DD/MM/YYYY)	: 
	Description					: Stored procedure to check candidates for expiry
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 03/02/2016 Kahkeshan		Bug 58902 - Database got hang in case of expiry of referred workitems .
 04/02/2016 Kahkeshan		Bug 58903 - Lock Status of workitems locked by Ps being set to “N” without Q_USerId updation .
 17/06/2016	Kahkeshan		Bug 62323 - History to be made on target cabinet for CTS Archive
 17/05/2017	Kahkeshan		Bug 69254 - Some fields of WFInstrumentTable not getting cleared after processed by  Expiry utility .
 30/03/2018	Ashutosh Pandey	Bug 75232 - Remove the db console messages from all procedures
 16/04/2018	Jyoti Gupta		Bug 74348 - Support for fetching history after the data has been migrated from WFHistoryRouteLogTable to a backup table
 27/04/2018	Ashutosh Pandey	Bug 77141  - Architecture change in expiry utility
 04/04/2019	Ashutosh Pandey Bug 83959 - Expiry utility is getting hang in expiring referred WI
 08/04/2020	Shahzad Malik	Bug 91513 - Optimization in mailing utility.
 25/04/2020	Ravi Ranjan Kumar	Bug 92037 - WI showing in Referredto state even after the WI is expired and moved to next activity
____________________________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE WFCHECKEXPIRY
(
  v_HistoryNew NVARCHAR2,
  v_CSName NVARCHAR2,
  v_BatchCount INT,
  v_ResCount OUT INT,
  v_CSSessionId OUT INT,
  v_tarHisLog				NVARCHAR2,
  v_targetCabinet			VARCHAR2,
  v_isReport				VARCHAR2
)
AS
  v_ProcessInstanceId NVARCHAR2(63);
  v_WorkitemId INTEGER;
  v_ProcessDefId INTEGER;
  v_ActivityId INTEGER;
  v_ActivityName NVARCHAR2(30);
  v_Q_QueueId INTEGER;
  v_ParentWorkItemId INTEGER;
  v_InsertCount INTEGER;
  v_DeleteCount INTEGER;
  v_SelectCount INTEGER;
  v_UpdateCount INTEGER;
  v_AssignmentType NVARCHAR2(4);
  v_ParentIdStr NVARCHAR2(100);
  v_ParentId INTEGER;
  v_Pos1 INTEGER;
  v_DivertedUserIndex INTEGER;
  v_DivertedUserName NVARCHAR2(63);
  v_AssignedUserIndex INTEGER;
  v_AssignedUserName NVARCHAR2(63);
  v_assocField NVARCHAR2(200);
  v_AssignedTo NVARCHAR2(63);
  v_AssignBackToDivertedUser NVARCHAR2(4);
  v_DivertedProcessDefId INTEGER;
  v_DivertedActivityId INTEGER;
  v_TaskId INTEGER;
  v_SubTaskId INTEGER;
  v_MyQueue NVARCHAR2(100);
  TYPE EXPIRY_CURSOR IS REF CURSOR;
  v_Cursor EXPIRY_CURSOR;
  v_InnerCursor EXPIRY_CURSOR;
  v_Count INTEGER;
  v_TotalDuration NUMBER;
  v_TotalCount INTEGER;
  v_RollBackCount INTEGER;
  v_MainCode INTEGER;
  v_ResultCount INTEGER;
  csSessionId INTEGER;
  v_genLog  INTEGER;
  v_LoopCount INT;
  v_CurrentLoopCount INT;
  v_LocalBatchCount INT;
  v_ReferredByName NVARCHAR2(63);
  v_quoteChar CHAR(1);
  v_insertTarStr NVARCHAR2(100);
  v_CurrDate 			DATE;
BEGIN
  v_MainCode := 0;
  v_ResultCount := 0;
  csSessionId := 0;
  v_genLog := 0;
  v_LocalBatchCount := v_BatchCount;
  v_quoteChar := CHR(39);

  IF(v_CSName IS NOT NULL) THEN
  BEGIN
    BEGIN
      SELECT SessionID INTO csSessionId FROM PSRegisterationTable WHERE Type = 'C' AND PSName = v_CSName;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        csSessionId := 0;
    END;
  END;
  END IF;
  v_insertTarStr := '';
  
  BEGIN
		IF(v_tarHisLog = 'Y' AND v_targetCabinet IS NOT NULL )THEN
			--v_insertTarStr := ' '' ' || v_targetCabinet || '.' || ' '' ';
			v_insertTarStr :=  TRIM(v_targetCabinet)  ;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN  
		v_insertTarStr := '';
	END;

  IF(v_LocalBatchCount < 50 OR v_LocalBatchCount > 100) THEN
    v_LocalBatchCount := 100;
  END IF;

  v_LoopCount := CEIL(v_LocalBatchCount/10);

  --Going to Expire Non-Referred Workitems present in WorkListTable whose ValidTill is reached.
  v_CurrentLoopCount := 0;
  
    v_Count := 0;
    OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, (SYSDATE - EntryDateTime) FROM WFInstrumentTable where RoutingStatus = 'N' AND LockStatus = 'N' AND AssignmentType != 'E' AND ValidTill < sysDate AND ROWNUM <= 5 FOR UPDATE;
    LOOP
    BEGIN
    <<NEXTRECORD>>
      FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_TotalDuration;
      EXIT WHEN v_Cursor%NOTFOUND;
      v_Count := 1;
      v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
	  v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
      SAVEPOINT TRANS;
        BEGIN
        Update WFInstrumentTable set AssignmentType = N'X',WorkItemState = 6,RoutingStatus = N'Y',ValidTill=null,Statename = N'COMPLETED', Q_DivertedByUserId = 0,Q_StreamId = 0 ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,LockedByName=NULL, Q_Userid = 0, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL WHERE ProcessInstanceID = v_ProcessInstanceId and WorkItemID = v_WorkitemId;

        EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                              BEGIN

                              v_InsertCount:=0;
                              END;
        END;
        IF v_InsertCount = 0 THEN
        BEGIN
          ROLLBACK TO SAVEPOINT TRANS;
          GOTO NEXTRECORD;
        END;
        END IF;

        IF v_genLog = 0 THEN
        BEGIN
		v_CurrDate := SYSDATE;
          WFGenerateLog(28, NULL, v_ProcessDefId, v_ActivityId, v_Q_QueueId, NULL, v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, NULL, v_WorkitemId, 0, 0,  v_MainCode,v_isReport ,0 ,0 ,0 , NULL,NULL,v_CurrDate,v_tarHisLog,v_insertTarStr);
		END;
		END IF;

                    IF(v_MainCode <> 0) THEN
                    BEGIN
                         ROLLBACK TO SAVEPOINT TRANS;
                         GOTO NEXTRECORD;
                    END;
                    END IF;
                    v_ResultCount := v_ResultCount + 1;
					--EXIT WHEN v_LocalBatchCount = v_ResultCount;
      END;
      END LOOP;
		  COMMIT;
          CLOSE v_Cursor;
          --EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;
		  v_CurrentLoopCount := v_CurrentLoopCount + 1;
     

	IF(v_ResultCount = 5) THEN
		GOTO ALWAYSPROCESS;
	END IF;

     --Going to expire Hold WorkItems present in PendingWorkListTable whose ValidTill is reached.
     v_CurrentLoopCount := 0;
	
          v_Count := 0;
          OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, (SYSDATE - EntryDateTime) FROM WFInstrumentTable WHERE WorkItemState = 3 AND AssignmentType = 'H' AND ValidTill < sysDate AND ROWNUM <= 5 AND RoutingStatus = 'R' FOR UPDATE;
          LOOP
          BEGIN
          <<NEXTRECORD1>>
               FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_TotalDuration;
               EXIT WHEN v_Cursor%NOTFOUND;
               v_Count := 1;
               v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
			   v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
               SAVEPOINT TRANS;
               BEGIN

                    Update WFInstrumentTable Set AssignmentType = N'X',ValidTill=null,WorkItemState = 6 ,Statename =  N'COMPLETED', Q_DivertedByUserId = 0,RoutingStatus = 'Y' ,LockStatus = 'N',Q_StreamId = 0 ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,LockedByName=NULL, Q_Userid = 0, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL where  ProcessInstanceID = v_ProcessInstanceId and WorkItemID = v_WorkitemId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                              BEGIN

                              v_InsertCount:=0;
                              END;
                      END;
                    IF (v_InsertCount = 0) THEN
                    BEGIN
                         ROLLBACK TO SAVEPOINT TRANS;
                         GOTO NEXTRECORD1;
                    END;
                    END IF;
                         IF v_genLog = 0 THEN
                         BEGIN
						 v_CurrDate := SYSDATE;
                              WFGenerateLog(28, NULL, v_ProcessDefId, v_ActivityId, v_Q_QueueId, NULL, v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, NULL, v_WorkitemId, 0, 0, v_MainCode,v_isReport ,0 ,0 ,0 ,NULL,NULL,v_CurrDate,v_tarHisLog,v_insertTarStr);
                     END;
          END IF;


                    IF(v_MainCode <> 0) THEN
                    BEGIN
                         ROLLBACK TO SAVEPOINT TRANS;
                         GOTO NEXTRECORD1;
                    END;
                    END IF;
                    v_ResultCount := v_ResultCount + 1;
              -- EXIT WHEN v_LocalBatchCount = v_ResultCount;
          END;
          END LOOP;
		  COMMIT;
          CLOSE v_Cursor;
         -- EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;
		  v_CurrentLoopCount := v_CurrentLoopCount + 1;
 

	IF(v_ResultCount = 5) THEN
		GOTO ALWAYSPROCESS;
	END IF;

     --Going to Expire Referred records present in WorkListTable whose ValidTill is reached.
     v_CurrentLoopCount := 0;
	
          v_Count := 0;
          OPEN v_Cursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, ParentWorkItemId, (SYSDATE - EntryDateTime) FROM WFInstrumentTable WHERE RoutingStatus = 'N' and LockStatus = 'N' AND AssignmentType = 'E' AND ValidTill < sysDate AND ROWNUM <= 5 FOR UPDATE;
          LOOP
          BEGIN
          <<NEXTRECORD2>>
               FETCH v_Cursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId, v_ParentWorkItemId, v_TotalDuration;
               EXIT WHEN v_Cursor%NOTFOUND;
               v_Count := 1;
               v_TotalDuration := v_TotalDuration * 24 * 60 * 60;
			   v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
               SAVEPOINT TRANS;
                    v_ParentIdStr := '';
          Delete from WFInstrumentTable where ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_WorkitemId And RoutingStatus = 'N' and LockStatus = 'N';
                    WHILE(1 = 1) LOOP
                    BEGIN
                         BEGIN
                              SELECT ParentWorkItemId, AssignmentType, ReferredByName INTO v_ParentId, v_AssignmentType, v_ReferredByName FROM WFInstrumentTable WHERE RoutingStatus = 'R' AND ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_ParentWorkItemId;
                              v_SelectCount := SQL%ROWCOUNT;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                        v_SelectCount := 0;
                         END;
                         IF v_SelectCount <= 0 THEN
                         BEGIN
                              ROLLBACK TO SAVEPOINT TRANS;
                              GOTO NEXTRECORD2;
                         END;
                         END IF;
                         IF v_AssignmentType IS NOT NULL THEN
                              v_AssignmentType := LTRIM(RTRIM(v_AssignmentType));
                         END IF;
                         IF (v_ReferredByName IS NOT NULL AND LENGTH(v_ReferredByName) > 0) THEN
                         BEGIN
                            DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkItemId = v_ParentWorkItemId;
                            v_ParentWorkItemId := v_ParentId;
                         END;
                         ELSIF v_AssignmentType IS NULL OR v_AssignmentType <> 'E' THEN
                         BEGIN

                             Update WFInstrumentTable set WorkItemState  = 6,ValidTill=null,RoutingStatus = N'Y',LockStatus = 'N',
            LockedByname = null, lockedtime = null, Statename = N'COMPLETED', Q_Userid = 0, Q_StreamId = 0,Q_QueueId = 0,QueueName = NULL,QueueType = NULL,Q_DivertedByUserId = 0,AssignmentType=N'X', LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL ,Referredto=null,Referredtoname=null where
            ProcessInstanceID = v_ProcessInstanceId and WorkItemID = v_ParentWorkItemId;

                         IF v_genLog = 0 THEN
                                   BEGIN
								   v_CurrDate := SYSDATE;
                              WFGenerateLog(28, NULL, v_ProcessDefId, v_ActivityId, v_Q_QueueId, NULL, v_ActivityName, v_TotalDuration, v_ProcessInstanceId, 0, NULL, v_WorkitemId, 0, 0, v_MainCode,v_isReport , 0,0,0,NULL,NULL,v_CurrDate,v_tarHisLog,v_insertTarStr);
                              END;
            end if;
                              IF(v_MainCode <> 0) THEN
                              BEGIN
                                   ROLLBACK TO SAVEPOINT TRANS;
                                   GOTO NEXTRECORD2;
                              END;
                              END IF;
                              EXIT;
                         END;
                         END IF;
                    END;
                    END LOOP;
                    v_ResultCount := v_ResultCount + 1;
               --EXIT WHEN v_LocalBatchCount = v_ResultCount;
          END;
          END LOOP;
		  COMMIT;
          CLOSE v_Cursor;
          --EXIT WHEN v_Count = 0 OR v_LocalBatchCount = v_ResultCount;
		  --v_CurrentLoopCount := v_CurrentLoopCount + 1;
  

	 <<ALWAYSPROCESS>>
     --Going to Delete entries from QueueUserTble in case Temporary User Assignment Period is reached.
     BEGIN
          DELETE FROM QueueUserTable WHERE AssignedTillDateTime < sysDate;
     END;

     --Going to Delete entries from UserDiversionTable in case Diversion Period is reached and also Assign back the workitems from AssignedUser to the original DivertedUser if CurrentWorkItemFlag(i.e. Assign Back Current Workitem Flag) in UserDiversionTable is 'Y' for that Diversion.
     BEGIN
          OPEN v_Cursor FOR SELECT DivertedUserIndex, DivertedUserName, AssignedUserIndex, AssignedUserName, CurrentWorkItemsFlag, ProcessDefId, ActivityId FROM UserDiversionTable WHERE ToDate < sysDate;
          LOOP
          BEGIN
          <<NEXTRECORD3>>
               FETCH v_Cursor INTO v_DivertedUserIndex, v_DivertedUserName, v_AssignedUserIndex, v_AssignedUserName, v_AssignBackToDivertedUser, v_DivertedProcessDefId, v_DivertedActivityId;
               EXIT WHEN v_Cursor%NOTFOUND;
               SAVEPOINT TRANS;
                    v_SelectCount := 0;
						IF v_AssignBackToDivertedUser = N'Y' THEN
						BEGIN
							IF v_DivertedProcessDefId >0 AND v_DivertedActivityId > 0 THEN
							BEGIN
								OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId AND ActivityId = v_DivertedActivityId;
							END;
							ELSIF  v_DivertedProcessDefId >0  THEN
							BEGIN
							OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId ;
							END;
							ELSE
							BEGIN
							OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex;
							END;
							END IF;
                         
                         LOOP
                         BEGIN
                              FETCH v_InnerCursor INTO v_ProcessInstanceId, v_ProcessInstanceId, v_ProcessDefId, v_ActivityId, v_ActivityName, v_Q_QueueId;
                              EXIT WHEN v_InnerCursor%NOTFOUND;
                              v_SelectCount := v_SelectCount + 1;
                              WFGenerateLog(123, NULL, v_ProcessDefId, v_ActivityId, v_Q_QueueId, v_AssignedUserName, v_ActivityName, 0, v_ProcessInstanceId, v_DivertedUserIndex, v_DivertedUserName, v_WorkitemId, 0, 0, v_MainCode,v_isReport , 0, 0, 0,NULL,NULL,NULL,v_tarHisLog,v_insertTarStr);
                              IF(v_MainCode <> 0) THEN
                              BEGIN
                                   ROLLBACK TO SAVEPOINT TRANS;
                                   CLOSE v_InnerCursor;
                                   GOTO NEXTRECORD3;
                              END;
                              END IF;
							  
							  v_MyQueue := v_DivertedUserName || '''s MyQueue';
                              UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N' AND ProcessInstanceID =v_ProcessInstanceId AND WorkItemId = v_ProcessInstanceId;
							  
                         END;
                         END LOOP;

                         CLOSE v_InnerCursor;

                         /*IF(v_SelectCount > 0) THEN
                         BEGIN
                              v_MyQueue := v_DivertedUserName || '''s MyQueue';
                              UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N';
                              v_UpdateCount := SQL%ROWCOUNT;
                              IF(v_SelectCount <> v_UpdateCount) THEN
                              BEGIN
                                   ROLLBACK TO SAVEPOINT TRANS;
                                   GOTO NEXTRECORD3;
                              END;
                              END IF;
                         END;
                         END IF;*/
                    END;
                    END IF;
					
					
					
					
					
					
					--added by Nikhil for Task
					
					
					
					IF v_AssignBackToDivertedUser = N'Y' THEN
                    BEGIN
							IF v_DivertedProcessDefId >0 AND v_DivertedActivityId > 0 THEN
							BEGIN
								OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N' AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId AND ActivityId = v_DivertedActivityId;
							END;
							ELSIF  v_DivertedProcessDefId >0  THEN
							BEGIN
								OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N' AND Q_DivertedByUserId = v_DivertedUserIndex AND ProcessDefId = v_DivertedProcessDefId;
							END;
							ELSE
							BEGIN
								OPEN v_InnerCursor FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE TaskStatus =2 AND LockStatus = 'N' AND Q_DivertedByUserId = v_DivertedUserIndex;
							END;
							END IF;
                       
                         LOOP
                         BEGIN
                              FETCH v_InnerCursor INTO v_ProcessInstanceId, v_WorkitemId, v_ProcessDefId, v_ActivityId, v_AssignedTo, v_SubTaskId,v_TaskId;
                              EXIT WHEN v_InnerCursor%NOTFOUND;
                              v_assocField := v_AssignedTo ||','||v_DivertedUserName;
							WFGenerateLog(715, NULL, v_ProcessDefId, v_ActivityId, v_Q_QueueId, v_AssignedUserName, v_ActivityName, 0, v_ProcessInstanceId, v_DivertedUserIndex, v_assocField, v_WorkitemId, 0, 0, v_MainCode,v_isReport , 0, v_TaskId ,v_SubTaskId,NULL,NULL,NULL,v_tarHisLog,v_insertTarStr);
                              IF(v_MainCode <> 0) THEN
                              BEGIN
                                   ROLLBACK TO SAVEPOINT TRANS;
                                   CLOSE v_InnerCursor;
                                   GOTO NEXTRECORD3;
                              END;
                              END IF;
							  
							  UPDATE WFTaskStatusTable SET AssignedTo = v_DivertedUserName, Q_DivertedByUserId = 0 WHERE Q_DivertedByUserId = v_DivertedUserIndex AND LockStatus = 'N' AND ProcessInstanceID =v_ProcessInstanceId AND WorkItemId = v_WorkitemId;
                         END;
                         END LOOP;

                         CLOSE v_InnerCursor;

                         /*IF(v_SelectCount > 0) THEN
                         BEGIN
                              v_MyQueue := v_DivertedUserName || '''s MyQueue';
                              UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = v_DivertedUserIndex, AssignedUser = v_DivertedUserName, Q_QueueId = 0, QueueName = v_MyQueue WHERE Q_UserId = v_AssignedUserIndex AND Q_DivertedByUserId = v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N';
                              v_UpdateCount := SQL%ROWCOUNT;
                              IF(v_SelectCount <> v_UpdateCount) THEN
                              BEGIN
                                   ROLLBACK TO SAVEPOINT TRANS;
                                   GOTO NEXTRECORD3;
                              END;
                              END IF;
                         END;
                         END IF;*/
                    END;
                    END IF;
					
					
					
					
                    DELETE FROM UserDiversionTable WHERE DivertedUserIndex = v_DivertedUserIndex;
                    v_DeleteCount := SQL%ROWCOUNT;
                    IF v_DeleteCount <= 0 THEN
                    BEGIN
                         ROLLBACK TO SAVEPOINT TRANS;
                         GOTO NEXTRECORD3;
                    END;
                    END IF;
                    IF(v_HistoryNew = 'N') THEN
                    BEGIN
                         WFGenerateLog(54, NULL, 0, 0, 0, 'SYSTEM', NULL, 0, NULL, v_DivertedUserIndex, v_DivertedUserName, 0, 0, 0, v_MainCode,v_isReport ,0,0,0,NULL,NULL,NULL,v_tarHisLog,v_insertTarStr);
                         IF(v_MainCode <> 0) THEN
                         BEGIN
                              ROLLBACK TO SAVEPOINT TRANS;
                              GOTO NEXTRECORD3;
                         END;
                         END IF;
                    END;
                    END IF;
                    IF(v_HistoryNew = 'Y') THEN
                    BEGIN
                         INSERT INTO WFAdminLogTable (ActionId, ActionDateTime, ProcessDefId, QueueId , QueueName, FieldId1, FieldName1, FieldId2, FieldName2, Property, UserId, UserName, OldValue, NewValue, WEFDate, ValidTillDate) VALUES (54, SYSDATE, 0, 0, NULL, v_DivertedUserIndex, v_DivertedUserName, 0, NULL, NULL, 0, 'SYSTEM', NULL, NULL, NULL, NULL);
                         v_InsertCount := SQL%ROWCOUNT;
                         IF(v_InsertCount <= 0) THEN
                         BEGIN
                              ROLLBACK TO SAVEPOINT TRANS;
                              GOTO NEXTRECORD3;
                         END;
                         END IF;
                    END;
                    END IF;
               COMMIT;
          END;
          END LOOP;
          CLOSE v_Cursor;
     END;
     v_ResCount := v_ResultCount;
     v_CSSessionId := csSessionId;
END;