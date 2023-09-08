/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 6.0
	Module				: Transaction Server
	File Name			: WFEscalateWorkitem.sql [MSSQL Server]
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 17/08/2005
	Description			: To be scheduled on database server, this will 
					  move candidate records [escalation mail item] from
					  WFEscalationTable to WFMailQueueTable.
----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
25/08/2005		Ruhi Hira		Bug # WFS_6.1_029.
15/02/2007		Varun Bhansaly		Bugzilla Id 74 (Inconsistency in date-time)
24/05/2007		Ruhi Hira		Bugzilla Bug 945.
23/08/2012		Abhishek Gupta	Change for added columns zipFlag, zipName, maxZipSize, alternateMessage in WFMAILQUEUETABLE.
11/03/2013      Kahkeshan       Changes corresponding to mailBCC field added in WFMailQueueTable
01/05/2013      Kahkeshan       Bug 39079 - EscalateToWithTrigger Feature requirement
28/01/2014		Shweta Singhal	UPDLock replaced with UPDLock, READPAST
10-02-2014		Sajid Khan		Changes done for Mesage Agent Optimization.
27/05/2014      Kanika Manik    PRD Bug 42494 - BCC support at each email sending modules
10/08/2016		Ambuj Triapthi		Added changes for the task Escalation feature in Case Management
25/08/2017		Sajid Khan		PRDP Bug 69029 - Need to send escalation mail after every defined time
31/08/2016		Ambuj Triapthi		Added UT bug fixes for task Escalation feature in Case Management
14/09/2017      Kumar Kimil         Handling of Expired flag and Escalated flag	
26/09/2017      Ambuj Tripathi  UT Bug#72140 fixed
----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFEscalateWorkitem')
Begin
	Execute('DROP PROCEDURE WFEscalateWorkitem')
	Print 'Procedure WFEscalateWorkitem already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFEscalateWorkitem As
