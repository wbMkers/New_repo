/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: OmniFlow 10.x
	Module				: Transaction Server
	File Name			: WFGetNextRowFromTable.sql
	Author				: Ashutosh Pandey
	Date written		: Apr 16, 2019
	Description			: This procedure will fetch and return next record from import table
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
17/04/2019	Ashutosh Pandey		Bug 84206 - Optimization in WFGetNextUnlockedRowFromTable API
4/09/2019	Ravi Ranjan Kumar	Bug 86333 - Import Service is not working. WI are not getting created.
----------------------------------------------------------------------------------------------------
*/
IF EXISTS (SELECT 1 FROM SysObjects WITH(NOLOCK) WHERE name = 'WFGetNextRowFromTable' AND xType = 'P')
BEGIN
	EXECUTE('DROP PROCEDURE WFGetNextRowFromTable')
END

~

CREATE PROCEDURE WFGetNextRowFromTable (
	@DBSessionId INT,
	@CSName NVARCHAR(100),
	@TableName NVARCHAR(100),
	@FilterString NVARCHAR(1000)
)
AS
SET NOCOUNT ON
BEGIN

	DECLARE @v_PSId INT
	DECLARE @v_PSName NVARCHAR(400)
	DECLARE @v_RowCount INT
	DECLARE @v_ErrorCode INT
	DECLARE @v_CSSessionId INT

	DECLARE @v_ImportDataId INT;
	DECLARE @v_QueryStr NVARCHAR(2000);

	BEGIN
		SELECT @v_PSId = PSReg.PSId, @v_PSName = PSReg.PSName FROM PSRegisterationTable PSReg WITH(NOLOCK) , WFPSConnection PSCon  WITH(NOLOCK) WHERE PSCon.SESSIONID = @DBSessionId  and PSReg.PSID = PSCon.PSID
		SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR
		IF @v_RowCount <= 0 OR @v_ErrorCode <> 0
		BEGIN
			SELECT 11, NULL, NULL, NULL
			RETURN
		END
	END

	BEGIN
		SELECT @v_CSSessionId = SessionID FROM PSRegisterationTable WITH(NOLOCK) WHERE PSName = @CSName AND Type = 'C'
	END

	BEGIN
		BEGIN TRANSACTION LockNextRecord

		SET @v_QueryStr = 'SELECT TOP 1 @v_ImportDataId = ImportDataId FROM ' + @TableName + ' WITH(UPDLOCK, READPAST) WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''N'''
		IF(@FilterString IS NOT NULL AND LEN(@FilterString) > 0)
			SET @v_QueryStr = @v_QueryStr + ' AND ' + @FilterString
		SET @v_QueryStr = @v_QueryStr + ' ORDER BY ImportDataId ASC'
		EXECUTE sp_executesql @v_QueryStr, N'@v_ImportDataId INT OUTPUT', @v_ImportDataId = @v_ImportDataId OUTPUT

		SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

		IF @v_ErrorCode <> 0
		BEGIN
			ROLLBACK TRANSACTION LockNextRecord
			SELECT 15, @v_CSSessionId, @v_PSId, @v_PSName
			RAISERROR('WFGetNextRowFromTable: Error in fetching next unlocked record', 16, 1)
			RETURN
		END

		IF @v_RowCount <= 0
		BEGIN
			SET @v_QueryStr = 'SELECT TOP 1 @v_ImportDataId = ImportDataId FROM ' + @TableName + ' WITH(NOLOCK) WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''Y'' AND LockedBy = ''' + @v_PSName + ''''
			IF(@FilterString IS NOT NULL AND LEN(@FilterString) > 0)
				SET @v_QueryStr = @v_QueryStr + ' AND ' + @FilterString
			SET @v_QueryStr = @v_QueryStr + ' ORDER BY ImportDataId ASC'
			EXECUTE sp_executesql @v_QueryStr, N'@v_ImportDataId INT OUTPUT', @v_ImportDataId = @v_ImportDataId OUTPUT

			SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

			IF @v_ErrorCode <> 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @v_CSSessionId, @v_PSId, @v_PSName
				RAISERROR('WFGetNextRowFromTable: Error in fetching next locked record', 16, 1)
				RETURN
			END

			IF @v_RowCount <= 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 18, @v_CSSessionId, @v_PSId, @v_PSName
				RETURN
			END
		END
		ELSE
		BEGIN
			SET @v_QueryStr = 'UPDATE ' + @TableName + ' SET LockStatus = ''Y'', LockedBy = ''' + @v_PSName + ''' WHERE ImportDataId = ' + CONVERT(NVARCHAR, @v_ImportDataId)
			EXECUTE sp_executesql @v_QueryStr

			SELECT @v_RowCount = @@ROWCOUNT, @v_ErrorCode = @@ERROR

			IF @v_ErrorCode <> 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @v_CSSessionId, @v_PSId, @v_PSName
				RAISERROR ('WFGetNextRowFromTable: Error in Updating status of fetched record', 16, 1)
				RETURN
			END

			IF @v_RowCount <= 0
			BEGIN
				ROLLBACK TRANSACTION LockNextRecord
				SELECT 15, @v_CSSessionId, @v_PSId, @v_PSName
				RAISERROR ('WFGetNextRowFromTable: Status for fetched record is not updated', 16, 1)
				RETURN
			END
		END
	END

	SET @v_QueryStr = 'UPDATE ' + @TableName + ' SET RetryCount = (ISNULL(RetryCount, 0) + 1) WHERE ImportDataId = ' + CONVERT(NVARCHAR, @v_ImportDataId)
	EXECUTE sp_executesql @v_QueryStr

	COMMIT TRANSACTION LockNextRecord

	SELECT 0, @v_CSSessionId, @v_PSId, @v_PSName

	SET @v_QueryStr = 'SELECT * FROM ' + @TableName + ' WITH(NOLOCK) WHERE ImportDataId = ' + CONVERT(NVARCHAR, @v_ImportDataId)
	EXECUTE sp_executesql @v_QueryStr

END



