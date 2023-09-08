/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: OmnniFlow 8.0
	Module						: Omniflow Server
	File Name					: WFGenerateRegistration.sql
	Author						: Preeti Awasthi.
	Date written (DD/MM/YYYY)	: 22/1/2010
	Description					: Stored procedure to generate Registration Number while invoked from WFUploadWorkitem API.
______________________________________________________________________________________________________
				CHANGE HISTORY
				
Date                        Change By        Change Description (Bug No. (If Any))

24/01/2011					Saurabh Sinha	 WFS_8.0_090[Replicated]	Removing Hyphen from processinstanceid when suffix is not supplied at  	the time of process registration.
12/02/2013					Shweta Singhal	Variable type changed from VARCHAR(20) to NVARCHAR(25)
Case getting generated when user defined regPrefix of length 20 
17/05/2013					Shweta Singhal	Process Variant Support Changes
01/03/2014					Changes for Code Optimization - Registration number generation changes. Will be fetched from
							new table(IDE_RegistrationNumber_+ processdefid) for every process .
03-07-2014					Sajid Khan		Bug 46391 - Arabic: Process Name, Queue Name & Created User name is not showing proper in Workitem Properties.
22/08/2014					Mohnish Chopra	Bug 47515 - Create workitem operation is slow with high concurrency (5 seconds with 100 concurrent users)
27/02/2017					RishiRam Meel   PRDP Bug  Merging 67207 - Unable to create workitem on different versions of a process.
16/10/2017                  Kumar Kimil     Case Registration requirement--Upload Workitem changes
05/01/2018					Shubhankur Manuja	Arabic support
22/04/2018  				Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
01/10/2018  				Ambuj Tripathi		Changes related to sharepoint support
03/09/2020                  Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain '-'
01/12/2021					chitranshi nitharia	Changes done for upload error handling
______________________________________________________________________________________________________*/
If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFGenerateRegistration')
Begin
	Execute('DROP PROCEDURE WFGenerateRegistration')
	Print 'Procedure WFGenerateRegistration already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFGenerateRegistration (
