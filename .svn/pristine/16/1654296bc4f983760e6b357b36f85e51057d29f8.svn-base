If Exists (Select 1 from SysObjects Where xType = 'P' and name = 'WFChangeProcessName')
Begin
	DROP PROCEDURE WFChangeProcessName
	Print 'Procedure WFChangeProcessName already exists, hence older one dropped ..... '
End

~

CREATE  PROCEDURE WFChangeProcessName(
	@DBProcessName		NVARCHAR(255),
	@DBNewProcessName	NVARCHAR(255),
	@UserId             INT,
	@UserName			NVARCHAR(128),
	@MainCode			INT OUTPUT,
	@Message 			NVARCHAR(1000) OUTPUT
)     
AS   
BEGIN
	SET NOCOUNT ON
	
	DECLARE @ProcessDefId	    	INT
	DECLARE @FolderIndex	    	INT
	DECLARE @v_OldQueueName			NVARCHAR(255)
	DECLARE @v_ProcessInstanceId	NVARCHAR(255)
	DECLARE @v_WorkItemId			INT
	DECLARE @v_QueueId          	INT 
	DECLARE @v_NewQueueName     	NVARCHAR(255)
	DECLARE	@v_ProcessQuery	    	NVARCHAR(1000) 
	DECLARE	@v_QueueQuery	    	NVARCHAR(1000) 
	DECLARE	@v_Query	        	NVARCHAR(1000) 
	DECLARE @VersionNo          	INT
	
	/* Perform Validations */
	IF @DBProcessName IS NULL OR @DBNewProcessName IS NULL
	BEGIN
		SET @MainCode = 400
		SET @Message = 'ProcessName and NewProcessName are mandatory parameters.'
		RETURN
	END
	
	IF LEN(@DBNewProcessName)>60
	BEGIN
		SET @MainCode = 400
		SET @Message = 'NewProcessName should not be more than 60 characters.'
		RETURN
	END 
	
	IF @DBNewProcessName LIKE '%[^a-zA-Z0-9-_ ]%'
	BEGIN
		SET @MainCode = 400
		SET @Message = 'NewProcessName should not contain special characters'
		RETURN
	END
	
	/* Validate given process name */
	SELECT 1 FROM ProcessDefTable (NOLOCK) WHERE ProcessName = @DBProcessName
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		SET @MainCode = 400
		SET @Message ='Process ' + @DBProcessName + ' does not exist.'
		RETURN
	END
	
	/* Check for if new process name already present */
	IF EXISTS (SELECT 1 FROM ProcessDefTable (NOLOCK) WHERE ProcessName = @DBNewProcessName)
	BEGIN
		SET @MainCode = 400
		SET @Message ='Process with name ' + @DBNewProcessName + ' already exists. Please specify a different name.'
		RETURN
	END
	
	/*SELECT @FolderIndex = FolderIndex FROM PDBFolder WHERE Name = 'ProcessFolder'
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		SET @MainCode = 400
		SET @Message = 'ProcessFolder not found, hence ProcessName not changed.'
		RETURN
	END*/
	

	BEGIN TRANSACTION TxnChangeProcessName

	/* Find out ProcessDefId for given process name  */
	SELECT @v_ProcessQuery = 'SELECT ProcessDefId, VersionNo FROM ProcessDefTable (NOLOCK) WHERE ProcessName = ''' + @DBProcessName + ''''
	BEGIN
		EXECUTE('DECLARE ProcessCursor CURSOR Fast_Forward FOR ' + @v_ProcessQuery) 
			OPEN ProcessCursor 
				/* Fetch next row and close cursor in case of error */  
				FETCH NEXT FROM ProcessCursor INTO @ProcessDefId, @VersionNo
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
					UPDATE PDBFolder SET Name = @DBNewProcessName + ' V' + CONVERT(VARCHAR, @VersionNo)
					WHERE Name = @DBProcessName + ' V' + CONVERT(VARCHAR, @VersionNo)
					IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
						BEGIN
							CLOSE ProcessCursor
							DEALLOCATE ProcessCursor
							ROLLBACK TRANSACTION TxnChangeProcessName
							SET @MainCode = 400
							SET @Message = 'Updation of PDBFolder failed, hence ProcessName not changed.'
							RETURN
						END
						/* Insert the entry into WFAdminLogTable*/
					Insert into WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,Oldvalue,NewValue)values(82,convert(varchar(22), getDate(), 20),@ProcessDefId,@UserId,@Username,@DBProcessName,@DBNewProcessName) 
					IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
						BEGIN
							CLOSE ProcessCursor
							DEALLOCATE ProcessCursor
							ROLLBACK TRANSACTION TxnChangeProcessName
							SET @MainCode = 400
							SET @Message = 'Insertion into WFAdminLogTable failed, hence ProcessName not changed.'
						RETURN
					END
				FETCH NEXT FROM ProcessCursor INTO @ProcessDefId, @VersionNo
			 	END
			CLOSE ProcessCursor
		DEALLOCATE ProcessCursor
	END
	
    UPDATE ProcessDefTable SET ProcessName = @DBNewProcessName, lastModifiedOn = getDate() WHERE ProcessName = @DBProcessName
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of ProcessDefTable failed, hence ProcessName not changed.'
			RETURN
		END

	UPDATE PMWProcessDefTable SET ProcessName = @DBNewProcessName, lastModifiedOn = getDate() WHERE ProcessName = @DBProcessName --change for pmweb shubham PMWProcessDefTable
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of PMWProcessDefTable failed, hence ProcessName not changed.'
			RETURN
		END
		
	WHILE(1=1)
	BEGIN
	SELECT @v_Query = 'select TOP 100 processinstanceid,workitemid from wfinstrumenttable where ProcessName = '''+ @DBProcessName +''''
		BEGIN	
			EXECUTE('DECLARE FetchRecordCursor CURSOR Fast_Forward FOR ' + @v_Query) 
			 OPEN FetchRecordCursor 
				FETCH NEXT FROM FetchRecordCursor INTO @v_ProcessInstanceId, @v_WorkItemId
				IF(@@FETCH_STATUS <> 0) 
				BEGIN
					CLOSE FetchRecordCursor
					DEALLOCATE FetchRecordCursor
					BREAK;
				END
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
					UPDATE WFINSTRUMENTTABLE SET ProcessName = @DBNewProcessName WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
					IF (@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeProcessName
							SET @MainCode = 400
							SET @Message = 'Updation of WFINSTRUMENTTable failed, hence ProcessName not changed.'
							RETURN
						END
				     FETCH NEXT FROM FetchRecordCursor INTO @v_ProcessInstanceId, @v_WorkItemId
				END
			 CLOSE FetchRecordCursor
			 DEALLOCATE FetchRecordCursor
		END
	END

	/*UPDATE PDBDocument SET Name = @DBNewProcessName 
	WHERE DocumentIndex = (SELECT A.DocumentIndex 
				    FROM PDBDocumentContent A  WITH (NOLOCK), PDBDocument B WITH (NOLOCK)
				    WHERE A.DocumentIndex = B.DocumentIndex
				    AND A.parentFolderIndex = @FolderIndex
				    AND B.Name = @DBProcessName)
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of PDBDocument failed, hence ProcessName not changed.'
			RETURN
		END*/
		
	UPDATE ImportedProcessDefTable SET ImportedProcessName = @DBNewProcessName WHERE ImportedProcessName = @DBProcessName
	IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of ImportedProcessDefTable failed, hence ProcessName not changed.'
			RETURN
		END

	UPDATE InitiateWorkitemDefTable SET ImportedProcessName = @DBNewProcessName WHERE ImportedProcessName = @DBProcessName
	IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message ='Updation of InitiateWorkitemDefTable failed, hence ProcessName not changed.'
			RETURN
		END
    
	EXECUTE('sp_rename IDE_Reg_'+@DBProcessName+',IDE_Reg_'+@DBNewProcessName)
	IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message ='Updation of IDE_Reg_'+@DBProcessName+'Failed, hence ProcessName not changed.'
			RETURN
		END
	
	/* Update Queuename in QueueDefTable*/
	SELECT @v_QueueQuery = 'select QueueId, QueueName from queueDeftable where QueueName like '''+ @DBProcessName + '[_]%'''
		BEGIN	
			EXECUTE('DECLARE FetchQueueCursor CURSOR Fast_Forward FOR ' + @v_QueueQuery) 
			 OPEN FetchQueueCursor 
				/* Fetch next row and close cursor in case of error */  
				FETCH NEXT FROM FetchQueueCursor INTO @v_QueueId, @v_OldQueueName
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
				SELECT @v_NewQueueName = SUBSTRING(@v_OldQueueName, CHARINDEX(@DBProcessName,@v_OldQueueName)+LEN(@DBProcessName), LEN(@v_OldQueueName))
				SELECT @v_NewQueueName = @DBNewProcessName + @v_NewQueueName
				Execute WFchangeQueueName @v_OldQueueName, @v_NewQueueName, @UserId, @Username, @MainCode OUTPUT, @Message OUTPUT
				
              	IF(@MainCode <> 0)
					BEGIN
						CLOSE FetchQueueCursor
			            DEALLOCATE FetchQueueCursor
						ROLLBACK TRANSACTION TxnChangeProcessName
						SET @MainCode=@MainCode
						SET @Message=@Message
						RETURN
					END
				
                FETCH NEXT FROM FetchQueueCursor INTO @v_QueueId, @v_OldQueueName
			END
			 CLOSE FetchQueueCursor
			 DEALLOCATE FetchQueueCursor
			 
			 
	 update queueDeftable set processname=@DBNewProcessName where processname=@DBProcessName  
	 IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of queueDeftable failed, hence ProcessName not changed.'
			RETURN
		END
		
	update PMWqueueDeftable set processname=@DBNewProcessName where processname=@DBProcessName  --change for pmweb shubham PMWqueueDeftable
	 IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of PMWqueueDeftable failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update QUEUEHISTORYTABLE set processname=@DBNewProcessName where processname=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of QUEUEHISTORYTABLE failed, hence ProcessName not changed.'
			RETURN
		END
		
	 
	 update CHECKOUTPROCESSESTABLE set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of CHECKOUTPROCESSESTABLE failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSChangeProcessDefState set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSChangeProcessDefState failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSStreamOperation set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSStreamOperation failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSSetVariableMapping set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetVariableMapping failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSSetTurnAroundTime set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetTurnAroundTime failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSSetDynamicConstants set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetDynamicConstants failed, hence ProcessName not changed.'
			RETURN
		END
			 
	 update WFTMSSetQuickSearchVariables set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetQuickSearchVariables failed, hence ProcessName not changed.'
			RETURN
		END
		
	 update WFTMSSetCalendarData set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetCalendarData failed, hence ProcessName not changed.'
			RETURN
		END
	 update WFTMSAddCalendar set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSAddCalendar failed, hence ProcessName not changed.'
			RETURN
		END
	 
	 update WFTMSSetActionList set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFTMSSetActionList failed, hence ProcessName not changed.'
			RETURN
		END
	 update WFRecordedChats set ProcessName=@DBNewProcessName where ProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of WFRecordedChats failed, hence ProcessName not changed.'
			RETURN
		END
	 update CaseInitiateWorkitemTable set ImportedProcessName =@DBNewProcessName where ImportedProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of CaseInitiateWorkitemTable failed, hence ProcessName not changed.'
			RETURN
		END
	 
	 update CaseIMPORTEDPROCESSDEFTABLE set ImportedProcessName =@DBNewProcessName where ImportedProcessName=@DBProcessName
	  IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeProcessName
			SET @MainCode = 400
			SET @Message = 'Updation of CaseIMPORTEDPROCESSDEFTABLE failed, hence ProcessName not changed.'
			RETURN
		END
			 
			 
		END
	

	COMMIT TRANSACTION TxnChangeProcessName
	

	SET @MainCode = 0
	SET @Message = 'Process Name changed successfully.'
	
	RETURN


END

~

Print 'Stored Procedure WFChangeProcessName compiled successfully...'