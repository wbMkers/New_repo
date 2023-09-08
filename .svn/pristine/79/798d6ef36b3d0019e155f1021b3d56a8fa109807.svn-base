/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFSetCustomServiceStatus.sql
Author			: Chitranshi Nitharia
Date written	: Mar 24th, 2020
Description		: This procedure will set custom service status
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
16-04-2020		Chitranshi Nitharia			Bug 91524 - Framework to manage custom utility via ofservices
-----------------------------------------------------------------------------------------
*/

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'WFSetCustomServiceStatus')
BEGIN
  EXECUTE ('DROP PROCEDURE WFSetCustomServiceStatus')
END

~

CREATE PROCEDURE WFSetCustomServiceStatus (
	@PSID				INTEGER,
	@ServiceStatus		INTEGER,
	@ServiceStatusMsg	NVARCHAR(100),
	@WorkItemCount		INTEGER
)
AS
	SET NOCOUNT ON
	DECLARE @lWorkItemCount		INTEGER
	DECLARE @WorkItemCountExp	NVARCHAR(100)
	DECLARE @Query1				NVARCHAR(2000)
	DECLARE @Param1				NVARCHAR(500)
BEGIN
	SET @lWorkItemCount = ISNULL(@WorkItemCount, 0)
	IF(@lWorkItemCount >= 0)
	BEGIN
		SET @WorkItemCountExp = N'(WorkItemCount + @lWorkItemCount)'
	END
	ELSE IF(@lWorkItemCount = -1)
	BEGIN
		SET @lWorkItemCount = 0
		SET @WorkItemCountExp = N'@lWorkItemCount'
	END
	ELSE
	BEGIN
		SET @lWorkItemCount = 0
		SET @WorkItemCountExp = N'(WorkItemCount + @lWorkItemCount)'
	END

	SET @Query1 = N'UPDATE WFCustomServicesStatusTable SET ServiceStatus = @ServiceStatus, ServiceStatusMsg = @ServiceStatusMsg, WorkItemCount = ' + @WorkItemCountExp + ', LastUpdated = GETDATE() WHERE PSID = @PSID'
	SET @Param1 = N'@ServiceStatus INTEGER, @ServiceStatusMsg NVARCHAR(100), @lWorkItemCount INTEGER, @PSID INTEGER'

	EXECUTE SP_EXECUTESQL @Query1, @Param1, @ServiceStatus = @ServiceStatus, @ServiceStatusMsg = @ServiceStatusMsg, @lWorkItemCount = @lWorkItemCount, @PSID = @PSID
END
