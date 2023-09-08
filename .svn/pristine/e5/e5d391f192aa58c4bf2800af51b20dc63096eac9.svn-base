/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Application –Products
	Product / Project		: Omniflow 10.1
	Module				: Omniflow Server
	File Name			: WFGetNextWorkItemForPS.sql
	Programmer			: Mohnish Chopra
	Date written (DD/MM/YYYY)		: 05/02/2014
	Last Modified By (DD/MM/YYYY)	: 
	Last Modified On (DD/MM/YYYY)	: 
	Description			: Stored procedure that returns the locked workitem data for PS . If no locked workitem exists, then SP
							locks the workitem and then returns the same.
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------
DD/MM/YYYY	Changed by		Change Description
13/10/16	Rishi		Bug-64860 - PRDP Bug 59917 - Bulk Ps support for MSSQL Database
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
23/07/2020  Shubham    Internal Bug:Code modified for picking up only that workitems that are being locked for more than 3 seconds.
------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------*/
If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFGetNextWorkItemForPS')
Begin
	Execute('DROP PROCEDURE WFGetNextWorkItemForPS')
	Print 'Procedure WFGetNextWorkItemForPS already exists, hence older one dropped ..... '
End

~

Create Procedure WFGetNextWorkItemForPS(
	@DBSessionId			Int,
	@DBCSName			NVARCHAR(100),
	@DBProcessDefId			Int,
	@DBBulkPS				NVARCHAR(1)
)    
AS     
SET NOCOUNT ON     
BEGIN
	DECLARE @psId INT
	DECLARE @psName NVARCHAR(400)
	DECLARE @csSessionId INT	
	DECLARE @processInstanceId NVARCHAR(150)
	DECLARE @workItemId INT
	DECLARE @v_rowCount INT
	DECLARE @v_errorCode INT
	DECLARE	@v_quoteChar 			CHAR(1) 
	DECLARE @activityName   			NVARCHAR(30)
	DECLARE @activityId   				INT
	DECLARE @parentWorkItemId   		INT	
	DECLARE @assignmentType   			NVARCHAR(1)
	DECLARE @collectFlag   				NVARCHAR(1)
	DECLARE @priorityLevel   			SMALLINT
	DECLARE @lockStatus   				NVARCHAR(1)
	DECLARE @processVariantId			INT
	
	
	SET @csSessionId = 0
	SET @v_rowCount = 0

	BEGIN
		Select @psId = PSReg.PSId, @psName = PSReg.PSName from PSREGISTERATIONTABLE PSReg WITH(NOLOCK) , WFPSConnection PSCon WITH(NOLOCK) where PSCon.SessionId = @DBSessionId AND PSReg.PSID = PSCon.PSID 
		Select @v_rowCount = @@ROWCOUNT, @v_errorCode = @@ERROR
		IF @v_rowCount <= 0 or @v_errorCode <> 0
		BEGIN
			Select 11, NULL, NULL, NULL
			RETURN
		END		
	END
	
	BEGIN
		Select @csSessionId = PSCon.SessionID from PSREGISTERATIONTABLE PSReg WITH(NOLOCK) , WFPSConnection PSCon WITH(NOLOCK)  where PSReg.Type = 'C' AND PSReg.PSName = @DBCSName AND PSReg.PSID = PSCon.PSID				
	END

	BEGIN
		SET @v_rowCount = 0
		IF @DBBulkPS = 'Y'
			BEGIN
			Select Top 1 @processInstanceId = ProcessInstanceId, @workItemId = WorkItemId,@activityName=ActivityName,@activityId=ActivityId,@parentWorkItemId=ParentWorkItemId,@assignmentType= AssignmentType,@collectFlag= CollectFlag,@priorityLevel=PriorityLevel,@lockStatus= LockStatus ,@processVariantId=ProcessVariantId from WFINSTRUMENTTABLE WITH(NOLOCK) where ProcessDefId = @DBProcessDefId and ROUTINGSTATUS='Y' AND Q_UserId = @psId
			Select @v_rowCount = @@ROWCOUNT, @v_errorCode = @@ERROR
			
			IF @v_errorCode <> 0
			BEGIN
				SELECT 15, @csSessionId, @psId, @psName
				RAISERROR ('WFGetNextWorkItemForPS: Error while fetching the Workitem Locked by BulkPS from WFINSTRUMENTTABLE With Routing Status Y ', 16, 1)
				RETURN
			END
			IF @v_rowCount > 0 
			BEGIN
				SELECT 0, @csSessionId, @psId, @psName
				SELECT @processInstanceId ProcessInstanceId ,@workItemId WorkitemId,@activityName ActivityName,@activityId ActivityId,@parentWorkItemId ParentWorkitemId,@assignmentType AssignmentType,@collectFlag CollectFlag,@priorityLevel PriorityLevel,@lockStatus LockStatus,@processVariantId ProcessVariantId 
				RETURN
			END
		END
		BEGIN TRANSACTION WILOCK
		IF @v_rowCount <= 0
		BEGIN
			Set @v_rowCount = 0
			Select Top 1 @processInstanceId = ProcessInstanceId, @workItemId = WorkItemId,@activityName=ActivityName,@activityId=ActivityId,@parentWorkItemId=ParentWorkItemId,@assignmentType= AssignmentType,@collectFlag= CollectFlag,@priorityLevel=PriorityLevel,@lockStatus= LockStatus ,@processVariantId=ProcessVariantId from WFINSTRUMENTTABLE WITH (UPDLOCK,READPAST,INDEX (idx6_wfinstrumenttable)) where ProcessDefId = @DBProcessDefId AND LOCKSTATUS='N' and ROUTINGSTATUS='Y'
			Select @v_rowCount = @@ROWCOUNT, @v_errorCode = @@ERROR
			IF @v_errorCode <> 0
			BEGIN
				ROLLBACK TRANSACTION WILOCK
				SELECT 15, @csSessionId, @psId, @psName
				RAISERROR ('WFGetNextWorkItemForPS: Error while fetching the next Unlocked Workitem from WFInstrumentTable with Routingstatus Y and LockStatus N and Q_UserID null or 0', 16, 1)
				RETURN
			END
			IF @v_rowCount <= 0
			BEGIN
				IF @DBBulkPS = 'Y'
				BEGIN
					ROLLBACK TRANSACTION WILOCK
					SELECT 18, @csSessionId, @psId, @psName
					RETURN	
				END		
				ELSE
					BEGIN
						Select Top 1 @processInstanceId = ProcessInstanceId, @workItemId = WorkItemId,@activityName=ActivityName,@activityId=ActivityId,@parentWorkItemId=ParentWorkItemId,@assignmentType= AssignmentType,@collectFlag= CollectFlag,@priorityLevel=PriorityLevel,@lockStatus= LockStatus ,@processVariantId=ProcessVariantId from WFINSTRUMENTTABLE WITH(NOLOCK) where ProcessDefId = @DBProcessDefId and ROUTINGSTATUS='Y' AND LOCKSTATUS='Y' AND LockedTime < DATEADD(ss,-3,GETDATE()) AND Q_UserId = @psId
						Select @v_rowCount = @@ROWCOUNT, @v_errorCode = @@ERROR
						IF @v_errorCode <> 0
						BEGIN
							ROLLBACK TRANSACTION WILOCK
							SELECT 15, @csSessionId, @psId, @psName
							RAISERROR ('WFGetNextWorkItemForPS: Error while fetching the next Unlocked Workitem from WFInstrumentTable with Routingstatus Y and LockStatus Y and Q_UserID as the incoming PSId', 16, 1)
							RETURN
						END
						IF @v_rowCount > 0 
						BEGIN
							COMMIT TRANSACTION WILOCK
							SELECT 0, @csSessionId, @psId, @psName
							SELECT @processInstanceId ProcessInstanceId ,@workItemId WorkitemId,@activityName ActivityName,@activityId ActivityId,@parentWorkItemId ParentWorkitemId,@assignmentType AssignmentType,@collectFlag CollectFlag,@priorityLevel PriorityLevel,@lockStatus LockStatus,@processVariantId ProcessVariantId 
							RETURN
						END
						ELSE
						BEGIN
							ROLLBACK TRANSACTION WILOCK
							SELECT 18, @csSessionId, @psId, @psName
							RETURN	
						END	
					END
			END
			ELSE
			BEGIN
				Update WFINSTRUMENTTABLE SET WorkItemState=6,StateName='COMPLETED', LockStatus='Y' ,Q_UserId=@psId,LockedTime=getDate() WHERE ProcessInstanceId = @processInstanceId AND WorkItemId = @workItemId; 		
				IF @v_errorCode <> 0
				BEGIN
					ROLLBACK TRANSACTION WILOCK
					SELECT 15, @csSessionId, @psId, @psName
					RAISERROR ('WFGetNextWorkItemForPS: Error while Updating the status of fetched Workitem from WFInstrumentTable', 16, 1)
					RETURN
				END
				IF @v_rowCount > 0
				BEGIN
					COMMIT TRANSACTION WILOCK
					SELECT 0, @csSessionId, @psId, @psName
					SELECT @processInstanceId ProcessInstanceId ,@workItemId WorkitemId,@activityName ActivityName,@activityId ActivityId,@parentWorkItemId ParentWorkitemId,@assignmentType AssignmentType,@collectFlag CollectFlag,@priorityLevel PriorityLevel,@lockStatus LockStatus,  
					@processVariantId ProcessVariantId
					RETURN
				END
				ELSE
				BEGIN
					ROLLBACK TRANSACTION WILOCK
					SELECT 15, @csSessionId, @psId, @psName
					RAISERROR ('WFGetNextWorkItemForPS: Error due to RowCount returned while Updating the status of fetched Workitem from WFInstrumentTable', 16, 1)
					RETURN
				END
					
			END
		END
	END
END
		
~

Print 'Stored Procedure WFGetNextWorkItemForPS compiled successfully ........'