Begin

	Declare @escalateId		Int
	Declare @processDefId		Int
	Declare @activityId		Int
	Declare @activityName		NVarchar(30)
	Declare @processInstanceId	NVarchar(64)
	Declare @workitemId		Int
	Declare @ConcernedAuthInfo	NVarchar(2000)
	Declare @fieldName	NVARCHAR(2000)
	Declare @actionId		Int
	DECLARE @EscalationType NVARCHAR(1)
	DECLARE @ResendDurationMinutes INT
	Declare @taskId			Int
	Declare @taskName		NVarchar(30)
	Declare @isValidTask	Int
	DECLARE @v_MainCode INT

	/* Bug # Bug # WFS_6.1_029 , delete from WFEscInProcessTable in the beginning only - Ruhi Hira*/ 
	/*Delete From WFEscInProcessTable

	Insert Into WFEscInProcessTable
	Select * 
	From WFEscalationTable WITH (NOLOCK)
	Where	Upper(RTRIM(EscalationMode)) = N'MAIL'
	And	ScheduleTime <= getDate()*/

	Declare Escalate_cur CURSOR FAST_FORWARD FOR
		Select	escalationId, processDefid, activityId, processInstanceId, workitemId, ConcernedAuthInfo, EscalationType, ResendDurationMinutes, ISNULL(TaskId, 0)
		From WFEscalationTable WITH (NOLOCK) Where ScheduleTime <= getDate() AND	EscalationMode = N'MAIL'
	Open Escalate_Cur

	Fetch Next From Escalate_Cur Into 
		@escalateId, @processDefid, @activityId, @processInstanceId, @workitemId, @ConcernedAuthInfo,@EscalationType, @ResendDurationMinutes,@taskId
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF (@@FETCH_STATUS <> -2) 
		BEGIN
			/*Changes done for task expiry*/
			IF(@activityId < 0)
				BEGIN
					/*Check if this is valid escalation case, Bug#72140*/
					select @isValidTask = 0
					select @isValidTask=1 from wftaskstatustable (NOLOCK) where ProcessInstanceId = @processInstanceId and WorkitemId = @workitemId and ProcessDefId = @processDefid and ActivityId = -@activityId and TaskId = @taskId and TaskStatus in (2, 6)
					IF(@isValidTask = 0)
						BEGIN
						Fetch Next From Escalate_Cur Into 
							@escalateId, @processDefid, @activityId, @processInstanceId, @workitemId, @ConcernedAuthInfo,@EscalationType, 
							@ResendDurationMinutes, @taskId
						CONTINUE
						END
					ELSE
						BEGIN
					Select @activityId = -@activityId
					Select @actionId = 711
					Select @taskName = TaskName from Wftaskdeftable (NOLOCK) where ProcessDefId = @processDefid and TaskId = @taskId
					BEGIN
					UPDATE WFTaskStatusTable SET EscalatedFlag='Y' where processInstanceId=@processInstanceId and ProcessDefId = @processDefid and TaskId = @taskId and activityId=@activityId
				    END
						END
					/*Check if this is valid escalation case, Bug#72140 ends here*/
				END;
			ELSE
				BEGIN
					Select @actionId = 73
				END;
			/*Changes done for task expiry till here*/
			Select @activityName = activityName From ActivityTable (NOLOCK)
			Where	ProcessDefId = @processDefid
			And	ActivityId = @activityId
			Begin Transaction E_TRANS
				Insert Into WFMailQueueTable(mailFrom, mailTo,mailCC,mailBCC,mailSubject,mailMessage,mailContentType,attachmentISINDEX,attachmentNames,attachmentExts,mailPriority,mailStatus,statusComments,lockedBy,successTime,LastLockTime,insertedBy,mailActionType,insertedTime,processDefId,processInstanceId,workitemId,activityId,noOfTrials,zipFlag,zipName,maxZipSize,alternateMessage)
				Select FromId, ConcernedAuthInfo, CCId, BCCId, Comments,
					message, 'text/html', null, null,
					null, 1, N'N', null,
					null, null, null, 'SYSTEM',
					'ESCALATIONRULE', getDate(), processDefId, processInstanceId,
					workitemId, -activityId, 0 ,'N',null,0,'' /* Changes corresponding to mailBCC field added in WFMailQueueTable */
				From WFEscalationTable WITH (UPDLOCK,READPAST)
				WHERE EscalationId = @escalateId
				
				IF(@EscalationType = 'R' AND @ResendDurationMinutes IS NOT NULL AND @ResendDurationMinutes <> 0)
				BEGIN
					UPDATE WFEscalationTable SET ScheduleTime = DATEADD(mi, @ResendDurationMinutes, GETDATE()) WHERE EscalationId = @escalateId
				END
				ELSE
				BEGIN
					Delete From WFEscalationTable Where EscalationId = @escalateId
				END
				--Delete From WFEscalationTable Where EscalationId = @escalateId
				/* Changed By Varun Bhansaly On 15/02/2007 For Bugzilla Bug Id 74*/
				/*Insert Into WFMessageTable (message, status, ActionDateTime)
				values ('<Message><ActionId>73</ActionId><UserId>0</UserId><ProcessDefId>' + 
					convert(varchar, @processDefId) + '</ProcessDefId><ActivityId>' + 
					convert(varchar, @activityId) + 
					'</ActivityId><QueueId>0</QueueId><UserName>System</UserName><ActivityName>' +
					@activityName + '</ActivityName>' + 
					'<TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' + 
					convert(varchar(22), getDate(), 20) + 
					'</ActionDateTime><EngineName></EngineName><ProcessInstance>' + @processInstanceId + 
					'</ProcessInstance><FiledId>0</FiledId><FieldName><Mode>MAIL</Mode><ConcernedAuthInfo>' +
					@ConcernedAuthInfo + '</ConcernedAuthInfo></FieldName><WorkitemId>' + 
					convert(varchar, @workitemId) + 
					'</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay>' + 
					'<ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>',
					N'N', GETDATE()*/
					set @fieldName =   '<Mode>MAIL</Mode><ConcernedAuthInfo>' +
					@ConcernedAuthInfo + '</ConcernedAuthInfo>'
				EXECUTE WFGenerateLog @actionId, 0, @processDefId, @activityId, 0, 'SYSTEM', @activityName, 0, @processInstanceId, 0, @fieldName, @workitemId,  0, 0,  @taskName ,0, @taskId , null, null, null,@v_MainCode OUT
				

			Commit Transaction E_TRANS
		END
		Fetch Next From Escalate_Cur Into 
			@escalateId, @processDefid, @activityId, @processInstanceId, @workitemId, @ConcernedAuthInfo,@EscalationType, 
			@ResendDurationMinutes, @taskId
	END

	CLOSE Escalate_cur
	DEALLOCATE Escalate_cur

End