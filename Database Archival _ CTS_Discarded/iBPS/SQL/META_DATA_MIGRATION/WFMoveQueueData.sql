	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveQueueData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Move Queue Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveQueueData')
	Begin
		Execute('DROP PROCEDURE WFMoveQueueData')
		Print 'Procedure WFMoveQueueData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMoveQueueData
	(
		@v_sourceCabinet 	     VARCHAR(256),
		@v_targetCabinet 	     VARCHAR(256),
		@v_processDefId  	     INT,
		@dblinkString     	     VARCHAR(256),
		@v_migrateAllData 	     VARCHAR(1),
		@v_copyForceFully 		 VARCHAR(1),
		@v_existingProcessString VARCHAR(256),
		@v_executionLogId		 INT

	)
	AS

		DECLARE @v_query               	NVARCHAR(2000)
		DECLARE @v_tableName      		VARCHAR(256)
		DECLARE @v_colStrQueueDef  		VARCHAR(4000)
		DECLARE @v_colStrQueueUser 		VARCHAR(4000)
		DECLARE @v_columnName      		VARCHAR(256)
		DECLARE @v_FilterQueryString 	VARCHAR(1000)
		DECLARE @v_queryParameter       NVARCHAR(256)
		DECLARE @value        			INT
		DECLARE @val					INT
		DECLARE @v_queueId				INT

	BEGIN
		
		
			EXECUTE GetColStr 'QueueDefTable' , @v_columnStr = @v_colStrQueueDef  OUTPUT
			
				IF( @v_migrateAllData ='Y' )
				BEGIN
					IF( @v_copyForceFully ='Y' )
					BEGIN
						---Truncating QUEUEDEFTABLE on target Cabinet
						SELECT @v_query = 'TRUNCATE TABLE ' + @v_targetCabinet + '.. QueueDefTable' 
						EXECUTE (@v_query)
						IF(@@error <> 0)
						Begin
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMovequeueData] Error in truncating Table : QueueDefTable ')
							--RAISERROR('Error in WFMoveTableData Error truncating data ', 16, 1) 
							RETURN
						End
						
						SELECT @v_FilterQueryString = ' WHERE 1 = 1 '
					END
					ELSE
					BEGIN
						SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID NOT IN ( ' + @v_existingProcessString + ')'
					END
				END
				ELSE
				BEGIN
					SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID = '	+ CONVERT(NVARCHAR(10),@v_processDefId)
					IF( @v_copyForceFully ='Y' )
					BEGIN
						SELECT @v_query = 'DELETE FROM ' + @v_targetCabinet + '..QUEUEDEFTABLE WHERE QUEUEID IN ( SELECT QUEUEID FROM  ' + @dblinkString + '.QUEUESTREAMTABLE' + @v_FilterQueryString + ')'
						EXECUTE(@v_query)
						IF(@@error <> 0)
						Begin
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMovequeueData] Error deleting from QUEUEDEFTABLE ')
							--RAISERROR('Error in WFMoveTableData Error truncating data ', 16, 1) 
							RETURN
						End
					END
				END
			
				SELECT @v_query = 'SELECT DISTINCT QUEUEID FROM ' + @dblinkString + '.QUEUESTREAMTABLE WITH(NOLOCK) ' + @v_FilterQueryString
				EXECUTE('DECLARE v_QueueCursor CURSOR FAST_FORWARD FOR ' + @v_query)
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'[WFMoveQueueData] Error in declaring v_QueueCursor')
					CLOSE v_QueueCursor 
					DEALLOCATE v_QueueCursor 
					--RAISERROR('Error in WFMOVEQUEUEDATA while truncating data ', 16, 1) 
					RETURN
				END
				
				OPEN v_QueueCursor
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'[WFMoveQueueData] Error in OPENING v_QueueCursor')
					CLOSE v_QueueCursor 
					DEALLOCATE v_QueueCursor 
					--RAISERROR('Error in WFMOVEQUEUEDATA while truncating data ', 16, 1) 
					RETURN
				END
				
				FETCH NEXT FROM v_QueueCursor INTO @v_queueId
				IF(@@error <> 0)
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'[WFMoveQueueData] Error in fetching from v_QueueCursor')
					CLOSE v_QueueCursor 
					DEALLOCATE v_QueueCursor 
					--RAISERROR('Error in WFMOVEQUEUEDATA while truncating data ', 16, 1) 
					RETURN
				END
				WHILE ( @@FETCH_STATUS <> -1 )
				BEGIN
					IF (@@FETCH_STATUS <> -2) 
					BEGIN 
						SELECT @v_query = ' SELECT @value = COUNT(*) FROM ' + @v_targetCabinet + '..QueueDefTable WHERE QUEUEID = ' +  CONVERT(nvarchar(10),@v_queueId)
						SELECT @v_queryParameter = '@value INT OUTPUT'
						EXEC sp_executesql @v_query, @v_queryParameter, @value = @val OUTPUT
						If ( @val = 0 )
						BEGIN
							print 'columnstr>.'
							print @v_colStrQueueDef
						
							SELECT @v_query = 'set IDENTITY_INSERT '  + @v_targetCabinet + '..QueueDefTable ON' + ' Insert into QueueDefTable ( ' + @v_colStrQueueDef +' ) Select * from ' +  @dblinkString + '.QueueDefTable WITH (NOLOCK) where QUEUEID = '  +  CONVERT(nvarchar(10),@v_queueId)
							print ('queuedefquery -- ')
							print(@v_query)
							EXECUTE (@v_query)
							IF(@@error <> 0)
							BEGIN
								INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,@v_query)
								--RAISERROR('Error in WFMoveQueueData while inserting data ', 16, 1) 
								RETURN
							END
						END
						
					END
					
					FETCH NEXT FROM v_QueueCursor INTO @v_queueId
					IF(@@error <> 0)
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'[WFMoveQueueData] Error in fetching from v_QueueCursor')
						CLOSE v_QueueCursor 
						DEALLOCATE v_QueueCursor 
						--RAISERROR('Error in WFMOVEQUEUEDATA while truncating data ', 16, 1) 
						RETURN
					END
					INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,0,NULL,'[WFMoveQueueData] Queue Data Migrated For queue-->'+CONVERT(nvarchar(10),@v_queueId))
				END
				CLOSE v_QueueCursor 
				DEALLOCATE v_QueueCursor 
	END
	