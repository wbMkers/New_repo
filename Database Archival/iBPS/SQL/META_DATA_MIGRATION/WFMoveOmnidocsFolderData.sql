	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveOmnidocsFolderData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure to move Omnidocs Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveOmnidocsFolderData')
	Begin
		Execute('DROP PROCEDURE WFMoveOmnidocsFolderData')
		Print 'Procedure WFMoveOmnidocsFolderData already exists, hence older one dropped ..... '
	End

	~

	CREATE PROCEDURE WFMoveOmnidocsFolderData(
		@v_sourceCabinet            VARCHAR(256),
		@v_targetCabinet            VARCHAR(256),
		@dblinkString    			VARCHAR(256),
		@v_processDefId  			INT,
		@v_migrateAllData 			VARCHAR(1),
		@v_copyForceFully 			VARCHAR(1),
		@v_existingProcessString	VARCHAR(4000),
		@v_DeleteFromSrc			VARCHAR(1),
		@v_executionLogId			INT
		
	) AS
	BEGIN
		DECLARE @v_queryFolder 			VARCHAR(4000)
		DECLARE @v_FilterQueryString	VARCHAR(1000)
		DECLARE @v_routeFolderId 	   	NVARCHAR(255)
		DECLARE @v_scratchFolderId   	NVARCHAR(255)
		DECLARE @v_workFlowFolderId   	NVARCHAR(255)
		DECLARE @v_completedFolderId  	NVARCHAR(255)
		DECLARE @v_dicarderFolderId   	NVARCHAR(255)
		DECLARE @v_genIndex				INT
		DECLARE @newFolderIndex			INT
		DECLARE @v_folderStatus			INT
		DECLARE @pid					INT
		DECLARE @parentIndex            INT

		IF( @v_migrateAllData ='Y' )
		BEGIN
			SELECT @v_FilterQueryString = ' WHERE processdefid not in ( ' + @v_existingProcessString + ')'
		END
		ELSE
		BEGIN
			IF( @v_copyForceFully ='Y' )
			BEGIN
				SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID = ' + CONVERT(NVARCHAR(10),@v_processdefid) + ' AND PROCESSDEFID NOT IN ( ' + @v_existingProcessString  + ')'
			END
			ELSE
			BEGIN
				SELECT @v_FilterQueryString = ' WHERE PROCESSDEFID = ' + CONVERT(NVARCHAR(10),@v_processdefid)
			END
		END
		
			SELECT @v_queryFolder = 'Select RouteFolderId,ScratchFolderId,WorkFlowFolderId,CompletedFolderId,DiscardFolderId,ProcessDefId from '+ @dblinkString + '.RouteFolderDefTable   WITH (NOLOCK) ' +@v_FilterQueryString

			EXECUTE(' DECLARE  v_FolderCursor CURSOR FAST_FORWARD FOR '+ @v_queryFolder)
			IF(@@error <> 0 )
			BEGIN
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveOmnidocsFolderData] Error in declaring v_FolderCursor')
				CLOSE v_FolderCursor
				DEALLOCATE v_FolderCursor
				RETURN
			END
			
			OPEN v_FolderCursor
			
			IF(@@error <> 0 )
			BEGIN
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveOmnidocsFolderData]Error in opening v_FolderCursorr')
				CLOSE v_FolderCursor
				DEALLOCATE v_FolderCursor
				RETURN
			END

			FETCH NEXT FROM v_FolderCursor INTO @v_routeFolderId , @v_scratchFolderId , @v_workFlowFolderId ,@v_completedFolderId , @v_dicarderFolderId, @pid
			
			IF(@@error <> 0 )
			BEGIN
				INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,' [WFMoveOmnidocsFolderData]Error in fetching from v_FolderCursor')
				CLOSE v_FolderCursor
				DEALLOCATE v_FolderCursor
				RETURN
			END
			
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				IF(@@FETCH_STATUS <> -2)
				BEGIN
				
					IF @v_dicarderFolderId = 'Y'
					BEGIN
					FETCH NEXT FROM v_FolderCursor INTO @v_routeFolderId , @v_scratchFolderId , @v_workFlowFolderId ,@v_completedFolderId , @v_dicarderFolderId, @pid
					CONTINUE;
					end
					
					EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_routeFolderId,'N','Y',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
					IF( @@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' + @v_routeFolderId)
						RETURN
					END
					Update RouteFolderDefTable set RouteFolderId= @newFolderIndex, DiscardFolderId = 'Y' where Processdefid=@pid
					Select @parentIndex = @newFolderIndex
					/*EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_scratchFolderId, 'N','N',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
					IF( @@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' + @v_scratchFolderId)
						RETURN
					END */
					
					EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_workFlowFolderId,'N','Y',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
					IF( @@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' + @v_workFlowFolderId)
						RETURN
						END
                    Update RouteFolderDefTable set WorkFlowFolderId = @newFolderIndex where ProcessdefId = @pid
					Update PDBFolder set ParentFolderIndex= @parentIndex where FolderIndex= @newFolderIndex
					/*EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_completedFolderId,'N','N',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
					IF( @@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' + @v_completedFolderId)
						RETURN
					END

					EXEC MoveDocdb @v_sourcecabinet,@v_targetCabinet,@dblinkString,@v_dicarderFolderId,'N','N',@newFolderIndex,@v_folderStatus,@v_DeleteFromSrc
					IF( @@error <> 0 )
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' + @v_dicarderFolderId)
						RETURN
					END */
					
				END
				FETCH NEXT FROM v_FolderCursor INTO @v_routeFolderId , @v_scratchFolderId , @v_workFlowFolderId ,@v_completedFolderId , @v_dicarderFolderId, @pid
			
				IF(@@error <> 0 )
				BEGIN
					PRINT 'Error in FETCHING FROM v_FolderCursor'
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,'Error in fetching from v_FolderCursor')
					CLOSE v_FolderCursor
					DEALLOCATE v_FolderCursor
					RETURN
				END
			END
			CLOSE v_FolderCursor
			DEALLOCATE v_FolderCursor
			
			INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (@v_executionLogId,current_timestamp,@v_processDefId,NULL,'WFMoveOmnidocsFolderData Executed Succssfully')
	END
