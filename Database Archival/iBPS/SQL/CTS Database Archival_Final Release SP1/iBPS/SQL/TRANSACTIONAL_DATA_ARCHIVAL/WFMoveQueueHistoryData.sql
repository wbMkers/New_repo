	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveQueueHistoryData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Move Queue History Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveQueueHistoryData')
	Begin
		Execute('DROP PROCEDURE WFMoveQueueHistoryData')
		Print 'Procedure WFMoveQueueHistoryData already exists, hence older one dropped ..... '
	End

	~

	create Procedure WFMoveQueueHistoryData
	(	 
		@v_sourceCabinet      		VARCHAR(256),
		@v_targetCabinet      		VARCHAR(256),
		@dblinkString          		VARCHAR(256),
		@tableVariableMap 			Process_Variant_Type READONLY,
		@v_migrateAllProcesses		VARCHAR(1),
		@v_fromDate           		VARCHAR(256),
		@v_toDate			 		VARCHAR(256),
		@v_batchSize				INT,
		@v_moveAuditTrailData 		VARCHAR(1),
		--@v_moveExternalTableData 	VARCHAR(1),
		--@v_moveComplexTableData		VARCHAR(1)	
		@v_moveExtData				VARCHAR(1),
		@v_DeleteFromSrc			VARCHAR(1),
		@v_moveTaskData				VARCHAR(1),
		@executionLogId				INT
		)

	AS

	BEGIN
		DECLARE @v_processDefId 			INT
		DECLARE @v_variantId    			INT
		DECLARE @v_variantName 				VARCHAR(400)
		DECLARE @v_variantTableName     	VARCHAR(400)
		DECLARE @v_processInstanceId		NVARCHAR(63)
		DECLARE @v_folderIndex				NVARCHAR(255)
		DECLARE @v_workItemId				INT	
		DECLARE @v_lastWorkItemId			INT
		DECLARE @v_localTableVariableMap	AS Process_Variant_Type
		DECLARE @v_query					NVARCHAR(2000)
		DECLARE @v_queryStr					NVARCHAR(2000)
		DECLARE @v_externalTable			NVARCHAR(50)
		DECLARE @v_externalTableCount		INT
		DECLARE @v_externalTableHistory 	NVARCHAR(256)
		DECLARE @v_externalTableHistoryCount INT
		DECLARE @v_itemIndex				INT
		DECLARE @existsFlag					INT
		DECLARE @v_folderStatus				INT
		DECLARE @variantFilterString		NVARCHAR(256)
		DECLARE @v_tableName				VARCHAR(50)
		DECLARE @v_genIndex					INT
		DECLARE @newFolderIndex				INT
		DECLARE @v_queryParam				INT
		DECLARE @v_rowCounter				INT
		DECLARE @v_queryParameter  			NVARCHAR(256)
		DECLARE @v_CountQuery				NVARCHAR(2000)
		DECLARE @rowCount					INT
		DECLARE @v_lastProcessInstanceId	NVARCHAR(256)
		DECLARE @v_firstProcessInstanceId	NVARCHAR(256)
		
		
		IF(@v_migrateAllProcesses='Y')
		BEGIN
			--SELECT @variantFilterString = ''
			SELECT @v_query = 'SELECT ProcessDefId from ProcessDefTable'
			EXECUTE('DECLARE v_processCursor CURSOR  FAST_FORWARD for ' + @v_query)
		
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveQueueHistoryData] Error in executing v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
		
			OPEN v_processCursor
		
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveQueueHistoryData] Error in opening v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
		
			FETCH NEXT FROM v_processCursor INTO @v_processDefId
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveQueueHistoryData] Error in fetchong from  v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
			WHILE( @@FETCH_STATUS <> -1 ) 
			BEGIN
				IF( @@FETCH_STATUS <> -2 )
				BEGIN
					--insert into  @v_localTableVariableMap (ProcessDefid,ProcessVariantID) values (  CONVERT(NVarchar(10),@v_processdefid) , -1)
					insert into  @v_localTableVariableMap (ProcessDefid,ProcessVariantID) values (  CONVERT(NVarchar(10),@v_processdefid) , 0)

				END
				FETCH NEXT FROM v_processCursor INTO @v_processDefId
				IF(@@error <> 0)
				BEGIN
					PRINT ' [] Error in fetchong from  v_processCursor cursor query'
					CLOSE v_processCursor 
					DEALLOCATE v_processCursor 
					--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
					RETURN
				END
			END
			CLOSE v_processCursor 
			DEALLOCATE v_processCursor 
		END
		ELSE
		BEGIN
			--SELECT @variantFilterString = 'AND PROCESSVARIANTID = '
			INSERT INTO @v_localTableVariableMap SELECT * FROM @tableVariableMap
		END
		
		Declare tableVarCursor  CURSOR FAST_FORWARD FOR Select ProcessDefId,ProcessVariantID From @v_localTableVariableMap
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveQueueHistoryData] Error in declaring tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor 
			--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		Open tableVarCursor
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveQueueHistoryData] Error in opening tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor
			--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		--IF(@v_migrateAllProcesses = 'N')
		--BEGIN
			 --SELECT @variantFilterString =  @variantFilterString + CONVERT(NVARCHAR(10),@v_variantId)
		--END
		
		FETCH NEXT FROM tableVarCursor INTO @v_processDefId , @v_variantId
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveQueueHistoryData] Error in fetching from tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor 
			--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		WHILE(@@FETCH_STATUS <> -1) ---------------------OUTERMOST WHILE BEGIN
		BEGIN
			IF (@@FETCH_STATUS <> -2) -------------------------OUTERMOST IF BEGIN
			BEGIN
				PRINT 'ProcessDefId ----' +  CONVERT(NVarchar(10),@v_ProcessDefId) + 'ProcessVariantID ----' + CONVERT(NVarchar(10),@v_variantId)
				SELECT @v_externalTable = ''
				IF( ( @v_variantId = 0 ) AND ( @v_moveExtData = 'Y' ))
				BEGIN
					SELECT @v_query = 'SELECT @value =   TABLENAME FROM ' + @dblinkString + '.EXTDBCONFTABLE WHERE PROCESSDEFID = ' +  CONVERT(NVarchar(10),@v_ProcessDefId) + 'AND EXTOBJID = 1' 
					SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
					EXEC sp_executesql @v_query, @v_queryParameter, @value = @v_externalTable OUTPUT
					
					IF( @v_externalTable <> '')
					BEGIN
						SELECT @v_externalTableCount = 1
						SELECT @v_externalTableHistory = @v_externalTable + '_HISTORY'
						
						IF EXISTS (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and UPPER(name) = UPPER(@v_externalTableHistory))
						BEGIN
							SELECT @v_externalTableHistoryCount = 1
						END
						ELSE
						BEGIN
							SELECT @v_externalTableHistory = ''
							SELECT @v_externalTableHistoryCount = 0
						END
					END
					ELSE
					BEGIN
						SELECT @v_externalTableCount = 0
						SELECT @v_externalTable = ''
					END
				END
			
				IF( @v_variantId  = 0 )
				BEGIN
					SELECT @variantFilterString = ''
				END
				ELSE
				BEGIN
					SELECT @variantFilterString = 'AND A.PROCESSVARIANTID = ' + CONVERT(NVarchar(10),@v_variantId)
					
				END
				
				WHILE(1 = 1)---------------------------------------WHILE (1=1) BEGINS
				BEGIN
					SELECT @v_query = 'SELECT TOP ' + CONVERT (NVARCHAR(10),@v_batchSize) +' A.PROCESSINSTANCEID , A.VAR_REC_1 FROM ' + @dblinkString + '.' + 'QUEUEHISTORYTABLE A WITH (NOLOCK)  WHERE A.PROCESSDEFID = ' + CONVERT (NVARCHAR(10),@v_ProcessDefId) + @variantFilterString + 
					' AND A.CREATEDDATETIME > CONVERT(DATETIME, ' + '''' + @v_fromDate + '''' + ')'+' AND  A.CREATEDDATETIME < CONVERT( DATETIME,' + '''' + @v_toDate + +''''+')
					   ORDER BY PROCESSINSTANCEID '
					
					PRINT @v_query
					--------------Storing no of instances fetched from batch in  v_rowCounter --------
					SELECT @v_CountQuery = ' SELECT @value = COUNT (*) FROM  ( ' + @v_query + ')b'
					SELECT @v_queryParameter = '@value INT OUTPUT'
					EXEC sp_executesql @v_CountQuery, @v_queryParameter, @value = @v_rowCounter OUTPUT
					
					EXECUTE ('DECLARE v_qhtcursor CURSOR FAST_FORWARD FOR ' + @v_query)
					IF(@@error <> 0)
					Begin
						PRINT ' [WFMoveTransData] Error in declaring v_qhtcursor cursor query'
						INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,null , @v_query)
						CLOSE v_qhtcursor 
						DEALLOCATE v_qhtcursor 
						--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
		
					OPEN v_qhtcursor
					IF(@@error <> 0)
					Begin
						PRINT ' [WFMoveQueueHistoryData] Error in opening v_qhtcursor cursor query'
						CLOSE v_qhtcursor 
						DEALLOCATE v_qhtcursor 
						--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
					
					FETCH NEXT FROM v_qhtcursor INTO @v_processInstanceId,@v_folderIndex
					
					IF(@@error <> 0)
					Begin
						PRINT ' [WFMoveQueueHistoryData] Error in opening v_qhtcursor cursor query'
						CLOSE v_qhtcursor 
						DEALLOCATE v_qhtcursor 
						--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
					
					--------COPYING DATA FOR A BATCH AND COMMITING IT ------------
					SELECT @rowCount = 1
					BEGIN TRANSACTION MOVE_QUEUE_HISTORY_DATA ------------------------------Move Trans Data Begins Here
						WHILE(@@FETCH_STATUS <> -1) --------------2nd while
						BEGIN
							IF (@@FETCH_STATUS <> -2) ------------------------IF INSIDE 2ND WHILE
							BEGIN
									IF( @v_folderIndex = NULL )
									BEGIN
										--  v_lastInstanceId:=v_processInstanceId;
										CONTINUE
									END 
									--IF(@v_firstProcessInstanceId = '') 
									--BEGIN
										--SELECT @v_firstProcessInstanceId = @v_processInstanceId;
									--END 
									
									IF(@rowCount = 1)
									BEGIN
										SELECT @v_firstProcessInstanceId = @v_processInstanceId
									END
									ELSE IF(@rowCount = @v_batchSize)
									BEGIN
										SELECT @v_lastProcessInstanceId = @v_processInstanceId
									END
									
									SELECT @v_query = 'Insert into QUEUEHISTORYTABLE Select * from ' +  @dblinkString + '.QUEUEHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'QUEUEHISTORYTABLE where processinstanceid = ' + ''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									
									SELECT @v_query = 'Insert into TODOSTATUSHISTORYTABLE Select * from ' +  @dblinkString + '.TODOSTATUSHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' TODOSTATUSHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									
									SELECT @v_query = 'Insert into EXCEPTIONHISTORYTABLE Select * from ' +  @dblinkString + '.EXCEPTIONHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' EXCEPTIONHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									END
									
									/* Adding changes for archival task */
									
									IF( UPPER(@v_moveTaskData) = 'Y')
									BEGIN
										SELECT @v_query = 'Insert into WFTASKSTATUSHISTORYTABLE Select * from ' +  @dblinkString + '.WFTASKSTATUSHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
										
										SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' WFTASKSTATUSHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
									
										SELECT @v_query = 'Insert into WFRTTASKINTFCASSOCHISTORY Select * from ' +  @dblinkString + '.WFRTTASKINTFCASSOCHISTORY where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
										
										SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' WFRTTASKINTFCASSOCHISTORY where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
									
										SELECT @v_query = 'Insert into RTACTIVITYINTFCASSOCHISTORY Select * from ' +  @dblinkString + '.RTACTIVITYINTFCASSOCHISTORY where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
										
										SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' RTACTIVITYINTFCASSOCHISTORY where processinstanceid = '+''''+ @v_processInstanceId + ''''									
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
											CLOSE v_qhtcursor 
											DEALLOCATE v_qhtcursor 
											ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										END
									END
									
									/* Adding changes for archival task ends here */
		
									IF(( ( @v_variantId = 0 ) OR ( @v_variantId = -1 ) ) AND ( @v_moveExtData = 'Y'))
									BEGIN
										IF( @v_externalTableCount > 0 )
										BEGIN
											SELECT @v_query = 'INSERT INTO ' + @v_externalTable + ' SELECT * FROM ' + @dblinkString + '.' + @v_externalTable + ' WHERE ITEMINDEX = ' + @v_folderIndex
											--Insert into WFMigrationLogTable values (@executionLogId,getdate(), 'INsert query for external table : ' + @v_query)
											EXECUTE(@v_query)
											
											IF (@@error <> 0)
											BEGIN
												INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
												CLOSE v_qhtcursor 
												DEALLOCATE v_qhtcursor 
												ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
											END
									
											SELECT @v_query = 'DELETE FROM ' +  @dblinkString + '.' + @v_externalTable + ' WHERE ITEMINDEX = ' + @v_folderIndex
											EXECUTE(@v_query)
											
											IF (@@error <> 0)
											BEGIN
												INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
												CLOSE v_qhtcursor 
												DEALLOCATE v_qhtcursor 
												ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
											END
											
										END
										
										/* Adding logic to move external history tables */
										IF ( @v_externalTableHistoryCount > 0)
										BEGIN
											SELECT @v_query = 'INSERT INTO ' + @v_externalTableHistory + ' SELECT * FROM ' + @dblinkString + '.' + @v_externalTableHistory + ' WHERE ITEMINDEX = ' + @v_folderIndex
											--Insert into WFMigrationLogTable values (@executionLogId,getdate(), 'INsert query for external history table : ' + @v_query)
											EXECUTE(@v_query)
											
											IF (@@error <> 0)
											BEGIN
												INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
												CLOSE v_qhtcursor 
												DEALLOCATE v_qhtcursor 
												ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
											END
									
											SELECT @v_query = 'DELETE FROM ' +  @dblinkString + '.' + @v_externalTableHistory + ' WHERE ITEMINDEX = ' + @v_folderIndex
											EXECUTE(@v_query)
											
											IF (@@error <> 0)
											BEGIN
												INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
												CLOSE v_qhtcursor 
												DEALLOCATE v_qhtcursor 
												ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
											END	
										END
										/* Adding external logic ends here */
									END
									
									IF(@v_moveExtData='Y') 
									BEGIN
										EXEC WFMoveComplexData @v_processInstanceId,@v_processDefId,@v_variantId,@v_sourceCabinet,@v_targetCabinet,@dblinkString,'Y',@executionLogId
									END
									
									IF( (@v_moveAuditTrailData != 'N') AND (@v_moveAuditTrailData != 'n') )
									BEGIN
										EXEC WFMoveHistoryAuditTrailData @v_processInstanceId,@v_processDefId,@v_sourceCabinet,@v_targetCabinet,@dblinkString,@v_fromDate,@v_toDate,@executionLogId
									END
									IF(@@error <> 0)
									Begin
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveQueueHistoryData] Error in execution of  WFMoveHistoryAuditTrailData')
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_folderIndex,'Y','N',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
									IF(@@error <> 0)
									Begin
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId ,  ' [WFMoveQueueHistoryData] Error in execution of  MoveDocdb')
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									IF (@v_folderStatus <> 0) 
									BEGIN
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId ,  'ERROR CODE WHILE MIGRTAING FOLDER ' + @v_folderIndex + 'IS' + @v_folderStatus)
										CLOSE v_qhtcursor 
										DEALLOCATE v_qhtcursor 
										ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
										RETURN
									END
									
							END ----------------------------------------------IF INSIDE 2ND WHILE
							
							FETCH NEXT FROM v_qhtcursor INTO @v_processInstanceId,@v_folderIndex
							IF(@@error <> 0)
								Begin
									INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId ,  ' [WFMoveQueueHistoryData] Error in opening v_qhtcursor cursor query')
									CLOSE v_qhtcursor 
									DEALLOCATE v_qhtcursor 
									ROLLBACK TRANSACTION MOVE_QUEUE_HISTORY_DATA
									--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
									RETURN
								End
							SELECT @rowCount = @rowCount + 1
						END---------------------------------------End 2nd while
						
					INSERT INTO WFTxnDataMigrationProgressLog VALUES(@executionLogId , GETDATE() , @v_ProcessDefId, @v_firstProcessInstanceId ,@v_lastProcessInstanceId)
					
					COMMIT TRANSACTION MOVE_QUEUE_HISTORY_DATA ------------------------------Move Trans Data COMMITS Here
					
					CLOSE v_qhtcursor  -----------not present in oracle sp
					DEALLOCATE v_qhtcursor 
					
					IF(@v_rowCounter=0) 
					BEGIN
						--EXIT
						BREAK
					END
					
				END---------------------------------------WHILE (1=1) endS
				
			END -------------------------OUTERMOST IF ENDS
			
			PRINT 'WFMoveQueueHistoryData execoted successfully for processdefid --' + CONVERT(VARCHAR(10),@v_processDefId)
			
			FETCH NEXT FROM tableVarCursor INTO  @v_processDefId , @v_variantId
			IF(@@error <> 0)
			BEGIN
				INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId ,  ' [WFMoveQueueHistoryData] Error in fetching from tableVarCursor cursor query')
				CLOSE tableVarCursor 
				DEALLOCATE tableVarCursor 
				--RAISERROR('Error in WFMoveQueueHistoryData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			END
			
			
		END ---------------------OUTERMOST WHILE ENDS
		CLOSE tableVarCursor
		DEALLOCATE tableVarCursor

	END