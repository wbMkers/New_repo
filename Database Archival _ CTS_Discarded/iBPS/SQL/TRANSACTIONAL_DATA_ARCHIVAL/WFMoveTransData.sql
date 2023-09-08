	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveTransData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Move Transactional Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	21/9/2017	Ambuj			Added the changes for Archiving the case management tables
	19/7/2019	Ambuj Tripathi	Multiple bugs fixed, Added support to skip deletion of External/history tables data.
	____________________________________________________________________________________*/
	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveTransData')
	Begin
		Execute('DROP PROCEDURE WFMoveTransData')
		Print 'Procedure WFMoveTransData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure WFMoveTransData
	(	 
		@v_sourceCabinet      			VARCHAR(256),
		@v_targetCabinet      			VARCHAR(256),
		@dblinkString          			VARCHAR(256),
		@tableVariableMap 				Process_Variant_Type READONLY,
		@v_migrateAllProcesses			VARCHAR(1),
		@v_fromDate           			VARCHAR(256),
		@v_toDate			 			VARCHAR(256),
		@v_batchSize					INT,
		@v_moveAuditTrailData 			VARCHAR(1),
		@v_moveFromHistoryData 			VARCHAR(1),
		--@v_moveExternalTableData 		VARCHAR(1),
		--@v_moveComplexTableData		VARCHAR(1)	
		@v_moveExtData					VARCHAR(1),
		@v_filterProcessInstanceState	VARCHAR(256),
		@v_DeleteFromSrc				VARCHAR(1),
		@executionLogId					INT,
		@v_moveTaskData        		VARCHAR(1),
		@v_deleteExtTabData			VARCHAR(1)		
		)

	AS

	BEGIN
		DECLARE @v_processDefId 			INT
		DECLARE @v_variantId				INT
		DECLARE @variantName				VARCHAR(256)
		DECLARE @v_variantTableName 		VARCHAR(256)
		DECLARE @v_processInstanceId 		NVARCHAR(256)
		DECLARE @v_folderIndex 				NVARCHAR(256)
		DECLARE @v_workItemId         		INT
		DECLARE @v_lastWorkItemId     		INT
		DECLARE @v_localTableVariableMap    AS Process_Variant_Type
		DECLARE @v_query              		NVARCHAR(4000)
		DECLARE @v_queryStr           		NVARCHAR(2000)
		DECLARE @v_externalTable      		VARCHAR(255)
		DECLARE @v_externalTableCount 		INT
		DECLARE @v_itemIndex          		INT
		DECLARE @existsFlag           		INT
		DECLARE @v_folderStatus       		INT
		DECLARE @v_tempQuery				NVARCHAR(1000)
		DECLARE @v_queryParameter  			NVARCHAR(256)
		DECLARE @v_queryParam  			    NVARCHAR(256)
		DECLARE @variantFilterString		NVARCHAR(256)
		DECLARE @v_tableName				VARCHAR(50)
		DECLARE @v_CountQuery				NVARCHAR(2000)
		DECLARE @v_firstProcessInstanceId	NVARCHAR(256)
		DECLARE @v_rowCounter				INT
		DECLARE @v_genIndex					INT
		DECLARE @newFolderIndex				INT
		DECLARE @rowCount					INT
		DECLARE @v_lastProcessInstanceId	NVARCHAR(256)
		DECLARE @colStr						VARCHAR(4000)
		DECLARE @v_count						INT
		DECLARE @v_colName 					NVARCHAR(4000)
		DECLARE @v_column 					NVARCHAR(100)

		IF(@v_migrateAllProcesses='Y')
		BEGIN
			SELECT @v_query = 'SELECT ProcessDefId from ProcessDefTable'
			EXECUTE('DECLARE v_processCursor CURSOR  FAST_FORWARD for ' + @v_query)
		
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveTransData] Error in executing v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
		
			OPEN v_processCursor
		
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveTransData] Error in opening v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
		
			FETCH NEXT FROM v_processCursor INTO @v_processDefId
			IF(@@error <> 0)
			Begin
				PRINT ' [WFMoveTransData] Error in fetchong from  v_processCursor cursor query'
				CLOSE v_processCursor 
				DEALLOCATE v_processCursor 
				--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			End
			WHILE( @@FETCH_STATUS <> -1 ) 
			BEGIN
				IF( @@FETCH_STATUS <> -2 )
				BEGIN
					insert into  @v_localTableVariableMap (ProcessDefid,ProcessVariantID) values (  CONVERT(NVarchar(10),@v_processdefid) , 0)
				END
				FETCH NEXT FROM v_processCursor INTO @v_processDefId
				IF(@@error <> 0)
				BEGIN
					PRINT ' [WFMoveTransData] Error in fetchong from  v_processCursor cursor query'
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
			INSERT INTO @v_localTableVariableMap SELECT * FROM @tableVariableMap
		END
		
		
		Declare tableVarCursor  CURSOR FAST_FORWARD FOR Select ProcessDefId,ProcessVariantID From @v_localTableVariableMap
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveTransData] Error in declaring tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor 
			--ROLLBACK TRANSACTION MOVE_TRANS_DATA
			--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		Open tableVarCursor
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveTransData] Error in opening tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor
			--ROLLBACK TRANSACTION MOVE_TRANS_DATA
			--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		FETCH NEXT FROM tableVarCursor INTO @v_processDefId , @v_variantId
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMoveTransData] Error in fetching from tableVarCursor cursor query'
			CLOSE tableVarCursor 
			DEALLOCATE tableVarCursor 
			--ROLLBACK TRANSACTION MOVE_TRANS_DATA
			--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		End
		
		WHILE(@@FETCH_STATUS <> -1) ---------------------OUTERMOST WHILE BEGIN
		BEGIN
			IF (@@FETCH_STATUS <> -2) -------------------------OUTERMOST IF BEGIN
			BEGIN
				PRINT 'ProcessDefId ----' +  CONVERT(NVarchar(10),@v_ProcessDefId) + ', ProcessVariantID ----' + CONVERT(NVarchar(10),@v_variantId)
				SELECT @v_externalTable = ''
				IF( ( @v_variantId = 0 ) AND ( @v_moveExtData = 'Y' ))
				BEGIN
					SELECT @v_query = 'SELECT @value =   TABLENAME FROM ' + @dblinkString + '.EXTDBCONFTABLE WHERE PROCESSDEFID = ' +  CONVERT(NVarchar(10),@v_ProcessDefId) + 'AND EXTOBJID = 1' 
					SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
					EXEC sp_executesql @v_query, @v_queryParameter, @value = @v_externalTable OUTPUT
					
					SELECT @v_query = ' SELECT @value = COUNT(TABLENAME) FROM ' + @dblinkString + '.EXTDBCONFTABLE  WHERE PROCESSDEFID = ' +  CONVERT(NVarchar(10),@v_ProcessDefId) + 'AND EXTOBJID = 1'
					SELECT @v_queryParam = '@value INT OUTPUT'
					EXEC sp_executesql @v_query, @v_queryParam, @value = @v_externalTableCount OUTPUT
				END
				
				IF( @v_variantId  = 0 )
				BEGIN
					SELECT @variantFilterString = ''
				END
				ELSE
				BEGIN
					SELECT @variantFilterString = ' AND A.PROCESSVARIANTID = ' + CONVERT(NVarchar(10),@v_variantId)
				END
				
				WHILE(1 = 1)---------------------------------------WHILE (1=1) BEGINS
				BEGIN
					
					SELECT @v_query = 'SELECT TOP ' + CONVERT (NVARCHAR(10),@v_batchSize) +' A.PROCESSINSTANCEID , A.VAR_REC_1 FROM ' + @dblinkString + '.' + 'WFINSTRUMENTTABLE A WITH (NOLOCK)  WHERE A.PROCESSDEFID = ' + CONVERT (NVARCHAR(10),@v_ProcessDefId) + @variantFilterString + 
					' AND A.CREATEDDATETIME > CONVERT(DATETIME, ' + '''' + @v_fromDate + '''' + ')'+' AND  A.CREATEDDATETIME < CONVERT( DATETIME,' + '''' + @v_toDate + +''''+')
					 AND ' + @v_filterProcessInstanceState + ' ORDER BY PROCESSINSTANCEID '

					 --------------Storing no of instances fetched from batch in  v_rowCounter --------
					SELECT @v_CountQuery = ' SELECT @value = COUNT (*) FROM  ( ' + @v_query + ')b'
					SELECT @v_queryParam = '@value INT OUTPUT'
					EXEC sp_executesql @v_CountQuery, @v_queryParam, @value = @v_rowCounter OUTPUT
					
					IF(@v_rowCounter=0) 
					BEGIN
						BREAK
					END

					EXECUTE ('DECLARE v_cursor CURSOR FAST_FORWARD FOR ' + @v_query)
					IF(@@error <> 0)
					Begin
						PRINT ' [WFMoveTransData] Error in declaring v_cursor cursor query'
						CLOSE v_cursor 
						DEALLOCATE v_cursor 
						--ROLLBACK TRANSACTION MOVE_TRANS_DATA
						--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
		
					OPEN v_cursor
					IF(@@error <> 0)
					Begin
						INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData]Error in opening v_cursor cursor query')
						CLOSE v_cursor 
						DEALLOCATE v_cursor 
						--ROLLBACK TRANSACTION MOVE_TRANS_DATA
						--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
					
					FETCH NEXT FROM v_cursor INTO @v_processInstanceId,@v_folderIndex
					
					IF(@@error <> 0)
					Begin
						INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error IS in opening v_cursor cursor query')
						CLOSE v_cursor 
						DEALLOCATE v_cursor 
						--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
						RETURN
					End
					
					--------COPYING DATA FOR A BATCH AND COMMITING IT ------------
					
					SELECT @rowCount = 1
					BEGIN TRANSACTION MOVE_TRANS_DATA ------------------------------Move Trans Data Begins Here
						WHILE(@@FETCH_STATUS <> -1) --------------2nd while
						BEGIN
							IF (@@FETCH_STATUS <> -2) ------------------------IF INSIDE 2ND WHILE
							BEGIN	
									IF( @v_folderIndex = NULL )
									BEGIN
										--  v_lastInstanceId:=v_processInstanceId
										CONTINUE
									END 
									
									IF(@rowCount = 1)
									BEGIN
										SELECT @v_firstProcessInstanceId = @v_processInstanceId
									END
									ELSE IF(@rowCount = @v_batchSize)
									BEGIN
										SELECT @v_lastProcessInstanceId = @v_processInstanceId
									END

									/*Changes for moving data from WFINSTRUMENTTABLE to QUEUEHISTORYTABLE starts from here */
									--Steps : Get the common columns
									--Instert into the queuehistory table from wfinstruments table for the common columns 
									
									SELECT @v_query = 'INSERT INTO WFTxnDataMigrationLogTable (executionLogId, ProcessDefId, ProcessInstanceId, Status,ActionStartDateTime)
									VALUES (' + cast(@executionLogId as varchar(10)) + ',' +  cast(@v_ProcessDefId as varchar(10)) + ',''' + @v_processInstanceId + ''',''S'',''' +  CONVERT(VARCHAR(23), GETDATE(), 121) + ''')'
									
									EXECUTE(@v_query)
									IF(@@error <> 0)
									Begin
										PRINT ' [WFMoveTransData] Error while inserting data in WFTxnDataMigrationLogTable with Status S'
										CLOSE v_columnCursor 
										DEALLOCATE v_columnCursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , '[WFMoveTransData] Error while inserting data in WFTxnDataMigrationLogTable with Status S')
										RETURN
									End
									
									BEGIN
										SELECT @v_query = 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''QUEUEHISTORYTABLE'' INTERSECT SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''WFINSTRUMENTTABLE'''
										
										EXECUTE('DECLARE v_columnCursor CURSOR  FAST_FORWARD for ' + @v_query)
										IF(@@error <> 0)
										Begin
											PRINT ' [WFMoveTransData] Error in executing v_columnCursor cursor query'
											CLOSE v_columnCursor 
											DEALLOCATE v_columnCursor 
											--RAISERROR('Error in WFMoveTransData Error in executing v_columnCursor cursor query', 16, 1) 
											RETURN
										End
										
										OPEN v_columnCursor
											
										IF(@@error <> 0)
										Begin
											PRINT ' [WFMoveTransData] Error in opening v_columnCursor cursor query'
											CLOSE v_columnCursor 
											DEALLOCATE v_columnCursor 
											--RAISERROR('Error in WFMoveTransData Error in executing v_columnCursor cursor query', 16, 1) 
											RETURN
										End
																			
										FETCH NEXT FROM v_columnCursor INTO @v_column
										IF(@@error <> 0)
										Begin
											PRINT ' [WFMoveTransData] Error in fetchong from  v_columnCursor cursor query'
											CLOSE v_columnCursor 
											DEALLOCATE v_columnCursor 
											--RAISERROR('Error in WFMoveTransData Error in executing v_columnCursor cursor query', 16, 1) 
											RETURN
										End
										SELECT @v_colName = ''

										WHILE( @@FETCH_STATUS <> -1 ) 
										BEGIN
											IF( @@FETCH_STATUS <> -2 )
											BEGIN
												IF(@v_column <> '')
												BEGIN
													IF(@v_colName <> '')
													BEGIN
														SELECT @v_colName = @v_colName + ',' + @v_column
													END
													ELSE
													BEGIN
														SELECT @v_colName = @v_column
													END
												END
											END
											FETCH NEXT FROM v_columnCursor INTO @v_column
											IF(@@error <> 0)
											BEGIN
												PRINT ' [WFMoveTransData] Error in fetchong from  v_columnCursor cursor query'
												CLOSE v_columnCursor 
												DEALLOCATE v_columnCursor 
												--RAISERROR('Error in WFMoveTransData Error in executing v_columnCursor cursor query', 16, 1) 
												RETURN
											END
										END
										CLOSE v_columnCursor 
										DEALLOCATE v_columnCursor
										PRINT @v_colName
									END

									SELECT @v_query = 'Insert into QUEUEHISTORYTABLE' + '(' + @v_colName + ')' + ' Select ' + @v_colName + ' from ' +  @dblinkString + '.WFINSTRUMENTTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
									PRINT @v_query
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										RETURN
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.WFINSTRUMENTTABLE where processinstanceid = ' + ''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Insert into TODOSTATUSHISTORYTABLE Select * from ' +  @dblinkString + '.TODOSTATUSTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
								
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'TODOSTATUSTABLE where processinstanceid = ' + ''''+ @v_processInstanceId +''''
									EXECUTE(@v_query)
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									/* Changes done upto here*/

									SELECT @v_query = 'Insert into EXCEPTIONHISTORYTABLE Select * from ' +  @dblinkString + '.EXCEPTIONTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'EXCEPTIONTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFREMINDERTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									EXECUTE GetColStr 'WFESCALATIONTABLE',@v_columnStr = @colStr OUTPUT
									SELECT @v_query = 'set IDENTITY_INSERT '  + @v_targetCabinet + '..WFESCALATIONTABLE ON' + ' Insert into WFESCALATIONTABLE ( ' + @colStr +' ) Select * from ' +  @dblinkString + '.WFESCALATIONTABLE where processinstanceid = '+''''+ @v_processInstanceId + '''' + ' set IDENTITY_INSERT '  + @v_targetCabinet + '.. WFESCALATIONTABLE OFF'
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFESCALATIONTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
						
									SELECT @v_query = 'Insert into WFESCINPROCESSTABLE Select * from ' +  @dblinkString + '.WFESCINPROCESSTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFESCINPROCESSTABLE where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_CountQuery = ' SELECT @value = COUNT(*) FROM  ' + @dblinkString + '.WFLINKSTABLE WHERE PARENTPROCESSINSTANCEID = ' + '''' + @v_processInstanceId + ''''
									SELECT @v_queryParam = '@value INT OUTPUT'
									EXEC sp_executesql @v_CountQuery, @v_queryParam, @value = @v_count OUTPUT
									IF( @v_count > 0 )
									BEGIN
										SELECT @v_query = 'UPDATE  ' + @dblinkString +'.WFLINKSTABLE SET IsParentArchived ='' Y '' WHERE PARENTPROCESSINSTANCEID = ' + '''' +
															@v_processInstanceId + ''''
										EXECUTE(@v_query)
										IF (@@error <> 0)
										BEGIN											
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										
										SELECT @v_query = 'UPDATE  WFLINKSTABLE SET IsParentArchived ='' Y '' WHERE PARENTPROCESSINSTANCEID = ' + '''' +
															@v_processInstanceId + ''''
										EXECUTE(@v_query)
										IF (@@error <> 0)
										BEGIN											
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
									END
									
									SELECT @v_CountQuery = ' SELECT @value = COUNT(*)  FROM  ' +@dblinkString + '.WFLINKSTABLE WHERE CHILDPROCESSINSTANCEID = ' + '''' + @v_processInstanceId + ''''
									SELECT @v_queryParam = '@value INT OUTPUT'
									EXEC sp_executesql @v_CountQuery, @v_queryParam, @value = @v_count OUTPUT
									IF( @v_count > 0 )
									BEGIN
										SELECT @v_query = 'UPDATE  ' + @dblinkString +'.WFLINKSTABLE SET IsChildArchived ='' Y '' WHERE ChildProcessInstanceId = ' + '''' +
															@v_processInstanceId + ''''
										EXECUTE(@v_query)
										IF (@@error <> 0)
										BEGIN											
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										
										SELECT @v_query = 'UPDATE  WFLINKSTABLE SET IsChildArchived = '' Y '' WHERE ChildProcessInstanceId = ' + '''' +
															@v_processInstanceId + ''''
										EXECUTE(@v_query)
										IF (@@error <> 0)
										BEGIN											
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
									END
									
									EXECUTE GetColStr 'WFCOMMENTSHISTORYTABLE',@v_columnStr = @colStr OUTPUT
									--This change is done to handle the case if commentsID in wfcommentsHistorytable is not identity...
									IF(columnproperty(object_id('WFCommentsHistoryTable'),'CommentsId','IsIdentity') = 1)
										BEGIN
											SELECT @v_query = 'set IDENTITY_INSERT '  + @v_targetCabinet + '..WFCOMMENTSHISTORYTABLE ON ' + ' Insert into WFCOMMENTSHISTORYTABLE ( ' + @colStr + ' ) Select * from ' +  @dblinkString + '.WFCOMMENTSTABLE where processinstanceid = '+''''+ @v_processInstanceId + '''' + ' set IDENTITY_INSERT '  + @v_targetCabinet + '.. WFCOMMENTSHISTORYTABLE OFF'
										END
									ELSE
										BEGIN
											SELECT @v_query = 'Insert into WFCOMMENTSHISTORYTABLE ( ' + @colStr + ' ) Select * from ' +  @dblinkString + '.WFCOMMENTSTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
										END
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + ' WFCOMMENTSTABLE where processinstanceid = ' ++''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									Print 'Checking the flag for ext data'
									print @v_moveExtData

									IF(( ( @v_variantId = 0 ) OR ( @v_variantId = -1 ) ) AND ( @v_moveExtData = 'Y'))
									BEGIN
										IF( @v_externalTableCount > 0 )
										BEGIN
											SELECT @v_query = 'INSERT INTO ' + @v_externalTable + ' SELECT * FROM ' + @dblinkString + '.' + @v_externalTable + ' WHERE ITEMINDEX = ' + @v_folderIndex
											EXECUTE(@v_query)
											
											IF (@v_deleteExtTabData = 'Y')
											BEGIN
												SELECT @v_query = 'DELETE FROM ' +  @dblinkString + '.' + @v_externalTable + ' WHERE ITEMINDEX = ' + @v_folderIndex
												EXECUTE(@v_query)
											END
										END
									END
									
									--Latest changes for new Case management features
									SELECT @v_query = 'Insert into WFCaseSummaryDetailsHistory Select * from ' +  @dblinkString + '.WFCaseSummaryDetailsTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFCaseSummaryDetailsTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END

									SELECT @v_query = 'Insert into WFCaseDocStatusHistory Select * from ' +  @dblinkString + '.WFCaseDocStatusTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									
									SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFCaseDocStatusTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
									EXECUTE(@v_query)
									
									IF (@@error <> 0)
									BEGIN
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
									END
									--Latest changes for new Case management features
									
					/* Added for Case Management--Archival of task DATA */ 
									If(@v_moveTaskData='Y')
									BEGIN
										Select  @v_query = 'Insert into WFRTTASKINTFCASSOCHISTORY Select * from '+@dblinkString+'.WFRTTaskInterfaceAssocTable where ProcessInstanceId='''+@v_processInstanceId+''''
										EXECUTE(@v_query)
									    
										Select @v_query = 'Delete from ' +@dblinkString+'.WFRTTaskInterfaceAssocTable where ProcessInstanceId='''+@v_processInstanceId +''''
										EXECUTE(@v_query)
										
										Select 	@v_query = 'Insert into RTACTIVITYINTFCASSOCHISTORY Select * from ' +@dblinkString+'.RTACTIVITYINTERFACEASSOCTABLE where ProcessInstanceId='''+@v_processInstanceId+''''
										EXECUTE(@v_query)
										
										Select @v_query = 'Delete from ' +@dblinkString+'.RTACTIVITYINTERFACEASSOCTABLE where ProcessInstanceId='''+@v_processInstanceId +''''
										EXECUTE(@v_query)
										
										Select @v_query = 'Insert into WFTaskStatusHistoryTable Select * from ' +@dblinkString+'.WFTaskStatusTable where 
										ProcessInstanceId='''+@v_processInstanceId+''''
										EXECUTE(@v_query)
										
										Select @v_query = 'Delete from ' +@dblinkString+'.WFTaskStatusTable  where ProcessInstanceId='''+@v_processInstanceId+''''
										EXECUTE(@v_query)
										
										--Latest Changes for the new case management features
										SELECT @v_query = 'Insert into WFTaskPreCondResultHistory Select * from ' +  @dblinkString + '.WFTaskPreConditionResultTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										
										SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFTaskPreConditionResultTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										
										SELECT @v_query = 'Insert into WFTaskPreCheckHistoryTable Select * from ' +  @dblinkString + '.WFTaskPreCheckTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										
										SELECT @v_query = 'Delete from ' +  @dblinkString + '.' + 'WFTaskPreCheckTable where processinstanceid = ' +''''+ @v_processInstanceId + ''''
										EXECUTE(@v_query)
										
										IF (@@error <> 0)
										BEGIN
											CLOSE v_cursor 
											DEALLOCATE v_cursor 
											ROLLBACK TRANSACTION MOVE_TRANS_DATA
											INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , @v_query)
										END
										--Latest changes for new Case Management features
									END
					/* End Of Case Management--Archival of task DATA */ 
									IF(@v_moveExtData='Y') 
									BEGIN
										EXEC WFMoveComplexData @v_processInstanceId,@v_processDefId,@v_variantId,@v_sourceCabinet,@v_targetCabinet,@dblinkString,'N',@executionLogId
									END
									IF(@@error <> 0)
									Begin										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in execution of sp WFMoveComplexData ')
										--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									-----Custom Data Procedure starts---
									EXEC WFMoveCustomData @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_ProcessDefId ,@v_processInstanceId,@v_DeleteFromSrc
									IF(@@error <> 0)
									Begin										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in execution of sp WFMoveCustomData ')
										--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									-----Custom Data Procedure ends---
									IF( (@v_moveAuditTrailData != 'N') AND (@v_moveAuditTrailData != 'n') )
									BEGIN
										EXEC WFMoveAuditTrailData @v_processInstanceId,@v_processDefId,@v_sourceCabinet,@v_targetCabinet,@dblinkString,@v_fromDate,@v_toDate,@executionLogId
									END
									IF(@@error <> 0)
									Begin										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in execution of sp WFMoveAuditTrailData ')
										--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_folderIndex,'Y','N',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
									IF(@@error <> 0)
									Begin										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in execution of sp MoveDocdb ')
										--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
										RETURN
									End
									
									IF (@v_folderStatus <> 0) 
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , 'ERROR CODE WHILE MIGRTAING FOLDER ' + @v_folderIndex + 'IS' + @v_folderStatus)
										RETURN
									END
									
									UPDATE WFTxnDataMigrationLogTable SET Status='D',ActionEndDateTime = getdate() WHERE ProcessDefId = @v_ProcessDefId and ProcessInstanceId=@v_processInstanceId;
									IF (@@ROWCOUNT != 1) 
									BEGIN										
										CLOSE v_cursor 
										DEALLOCATE v_cursor 
										ROLLBACK TRANSACTION MOVE_TRANS_DATA
										INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , '[WFMoveTransData] Number of affected row(s) are either 0 or greater than 1 in WFTxnDataMigrationLogTable.')
										RETURN
									END
									
																		
							END ----------------------------------------------IF INSIDE 2ND WHILE
							
							FETCH NEXT FROM v_cursor INTO @v_processInstanceId,@v_folderIndex
							IF(@@error <> 0)
							Begin								
								CLOSE v_cursor 
								DEALLOCATE v_cursor 
								ROLLBACK TRANSACTION MOVE_TRANS_DATA
								INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in opening v_cursor cursor query')
								--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
								RETURN
							End
							SELECT @rowCount = @rowCount + 1
						END---------------------------------------End 2nd while
	
					INSERT INTO WFTxnDataMigrationProgressLog VALUES(@executionLogId , GETDATE() , @v_ProcessDefId, @v_firstProcessInstanceId ,@v_lastProcessInstanceId)
					
					COMMIT TRANSACTION MOVE_TRANS_DATA ------------------------------Move Trans Data COMMITS Here
					
					CLOSE v_cursor  
					DEALLOCATE v_cursor 
					
				END---------------------------------------WHILE (1=1) endS
				
			END -------------------------OUTERMOST IF ENDS
			IF(@v_moveTaskData = 'Y') 
			BEGIN
				EXEC WFExportTaskTables @v_sourceCabinet, @v_targetCabinet, @dblinkString,@v_processDefId,'N',@executionLogId,'Y'
				EXEC WFMigrateTaskData @v_processDefId,@v_sourceCabinet,@v_targetCabinet,@dblinkString,@v_fromDate,@v_toDate
			END
			PRINT 'WFMoveTransData executed successfully for processdefid --' + CONVERT( NVARCHAR(10),@v_processDefId )
			
			FETCH NEXT FROM tableVarCursor INTO  @v_processDefId , @v_variantId
			IF(@@error <> 0)
			BEGIN
				INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in fetching from tableVarCursor cursor query')
				CLOSE tableVarCursor 
				DEALLOCATE tableVarCursor 
				--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
				RETURN
			END
			
		END ---------------------OUTERMOST WHILE ENDS
		CLOSE tableVarCursor 
		DEALLOCATE tableVarCursor 
			
		
		--EXEC WFSynchLinksData @v_sourceCabinet , @v_targetCabinet ,@dblinkString,@executionLogId
		IF(@@error <> 0)
		BEGIN
			INSERT INTO WFFailedTxnDataMigrationLogTable VALUES (@executionLogId , GETDATE(), @v_ProcessDefId ,@v_processInstanceId , ' [WFMoveTransData] Error in execution of procdure WFSynchLinksData')
			--RAISERROR('Error in WFMoveTransData Error in executing v_processCursor cursor query', 16, 1) 
			RETURN
		END
			

	END
