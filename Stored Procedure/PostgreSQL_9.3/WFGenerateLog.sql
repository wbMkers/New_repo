/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: iBPS
	Module				: Transaction Server
	File Name			: WFGenerateLog.sql
	Author				: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 22th July,2019
	Description			: 
		
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))

------------------------------------------------------------------------------------------------------
23/07/2019		Ravi Ranjan Kumar Bug 85705 - Write SP for fetching next item for utilities
29/01/2020	Ravi Ranjan Kumar	Bug 90317 - Revoke functionality not working on task.

05/06/2023		shubham srivastava Bug 127756 - Three column has been added in WFCurrentRouteLogTable, ProcessingTime ,TAT & DelayTime .
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION WFGenerateLog ( 
	v_ActionId INT,
	v_UserId INT,
	v_ProcessDefId INT,
	v_ActivityId INT,
	v_QueueId INT,
	v_UserName VARCHAR(100),
	v_ActivityName VARCHAR(100),
	v_TotalDuration INT,
	v_ProcessInstanceId VARCHAR(100),
	v_FieldId BIGINT,
	v_FieldName VARCHAR(4000),
	v_WorkItemId INT,
	v_TotalPrTime INT,
	v_DelayTime INT,
	v_NewValue VARCHAR(2000) ,
	V_ProcessVariantId INT , 
	v_TaskId INT , 
	v_subTaskId INT,
	v_URN VARCHAR(63),
	v_AssociatedDateTime VARCHAR(100)
) RETURNS INT AS $$
DECLARE
	v_MainCode INT;
	v_PrTimeTillNow INT;
	v_TotPrTime INT;
	
BEGIN
	v_MainCode:=0;
	IF(v_ActionId IS NOT NULL AND v_ActionId > 0) THEN
		IF((v_ActionId = 1 OR v_ActionId = 2 OR v_ActionId = 3 OR v_ActionId = 4 OR v_ActionId = 5 OR v_ActionId = 6 OR v_ActionId = 8 OR v_ActionId = 9 OR v_ActionId = 10 OR v_ActionId = 20 OR v_ActionId = 27 OR v_ActionId = 28 OR v_ActionId = 45 OR v_ActionId = 112) AND v_UserId < 10000000) THEN
		
		IF (v_ActionId =8) THEN
		BEGIN
		SELECT ProcessingTime INTO v_PrTimeTillNow FROM WFINSTRUMENTTABLE  WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
		IF (v_PrTimeTillNow is null) THEN
					BEGIN
					v_PrTimeTillNow := 0;
					END;
					END IF;
			v_PrTimeTillNow := v_PrTimeTillNow + v_TotalPrTime;
			UPDATE WFINSTRUMENTTABLE SET ProcessingTime = v_PrTimeTillNow WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
			END;
		END if;
		
		
			
			IF(v_ActionId  = 2 OR  v_ActionId  = 27 OR  v_ActionId  = 28 OR  v_ActionId  = 45) THEN 
			SELECT ProcessingTime INTO v_TotPrTime FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
		END if;
		
			INSERT INTO WFMessageTable (Message, Status, ActionDateTime) VALUES('<Message><ActionId>' || CAST(v_ActionId AS VARCHAR) || '</ActionId><UserId>' || CAST(COALESCE(v_UserId, 0) AS VARCHAR) || '</UserId><ProcessDefId>' || CAST(COALESCE(v_ProcessDefId, 0) AS VARCHAR ) || '</ProcessDefId><ActivityId>' || CAST(COALESCE(v_ActivityId, 0) AS VARCHAR) ||	'</ActivityId><QueueId>'|| CAST(COALESCE(v_QueueId, 0) AS VARCHAR) || '</QueueId><UserName>' || COALESCE(v_UserName, '') ||	'</UserName><ActivityName>' || COALESCE(v_ActivityName, '') || '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' || CAST(COALESCE(v_TotalDuration, 0) AS VARCHAR) ||'</TotalDuration><ActionDateTime>' || CAST(CURRENT_TIMESTAMP AS VARCHAR(22)) || '</ActionDateTime><ProcessInstance>' || COALESCE(v_ProcessInstanceId, '') || '</ProcessInstance><FieldId>' || CAST(COALESCE(v_FieldId, 0) AS VARCHAR) || '</FieldId><FieldName>' || COALESCE(v_FieldName, '') || '</FieldName><WorkitemId>' || CAST(COALESCE(v_WorkItemId, 0) AS VARCHAR) || '</WorkitemId><TotalPrTime>' || CAST(COALESCE(v_TotPrTime, 0) AS VARCHAR) || '</TotalPrTime><DelayTime>' || CAST(COALESCE(v_DelayTime, 0) AS VARCHAR) || '</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', N'N', CURRENT_TIMESTAMP);
		END IF;

		Insert into WFCurrentRouteLogTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName, NewValue, QueueId ,  ProcessVariantId, TaskId , SubTaskId , URN , ProcessingTime, TAT, DelayTime) values(v_ProcessDefId,v_ActivityId,v_ProcessInstanceId,v_WorkItemId,v_UserId,v_ActionId,CURRENT_TIMESTAMP,to_date(v_AssociatedDateTime,'YYYY-MM-DD HH24:MI:SS'),v_FieldId,v_FieldName, v_ActivityName,v_UserName,v_NewValue,v_QueueId , V_ProcessVariantId , v_TaskId , v_subTaskId, v_URN, v_TotPrTime, v_TotalDuration, v_DelayTime);
	END IF;
	RETURN v_MainCode;
END;
$$ LANGUAGE plpgsql;
			