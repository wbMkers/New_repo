	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMigrateTxnCabinetData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 26 MAY 2014
	Description                 : Stored Procedure To Migrate Cabinet Level Transactional Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/

	

	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFMigrateTxnCabinetData')
	Begin
		Execute('DROP PROCEDURE WFMigrateTxnCabinetData')
		Print 'Procedure WFMigrateTxnCabinetData already exists, hence older one dropped ..... '
	End

	~


	CREATE Procedure WFMigrateTxnCabinetData(

		@v_sourceCabinet      VARCHAR(256),
		@v_targetCabinet      VARCHAR(256),
		@v_isDBLink			  VARCHAR(1),	
		@sourceMachineIp      VARCHAR(256),
		@v_beforeDate         VARCHAR(256)
	)
	AS
	BEGIN
		DECLARE @v_query 	  				VARCHAR(4000)
		DECLARE @v_query_Str  				VARCHAR(4000)
		DECLARE @v_tableId	  				INT
		DECLARE @v_tableName  				VARCHAR(256)
		DECLARE @v_dataMigrationSuccessful	VARCHAR(1)
		DECLARE @dblinkString				VARCHAR(256)
		
		IF(@v_isDBLink = 'Y' )
		BEGIN
			SELECT @dblinkString = '[' + @sourceMachineIp + '].'+ @v_sourcecabinet +'.dbo' 
		END
		ELSE
		BEGIN
			SELECT @dblinkString = @v_sourcecabinet + '.'
		END
		
		If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and name = 'WFTXNCABINETBLELIST')
		Begin
			SELECT @v_query = 'Drop Table ' + @v_targetCabinet + '..WFTXNCABINETBLELIST'
			EXECUTE(@v_query)
		End
		
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in dropping table'
			Return
		END
		
		SELECT @v_query = 'Create Table ' + @v_targetCabinet + ' ..WFTXNCABINETBLELIST  (tableId INT Identity(1,1),tableName Varchar(256),dataMigrationSuccessful Varchar(1)) '
		EXECUTE(@v_query)
		
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in creating WFTXNCABINETBLELIST Table'
			Return
		END
		
		EXEC WFPopulateTxnCabinetTableList @v_targetCabinet
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in execution of SP WFPopulateTxnCabinetTableList '
			Return
		END
		
		SELECT @v_query = 'SELECT * FROM ' + @v_targetCabinet + '..WFTXNCABINETBLELIST '
		EXECUTE('DECLARE v_TableNameCursor CURSOR FAST_FORWARD FOR ' + @v_query)
		IF(@@error <> 0)
		BEGIN
			PRINT 'WFMigrateTxnCabinetDate : Error in declaring v_TableNameCursor'
			Return
		END
		
		OPEN v_TableNameCursor
		IF(@@error <> 0)
		BEGIN
			PRINT 'WFMigrateTxnCabinetDate : Error in opening v_TableNameCursor'
			ClOSE v_TableNameCursor
			DEALLOCATE v_TableNameCursor
			Return
		END
		
		FETCH NEXT FROM v_TableNameCursor INTO @v_tableId,@v_tableName,@v_dataMigrationSuccessful
		IF(@@error <> 0)
		BEGIN
			PRINT 'WFMigrateTxnCabinetDate : Error in fetching from  v_TableNameCursor'
			ClOSE v_TableNameCursor
			DEALLOCATE v_TableNameCursor
			Return
		END
		
		WHILE(@@FETCH_STATUS <> -1)
		BEGIN
			IF(@@FETCH_STATUS <> -2  )
			BEGIN
				IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
				BEGIN
					EXEC WFMoveTxnCabinetData @v_sourceCabinet,@v_targetCabinet, @v_tableName,@dblinkString,@v_beforeDate
					IF(@@error <> 0)
					Begin
						PRINT ' [WFMigrateTxnCabinetData] Error in execution of WFMoveTxnCabinetData'
						CLOSE v_TableNameCursor 
						DEALLOCATE v_TableNameCursor 
						--RAISERROR('Error in WFMigrateTxnCabinetData Error in execution of WFMoveTxnCabinetData', 16, 1) 
						RETURN
					End
				END
			END
			
			FETCH NEXT FROM v_TableNameCursor INTO @v_tableId,@v_tableName,@v_dataMigrationSuccessful
			IF(@@error <> 0)
			BEGIN
				PRINT 'WFMigrateTxnCabinetDate : Error in fetching from  v_TableNameCursor'
				PRINT 'WFMigrateTxnCabinetDate : Error in fetching from  v_TableNameCursor'
				ClOSE v_TableNameCursor
				DEALLOCATE v_TableNameCursor
				Return
			END
		END
		
		ClOSE v_TableNameCursor
		DEALLOCATE v_TableNameCursor
	END




