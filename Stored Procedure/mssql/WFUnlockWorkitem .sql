/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow
	Module				: Transaction Server
	File Name			: WFUnlockWorkitems.sql
	Programmer			: Ashutosh Pandey
	Date written		: Mar 2nd 2017
	Description			: This stored procedure is wriiten to unlock the workitems which are locked for more than a specified time
------------------------------------------------------------------------------------------------------
	Parameter Description

	@v_LockedTime   : Provide the no of hours. All the workitem which are locked for more than this hour will be unlocked.
	@v_ProcessDefId : Provide this value if you want to unlock the workitems of a specified process otherwise 0.
	@v_ActivityId   : Provide this value if you want to unlock the workitems of specified activity otherwise 0. ProcessDefId is must if it’s value is not 0.
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
06-Apr-2107		Ashutosh Pandey	Bug 67688 - Requirement to unlock workitems which are locked for more than a specified time
----------------------------------------------------------------------------------------------------*/

IF EXISTS(SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFUnlockWorkitems')
BEGIN
	DROP PROCEDURE WFUnlockWorkitems
	Print('Procedure WFUnlockWorkitems already exists, hence older one dropped ..... ')
END

~

CREATE PROCEDURE WFUnlockWorkitems
(
@v_LockedTime INT,
@v_ProcessDefId INT,
@v_ActivityId INT
)
AS
BEGIN
	DECLARE @v_Filter NVARCHAR(1000)
	DECLARE @v_Query NVARCHAR(2000)
	DECLARE @v_sQuery NVARCHAR(2000)
	DECLARE @v_iProcessDefId INT
	DECLARE @v_iActivityId INT
	DECLARE @v_sProcessInstanceId NVARCHAR(100)
	DECLARE @v_sWorkitemId NVARCHAR(10)
	DECLARE @v_sActivityName NVARCHAR(100)
	DECLARE @v_iQueueID INT
	DECLARE @v_tLockedTime DATETIME
	DECLARE @v_sQueueType NVARCHAR(10)
	DECLARE @v_sHistoryNew NVARCHAR(1)
	DECLARE @v_MainCode INT

	SET @v_Filter = ' WHERE LockStatus = N''Y'' AND RoutingStatus = N''N'''

	IF(@v_LockedTime IS NULL OR @v_LockedTime < 1)
		SET @v_Filter = @v_Filter + ' AND DATEDIFF(MINUTE, LockedTime, GETDATE()) >= 60'
	ELSE
		SET @v_Filter = @v_Filter + ' AND DATEDIFF(MINUTE, LockedTime, GETDATE()) >= ' + CONVERT(NVARCHAR(5), (@v_LockedTime * 60))

	IF(@v_ProcessDefId IS NOT NULL AND @v_ProcessDefId > 0)
	BEGIN
		SET @v_Filter = @v_Filter + ' AND ProcessDefId = ' + CONVERT(NVARCHAR(5), @v_ProcessDefId)
		IF(@v_ActivityId IS NOT NULL AND @v_ActivityId > 0)
			SET @v_Filter = @v_Filter + ' AND ActivityId = ' + CONVERT(NVARCHAR(5), @v_ActivityId)
	END

	SET @v_Query = 'SELECT TOP 100 ProcessDefId, ActivityId, ProcessInstanceId, WorkitemId, ActivityName, Q_QueueID, LockedTime, QueueType FROM WFInstrumentTable' + @v_Filter

	WHILE(1 = 1)
	BEGIN
		BEGIN TRANSACTION UnlockWorkitems

		EXECUTE ('DECLARE LockWorkitemsCur CURSOR FAST_FORWARD FOR ' + @v_Query)
		IF(@@error <> 0)
		BEGIN
			Print('Error in creating LockWorkitemsCur cursor')
			ROLLBACK TRANSACTION UnlockWorkitems
			CLOSE LockWorkitemsCur
			DEALLOCATE LockWorkitemsCur
			RETURN
		END

		OPEN LockWorkitemsCur
		IF(@@error <> 0)
		BEGIN
			Print('Error in opening LockWorkitemsCur cursor')
			ROLLBACK TRANSACTION UnlockWorkitems
			CLOSE LockWorkitemsCur
			DEALLOCATE LockWorkitemsCur
			RETURN
		END

		FETCH NEXT FROM LockWorkitemsCur INTO @v_iProcessDefId, @v_iActivityId, @v_sProcessInstanceId, @v_sWorkitemId, @v_sActivityName, @v_iQueueID, @v_tLockedTime, @v_sQueueType
		IF(@@error <> 0)
		BEGIN
			Print('Error in fetching next record from LockWorkitemsCur cursor')
			ROLLBACK TRANSACTION UnlockWorkitems
			CLOSE LockWorkitemsCur
			DEALLOCATE LockWorkitemsCur
			RETURN
		END

		IF(@@FETCH_STATUS = -1 OR @@FETCH_STATUS = -2)
		BEGIN
			PRINT('Exiting outer loop as no more record found')
			CLOSE LockWorkitemsCur
			DEALLOCATE LockWorkitemsCur
			COMMIT TRANSACTION UnlockWorkitems
			RETURN
		END

		WHILE(@@FETCH_STATUS <> -1)
		BEGIN
			IF (@@FETCH_STATUS <> -2)
			BEGIN
				PRINT('Unlock for ProcessInstanceId = ' + @v_sProcessInstanceId + ' Starts')
				SET @v_sQuery = 'UPDATE WFInstrumentTable SET LockStatus = N''N'', LockedByName = NULL, LockedTime = NULL'
				IF(@v_sQueueType = 'I' OR @v_sQueueType = 'F' OR @v_sQueueType = 'D' OR @v_sQueueType = 'N')
				BEGIN
					SET @v_sQuery = @v_sQuery + ', Q_UserId = 0, AssignedUser = NULL'
				END
				SET @v_sQuery = @v_sQuery + ' WHERE ProcessInstanceId = N''' + @v_sProcessInstanceId + ''' AND WorkitemId = N''' + @v_sWorkitemId + ''''
				EXECUTE(@v_sQuery)
				IF(@@error <> 0)
				BEGIN
					PRINT('Unlock for ProcessInstanceId = ' + @v_sProcessInstanceId + ' Failed')
					ROLLBACK TRANSACTION UnlockWorkitems
					CLOSE LockWorkitemsCur
					DEALLOCATE LockWorkitemsCur
					RETURN
				END

				EXECUTE WFGenerateLog 8, 0, @v_iProcessDefId, @v_iActivityId, @v_iQueueID, 'SYSTEM', @v_sActivityName, 0, @v_sProcessInstanceId, 0, NULL, @v_sWorkitemId,  0, 0, null, 0, 0 , 0, null,NULL, @v_MainCode OUT
				
				IF(@@error <> 0)
				BEGIN
					PRINT('Error while updating RouteLogTable for action id 8 for ProcessInstanceId = ' + @v_sProcessInstanceId)
					PRINT('Unlock for ProcessInstanceId = ' + @v_sProcessInstanceId + ' Failed')
					ROLLBACK TRANSACTION UnlockWorkitems
					CLOSE LockWorkitemsCur
					DEALLOCATE LockWorkitemsCur
					RETURN
				END
				PRINT('Unlock for ProcessInstanceId = ' + @v_sProcessInstanceId + ' Ends')
			END
			FETCH NEXT FROM LockWorkitemsCur INTO @v_iProcessDefId, @v_iActivityId, @v_sProcessInstanceId, @v_sWorkitemId, @v_sActivityName, @v_iQueueID, @v_tLockedTime, @v_sQueueType
			IF(@@error <> 0)
			BEGIN
				Print('Error in fetching next record from LockWorkitemsCur cursor')
				ROLLBACK TRANSACTION UnlockWorkitems
				CLOSE LockWorkitemsCur
				DEALLOCATE LockWorkitemsCur
				RETURN
			END
		END
		CLOSE LockWorkitemsCur
		DEALLOCATE LockWorkitemsCur
		COMMIT TRANSACTION UnlockWorkitems
	END
END

~

Print('Stored Procedure WFUnlockWorkitems compiled successfully ........')