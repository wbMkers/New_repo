
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


Create  PROCEDURE GetActivityPath
(
@ProcessDefId   INT 
)
AS    
SET NOCOUNT ON    
BEGIN
    --- variable declaration at process level 
	Declare @WorkItemId	NVARCHAR(63)
	---- variable declaration at activity level
	Declare @ActivityName  			NVARCHAR(30)
	Declare @ActivityType  INT
	Declare @ActivityId	  INT 
	Declare @WIActivityPath  NVARCHAR(1000)  NULL
	--------------------------------------------------------------------------------------------------------------
	--procss specific loop--
	DECLARE CursorToGetProcessedWI CURSOR  FOR select ProcessInstanceId from WFINSTRUMENTTABLE where ProcessDefID=@ProcessDefID and  ProcessInstanceState in (4,5,6) 
	 
	OPEN CursorToGetProcessedWI
	FETCH NEXT FROM CursorToGetProcessedWI INTO @WorkItemId
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
			select @WIActivityPath=@ActivityName
			END
			ELSE 
			BEGIN 
			select @WIActivityPath=@WIActivityPath + ',' + @ActivityName
			END 
			-- fetch next record
			FETCH NEXT FROM crsrToGetDataAtActivity INTO @ActivityName, @ActivityType,@ActivityId
		
		END
		CLOSE 		crsrToGetDataAtActivity
	    DEALLOCATE 	crsrToGetDataAtActivity
		
		insert into ActivityPath (WorkItemId, WIActivityPath) 
		values(@WorkItemId, @WIActivityPath)
		
		-- fetch next record
		FETCH NEXT FROM CursorToGetProcessedWI INTO @WorkItemId
			
	END
	CLOSE 		CursorToGetProcessedWI
	DEALLOCATE 	CursorToGetProcessedWI
	
	RETURN
END