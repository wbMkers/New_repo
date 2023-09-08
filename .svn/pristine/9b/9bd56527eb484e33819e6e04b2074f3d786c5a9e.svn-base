/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFPurgeServiceAudit.sql
Author			: Chitranshi Nitharia
Date written	: Apr 16th, 2020
Description		: This procedure will purge service history
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
16-04-2020		Chitranshi Nitharia			Bug 91524 - Framework to manage custom utility via ofservices
-----------------------------------------------------------------------------------------
*/

IF EXISTS (SELECT 1 FROM sys.objects WITH(NOLOCK) WHERE name = 'WFPurgeServiceAudit' AND Type = 'P')
BEGIN
	EXECUTE ('DROP PROCEDURE WFPurgeServiceAudit')
END

~

CREATE PROCEDURE WFPurgeServiceAudit (
	@DBConnectId			INT,
	@DBHostName				VARCHAR(30),
	@DBDays					INT = 0,
	@BackupFlag				CHAR(1) = 'N'
)
AS
	SET NOCOUNT ON

	DECLARE @DBUserId				INT
	DECLARE @MainGroupId			INT
	DECLARE @DBStatus				INT
	DECLARE @ApplicationName		VARCHAR(32)
	DECLARE @ApplicationInfo		VARCHAR(32)
	DECLARE @Days					INT
	DECLARE @TillActionDateTime		DATETIME
	DECLARE @PSID					INT
	DECLARE @Query1					NVARCHAR(2000)
	DECLARE @Query2					NVARCHAR(2000)
	DECLARE @Query3					NVARCHAR(2000)
	DECLARE @Query4					NVARCHAR(2000)
	DECLARE @Param1					NVARCHAR(500)
	DECLARE @Param2					NVARCHAR(500)
	DECLARE @Param3					NVARCHAR(500)
	DECLARE @Param4					NVARCHAR(500)
	DECLARE @ErrorMessage			NVARCHAR(2000)
BEGIN TRY

	SET @DBUserId = 0
	SET @MainGroupId = 0
	SET @DBStatus = -1

	EXECUTE PRTCheckUser @DBConnectId, @DBHostName, @DBUserId OUT, @MainGroupId OUT, @DBStatus OUT, @ApplicationInfo, @ApplicationName
	IF (@DBStatus <> 0)
	BEGIN
		SELECT @DBStatus AS Status
		RETURN
	END

	SET @Days = @DBDays
	IF(@Days IS NULL OR @Days <= 0)
	BEGIN
		SET @Days = 90
	END

	SET @Query1 = N'SELECT @TillActionDateTime = (GETDATE() - @Days)'
	SET @Param1 = N'@TillActionDateTime DATETIME OUTPUT, @Days INT'

	SET @Query2 = N'DELETE FROM WFServicesListTable WHERE PSID = @PSID'
	SET @Param2 = N'@PSID INT'

	SET @Query3 = N'INSERT INTO WFServiceAuditTable_History(LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails) SELECT LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails FROM WFServiceAuditTable WITH(NOLOCK) WHERE ActionDateTime < @TillActionDateTime'
	SET @Param3 = N'@TillActionDateTime DATETIME'

	SET @Query4 = N'DELETE FROM WFServiceAuditTable WHERE ActionDateTime < @TillActionDateTime'
	SET @Param4 = N'@TillActionDateTime DATETIME'

	EXECUTE SP_EXECUTESQL @Query1, @Param1, @TillActionDateTime = @TillActionDateTime OUTPUT, @Days = @Days

	DECLARE Cursor1 CURSOR STATIC FOR SELECT PSID FROM WFServiceAuditTable WITH(NOLOCK) WHERE ActionDateTime < @TillActionDateTime AND ActionId = 3
	OPEN Cursor1
	FETCH NEXT FROM Cursor1 INTO @PSID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE SP_EXECUTESQL @Query2, @Param2, @PSID = @PSID
		FETCH NEXT FROM Cursor1 INTO @PSID
	END
	CLOSE Cursor1
	DEALLOCATE Cursor1

	IF(UPPER(@BackupFlag) = 'Y')
	BEGIN
		EXECUTE SP_EXECUTESQL @Query3, @Param3, @TillActionDateTime = @TillActionDateTime
	END

	EXECUTE SP_EXECUTESQL @Query4, @Param4, @TillActionDateTime = @TillActionDateTime

	SELECT 0 AS Status

END TRY
BEGIN CATCH
	SELECT 15 AS Status
	IF CURSOR_STATUS('global','Cursor1') >= -1
	BEGIN
		IF CURSOR_STATUS('global','Cursor1') > -1
		BEGIN
			CLOSE Cursor1
		END
		DEALLOCATE Cursor1
	END
	SET @ErrorMessage = ERROR_MESSAGE()
	RAISERROR(@ErrorMessage, 16, 1)
	RETURN
END CATCH
