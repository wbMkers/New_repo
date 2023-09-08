	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMigrateMetaData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure to migrate meta data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMigrateMetaData')
	Begin
		Execute('DROP PROCEDURE WFMigrateMetaData')
		Print 'Procedure WFMigrateMetaData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMigrateMetaData(
		@v_sourceCabinet            VARCHAR(256),
		@v_targetCabinet            VARCHAR(256),
		@dblinkString    			VARCHAR(256),
		@tableVariableMap 			Process_Variant_Type READONLY,
		@v_migrateAllData 			VARCHAR(1),
		@v_copyForceFully 			VARCHAR(1),
		@v_overRideCabinetData		VARCHAR(1),
		@v_DeleteFromSrc			VARCHAR(1),
		@v_executionLogId			INT,
		@v_moveTaskData      		VARCHAR(2)
	) AS
	BEGIN
		DECLARE @v_query                    NVARCHAR(2000)
		DECLARE @v_queryFolder 				INT
		DECLARE @v_queryStr2                NVARCHAR(2000)
		DECLARE @v_tableId 					INT
		DECLARE @v_variantId 				INT
		DECLARE @v_tableName                VARCHAR(256)
		DECLARE @v_routeFolderId        	NVARCHAR(255)
		DECLARE @v_identityColumnName       NVARCHAR(255)
		DECLARE @v_workFlowFolderId  		NVARCHAR(255)
		DECLARE @v_completedFolderId        NVARCHAR(255)
		DECLARE @v_dicarderFolderId			NVARCHAR(255)
		DECLARE @v_dataMigrationSuccessful  NVARCHAR(1)
		DECLARE @v_isVariantTable           NVARCHAR(1)
		DECLARE @v_genIndex                	INT
		DECLARE @v_folderStatus            	INT
		DECLARE @v_processType             	NVARCHAR(1)
		DECLARE @v_existingProcessString   	VARCHAR(200)
		DECLARE @v_existingProcessDefId	   	INT
		DECLARE @v_migratedflag     		INT
		DECLARE @v_existsFlag       		INT
		DECLARE @v_processDefId     		INT
		DECLARE @value						NVARCHAR(1)
		DECLARE @v_queryParameter  			NVARCHAR(256)
		DECLARE @v_hasIdentityColumn 		VARCHAR(1)
		DECLARE @v_query2					NVARCHAR(2000)
		DECLARE @val 						INT
		DECLARE @edition					VARCHAR(256)
		DECLARE @flagCheck					VARCHAR(256)
		DECLARE @flagCheck2					VARCHAR(256)
		DECLARE @flagPartition				INT
		DECLARE @tableRecreate				INT
		DECLARE @v_rowcount					INT
		
		SELECT @flagCheck2 ='N'
		SELECT @flagPartition = 0
		Select @edition = PropertyValue  from WFSystemPropertiesTable where PropertyKey = 'DBEDITION'
		SELECT @v_rowcount = @@ROWCOUNT
		/*IF (@edition = 'Enterprise Edition (64-bit)')
		Begin
			SELECT @flagPartition = 1
		End
		ELSE
		Begin
			Select @edition = convert(nvarchar(50), SERVERPROPERTY('edition'))
			IF (@edition = 'Enterprise Edition (64-bit)')
			Begin
				SELECT @flagPartition = 1
			End
			IF (@v_rowcount <= 0) 
			BEGIN
				insert into WFSystemPropertiesTable values ('DBEDITION',@edition)
			END
		End */
		
		select @v_existingProcessString = '0,'
		BEGIN TRANSACTION  MetaDataTran
			EXEC WFMigrateProcessData @v_sourceCabinet, @v_targetCabinet, @dblinkString, @v_overRideCabinetData,@v_executionLogId,@v_moveTaskData
			IF(@@error <> 0)
			BEGIN
				ROLLBACK TRANSACTION MetaDataTran
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,'Error in calling stored procedure WFMigrateProcessData')
				RETURN
			END
			
			If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and name = 'WFMETADATATABLELIST')
			Begin
				SELECT @v_query = 'DROP TABLE ' + @v_targetCabinet + '..WFMETADATATABLELIST'
				EXECUTE(@v_query)
			
				Print 'TABLE WFMETADATATABLELIST already exists, hence older one dropped ..... '
			End
			
			SELECT @v_query = 'CREATE TABLE ' + @v_targetCabinet + '..WFMETADATATABLELIST (
									tableId                  INT IDENTITY (1, 1) PRIMARY KEY, 
									tableName                VARCHAR(256),
									isVariantTableFlag       VARCHAR(1),
									dataMigrationSuccessful  VARCHAR(1),
									hasIdentityColumn       VARCHAR(1)
								)'
			EXECUTE(@v_query)
				
			EXEC WFPopulateMetaData @v_targetCabinet,@v_moveTaskData
			IF(@@error <> 0)
			BEGIN
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,'Error in calling stored procedure WFPopulateMetaData')
				ROLLBACK TRANSACTION MetaDataTran
				RETURN
			END
			
			SELECT @v_query = 'SELECT PROCESSDEFID FROM PROCESSDEFTABLE WITH (NOLOCK) '
			EXECUTE( ' DECLARE  v_processdefidCusrsor CURSOR FAST_FORWARD FOR ' + @v_query)
			
			IF(@@error <> 0)
			BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,'Error in executing v_processdefidCusrsor cursor query')
					CLOSE v_processdefidCusrsor 
					DEALLOCATE v_processdefidCusrsor 
					--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
					ROLLBACK TRANSACTION MetaDataTran
					RETURN
			END
			
			OPEN v_processdefidCusrsor
			
			IF(@@error <> 0)
			BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,'[WFMigrateMetaData] Error in opening v_processdefidCusrsor cursor ')
					CLOSE v_processdefidCusrsor 
					DEALLOCATE v_processdefidCusrsor 
					--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
					ROLLBACK TRANSACTION MetaDataTran
					RETURN
			END
			
			FETCH NEXT FROM v_processdefidCusrsor INTO @v_existingProcessDefId
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,'Error in fetching data FROM v_processdefidCusrsor cursor ')
				CLOSE v_processdefidCusrsor 
				DEALLOCATE v_processdefidCusrsor 
				--RAISERROR('Error in WFMigrateVariantMetaData Error in fetching data FROM processVariantCursor cursor', 16, 1) 
				ROLLBACK TRANSACTION MetaDataTran
				RETURN
			End 
			
			WHILE(@@FETCH_STATUS <> -1) 
			BEGIN 
				IF (@@FETCH_STATUS <> -2) 
				BEGIN
					SELECT @v_existingProcessString = @v_existingProcessString + CONVERT (NVARCHAR(10), @v_existingProcessDefId ) + ','
				END
				
				FETCH NEXT FROM v_processdefidCusrsor INTO @v_existingProcessDefId
				
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching data from v_processdefidCusrsor cursor')
					CLOSE v_processdefidCusrsor 
					DEALLOCATE v_processdefidCusrsor 
					ROLLBACK TRANSACTION MetaDataTran
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
				End	
				
			END  ----------END WHILE

			CLOSE v_processdefidCusrsor 
			DEALLOCATE v_processdefidCusrsor 
			
			SET @v_existingProcessString = LEFT(@v_existingProcessString, LEN(@v_existingProcessString) - 1)
			
			SELECT @v_query = 'SELECT tableName , hasIdentityColumn FROM ' + @v_targetCabinet + '..WFMETADATATABLELIST WITH (NOLOCK) where isVariantTableFlag=''N'''
			
			DECLARE meta_data_cursor  CURSOR FAST_FORWARD FOR Select ProcessDefId,ProcessVariantID From @tableVariableMap
			IF(@@error <> 0)
			Begin
					--PRINT ' [WFMigrateMetaData] Error in declaring meta_data_cursor'
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' Error in declaring meta_data_cursor')
					CLOSE meta_data_cursor 
					DEALLOCATE meta_data_cursor 
					ROLLBACK TRANSACTION MetaDataTran
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
			End	
			
			OPEN meta_data_cursor
			
			IF(@@error <> 0)
			Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in opening meta_data_cursor')
					CLOSE meta_data_cursor 
					DEALLOCATE meta_data_cursor 
					ROLLBACK TRANSACTION MetaDataTran
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
			End	
			
			FETCH NEXT FROM meta_data_cursor INTO @v_processDefId,@v_variantId
			
			IF(@@error <> 0)
			Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from  meta_data_cursor')
					CLOSE meta_data_cursor 
					DEALLOCATE meta_data_cursor 
					ROLLBACK TRANSACTION MetaDataTran
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
			End	
			
			WHILE @@FETCH_STATUS = 0 ---------------START OUTER WHILE
			BEGIN
				PRINT 'ProcessDefID is ' + CONVERT(NVARCHAR(10),@v_processDefId) + ' ProcessVariantId is ' + CONVERT(NVARCHAR(10),@v_variantId)
				IF( @v_migrateAllData = 'N')
				BEGIN
				
					SELECT @v_query2 = ' SELECT @value =  PROCESSTYPE FROM ' + @dblinkString+ '.PROCESSDEFTABLE WITH (NOLOCK) WHERE PROCESSDEFID = ' + CONVERT(NVarchar(10),@v_processdefid)
					SELECT @v_queryParameter = '@value  NVARCHAR(1) OUTPUT'
					EXEC sp_executesql @v_query2, @v_queryParameter, @value = @v_processType OUTPUT
					
					SELECT @v_migratedflag = 0
					SELECT @v_migratedflag = 1 FROM PROCESSDEFTABLE WHERE PROCESSDEFID = @v_processdefid	
					IF(@v_migratedflag = 1)
					BEGIN
						IF(@v_copyForceFully ='N')
						BEGIN
							PRINT('Process Already exists on the target cabinet')
							IF(@v_processType = 'M')
							BEGIN
								EXEC WFMigrateVariantMetaData @v_sourceCabinet, @v_targetCabinet, @dblinkString,@v_processDefId,@v_variantId,@v_migrateAllData,@v_copyForceFully,@v_executionLogId
							END
							
							FETCH NEXT FROM meta_data_cursor INTO @v_processDefId,@v_variantId
							IF(@@error <> 0)
							Begin
									--PRINT ' [WFMigrateMetaData] Error in fetching from  meta_data_cursor'
									INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from  meta_data_cursor')
									CLOSE meta_data_cursor 
									DEALLOCATE meta_data_cursor 
									--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
									ROLLBACK TRANSACTION MetaDataTran
									RETURN
							End	
							CONTINUE
						END
					END
				END
				
				IF(@v_migratedflag = 1) 
				BEGIN
					PRINT 'PROCESS ALREADY MIGRATED'
				END
				ELSE -------------process not migrated
				BEGIN
				
					IF(@v_migrateAllData='N')
					BEGIN
						SELECT @v_existsflag = 0
						SELECT @v_query2 = ' SELECT @value =  1 FROM ' + @dblinkString+ '.PROCESSDEFTABLE WITH (NOLOCK)  WHERE PROCESSDEFID = ' + CONVERT(NVarchar(10),@v_processdefid)
						SELECT @v_queryParameter = '@value  INT OUTPUT'
						EXEC sp_executesql @v_query2, @v_queryParameter, @value = @v_existsflag OUTPUT
					
						IF ( @v_existsflag = 0)
						BEGIN
							PRINT 'PROCESS DOESN''T EXISTS ON SOURCE CABINET '
							FETCH NEXT FROM meta_data_cursor INTO @v_processDefId,@v_variantId
							IF(@@error <> 0)
							Begin
								INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from  meta_data_cursor')
								CLOSE meta_data_cursor 
								DEALLOCATE meta_data_cursor 
								--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
								ROLLBACK TRANSACTION MetaDataTran
								RETURN
							End	
							CONTINUE
						END
					END
					
					EXECUTE( ' DECLARE v_TableNameCursor CURSOR  FAST_FORWARD FOR ' + @v_query)
					IF(@@error <> 0)
					BEGIN
						--PRINT ' [WFMigrateMetaData] Error in declaring v_TableNameCursor cursor query'
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in declaring v_TableNameCursor cursor query')
						ROLLBACK TRANSACTION MetaDataTran
						CLOSE v_TableNameCursor 
						DEALLOCATE v_TableNameCursor 
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						RETURN
					END
					
					OPEN v_TableNameCursor
					
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in opening v_TableNameCursor cursor query')
						CLOSE v_TableNameCursor 
						DEALLOCATE v_TableNameCursor 
						ROLLBACK TRANSACTION MetaDataTran
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						RETURN
					END
					
					FETCH NEXT FROM v_TableNameCursor INTO @v_tableName , @v_hasIdentityColumn
					
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from v_TableNameCursor cursor query')
						CLOSE v_TableNameCursor 
						DEALLOCATE v_TableNameCursor 
						ROLLBACK TRANSACTION MetaDataTran
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						RETURN
					END
					
					WHILE(@@FETCH_STATUS <> -1) -------------START INNER WHILE
					BEGIN 
						IF (@@FETCH_STATUS <> -2) 
						BEGIN 	
							IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
							BEGIN
								IF @v_tableName = 'RouteFolderDefTable'
								BEGIN
									Select @flagCheck2 = 'Y'
									Select @flagCheck = ScratchFolderId  from RouteFolderDefTable where PROCESSDEFID =@v_processdefid
									IF @flagCheck = 'Y'
									BEGIN
									FETCH NEXT FROM v_TableNameCursor INTO @v_tableName , @v_hasIdentityColumn
									CONTINUE;
									END
								END
								EXEC WFMoveMetaData @v_sourceCabinet, @v_targetCabinet, @v_tableName, @v_processdefid,@dblinkString,@v_migrateAllData,@v_copyForcefully,@v_existingProcessString,@v_hasIdentityColumn,@v_executionLogId
								IF (@flagCheck2 = 'Y' AND @v_tableName = 'RouteFolderDefTable')
								BEGIN
									Update RouteFolderDefTable set ScratchFolderId ='Y' where PROCESSDEFID =@v_processdefid
								END
							END
							
							IF(@@error <> 0)
							BEGIN
								INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in executing WFMoveMetaData')
								CLOSE v_TableNameCursor 
								DEALLOCATE v_TableNameCursor 
								ROLLBACK TRANSACTION MetaDataTran
								--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
								RETURN
							END
							
						END
						
						FETCH NEXT FROM v_TableNameCursor INTO @v_tableName , @v_hasIdentityColumn
						IF(@@error <> 0)
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from v_TableNameCursor')
							CLOSE v_TableNameCursor 
							DEALLOCATE v_TableNameCursor 
							ROLLBACK TRANSACTION MetaDataTran
							--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
							RETURN
						END
					END------------------------------------------END INNER WHILE
					
					CLOSE v_TableNameCursor 
					DEALLOCATE v_TableNameCursor 
					
					print('going to execute WFMoveQueueData---')
					EXEC WFMoveQueueData @v_sourceCabinet, @v_targetCabinet, @v_processdefid,@dblinkString,@v_migrateAllData,@v_copyForcefully,@v_existingProcessString,@v_executionLogId
					
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in executing WFMoveQueueData')
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						ROLLBACK TRANSACTION MetaDataTran
						RETURN
					END
					
					EXEC WFMoveOmnidocsFolderData @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_processdefid,@v_migrateAllData,@v_copyForceFully,@v_existingProcessString,@v_DeleteFromSrc,@v_executionLogId
					
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0, ' [WFMigrateMetaData] Error in executing WFMoveOmnidocsFolderData')
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						ROLLBACK TRANSACTION MetaDataTran
						RETURN
					END
					
					PRINT 'Metadata successfully migrated for ProcessDefId ' + CONVERT(NVARCHAR(10),@v_processdefid)
					 
					EXEC WFExportExternalTable @v_sourceCabinet, @v_targetCabinet, @dblinkString, @v_processDefId, @v_migrateAllData , @v_executionLogId
					IF(@v_moveTaskData = 'Y') 
						BEGIN
							EXEC WFExportTaskTables @v_sourceCabinet, @v_targetCabinet, @dblinkString, @v_processDefId, @v_migrateAllData , @v_executionLogId,'N'
						END
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) values (@v_executionLogId,current_timestamp,0, ' [WFMigrateMetaData] Error in executing WFExportExternalTable')
						--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
						ROLLBACK TRANSACTION MetaDataTran
						RETURN
					END
					
					IF(@v_processType = 'M')
					BEGIN
						EXEC WFMigrateVariantMetaData @v_sourceCabinet, @v_targetCabinet, @dblinkString, @v_processDefId, @v_VariantId, @v_migrateAllData, @v_copyForceFully,@v_executionLogId
						IF(@@error <> 0)
						BEGIN
							--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in executing WFMigrateVariantMetaData')
							ROLLBACK TRANSACTION MetaDataTran
							RETURN
						END
					END
					
						
				END -------------process not migrated
				
				-- create partitions for the processdefid and processvariant id that has been migrated 
				
				/*IF (@flagPartition = 1)
				BEGIN
					EXEC WFCreatePartitions @v_processDefId,@v_variantId
				END
				IF(@@error <> 0)
				Begin
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,'error in execution of WFCreatePartitions')
					CLOSE meta_data_cursor 
					DEALLOCATE meta_data_cursor 
					ROLLBACK TRANSACTION MetaDataTran
					--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
					RETURN
				
				End
				*/
				FETCH NEXT FROM meta_data_cursor INTO @v_processDefId,@v_variantId
				IF(@@error <> 0)
				Begin
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateMetaData] Error in fetching from  meta_data_cursor')
						CLOSE meta_data_cursor 
						DEALLOCATE meta_data_cursor 
						--RAISERROR('Error in WFMigrateVariantMetaData Error in opening processVariantCursor cursor', 16, 1) 
						ROLLBACK TRANSACTION MetaDataTran
						RETURN
				End	
			END----------------END OUTER WHILE
			CLOSE meta_data_cursor 
			DEALLOCATE meta_data_cursor
			
			INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,0,NULL,'WFMigrate Meta Data Executed Succssfully')
			COMMIT TRANSACTION MetaDataTran
	END

	