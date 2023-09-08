/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: OmniFlow 10.x
	Module				: Transaction Server
	File Name			: WFGetNextWIForArchiveAudit.sql
	Author				: Ashutosh Pandey
	Date written		: Mar 14, 2019
	Description			: This procedure will fetch and return next record for Audit Archive utility
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
14/03/2019	Ashutosh Pandey		Bug 83490 - Audit Archive utility gets stuck if an error occurs in processing a record
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
----------------------------------------------------------------------------------------------------
*/
IF EXISTS (SELECT 1 FROM SysObjects WITH(NOLOCK) WHERE name = 'WFGetNextWIForArchiveAudit' AND xType = 'P')
BEGIN
	EXECUTE('DROP PROCEDURE WFGetNextWIForArchiveAudit')
END

~

CREATE PROCEDURE WFGetNextWIForArchiveAudit (
	@DBSessionId INT,
	@CSName NVARCHAR(100)
)
AS
SET NOCOUNT ON
BEGIN

	DECLARE @PSId INT
	DECLARE @PSName NVARCHAR(400)
	DECLARE @v_RowCount INT
	DECLARE @v_ErrorCode INT
	DECLARE @CSSessionId INT

	DECLARE @ProcessDefId INT
	DECLARE @ProcessInstanceId NVARCHAR(63)
	DECLARE @WorkitemId INT
	DECLARE @ActivityId INT
	DECLARE @DocId INT
	DECLARE @ParentFolderIndex INT
	DECLARE @VolId INT
	DECLARE @AppServerIP NVARCHAR(63)
	DECLARE @AppServerPort INT
	DECLARE @AppServerType NVARCHAR(63)
	DECLARE @EngineName NVARCHAR(63)
	DECLARE @DeleteAudit NVARCHAR(1)
	DECLARE @URN NVARCHAR(63)

	BEGIN
		SELECT @PSId = PSReg.PSId, @PSName = PSReg.PSName FROM PSRegisterationTable PSReg WITH(NOLOCK) , WFPSConnection PSCon  WITH(NOLOCK) WHERE PSCon.SESSIONID = @DBSessionId   and PSReg.PSID = PSCon.PSID 
		SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR
		IF @v_RowCount <= 0 OR @v_ErrorCode <> 0
		BEGIN
			SELECT 11, NULL, NULL, NULL
			RETURN
		END
	END

	BEGIN
		SELECT @CSSessionId = SessionID FROM PSRegisterationTable WITH(NOLOCK) WHERE PSName = @CSName AND Type = 'C'
	END

	BEGIN
		BEGIN TRANSACTION LockNextRecord

		SELECT TOP 1 @ProcessDefId = ProcessDefId, @ProcessInstanceId = ProcessInstanceId, @WorkitemId = WorkitemId, @ActivityId = ActivityId, @DocId = DocId, @ParentFolderIndex = ParentFolderIndex, @VolId = VolId, @AppServerIP = AppServerIP, @AppServerPort = AppServerPort, @AppServerType = AppServerType, @EngineName = EngineName, @DeleteAudit = DeleteAudit FROM WFAuditTrailDocTable WITH(UPDLOCK, READPAST) WHERE Status = 'R'

		SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

		IF @v_ErrorCode <> 0
		BEGIN
			ROLLBACK TRANSACTION LockNextRecord
			SELECT 15, @CSSessionId, @PSId, @PSName
			RAISERROR('WFGetNextWorkitemforArchiveAudit: Error in fetching next unlocked record', 16, 1)
			RETURN
		END

		IF @v_RowCount <= 0
		BEGIN
			SELECT TOP 1 @ProcessDefId = ProcessDefId, @ProcessInstanceId = ProcessInstanceId, @WorkitemId = WorkitemId, @ActivityId = ActivityId, @DocId = DocId, @ParentFolderIndex = ParentFolderIndex, @VolId = VolId, @AppServerIP = AppServerIP, @AppServerPort = AppServerPort, @AppServerType = AppServerType, @EngineName = EngineName, @DeleteAudit = DeleteAudit FROM WFAuditTrailDocTable WITH(NOLOCK) WHERE Status = 'L' AND LockedBy = @PSName

			SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

			IF @v_ErrorCode <> 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @CSSessionId, @PSId, @PSName
				RAISERROR('WFGetNextWorkitemforArchiveAudit: Error in fetching next locked record', 16, 1)
				RETURN
			END

			IF @v_RowCount > 0 
			BEGIN	
				BEGIN
					select @URN=URN  from WFInstrumentTable WITH(NOLOCK) where processinstanceid=@ProcessInstanceId and workitemid=@WorkitemId
				END
				SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR
				
				IF @v_ErrorCode <> 0
				BEGIN
					ROLLBACK TRANSACTION LockNextRecord
					SELECT 15, @CSSessionId, @PSId, @PSName
					RAISERROR('WFGetNextWorkitemforArchiveAudit: Error in fetching URN', 16, 1)
					RETURN
				END
				COMMIT TRANSACTION LockNextRecord
				SELECT 0, @CSSessionId, @PSId, @PSName
				SELECT @ProcessDefId ProcessDefId, @ProcessInstanceId ProcessInstanceId, @WorkitemId WorkitemId, @ActivityId ActivityId, @DocId DocId, @ParentFolderIndex ParentFolderIndex, @VolId VolId, @AppServerIP AppServerIP, @AppServerPort AppServerPort, @AppServerType AppServerType, @EngineName EngineName, @DeleteAudit DeleteAudit,@URN URN
				RETURN
			END
			ELSE
			BEGIN
				COMMIT TRANSACTION LockNextRecord
				SELECT 18, @CSSessionId, @PSId, @PSName
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE WFAuditTrailDocTable SET Status = 'L', LockedBy = @PSName WHERE ProcessInstanceId = @ProcessInstanceId AND WorkitemId = @WorkitemId AND ActivityId = @ActivityId

			SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

			IF @v_ErrorCode <> 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @CSSessionId, @PSId, @PSName
				RAISERROR ('WFGetNextWorkitemforArchiveAudit: Error in Updating status of fetched record', 16, 1)
				RETURN
			END

			IF @v_RowCount > 0
			BEGIN
				BEGIN
					select @URN=URN  from WFInstrumentTable WITH(NOLOCK) where processinstanceid=@ProcessInstanceId and workitemid=@WorkitemId
				END
				SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR
				
				IF @v_ErrorCode <> 0
				BEGIN
					ROLLBACK TRANSACTION LockNextRecord
					SELECT 15, @CSSessionId, @PSId, @PSName
					RAISERROR('WFGetNextWorkitemforArchiveAudit: Error in fetching URN', 16, 1)
					RETURN
				END
				COMMIT TRANSACTION LockNextRecord
				SELECT 0, @CSSessionId, @PSId, @PSName
				SELECT @ProcessDefId ProcessDefId, @ProcessInstanceId ProcessInstanceId, @WorkitemId WorkitemId, @ActivityId ActivityId, @DocId DocId, @ParentFolderIndex ParentFolderIndex, @VolId VolId, @AppServerIP AppServerIP, @AppServerPort AppServerPort, @AppServerType AppServerType, @EngineName EngineName, @DeleteAudit DeleteAudit,@URN URN
				RETURN
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @CSSessionId, @PSId, @PSName
				RAISERROR ('WFGetNextWorkitemforArchiveAudit: Status for fetched record is not updated', 16, 1)
				RETURN
			END
		END
	END

END

~