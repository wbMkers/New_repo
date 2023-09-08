
/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: Ibps
	File Name					: GetHistoricalDataForAnalytics.sql 
	Author						: RishiRam Meel
	Date written (DD/MM/YYYY)	: 04/04/2017 
	Description					: Stored Procedure to get historical data for analytics
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))

____________________________________________________________________________________________________*/

create or replace
FUNCTION GetHistoricalDataForAnalytics
(
V_Processid   INTEGER 
) RETURNS void
AS $$
DECLARE
    --- variable declaration at process level 
	V_ProcessName	VARCHAR(50);
	V_WorkItemId	VARCHAR(63);
	V_WorkitemIntroductionTime TIMESTAMP;
	V_WorkitemEndTime TIMESTAMP;
	---- variable declaration at activity level
	V_ActivityName  			VARCHAR(30);
	V_ActivityEntryTime TIMESTAMP;
	V_ActivityExitTime TIMESTAMP;
	V_WorkerName      VARCHAR (63);
	V_ActivityType  INTEGER;
	V_ActivityId	  INTEGER;
	V_NextActivity VARCHAR(30);
    V_PrevActivity VARCHAR(30);
	v_quoteChar 		CHAR(1); 
	V_CursorToGetProcessedWI			REFCURSOR;
	V_crsrToGetDataAtActivity			REFCURSOR;
	v_QueryStr1		VARCHAR(8000);
	v_QueryStr2		VARCHAR(8000);
BEGIN
	--------------------------------------------------------------------------------------------------------------
	--procss specific loop--
	v_quoteChar := CHR(39);  
	v_QueryStr1='select ProcessName,ProcessInstanceId,IntroductionDATETime,EntryDATETime from WFINSTRUMENTTABLE where ProcessDefID='|| V_Processid||' and  ProcessInstanceState in (4,5,6)';
	OPEN V_CursorToGetProcessedWI FOR EXECUTE v_QueryStr1;
	LOOP
	    -- fetch next record
		FETCH  V_CursorToGetProcessedWI INTO V_ProcessName,V_WorkItemId,V_WorkitemIntroductionTime,V_WorkitemEndTime;
		IF (NOT FOUND) THEN
            EXIT;
        END IF;
		--Activity specific loop--
		v_QueryStr2='SELECT  A.ActivityName as ActivityName ,B.ActivityType as ActivityType,A.ActivityId  as   ActivityId
		  from (select distinct(ActivityName), ActivityId,ProcessDefId,MAX(ActionDATETime) as date1 from WFCURRENTROUTELOGTABLE
		   where processinstanceid='|| v_quoteChar  ||V_WorkItemId || v_quoteChar || ' and ActivityName is not null  group by ActivityName, ActivityId,ProcessDefId  ) A 
		   inner join (SELECT  ActivityId,ActivityType,ProcessDefId from 
		   ActivityTable where ProcessDefId='|| V_Processid ||') B on  A.ProcessDefId=B.ProcessDefId and A.ActivityId=B.ActivityId  order by date1';
		 
		OPEN V_crsrToGetDataAtActivity  FOR EXECUTE v_QueryStr2;
		
			LOOP
			-- fetch next record
			FETCH  V_crsrToGetDataAtActivity INTO V_ActivityName, V_ActivityType, V_ActivityId;
				IF (NOT FOUND) THEN
						EXIT;
				END IF;
		
				IF (V_ActivityType=1) THEN
				BEGIN 
					-- entry time for workintroduction step.ActionId 1=WFL_CreateProcessInstance=1
					select ActionDatetime INTO V_ActivityEntryTime from WFCURRENTROUTELOGTABLE where ProcessInstanceId = V_WorkItemId and ActionId = 1 and ActivityName = 
					V_ActivityName;
					
				END ;
				ELSE 
				BEGIN 
				-- entry time for custom Workstep.ActionId 4=WFL_ProcessInstanceRouted = 4
					select ActionDatetime INTO V_ActivityEntryTime from WFCURRENTROUTELOGTABLE where ProcessInstanceId=V_WorkItemId and ActionId=4 and AssociatedFieldName=V_ActivityName; 
				END;
				END IF;
				-- Exit time for  Workstep.ActionId 4=WFL_ProcessInstanceRouted = 4
				select ActionDatetime INTO V_ActivityExitTime from WFCURRENTROUTELOGTABLE where ProcessInstanceId=V_WorkItemId and ActionId=4 and ActivityName=V_ActivityName; 
							
				-- Worker Name
				select   UserName INTO V_WorkerName from WFCURRENTROUTELOGTABLE where ActivityId=V_ActivityId and ProcessInstanceId=V_WorkItemId  and UserName IS NOT NULL  and UserName not in ('')  order by ActionDatetime desc limit 1;
						
				---next Activity 
				select AssociatedFieldName INTO V_NextActivity from WFCURRENTROUTELOGTABLE where ProcessInstanceId=V_WorkItemId and ActionId=4 and ActivityId=V_ActivityId ;
				
				---Prev Activity 
				IF (V_ActivityType=1) THEN
				BEGIN 
				V_PrevActivity := V_ActivityName;
				END;
				ELSE 
				BEGIN 
				select ActivityName INTO V_PrevActivity from WFCURRENTROUTELOGTABLE where  ProcessInstanceId=V_WorkItemId and ActionId=4 and AssociatedFieldName=V_ActivityName;
				END;
				END IF;
				-- inserting data into WorkItemDataAtActivityLevel
			
				insert into WorkItemDataAtActivityLevel (ProcessDefId, ProcessName, WorkItemId, ActivityName,NextActivity,PrevActivity, ActivityEntryTime, ActivityExitTime,WorkerName) 
				values(V_Processid,V_ProcessName,V_WorkItemId,V_ActivityName,V_NextActivity,V_PrevActivity, V_ActivityEntryTime,V_ActivityExitTime,V_WorkerName);
				
			END LOOP;
			CLOSE 		V_crsrToGetDataAtActivity;
		insert into WorkItemDataAtProcessLevel (ProcessDefId, ProcessName, WorkItemId, WorkitemIntroductionTime, WorkitemEndTime) 
		values(V_Processid,V_ProcessName,V_WorkItemId, V_WorkitemIntroductionTime,V_WorkitemEndTime);
		
	END LOOP;
	CLOSE 		V_CursorToGetProcessedWI;	
END;
$$LANGUAGE plpgsql;
