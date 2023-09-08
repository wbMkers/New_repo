	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveProcessData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Move Process Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveProcessData')
	Begin
		Execute('DROP PROCEDURE WFMoveProcessData')
		Print 'Procedure WFMoveProcessData already exists, hence older one dropped ..... '
	End

	~

	CREATE 
	PROCEDURE WFMoveProcessData
	(
		@v_sourceCabinet	  	VARCHAR(255),
		@v_targetCabinet      	VARCHAR(255),	
		@v_tableName          	VARCHAR(255),
		@dblinkString          	VARCHAR(255),
		@v_overRideCabinetData	VARCHAR(1),
		@v_hasIdentityColumn	VARCHAR(1),
		@v_executionLogId		INT
	)
	AS

	BEGIN

		DECLARE @v_query            NVARCHAR(2000)
		DECLARE @v_colStr           VARCHAR(4000)
		DECLARE @v_columnName       VARCHAR(256)
		DECLARE @v_toCopyData		INT
		DECLARE @v_queryParameter	NVARCHAR(256)
		DECLARE @countVal				INT
		
		
			SELECT @v_query = 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''' + @v_tableName + ''''
			EXECUTE ('DECLARE columnName_cur CURSOR FAST_FORWARD FOR ' + @v_query)
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in executing columnName cursor query')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				ROLLBACK TRANSACTION Move_Process_Data
				--RAISERROR('Error in WFMoveProcessData Error in executing columnName cursor query', 16, 1) 
				RETURN
			End
			OPEN columnName_cur
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in opening columnName cursor')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--ROLLBACK TRANSACTION Move_Process_Data
				--RAISERROR('Error in WFMoveProcessData Error in opening columnName cursor', 16, 1) 
				RETURN
			End

			FETCH NEXT FROM columnName_cur INTO @v_columnName
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in fetching data FROM columnName cursor')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--ROLLBACK TRANSACTION Move_Process_Data
				--RAISERROR('Error in WFMoveProcessData Error in fetching data FROM columnName cursor', 16, 1) 
				RETURN
			End
			SELECT @v_colStr = ''
			WHILE(@@FETCH_STATUS <> -1) 
			BEGIN 
				IF (@@FETCH_STATUS <> -2) 
				BEGIN 
						IF (@v_colStr IS NOT NULL AND @v_colStr <> '')
						BEGIN
							SELECT @v_colStr = @v_colStr + ', '
						END
						SELECT @v_colStr = @v_colStr + @v_columnName
				END
				FETCH NEXT FROM columnName_cur INTO @v_columnName
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in fetching data FROM columnName cursor')
					CLOSE columnName_cur 
					DEALLOCATE columnName_cur 
					--ROLLBACK TRANSACTION Move_Process_Data
					--RAISERROR('Error in WFMoveProcessData Error in fetching data FROM columnName cursor', 16, 1) 
					RETURN
				End
			END
			CLOSE columnName_cur
			DEALLOCATE columnName_cur
			
			SELECT  @v_toCopyData = 0
			
			IF(@v_overRideCabinetData='Y') 
			BEGIN
				
				SELECT @v_query = 'TRUNCATE TABLE ' + @v_targetCabinet + '..' + @v_tableName
				EXECUTE (@v_query)
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error truncating table ' + @v_tableName)
					--RAISERROR('Error in WFMoveProcessData Error truncating data ', 16, 1) 
					RETURN
				End
				SELECT  @v_toCopyData = 1
			END
			ELSE
			BEGIN
				SELECT @v_query = ' SELECT @value = COUNT(*) FROM ' + @v_targetCabinet + '..' + @v_tableName + '  WITH (NOLOCK) '
				SELECT @v_queryParameter = '@value INT OUTPUT'
				EXEC sp_executesql @v_query, @v_queryParameter, @value = @countVal OUTPUT
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in execution of query  ' + @v_query)
					--RAISERROR('Error in Migrate_Process_Data while inserting data ', 16, 1) 
					RETURN
				END
				IF(@countVal = 0 )
				BEGIN
					SELECT  @v_toCopyData = 1
				END
			END
			
			IF( @v_toCopyData > 0 )
			BEGIN
				IF(@v_hasIdentityColumn = 'Y')
				BEGIN
					SELECT @v_query = 'SET IDENTITY_INSERT ' + @v_targetCabinet + '..' + @v_tableName +' ON INSERT INTO ' + @v_targetCabinet + '..' + @v_tableName + 
									' (' + @v_colStr + ') SELECT ' + @v_colStr + 
									' FROM ' + @dblinkString + '.' + @v_tableName  + '   WITH (NOLOCK)  SET IDENTITY_INSERT ' + @v_targetCabinet + '..' + @v_tableName +' OFF'
				END
				ELSE
				BEGIN
					SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..' + @v_tableName + 
									' (' + @v_colStr + ') SELECT ' + @v_colStr + 
									' FROM ' + @dblinkString + '.' + @v_tableName + '  WITH (NOLOCK) '
				END
				EXECUTE (@v_query)
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in execution of query  ' + @v_query)
					--ROLLBACK TRANSACTION Move_Process_Data
					--RAISERROR('Error in Migrate_Process_Data while inserting data ', 16, 1) 
					RETURN
				END
			
				SELECT @v_query = 'UPDATE ' + @v_targetCabinet + '..WFPROCESSTABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' + @v_tableName + ''''
				EXECUTE (@v_query)
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMoveProcessData] Error in updating status in WFPROCESSTABLELIST for ' + @v_tableName)
					--RAISERROR('Error in WFMoveProcessData Error in updating status in WFPROCESSTABLELIST ', 16, 1) 
					RETURN
				End
				
				INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,0,@v_tableName,'Cabinet level MetaData')
			END
	END
