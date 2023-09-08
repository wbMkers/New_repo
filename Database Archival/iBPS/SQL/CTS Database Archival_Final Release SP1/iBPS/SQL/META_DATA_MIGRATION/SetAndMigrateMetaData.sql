	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : SetAndMigrateMetaData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure to set values to start MetaDataMigration Execution
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'SetAndMigrateMetaData')
	Begin
		Execute('DROP PROCEDURE SetAndMigrateMetaData')
		Print 'Procedure SetAndMigrateMetaData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure SetAndMigrateMetaData
	(
		@v_sourceCabinet      		VARCHAR(256),
		@v_targetCabinet      		VARCHAR(256),
		@v_isDBLink			  		VARCHAR(1),
		@sourceMachineIp      		VARCHAR(256),
		@v_migrateAllData 	  		VARCHAR(1),	
		@v_copyForceFully	  		VARCHAR(1),
		@v_overRideCabinetData		VARCHAR(1),
		@v_DeleteFromSrc			VARCHAR(1),    /* Required for MoveDocDb whether Data has to be deleted from source or not */
		@v_moveTaskData        		VARCHAR(2)
	)

	AS
		
	BEGIN
	
		SET NOCOUNT ON
		
		Declare @tableVariableMap 		AS Process_Variant_Type
		Declare @dblinkString 			NVARCHAR(256)
		Declare @Id 					INT
		Declare @PVId 					INT
		Declare @v_executionLogId 		INT
		Declare @v_remarks 				VARCHAR(Max)
		Declare @tableVarRemarks		VARCHAR(4000)
		DECLARE @DBStatus	 			INT
		
		Select @tableVarRemarks = ''
		IF(@v_isDBLink = 'Y' )
		BEGIN
			SELECT @dblinkString = '[' + @sourceMachineIp + '].'+ @v_sourcecabinet +'.dbo' 
		END
		ELSE
		BEGIN
			SELECT @dblinkString = @v_sourcecabinet + '.'
		END
		
			
		------------------------------Call SynchCabinets---------------------------------------------------------
		--EXEC SynchCabinets @v_sourceCabinet,@v_targetCabinet,@dblinkString,@DBStatus OUT
		--IF (@DBStatus <> 0)
		--Begin
			-- Print 'Error in caliing Synch Cabinets'
			 --Return
		--End
		
		--Populate our SourceIDMap variable (dummy select statement for now).
		Insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (3,0)

		--Print out contents of collection
		Declare NewCursor  CURSOR FAST_FORWARD FOR Select ProcessDefId,ProcessVariantID From @tableVariableMap
		Open NewCursor
		FETCH NEXT FROM NewCursor INTO @Id , @PVId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'ProcessDefId'
			PRINT  @Id
			PRINT 'ProcessVariantID'
			PRINT  @PVId
			SELECT @tableVarRemarks = @tableVarRemarks +  'PId--'+ CONVERT(NVARCHAR(10),@Id) + 'PVId--' + CONVERT(NVARCHAR(10),@PVId)
			FETCH NEXT FROM NewCursor INTO  @Id , @PVId

		END
		Close NewCursor
		
		Insert into getnerateLogId DEFAULT VALUES
		SELECT @v_executionLogId =  max(id) from  getnerateLogId
		SELECT @v_remarks = 'MetaData Execution Begins with following parameters --> v_sourceCabinet : ' + @v_sourceCabinet + ' , v_targetCabinet : ' + @v_targetCabinet + ' , v_isDBLink : ' + @v_isDBLink  + ' , sourceMachineIp : '+ @sourceMachineIp + ' , v_migrateAllData : ' + @v_migrateAllData + ' , v_copyForceFully : ' + @v_copyForceFully + '  , v_overRideCabinetData : ' + @v_overRideCabinetData + ' ,  tableVariable : ' + @tableVarRemarks + ' ,  dblinkString : ' + @dblinkString
		Insert into WFMigrationLogTable values (@v_executionLogId,getdate(),@v_remarks)
		
		EXEC WFMigrateMetaData @v_sourceCabinet , @v_targetCabinet , @dblinkString , @tableVariableMap , @v_migrateAllData ,@v_copyForceFully , @v_overRideCabinetData,@v_DeleteFromSrc,@v_executionLogId,@v_moveTaskData
		

	END
	