@DBUserId					INT,
@DBProcessDefId				INTEGER,
@ValidataionReqd			VARCHAR(1000)	= NULL,
@DBInitiateFromActivityId	INTEGER,
@DBInitiateFromActivityName	NVARCHAR(60),
@DataDefinitionName			CHAR(64)		= NULL,
@DBProcessVariantId			INTEGER,
@PSFlag						CHAR(1)			= 'N',
@HyphenRequired				CHAR(4)         = 'N'
)
AS
	SET NOCOUNT ON
	DECLARE @UserName				VARCHAR(64)
	DECLARE @pos1					INT
	DECLARE @TempTableName			VARCHAR(255)
	DECLARE @TempColumnName			VARCHAR(255)
	DECLARE @TempColumnType			VARCHAR(10)	
	DECLARE @TempValue				VARCHAR(500)
	DECLARE @ActivityId				SMALLINT
	DECLARE @ActivityName			NVARCHAR(30)
	Declare @DBStatus       		INT
	DECLARE @MainGroupId			SMALLINT
	DECLARE @ValidateQuery			VARCHAR(1000)
	DECLARE @DBParentFolderId		VARCHAR(255)
	DECLARE @DBDataDefinitionIndex  INT
	DECLARE @DDTTableName			VARCHAR(255)
	DECLARE @QueueName				NVARCHAR(255)
	DECLARE @QueueId				INT
	DECLARE @StreamId				INT
	DECLARE @RegPrefix				NVARCHAR(25)
	DECLARE @RegSuffix				NVARCHAR(25)
	DECLARE @RegStartingNo			INT
	DECLARE @RegSeqLength			INT
	DECLARE @Temp					SMALLINT
	DECLARE	@ProcessName			NVARCHAR(128)
	DECLARE	@ProcessVersion 		SMALLINT
	DECLARE @Length					INT
	DECLARE @ProcessInstanceId		NVARCHAR(255)
	DECLARE @DBFolderName           VARCHAR(255)
	DECLARE @ProcessType			VARCHAR(1)
	DECLARE @ProcessSequenceTable	NVARCHAR(510)
	DECLARE @sequenceQuery			NVARCHAR(800)
	DECLARE @Urn                    NVARCHAR(126)
	Declare @DisplayName            NVARCHAR(20)
	
	SELECT 	@UserName = UserName , 
			@MainGroupId = MainGroupId
	FROM 	PDBUser (NOLOCK)
	WHERE 	UserIndex = @DBUserId
	select @ProcessName=processname ,@DisplayName=DisplayName  from processdeftable where processdefid = @DBProcessDefId
	SELECT @ProcessName = REPLACE(@ProcessName,' ','')
	Select @ProcessSequenceTable = 'IDE_Reg_' + CONVERT(nvarchar,@ProcessName)
	Select @ProcessSequenceTable = REPLACE(@ProcessSequenceTable,'-','_')
	IF @ValidataionReqd IS NOT NULL
	BEGIN
		SELECT @pos1 		= CHARINDEX(CHAR(21), @ValidataionReqd)
		SELECT @TempTableName 	= SUBSTRING(@ValidataionReqd, 1, @pos1-1)
		SELECT @ValidataionReqd = STUFF(@ValidataionReqd, 1, @pos1, NULL)
		SELECT @pos1 		= CHARINDEX(CHAR(21), @ValidataionReqd)
		SELECT @TempColumnName 	= SUBSTRING(@ValidataionReqd, 1, @pos1-1)
		SELECT @ValidataionReqd = STUFF(@ValidataionReqd, 1, @pos1, NULL)
		SELECT @pos1 		= CHARINDEX(CHAR(25), @ValidataionReqd)
		SELECT @TempValue 	= RTRIM(SUBSTRING(@ValidataionReqd, 1, @pos1-1))

		SELECT 	@TempColumnType = DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)
		WHERE  	TABLE_NAME 	= @TempTableName
		AND 	COLUMN_NAME 	= @TempColumnName

		IF @TempColumnType IN ('varchar', 'char', 'datetime')
			SELECT @TempValue = CHAR(39) + @TempValue + CHAR(39)

		EXECUTE (' DECLARE valcur CURSOR FAST_FORWARD FOR ' +
			' SELECT 1 FROM ' + @TempTableName +
			' (NOLOCK) WHERE ' + @TempColumnName + ' = ' + @TempValue)
		SELECT @DBStatus = @@ERROR
		IF (@DBStatus <> 0)
		BEGIN
			SELECT 	Status = 15
			RETURN
		END
		OPEN valcur
		SELECT @DBStatus = @@ERROR
		IF (@DBStatus <> 0)
		BEGIN
			CLOSE valcur
			DEALLOCATE valcur
			SELECT 	Status = 15
			RETURN
		END
		FETCH NEXT FROM valcur INTO @Temp
		IF @@FETCH_STATUS = 0
		BEGIN
			SELECT @DBStatus =  50
			SELECT Status = @DBStatus
			CLOSE valcur
			DEALLOCATE valcur
			RETURN
		END
		CLOSE valcur
		DEALLOCATE valcur
		SELECT @ValidateQuery = 'INSERT INTO ' + @TempTableName + ' ( ' + @TempColumnName + ' ) VALUES ( ' + @TempValue + ' ) '
	END
	
	If (@DBInitiateFromActivityId > 0)
	Begin
		SELECT	@ActivityId = ActivityId,
			@ActivityName  = ActivityName
		FROM	ActivityTable (NOLOCK)
		WHERE	ProcessDefID = @DBProcessDefId
		AND	ActivityType = 1
		AND	ActivityId = @DBInitiateFromActivityId
		If(@@ERROR > 0 OR @@ROWCOUNT <= 0)
		Begin
			SELECT @DBStatus =  603
			SELECT Status = @DBStatus
			Return
		End
	End
	Else
	Begin
		If(@DBInitiateFromActivityName IS NOT NULL AND LEN(RTRIM(@DBInitiateFromActivityName)) > 0 )
		Begin
			SELECT	@ActivityId = ActivityId,
				@ActivityName  = ActivityName
			FROM	ActivityTable (NOLOCK)
			WHERE	ProcessDefID = @DBProcessDefId
			AND	ActivityType = 1
			AND	ActivityName = RTRIM(@DBInitiateFromActivityName)
			If(@@ERROR > 0 OR @@ROWCOUNT <= 0)
			Begin
				SELECT @DBStatus =  603
				SELECT Status = @DBStatus
				Return
			End
		End
		Else
		Begin
			SELECT	@ActivityId = ActivityId,
				@ActivityName  = ActivityName
			FROM	ActivityTable (NOLOCK)
			WHERE	ProcessDefID = @DBProcessDefId
			AND	ActivityType = 1
			AND	PrimaryActivity = 'Y'		/* Default Introduction workstep */
		End
	End
	
	IF @DataDefinitionName IS NOT NULL /* AND @DataClassFlag = 'Y' */
	BEGIN
		SELECT 	@DBDataDefinitionIndex = DataDefIndex
		FROM 	PDBDataDefinition (NOLOCK)
		WHERE 	DataDefName = @DataDefinitionName
		AND 	GroupId = @MainGroupId
		IF @@ROWCOUNT <= 0
		BEGIN
    		   	EXECUTE PRTRaiseError  'PRT_ERR_DDI_Not_Exist', @DBStatus OUT
			SELECT 	Status = @DBStatus
			RETURN
		END
		SELECT @DDTTableName = 'DDT_' + CONVERT(varchar(10), @DBDataDefinitionIndex)
	END
	ELSE
		SELECT @DBDataDefinitionIndex  = 0
		
	SELECT @DBParentFolderId = WorkFlowFolderId
	FROM   RouteFolderDefTable (NOLOCK)
	WHERE  ProcessDefId = @DBProcessDefId
	IF @@ROWCOUNT <= 0
	BEGIN
	    EXECUTE PRTRaiseError  'PRT_ERR_Invalid_Parameter', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END
	
	IF @PSFlag <> 'P'
	BEGIN
		SELECT 	TOP 1 @QueueName	= QUEUEDEFTABLE.QUEUENAME,
			@QueueId	= QUEUEDEFTABLE.QUEUEID,
			@StreamId	= QUEUESTREAMTABLE.STREAMID
		FROM 	QUEUESTREAMTABLE (NOLOCK), QUserGroupView (NOLOCK), ACTIVITYTABLE (NOLOCK), QUEUEDEFTABLE (NOLOCK)
		WHERE 	ACTIVITYTABLE.PROCESSDEFID 	= @DBProcessDefId
		AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1
		AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID
		AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID
		AND 	ACTIVITYTABLE.ACTIVITYID	= @ActivityId
		AND 	QUEUESTREAMTABLE.QUEUEID 	= QUserGroupView.QUEUEID
		AND 	QUEUEDEFTABLE.QUEUEID 		= QUserGroupView.QUEUEID
		AND 	QUEUETYPE 			= 'I'
		AND 	USERID 				= @DBUserId
	END
	ELSE
	BEGIN
		SELECT 	TOP 1 @QueueName	= QUEUEDEFTABLE.QUEUENAME,
		@QueueId	= QUEUEDEFTABLE.QUEUEID,
		@StreamId	= QUEUESTREAMTABLE.STREAMID
		FROM 	QUEUESTREAMTABLE, ACTIVITYTABLE , QUEUEDEFTABLE 
		WHERE 	QUEUESTREAMTABLE.PROCESSDEFID 	= @DBProcessDefId 
		AND 	QUEUESTREAMTABLE.ACTIVITYID	=  @ActivityId
		AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1			
		AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID 
		AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID 
		AND 	QUEUETYPE 					= 'I'
		AND 	QUEUEDEFTABLE.QUEUEID 		= QUEUESTREAMTABLE.QUEUEID 			
	END
	
	IF @@ROWCOUNT <= 0
	BEGIN
		SELECT @DBStatus = 300	/*WFS_7.1_033*/
		SELECT 	Status   = @DBStatus
		RETURN
	END
	/*Process Variant Support Changes*/
	SELECT @ProcessType = ProcessType
	FROM ProcessDefTable (NOLOCK)	
	WHERE ProcessDefId = @DBProcessDefId
		
	IF @@ROWCOUNT <= 0
	BEGIN
		SELECT @DBStatus = 2	/*WFS_7.1_033*/
		SELECT 	Status   = @DBStatus
		RETURN
	END
	
	--BEGIN TRANSACTION TranWorkItem
	IF @ProcessType = 'S'/*Process Variant Support Changes*/
		BEGIN TRY
			Select @sequenceQuery= 'INSERT '+ @ProcessSequenceTable + ' DEFAULT VALUES '
			--print 'sequenceQuery' + @sequenceQuery
			Execute(@sequenceQuery)
			Select @RegStartingNo = @@identity
			/*UPDATE 	ProcessDefTable
			SET 	RegStartingNo 	= @RegStartingNo
			WHERE 	ProcessDefID 	= @DBProcessDefId */

			SELECT	@RegPrefix	= RegPrefix,
				@RegSuffix	= RegSuffix,
				@RegSeqLength	= RegSeqLength,
				@ProcessName	= ProcessName,
				@ProcessVersion = VersionNo
			FROM	ProcessDefTable (NOLOCK)
			WHERE	ProcessDefID	= @DBProcessDefId
		END TRY
		BEGIN CATCH
			SELECT Status = 4014,
			DBTblNm = @ProcessSequenceTable
		END CATCH
	ELSE
		BEGIN
			SELECT	@RegPrefix	=WFProcessVariantDefTable.RegPrefix,
				@RegSuffix	= WFProcessVariantDefTable.RegSuffix,
				@RegStartingNo	= WFProcessVariantDefTable.RegStartingNo,
				@RegSeqLength	= RegSeqLength,
				@ProcessName	= ProcessName,
				@ProcessVersion = VersionNo
			FROM	WFProcessVariantDefTable (NOLOCK), ProcessDefTable (NOLOCK) 
			WHERE	WFProcessVariantDefTable.ProcessDefId = ProcessDefTable.ProcessDefId
			AND		ProcessDefTable.ProcessDefID	= @DBProcessDefId
			AND		ProcessVariantId = @DBProcessVariantId
			
			UPDATE 	WFProcessVariantDefTable
			SET 	RegStartingNo 	= RegStartingNo + 1
			WHERE 	ProcessDefID 	= @DBProcessDefId
			AND 	ProcessVariantId = @DBProcessVariantId
		END
	--COMMIT TRANSACTION TranWorkItem
	
	SELECT @RegStartingNo	= @RegStartingNo
	
	IF(@RegPrefix IS NOT NULL AND @RegPrefix<>'')	/*WFS_8.0_090*/
	BEGIN
		SELECT @RegPrefix	= @RegPrefix + '-'
	END	
	
	IF(@RegSuffix IS NOT NULL AND @RegSuffix<>'')	/*WFS_8.0_090*/
	BEGIN
		SELECT @RegSuffix	= '-' + @RegSuffix
	END
	ELSE
	BEGIN
		IF(@HyphenRequired  = 'Y')
		BEGIN
			SELECT @RegSuffix	= '-'
	END
		ELSE
		BEGIN
			SELECT @RegSuffix	= ''
		END
	END
	
	IF(@RegPrefix IS NULL)	
	BEGIN
		SELECT @RegPrefix	= ''		
	END


	IF LEN(@RegStartingNo) > @RegSeqLength - LEN(@RegPrefix) - LEN(@RegSuffix)
	BEGIN
		SELECT @DBStatus = 19
		SELECT 	Status   = @DBStatus
		RETURN
	END

	SELECT	@Length			= @RegSeqLength - LEN(@RegPrefix) - LEN(@RegSuffix)
	SELECT	@ProcessInstanceId	= REPLICATE('0', @Length)
	SELECT 	@ProcessInstanceId	= @RegPrefix + SUBSTRING(@ProcessInstanceId,1, LEN(@ProcessInstanceId) - LEN(@RegStartingNo)) + 	CONVERT(varchar(10), @RegStartingNo) + @RegSuffix
	SELECT 	@DBFolderName		= @ProcessInstanceId
	
	if(@DisplayName IS NOT NULL AND @DisplayName<>'')
	Begin
	Select @Urn=@DisplayName +'-'+ CONVERT(varchar(10), @RegStartingNo)
	end
	
	SELECT Status  = @DBStatus,	
	ProcessInstanceid = @ProcessInstanceId,
	ParentFolderIndex = @DBParentFolderId,
	DataDefinitionIndex = @DBDataDefinitionIndex,	
	ActivityId = @ActivityId,		
	MainGroupId = @MainGroupId,		
	ActivityName = @ActivityName,		
	QueueId = @QueueId,
	QueueName = @QueueName,
	VaidateQuery = @ValidateQuery,
	StreamId = @StreamId,
	URN = @urn
	
	