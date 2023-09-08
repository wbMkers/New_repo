		/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveVariantMetaData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Move Variant Meta Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	

	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveVariantMetaData')
	Begin
		Execute('DROP PROCEDURE WFMoveVariantMetaData')
		Print 'Procedure WFMoveVariantMetaData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMoveVariantMetaData
	(
		@v_sourceCabinet 		  VARCHAR(256),
		@v_targetCabinet 		  VARCHAR(256),
		@v_tableName     		  VARCHAR(256),
		@v_hasIdentityColumn	  VARCHAR(1),
		@v_processDefId			  INT,
		@v_processVariantId  	  INT,
		@dblinkString    	 	  VARCHAR(256),
		@v_migrateAllData 		  VARCHAR(1),
		@v_copyForceFully    	  VARCHAR(1),
		@v_existingProcessString  VARCHAR(2000),
		@v_executionLogId 		  INT
	)
	AS
	  DECLARE @v_query      			NVARCHAR(4000)
	  DECLARE @v_colStr     			NVARCHAR(4000)
	  DECLARE @v_columnName 			VARCHAR(256)
	  DECLARE @v_FilterQueryString 		NVARCHAR(1000)
	  
	BEGIN
			SELECT @v_FilterQueryString = ''
			SELECT @v_query = 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''' + @v_tableName + ''''
			EXECUTE ('DECLARE columnName_cur CURSOR FAST_FORWARD FOR ' + @v_query)
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveVariantMetaData] Error in executing columnName cursor query')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
				RETURN
			End
			OPEN columnName_cur
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveVariantMetaData] Error in opening columnName cursor')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in WFMoveVariantMetaData Error in opening columnName cursor', 16, 1) 
				RETURN
			End

			FETCH NEXT FROM columnName_cur INTO @v_columnName
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveVariantMetaData] Error in fetching data FROM columnName cursor')
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in WFMoveVariantMetaData Error in fetching data FROM columnName cursor', 16, 1) 
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
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveVariantMetaData] Error in fetching data FROM columnName cursor')
					CLOSE columnName_cur 
					DEALLOCATE columnName_cur 
					--RAISERROR('Error in WFMoveVariantMetaData Error in fetching data FROM columnName cursor', 16, 1) 
					RETURN
				End
			END
			
			CLOSE columnName_cur
			DEALLOCATE columnName_cur
				
				IF(@v_migrateAllData = 'Y')
				BEGIN
					IF(@v_copyForceFully ='Y')
					BEGIN
						SELECT @v_query = 'TRUNCATE TABLE ' + @v_targetCabinet + '..' + @v_tableName
						EXECUTE (@v_query)
						IF(@@error <> 0)
						BEGIN
							--RAISERROR('Error in WFMoveVariantMetaData while truncating data ', 16, 1) 
							RETURN
						END
						SELECT @v_FilterQueryString = ' WHERE 1 = 1 '
					END
					ELSE
					BEGIN
						SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID NOT IN ( ' + @v_existingProcessString + ')'
					END
				END
				ELSE
				BEGIN
					SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID = ' + CONVERT(NVARCHAR(10),@v_processDefId) + ' AND PROCESSVARIANTID = ' + CONVERT(NVARCHAR(10),@v_processVariantId)
					IF(@v_copyForceFully ='Y')
					BEGIN
						SELECT @v_query = 'DELETE FROM ' + @v_targetCabinet + '..' + @v_tableName + ' WHERE PROCESSDEFID = ' + CONVERT(NVARCHAR(10),@v_processDefId) + ' AND PROCESSVARIANTID = ' + CONVERT(NVARCHAR(10),@v_processVariantId)
						EXECUTE(@v_query)
						IF(@@error <> 0)
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_query)
							--RAISERROR('Error in WFMoveVariantMetaData while truncating data ', 16, 1) 
							RETURN
						END
					END
				END
				
				IF( @v_hasIdentityColumn = 'Y' )
				BEGIN
					SELECT @v_query = 'set IDENTITY_INSERT '  + @v_targetCabinet + '..' + @v_tableName + ' ON INSERT INTO ' + @v_targetCabinet + '..' + @v_tableName + 
									' (' + @v_colStr + ') SELECT ' + @v_colStr + 
									' FROM ' + @dblinkString + '.' + @v_tableName +  ' WITH (NOLOCK) ' + @v_FilterQueryString + ' set IDENTITY_INSERT '  + @v_targetCabinet + '..' + @v_tableName + ' OFF ' 
				END
				ELSE
				BEGIN
					SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..' + @v_tableName + 
									' (' + @v_colStr + ') SELECT ' + @v_colStr + 
									' FROM ' + @dblinkString + '.' + @v_tableName +  ' WITH (NOLOCK) ' + @v_FilterQueryString
				END
				EXECUTE (@v_query)
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_query)
					--RAISERROR('Error in WFMoveVariantMetaData while inserting data ', 16, 1) 
					RETURN
				END

				SELECT @v_query = 'UPDATE ' + @v_targetCabinet + '..WFMETADATATABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' + @v_tableName + ''''
				EXECUTE (@v_query)
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_query)
					--RAISERROR('Error in WFMoveVariantMetaData Error in updating status in WFMETADATATABLELIST ', 16, 1) 
					RETURN
				End
				
				INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_tableName,'WFMoveVariantMetaData Executed Succssfully for variant ' + CONVERT(NVARCHAR(10),@v_processVariantId))
			
	END

	