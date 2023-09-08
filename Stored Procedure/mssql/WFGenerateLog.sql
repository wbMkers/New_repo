/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 9.0
	Module				: Transaction Server
	File Name			: WFGenerateLog.sql
	Author				: Sweta Bansal
	Date written (DD/MM/YYYY)	: Aug 27th 2014
	Description			: Purpose of this stored procedure is to perform auditing(i.e. to prepare logging message based on the cabinet and then insert the same into WFMessageTable which will be further processed by Message agent to generate the history).
						  Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
		
	Purpose of the script is as follows : 
		1. Prepare the logging message based on the cabinet(i.e. if WFCurrentRouteLogTable is present in the cabinet then message prepared will be diferent than that when CurrentRouteLogTable will be present in the cabinet).
		2. And then insert the message into WFMessageTable which can be processed by Message agent so that proper auditing can be performed.
		
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))

------------------------------------------------------------------------------------------------------
27/08/2014		Sweta Bansal	Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
23/07/2019		Ravi Ranjan Kumar Bug 85705 - Write SP for fetching next item for utilities
----------------------------------------------------------------------------------------------------*/

IF EXISTS(SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFGenerateLog')
BEGIN
	DROP PROCEDURE WFGenerateLog
	Print 'Procedure WFGenerateLog already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE WFGenerateLog 
( 
@v_ActionId INT, 
@v_UserId INT, 
@v_ProcessDefId INT, 
@v_ActivityId INT, 
@v_QueueId INT, 
@v_UserName NVARCHAR(100), 
@v_ActivityName NVARCHAR(100), 
@v_TotalDuration INT, 
@v_ProcessInstanceId NVARCHAR(100), 
@v_FieldId INT, 
@v_FieldName NVARCHAR(4000), 
@v_WorkItemId INT, 
@v_TotalPrTime INT, 
@v_DelayTime INT, 
@v_NewValue NVARCHAR(2000), 
@v_ProcessVariantId INT, 
@v_TaskId INT, 
@v_subTaskId INT, 
@v_URN NVARCHAR(63),
@v_AssociatedDateTime NVARCHAR(500),
@v_MainCode INT OUT 
) 
AS 
BEGIN 
DECLARE @PrTimeTillNow INT
DECLARE @TotPrTime INT

	SELECT @v_MainCode = 0 
	IF(@v_ActionId IS NOT NULL AND @v_ActionId > 0) 
	BEGIN 
		IF(@v_ActionId = 1 OR @v_ActionId = 2 OR @v_ActionId = 3 OR @v_ActionId = 4 OR @v_ActionId = 5 OR @v_ActionId = 6 OR @v_ActionId = 8 OR @v_ActionId = 9 OR @v_ActionId = 10 OR @v_ActionId = 20 OR @v_ActionId = 27 OR @v_ActionId = 28 OR @v_ActionId = 45 OR @v_ActionId = 112) 
		
		IF(@V_ActionId = 8)
		BEGIN
			SELECT @PrTimeTillNow = ISNULL(ProcessingTime, 0) FROM WFINSTRUMENTTABLE WITH(NOLOCK) WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
			SELECT @PrTimeTillNow = @PrTimeTillNow + @v_TotalPrTime
			UPDATE WFINSTRUMENTTABLE SET ProcessingTime = @PrTimeTillNow WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
		END
	
		IF(@v_ActionId  = 2 OR  @v_ActionId  = 27 OR  @v_ActionId  = 28 OR  @v_ActionId  = 45)
		BEGIN 
			SELECT @TotPrTime = ISNULL(ProcessingTime, 0) FROM WFINSTRUMENTTABLE WITH(NOLOCK) WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
		END
			
		BEGIN 
			INSERT INTO WFMessageTable (Message, Status, ActionDateTime) VALUES('<Message><ActionId>' + CONVERT(VARCHAR, @v_ActionId) + '</ActionId><UserId>' + CONVERT(VARCHAR, COALESCE(@v_UserId, '')) + '</UserId><ProcessDefId>' + CONVERT(VARCHAR, COALESCE(@v_ProcessDefId, '')) + '</ProcessDefId><ActivityId>' + CONVERT(VARCHAR, COALESCE(@v_ActivityId, '')) +	'</ActivityId><QueueId>'+ CONVERT(VARCHAR, COALESCE(@v_QueueId, '')) + '</QueueId><UserName>' + COALESCE(@v_UserName, '') +	'</UserName><ActivityName>' + COALESCE(@v_ActivityName, '') + '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' + CONVERT(VARCHAR, COALESCE(@v_TotalDuration, 0)) +'</TotalDuration><ActionDateTime>' + CONVERT(VARCHAR(22), GETDATE(), 20) + '</ActionDateTime><ProcessInstance>' + COALESCE(@v_ProcessInstanceId, '') + '</ProcessInstance><FieldId>' + CONVERT(VARCHAR, COALESCE(@v_FieldId, '')) + '</FieldId><FieldName>' + COALESCE(@v_FieldName, '') + '</FieldName><WorkitemId>' + CONVERT(VARCHAR, COALESCE(@v_WorkItemId, '')) + '</WorkitemId><TotalPrTime>' + CONVERT(VARCHAR, COALESCE(@TotPrTime, 0)) + '</TotalPrTime><DelayTime>' + CONVERT(VARCHAR, COALESCE(@v_DelayTime, 0)) + '</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', N'N', GETDATE()) 
		END 
 
		Insert into WFCurrentRouteLogTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName, NewValue, QueueId , ProcessVariantId, TaskId ,subTaskId, URN, ProcessingTime, TAT, DelayTime) 
		values(@v_ProcessDefId,@v_ActivityId,@v_ProcessInstanceId,@v_WorkItemId,@v_UserId,@v_ActionId,getDate(),@v_AssociatedDateTime,@v_FieldId,@v_FieldName, @v_ActivityName,@v_UserName,
		@v_NewValue,@v_QueueId,@v_ProcessVariantId,@v_TaskId ,@v_subTaskId,@v_URN, CONVERT(INT, COALESCE(@TotPrTime, 0)),@v_TotalDuration, @v_DelayTime) 
 
		IF(@@ERROR > 0 OR @@ROWCOUNT <= 0) 
		BEGIN 
			SELECT @v_MainCode = 15 
		END 
		
	
	END 
END
~

Print 'Stored Procedure WFGenerateLog compiled successfully ........'