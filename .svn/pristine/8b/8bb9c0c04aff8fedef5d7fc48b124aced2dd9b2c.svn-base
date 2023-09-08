/*
-------------------------------------------------------------------------
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------------------------------------------------------
	Group				: Genesis
	Product				: omniFlow 10.x
	Module				: Transaction Server
	File Name			: WFDeleteUnusedWorkItems.sql
	Author				: Chitranshi Nitharia
	Date written		: July 30, 2019
	Description			: This procedure will delete WIs which are present on introduction more than specified days.
-------------------------------------------------------------------------
	CHANGE HISTORY
-------------------------------------------------------------------------
DATE		Change By				Change Description (Bug No. (If Any))
-------------------------------------------------------------------------
27/08/2019	Chitranshi Nitharia		Bug 85763 - To delete workitems and its document present on introduction workstep more than the specified days(minimum 10 days)
11/10/2019	Ravi Ranjan Kumar		Bug 85763 - To delete workitems and its document present on introduction workstep more than the specified days(minimum 10 days)(PRDP Bug Merging)
-------------------------------------------------------------------------
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'WFDeleteUnusedWorkItems')
BEGIN
  EXECUTE ('DROP PROCEDURE WFDeleteUnusedWorkItems')
END
~
create PROCEDURE WFDeleteUnusedWorkItems(
    @DBProcessDefId              INTEGER,
    @DBActivityId                INTEGER,
    @DBDeleteItemsOlderThanDays  INTEGER,
    @DBBatchSize                 INTEGER,
    @DBDebugMode                 INTEGER -- 1 = YES, 0 == NO
	--,@STATUS	 varchar(MAX) OUTPUT
) AS

BEGIN
SET XACT_ABORT ON
SET NOCOUNT ON
    Declare @v_existsflag                INTEGER
    Declare @v_processDefId              INTEGER
    Declare @v_activityId                INTEGER
    Declare @v_activityName              NVARCHAR(256)
    Declare @v_del_cursor                INTEGER
    Declare @v_processInstanceId         NVARCHAR(64)
    Declare @v_retval                    INTEGER
    Declare @v_status                    INTEGER
    Declare @v_var_Rec_1                 NVARCHAR(255)
    Declare @v_extTableName              NVARCHAR(255)
    Declare @v_deletestr                 NVARCHAR(2000)
    Declare @v_folderid                  INTEGER
    Declare @v_DBStatus                  INTEGER
    Declare @v_QueryStr                  NVARCHAR(1000)
    Declare @v_Str1                      NVARCHAR(1000)
    Declare @v_Str2                      NVARCHAR(1000)
    Declare @v_Str3                      NVARCHAR(1000)
    Declare @v_QueryStr2                 VARCHAR(1000)
	Declare @sql                         NVARCHAR(1000)
    Declare @v_ActivityType              NVARCHAR(64)
    Declare @v_rowCounter                INTEGER
    Declare @v_processInstanceState      INTEGER
    Declare @v_deleteItemsOlderThanDays  INTEGER
	Declare @objcursor as cursor 	
	DECLARE @SINGLE_QUOTE				 CHAR = CHAR(39)
	DECLARE @Query						 VARCHAR(2000)
	-- parameters for [PRTDeleteFolder]
	DECLARE @DBConnectId				 int 
	DECLARE @DBHostName					 NVARCHAR(30) 
	DECLARE @DBReferenceFlag 			 char(1) 
	DECLARE @DBGenerateLogFlag			 char(1) 
	DECLARE @DBLockFlag					 char(1)	 
	DECLARE @DBCheckOutFlag				 char(1) 
	DECLARE @DBParentFolderIndex		 int   
	DECLARE @DBTransactionFlag			 char(1)  
	DECLARE @DeleteFromISFlag			 char(1)  
	DECLARE @UserIndex					 INTEGER
	DECLARE @v_WFCurrentRouteLogTable	 varchar(30) 
	DECLARE @v_TotalPrTime		INTEGER
	DECLARE @v_TotalDuration 	INTEGER
	DECLARE @v_MainCode INTEGER
	 
	set @v_status = -1
    set @v_folderid = -1
    SET @v_DBStatus = -1
    set @v_processdefid = @DBProcessDefId
	SET @DBHostName = 'OmniFlow'
	SET @DBReferenceFlag = 'Y'
	SET @DBGenerateLogFlag = 'N'
	SET @DBLockFlag = 'Y'
	SET @DBCheckOutFlag = 'Y'
	SET @DBParentFolderIndex = null
	SET @DBTransactionFlag = 'N'
	SET @DeleteFromISFlag = 'Y'

	IF (@DBDebugMode = 1)
	BEGIN
        PRINT 'WFDeleteUnusedWorkItems started .. ' + convert(varchar, getdate(), 1)
    END 
	    
    IF (@DBProcessDefId IS NULL) OR (@DBProcessDefId <= 0)
    BEGIN
        IF (@DBDebugMode = 1) 
		BEGIN
            PRINT 'Error: It is mandatory to specify DBProcessDefId greater than zero.'
			--SET @STATUS = 'Failed invalid ProcessDefId';
        END 
        RETURN
    END

	BEGIN TRY 
        SELECT @v_ActivityType = ACTIVITYTYPE, @v_activityName = ActivityName
        FROM ACTIVITYTABLE
        WHERE ACTIVITYID = @DBActivityId
        AND PROCESSDEFID = @DBProcessDefId
    END TRY
	BEGIN CATCH  
		PRINT 'Error: Entry for the given activityId is missing in Activity Table.'
    END CATCH

	IF (@DBDebugMode = 1)
	BEGIN
        PRINT 'WFDeleteUnusedWorkItems after fetch data from ActivityTable .. ' + convert(varchar, getdate(), 1)
    END 

	IF (@v_ActivityType <> 1)
    BEGIN
        IF (@DBDebugMode = 1)
		BEGIN
            PRINT 'Error: Workitem is not at Introduction.'
			--SET @STATUS = 'Failed Workitem(s) not on introduction stage';
        END 
        RETURN
    END
	
	SET @v_deleteItemsOlderThanDays = @DBDeleteItemsOlderThanDays
	IF (@DBDeleteItemsOlderThanDays < 10)
    BEGIN
        SET @v_deleteItemsOlderThanDays = 10
        IF (@DBDebugMode = 1) 
		BEGIN
            PRINT 'WFDeleteUnusedWorkItems Resetting days to 10 ' + convert(varchar, getdate(), 1)
        END 
	END
    BEGIN TRY
        SELECT    @v_extTableName = TableName
        FROM      ExtDBConfTable
        WHERE     ProcessDefId = @v_processDefId AND extobjid = 1
    End TRY
	BEGIN CATCH
	  SET @v_extTableName = ''
	END CATCH 
   
    IF (@DBDebugMode = 1)
	BEGIN
        PRINT 'WFDeleteUnusedWorkItems Data fetched from ExtDBConfTable ' + convert(varchar, getdate(), 1)
    END
	BEGIN TRY
        set @v_existsflag = 0
		SELECT @v_existsflag = 1
        FROM sysobjects sobjects
        WHERE sobjects.xtype = 'U' and  UPPER(name) = UPPER(@v_extTableName)
    END TRY
	BEGIN CATCH
	    set @v_existsflag = 0
		--SET @STATUS = 'Failed invalid External Table'+@v_extTableName;
	END CATCH 
	-- block to insert user row in PDBConnection
	BEGIN TRY
	SELECT TOP 1 @UserIndex = PDBUser.UserIndex FROM PDBUser, PDBGroupMember WHERE PDBUser.UserIndex = PDBGroupMember.UserIndex AND UserAlive = 'Y' AND GroupIndex = 2
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PDBCONNECTION') AND  NAME = 'PRODUCTNAME')
	BEGIN
		EXECUTE ('INSERT INTO PDBConnection(RandomNumber, UserIndex, HostName, UserLoginTime, MainGroupId, UserType, AccessDateTime, StatusFlag, Locale, ApplicationName, ApplicationInfo) VALUES(12345, ' + @UserIndex + ', ''USER'', GETDATE(), 0, ''U'', GETDATE(), ''Y'', ''en-US'', ''SP'', ''SP'')')
	END
	ELSE
	BEGIN
		EXECUTE ('INSERT INTO PDBConnection(RandomNumber, UserIndex, HostName, UserLoginTime, MainGroupId, UserType, AccessDateTime, StatusFlag, Locale, ApplicationName, ApplicationInfo,ProductName) VALUES(12345, ' + @UserIndex + ', ''USER'', GETDATE(), 0, ''U'', GETDATE(), ''Y'', ''en-US'', ''SP'', ''SP'',''iBPS'')')	
	END
	
	IF (@DBDebugMode = 1)
	BEGIN
		PRINT 'Sucessfully Inserted in PDBConnection'
	END 
	END TRY
	BEGIN CATCH
	IF (@DBDebugMode = 1)
	BEGIN
		PRINT 'Error in PDBConnection insertion'
		--SET @STATUS = 'Failed invalid session';
		PRINT(error_message())
	END 
	END CATCH 
	
	SET @v_QueryStr = ' Select top '+CAST(@DBBatchSize AS NVARCHAR(10))+'  ProcessInstanceId,ProcessInstanceState,Var_Rec_1 , DATEDIFF(ss, EntryDateTime, GETDATE()) From WFINSTRUMENTTABLE where ROUTINGSTATUS = ''N'' AND LOCKSTATUS = ''N'' AND processdefid = ' + ISNULL(CAST(@DBProcessDefId AS NVARCHAR(10)), '') + ' and activityid = ' + ISNULL(CAST(@DBActivityId AS NVARCHAR(10)), '') + ' and CreatedDateTime  <= getdate()-  '+ISNULL(CAST(@v_deleteItemsOlderThanDays AS NVARCHAR(10)), '')
	
	IF (@DBDebugMode = 1)
	BEGIN
        PRINT 'v_QueryStr:'+ISNULL(@v_QueryStr, '')
    END 
	
	BEGIN TRY
	set @sql = 'set @v_cursor = cursor STATIC  for ' + @v_QueryStr + ' open @v_cursor;'
	  exec sys.sp_executesql @sql
      ,N'@v_cursor cursor output'
      ,@objcursor output
	END TRY
	BEGIN CATCH
	    PRINT 'Error in cursor declaration'
		PRINT(error_message())
	END CATCH
	BEGIN
		BEGIN 	
			IF (@DBDebugMode = 1)
			BEGIN
			
				PRINT 'WFDeleteUnusedWorkItems After opening cursor ' + convert(varchar, getdate(), 1)
            END 
		    Set	@v_rowCounter = 0
			FETCH  NEXT FROM @objcursor INTO @v_processInstanceId,@v_processInstanceState,@v_var_Rec_1 , @v_TotalDuration 
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				BEGIN TRY
					BEGIN TRANSACTION DELETEDATA
					IF (@DBDebugMode = 1)
					BEGIN
						PRINT 'WFDeleteUnusedWorkItems After fetching data from cursor ' + convert(varchar, getdate(), 1)
					END 
					IF (@v_processInstanceState <> 1)
					BEGIN
						IF (@DBDebugMode = 1) 
						BEGIN
							PRINT 'The processInstance is not in the NotStartedState, No need to delete'
						END 
					END
					ELSE
					BEGIN
						IF (@DBDebugMode = 1) 
						BEGIN
							PRINT 'WFDeleteUnusedWorkItems : Going ot delete from external table ' + convert(varchar, getdate(), 1)
						END 
						IF(@v_var_Rec_1 IS NOT NULL AND (cast(@v_var_Rec_1 as int) ) > 0)
						BEGIN
							IF(@v_existsflag = 1)
							BEGIN
								set @v_deletestr =' DELETE FROM ' + ISNULL(@v_extTableName, '') + ' WHERE ItemIndex = ''' + ISNULL(@v_var_Rec_1, '') +'''';
								IF (@DBDebugMode = 1)
								BEGIN
									PRINT 'WFDeleteUnusedWorkItems Ext Table delete query ' + isnull(@v_deletestr, '')
								END 
								EXECUTE sp_executesql @v_deletestr
								set @v_status = @@ERROR
							END
							IF (@DBDebugMode = 1) 
							BEGIN
								PRINT 'WFDeleteUnusedWorkItems After deleting from external table ' + convert(varchar, getdate(), 1)
							END 
							/* DELETE Folder corresponding to the process instance */
							set @v_folderid = (cast(@v_var_Rec_1 as int))
							IF (@v_folderid IS NOT NULL AND  @v_folderid > 0)


							BEGIN	
								IF (@DBDebugMode = 1)
								BEGIN
									PRINT 'Going to Execute PRTDELETEFolder' + convert(varchar, getdate(), 1)
								END 
								EXECUTE  PRTDELETEFolder '12345', @DBHostName, @v_folderid, @DBReferenceFlag, @DBGenerateLogFlag, @DBLockFlag, @DBCheckOutFlag, @DBParentFolderIndex, @DBTransactionFlag,@DeleteFromISFlag
								IF (@DBDebugMode = 1)
								BEGIN
									PRINT 'WFDeleteUnusedWorkItems after Executing PRTDELETEFolder Sucessfully' + convert(varchar, getdate(), 1)
								END
							END


						END
						EXECUTE('DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = N' + @SINGLE_QUOTE + @v_processInstanceId + @SINGLE_QUOTE)
						IF (@DBDebugMode = 1) 
						BEGIN
							PRINT 'WFDeleteUnusedWorkItems After deleting from WFInstrumentTable ' + convert(varchar, getdate(), 1)
						END 
						EXECUTE ('INSERT INTO WFProcessInstanceDelSuccess VALUES(N'''+@v_processInstanceId+''', '+@v_processDefId+', '+@DBActivityId+', convert(varchar, getdate(), 1))')	
						IF (@DBDebugMode = 1)
						BEGIN
							PRINT 'WFDeleteUnusedWorkItems After inserting in WFProcessInstanceDelSuccess ' + convert(varchar, getdate(), 1)
						END 
						EXECUTE WFGenerateLog 39, @UserIndex, @v_ProcessDefId, @v_ActivityId, 0, 'SYSTEM', @v_ActivityName, @v_TotalDuration, @v_ProcessInstanceId, 0, 'WFDeleteUnUsedWorkitems', 1,  0, 0, NULL,0 ,0 ,0 , NULL ,NULL, @v_MainCode OUT
						IF (@DBDebugMode = 1) 
						BEGIN
							PRINT 'WFDeleteUnusedWorkItems After inserting in WFCurrentRouteLogTable ' + convert(varchar, getdate(), 1)
						END
						SET @v_rowCounter = @v_rowCounter + 1
					END
					COMMIT TRANSACTION DELETEDATA
					IF (@DBDebugMode = 1)
					BEGIN
						PRINT 'WFDeleteUnusedWorkItems After Commit on Success ' + convert(varchar, getdate(), 1)
						--SET @STATUS = 'Sucessfully Deleted'
					END
				END TRY
				BEGIN CATCH
					PRINT 'ERROR IN WFDeleteUnusedWorkItems : ' + ERROR_MESSAGE()
					ROLLBACK TRANSACTION DELETEDATA
					BREAK;
					IF (@DBDebugMode = 1)
					BEGIN
						PRINT 'WFDeleteUnusedWorkItems After Rollback on Failure ' + convert(varchar, getdate(), 1)
						--SET @STATUS = ERROR_MESSAGE();
					END
					EXECUTE('INSERT INTO WFProcessInstanceDelFailure VALUES('+@v_processInstanceId+','+@v_processDefId+', '+@DBActivityId+', convert(varchar, getdate(), 1))')
					COMMIT
				END CATCH
				FETCH  NEXT FROM @objcursor INTO @v_processInstanceId,@v_processInstanceState, @v_var_Rec_1 , @v_TotalDuration 
			END
			CLOSE @objcursor
			DEALLOCATE @objcursor
		END
	END
	EXECUTE ('delete from PDBConnection where RandomNumber = ''12345''')
	IF (@DBDebugMode = 1)
					BEGIN
						PRINT 'Session deleted sucessfully from PDBConnection'
					END
	IF (@v_rowCounter = 0)
	BEGIN TRY
		IF (@DBDebugMode = 1)
		BEGIN
			PRINT 'Exiting........'
		END 
    END TRY
	BEGIN CATCH
		IF (@DBDebugMode = 1) 
		BEGIN
			PRINT 'Check!! Check!! An Exception occurred while execution of Stored Procedure WFDeleteUnusedWorkitems........'
			
	    CLOSE @objcursor
		DEALLOCATE @objcursor
		END 
	END CATCH
			 
	IF (@DBDebugMode = 1)
	if(@v_rowCounter = 0)
	BEGIN 
		PRINT 'No More Workitems'
	END
	BEGIN	
	    PRINT 'Stored Procedure WFDeleteUnusedWorkitems executed successfully........'	
	END 
	
END
