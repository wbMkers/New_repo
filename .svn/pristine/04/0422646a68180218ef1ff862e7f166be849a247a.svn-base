	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveOmnidocsFolderData.sql (postgres)
		Author                      : Puneet Jaiswal
		Date written (DD/MM/YYYY)   : 21 MAY 2020
		Description                 : Stored Procedure to move Omnidocs Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
CREATE OR REPLACE FUNCTION WFMoveOmnidocsFolderData() RETURNS void  LANGUAGE 'plpgsql' AS $function$ 
	DECLARE	v_sourceCabinet            VARCHAR(256);
		v_targetCabinet            VARCHAR(256);
		dblinkString    			VARCHAR(256);
		v_processDefId  			INT;
		v_migrateAllData 			VARCHAR(1);
		v_copyForceFully 			VARCHAR(1);
		v_existingProcessString		VARCHAR(4000);
		v_DeleteFromSrc				VARCHAR(1);
		v_executionLogId			INT;
		

	BEGIN
		DECLARE v_queryFolder 			VARCHAR(4000);
		DECLARE v_FilterQueryString	VARCHAR(1000);
		DECLARE v_routeFolderId 	   	VARCHAR(255);
		DECLARE v_scratchFolderId   	VARCHAR(255);
		DECLARE v_workFlowFolderId   	VARCHAR(255);
		DECLARE v_completedFolderId  	VARCHAR(255);
		DECLARE v_dicarderFolderId   	VARCHAR(255);
		DECLARE v_genIndex				INT;
		DECLARE newFolderIndex			INT;
		DECLARE v_folderStatus			INT;
		DECLARE v_FolderCursor REFCURSOR;
		
		BEGIN
			IF( v_migrateAllData ='Y' ) THEN
			BEGIN
				v_FilterQueryString := ' WHERE processdefid not in ( ' || v_existingProcessString || ')';
			END;
			ELSE
			BEGIN
				IF( v_copyForceFully = 'Y' ) THEN
				BEGIN
					v_FilterQueryString := ' WHERE PROCESSDEFID = ' || v_processdefid || ' AND PROCESSDEFID NOT IN ( ' || v_existingProcessString  || ')';
				END;
				ELSE
				BEGIN
					v_FilterQueryString := ' WHERE PROCESSDEFID = ' || v_processdefid;
				END;
				END IF;
			END;
			END IF;
		
			v_queryFolder := 'Select RouteFolderId,ScratchFolderId,WorkFlowFolderId,CompletedFolderId,DiscardFolderId from '|| dblinkString || '.RouteFolderDefTable ' || v_FilterQueryString;

			OPEN v_FolderCursor FOR EXECUTE v_queryFolder;
			
			LOOP
				FETCH v_FolderCursor INTO v_routeFolderId , v_scratchFolderId , v_workFlowFolderId ,v_completedFolderId , v_dicarderFolderId;
			
				IF(NOT FOUND) THEN
				BEGIN
					INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,' [WFMoveOmnidocsFolderData]Error in fetching from v_FolderCursor');
					CLOSE v_FolderCursor;
					DEALLOCATE v_FolderCursor;
					RETURN;
				END;
				END IF;
				
				BEGIN
					BEGIN
						EXECUTE MoveDocdb v_sourcecabinet,v_targetCabinet,dblinkString,v_routeFolderId,'N','N',newFolderIndex,v_folderStatus,v_DeleteFromSrc;
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,'Error while migrating folder ' || v_routeFolderId);
							RETURN;
						END;
					END;	
						
					BEGIN
						EXECUTE MoveDocdb v_sourcecabinet,v_targetCabinet,dblinkString,v_scratchFolderId, 'N','N',newFolderIndex,v_folderStatus,v_DeleteFromSrc;
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,@v_processDefId,'Error while migrating folder ' || v_scratchFolderId);
							RETURN;
						END;
					END;	
					
					BEGIN	
						EXECUTE MoveDocdb v_sourcecabinet,v_targetCabinet,dblinkString,v_workFlowFolderId,'N','N',newFolderIndex,v_folderStatus,v_DeleteFromSrc;
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,'Error while migrating folder ' || v_workFlowFolderId);
							RETURN;
						END;
					END;	
	
					BEGIN
						EXECUTE MoveDocdb v_sourcecabinet,v_targetCabinet,dblinkString,v_completedFolderId,'N','N',newFolderIndex,v_folderStatus,v_DeleteFromSrc;
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,'Error while migrating folder ' || v_completedFolderId);
							RETURN;
						END;
					END;	
					
					BEGIN
						EXECUTE MoveDocdb v_sourcecabinet,v_targetCabinet,dblinkString,v_dicarderFolderId,'N','N',newFolderIndex,v_folderStatus,v_DeleteFromSrc;
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,'Error while migrating folder ' || v_dicarderFolderId);
							RETURN;
						END;
					END;
					
				END;
				
				END LOOP;
			
			
			CLOSE v_FolderCursor;
			DEALLOCATE v_FolderCursor;
			
			INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,NULL,'WFMoveOmnidocsFolderData Executed Succssfully');
		END;
	END;
$function$;	
