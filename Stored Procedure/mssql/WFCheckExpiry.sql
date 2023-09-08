/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 9.0
	Module				: Transaction Server
	File Name			: WFCheckExpiry.sql
	Author				: Sweta Bansal
	Date written (DD/MM/YYYY)	: Aug 27th 2014
	Description			: Expire the workitem whose valid till has been reached.
						  Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
	
	This script will take two parameters in input : 
		1. Is History New : Its value will be "Y" if WFCurrentRouteLogTable is present in the system otherwise "N".
		2. CSName : It will contain the name/IP of the machine on which CS is running.
		
	Purpose of the script is as follows : 
		1. Expiry will perform following activities :
			a) Expire all Non-referred workitem which are present in User Queue and their Valid till has been reached.
			b) Expire all workitem which are on Hold stage and their hold till has been reached.
			c) Expire all the referred workitem which are present in User Queue and their Valid till has been reached such that all the referred child workitems get deleted, only Parent entry will proceed further.
		2. Delete all temporary user from the queue whose temporary assignment period has been reached.
		3. Delete Diversion Set for the user if Diversion period gets over. While deleting the Diversion, If RollBackDivertedWorkitem flag is set for that diversion then in that case assign back all the un-processed diverted item to the original user.
		
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))

------------------------------------------------------------------------------------------------------
27/08/2014		Sweta Bansal	Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
19/01/2016		Sajid Khan		Bug 58703 - CheckExpiry SP caused the database slowness when reffered workitems came in picture.
20/12/2016		Kahkeshan		Bug 58903 - Lock Status of workitems locked by Ps being set to “N” without Q_USerId updation .
17/05/2017		Kahkeshan		Bug 69254 - ValidTill and other fields not getting cleared from MSSQL WFCheckExpiry SP .
30/03/2018		Ashutosh Pandey	Bug 75232 - Remove the db console messages from all procedures
27/04/2018		Ashutosh Pandey	Bug 77141  - Architecture change in expiry utility
30/05/2018		Ashutosh Pandey	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
04/04/3019		Ashutosh Pandey	Bug 83959 - Expiry utility is getting hang in expiring referred WI
08/04/2020		Shahzad Malik	Bug 91513 - Optimization in mailing utility.
25/04/2020	Ravi Ranjan Kumar	Bug 92037 - WI showing in Referredto state even after the WI is expired and moved to next activity
----------------------------------------------------------------------------------------------------*/

