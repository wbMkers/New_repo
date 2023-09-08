	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveTxnCabinetData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 26 MAY 2014
	Description                 : Stored Procedure To Move Cabinet Level Transactional Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/

	
	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFMoveTxnCabinetData')
	Begin
		Execute('DROP PROCEDURE WFMoveTxnCabinetData')
		Print 'Procedure WFMoveTxnCabinetData already exists, hence older one dropped ..... '
	End

	~


	CREATE Procedure WFMoveTxnCabinetData(
		@v_sourceCabinet VARCHAR(256),
		@v_targetCabinet VARCHAR(256),
		@v_tableName	 VARCHAR(256),
		@dblinkString	 VARCHAR(256),
		@v_beforeDate	 VARCHAR(256)
	)
	AS
	BEGIN
		DECLARE @v_query 			NVARCHAR(2000)
		DECLARE @v_ColStr 			VARCHAR(4000)
		DECLARE @v_columnName		VARCHAR(256)
		DECLARE @existsFlag			INT 	
		DECLARE @v_rowCounter		INT
		DECLARE @v_filterString		VARCHAR(4000)
		DECLARE @v_orderByString	VARCHAR(4000)
		DECLARE @v_queryParameter   NVARCHAR(256)
		
		SELECT @v_filterString  = ''
		SELECT @v_orderByString = ''
		
		IF( (UPPER(@v_tableName) = 'SUMMARYTABLE') OR (UPPER(@v_tableName) = 'WFACTIVITYREPORTTABLE') )
		BEGIN
			SELECT @v_filterString  = ' WHERE ACTIONDATETIME < CONVERT(DATETIME, ' + '''' + @v_beforeDate + '''' + ')'
			SELECT @v_orderByString = ' ORDER BY ACTIONDATETIME'
		END
		ELSE IF(Upper(@v_tableName) = 'WFRECORDEDCHATS')
		BEGIN
			SELECT @v_filterString  = ' WHERE SAVEDAT < CONVERT(DATETIME, ' + '''' + @v_beforeDate + '''' + ')'
			SELECT @v_orderByString = ' ORDER BY SAVEDAT'
		END
		ELSE IF (Upper(@v_tableName) = 'WFUSERRATINGLOGTABLE') 
		BEGIN
			SELECT @v_filterString  = ' WHERE RATINGDATETIME < CONVERT(DATETIME, ' + '''' + @v_beforeDate + '''' + ')'
			SELECT @v_orderByString = ' ORDER BY RATINGDATETIME'
		END
		ELSE IF (Upper(@v_tableName) = 'WFMAILQUEUEHISTORYTABLE') 
		BEGIN
			SELECT @v_filterString  = ' WHERE SUCCESSTIME < CONVERT(DATETIME, ' + '''' + @v_beforeDate + '''' + ')'
			SELECT @v_orderByString = ' ORDER BY SUCCESSTIME'
		END
		
		WHILE (1 = 1)
		BEGIN
			BEGIN TRANSACTION Move_Txn_Cabinet_Data
				SELECT @v_query = ' SELECT @value = COUNT(*) FROM ( SELECT TOP 100 * FROM ' + @dblinkString + '. ' +@v_tableName + @v_filterString + @v_orderByString + ' ) A '
				SELECT @v_queryParameter = '@value INT OUTPUT'
				EXEC sp_executesql @v_query, @v_queryParameter, @value = @v_rowCounter OUTPUT
				IF(@@ERROR <> 0 )
				BEGIN
					PRINT 'Error in execution of ' + @v_query
					ROLLBACK TRANSACTION Move_Txn_Cabinet_Data
					RETURN
				END
				IF(@v_rowCounter = 0)
				BEGIN
					COMMIT TRANSACTION 
					break
				END
				
				IF(@v_tableName = 'WFUserRatingLogTable')
				BEGIN
					SELECT @v_query =  'set IDENTITY_INSERT '  + @v_targetCabinet + '..' + @v_tableName + ' ON INSERT INTO ' + @v_tableName + '(RatingLogId,RatingToUser,RatingByUser,SkillId,Rating,RatingDateTime,Remarks) SELECT TOP 100 * FROM ' + @dblinkString + '.' + @v_tableName + @v_filterString + @v_orderByString + ' set IDENTITY_INSERT '  + @v_targetCabinet + '..' + @v_tableName + ' OFF'
				END
				ELSE
				BEGIN
					SELECT @v_query = 'INSERT INTO ' + @v_tableName + ' SELECT TOP 100 * FROM ' + @dblinkString + '.' + @v_tableName + @v_filterString + @v_orderByString
				END
				EXECUTE (@v_query)
				IF(@@ERROR <> 0 )
				BEGIN
					PRINT 'Error in execution of ' + @v_query
					ROLLBACK TRANSACTION Move_Txn_Cabinet_Data
					RETURN
				END
				
				SELECT @v_query = 'DELETE TOP ( 100 ) FROM ' + @dblinkString + '.' + @v_tableName + @v_filterString
				EXECUTE (@v_query)
				IF(@@ERROR <> 0 )
				BEGIN
					PRINT 'Error in execution of ' + @v_query
					ROLLBACK TRANSACTION Move_Txn_Cabinet_Data
					RETURN
				END
				
				SELECT @v_query = 'UPDATE ' + @v_targetCabinet + '..WFTXNCABINETBLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ' + '''' + @v_tableName + ''''
				EXECUTE (@v_query)
				
			COMMIT TRANSACTION Move_Txn_Cabinet_Data
		END
	END
