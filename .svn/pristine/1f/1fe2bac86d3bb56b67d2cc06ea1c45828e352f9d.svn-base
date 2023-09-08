	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : SetAndMigrateTransactionalData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Initialize Values To Start 
								  Transactional Data Migration
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	19/7/2019	Ambuj Tripathi	Multiple bugs fixed, Added support to skip deletion of External/history tables data.
	03/12/2019	Ambuj Tripathi	Multiple Bugs fixed for CTS - BugId#88851
	21/11/2022  Nikhil Garg     Bug 119354 - Support of Nested Complex data Archival in Archival Solution
	____________________________________________________________________________________*/
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'SetAndMigrateTransactionalData')
	Begin
		Execute('DROP PROCEDURE SetAndMigrateTransactionalData')
		Print 'Procedure SetAndMigrateTransactionalData already exists, hence older one dropped ..... '
	End

	~

	create Procedure SetAndMigrateTransactionalData
	(	 
		@v_sourceCabinet      		VARCHAR(256),
		@v_targetCabinet      		VARCHAR(256),
		@v_isDBLink			  		VARCHAR(1),
		@sourceMachineIp          	VARCHAR(256),
		@v_migrateAllProcesses		VARCHAR(1),
		@v_startDate           		VARCHAR(256),
		@v_endDate			 		VARCHAR(256),
		@v_noOfRecords				INT,
		@v_moveAuditTrailData 		VARCHAR(1),
		@v_moveFromHistoryData 		VARCHAR(1),
		@v_moveExtData				VARCHAR(1),
		@v_DeleteFromSrc			VARCHAR(1),    /* Required for MoveDocDb whether Data has to be deleted from source or not */
		@v_moveTaskData        		VARCHAR(1),
		@v_deleteExtTabData			VARCHAR(1),
		@MoveComplexData		     CHAR(1),
		@DBProcessDefId            INT/* Flag required in MoveDocDb for whether the new user index to be created on target cab, default - N*/
		--@v_moveExternalTableData 	VARCHAR(1),
		--@v_moveComplexTableData		VARCHAR(1),
		
		)

	AS

	BEGIN
		
		SET NOCOUNT ON
		IF(@v_isDBLink = 'Y')
		BEGIN
			SET XACT_ABORT ON
		END
		DECLARE @createdDateTime				DATETIME
		Declare @tableVariableMap 				AS Process_Variant_Type
		Declare @dblinkString 					NVARCHAR(256)
		Declare @Id 							Int
		Declare @PVId 							Int
		Declare @v_filterProcessInstanceState  	NVARCHAR(256)
		Declare @days 							Int
		Declare @v_query						NVARCHAR(2000)
		Declare @paramDefinition				NVARCHAR(256)
		DECLARE @executionLogId					INT
		Declare @tableVarRemarks				VARCHAR(4000)
		Declare @v_remarks 						VARCHAR(Max)
		Declare @countData						INT
		Declare @tableName						NVARCHAR(100)
		
		--This new flag @V_DELETEEXTTABDATA governs the deletion of data from external/extnerla-history tables.
		--If this flag is Y, then the data will be deleted from the external/extnerla-history tables.
		--If N, it won't delete the data.
		--By default, or if not passed in params, its value will be Y.
		IF (@v_deleteExtTabData = NULL OR @v_deleteExtTabData = '' OR @v_deleteExtTabData = ' ')
			BEGIN
				select @v_deleteExtTabData = 'Y'
			END

		--This flag @v_genNewFolderIndxOnTarget governs whether the new user index will be created in the target cabinet(for value Y) or the same user index will be used (for value N) to insert into PDBUser (see 6th parameter of MoveDocDb DB Procedure for more details). By default, its value will be N.
		
		SELECT @days = DATEDIFF( dd,@v_endDate,GETDATE())
		/*IF ( @days <= 15 )
		BEGIN
			Print 'Please Check : End Date cannot be greter than current date - 15 days'
			Return
		END*/
		
		select @days = DATEDIFF (dd,@v_startDate,@v_endDate)
		if(@days <= 0 )
		BEGIN
			Print 'Please Check : End date cannot be less than or equal to Start date .'
			Return 
		END
		
		IF(@v_isDBLink = 'Y' )
		BEGIN
			SELECT @dblinkString = '[' + @sourceMachineIp + '].'+ @v_sourcecabinet +'.dbo' 
		END
		ELSE
		BEGIN
			SELECT @dblinkString = @v_sourcecabinet + '.'
		END
		
		Select @tableVarRemarks = ''
		--Populate our SourceIDMap variable (dummy select statement for now).
		insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (@DBProcessDefId,0)
		--insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (3,2)


		--Print out contents of collection
		Declare NewCursor  CURSOR FAST_FORWARD FOR Select ProcessDefId,ProcessVariantID From @tableVariableMap
		Open NewCursor
		FETCH NEXT FROM NewCursor INTO @Id , @PVId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'ProcessDefId'
			PRINT  @Id
			PRINT 'ProcessVariantID'
			FETCH NEXT FROM NewCursor INTO  @Id , @PVId
			PRINT  @PVId
		END
		Close NewCursor
		
		IF(@v_startDate IS NULL)
		BEGIN
			IF(@v_moveFromHistoryData = 'Y')
			BEGIN
				SELECT @tableName = ' QUEUEHISTORYTABLE '
			END
			ELSE
			BEGIN
				SELECT @tableName = ' WFINSTRUMENTTABLE '
			END
			
			Select @v_query = ' Select @countDataOut = Count(*) from ' +@dblinkString +'.'+@tableName
			set @paramDefinition = N'@countDataOut INT OUTPUT '
			exec sp_executesql @v_query,@paramDefinition,@countDataOut = @countData OUTPUT
			
			IF(@countData = 0)
			BEGIN
				Print 'Please Check : There is no data in ' + @tableName +' to migrate .'
				RETURN
			END
			
			SELECT @v_query = 'select @createdDateTimeOut = min(createddatetime) from '+@dblinkString +
							 '.'+@tableName
			set @paramDefinition = N'@createdDateTimeOut datetime OUTPUT '
			exec sp_executesql @v_query,@paramDefinition,@createdDateTimeOut = @createdDateTime OUTPUT
			SELECT @v_startDate =  LEFT(CONVERT(VARCHAR, @createdDateTime, 120), 10)
		END
		
		IF(@v_endDate IS NULL)
		BEGIN
			SELECT @createdDateTime =   DateAdd(yy, -1, GetDate())
			SELECT @v_endDate =  LEFT(CONVERT(VARCHAR, @createdDateTime, 120), 10)
		END
		
		
		INSERT INTO getnerateLogId DEFAULT VALUES
		SELECT @executionLogId =  max(id) from  getnerateLogId
		SELECT @v_remarks =  'Transactional Execution Begins with following parameters --> v_sourceCabinet : ' + @v_sourceCabinet + ' , v_targetCabinet : ' + @v_targetCabinet + ' , v_isDBLink : ' + @v_isDBLink  + ' , sourceMachineIp : '+ @sourceMachineIp + ' , v_migrateAllProcesses : ' + @v_migrateAllProcesses + ' , v_startDate : ' + @v_startDate + '  , v_endDate : ' + @v_endDate + ' ,  batchSize : ' + Convert(Nvarchar(10),@v_noOfRecords) + ' , v_moveAuditTrailData : ' + @v_moveAuditTrailData + ' , v_moveFromHistoryData : ' + @v_moveFromHistoryData + ' , v_moveExtData : ' + @v_moveExtData + ' , v_DeleteFromSrc : ' + @v_DeleteFromSrc + ' , tableVariable : ' + @tableVarRemarks + ' ,  dblinkString : ' + @dblinkString
		
		Insert into WFMigrationLogTable values (@executionLogId,getdate(),@v_remarks)
		
		IF(@v_moveFromHistoryData = 'Y')
		BEGIN
			EXEC WFMoveQueueHistoryData @v_sourceCabinet,@v_targetCabinet,@dblinkString,@tableVariableMap,@v_migrateAllProcesses,@v_startDate,@v_endDate,@v_noOfRecords,@v_moveAuditTrailData,@v_moveExtData,@v_DeleteFromSrc,@v_moveTaskData,@executionLogId,@v_deleteExtTabData, 'Y', @MoveComplexData
		END
		ELSE
		BEGIN
			--------migrate processinstanceid with state = 6 ---------
			SELECT @v_filterProcessInstanceState = ' PROCESSINSTANCESTATE = 6 '
			EXEC WFMoveTransData @v_sourceCabinet,@v_targetCabinet,@dblinkString,@tableVariableMap ,@v_migrateAllProcesses,@v_startDate,@v_endDate,@v_noOfRecords,@v_moveAuditTrailData,@v_moveFromHistoryData,@v_moveExtData,@v_filterProcessInstanceState,@v_DeleteFromSrc,@executionLogId,@v_moveTaskData,@v_deleteExtTabData, 'Y', @MoveComplexData
			
			--------migrate processinstanceid with state = 4,5 ---------
			SELECT @v_filterProcessInstanceState = ' PROCESSINSTANCESTATE IN (4,5) '
			EXEC WFMoveTransData @v_sourceCabinet,@v_targetCabinet,@dblinkString,@tableVariableMap ,@v_migrateAllProcesses,@v_startDate,@v_endDate,@v_noOfRecords,@v_moveAuditTrailData,@v_moveFromHistoryData,@v_moveExtData,@v_filterProcessInstanceState,@v_DeleteFromSrc,@executionLogId,@v_moveTaskData,@v_deleteExtTabData, 'Y', @MoveComplexData
		END

	END