IF EXISTS(SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFCHECKEXPIRY')
BEGIN
	DROP PROCEDURE WFCHECKEXPIRY
	Print 'Procedure WFCHECKEXPIRY already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE WFCHECKEXPIRY
(
@v_HistoryNew NVARCHAR(1),
@v_CSName NVARCHAR(100),
@v_BatchCount INT
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE @v_ProcessInstanceId NVARCHAR(63)
	DECLARE @v_WorkitemId INT
	DECLARE @v_ProcessDefId INT
	DECLARE @v_ActivityId INT
	DECLARE @v_ActivityName NVARCHAR(30)
	DECLARE @v_Q_QueueId INT
	DECLARE @v_ParentWorkItemId INT
	DECLARE @v_InsertCount INT
	DECLARE @v_TaskId INT
	DECLARE @v_SubTaskId INT
	DECLARE @v_DeleteCount INT
	DECLARE @v_SelectCount INT
	DECLARE @v_UpdateCount INT
	DECLARE @v_ParentIdStr NVARCHAR(100)
	DECLARE @v_ParentId INT
	DECLARE @v_Pos1 INT
	DECLARE @v_DivertedUserIndex INT
	DECLARE @v_DivertedProcessdefId INT
	DECLARE @v_DivertedActivityId INT
	DECLARE @v_DivertedUserName NVARCHAR(63)
	DECLARE @v_associatedFieldName NVARCHAR(100)
	DECLARE @v_TaskAssignedTo NVARCHAR(100)
	DECLARE @v_AssignedUserIndex INT
	DECLARE @v_AssignedUserName NVARCHAR(63)
	DECLARE @v_AssignBackToDivertedUser NVARCHAR(4)
	DECLARE @v_MyQueue NVARCHAR(100)
	DECLARE @v_AssignmentType NVARCHAR(4)
	DECLARE @v_TotalDuration INT
	DECLARE @v_MainCode INT
	DECLARE @v_ResultCount INT
	DECLARE @csSessionId INT
	DECLARE @v_LoopCount INT
	DECLARE @v_CurrentLoopCount INT
	DECLARE @v_LocalBatchCount INT
	DECLARE @v_Error INT
	DECLARE @v_ReferredByName NVARCHAR(63)
	DECLARE @CurrDate 		DATETIME
	
	SELECT @v_MainCode = 0
	SELECT @v_ResultCount = 0
	SELECT @csSessionId = 0
	SELECT @v_LocalBatchCount = @v_BatchCount
	
	IF(@v_CSName IS NOT NULL AND @v_CSName <> '')
	BEGIN
		SELECT @csSessionId = SessionID FROM PSRegisterationTable WITH(NOLOCK) WHERE Type = 'C' AND PSName = @v_CSName				
	END
	
	IF(@v_LocalBatchCount < 50 OR @v_LocalBatchCount > 100)
	BEGIN
		SELECT @v_LocalBatchCount = 100
	END

	SELECT @v_LoopCount = CEILING(@v_LocalBatchCount/10)

	--Going to Expire Non-Referred Workitems present in WorkListTable whose ValidTill is reached.
	SELECT @v_CurrentLoopCount = 0
	
		SELECT @v_Error = 0
		DECLARE EXPIRY_CURSOR CURSOR FAST_FORWARD FOR
			SELECT TOP 5 ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, DATEDIFF(ss, EntryDateTime, GETDATE()) FROM WFInstrumentTable WITH(UPDLOCK, READPAST) WHERE RoutingStatus = 'N' AND LockStatus = 'N' AND AssignmentType != 'E' AND ValidTill < GETDATE()
			
		OPEN EXPIRY_CURSOR
		BEGIN TRANSACTION LOCK
		
		FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_TotalDuration
		
		IF(@@FETCH_STATUS = -1 OR @@FETCH_STATUS = -2)
		BEGIN
			COMMIT TRANSACTION LOCK
			CLOSE EXPIRY_CURSOR
			DEALLOCATE EXPIRY_CURSOR
			GOTO BLOCK1
		END
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
				Update WFinstrumentTable set RoutingStatus = 'Y',LockStatus = 'N',WorkItemState = 6 ,Statename = N'COMPLETED' , Q_Userid = 0,Q_DivertedByUserId = 0,AssignmentType =N'X',Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,ValidTill = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL where ProcessInstanceID = @v_ProcessInstanceId AND WorkItemID = @v_WorkitemId
				
				IF(@@error <> 0)
				BEGIN
					ROLLBACK TRANSACTION LOCK
					SELECT @v_Error = 1
					BREAK
				END
				SELECT @CurrDate = GETDATE()
				EXECUTE WFGenerateLog 28, NULL, @v_ProcessDefId, @v_ActivityId, @v_Q_QueueId, NULL, @v_ActivityName, @v_TotalDuration, @v_ProcessInstanceId, 0, NULL, @v_WorkitemId, 0, 0,NULL,0, 0, 0, NULL,@CurrDate, @v_MainCode OUT
				IF(@v_MainCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION LOCK
					SELECT @v_Error = 1
					BREAK
				END
				SELECT @v_ResultCount = @v_ResultCount + 1
			
			
			NEXTRECORD:
			FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_TotalDuration
			IF(@@ERROR <> 0)
			BEGIN
				GOTO NEXTRECORD
			END
		END
		IF(@v_Error = 0)
		BEGIN
			COMMIT TRANSACTION LOCK
		END
		CLOSE EXPIRY_CURSOR
		DEALLOCATE EXPIRY_CURSOR
		
		SELECT @v_CurrentLoopCount = @v_CurrentLoopCount + 1
	END
	
	IF(@v_ResultCount = 5)
	BEGIN
		GOTO ALWAYSPROCESS
	END

	--Going to expire Hold WorkItems present in PendingWorkListTable whose ValidTill is reached.
	BLOCK1:
	SELECT @v_CurrentLoopCount = 0
		SELECT @v_Error = 0
		DECLARE EXPIRY_CURSOR CURSOR FAST_FORWARD FOR
			SELECT TOP 5 ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, DATEDIFF(ss, EntryDateTime, GETDATE()) FROM WFinstrumentTable WITH(UPDLOCK, READPAST) WHERE WorkItemState = 3 AND AssignmentType = 'H' AND ValidTill < GETDATE() AND RoutingStatus = N'R'
			
		OPEN EXPIRY_CURSOR
		BEGIN TRANSACTION LOCK
		
		FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_TotalDuration
		
		IF(@@FETCH_STATUS = -1 OR @@FETCH_STATUS = -2)
		BEGIN
			COMMIT TRANSACTION LOCK
			CLOSE EXPIRY_CURSOR
			DEALLOCATE EXPIRY_CURSOR
			GOTO BLOCK2
		END
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
				Update WFInstrumentTable set RoutingStatus = N'Y' , LockStatus = 'N' ,AssignmentType =  N'X', WorkItemState = 6 , Statename = N'COMPLETED', Q_Userid = 0,Q_DivertedByUserId = 0 ,Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,ValidTill = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL
				where  ProcessInstanceID = @v_ProcessInstanceId AND WorkItemID = @v_WorkitemId
				
				IF(@@error <> 0)
				BEGIN
					ROLLBACK TRANSACTION LOCK
					SELECT @v_Error = 1
					BREAK
				END
				SELECT @CurrDate = GETDATE()
				EXECUTE WFGenerateLog 28, NULL, @v_ProcessDefId, @v_ActivityId, @v_Q_QueueId, NULL, @v_ActivityName, @v_TotalDuration, @v_ProcessInstanceId, 0, NULL, @v_WorkitemId, 0, 0,NULL,0, 0,0, NULL , @CurrDate,@v_MainCode OUT
				IF(@v_MainCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION LOCK
					SELECT @v_Error = 1
					BREAK
				END
				SELECT @v_ResultCount = @v_ResultCount + 1
			
			
			NEXTRECORD1:
			FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_TotalDuration
			IF(@@ERROR <> 0)
			BEGIN
				GOTO NEXTRECORD1
			END
		END
		IF(@v_Error = 0)
		BEGIN
			COMMIT TRANSACTION LOCK
		END
		CLOSE EXPIRY_CURSOR
		DEALLOCATE EXPIRY_CURSOR
		SELECT @v_CurrentLoopCount = @v_CurrentLoopCount + 1
	END
	
	IF(@v_ResultCount = 5)
	BEGIN
		GOTO ALWAYSPROCESS
	END

	--Going to Expire Referred records present in WorkListTable whose ValidTill is reached.
	BLOCK2:
	SELECT @v_CurrentLoopCount = 0
		SELECT @v_Error = 0
		DECLARE EXPIRY_CURSOR CURSOR FAST_FORWARD FOR
			SELECT TOP 5 ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID, ParentWorkItemId, DATEDIFF(ss, EntryDateTime, GETDATE()) FROM WFInstrumentTable WITH(UPDLOCK, READPAST) where RoutingStatus = 'N' AND LockStatus = 'N' AND AssignmentType = 'E' AND ValidTill < GETDATE()
			
		OPEN EXPIRY_CURSOR
		BEGIN TRANSACTION LOCK
		
		FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_ParentWorkItemId, @v_TotalDuration
		
		IF(@@FETCH_STATUS = -1 OR @@FETCH_STATUS = -2)
		BEGIN
			COMMIT TRANSACTION LOCK
			CLOSE EXPIRY_CURSOR
			DEALLOCATE EXPIRY_CURSOR
			GOTO ALWAYSPROCESS
		END
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SELECT @v_ParentIdStr = ''
				DELETE FROM WFInstrumentTable where ProcessInstanceId = @v_ProcessInstanceId AND WorkItemId = @v_WorkitemId
				WHILE(1 = 1)
				BEGIN
					SELECT @v_ParentId = ParentWorkItemId, @v_AssignmentType = AssignmentType, @v_ReferredByName = ReferredByName FROM WFInstrumentTable  WITH (NOLOCK) WHERE RoutingStatus = N'R' AND ProcessInstanceId = @v_ProcessInstanceId AND WorkItemId = @v_ParentWorkItemId
					SELECT @v_SelectCount = @@ROWCOUNT
					IF(@v_SelectCount <= 0)
					BEGIN
						ROLLBACK TRANSACTION LOCK
						SELECT @v_Error = 1
						BREAK
					END
					IF(@v_AssignmentType IS NOT NULL)
					BEGIN
						SELECT @v_AssignmentType = LTRIM(RTRIM(@v_AssignmentType))
					END					
					IF(@v_ReferredByName IS NOT NULL AND LEN(@v_ReferredByName) > 0)
					BEGIN
						DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_ParentWorkItemId
						SELECT @v_ParentWorkItemId = @v_ParentId
					END
					ELSE IF(@v_AssignmentType IS NULL OR @v_AssignmentType <> N'E')
					BEGIN
						Update WFinstrumentTable set RoutingStatus = N'Y', ValidTill=null,LockStatus = 'N', WorkItemState = 6, Statename =  N'COMPLETED' , AssignmentType = N'X', Q_Userid = 0,Q_DivertedByUserId = 0,Q_StreamId = Null ,Q_QueueId = 0,LockedTime = NULL,QueueName = NULL,QueueType = NULL,LockedByName=NULL, LastProcessedBy = 0, ProcessedBy = 'System', NotifyStatus = NULL  ,Referredto=null,Referredtoname=null WHERE ProcessInstanceID = @v_ProcessInstanceId AND WorkItemID = @v_ParentWorkItemId
						IF(@@error <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							SELECT @v_Error = 1
							BREAK
						END
						SELECT @CurrDate = GETDATE()
						EXECUTE WFGenerateLog 28, NULL, @v_ProcessDefId, @v_ActivityId, @v_Q_QueueId, NULL, @v_ActivityName, @v_TotalDuration, @v_ProcessInstanceId, 0, NULL, @v_WorkitemId, 0, 0,NULL,0, 0,0, NULL,@CurrDate, @v_MainCode OUT
						IF(@v_MainCode <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							SELECT @v_Error = 1
							BREAK
						END
						BREAK
					END
				END
			SELECT @v_ResultCount = @v_ResultCount + 1
			
			
			NEXTRECORD2:
			FETCH NEXT FROM EXPIRY_CURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId, @v_ParentWorkItemId, @v_TotalDuration
			IF(@@ERROR <> 0)
			BEGIN
				GOTO NEXTRECORD2
			END
		END
		IF(@v_Error = 0)
		BEGIN
			COMMIT TRANSACTION LOCK
		END
		CLOSE EXPIRY_CURSOR
		DEALLOCATE EXPIRY_CURSOR
		SELECT @v_CurrentLoopCount = @v_CurrentLoopCount + 1
	END
	
	ALWAYSPROCESS:
	--Going to Delete entries from QueueUserTble in case Temporary User Assignment Period is reached.
	BEGIN
		DELETE FROM QueueUserTable WHERE AssignedTillDateTime < GETDATE()
	END
	
	--Going to Delete entries from UserDiversionTable in case Diversion Period is reached and also Assign back the workitems from AssignedUser to the original DivertedUser if CurrentWorkItemFlag(i.e. Assign Back Current Workitem Flag) in UserDiversionTable is 'Y' for that Diversion.
	BEGIN
		DECLARE EXPIRY_CURSOR CURSOR FAST_FORWARD FOR
			SELECT DivertedUserIndex, DivertedUserName, AssignedUserIndex, AssignedUserName, CurrentWorkItemsFlag, ProcessDefId, ActivityId FROM UserDiversionTable  WITH (NOLOCK) WHERE ToDate < GETDATE()
		
		OPEN EXPIRY_CURSOR
		
		FETCH NEXT FROM EXPIRY_CURSOR INTO @v_DivertedUserIndex, @v_DivertedUserName, @v_AssignedUserIndex, @v_AssignedUserName, @v_AssignBackToDivertedUser, @v_DivertedProcessdefId, @v_DivertedActivityId
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			BEGIN TRANSACTION LOCK
				SELECT @v_SelectCount = 0
				SELECT @v_DeleteCount = 0
				SELECT @v_UpdateCount = 0
				IF(@v_AssignBackToDivertedUser = 'Y')
				BEGIN
					IF(@v_DivertedProcessdefId > 0 AND @v_DivertedActivityId > 0)
					BEGIN
						DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable  WITH (NOLOCK) WHERE RoutingStatus = N'N' AND LockStatus = N'N' AND Q_UserId = @v_AssignedUserIndex AND Q_DivertedByUserId = @v_DivertedUserIndex AND ProcessDefId = @v_DivertedProcessdefId AND ActivityId = @v_DivertedActivityId
					END
					ELSE IF(@v_DivertedProcessdefId > 0)
						BEGIN
							DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable  WITH (NOLOCK) WHERE RoutingStatus = N'N' AND LockStatus = N'N' AND Q_UserId = @v_AssignedUserIndex AND Q_DivertedByUserId = @v_DivertedUserIndex	AND ProcessDefId = @v_DivertedProcessdefId					
						END
					ELSE
						BEGIN
						DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID FROM WFInstrumentTable  WITH (NOLOCK) WHERE RoutingStatus = N'N' AND LockStatus = N'N' AND Q_UserId = @v_AssignedUserIndex AND Q_DivertedByUserId = @v_DivertedUserIndex 
					END						
					
					
					OPEN EXPIRY_INNERCURSOR
					
					FETCH NEXT FROM EXPIRY_INNERCURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId
					
					WHILE(@@FETCH_STATUS = 0)
					BEGIN
						SELECT @v_SelectCount = @v_SelectCount + 1
						EXECUTE WFGenerateLog 123, NULL, @v_ProcessDefId, @v_ActivityId, @v_Q_QueueId, @v_AssignedUserName, @v_ActivityName, 0, @v_ProcessInstanceId, @v_DivertedUserIndex, @v_DivertedUserName, @v_WorkitemId, 0, 0,NULL,0, 0,0, NULL,NULL, @v_MainCode OUT
						IF(@v_MainCode <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							CLOSE EXPIRY_INNERCURSOR
							DEALLOCATE EXPIRY_INNERCURSOR
							GOTO NEXTRECORD3
						END
						
						SELECT @v_MyQueue = @v_DivertedUserName + '''s MyQueue'
						UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = @v_DivertedUserIndex, AssignedUser = @v_DivertedUserName, Q_QueueId = 0, QueueName = @v_MyQueue WHERE Q_UserId = @v_AssignedUserIndex AND Q_DivertedByUserId = @v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N' AND ProcessInstanceID =@v_ProcessInstanceId AND WorkItemId = @v_WorkitemId
						
						FETCH NEXT FROM EXPIRY_INNERCURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_ActivityName, @v_Q_QueueId
						IF(@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							CLOSE EXPIRY_INNERCURSOR
							DEALLOCATE EXPIRY_INNERCURSOR
							GOTO NEXTRECORD3
						END
					END
					
					CLOSE EXPIRY_INNERCURSOR
					DEALLOCATE EXPIRY_INNERCURSOR
					
					/*IF(@v_SelectCount > 0)
					BEGIN
						SELECT @v_MyQueue = @v_DivertedUserName + '''s MyQueue'
						UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = @v_DivertedUserIndex, AssignedUser = @v_DivertedUserName, Q_QueueId = 0, QueueName = @v_MyQueue WHERE Q_UserId = @v_AssignedUserIndex AND Q_DivertedByUserId = @v_DivertedUserIndex AND RoutingStatus = 'N' AND LockStatus = 'N'
						SELECT @v_UpdateCount = @@ROWCOUNT
						IF(@v_SelectCount <> @v_UpdateCount)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							GOTO NEXTRECORD3
						END
					END */
				END
				
				--Added by Nikhil for Tasks
				
				
				
				IF(@v_AssignBackToDivertedUser = 'Y')
				BEGIN
					IF(@v_DivertedProcessdefId > 0 AND @v_DivertedActivityId > 0)
					BEGIN
					DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WITH (NOLOCK) WHERE TaskStatus =2 AND LockStatus = N'N' AND Q_DivertedByUserId = @v_DivertedUserIndex AND ProcessDefId = @v_DivertedProcessdefId AND ActivityId = @v_DivertedActivityId
					END
					ELSE IF(@v_DivertedProcessdefId > 0)
					BEGIN
						DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WITH (NOLOCK) WHERE TaskStatus =2 AND LockStatus = N'N' AND Q_DivertedByUserId = @v_DivertedUserIndex AND ProcessDefId = @v_DivertedProcessdefId 
					END
					ELSE
					BEGIN
						DECLARE EXPIRY_INNERCURSOR CURSOR FAST_FORWARD FOR SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WITH (NOLOCK) WHERE TaskStatus =2 AND LockStatus = N'N' AND Q_DivertedByUserId = @v_DivertedUserIndex
					END
					
					
					OPEN EXPIRY_INNERCURSOR
					
					FETCH NEXT FROM EXPIRY_INNERCURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_TaskAssignedTo, @v_SubTaskId, @v_TaskId
					
					WHILE(@@FETCH_STATUS = 0)
					BEGIN
						SELECT @v_associatedFieldName = @v_TaskAssignedTo + ',' + @v_DivertedUserName
						SELECT @v_SelectCount = @v_SelectCount + 1
						EXECUTE WFGenerateLog 715, NULL, @v_ProcessDefId, @v_ActivityId, @v_Q_QueueId, @v_AssignedUserName, @v_ActivityName, 0, @v_ProcessInstanceId, @v_DivertedUserIndex, @v_associatedFieldName, @v_WorkitemId, 0, 0,NULL,0,@v_TaskId ,@v_SubTaskId, NULL,NULL, @v_MainCode OUT
						IF(@v_MainCode <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							CLOSE EXPIRY_INNERCURSOR
							DEALLOCATE EXPIRY_INNERCURSOR
							GOTO NEXTRECORD3
						END
						
						UPDATE WFTaskStatusTable SET AssignedTo = @v_DivertedUserName, Q_DivertedByUserId = 0 WHERE Q_DivertedByUserId = @v_DivertedUserIndex AND LockStatus = 'N' AND ProcessInstanceID =@v_ProcessInstanceId AND WorkItemId = @v_WorkitemId AND ProcessdefId = @v_ProcessDefId AND ActivityId = @v_ActivityId
						
						FETCH NEXT FROM EXPIRY_INNERCURSOR INTO @v_ProcessInstanceId, @v_WorkitemId, @v_ProcessDefId, @v_ActivityId, @v_TaskAssignedTo, @v_SubTaskId, @v_TaskId
						IF(@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION LOCK
							CLOSE EXPIRY_INNERCURSOR
							DEALLOCATE EXPIRY_INNERCURSOR
							GOTO NEXTRECORD3
						END
					END
					
					CLOSE EXPIRY_INNERCURSOR
					DEALLOCATE EXPIRY_INNERCURSOR
					
					
				END
				
				
				
				DELETE FROM UserDiversionTable WHERE DivertedUserIndex = @v_DivertedUserIndex
				SELECT @v_DeleteCount = @@ROWCOUNT
				IF(@v_DeleteCount <= 0)
				BEGIN
					ROLLBACK TRANSACTION LOCK
					GOTO NEXTRECORD3
				END
				IF(@v_HistoryNew = 'N')
				BEGIN
					EXECUTE WFGenerateLog 54, NULL, 0, 0, 0, 'SYSTEM', NULL, 0, NULL, @v_DivertedUserIndex, @v_DivertedUserName, 0, 0, 0, NULL ,0 , 0 ,0, NULL,NULL, @v_MainCode OUT
					IF(@v_MainCode <> 0)
					BEGIN
						ROLLBACK TRANSACTION LOCK
						GOTO NEXTRECORD3
					END
				END
				IF(@v_HistoryNew = 'Y')
				BEGIN
					INSERT INTO WFAdminLogTable (ActionId, ActionDateTime, ProcessDefId, QueueId , QueueName, FieldId1, FieldName1, FieldId2, FieldName2, Property, UserId, UserName, OldValue, NewValue, WEFDate, ValidTillDate) VALUES (54, GETDATE(), 0, 0, NULL, @v_DivertedUserIndex, @v_DivertedUserName, 0, NULL, NULL, 0, 'SYSTEM', NULL, NULL, NULL, NULL)
					SELECT @v_InsertCount = @@ROWCOUNT
					IF(@v_InsertCount <= 0)
					BEGIN
						ROLLBACK TRANSACTION LOCK
						GOTO NEXTRECORD3
					END
				END
			COMMIT TRANSACTION LOCK
			
			NEXTRECORD3:
			FETCH NEXT FROM EXPIRY_CURSOR INTO @v_DivertedUserIndex, @v_DivertedUserName, @v_AssignedUserIndex, @v_AssignedUserName, @v_AssignBackToDivertedUser, @v_DivertedProcessdefId, @v_DivertedActivityId
			IF(@@ERROR <> 0)
			BEGIN
				GOTO NEXTRECORD3
			END
		END
		CLOSE EXPIRY_CURSOR
		DEALLOCATE EXPIRY_CURSOR
	END
	SELECT ResultCount = @v_ResultCount, CSSessionId = @csSessionId
END

~

Print 'Stored Procedure WFCHECKEXPIRY compiled successfully ........'