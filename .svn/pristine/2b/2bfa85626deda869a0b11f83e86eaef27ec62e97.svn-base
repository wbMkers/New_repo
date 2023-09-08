	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFExportExternalTable.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure to set migrate External Tables
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFExportExternalTable')
	Begin
		Execute('DROP PROCEDURE WFExportExternalTable')
		Print 'Procedure WFExportExternalTable already exists, hence older one dropped ..... '
	End

	~
	
	CREATE PROCEDURE WFExportExternalTable (
		@v_sourceCabinet 	VARCHAR(256),
		@v_targetCabinet 	VARCHAR(256),
		@dblinkString     	VARCHAR(256),
		@v_processDefId  	INT,
		@v_migrateAllData 	VARCHAR(256),
		@v_executionLogId	INT
	)
	AS
	BEGIN
		DECLARE @v_query       			NVARCHAR(2000)
		DECLARE @v_queryStr    			NVARCHAR(2000)
		DECLARE @v_createQuery  		NVARCHAR(4000)
		DECLARE @v_filterQueryString 	VARCHAR(1000)
		DECLARE @v_tableName			VARCHAR(256)
		DECLARE @v_extObjId				INT
		DECLARE @v_histTabFlag			INT
		DECLARE @v_queryParameter		NVARCHAR(256)
		
		IF(@v_migrateAllData ='Y')	
		BEGIN
			SELECT @v_filterQueryString = ' '
		END
		ELSE
		BEGIN
			SELECT @v_filterQueryString = ' WHERE PROCESSDEFID =  ' + CONVERT(nvarchar(10),@v_ProcessDefId)
		END
		
		SELECT @v_query = ' SELECT TABLENAME,EXTOBJID FROM ' + @dblinkString + '.EXTDBCONFTABLE WITH (NOLOCK) ' + 
		@v_filterQueryString
		EXECUTE ('DECLARE v_TableCursor CURSOR FAST_FORWARD FOR ' + @v_query)
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [Export External Data] Error in executing v_TableCursor cursor query..' + @v_query)
			CLOSE v_TableCursor 
			DEALLOCATE v_TableCursor 
			--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
			RETURN
		End
		OPEN v_TableCursor
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [Export External Data] Error in OPENING v_TableCursor cursor query..')
			CLOSE v_TableCursor 
			DEALLOCATE v_TableCursor 
			--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
			RETURN
		End
		
		FETCH NEXT FROM v_TableCursor INTO @v_tableName, @v_extObjId
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId, ' [Export External Data] Error in fetching from v_TableCursor cursor query>>'+@v_query)
			CLOSE v_TableCursor 
			DEALLOCATE v_TableCursor 
			--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
			RETURN
		End
		
		WHILE(@@FETCH_STATUS <> -1) 
		BEGIN
			IF (@@FETCH_STATUS <> -2) 
			BEGIN 
				IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
					PRINT 'External Table Already exists on target Cabinet'
				ELSE
				BEGIN
					SELECT @v_createQuery = 'SELECT * INTO ' + @v_tableName + ' FROM ' + @dblinkString + '.' + @v_tableName + ' WHERE 1 = 2'
					EXECUTE(@v_createQuery)
					IF(@@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,  'Error in Creating External Teable On Target' + @v_createQuery)
						Return
					END
					PRINT 'External Table created successfully on target cabinet'
				END
				
				/* Check if extobjid is 1 means it can be exported separately ?*/
				PRINT 'Checking for the existance for the External Histry table: '
				IF (@v_extObjId = 1)
				BEGIN
					/* Checking if the external history table exists in the source database */
					SELECT @v_histTabFlag = 0
					SELECT @v_createQuery = ' SELECT @value =  1 FROM ' + @dblinkString + '.SYSOBJECTS WHERE NAME = ''' + @v_tableName + '_HISTORY'''
					SELECT @v_queryParameter = '@value  INT OUTPUT'
					EXEC sp_executesql @v_createQuery, @v_queryParameter, @value = @v_histTabFlag OUTPUT

					/*History table exists in the source db*/
					IF ( @v_histTabFlag = 1)

					BEGIN
						PRINT 'External History Table exists on Source Cabinet, creating the history table on target'
					
						/* Check if the history table exists into the target database*/
						IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName + '_HISTORY' )
						BEGIN
							SELECT @v_createQuery = 'SELECT * INTO ' + @v_tableName + '_HISTORY FROM ' + @dblinkString + '.' + @v_tableName + ' WHERE 1 = 2'
							EXECUTE(@v_createQuery)
							IF(@@error <> 0 )
							BEGIN
								INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,  'Error in Creating External History Table On Target >>' + @v_createQuery)
								Return
							END
							PRINT 'External History Table created successfully on target cabinet'
						END
						ELSE
						BEGIN
							PRINT 'External History Table exists on target Cabinet'
						END
					END
					ELSE
					BEGIN
						PRINT 'External History Table doesnt exists on source Cabinet, skip creating on the target cabinet'
					END
				END
			--End of the history move task here..
			END
			
			FETCH NEXT FROM v_TableCursor INTO @v_tableName, @v_extObjId
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId, ' [Export External Data] Error in fetching from  v_TableCursor cursor query')
				CLOSE v_TableCursor 
				DEALLOCATE v_TableCursor 
				--RAISERROR('Error in WFMoveVariantMetaData Error in executing columnName cursor query', 16, 1) 
				RETURN
			End
		END
		CLOSE v_TableCursor 
		DEALLOCATE v_TableCursor 
	END