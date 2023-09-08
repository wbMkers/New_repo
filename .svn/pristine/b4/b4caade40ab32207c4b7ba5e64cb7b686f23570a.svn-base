	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMigrateVariantMetaData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Migrate Variant Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK) Where xType = 'P' and name = 'WFMigrateVariantMetaData')
	Begin
		Execute('DROP PROCEDURE WFMigrateVariantMetaData')
		Print 'Procedure WFMigrateVariantMetaData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMigrateVariantMetaData(
		@v_sourceCabinet    	VARCHAR(256),
		@v_targetCabinet    	VARCHAR(256),
		@dblinkString        	VARCHAR(256),
		@v_processDefId     	INT,
		@v_processVariantId 	INT,
		@v_migrateAllData 		VARCHAR(1),
		@v_copyForceFully    	VARCHAR(1),
		@v_executionLogId		INT
		
	) AS
	BEGIN
		DECLARE @v_query            		NVARCHAR(2000)
		DECLARE @v_queryStr            		VARCHAR(4000)
		DECLARE @v_queryStr2            	VARCHAR(4000)
		DECLARE @v_query2            	    NVARCHAR(4000)
		DECLARE @v_migratedflag            	INT
		DECLARE @v_existsflag      			INT
		DECLARE @v_tableId      			INT
		DECLARE @v_tableName    			VARCHAR(256)
		DECLARE @v_isVariantTable 			VARCHAR(1)
		DECLARE @v_dataMigrationSuccessful	VARCHAR(1) 
		DECLARE @v_existingVariantString 	Varchar(4000)
		DECLARE @v_existingProcessVariantId	INT
		DECLARE @v_queryParameter  NVARCHAR(256)
		DECLARE @v_hasIdentityColumn		VARCHAR(1) 
		
		SELECT @v_query = 'SELECT ProcessVariantId FROM ' + @v_targetCabinet + '..WFProcessVariantDefTable'
		SELECT @v_existingVariantString = ''
		EXECUTE ('DECLARE processVariantCursor CURSOR FAST_FORWARD FOR ' + @v_query)
		
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateVariantMetaData] Error in executing processVariantCursor cursor query')
			CLOSE processVariantCursor 
			DEALLOCATE processVariantCursor 
			--RAISERROR('Error in WFMigrateVariantMetaData Error in executing processVariantCursor cursor query', 16, 1) 
			RETURN
		End
		
		OPEN processVariantCursor
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateVariantMetaData] Error in opening processVariantCursor cursor')
			CLOSE processVariantCursor 
			DEALLOCATE processVariantCursor 
			--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
			RETURN
		End
		
		FETCH NEXT FROM processVariantCursor INTO @v_existingProcessVariantId
		
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,'[WFMigrateVariantMetaData] Error in fetching data FROM processVariantCursor cursor')
			CLOSE processVariantCursor 
			DEALLOCATE processVariantCursor 
			--RAISERROR('Error in WFMigrateVariantMetaData Error in fetching data FROM processVariantCursor cursor', 16, 1) 
			RETURN
		End
		
		WHILE(@@FETCH_STATUS <> -1) 
		BEGIN 
			IF (@@FETCH_STATUS <> -2) 
			BEGIN
				SELECT @v_existingVariantString = @v_existingVariantString + convert(nvarchar(10),@v_existingProcessVariantId) + ','
			END
			
			FETCH NEXT FROM processVariantCursor INTO @v_existingProcessVariantId
			
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,'[WFMigrateVariantMetaData] Error in fetching data from processVariantCursor cursor')
				CLOSE processVariantCursor 
				DEALLOCATE processVariantCursor 
				--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
				RETURN
			End	
			
		END  ----------END WHILE
		
		----remove last comma--------------
		IF(@v_existingVariantString is not null and @v_existingVariantString <> '' )
			SET @v_existingVariantString = LEFT(@v_existingVariantString, LEN(@v_existingVariantString) - 1)
		
		CLOSE processVariantCursor 
		DEALLOCATE processVariantCursor 
		
		SELECT @v_query = 'SELECT tableName,hasIdentityColumn FROM ' + @v_targetCabinet + '..WFMETADATATABLELIST  WITH (NOLOCK)  where isVariantTableFlag = ''Y''';
		
		IF(@v_migrateAllData = 'N')
		BEGIN
			SELECT @v_migratedflag = 0
			SELECT @v_migratedflag = 1 from WFProcessVariantDefTable where processdefid = @v_processDefId and processvariantid = @v_processVariantId
			IF(@v_migratedflag = 1)	
			BEGIN
				PRINT 'Variant already exists on target cabinet'
				RETURN	
			END
		END
		
		IF(@v_migratedflag = 1)
		BEGIN
			PRINT 'PROCESS VARIANT ALREADY MIGRAATED'
		END
		ELSE
		BEGIN
			SELECT @v_existsflag = 0
			
			SELECT @v_query2 = ' SELECT @value =  1 FROM ' + @dblinkString+ '.WFPROCESSVARIANTDEFTABLE WHERE PROCESSDEFID = ' + CONVERT(NVarchar(10),@v_processdefid) + 'AND PROCESSVARIANTID = ' + CONVERT(NVarchar(10),@v_processVariantId)
			SELECT @v_queryParameter = '@value INT OUTPUT'
			EXEC sp_executesql @v_query2, @v_queryParameter, @value = @v_existsflag OUTPUT
					
			IF ( @v_existsflag = 0 )
			BEGIN
				PRINT 'VARIANT doesn''t exist on the source cabinet'
				RETURN
			END
			ELSE
			BEGIN
				EXECUTE ('DECLARE v_TableNameCursor CURSOR FAST_FORWARD FOR ' + @v_query)
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,'[WFMigrateVariantMetaData]  Error in opening v_TableNameCursor cursor')
					CLOSE v_TableNameCursor 
					DEALLOCATE v_TableNameCursor 
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
				End	
				
				OPEN v_TableNameCursor
				FETCH NEXT FROM v_TableNameCursor INTO @v_tableName , @v_hasIdentityColumn
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,'[WFMigrateVariantMetaData] Error in fetching from v_TableNameCursor cursor')
					CLOSE v_TableNameCursor 
					DEALLOCATE v_TableNameCursor 
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
				END	
				
				WHILE(@@FETCH_STATUS <> -1) 
				BEGIN 
					IF (@@FETCH_STATUS <> -2) 
					BEGIN 
						SELECT @v_existsflag = 0
						IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
						BEGIN
							SELECT @v_existsflag = 1
						END
						IF(@v_existsflag = 1)
						BEGIN
							EXEC WFMoveVariantMetaData @v_sourceCabinet,@v_targetCabinet ,@v_tableName,@v_hasIdentityColumn,@v_processDefId,@v_processVariantId,@dblinkString,@v_migrateAllData,@v_copyForcefully,@v_existingVariantString,@v_executionLogId
							INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_tableName,'WFMoveVariantMetaData Meta Data Executed Succssfully for variant' + convert(nvarchar(10),@v_processVariantId))
						END
				
						FETCH NEXT FROM v_TableNameCursor INTO @v_tableName , @v_hasIdentityColumn
						IF(@@error <> 0)
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0, ' [WFMigrateVariantMetaData] Error in fetching from v_TableNameCursor cursor')
							CLOSE v_TableNameCursor 
							DEALLOCATE v_TableNameCursor 
							--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
							RETURN
						END	
					END ---------END WHILE
				END
				CLOSE v_TableNameCursor 
				DEALLOCATE v_TableNameCursor 
				
			END
		END
	END
