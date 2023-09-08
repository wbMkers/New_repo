	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMigrateProcessData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To migrate Process Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMigrateProcessData')
	Begin
		Execute('DROP PROCEDURE WFMigrateProcessData')
		Print 'Procedure WFMigrateProcessData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMigrateProcessData
	  (
		@v_sourceCabinet      	VARCHAR(255),
		@v_targetCabinet      	VARCHAR(255),
		@dblinkString         	VARCHAR(255),
		@v_overRideCabinetData	VARCHAR(1),
		@v_executionLogId       INT,
		@v_moveTaskData			VARCHAR(1)
	)
	AS

	 BEGIN
	 
	  DECLARE @v_query 						NVARCHAR(4000)
	  DECLARE @v_queryStr 					NVARCHAR(2000)
	  DECLARE @v_tableName               	VARCHAR(256)
	  DECLARE @v_existsFlag           		INT
	  DECLARE @v_hasIdentityColumn			VARCHAR(1)
		
		If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and name = 'WFPROCESSTABLELIST')
		Begin
			SELECT @v_query = 'DROP TABLE ' + @v_targetCabinet + '..WFPROCESSTABLELIST'
			EXECUTE(@v_query)
		
			Print 'TABLE WFPROCESSTABLELIST already exists, hence older one dropped ..... '
		End
		
		SELECT @v_query = 'CREATE TABLE ' + @v_targetCabinet + '..WFPROCESSTABLELIST (
								tableId                 INT IDENTITY (1, 1) PRIMARY KEY, 
								tableName               VARCHAR(256),
								dataMigrationSuccessful VARCHAR(1) ,
								hasIdentityColumn       VARCHAR(1)
							)'
		EXECUTE(@v_query)
			
		EXEC WFPopulateProcessDataList @v_targetCabinet,@v_moveTaskData
		
		SELECT @v_query = 'SELECT tableName , hasIdentityColumn FROM ' + @v_targetCabinet + '..WFPROCESSTABLELIST   WITH (NOLOCK) '
		EXECUTE ('DECLARE tableName_cur CURSOR FAST_FORWARD FOR ' + @v_query)
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateProcessData] Error in executing tableName cursor query')
			CLOSE tableName_cur 
			DEALLOCATE tableName_cur 
			--RAISERROR('Error in WFMigrateProcessData Error in executing tableName cursor query', 16, 1) 
			RETURN
		End
		
		OPEN tableName_cur
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateProcessData] Error in opening tableName cursor')
			CLOSE tableName_cur 
			DEALLOCATE tableName_cur 
			--RAISERROR('Error in WFMigrateProcessData Error in opening tableName cursor', 16, 1) 
			RETURN
		End

		FETCH NEXT FROM tableName_cur INTO  @v_tableName , @v_hasIdentityColumn
		IF(@@error <> 0)
		Begin
			INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateProcessData]  Error in fetching data FROM tableName cursor')
			CLOSE tableName_cur 
			DEALLOCATE tableName_cur 
			--RAISERROR('Error in WFMigrateProcessData Error in fetching data FROM tableName cursor', 16, 1) 
			RETURN
		End
		WHILE(@@FETCH_STATUS <> -1) 
		BEGIN 
			IF (@@FETCH_STATUS <> -2) 
			BEGIN
				IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = @v_tableName)
				BEGIN
					
						EXEC WFMoveProcessData @v_sourceCabinet, @v_targetCabinet, @v_tableName ,@dblinkString ,@v_overRideCabinetData,@v_hasIdentityColumn,@v_executionLogId

						IF(@@error <> 0)
						Begin
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0,' [WFMigrateProcessData]  Error in execution of WFMoveProcessData')
							CLOSE tableName_cur 
							DEALLOCATE tableName_cur 
							----RAISERROR('Error in WFMigrateMetaData Error in execution of WFMoveProcessData', 16, 1) 
							RETURN
						End
					
				END
			END
			
			FETCH NEXT FROM tableName_cur INTO  @v_tableName , @v_hasIdentityColumn
			IF(@@error <> 0)
			Begin
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,0, ' [WFMigrateProcessData] Error in fetching data FROM tableName cursor ')
				CLOSE tableName_cur 
				DEALLOCATE tableName_cur 
				--RAISERROR('Error in WFMigrateMetaData Error in fetching data FROM tableName cursor', 16, 1) 
				RETURN
			End
		
		END
		
		CLOSE tableName_cur
		DEALLOCATE tableName_cur

		INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,0,NULL,'WFMigrateProcessData  Executed Succssfully')
		
	 END	