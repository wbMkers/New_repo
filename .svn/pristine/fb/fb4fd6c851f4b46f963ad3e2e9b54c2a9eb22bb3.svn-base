/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: iBPS
	Module				: Transaction Server
	File Name			: WFUpgradeCustomUploadTable.sql
	Author				: Sajid Khan
	Date written		: 29 April 2017
	Description			: This procedure will check and upgrade the Custom Upload Table
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------------------
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
----------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFUpgradeCustomUploadTable')
BEGIN
	EXECUTE('DROP PROCEDURE WFUpgradeCustomUploadTable')
	PRINT 'Procedure WFUpgradeCustomUploadTable already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE WFUpgradeCustomUploadTable (
	@CustomTableName NVARCHAR(255),
	@UpgradeHistoryTable NVARCHAR(1),
	@MainCode INT OUTPUT,
	@ErrorDescription NVARCHAR(1000) OUTPUT
)
AS
BEGIN
	DECLARE @CustomHistoryTableName NVARCHAR(265)
	DECLARE @CustomTableId BIGINT
	DECLARE @CustomHistoryTableId BIGINT

	SET @CustomHistoryTableName = @CustomTableName + '_History'
	SET @CustomTableId = 0
	SET @CustomHistoryTableId = 0

	SET @MainCode = 0
	SET @ErrorDescription = ''

	/* Adding RetryCount column in @CustomTableName table*/
	SELECT @CustomTableId = id FROM sysObjects WHERE NAME = @CustomTableName
	IF(@CustomTableId <> 0)
	BEGIN
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = @CustomTableId AND  NAME = 'RetryCount')
		BEGIN
			--PRINT 'Altering table ' + @CustomTableName + ', adding column RetryCount.'
			EXECUTE('ALTER TABLE ' + @CustomTableName + ' ADD RetryCount INT DEFAULT 0')
			EXECUTE('UPDATE ' + @CustomTableName + ' SET RetryCount = 0')
			--PRINT 'Table ' + @CustomTableName + ' altered.'
		END
	END
	ELSE
	BEGIN
		SET @MainCode = 15
		SET @ErrorDescription = 'Table ' + @CustomTableName + ' does not exist.'
	END

	/* Adding RetryCount column in @CustomHistoryTableName table*/
	IF @UpgradeHistoryTable = 'Y'
	BEGIN
		SELECT @CustomHistoryTableId = id FROM sysObjects WHERE NAME = @CustomHistoryTableName
		IF(@CustomHistoryTableId <> 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = @CustomHistoryTableId AND  NAME = 'RetryCount')
			BEGIN
				--PRINT 'Altering table ' + @CustomHistoryTableName + ', adding column RetryCount.'
				EXECUTE('ALTER TABLE ' + @CustomHistoryTableName + ' ADD RetryCount INT DEFAULT 0')
				EXECUTE('UPDATE ' + @CustomHistoryTableName + ' SET RetryCount = 0')
				--PRINT 'Table ' + @CustomHistoryTableName + ' altered.'
			END
		END
		ELSE
		BEGIN
			SET @MainCode = 15
			SET @ErrorDescription = @ErrorDescription + 'Table ' + @CustomHistoryTableName + ' does not exist.'
		END
	END
END

~

Print 'Stored Procedure WFUpgradeCustomUploadTable compiled successfully ........'
