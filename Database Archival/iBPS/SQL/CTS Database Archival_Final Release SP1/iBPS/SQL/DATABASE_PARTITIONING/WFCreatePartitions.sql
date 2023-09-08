	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFCreatePartitions.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 30 MAY 2014
	Description                 : Stored Procedures To Partition Tables on the 
								  basis of ProcessInstanceId
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/	
				
			
	If Exists (Select * FROM SysObjects  WITH (NOLOCK) Where xType = 'P' and name = 'WFCreatePartitions')
	Begin
		Execute('DROP PROCEDURE WFCreatePartitions')
		Print 'Procedure WFCreatePartitions already exists, hence older one dropped ..... '
	End
	
	~
	
	Create Procedure WFCreatePartitions(
		@processDefId 		Int,
		@processVariantId	Int
	)
	AS
	BEGIN
		DECLARE @vquery 				NVARCHAR(2000)
		DECLARE @v_PartiitonStatus 		INT
		DECLARE @vqueryParam 			NVARCHAR(2000)
		DECLARE @vtableName				VARCHAR(200)
		DECLARE @vpartitionColumn		VARCHAR(100)
		DECLARE @loopCount 				INT
		DECLARE @RegPrefix 				nvarchar(50)
		DECLARE @RegSuffix 				nvarchar(50)
		DECLARE @ProcessInstanceId 		nvarchar(63)
		DECLARE @Length					INT
		DECLARE @RegStartingNo			INT
		DECLARE @RegSeqLength			INT
		DECLARE @tableRecreate			INT
		
		Select @tableRecreate = 0
		Select  @vquery = 'Select @value = Count(*) from WFCabVersionTable where Upper (CabVersion) = ''PARTITIONINGSUPPORT'''
		Set @vqueryParam = '@value INT OUTPUT'
		Exec sp_executesql @vquery , @vqueryParam , @value = @tableRecreate OUTPUT
		IF(@tableRecreate = 0)
		BEGIN
			EXEC WFPartitionLargeTables
		END
		IF(@@Error <> 0)
		BEGIN
			Print 'Error in querying WFCabVersionTable : query is ' + @vquery
			Return
		END
		
		Select 	@v_PartiitonStatus = 0
		Select  @vquery = 'Select @value = Count(*) from WFPartitionStatusTable where ProcessDefId = ' + Convert(NVARCHAR(10),@processDefId) + ' and ProcessVariantId = ' +  Convert(NVARCHAR(10),@processVariantId)
		Set @vqueryParam = '@value INT OUTPUT'
		Exec sp_executesql @vquery , @vqueryParam , @value = @v_PartiitonStatus OUTPUT
		IF(@@Error <> 0)
		BEGIN
			Print 'Error in querying WFPartitionStatusTable : query is ' + @vquery
			Return
		END
		
		IF(@v_PartiitonStatus > 0 )
		BEGIN
			Print 'Partition already created for ProcessDefId ' + Convert(NVARCHAR(10),@processDefId)  + ' and ProcessVariantId = ' + Convert(NVARCHAR(10),@processVariantId)
			Return
		END
		ELSE
		BEGIN
			IF(@processVariantId = 0)
			BEGIN
				Select @vquery = 'Select  @regPrefixOut = Regprefix ,@regSuffixOut = RegSuffix ,@regSeqOut = RegSeqLength from ProcessDefTable where processdefid = '+ Convert(nvarchar(10),@processDefId)
				Select @vqueryParam = N'@regPrefixOut nvarchar(50) OUTPUT ,@regSuffixOut nvarchar(50) OUTPUT ,@regSeqOut nvarchar(50) OUTPUT '
				exec sp_executesql @vquery,@vqueryParam,@regPrefixOut = @RegPrefix OUTPUT,@regSuffixOut = @RegSuffix OUTPUT,@regSeqOut = @RegSeqLength OUTPUT
			END
			ELSE
			BEGIN
				Select @vquery = 'Select  @regPrefixOut = Regprefix ,@regSuffixOut = RegSuffix from WFProcessVariantDefTable where ProcessDefId = ' + Convert(NVARCHAR(10),@processDefId) + ' and ProcessVariantId = ' +  Convert(NVARCHAR(10),@processVariantId)
				Select @vqueryParam = N'@regPrefixOut nvarchar(50) OUTPUT ,@regSuffixOut nvarchar(50) OUTPUT  '
				Print 'query'
				print @vquery
				exec sp_executesql @vquery,@vqueryParam,@regPrefixOut = @RegPrefix OUTPUT,@regSuffixOut = @RegSuffix OUTPUT
				
				Select @vquery = 'Select @regSeqOut = RegSeqLength from  ProcessDefTable  where ProcessDefId = ' + Convert(NVARCHAR(10),@processDefId) 
				Select @vqueryParam = N'@regSeqOut nvarchar(50) OUTPUT'
				exec sp_executesql @vquery,@vqueryParam,@regSeqOut = @RegSeqLength OUTPUT
				
			END
			
			SELECT @RegPrefix	= @RegPrefix + '-'
			IF(@RegSuffix IS NOT NULL AND @RegSuffix<>'')	
			BEGIN
				SELECT @RegSuffix	= '-' + @RegSuffix
			END
			
			Select @RegStartingNo = 0000001
			Select @loopCount = 1
			While (@loopCount < = 10)
			Begin
				SELECT	@Length			= @RegSeqLength - LEN(@RegPrefix) - LEN(@RegSuffix)
				SELECT	@ProcessInstanceId	= REPLICATE('0', @Length)
				SELECT 	@ProcessInstanceId	= @RegPrefix + SUBSTRING(@ProcessInstanceId,1,LEN(@ProcessInstanceId) - LEN(@RegStartingNo)) + 	CONVERT(varchar(10), @RegStartingNo) + @RegSuffix
				Print 'Pid--'
				Print  @ProcessInstanceId
				ALTER PARTITION SCHEME PartitionSchemePId NEXT USED [PRIMARY]
				ALTER PARTITION FUNCTION PartitionRangePId()SPLIT RANGE (@ProcessInstanceId)
				select @loopCount = @loopCount + 1
				Select @RegStartingNo = @RegStartingNo + 1000000
			End
			
		END
		
		Select @vquery = 'Insert Into WFPartitionStatusTable values ( ' +  Convert(NVARCHAR(10),@processDefId)  + ',' + Convert(NVARCHAR(10),@processVariantId) + ')'
		Execute (@vquery)
		IF(@@Error <> 0)
		BEGIN
			Print 'Error in inserting into WFPartitionStatusTable : query is ' + @vquery
			Return
		END
		
	END
	