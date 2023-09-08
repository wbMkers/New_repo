/*--------------------------------------------------------------------------------------------------
 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------------
 Group				: Application � Products
 Product / Project		: WorkFlow 6.2
 Module				: Transaction Server
 File Name			: WFPurgeWorkItem.sql
 Author				: Vikram Kumbhar
 Date written (DD/MM/YYYY)	: 16/01/2008
 Description			: Script to purge workitem data from all tables in the database
----------------------------------------------------------------------------------------------------
 CHANGE HISTORY
----------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
 30/01/2008	Vikram Kumbhar		Bugzilla Bug 3731 WFPurgeWorkItem Stored Procedure giving error in SQL 2005
 03/08/2009	Harmeet Kaur		WFS_8.0_020	 Execute Stored Procedure updated to delete workitems from the new database tables created
 
 8/01/2014       Anwar Ali Danish  Changes done for code optimization
 11-02-2014		 Sajid Khan		   Changes done for Message Agent Optimization.
 15-02-2016		 Mohnish Chopra	   Changes done for Bug 59178		
 25-07-2017		 Shubhankur Manuja Changes for table name from IDE_REGISTRATIONNUMBER_processdefid to IDE_Reg_processname
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures 
01/08/2019 		Sourabh Tantuway	Bug 85812 - iBPS 4.0 + mssql: WFPurgeWorkitem procedure is only removing initiated and completed workitems.
16/01/2019      Sourabh Tantuway   Bug 89979 - iBPS 4.0 + oracle + mssql+ postgres : Archival Utility is not able to process workitem. Also old entries are present for workitems in wfaudittraildoctable even after purging workitem.
03/09/2020      Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain '-'
22/01/2021      Satyanarayan Sharma     Handling of new actionId for Purging workitem in process.
27/10/2022      Nikhil Garg             Bug 117793 - Support of Complex data deletion in Purge Procedure
--------------------------------------------------------------------------------------------------*/

IF Exists (SELECT * FROM SysObjects WHERE xType = 'P' and name = 'WFPurgeWorkItem')
BEGIN
	Execute('DROP PROCEDURE WFPurgeWorkItem')
	Print 'Procedure WFPurgeWorkItem already exists, hence older one dropped.'
END

~

CREATE PROCEDURE WFPurgeWorkItem(
	@DBConnectId		int,					/* Session Id of the Logged in User */
	@DBHostName		char(30),					/* 'USER' for User */
	@DBAPPInfo		VARCHAR(50),				/* IP address of Database*/
	@DBAPPName		VARCHAR(50),				/* Send 'OAP' in this parameter */
	@DBProcessInstanceId	nvarchar(64) = NULL, /* To be given For purging only single workitem*/
	@DBProcessDefId		int = NULL,				/*  To be given For purging process specific workitems */
	@DBActivityId		int = NULL,				/* To be given For purging workitems on a particular activity for a process */
	@DBStartDate		VARCHAR(50) = NULL, 	/* Start Date . Should be given in case workitems created in a particular date range are to be purged*/
	@DBEndDate		VARCHAR(50) = NULL,			/* End Date . Should be given in case workitems created in a particular date range are to be purged */
	@DBDeleteHistoryFlag	char(1) = 'Y',		/* Delete History Data Flag*/
	@DBDeleteExternalData	char(1) = 'Y',
	@DBResetProcessSeqFlag  VARCHAR(1),
	@DeleteComplexDataFlag char(1) = 'Y'
	)
AS

SET NOCOUNT ON

