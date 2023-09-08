/*__________________________________________________________________________________________________________________-
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________-
	Group				: Application – Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFProcessMessageExt.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 02/08/2004
	Description			: This stored procedure is called from WFProcessNextMessage (WFIneternal.java).

______________________________________________________________________________________________________________________-
				CHANGE HISTORY
______________________________________________________________________________________________________________________-

Date			Change By		Change Description (Bug No. (If Any))
20/09/2004		Ruhi Hira		Queries rectified.
20/10/2004		Ruhi Hira		- Changes made for diversion.
						- Bug related to ActionId 8, (TotalWICount to be inserted should be 1).
25/10/2004		Harmeet			Bug related to Exception report generation, rectified (action Id 9).
28/10/2004		Ashish Mangla		AssociatedFieldName length increased
1/11/2004		Ruhi Hira		ActionId to be inserted should be 27 in case of 8 in SummaryTable.
1/11/2004		Ruhi Hira		- No need to insert into QueueHistoryTable in case of actionId 25.
						- AssociatedFieldId inserted in case of actionId 9 and 10.
09/11/2004		Krishan			DelayTime report bug for ProcessInstance rectified.
02/06/2005		Harmeet Kaur		Bug No WFS_6_013.
05/08/2005              Mandeep Kaur		SRNo-1(Bug Ref No WFS_5_047)
08/08/2005              Mandeep Kaur		SRNo-2(Bug Ref No WFS_5_053)
18/08/2005		Ruhi Hira		SrNo-3.
16/05/2006		Ashish Mangla		Support for Hourly Report
30/01/2007		Ruhi Hira		Bugzilla Id 460.
08/02/2007		Varun Bhansaly		Bugzilla Id 74 (Inconsistency in date-time)
15/03/2007		Ashish Mangla		Processing time should be added in summrytable / new table WFActivitytyReportTable when WI completes 
						- Till that time keep the processing time spent by a user in a separate table 
							that to be deleted when the WI completes
23/05/2007		Ruhi Hira		Bugzilla Bug 918, No more managed connection.
24/05/2007		Ruhi Hira		Bugzilla Bug 945.
29/01/2008		Varun Bhansaly	Bugzilla Id 74
17/05/2013		Shweta Singhal	Process Variant Support Changes
19/06/2013		Sajid Khan		Bug 39903 - Summary table queries and indexes to be modified 
23/12/2013		Sajid Khan		Message Agent Optimizaion.
03-05-2014		Sajid Khan		Bug 44499 - INT to BIGINT changes for Audit Tables.
10/08/2015		Anwar Danish	PRD Bug 51267 merged - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.
10/03/2017                 Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.
12/08/2020		Ashutosh Pandey	Bug 94054 - Optimization in Message Agent
______________________________________________________________________________________________________________________-
____________________________________________________________________________________________________________________-*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFProcessMessageExt')
Begin
	Execute('DROP PROCEDURE WFProcessMessageExt')
	Print 'Procedure WFProcessMessageExt already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFProcessMessageExt( 
	@DBActionId		SMALLINT,     
	@DBUserId		INT, 
	@DBProcessDefId		INT,    
	@DBActivityId		INT,    
	@DBQueueId		INT,    
	@DBUserName		NVARCHAR(63), 
	@DBActivityName		NVARCHAR(30), 
	@DBSummaryActId		INT,
	@DBSummaryActName	NVARCHAR(30), 
	@DBTotalWiCount		INT,    
	@DBTotalDuration	INT,    
	@DBProcessInstance	NVARCHAR(65),     
	@DBFieldId		INT,     
	@DBFlag			INT,    
	@DBWorkitemId		INT,    
	@DBTotalPrTime		INT,    
	@DBFieldName		NVARCHAR(2000), 
	@DBNewValue		NVARCHAR(2000), 
	@DBActionDateTime	NVARCHAR(50),      
	@DBAssociatedDateTime	NVARCHAR(50),      
	@DBDelayTime		INT,    
	@DBWKInDelay		INT,    
	@DBReportType		NVARCHAR(1),    
	@msgId			BigInt,    
	@UtilId			NVARCHAR(65), 
	@deleteFlag		INT	,	/* 1 record to be deleted from wfmessageTable , 2 not to be deleted	*/
						/* placed for case setAttribute(more than one in single message)	*/
	@ProcessVariantId	INT					/*Process Variant Support Changes*/
)    
AS    
SET NOCOUNT ON    
BEGIN 
	Declare @QuoteChar		CHAR
	DECLARE @TotPrTimeTillNow	INT 
	DECLARE @TotPrTimeActivity	INT 
	DECLARE @rst			INT    

	declare @fieldIdValue	NVARCHAR(50)
	declare @wherestr NVARCHAR(150)
	declare @vDBActivityId int
	declare @vDBUserId int
	declare @vDBQueueId int
	declare @vActionDateTimeStart	NVARCHAR(50)
	declare @vActionDateTimeEnd	NVARCHAR(50)      	
	


	SET @vDBActivityId = @DBSummaryActId
	SET @vDBUserId = @DBUserId
	SET @vDBQueueId = @DBQueueId
	SET @wherestr = null
	SET @fieldIdValue = null

	select  @rst = 0 
	SELECT	@QuoteChar = char(39)


      /* @DBFlag = 1 entry Only in currentroutelogtable
	 @DBFlag = 2 entry only in summaryTable
	 @DBFlag = 3 entry in both currentRouteLogTable and SummaryTable
	*/
