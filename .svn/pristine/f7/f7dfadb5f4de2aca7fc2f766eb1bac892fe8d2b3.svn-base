/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Phoenix
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFChangeQueueName.sql
	Author				: Sakshi Gupta
	Date written (DD/MM/YYYY)	: 27/04/2017
	Description			: To change the queuename[Bugzilla Bug 68415].
------------------------------------------------------------------------------------------------------
					CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//  Date                Change By               Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
					
//27/04/2017    	    Sanal Grover   			Bug 68826 - Exception handling missing in Stored procedures for change in process name and queue name.

------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------*/
If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFCHANGEQUEUENAME')
BEGIN
	Execute('DROP PROCEDURE WFCHANGEQUEUENAME')
	Print 'Procedure WFCHANGEQUEUENAME already exists, hence older one dropped ..... '
END

~
CREATE PROCEDURE WFCHANGEQUEUENAME(

	@DBOldQueueName		NVarchar(255),
	@DBNewQueueName		NVarchar(255),
	@UserId             INT,
	@Username 			NVARCHAR(128),
	@MainCode           INT OUTPUT,
	@Message            NVARCHAR(1000) OUTPUT
	
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @OldQueueName			NVARCHAR(255)
	DECLARE @NewQueueName			NVARCHAR(255)
	DECLARE @FolderIndex			INT
	DECLARE @QueueId	    		INT
	DECLARE @rowCount	    		INT
	DECLARE @v_ProcessInstanceId	NVARCHAR(255)
	DECLARE @v_WorkItemId			INT
	DECLARE	@v_Query	        	NVARCHAR(1000) 

	Select  @OldQueueName = @DBOldQueueName
	Select  @NewQueueName = @DBNewQueueName

	/* Perform Validations */
	IF @OldQueueName IS NULL OR @NewQueueName IS NULL
	BEGIN
		SET @MainCode = 400
		SET @Message = 'OldQueueName and NewQueueName are mandatory parameters.'
		RETURN
	END
	
	/* Check for existance of queue and find its id */
	SELECT @QueueId = QueueId FROM QueueDefTable WHERE QueueName = @OldQueueName
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		SET @MainCode = 400
		SET @Message = 'Queue ' + @OldQueueName + ' does not exist..... '
		RETURN
	END

	/*Check for duplicacy of new queue name*/

	If Exists (Select 1 FROM QueueDefTable (NOLOCK) Where QueueName = @NewQueueName)
	BEGIN
		SET @MainCode = 400
		SET @Message = 'Queue ' + @NewQueueName + ' already exists.Please specify a different name..... '
		RETURN
	END

	/*SELECT @FolderIndex = FolderIndex FROM PDBFOLDER WHERE name='QueueFolder'
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		SET @MainCode = 400
		SET @Message = 'QueueFolder not found, hence QueueName not changed.'
		RETURN
	END
 
	UPDATE pdbdocument 
	SET name = @NewQueueName 
	WHERE documentindex = (Select A.DocumentIndex 
					FROM PDBDocumentContent A  with (NOLOCK) , PDBDocument B  with (NOLOCK) 
					WHERE A.DocumentIndex = B.DocumentIndex 
					AND A.parentFolderIndex = @FolderIndex
					AND B.Name = @OldQueueName)
		IF (@@ERROR <> 0 OR @@ROWCOUNT=0)
			BEGIN
				SET	@MainCode = 400  
				SET @Message = ' Updation of pdbdocument failed, hence QueueName not changed...'
				RETURN
			END*/
	
	UPDATE QUEUEDEFTABLE SET QueueName = @NewQueueName WHERE QueueID = @QueueId
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				SET	@MainCode = 400
				SET @Message = ' Updation of QUEUEDEFTABLE failed, hence QueueName not changed...'
				RETURN
			END
			
	UPDATE PMWQUEUEDEFTABLE SET QueueName = @NewQueueName WHERE QueueID = @QueueId -- CHANGES FOR  PMWQUEUEDEFTABLE
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				SET	@MainCode = 400
				SET @Message = ' Updation of PMWQUEUEDEFTABLE failed, hence QueueName not changed...'
				RETURN
			END
	
	WHILE(1=1)
	BEGIN
	SELECT @v_Query = 'select TOP 100 processinstanceid,workitemid from wfinstrumenttable where QueueName = '''+ @OldQueueName +''''
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
					UPDATE WFINSTRUMENTTABLE SET QueueName = @NewQueueName WHERE ProcessInstanceId = @v_ProcessInstanceId AND WorkitemId = @v_WorkItemId
					IF (@@ERROR <> 0)
						BEGIN
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

	
		/* Insert the entry into WFAdminLogTable*/
	INSERT INTO WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,QueueId,QueueName,Property,UserId,UserName,Oldvalue,NewValue)values(51,convert(varchar(22), getDate(), 20),0,@QueueID,@OldQueueName,'queueName',@UserId,@Username,@OldQueueName,@NewQueueName) 
	IF (@@ERROR <> 0)
			BEGIN
				SET	@MainCode = 400
				SET @Message = ' Insertion into WFAdminLogTable failed, hence QueueName not changed...'
				RETURN
			END
	
	SET @MainCode = 0
	SET @Message = ' QueueName changed successfully...'
    RETURN
END

~

Print 'Stored Procedure WFCHANGEQUEUENAME compiled successfully ........'