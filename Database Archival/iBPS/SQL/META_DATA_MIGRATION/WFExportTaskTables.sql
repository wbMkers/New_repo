	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFExportTaskTables.sql (MSSQL)
		Author                      : Sajid Khan
		Date written (DD/MM/YYYY)   : 07 July 2015
		Description                 : Stored Procedure to set migrate Task Data Tables
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFExportTaskTables')
	Begin
		Execute('DROP PROCEDURE WFExportTaskTables')
		Print 'Procedure WFExportTaskTables already exists, hence older one dropped ..... '
	End

	~
	
	CREATE PROCEDURE WFExportTaskTables (
		@v_sourceCabinet 	VARCHAR(256),
		@v_targetCabinet 	VARCHAR(256),
		@dblinkString     	VARCHAR(256),
		@v_processDefId  	INT,
		@v_migrateAllData 	VARCHAR(256),
		@v_executionLogId	INT,
		@v_isRunTimeTable		VARCHAR(1)
	)
	AS
	BEGIN
		DECLARE @v_query       			NVARCHAR(2000)
		DECLARE @v_queryStr    			NVARCHAR(2000)
		DECLARE @v_createQuery  		VARCHAR(4000)
		DECLARE @v_filterQueryString 	VARCHAR(1000)
		DECLARE @v_tableName			VARCHAR(256)
		DECLARE	@v_localProcessDefId  	INT
		DECLARE @v_taskId				INT
		Declare @v_scope				VARCHAR(1)
		
		IF(@v_migrateAllData ='Y')	
		BEGIN
			SELECT @v_filterQueryString = ' '
		END
		ELSE
		BEGIN
			SELECT @v_filterQueryString = ' WHERE PROCESSDEFID =  ' + CONVERT(nvarchar(10),@v_ProcessDefId)
		END
		
		
		IF(@v_isRunTimeTable ='Y') 
		BEGIN
			Select @v_scope = 'U'
		END
		ELSE
		BEGIN
			Select @v_scope = 'P'
		END
		
		IF(@v_migrateAllData ='Y')	
		BEGIN
			SELECT @v_filterQueryString = ' Where  SCOPE = '''+@v_scope +''''
		END
		ELSE
		BEGIN
			SELECT @v_filterQueryString = @v_filterQueryString+' And SCOPE = '''+@v_scope +''''
		END
		
		SELECT @v_query = ' SELECT ProcessDefId, TaskId FROM ' + @dblinkString + '.WFTASKDEFTABLE WITH (NOLOCK) ' + 
		@v_filterQueryString
		EXECUTE ('DECLARE v_TableCursor CURSOR FAST_FORWARD FOR ' + @v_query)
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [Export Task Data] Error in executing v_TableCursor cursor query..' + @v_query)
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
		
		FETCH NEXT FROM v_TableCursor INTO @v_localProcessDefId,@v_taskId
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
				Select @v_tableName = 'WFGenericData_'+CONVERT(nvarchar(10),@v_localProcessDefId)+'_'+CONVERT(nvarchar(10),@v_taskId)
				IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
					PRINT 'Table Already exists on target Cabinet'
				ELSE
				BEGIN
					SELECT @v_createQuery = 'SELECT * INTO ' + @v_tableName + ' FROM ' + @dblinkString + '.' + @v_tableName + ' WHERE 1 = 2'
					EXECUTE(@v_createQuery)
					IF(@@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,  'Error in Creating Task Data Tables On Target' + @v_createQuery)
						Return
					END
				END
				
			END
			
			FETCH NEXT FROM v_TableCursor INTO @v_localProcessDefId,@v_taskId
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId, ' [Export Task Data Table] Error in fetching from  v_TableCursor cursor query')
				CLOSE v_TableCursor 
				DEALLOCATE v_TableCursor 
				RETURN
			End
		END
		CLOSE v_TableCursor 
		DEALLOCATE v_TableCursor 
	END
