
/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: Ibps
	File Name					: GetHistoricalDataForAnalytics.sql 
	Author						: RishiRam Meel
	Date written (DD/MM/YYYY)	: 27/04/2016
	Description					: Stored Procedure to get historical data for analytics
	Assumption 					: User logging information should be capture in WFCURRENTROUTELOGTABLE table.
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))

____________________________________________________________________________________________________*/


Create  PROCEDURE GetHistoricalDataForAnalytics
(
@ProcessDefId   INT 
)
AS    
SET NOCOUNT ON    
BEGIN
    --- variable declaration at process level 
	Declare @ProcessName	NVARCHAR(50)
	Declare @WorkItemId	NVARCHAR(63)
	Declare @WorkitemIntroductionTime DATETIME
	Declare @WorkitemEndTime DATETIME
	Declare @ProcessingDuraion DATETIME
	---- variable declaration at activity level
	Declare @ActivityName  			NVARCHAR(30)
	Declare @ActivityEntryTime DATETIME
	Declare @ActivityExitTime DATETIME
	Declare @ActivityDuration DATETIME
	Declare @WorkerName      NVARCHAR (63)
	Declare @ActivityType  INT
	Declare @ActivityId	  INT 
	Declare @NextActivity NVARCHAR(30)
    Declare @PrevActivity NVARCHAR(30)
	--------------------------------------------------------------------------------------------------------------
	--procss specific loop--
	DECLARE CursorToGetProcessedWI CURSOR  FOR select ProcessName,ProcessInstanceId,IntroductionDATETIME,EntryDATETIME,(EntryDATETIME-IntroductionDATETIME) as ProcessingDuraion from WFINSTRUMENTTABLE where ProcessDefID=@ProcessDefID and  ProcessInstanceState in (4,5,6) 
	 
	OPEN CursorToGetProcessedWI
	FETCH NEXT FROM CursorToGetProcessedWI INTO @ProcessName,@WorkItemId,@WorkitemIntroductionTime,@WorkitemEndTime,@ProcessingDuraion
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--Activity specific loop--
		DECLARE crsrToGetDataAtActivity CURSOR  FOR  SELECT  A.ActivityName as ActivityName ,B.ActivityType as ActivityType,A.ActivityId  as   ActivityId
		  from (select distinct(ActivityName), ActivityId,ProcessDefId,MAX(ActionDatetime) as date from WFCURRENTROUTELOGTABLE
		   where processinstanceid=@WorkItemId and ActivityName is not null  group by ActivityName, ActivityId,ProcessDefId  ) A 
		   inner join (SELECT  ActivityId,ActivityType,ProcessDefId from 
		   ActivityTable where ProcessDefId=@ProcessDefId) B on  A.ProcessDefId=B.ProcessDefId and A.ActivityId=B.ActivityId  order by date
		  
		--------
		OPEN crsrToGetDataAtActivity 
		FETCH NEXT FROM crsrToGetDataAtActivity INTO @ActivityName, @ActivityType,@ActivityId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF (@ActivityType=1) 
			BEGIN 
				-- entry time for workintroduction step.ActionId 1=WFL_CreateProcessInstance=1
				select @ActivityEntryTime=ActionDatetime from WFCURRENTROUTELOGTABLE where ProcessInstanceId=@WorkItemId and ActionId=1 and ActivityName=
				@ActivityName
				
			END 
			ELSE 
			BEGIN 
			-- entry time for custom Workstep.ActionId 4=WFL_ProcessInstanceRouted = 4
				select @ActivityEntryTime=ActionDatetime from WFCURRENTROUTELOGTABLE where ProcessInstanceId=@WorkItemId and ActionId=4 and AssociatedFieldName=@ActivityName  
			END  
			-- Exit time for  Workstep.ActionId 4=WFL_ProcessInstanceRouted = 4
			select @ActivityExitTime=ActionDatetime from WFCURRENTROUTELOGTABLE where ProcessInstanceId=@WorkItemId and ActionId=4 and ActivityName=@ActivityName 
			
			--Activityduration 
			select @ActivityDuration=@ActivityExitTime-@ActivityEntryTime
						
		    -- Worker Name
		    select  Top 1 @WorkerName=UserName from WFCURRENTROUTELOGTABLE where ActivityId=@ActivityId and ProcessInstanceId=@WorkItemId  and UserName IS NOT NULL  and UserName not in ('')  order by ActionDatetime desc
					
			---next Activity 
			select @NextActivity=AssociatedFieldName from WFCURRENTROUTELOGTABLE where ProcessInstanceId=@WorkItemId and ActionId=4 and ActivityId=@ActivityId 
			
			---Prev Activity 
			IF (@ActivityType=1) 
			BEGIN 
			select @PrevActivity=@ActivityName
			END
			ELSE 
			BEGIN 
			
			select @PrevActivity=ActivityName from WFCURRENTROUTELOGTABLE where  ProcessInstanceId=@WorkItemId and ActionId=4 and AssociatedFieldName=@ActivityName 
			
			
			END 
			-- inserting data into WorkItemDataAtActivityLevel
		
			insert into WorkItemDataAtActivityLevel (ProcessDefId, ProcessName, WorkItemId, ActivityName,NextActivity,PrevActivity, ActivityEntryTime, ActivityExitTime,ActivityDuration,WorkerName) 
		    values(@ProcessDefId,@ProcessName,@WorkItemId,@ActivityName,@NextActivity,@PrevActivity, @ActivityEntryTime,@ActivityExitTime,@ActivityDuration,@WorkerName)
			
			-- fetch next record
			FETCH NEXT FROM crsrToGetDataAtActivity INTO @ActivityName, @ActivityType,@ActivityId
		
		END
		CLOSE 		crsrToGetDataAtActivity
	    DEALLOCATE 	crsrToGetDataAtActivity
		
		insert into WorkItemDataAtProcessLevel (ProcessDefId, ProcessName, WorkItemId, WorkitemIntroductionTime, WorkitemEndTime, ProcessingDuraion) 
		values(@ProcessDefId,@ProcessName,@WorkItemId, @WorkitemIntroductionTime,@WorkitemEndTime,@ProcessingDuraion)
		
		-- fetch next record
		FETCH NEXT FROM CursorToGetProcessedWI INTO @ProcessName,@WorkItemId,@WorkitemIntroductionTime,@WorkitemEndTime,@ProcessingDuraion
			
	END
	CLOSE 		CursorToGetProcessedWI
	DEALLOCATE 	CursorToGetProcessedWI
	
	RETURN
END