/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS 
	Module				: Transaction Server
	File Name			: WFChangeActivityName.sql (mssql)
	Author				: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 11/01/2018
	Description			: Stored procedure to change activity name.
______________________________________________________________________________________________________
				CHANGE HISTORY
07/02/2018		Ambuj Tripathi		Change in case management table names.
22/04/2018  	Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
30/04/2018      Kumar Kimil         Bug 77370 - EAP 6.4+SQL: Unable to rename the system workstep (for E.g: Export) in Modify Activity Screen
______________________________________________________________________________________________________*/


IF EXISTS (SELECT * FROM SysObjects (NOLOCK) WHERE xType = 'P' and Name = 'WFChangeActivityName')
BEGIN
	EXECUTE ('Drop Procedure WFChangeActivityName')
	PRINT 'Procedure WFChangeActivityName already exists, hence older one dropped...'
End

~

CREATE PROCEDURE WFChangeActivityName(
	@DBProcessDefId		INT,
	@DBActivityName		NVARCHAR(64),
	@DBNewActivityName	NVARCHAR(64),
	@UserId             INT,
	@UserName			NVARCHAR(128),
	@MainCode           INT OUTPUT,
	@Message            NVARCHAR(1000) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ActivityId		INT
	DECLARE @ActivityType		SMALLINT
	DECLARE @QueryStr		NVARCHAR(2000)
	DECLARE @ActionId		INT
	DECLARE @v_OldQueueName		NVARCHAR(255)
	DECLARE @v_QueueId          INT 
	DECLARE @v_NewQueueName     NVARCHAR(255)
	DECLARE @ProcessName		NVARCHAR(255)
	DECLARE @v_ProcessInstanceId	NVARCHAR(255)
	DECLARE @FolderIndex		INT
	DECLARE	@QueueId			NVARCHAR(255)
	DECLARE @v_Query			NVARCHAR(2000)
	DECLARE	@v_WorkItemId		NVARCHAR(255)
	DECLARE @OldQueueName		NVARCHAR(255)
	DECLARE @NewQueueName		NVARCHAR(255)
	DECLARE @ER					INT
	DECLARE @RC					INT

	/* Perform Validations */
	IF @DBProcessDefId IS NULL OR @DBActivityName IS NULL OR @DBNewActivityName IS NULL
	BEGIN
		SET @MainCode = 400
		SET @Message  = 'ProcessDefId, ActivityName and NewActivityName are mandatory parameters.'
		RETURN
	END

	/* Trim Inputs */
	SELECT @DBActivityName = LTRIM(RTRIM(@DBActivityName))
	SELECT @DBNewActivityName = LTRIM(RTRIM(@DBNewActivityName))
	
	/* Check for New Activity Name length */
	IF LEN(@DBNewActivityName) > 30
	BEGIN
		SET @MainCode = 400
		SET @Message = 'New Activity Name can not be more than 30 character'
		
		RETURN
	END
	
	/* Check for valid New Activity Name */
	IF @DBNewActivityName LIKE '%[^a-zA-Z0-9-_ ]%'
	BEGIN
		SET @MainCode = 400
		SET @Message = 'New Activity Name should not contain special characters'
		RETURN
	END

	/* Activity Name cannot be SaveStage or PreviousStage */
	IF UPPER(@DBNewActivityName) IN ('SAVESTAGE', 'PREVIOUSSTAGE')
	BEGIN
		SET @MainCode = 400
		SET @Message = 'New Activity Name cannot be SaveStage or PreviousStage.'
		
		RETURN
	END

	/* Find out ActivityId for given process id and activity name */
	SELECT @ActivityId = ActivityId, @ActivityType = ActivityType
	FROM ActivityTable (NOLOCK)
	WHERE ProcessDefId = @DBProcessDefId
	AND ActivityName = @DBActivityName
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		SET @MainCode = 400
		SET @Message =	'Activity ' + @DBActivityName + ' does not exist.'
		RETURN
	END

	/* Check for if new activity name already exists in given process */
	IF EXISTS (SELECT 1 FROM ActivityTable (NOLOCK) WHERE ProcessDefId = @DBProcessDefId AND ActivityName = @DBNewActivityName)
	BEGIN
		SET @MainCode = 400
		SET @Message = 'Activity with name ' + @DBNewActivityName + ' already exists in process. Please specify a different name.'
		RETURN
	END

	BEGIN TRANSACTION TxnChangeActivityName
	
		/* Update ActivityName in ActivityTable */
		UPDATE ActivityTable 
		SET ActivityName = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of ActivityName in ActivityTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update ExpiryActivity in ActivityTable for activities having ActivityType 10(Custom) or 4(Hold) */
		UPDATE ActivityTable 
		SET ExpiryActivity = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND ActivityType IN (4, 10) AND ExpiryActivity = @DBActivityName
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of ExpiryActivity in ActivityTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update PrimaryActivity in ActivityTable for activities having ActivityType 6(Collect) */
		UPDATE ActivityTable 
		SET PrimaryActivity = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND ActivityType = 6 AND PrimaryActivity = @DBActivityName
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of PrimaryActivity in ActivityTable failed, hence ActivityName not changed.'
			RETURN
		END
		
		/* If ActivityType is 1(Work Introduction), then update IntroducedAt in WFInstrumentTable */
		IF (@ActivityType = 1)
		BEGIN
			WHILE(1=1)
				BEGIN
					SELECT @QueryStr = 'SELECT TOP 100 ProcessInstanceId FROM WFInstrumentTable WHERE ProcessDefId = ' + convert(VARCHAR, @DBProcessDefId) + ' AND IntroducedAt =' + CHAR(39) + @DBActivityName + CHAR(39)
					BEGIN	
						EXECUTE('DECLARE cur_UpdateActivityName CURSOR Fast_Forward  FOR ' + @QueryStr) 
						IF(@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeActivityName
							SET @MainCode = 400
							SET @Message = 'Could not create the cursor.'
							return
						END
						OPEN cur_UpdateActivityName 
						IF(@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeActivityName
							SET @MainCode = 400
							SET @Message = 'Error in opening the procedure.'
							return
						END
						FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
						--print @v_ProcessInstanceId
						IF(@@FETCH_STATUS <> 0) 
						BEGIN
							CLOSE cur_UpdateActivityName
							DEALLOCATE cur_UpdateActivityName
							BREAK;
						END
						WHILE (@@FETCH_STATUS = 0) 	
						BEGIN
							select @QueryStr = 'UPDATE WFInstrumentTable SET IntroducedAt = ' + CHAR(39)+ @DBNewActivityName + CHAR(39)+' WHERE ProcessInstanceId = ' + CHAR(39)+ @v_ProcessInstanceId + CHAR(39)
							--print @QueryStr
							EXECUTE (@QueryStr)
							IF (@@ERROR <> 0)
								BEGIN
									CLOSE cur_UpdateActivityName
									DEALLOCATE cur_UpdateActivityName
									ROLLBACK TRANSACTION TxnChangeActivityName
									SET @MainCode = 400
									SET @Message = 'Updation of IntroducedAt in WFInstrumentTable failed, hence ActivityName not changed.'
									RETURN
								END
							 FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
						END
						CLOSE cur_UpdateActivityName
						DEALLOCATE cur_UpdateActivityName
					END
				END
		END

		/* Update ActivityName in WFInstrumentTable */
		WHILE(1=1)
		BEGIN
			SELECT @QueryStr = 'SELECT TOP 100 ProcessInstanceId FROM WFInstrumentTable WHERE ProcessDefId = ' + convert(VARCHAR, @DBProcessDefId) + ' AND ActivityName =' + CHAR(39) + @DBActivityName + CHAR(39)
			--Print 'Update ActivityName in WFInstrumentTable : ' + @QueryStr
			BEGIN	
				EXECUTE ('DECLARE cur_UpdateActivityName CURSOR Fast_Forward FOR ' + @QueryStr)
				IF( @@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt create.'
					RETURN
				END
				OPEN cur_UpdateActivityName 
				IF(@@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt open.'
					RETURN
				END
				FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				IF(@@FETCH_STATUS <> 0) 
				BEGIN
					CLOSE cur_UpdateActivityName
					DEALLOCATE cur_UpdateActivityName
					BREAK;
				END
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
					SELECT @QueryStr = 'UPDATE WFInstrumentTable SET ActivityName = ' + CHAR(39) + @DBNewActivityName + CHAR(39) + ' WHERE ProcessInstanceId = ' + CHAR(39) + @v_ProcessInstanceId + CHAR(39)
					--Print @QueryStr
					EXECUTE(@QueryStr) 
					IF (@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeActivityName
							SET @MainCode = 400
							SET @Message = 'Updation of WFInstrumentTable failed, hence ActivityName not changed.'
							CLOSE cur_UpdateActivityName
							DEALLOCATE cur_UpdateActivityName
							RETURN
						END
					 FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				END
				 CLOSE cur_UpdateActivityName
				 DEALLOCATE cur_UpdateActivityName
			END
		END
		
		--Print 'Update ActivityName in WFInstrumentTable : complete'

		/* Update PreviousStage in WFInstrumentTable */
		WHILE(1=1)
		BEGIN
			SELECT @QueryStr = 'SELECT TOP 100 ProcessInstanceId FROM WFInstrumentTable WHERE ProcessDefId = ' + convert(VARCHAR, @DBProcessDefId) + ' AND PreviousStage =' + CHAR(39) + @DBActivityName + CHAR(39);
		
			--Print 'Update PreviousStage in WFInstrumentTable : ' + @QueryStr
		
			BEGIN	
				EXECUTE('DECLARE cur_UpdateActivityName CURSOR Fast_Forward FOR ' + @QueryStr) 
				IF( @@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt open.'
					RETURN
				END
				OPEN cur_UpdateActivityName 
				IF( @@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt open.'
					RETURN
				END
				FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				IF(@@FETCH_STATUS <> 0) 
				BEGIN
					CLOSE cur_UpdateActivityName
					DEALLOCATE cur_UpdateActivityName
					BREAK;
				END
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
					SELECT @QueryStr = 'UPDATE WFInstrumentTable SET PreviousStage = ' + CHAR(39) + @DBNewActivityName + CHAR(39) + 'WHERE ProcessInstanceId = ' + CHAR(39) + @v_ProcessInstanceId + CHAR(39);
					EXECUTE(@QueryStr) 
					IF (@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeActivityName
							SET @MainCode = 400
							SET @Message = 'Updation of PreviousStage in WFInstrumentTable failed, hence ActivityName not changed.'
							RETURN
						END
					 FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				END
				 CLOSE cur_UpdateActivityName
				 DEALLOCATE cur_UpdateActivityName
			END
		END
		
		--Print 'Update PreviousStage in WFInstrumentTable : complete'
				
		/* Update SaveStage in WFInstrumentTable */
		WHILE(1=1)
		BEGIN
			SELECT @QueryStr = 'SELECT TOP 100 ProcessInstanceId FROM WFInstrumentTable WHERE ProcessDefId = ' + convert(VARCHAR, @DBProcessDefId) + ' AND SaveStage =' + CHAR(39) + @DBActivityName + CHAR(39)

		--Print 'Update SaveStage in WFInstrumentTable : ' + @QueryStr

			BEGIN	
				EXECUTE('DECLARE cur_UpdateActivityName CURSOR Fast_Forward FOR ' + @QueryStr) 
				IF( @@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt create.'
					RETURN
				END
				 OPEN cur_UpdateActivityName 
				IF( @@ERROR <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message = 'Cursor for activityname change in wfinstrumenttable couldnt open.'
					RETURN
				END
				FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				IF(@@FETCH_STATUS <> 0) 
				BEGIN
					CLOSE cur_UpdateActivityName
					DEALLOCATE cur_UpdateActivityName
					BREAK;
				END
				WHILE (@@FETCH_STATUS = 0) 	
				BEGIN
					SELECT @QueryStr = 'UPDATE WFInstrumentTable SET SaveStage = ' + CHAR(39) + @DBNewActivityName + CHAR(39) + 'WHERE ProcessInstanceId = ' + CHAR(39) + @v_ProcessInstanceId + CHAR(39);
					EXECUTE(@QueryStr) 
					IF (@@ERROR <> 0)
						BEGIN
							ROLLBACK TRANSACTION TxnChangeActivityName
							SET @MainCode = 400
							SET @Message = 'Updation of WFInstrumentTable failed, hence ActivityName not changed.'
							RETURN
						END
					 FETCH NEXT FROM cur_UpdateActivityName INTO @v_ProcessInstanceId
				END
				 CLOSE cur_UpdateActivityName
				 DEALLOCATE cur_UpdateActivityName
			END
		END
		--Print 'Update SaveStage in WFInstrumentTable : complete'
		/* Update ActivityName in ActivityInterfaceAssocTable */
		UPDATE ActivityInterfaceAssocTable 
		SET ActivityName = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of ActivityName in ActivityInterfaceAssocTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update ActivityName in ExceptionTable */
		UPDATE ExceptionTable 
		SET ActivityName = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of ActivityName in ExceptionTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update Param1 in RuleOperationTable for operation having type 4(Route To) or 21(Distribute To) */
		UPDATE RuleOperationTable
		SET Param1 = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND OperationType IN (4, 21) AND Param1 = @DBActivityName
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of Param1 in RuleOperationTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update Param2 in RuleConditionTable for conditions having Param1 SaveStage or PreviousStage */
		UPDATE RuleConditionTable
		SET Param2 = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND UPPER(Param1) IN ('SAVESTAGE', 'PREVIOUSSTAGE')  AND Param2 = @DBActivityName
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of Param2 in RuleConditionTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update Param2 in ActionConditionTable for conditions having Param1 SaveStage or PreviousStage */
		UPDATE ActionConditionTable
		SET Param2 = @DBNewActivityName
		WHERE ProcessDefId = @DBProcessDefId AND UPPER(Param1) IN ('SAVESTAGE', 'PREVIOUSSTAGE')  AND Param2 = @DBActivityName
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of Param2 in ActionConditionTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update LastModifiedOn in ProcessDefTable, so that cache will be updated */
		UPDATE ProcessDefTable
		SET lastModifiedOn = getDate()
		WHERE ProcessDefId = @DBProcessDefId
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Updation of ProcessDefTable failed, hence ActivityName not changed.'
			RETURN
		END

		/* Update Queuename in QueueDefTable*/
		BEGIN
			IF (@ActivityType != 2 AND @ActivityType != 20) /* If the activity is end activity */
				BEGIN
					SELECT @v_QueueId = QueueId FROM QueueStreamTable WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId;
					select @RC = @@ROWCOUNT
					IF (@@ERROR <> 0 OR @RC = 0)
					BEGIN
						ROLLBACK TRANSACTION TxnChangeActivityName
						SET @MainCode = 400
						SET @Message =	'Process does not exist.'
						RETURN
					END
				END
			ELSE
				BEGIN
					select @RC = 0
				END
			
			IF (@RC > 0)
			BEGIN
				SELECT @v_OldQueueName = QueueName FROM QueueDeftable WHERE QueueId = @v_QueueId
				--PRINT 'Queue Name : ' + Convert(VARCHAR,@v_OldQueueName)
				SELECT @v_NewQueueName = SUBSTRING(@v_OldQueueName, 0, CHARINDEX(@DBActivityName,@v_OldQueueName))

				/* Change the queuename in the all related tables, its not mendatory since the swimlane queue contains the activities too */
				--print 'New Queue Name : ' + @v_NewQueueName
				IF (@v_NewQueueName IS NULL OR @v_NewQueueName = '')
					BEGIN
						PRINT 'Either OldQueueName OR NewQueueName are Empty, so skipping renaming queue.'
					END
				ELSE
					BEGIN
						SELECT @v_NewQueueName =  @v_NewQueueName + @DBNewActivityName
						--print 'udpated queueName : ' + @v_NewQueueName
						/*Check for duplicacy of new queue name*/
						If Exists (Select 1 FROM QueueDefTable (NOLOCK) Where QueueName = @v_NewQueueName)
							BEGIN
								PRINT 'NewQueueName already exists, so skipping renaming queue.'
							END
						ELSE
							BEGIN
								/*Update QueueDefTable*/
								select @QueryStr = 'UPDATE QUEUEDEFTABLE SET QueueName = ' + CHAR(39) + @v_NewQueueName + CHAR(39) + ' WHERE QueueID = ' + convert(VARCHAR,@v_QueueId);
								--print @QueryStr
								EXECUTE(@QueryStr)
									IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
										BEGIN
											ROLLBACK TRANSACTION TxnChangeActivityName
											SET	@MainCode = 400
											SET @Message = ' Updation of QUEUEDEFTABLE failed, hence QueueName not changed...'
											RETURN
										END
								
								/* UPdate WFInstrumentTable */
								WHILE(1=1)
								BEGIN
									SELECT @v_Query = 'select TOP 100 processinstanceid,workitemid from wfinstrumenttable where QueueName = '''+ @v_OldQueueName +''''
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
												UPDATE WFINSTRUMENTTABLE SET QueueName = @v_NewQueueName WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
												IF (@@ERROR <> 0)
													BEGIN
														ROLLBACK TRANSACTION TxnChangeActivityName
														SET	@MainCode = 400
														SET @Message = ' Updation of WFINSTRUMENTTABLE failed, hence QueueName not changed...'
														RETURN
													END
												FETCH NEXT FROM FetchRecordCursor INTO @v_ProcessInstanceId, @v_WorkItemId
											END
										 CLOSE FetchRecordCursor
										 DEALLOCATE FetchRecordCursor
									END
								END
								
								/* Insert the entry into WFAdminLogTable for change in QueueName*/
								INSERT INTO WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,QueueId,QueueName,Property,UserId,UserName,Oldvalue,NewValue)values(51,convert(varchar(22), getDate(), 20),0,@QueueID,@OldQueueName,'queueName',@UserId,@Username,@OldQueueName,@NewQueueName) 
								IF (@@ERROR <> 0)
									BEGIN
										ROLLBACK TRANSACTION TxnChangeActivityName
										SET	@MainCode = 400
										SET @Message = ' Insertion into WFAdminLogTable failed, hence QueueName not changed...'
										RETURN
									END
							END
					END
	
				IF(@MainCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION TxnChangeActivityName
					SET @MainCode = 400
					SET @Message ='Updation of queuename in QueueDefTable failed, hence ActivityName not changed.'
					RETURN
				END
			END
		END
		
		/* Update the CaseSummaryDetailsTable for case management */
		BEGIN
			UPDATE WFCaseSummaryDetailsTable
			SET ActivityName = @DBNewActivityName
			WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId AND ActivityName = @DBActivityName
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION TxnChangeActivityName
				SET @MainCode = 400
				SET @Message = 'Updation of ActivityName in CaseSummaryDetailsTable failed, hence ActivityName not changed.'
				RETURN
			END
		END

		/*Update the CaseSummaryDetailsHistory for case management*/
		BEGIN
			UPDATE WFCaseSummaryDetailsHistory
			SET ActivityName = @DBNewActivityName
			WHERE ProcessDefId = @DBProcessDefId AND ActivityId = @ActivityId AND ActivityName = @DBActivityName
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION TxnChangeActivityName
				SET @MainCode = 400
				SET @Message = 'Updation of ActivityName in CaseSummaryDetailsHistory failed, hence ActivityName not changed.'
				RETURN
			END
		END
		
		/*Generate log of event activity name changed */
		
		Insert into WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,Oldvalue,NewValue)values(81,convert(varchar(22), getDate(), 20),@DBProcessDefId,@UserId,@UserName,@DBActivityName,@DBNewActivityName)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION TxnChangeActivityName
			SET @MainCode = 400
			SET @Message = 'Insertion into WFMessageTable failed, hence ActivityName not changed.'
			RETURN
		END
	COMMIT TRANSACTION TxnChangeActivityName

	SET @MainCode = 0
	SET @Message ='Activity Name changed successfully.'
	--PRINT 'Activity Name changed successfully.'

END

~

PRINT 'Stored Procedure WFChangeActivityName compiled successfully...'