--	 IF (@deleteFlag = 1) 
--	 BEGIN
		Begin Transaction PROCESS	/*Otherwise transaction has been opened in API itself e.g. setAttribute...*/
--	 END

	/* SrNo-3, Omniflow 6.0 Feature : Escalation - Ruhi Hira */
	

	/*IF (@DBFlag = 1 OR @DBFlag = 3)	For insertion in currentRouteLogTable
	BEGIN
		Insert into WFCurrentRouteLogTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, 
			ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, 
			UserName, NewValue, QueueId, ProcessVariantId) 
		values (@DBProcessDefId, @DBActivityId, @DBProcessInstance, @DBWorkitemId, @DBUserId, 
			@DBActionId, @DBActionDateTime, @DBAssociatedDateTime, @DBFieldId, @DBFieldName, @DBActivityName, 
			@DBUserName, @DBNewValue, @DBQueueId, @ProcessVariantId)
		
		IF(@@rowcount <= 0)  
		BEGIN 
			ROLLBACK TRANSACTION PROCESS 
		/* SRNo-1 Insert on MessageTable taking time   -By Mandeep Kaur */
		/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
			BEGIN TRANSACTION FAILED 
				Insert Into WFFailedMessageTable(MessageId,Message,lockedBy,status,failuretime,actiondatetime)  
					Select messageId, message, null, 'F', getDate(), ActionDateTime 
					From WFMessageTable WITH(NOLOCK)  
					Where MessageId = @msgid 
				Delete From WFMessageTable Where MessageId = @msgid 
			COMMIT TRANSACTION FAILED 
			SELECT 0, 'Insert Failed 1.' 
			RETURN 
		END 
	END*/
	
	If(@DBActionId = 20 OR @DBActionId = 3 ) 
	Begin 
		update wfaudittraildoctable set status = 'R' 
		Where processInstanceId = coalesce(@DBProcessInstance, '') 
		AND workitemId = coalesce(@DBWorkitemId, 0) 
	End
		
	IF (@DBFlag = 2 OR @DBFlag = 3)	/*For insertion in SummaryTable*/
	BEGIN    
		IF(@DBActionId  = 8)    /* Total WI count should not be increased for processing time addition in SummaryTable */
		BEGIN    
			UPDATE WFReportDataTable SET 
				totalprocessingtime = totalprocessingtime + @DBTotalPrTime 
			WHERE processInstanceId = @DBProcessInstance 
				AND workitemId = @DBWorkitemId 
				AND processdefid =  @DBProcessDefId 
				AND activityid = @DBSummaryActId 
				AND Userid = @DBUserId 

			IF @@ROWCOUNT = 0 
			BEGIN 
				INSERT INTO WFReportDataTable 
					(processInstanceId, workitemId, processdefid, activityid, userid, totalprocessingtime, processvariantid) 
				VALUES 
					(@DBProcessInstance, @DBWorkitemId, @DBProcessDefId, @DBSummaryActId, @DBUserId, @DBTotalPrTime, @ProcessVariantId) /*Process Variant Support Changes*/
				IF(@@rowcount <= 0) 
				BEGIN 
					ROLLBACK TRANSACTION PROCESS 
					BEGIN TRANSACTION FAILED 
						Insert Into WFFailedMessageTable(MessageId,Message,lockedBy,status,failuretime,actiondatetime) 
							Select messageId, message, null, 'F', getDate(), ActionDateTime 
							From WFMessageTable WITH(NOLOCK)  
							Where MessageId = @msgid 
						Delete From WFMessageTable Where MessageId = @msgid 
					COMMIT TRANSACTION FAILED 
					SELECT 0, 'Insert Failed 5.' 
					RETURN 
				END 
			END 
		END    
		ELSE
		BEGIN
			IF(@DBActionId  = 2 OR  @DBActionId  = 27) 
			BEGIN 
				SELECT	@TotPrTimeTillNow = TotalProcessingTime 
				FROM	WFReportDataTable WITH (NOLOCK)
				WHERE	processInstanceId = @DBProcessInstance 
				AND	workitemId = @DBWorkitemId 
				AND	processdefid =  @DBProcessDefId 
				AND	activityid = @DBSummaryActId 
				AND	Userid = @DBUserId 
				AND processvariantId = @ProcessVariantId/*Process Variant Support Changes*/
				
				If(@@ERROR > 0 OR @@ROWCOUNT <= 0) 
				Begin 
					SELECT @TotPrTimeTillNow =  0 
				End 

				SELECT	@TotPrTimeActivity = coalesce(SUM(TotalProcessingTime), 0) 
				FROM	WFReportDataTable WITH (NOLOCK)
				WHERE	processInstanceId = @DBProcessInstance 
					AND processdefid =  @DBProcessDefId 
					AND activityid = @DBSummaryActId
					AND processvariantId = @ProcessVariantId/*Process Variant Support Changes*/
						/* WorkItemId Check intentionally left for refer case*/ 

				SELECT	@TotPrTimeActivity = @DBTotalPrTime + @TotPrTimeActivity 
				Select @DBTotalPrTime = @DBTotalPrTime + @TotPrTimeTillNow 
			END 

			IF(@DBActionId = 2 OR @DBActionId = 27 OR @DBActionId = 3 OR @DBActionId = 5 OR @DBActionId = 28 OR @DBActionId = 45) 
			BEGIN 
				DELETE FROM WFReportDataTable  
				WHERE processInstanceId = @DBProcessInstance 
					AND processdefid =  @DBProcessDefId 
					AND activityid = @DBSummaryActId 
					AND processvariantId = @ProcessVariantId/* WorkItemId Check intentionally left for refer case*/ /*Process Variant Support Changes*/
			END 

			IF @DBDelayTime > 0     
			BEGIN    
				select @DBWKInDelay = 1    
			END    
			ELSE    
			BEGIN     
				select @DBWKInDelay = 0    
				select @DBDelayTime = 0 
			END     

			IF(@DBActionId = 1 OR @DBActionId = 2 OR @DBActionId = 27)
			BEGIN
				set @wherestr = 'and activityId = ' + convert(varchar(10), @vDBActivityId) + ' and userid = ' +  convert(varchar(10), @vDBUserId) + ' and queueid = ' + convert(varchar(10), @vDBQueueId)
			END

			IF(@DBActionId = 3 OR @DBActionId = 5 OR @DBActionId = 20)
			BEGIN
				set @wherestr = null
				set @vDBActivityId = 0
				set @vDBUserId = 0
				set @vDBQueueId = 0
			END

			IF(@DBActionId = 4 OR @DBActionId = 6)
			BEGIN
				set @wherestr = 'and activityId = ' + convert(varchar(10), @vDBActivityId) + ' and queueid = ' + convert(varchar(10), @vDBQueueId)
				set @vDBUserId = 0
			END

			IF(@DBActionId = 9 OR @DBActionId = 10)
			BEGIN
				SET @fieldIdValue = @DBFieldId
				set @wherestr = 'and activityId = ' + convert(varchar(10), @vDBActivityId) + ' and AssociatedFieldId = ' + convert(varchar(10), @DBFieldId)
				set @vDBUserId = 0
				set @vDBQueueId = 0
			END

			IF(@DBActionId = 28)
			BEGIN
				set @wherestr = 'and activityId = ' + convert(varchar(10), @vDBActivityId)
				set @vDBUserId = 0
				set @vDBQueueId = 0
			END

			IF(@DBActionId = 45)
			BEGIN
				set @wherestr = 'and activityId = ' + convert(varchar(10), @vDBActivityId) + ' and userid = ' + convert(varchar(10), @vDBUserId)
				set @vDBQueueId = 0
			END

			set @vActionDateTimeStart = convert(varchar(13), coalesce(@DBActionDateTime, getdate()), 20) + ':00:00.000'
			--set @vActionDateTimeEnd  = convert(varchar(13), coalesce(@DBActionDateTime, getdate()), 20) + ':59:59.999'

	/*	EXECUTE('UPDATE summarytable set' +
				' totalwicount = totalwicount + 1 ' +
				', totalduration = totalduration + ' + @DBTotalDuration +
				', totalprocessingtime = totalprocessingtime + ' + @DBTotalPrTime +
				', delaytime = delaytime + ' + @DBDelayTime +
				', wkindelay = wkindelay + ' + @DBWKInDelay +
				' where processdefid = ' + @DBProcessDefId +
				' and actionid = ' + @DBActionId +
				' and ActionDateTime between ''' + @vActionDateTimeStart +
				''' and ''' + @vActionDateTimeEnd + ''' ' +
				@wherestr)*/
		/* Bug 39903 - Summary table queries and indexes to be modified */		
	  EXECUTE('UPDATE summarytable set' +
				' totalwicount = totalwicount + 1 ' +
				', totalduration = totalduration + ' + @DBTotalDuration +
				', totalprocessingtime = totalprocessingtime + ' + @DBTotalPrTime +
				', delaytime = delaytime + ' + @DBDelayTime +
				', wkindelay = wkindelay + ' + @DBWKInDelay +
				' where processdefid = ' + @DBProcessDefId +
				' and actionid = ' + @DBActionId +
				' and ActionDateTime = ''' + @vActionDateTimeStart + ''' ' +     /*Bug 41357 */
				@wherestr +
				' and processvariantid = '+@ProcessVariantId)/*Process Variant Support Changes*/
				
			IF @@ROWCOUNT =0
			BEGIN 
				INSERT INTO summarytable (processdefid, activityid, queueid, userid, actionid,
						actiondatetime, activityname, username, totalwicount,
						totalduration, totalprocessingtime, delaytime,
						wkindelay, reporttype, AssociatedFieldId, ProcessVariantId) 
				VALUES (@DBProcessDefId, @vDBActivityId, @vDBQueueId, @vDBUserId, @DBActionId,
					@vActionDateTimeStart, @DBSummaryActName, @DBUserName, 1, 
					@DBTotalDuration, @DBTotalPrTime, @DBDelayTime, 
					@DBWKInDelay, @DBReportType, @fieldIdValue, @ProcessVariantId)/*Process Variant Support Changes*/
				IF(@@rowcount <= 0) 
				BEGIN 
					ROLLBACK TRANSACTION PROCESS 
						/* SRNo-1  Insert on MessageTable taking time   -By Mandeep Kaur */ 
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					BEGIN TRANSACTION FAILED 
						Insert Into WFFailedMessageTable(MessageId,Message,lockedBy,status,failuretime,actiondatetime)  
							Select messageId, message, null, 'F', getDate(), ActionDateTime 
							From WFMessageTable WITH(NOLOCK)  
							Where MessageId = @msgid 
						Delete From WFMessageTable Where MessageId = @msgid 
					COMMIT TRANSACTION FAILED 
					SELECT 0, 'Insert Failed 4.' 
					RETURN 
				END 
			END 

			IF(@DBActionId  = 27 OR  @DBActionId  = 2 )    
			BEGIN    
				UPDATE WFActivityReportTable 
				SET 
					totalwicount = totalwicount + 1, 
					totalduration = totalduration + @DBTotalDuration, 
					totalprocessingtime = totalprocessingtime + @TotPrTimeActivity 
				WHERE 
					processdefid = @DBProcessDefId 
					AND activityid = @DBSummaryActId 
					and convert(varchar(13), ActionDateTime,20) =  
					convert(varchar(13), coalesce(@DBActionDateTime, getdate()), 20) 

				IF @@ROWCOUNT = 0 
				BEGIN 
					INSERT into WFActivityReportTable 
						(processdefid, activityid, activityname, actiondatetime,  
						totalwicount, totalduration, totalprocessingtime) 
					VALUES 
						(@DBProcessDefId, @DBSummaryActId, @DBSummaryActName, @DBActionDateTime, 
						1, @DBTotalDuration, @TotPrTimeActivity) 
					IF(@@rowcount <= 0) 
					BEGIN 
						ROLLBACK TRANSACTION PROCESS 
							/* SRNo-1  Insert on MessageTable taking time   -By Mandeep Kaur */ 
						BEGIN TRANSACTION FAILED 
							Insert Into WFFailedMessageTable(MessageId,Message,lockedBy,status,failuretime,actiondatetime)  
								Select messageId, message, null, 'F', getDate(), ActionDateTime 
								From WFMessageTable WITH(NOLOCK)  
								Where MessageId = @msgid 
							Delete From WFMessageTable Where MessageId = @msgid 
						COMMIT TRANSACTION FAILED 
						SELECT 0, 'Insert Failed 4.' 
						RETURN 
					END 
				END 
			END     
		END
	END

	if(@deleteFlag = 1) 
	begin 
	/* SRN0-1  Insert on MessageTable taking time   -By Mandeep Kaur */
		Delete From WFMessageTable Where messageId = @msgId  
		select @rst = @@rowcount 
	end 
	else 
		select @rst = 1 
						
	Commit Transaction PROCESS    
	select rst = @rst, 'SUCCESS'     
END 

~

Print 'Stored Procedure WFProcessMessageExt compiled successfully ........' 
