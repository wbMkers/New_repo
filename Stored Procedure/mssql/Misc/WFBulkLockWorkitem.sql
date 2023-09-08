/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 10.3
	Module				: Transaction Server
	File Name			: WFBulkLockWorkitem.sql
	Author				: Mohd Jaseem Ansari
	Date written (DD/MM/YYYY)	: 12/01/2017
	Purpose 			: To lock the multiple workitems.
	
						1. Processinstance ids will be provided in comma separated forms.
						2. Workitem ids will be provided in comma separated forms.
						3. Batch flag will be provided. If this flag is Y then All theworkitem will be locked and if error occurs for any workitem then all the workitem will be rolled back.If this flag is N then only failed workitem will be rolled back. 
		
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
24.07.2017		Mohnish Chopra	PRDP Bug 70097 - Error in BulkLock Worktiems when certain workitems provided in input xml are already locked .
------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------*/

IF EXISTS(SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFBulkLockWorkitem')
BEGIN
	DROP PROCEDURE WFBulkLockWorkitem
	Print 'Procedure WFBulkLockWorkitem already exists, hence older one dropped ..... '
END

~


 

CREATE PROCEDURE WFBulkLockWorkitem (
	@DBSessionId int,
	@DBQueueId int,
	@DBNoOfRecord int,
	@DBBatchFlag char(1),
	@DBHistoryFlag char(1),
	@DBProcessInstaceIds nvarchar(MAX),
	@DBWorkItemIds nvarchar(MAX),
	@DBMainCode INT OUTPUT,  
	@DBSubCode INT OUTPUT,  
	@DBNoOfFailedRecord INT OUTPUT,  
	@DBFailedProcessInstanceIds nvarchar (MAX) OUTPUT,
	@DBSubCodeList nvarchar(MAX) OUTPUT
		
)

AS

BEGIN

	DECLARE @sep_current_position_PId INT
	DECLARE @sep_prev_postion_PId INT
	DECLARE @sep_current_position_WId INT
	DECLARE @sep_prev_postion_WId INT
	DECLARE @v_ProcessInstaceId nvarchar(60)
	DECLARE @v_WorkitemId nvarchar(60)
	DECLARE @v_lockedById INT
	DECLARE @v_lockedByName nvarchar(60)
	DECLARE @v_ProcessDefId INT
	DECLARE @v_ActivityId INT
	DECLARE @v_QueueId INT
	DECLARE @v_ActivityName nvarchar(60)
	DEClare @v_MainCode INT
	DECLARE @v_LockStatus CHAR(1)
	DECLARE @v_userName nvarchar(60)
	DECLARE @v_HistoryNew CHAR(1)
	
	
	DECLARE @FailedProcessInstanceId nvarchar(MAX)
	DECLARE @NoOfFailedProcessInstanceId INT
	DECLARE @ErrorFlag CHAR(1)
	DECLARE @NoOfRecord INT
	DECLARE @v_FailedWISubCodeList nvarchar(MAX)
	

	
	
	SET @ErrorFlag = 'N'
	SET @v_HistoryNew=@DBHistoryFlag
	SET @sep_prev_postion_PId = 0
	SET @sep_prev_postion_WId = 0
	SET @FailedProcessInstanceId = ''
	SET @NoOfFailedProcessInstanceId = 0
	SET @NoOfRecord = @DBNoOfRecord
	SET @v_FailedWISubCodeList = ''
	
	/*Initializing output parameter*/
	SET @DBMainCode = 0
	SET @DBSubCode = 0
	SET @DBNoOfFailedRecord = 0
	SET @DBFailedProcessInstanceIds = ''
	

	/*Check for validity of session */
	SELECT @v_lockedById = UserID, @v_userName = UserName FROM WFSessionView, WFUserView 
	WHERE UserId = UserIndex AND SessionID = @DBSessionId

	IF(@@ERROR <> 0 OR @@ROWCOUNT <= 0)
	BEGIN
		SELECT @DBMainCode = 11, @DBSubCode = 0, @DBNoOfFailedRecord = 0, @DBFailedProcessInstanceIds = '' -- Invalid Session
		RETURN
	END
	
	
	/*Check for user association */	
	SELECT QueueID FROM userqueuetable WHERE UserID = @v_lockedById AND  QueueID = @DBQueueId
	
	IF(@@ERROR <> 0 OR @@ROWCOUNT <= 0)
	BEGIN
		SELECT @DBMainCode = 830, @DBSubCode = 0, @DBNoOfFailedRecord = 0,@DBFailedProcessInstanceIds = ''  -- User has no rights on the queue.
		RETURN
	END
	
	
	/* processing for all workitems */
	IF(@DBBatchFlag = 'Y')
		BEGIN TRANSACTION Batch_Transaction
	
	WHILE @NoOfRecord > 0 
			BEGIN -- Beginning of While loop
				IF(@DBBatchFlag = 'N')
					BEGIN TRANSACTION Single_Transaction
					
				SET @sep_current_position_PId = CHARINDEX(',', @DBProcessInstaceIds,@sep_prev_postion_PId)					
				SET @sep_current_position_WId = CHARINDEX(',', @DBWorkItemIds,@sep_prev_postion_WId)
				
				SET @v_ProcessInstaceId = SUBSTRING(@DBProcessInstaceIds, @sep_prev_postion_PId, @sep_current_position_PId-@sep_prev_postion_PId)
				SET @v_WorkitemId = SUBSTRING(@DBWorkItemIds, @sep_prev_postion_WId, @sep_current_position_WId-@sep_prev_postion_WId)
				SET @sep_prev_postion_PId = @sep_current_position_PId+1		--for next iteration
				SET @sep_prev_postion_WId = @sep_current_position_WId+1
				SET @NoOfRecord = @NoOfRecord-1;
				
				SELECT @v_ProcessDefId=ProcessDefId,@v_ActivityId=ActivityId,@v_ActivityName=ActivityName, @v_QueueId=Q_QueueId,@v_LockStatus = LockStatus,@v_LockedByName = LockedByName from  wfinstrumenttable WHERE ProcessInstanceID = RTrim(LTrim(@v_ProcessInstaceId)) AND WorkItemID = CONVERT(INT, @v_WorkitemId)  AND RoutingStatus = 'N'
				
				IF( @@Error <> 0 OR @@rowcount <= 0 )
					BEGIN					
					SET @ErrorFlag =  'Y'
					SELECT @DBMainCode = 400,@DBSubCode = 6, @DBNoOfFailedRecord = 0,@DBFailedProcessInstanceIds = '' --Need to set the main code and subcode when workitem does not exist.
					END
					
				ELSE
					BEGIN						
					IF( @v_QueueId=@DBQueueId) --IF WORKITEM IS IN SAME QUEUE THEN PROCEED
						BEGIN
							IF(@v_LockStatus = 'N' )
								BEGIN
									UPDATE wfinstrumenttable SET Q_UserId = @v_lockedById , WorkItemState = 2 , LockedByName = @v_userName, LockStatus = 'Y' , LockedTime =GETDATE() , Guid = NULL WHERE ProcessInstanceID = RTrim(LTrim(@v_ProcessInstaceId))  AND WorkItemID = CONVERT(INT, @v_WorkitemId) 
									
									IF( @@Error <> 0 OR @@rowcount <= 0 )
										BEGIN
											SELECT @DBMainCode = 400,@DBSubCode = 6, @DBNoOfFailedRecord = 0,@DBFailedProcessInstanceIds = '' --Need to set the main code and subcode when issue comes while uploading the table.
											SET @ErrorFlag =  'Y'
									END
								
									IF(@ErrorFlag = 'N')
										BEGIN
										EXECUTE WFGenerateLog 7, @v_lockedById, @v_ProcessDefId, @v_ActivityId, @v_QueueId, @v_userName, @v_ActivityName, 0, @v_ProcessInstaceId, 0, NULL,@v_WorkitemId, 0, 0, NULL, 0 , 0 ,0 , NULL,NULL, @v_MainCode OUT
										END
								END
							ELSE IF (@v_LockedByName=@v_userName)
								BEGIN
									UPDATE wfinstrumenttable SET Q_UserId = @v_lockedById , WorkItemState = 2 , LockedByName = @v_userName , LockStatus = 'Y' , LockedTime =GETDATE() , Guid = NULL WHERE ProcessInstanceID = RTrim(LTrim(@v_ProcessInstaceId))  AND WorkItemID = CONVERT(INT, @v_WorkitemId) 
								
									IF( @@Error <> 0 OR @@rowcount <= 0 )
										BEGIN
											SELECT @DBMainCode = 400,@DBSubCode = 6, @DBNoOfFailedRecord=0,@DBFailedProcessInstanceIds = '' --Need to set the main code and subcode when issue comes while uploading the table.
											SET @ErrorFlag =  'Y'
										END
								END
							ELSE
								BEGIN
								SET @ErrorFlag ='Y';
								SELECT	@DBMainCode = 400,@DBSubCode = 16,@DBNoOfFailedRecord = 0,@DBFailedProcessInstanceIds = '';
								END
						END
					ELSE
						BEGIN						
							SET @ErrorFlag =  'Y'	
							SELECT @DBMainCode = 400,@DBSubCode = 985, @DBNoOfFailedRecord=0,@DBFailedProcessInstanceIds = '' --Need to set the main code and subcode when workitem is in different queue.
						END
					END
						
					IF(@DBBatchFlag = 'Y' )
						BEGIN	
							IF(@ErrorFlag = 'Y')
								BEGIN
									Break
								END
							ELSE
								BEGIN
									SET @ErrorFlag = 'N'
									CONTINUE
								END
						END
					ELSE IF(@DBBatchFlag = 'N')
						BEGIN
							IF(@ErrorFlag = 'Y')
								BEGIN
									SET @ErrorFlag = 'N'
									SET @FailedProcessInstanceId = @FailedProcessInstanceId+@v_ProcessInstaceId+','
									SET @NoOfFailedProcessInstanceId = @NoOfFailedProcessInstanceId + 1
									print(@DBSubCode)
									SET @v_FailedWISubCodeList = @v_FailedWISubCodeList + CONVERT(varchar(10), @DBSubCode)  + ','
									print(@v_FailedWISubCodeList)
									ROLLBACK  TRANSACTION Single_Transaction					
									CONTINUE
								END
							ELSE IF(@ErrorFlag = 'N')
								BEGIN
									SET @ErrorFlag = 'N'
									COMMIT TRANSACTION Single_Transaction
								END
						END							 		
				END --End of while loop				
 	IF(@DBBatchFlag = 'Y')
	BEGIN
		IF(@ErrorFlag='Y')
			BEGIN
				ROLLBACK TRANSACTION Batch_Transaction
				RETURN
			END
		ELSE
			BEGIN
				COMMIT TRANSACTION  Batch_Transaction
				RETURN
			END
	END
	ELSE
		BEGIN	
			SELECT @DBMainCode = 0, @DBSubCode = 0, @DBNoOfFailedRecord = @NoOfFailedProcessInstanceId, @DBFailedProcessInstanceIds = @FailedProcessInstanceId,@DBSubCodeList = @v_FailedWISubCodeList
			RETURN
		END 
END