BEGIN
	DECLARE @ProcessInstanceId	nvarchar(64)
	DECLARE @var_Rec_1		nvarchar(255)
	DECLARE @ExtTableName		nvarchar(255)
	DECLARE @tableProcessRegistration nvarchar(255)
	DECLARE @ConditionStr		nvarchar(1000)
	DECLARE @PurgeMessageStr	nvarchar(500)
	DECLARE @DBReferenceFlag	char(1)
	DECLARE @DBGenerateLogFlag	char(1)
	DECLARE @DBLockFlag		char(1)
	DECLARE @DBCheckOutFlag		char(1)
	DECLARE @DBTransactionFlag	char(1)
	DECLARE	@DBParentFolderIndex	int
	DECLARE @DBStatus		int
	DECLARE	@DBUserId		int
	DECLARE	@MainGroupId		int
	DECLARE @FolderId		int
	DECLARE @ActivityType		int
	DECLARE @v_MainCode  INT
	Declare @ActivityName 	NVARCHAR(255)
	DECLARE	@ProcessName	VARCHAR(64)
	DECLARE @UserName		nvarchar(64)
	/* for purging complex data */
	Declare @inner_counter int;
	Declare @outer_counter int;
	Declare @RelationId int;
	Declare @MinRelationId int;
	Declare @OuterLoopvalue int;
	Declare @ChildObject nvarchar(MAX);
	Declare @ParentObject nvarchar(MAX);
	Declare @Refkey nvarchar(MAX);
	Declare @Foreignkey nvarchar(MAX);
	DECLARE @ParentObjectTypeFlag INT ;
	DECLARE @finalquery NVARCHAR(MAX);
	--Declare @DeleteComplexDataFlag CHAR(1);
	DECLARE @ComplexTableName NVARCHAR(255);
    /* */
	
	SELECT @ConditionStr = ''
	SELECT @PurgeMessageStr = ''
	SELECT @DBReferenceFlag = 'Y'
	SELECT @DBGenerateLogFlag = 'Y'
	SELECT @DBLockFlag = 'Y'
	SELECT @DBCheckOutFlag = 'Y'
	SELECT @DBTransactionFlag = 'N'
	SELECT @DBStatus = -1
	SELECT @DBUserId = 0	
	SELECT @MainGroupId = 0
	SELECT @DBParentFolderIndex = NULL
	SELECT @ActivityType = -1
	SELECT @FolderId = -1
	SELECT @finalquery=''
	
	
	/* Perform input parameter validation */
	IF (@DBProcessDefId IS NULL) OR (@DBProcessDefId <= 0)
	BEGIN
		PRINT 'Error: It is mandatory to specify ProcessDefId and it must be greater than zero.'
		RETURN
	END

	 --Check validity of User 
	EXECUTE PRTCheckUser @DBConnectId, @DBHostName, @DBUserId OUT, @MainGroupId OUT, @DBStatus OUT,@DBAPPInfo,@DBAPPName
	IF (@DBStatus <> 0)
	BEGIN
		PRINT 'Error: ConnectId of User is invalid.'
		SELECT Status = @DBStatus
		RETURN
	END 

	SELECT 	@UserName = UserName
	FROM 	PDBUser (NOLOCK)
	WHERE 	UserIndex = @DBUserId 
	
	/* Create temporary tables */
	If Exists (Select * FROM SysObjects WHERE xType = 'U' and name = 'WFPurgeFailureLogTable')
	Begin
		Drop TABLE WFPurgeFailureLogTable
		--Print 'WFPurgeFailureLogTable dropped successfully.'
	End

	If Not Exists (Select * FROM SysObjects WHERE xType = 'U' and name = 'WFPurgeFailureLogTable')
	Begin
		CREATE TABLE WFPurgeFailureLogTable(ProcessInstanceId NVARCHAR(64), ProcessDefId INT)
		--Print 'WFPurgeFailureLogTable created successfully.'
	End
	

	/* Generate condition string depending on input */
	SELECT @ConditionStr = 'ProcessDefId = ' + CONVERT(varchar(5), @DBProcessDefId) 

	IF @DBProcessInstanceId IS NOT NULL
	BEGIN
		SELECT @ConditionStr = @ConditionStr + ' AND A.ProcessInstanceId = ' + CHAR(39) + @DBProcessInstanceId + CHAR(39) 
	END

	IF @DBStartDate IS NOT NULL
	BEGIN
		SELECT @ConditionStr = @ConditionStr + ' AND CreatedDateTime >= ' + CHAR(39) + @DBStartDate + CHAR(39) 
	END

	IF @DBEndDate IS NOT NULL
	BEGIN
		SELECT @ConditionStr = @ConditionStr + ' AND CreatedDateTime <= ' + CHAR(39) + @DBEndDate + CHAR(39) 
	END

	IF @DBDeleteExternalData = 'Y'
	BEGIN
		SELECT @ExtTableName = TableName
		FROM ExtDBConfTable (NOLOCK)
		WHERE ProcessDefId = @DBProcessDefId
		AND EXTOBJID = 1

		IF Not Exists (SELECT * FROM SysObjects WHERE name = @ExtTableName)
		BEGIN
			SET @DBDeleteExternalData = 'N'
		END
	END
	
	IF @DeleteComplexDataFlag = 'Y'
	BEGIN
		SELECT TOP 1 @ComplexTableName = TableName
		FROM ExtDBConfTable (NOLOCK)
		WHERE ProcessDefId = @DBProcessDefId
		AND EXTOBJID > 2

		IF Not Exists (SELECT * FROM wfudtvarmappingtable WHERE MappedObjectName = @ComplexTableName)
		BEGIN
			SET @DeleteComplexDataFlag = 'N'
		END
	END
	
	
	/* for purging complex data - start  */
	IF @DeleteComplexDataFlag = 'Y'
	BEGIN
	
	IF Exists (SELECT * FROM SysObjects WHERE xType = 'U' and name = 'WFComplexDataDeleteQueryTable')
	BEGIN
		Drop TABLE WFComplexDataDeleteQueryTable
	END

	If Not Exists (SELECT * FROM SysObjects WHERE xType = 'U' and name = 'WFComplexDataDeleteQueryTable')
	BEGIN
		CREATE TABLE WFComplexDataDeleteQueryTable(ProcessDefId NVARCHAR(64), Query NVARCHAR(MAX), ParentObjectFlag int, OrderId INT IDENTITY(1,1))
	END
	
	
	SELECT @exttablename=tablename FROM EXTDBCONFTABLE WHERE ProcessDefId=@DBProcessDefId AND ExtObjID=1
	SELECT @RelationId= max(relationId) from wfvarrelationtable where processDefId=@DBProcessDefId
	SELECT @outer_counter=count(*) FROM WFVarRelationTable WHERE ProcessDefId=@DBProcessDefId
	
	WHILE (@outer_counter>0)
		BEGIN
		while (@RelationId>0)
			BEGIN
			if not exists (select * from wfvarrelationtable where relationId=@RelationId and processDefId=@DBProcessDefId)
			 BEGIN
			 select @RelationId=@RelationId-1
			 continue;
			 END
			 break;
			end
			
		SELECT @ChildObject= childobject from wfvarrelationtable where RelationId=@RelationId and processDefId=@DBProcessDefId
		Declare @LocalId int;
		Declare @query nvarchar(MAX);
		DECLARE @abc NVARCHAR(MAX);
		DECLARE @final NVARCHAR(MAX);
		DECLARE @new NVARCHAR(MAX);
		SELECT @abc=' '
		SELECT @new=' '
		SELECT @final=' '
		SELECT @LocalId=@RelationId-1;
		SELECT @query='Delete t from '+@ChildObject+ ' as t'
		
		SELECT @ParentObject= ParentObject from wfvarrelationtable where RelationId=@RelationId and processDefId=@DBProcessDefId
		SELECT @Refkey=Refkey from wfvarrelationtable where RelationId=@RelationId and processDefId=@DBProcessDefId
		SELECT @Foreignkey=Foreignkey from wfvarrelationtable where RelationId=@RelationId and processDefId=@DBProcessDefId
		SELECT @abc=' inner join '+ @ParentObject+ ' ON t' +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
		SELECT @inner_counter=@RelationId-1
		
		
			WHILE (@inner_counter>0)
				BEGIN 
				IF @ParentObject='WFINSTRUMENTTABLE' 
				BREAK;
				IF @ParentObject=@exttablename
				BEGIN
				BREAK;
				END
				SELECT @ChildObject= childobject from wfvarrelationtable where RelationId=@LocalId and processDefId=@DBProcessDefId
				
				IF @ParentObject <> @ChildObject
				BEGIN
				SELECT @LocalId=@LocalId-1
				SELECT @inner_counter=@inner_counter-1
				CONTINUE;
				END
				
				SELECT @ParentObject= ParentObject from wfvarrelationtable where RelationId=@LocalId and processDefId=@DBProcessDefId
				SELECT @Refkey=Refkey from wfvarrelationtable where RelationId=@LocalId and processDefId=@DBProcessDefId
				SELECT @Foreignkey=Foreignkey from wfvarrelationtable where RelationId=@LocalId and processDefId=@DBProcessDefId
				
				SELECT @abc=@abc + ' inner join '+ @ParentObject+ ' ON '+@ChildObject +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey 
				SELECT @LocalId=@LocalId-1
				SELECT @inner_counter=@inner_counter-1
				
			END
		IF @ParentObject=@exttablename
			BEGIN
			SELECT @final=@query+@abc+' where ItemIndex = '
			INSERT INTO WFComplexDataDeleteQueryTable VALUES(@DBProcessDefId,@final,1)
			SELECT @RelationId=@RelationId-1	
			SELECT @outer_counter=@outer_counter-1
			CONTINUE;
			END
		
		SELECT @final=@query+@abc +' where processinstanceid = '
		INSERT INTO WFComplexDataDeleteQueryTable VALUES(@DBProcessDefId,@final,2)
		SELECT @RelationId=@RelationId-1
		SELECT @outer_counter=@outer_counter-1
	END
	END
	
	/* for purging complex data - end  */



	/* Define the cursor */
	IF (@DBActivityId > 0)
	BEGIN
		SELECT @ActivityType = ActivityType ,@ActivityName = ActivityName
		FROM ActivityTable (NOLOCK)
		WHERE ProcessDefId = @DBProcessDefId
		AND ActivityId = @DBActivityId

		SELECT @ConditionStr = @ConditionStr + ' AND ActivityId =  ' + CONVERT(varchar(5), @DBActivityId)

		/* WFTransferData must be executed before running this script */
		IF (@ActivityType = 2 OR @ActivityType = 3) /* 2: Exit, 3: Discard */
		BEGIN
			EXECUTE('DECLARE purge_cursor CURSOR FAST_FORWARD FOR ' +
				' SELECT ProcessInstanceId, Var_Rec_1 ' +
				' FROM QueueHistoryTable A ' +
				' WHERE ' + @ConditionStr)
		END
		ELSE
		BEGIN
			EXECUTE('DECLARE purge_cursor CURSOR FAST_FORWARD FOR ' +
				' SELECT ProcessInstanceId, Var_Rec_1 '+
				' FROM QueueView A ' +
				' WHERE ' + @ConditionStr)
		END
	END
	ELSE
	BEGIN
		/*EXECUTE('DECLARE purge_cursor CURSOR FAST_FORWARD FOR ' +
			' SELECT A.ProcessInstanceId, Var_Rec_1 '+
			' FROM ProcessInstanceTable A, QueueDataTable B ' +
			' WHERE A.ProcessInstanceId = B.ProcessInstanceId ' +
			' AND ' + @ConditionStr + ' union all ' + 
			' SELECT ProcessInstanceId, Var_Rec_1 ' +
			' FROM QueueHistoryTable A ' + ' WHERE ' + @ConditionStr)*/
		EXECUTE('DECLARE purge_cursor CURSOR FAST_FORWARD FOR ' +
			' SELECT ProcessInstanceId, Var_Rec_1 '+
			' FROM WFINSTRUMENTTABLE A WHERE ' +			
			@ConditionStr + ' union all ' + 
			' SELECT ProcessInstanceId, Var_Rec_1 ' +
			' FROM QueueHistoryTable A ' + ' WHERE ' + @ConditionStr)
		
	END

	OPEN purge_cursor

	FETCH purge_cursor INTO @ProcessInstanceId, @var_Rec_1

	WHILE(@@FETCH_STATUS <> -1)
	BEGIN
		IF(@@FETCH_STATUS <> -2)
		BEGIN
			
			  
			BEGIN TRANSACTION PURGEDATA	
			
		
			
			
			/*for complex DATA  - start*/
			IF @DeleteComplexDataFlag='Y'
				BEGIN
					DECLARE purge_complex_cursor CURSOR FOR
					SELECT ParentObjectFlag, query FROM WFComplexDataDeleteQueryTable WHERE processdefid=@DBProcessDefId ORDER BY orderId
					OPEN purge_complex_cursor
					FETCH purge_complex_cursor INTO @ParentObjectTypeFlag, @query
					WHILE(@@FETCH_STATUS <>-1)
						BEGIN
							IF(@ParentObjectTypeFlag=1)
								BEGIN
								SELECT @finalquery=@query+N'@var_Rec_1'
								EXECUTE sp_executesql @finalquery,N'@var_Rec_1 nvarchar(max)',@var_Rec_1
								IF @@ERROR <> 0
								BEGIN
									ROLLBACK TRANSACTION PURGEDATA				
									INSERT INTO WFPurgeFailureLogTable
									VALUES(@ProcessInstanceId, @DBProcessDefId)
									GOTO ProcessNext
								END
								END
							ELSE
								BEGIN 
								SELECT @finalquery=@query+N'@ProcessInstanceId'
								EXECUTE sp_executesql @finalquery,N'@ProcessInstanceId nvarchar(max)',@ProcessInstanceId
								IF @@ERROR <> 0
								BEGIN
									ROLLBACK TRANSACTION PURGEDATA				
									INSERT INTO WFPurgeFailureLogTable
									VALUES(@ProcessInstanceId, @DBProcessDefId)
									GOTO ProcessNext
								END
								END
							
							FETCH NEXT FROM purge_complex_cursor INTO @ParentObjectTypeFlag, @query
							IF @@ERROR <> 0
								BEGIN
									CLOSE purge_complex_cursor
									DEALLOCATE purge_complex_cursor
									RETURN
								END
						END
					CLOSE purge_complex_cursor
					DEALLOCATE purge_complex_cursor
					
				END
			/*for complex DATA  - end*/
			
			DELETE FROM WFReminderTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WFLinksTable WHERE ChildProcessInstanceId = @ProcessInstanceId OR ParentProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM QueueHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)				
				GOTO ProcessNext
			END
			
			/*DELETE FROM QueueDataTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM ProcessInstanceTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WorkListTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WorkInProcessTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			
			DELETE FROM WorkDoneTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WorkWithPSTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END */
			
			DELETE FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM ExceptionTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM ToDoStatusTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM ExceptionHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA				
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM ToDoStatusHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END


			DELETE FROM WFMailQueueTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END						

			DELETE FROM WFMailQueueHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			
			DELETE FROM WFEscalationTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END

			DELETE FROM WFReportDataTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			/*Changes done by Kimil for CQRN-90326*Start*/
			DELETE FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFCommentsTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFRTTaskInterfaceAssocTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			
			DELETE FROM WFTaskStatusTable WHERE ProcessInstanceId = @ProcessInstanceId
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA			
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
		
			DELETE FROM WFCommentsHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFATTRIBUTEMESSAGEHISTORYTABLE WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFRTTASKINTFCASSOCHISTORY WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFTaskStatusHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			DELETE FROM WFReportDataHistoryTable WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			
			DELETE FROM WFAUDITTRAILDOCTABLE WHERE ProcessInstanceId = @ProcessInstanceId		/*bug 89979*/
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
			
			----Custom Data Procedure Start----
			EXEC WFPurgeCustomData @ProcessInstanceId,@DBProcessDefId
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION PURGEDATA 		
				INSERT INTO WFPurgeFailureLogTable
				VALUES(@ProcessInstanceId, @DBProcessDefId)
				GOTO ProcessNext
			END
		    ----Custom Data Procedure end------
			/*Changes done by Kimil for CQRN-90326*End*/
			IF @DBDeleteHistoryFlag = 'Y'
			BEGIN
				DELETE FROM WFCurrentRouteLogTable WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION PURGEDATA 		
					INSERT INTO WFPurgeFailureLogTable
					VALUES(@ProcessInstanceId, @DBProcessDefId)
					GOTO ProcessNext
				END
			
				DELETE FROM WFHistoryRouteLogTable WHERE ProcessInstanceId = @ProcessInstanceId		/*WFS_8.0_020*/
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION PURGEDATA			
					INSERT INTO WFPurgeFailureLogTable
					VALUES(@ProcessInstanceId, @DBProcessDefId)
					GOTO ProcessNext
				END
				
			END

			IF @DBDeleteExternalData = 'Y'
			BEGIN
				IF (@var_rec_1 IS NOT NULL AND @var_rec_1 > '0')
				BEGIN
					EXECUTE ('DELETE FROM '+ @ExtTableName +' WHERE ItemIndex = '+ @var_rec_1 )
					IF @@ERROR <> 0
					BEGIN	
						ROLLBACK TRANSACTION PURGEDATA			
						INSERT INTO WFPurgeFailureLogTable
						VALUES(@ProcessInstanceId, @DBProcessDefId)
						GOTO ProcessNext
					END
				END
			 END

			/* Delete folder corresponding to the Process Instance */
			IF (@var_rec_1 IS NOT NULL AND @var_rec_1 > '0')
			begin
				SELECT @FolderId = CONVERT(INT, @var_Rec_1)
				EXECUTE @DBStatus = PRTDELETEFolder @DBConnectId, @DBHostName, @FolderId, @DBReferenceFlag, @DBGenerateLogFlag, @DBLockFlag, @DBCheckOutFlag, @DBParentFolderIndex, @DBTransactionFlag
				IF (@DBStatus <> 0)
				BEGIN	
					SELECT Status = @DBStatus
					ROLLBACK TRANSACTION PURGEDATA				
					INSERT INTO WFPurgeFailureLogTable
					VALUES(@ProcessInstanceId, @DBProcessDefId)
					GOTO ProcessNext
				END
			end
			


			COMMIT TRANSACTION PURGEDATA
		END
		ProcessNext:
		FETCH NEXT FROM purge_cursor INTO @ProcessInstanceId, @var_Rec_1 
		IF @@ERROR <> 0
		BEGIN
			CLOSE purge_cursor
			DEALLOCATE purge_cursor
			RETURN
		END
	END

	CLOSE purge_cursor
	DEALLOCATE purge_cursor
	
	if @DBResetProcessSeqFlag = 'Y'
	BEGIN
	If Not Exists (Select * FROM WFINSTRUMENTTABLE WHERE ProcessDefId = @DBProcessDefId)
	BEGIN
		UPDATE ProcessDefTable
		SET RegStartingNo = 0
		WHERE ProcessDefId = @DBProcessDefId
		select @ProcessName=processname   from processdeftable where processdefid = @DBProcessDefId
		SELECT @ProcessName = REPLACE(@ProcessName,' ','')
		Select @tableProcessRegistration = 'IDE_Reg_' + CONVERT(varchar,@ProcessName)
		SELECT @tableProcessRegistration = REPLACE(@tableProcessRegistration,'-','_')
		If Exists (Select * FROM SysObjects WHERE xType = 'U' and name = 'IDE_Reg_' + CONVERT(varchar,@ProcessName))
		Begin
			EXECUTE('Drop table '+ @tableProcessRegistration)
			--print 'Table dropped '+@tableProcessRegistration
		End
			--print 'Table created '+@tableProcessRegistration
		EXECUTE('Create Table '+ @tableProcessRegistration+'(seqId	INT IDENTITY (1,1))')
		Delete from SummaryTable where processdefid = @DBProcessDefId		/*WFS_8.0_020*/
		Delete from WFActivityReportTable where processdefid = @DBProcessDefId	/*WFS_8.0_020*/
	END
	END
	INSERT INTO WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,NewValue)values(511,convert(varchar(22), getDate(), 20),@DBProcessDefId,@DBUserId, @UserName, null) 
	
END


~

Print 'Stored Procedure WFPurgeWorkItem compiled successfully.'
~