/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Application � Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFUploadWorkitem.sql
	Author				: Dinesh Parikh.
	Date written (DD/MM/YYYY)	:
	Description			: Stored procedure to upload workitems
					  (invoked from WMMiscelleneous.java).

______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 28/02/2005	Ruhi Hira		SrNo-1.
 12/05/2005	Rahul Mehta		SrNo-2.
 5/08/2005	Mandeep Kaur		SRNo-3 (Bug Ref No WFS_5_056)
 5/08/2005	Mandeep Kaur		SRNo-4 (Bug Ref No WFS_5_055)
 22/02/2006	Ruhi Hira		Bug No WFS_6.1.2_059.
 10/05/2006	Ahsan Javed		BUG # WFS_5_091.
 23/10/2006	Virochan Dev		Bugzilla Bug 265 - FolderIndex returned
 23/10/2006	Virochan Dev		Bugzilla Bug 270 - For multiple introduction worksteps
 02/02/2007	Varun Bhansaly		Extra Parameter added for Calendar Support and insert statement modified
 08/02/2007	Varun Bhansaly		Bugzilla Id 74 (Inconsistency in date-time)
 05/04/2007	Tirupati Srivastava	Bugzilla Id 529 (UploadWorkItem)
 11/04/2007	Varun Bhansaly		Bugzilla Id 532
					(In case of Stored Procedure for WFUploadWorkItem written in MSSQL, 
						JAVA style syntax is being used to check for a NULL)
 03/05/2007	Tirupati Srivastava	Bugzilla Id 676 (UploadWorkItem) (In case a user is added to introduction queue as well as group is 									asdded to Introduction Queue of which user is alsoa amember, err 																		comes in Oracle)
 24/05/2007	Ruhi Hira		Bugzilla Bug 945.
 25/07/2007	Varun Bhansaly		Bugzilla Id 1544 ([Jboss 3.2.7] [MSSQL 2005] [omniflow 7.0 Japanese] wfuploadworkitem gives error)
 25/07/2007	Tirupati Srivastava		Bugzilla Id 1447 (Introduce WorkItem from Webdesktop using Single Call WFUploadWorkItem)
 25/02/2008	Varun Bhansaly	WFS_5_169 Handling of errors while inserting in tables. - Code Inherited from 5.0
 25/02/2008	Varun Bhansaly	Bugzilla Bug Id 3129 (Support for multiple document types)
 05/03/2008	Varun Bhansaly	Coded backward compatibility for Bugzilla Id 3129
 11/04/2008	Ashish Mangla		Bugzilla Bug 4078 GenerateName making call slow, to be used only when required
 22/05/2008	Varun Bhansaly		WFS_6.2_005, (Error in WFUploadWorkitem when attribute value contains single quote as data)
 22/05/2008	Varun Bhansaly		WFS_5_236, Support for text attribute values upto length 8000 provided
 28/08/2008	Varun Bhansaly		Optimization in WFUploadWorkItem, query strings will be generated and passed from API.
								Oracle SP parameters donot have restriction on size. Hence unnecessary parameters removed.
 08/12/2008	Ashish Mangla		Bugzilla Bug 7193 (special char mu creating problem while being executed Post.sql execution)
 23/03/2009	Ashish Mangla		Bugzilla Bug 7891 (Error in Upload in case complex structure as well as external table defined)
 26/06/2009	Saurabh Kamal		WFS_8.0_010 , If else for InitiateAlso = 'N'
 26/06/2009	Ishu Saraf		SrNo-5 Unicode support in Document, Attributes and external table variables.
 4/7/2009	Preeti Awasthi		WFS_8.0_013 - Support for adding documents actual name(Harddisk name) in Comment column .
 03/07/2009	Indraneel dasgupta	WFS_7.1_033 ( User that do not have rights on an introduction queue got error "Process definition id invalid" on uploading workitem.Rather it should be No Authorization error)
 30/09/2009 Saurabh Kamal       Bugzilla bug 10941 (Not working in MSSQL2000 error while executing SUBSTRING function )
 30/09/2009 Saurabh Kamal       WFS_8.0_037 Message entry in WFMessageTable in case of add document
 05/06/2009 Saurabh Kamal		Bug 31357 - Queue Name not visible in workitem property
 17/05/2013	Shweta Singhal		Process Variant Support Changes
 23/12/2013	Shweta Singhal		Changes for Code Optimization
 23/12/2013	Sajid Khan			Message Agent Optimization.
 19-02-2014	Sajid Khan			Entries made into WFCurrentRouteLogTable for ActionId 1 and 2 for each execution.
 28-03-2014	Sajid Khan			Bug 43710 - While create a WI with html form, an error is generated (All types of queue vars are defined in this process.
_07.04-2014 Kanika Manik        Bug 44270 Initiation Agent utility is not working either with POP3 or IMAP Mail Protocol.
29/05/2014  Kanika Manik        PRD Bug 40306 - 1.Incorrect handling for the case when Subject,From,Date of the mail is null in Initiation Agent. 2. Size of comment field is small 
                                in WFUploadWorkitem Stored Procedure due to which string get truncated.
16-06-2014	Sajid Khan			Bug 46240 - Arabic: Default value for text type queue variable is not showing proper in Workitem 
17-06-2014	Sajid Khan			Bug 46391 - Arabic: Process Name, Queue Name & Created User name is not showing proper in Workitem Properties.
23-06-2014	Kahkeshan			Bug 46379 - Arabic: While create a new workitem, an error is generated
29-09-2014	Mohnish Chopra		Bug 50438 - WI properties showing 2 start Events
11/08/2015	Mohnish Chopra		Changes for Data Locking issue in Case Management -ActivityType added in WFInstrumentTable
01-05-2017	Sajid Khan			Merging Bug 58270 - Auditing of Attribute set is not being done through WFUPloadWorkitem API
04-05-2017	Sajid Khan			Bug 66075 - When a new workitem is created in webdesktop of name that already present in OD workflow folder then no new workitem is created
05/05/2017	Mohnish Chopra		Prdp Bug 56471 - Support in WFUploadWorkitem to provide document type also in input xml 
08/05/2017	Kumar Kimil 	    Bug 55927 - Support for API Wise Synchronous Routing.
07/06/2017  Kumar Kimil         Bug 70065 - Attachment name gets truncated by WFUploadworkitem SP.
17/07/2017	Mohnish Chopra 		PRDP Bug 69312 - Workitems created through initiation agent pending for PS are visible on queue click . 
24/10/2017        Kumar Kimil         Case Registration requirement--Upload Workitem changes
29/12/2017  Kumar Kimil         Bug 74441 - PNG File handling through Initiation Agent and 0KB file Handling for ESPN
01/10/2018  				Ambuj Tripathi		Changes related to sharepoint support
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
01/02/2019	Shubham Singla    Bug 82825 - Ibps 3.0 sp1+ SQL:Document Name getting trimmed by one alphabet when document is uploded by upload workitem.
19/02/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 84343 - WFUploadWorkItem getting failed when document data is huge)
20/12/2019  Shubham Singla      Bug 87593 - iBPS 4.0:WFUploadWorkitem getting failed when AssociatedFieldId in WFCurrentRouteLogTable becomes 	greater than the size of int.
02/01/2019  SHubham Singla      Bug 89615 - Adding "Document" Tag in output of WFUploadWorkItem call as it has been a gap between OF and iBPS API.
04/02/2020	Ambuj Tripathi		Bug 88867 - Png document is not displayed in Attached document when WI is created through import service or initiation agent.
05/02/2020	Shahzad Malik		Bug 90535 - Product query optimization
22/07/2020	Ravi Ranjan Kumar	Bug 93516 - Arabic : Process name not displayed in WI properties; instead question marks are displayed
01/12/2021	chitranshi nitharia	Changes done for upload error handling
25/08/2021 Satyanarayan Sharma  Bug 100869 - iBPS4.0SP1-Arabic name doc coming as ??? in wfuploadworkitem.
______________________________________________________________________________________________*/


If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFUploadWorkItem')
Begin
	Execute('DROP PROCEDURE WFUploadWorkItem')
	Print 'Procedure WFUploadWorkItem already exists, hence older one dropped ..... '
End

~

CREATE  PROCEDURE WFUploadWorkItem(
		@DBUserId				INTEGER,
		@ProcessInstanceId		nvarchar(1000),
		@DBProcessDefId			int,
		/* ______________________________________________________________________________________
		// Changed On  : 28/02/2005
		// Changed By  : Ruhi Hira
		// Description : SrNo-1, Omniflow 6.0, Feature: Multiple Introduction, New input
		//				parameters added.
		// ____________________________________________________________________________________*/
		@ActivityId				INTEGER,
		@ActivityName			NVARCHAR(60),
		@ValidataionReqd		varchar(1000)	= null,
		@DBDataDefinitionIndex	INT,
		/*BUG # WFS_5_091.----------------------------Begin*/
		@DBDataList1	ntext		= null,
		@DBDataList2	ntext		= null,
		@DBDataList3	ntext		= null,
		@DBDataList4	ntext		= null,
		@DBDataList5	ntext		= null,
		@DBDataList6	ntext		= null,
		@DBDataList7	ntext		= null,
		@DBDataList8	ntext		= null,
		@DBDataList9	ntext		= null,
		@DBDataList10	ntext		= null,
		@DBDocList1		ntext		= null,
		@DBDocList2		ntext		= null,
		@DBDocList3		ntext		= null,
		@DBDocList4		ntext		= null,
		@DBDocList5		ntext		= null,
		@DBPriorityLevel	INT			= null,
		/*BUG # WFS_5_091.----------------------------End*/
		@DBGenerateLog		NCHAR(1)		= null,
		/* Changed By Varun Bhansaly On 02/02/2007 */
		@DBExpectedProcessDelay	DATETIME	= null,
		/* ______________________________________________________________________________________
		// Changed On  : 25/07/2007
		// Changed By  : Tirupati Srivastava
		// Description : New input parameter added.Bugzilla Id 1447
		// ____________________________________________________________________________________*/
		@DBInitiateAlso		NCHAR(1)	= NULL,
		@DBQDTColumnList	NTEXT		= NULL,
		@DBQDTValueList		NTEXT		= NULL,
		@DBEXTColumnList1	NTEXT		= NULL,
		@DBEXTColumnList2	NTEXT		= NULL,
		@DBEXTColumnList3	NTEXT		= NULL,
		@DBEXTValueList1	NTEXT		= NULL,
		@DBEXTValueList2	NTEXT		= NULL,
		@DBEXTValueList3	NTEXT		= NULL,
		@DBRouteLogList1	NTEXT		= NULL,
		@DBRouteLogList2	NTEXT		= NULL,
		@DBRouteLogList3	NTEXT		= NULL,
		@DBRouteLogList4	NTEXT		= NULL,
		@DBRouteLogList5	NTEXT		= NULL,
		@DBRouteLogList6	NTEXT		= NULL,
		@DBRouteLogList7	NTEXT		= NULL,
		@DBRouteLogList8	NTEXT		= NULL,
		@ValidateQuery		VARCHAR(1000)		= NULL,	
		@MainGroupId		INT,
		@DBParentFolderId	INT, 
		@ProcessName		NVARCHAR(64),
		@ProcessVersion		INT,
		@QueueId			INT,
		@QueueName			NVARCHAR(64),
		@StreamId			INT,
		@DBProcessVariantId	INT/*Process Variant Support Changes*/,
		@DBSetAttributeLoggingEnabled		NVARCHAR(1),
		@DBSynchronousRouting	NVARCHAR(1),
		@Urn                Nvarchar(126),
		@DBSharepointFlag	varchar(1),
		@DBFolderIdSP		varchar(255),
		@DBLocale			Nvarchar(30)
	)
	AS

	SET NOCOUNT ON


	/*DECLARE @DBParentFolderId       int*/
	DECLARE @TMPDBFolderName        varchar(255)
	DECLARE @DBFolderName           nvarchar(255)
	DECLARE @DBAccessType           char(1)
	DECLARE @DBImageVolumeIndex     int
	DECLARE @DBFolderType           char(1)
        DECLARE @DBVersionFlag          char(1)
	DECLARE @DBComment              char(255)
	DECLARE @DBOwner		int
	DECLARE @DBExpiryDateTime	char(50)
	DECLARE @NameLength		int
	DECLARE @LimitCount		int
	DECLARE @DBEnableFTS		char(1)
	DECLARE @DuplicateNameFlag	char(1)
	DECLARE	@fieldId			BIGINT
    	/* Declare Variables	*/
	/*DECLARE @DBDataDefinitionIndex  int */
	DECLARE @DBLocation             char
	Declare @DBUserRights      	char(10)
	Declare @FolderLock		char(1)
	Declare @FinalizedFlag		char(1)
	Declare @EnableVersion		char(1)
	Declare @UpdateList varchar(255)
 	Declare  @DBStatus              int
	/*Declare  @DBUserId        	int*/
  	Declare  @Rights    		char
  	Declare  @NewFolderIndex	int
  	Declare  @iCount 		int
	Declare  @DBFlag		char
	/* Changed By Varun Bhansaly On 02/02/2007 */
    /*    DECLARE @ProcessTurnAroundTime	int */
	DECLARE  @DBFieldName		char(64)
	Declare  @TempUser			int
	Declare  @AccessType		char(1)
	Declare  @ACLMore		char(1)
	Declare  @ACLstr		char(255)
	/*DECLARE  @MainGroupId		smallint*/
	DECLARE  @IsAdmin 		char(1)
	DECLARE  @ExpiryDateTime	DATETIME
	DECLARE  @ParentEnableFTS 	char(1)
	DECLARE  @ParentFolderType	CHAR(1)
	DECLARE @LockByUser		varchar(255)
	DECLARE @EffectiveLockByUser	int
	DECLARE @LockMessage		varchar(255)
	DECLARE @LockedObject		int
	Declare @FolderLevel 		int
	DECLARE @FolLock		char(1)
	DECLARE @FolLockByUser		varchar(255)
	DECLARE @Hierarchy		varchar(4000)
	DECLARE @ProcessState		varchar(10)
	DECLARE @RegPrefix		varchar(20)
	DECLARE @RegSuffix		varchar(20)
	DECLARE @RegStartingNo		int
	DECLARE @RegSeqLength		int
	DECLARE @TableViewName		nvarchar(255)
	DECLARE @DataClassFlag		char(1)
	DECLARE @Length		int
	/*DECLARE @ProcessInstanceId	varchar(255)*/

	DECLARE @ColumnList		varchar(8000)
	DECLARE @ValueList		varchar(8000)
	DECLARE @WhileCounter		int
	DECLARE @DDTTableName		varchar(255)
	/*DECLARE @QueueName		varchar(255)
	DECLARE @QueueId		int
	DECLARE @StreamId		int
	DECLARE @ActivityId		smallint
	DECLARE @ActivityName		varchar(30)*/
	DECLARE @UserName		nvarchar(64)
	DECLARE @UpdateStr		varchar(8000)
	DECLARE @UpdateFlag		char(1)
	DECLARE @UpdateDFlag		char(1)
	DECLARE @SystemDefinedName	varchar(50)
	DECLARE @VariableType		smallint
	DECLARE @DefaultValue		varchar(255)
	DECLARE @DBDDIDataList		varchar(8000)
	DECLARE @ParseCount		int
	DECLARE @pos1			int
	DECLARE @TempStr		Nvarchar(4000)	 /*SrNo-5*/
	DECLARE @TempFieldName		varchar(100)
	DECLARE @TempFieldValue		nvarchar(4000)
	DECLARE @TempFieldId		int
	DECLARE @TempDataFieldType	char(1)
	DECLARE @DBDocumentList		nvarchar(4000)	 /*SrNo-5*/
	DECLARE @DocumentName		Nvarchar(255)	 /*SrNo-5*/
	DECLARE @ISIndexStr		varchar(50)
	DECLARE @ImageIndex 		int
	DECLARE @VolumeIndex 		int
	DECLARE @CurrDate 		DATETIME
	DECLARE @NextOrder 		int
	DECLARE @NewDocumentIndex	int
	DECLARE @NoOfPage 		int
	DECLARE @DocumentSize 		int

	DECLARE @DocumentType		char(1)
	DECLARE @AppType		varchar(50)	
	DECLARE @Comment		varchar(1020)	/*WFS_8.0_013*/
    DECLARE @FieldName      varchar(2000)/*xyz*/
	DECLARE	@AttributeName		varchar(50)
	DECLARE @AttributeType		char(1)
	DECLARE @AttributeValue		varchar(500)

	/*DECLARE @TempTableName		varchar(255)
	DECLARE @TempColumnName		varchar(255)
	DECLARE @TempColumnType		varchar(10)
	DECLARE @TempValue		varchar(500)*/
	DECLARE	@DBAttributeList	varchar(8000)

	DECLARE	@UserDefinedName	nvarchar(50)
	DECLARE	@ExtObjID		smallint

	DECLARE	@Rec1 			varchar(255)
	DECLARE	@Var_Rec_1 		varchar(255)
	DECLARE	@Rec2			varchar(255)
	DECLARE	@Var_Rec_2		varchar(255)
	DECLARE	@Rec3			varchar(255)
	DECLARE	@Var_Rec_3		varchar(255)
	DECLARE	@Rec4			varchar(255)
	DECLARE	@Var_Rec_4		varchar(255)
	DECLARE	@Rec5			varchar(255)
	DECLARE	@Var_Rec_5 		varchar(255)
	DECLARE @TempVar		varchar(4000)
	DECLARE @AttributeNameStr	varchar(8000)
	DECLARE @UpdateColumnStr	varchar(8000)
	DECLARE @UpdateValueStr		varchar(8000)
	DECLARE @QueryStr		varchar(8000)
	DECLARE @Pattern		varchar(400)
	DECLARE @atempstr		varchar(8000)
	DECLARE @Posi1			int
	DECLARE @Posi2			int
	DECLARE @yesValue		varchar(8000)
	DECLARE @InsertExtColumnStr	nvarchar(1024)
	DECLARE @InsertExtValueStr	nvarchar(1024)
	DECLARE @TempExtObjID		int
	/*DECLARE @Temp			smallint */
	DECLARE @DBProcessDefIdStr 	varchar(10)
	DECLARE @ActivityIdStr 	   	varchar(10)
	DECLARE @ValidTill		datetime
	DECLARE @AttributeRouteStr	varchar(8000)
	/*DECLARE @ProcessName		varchar(64)
	DECLARE	@ProcessVersion 	smallint*/
	DECLARE @PriorityLevel		varchar(5)

	DECLARE @DBTotalDuration	int
	DECLARE @DBTotalPrTime		int

	DECLARE @UniqueNameString	varchar(8000)
	/*BUG # WFS_5_091.----------------------------Begin*/
	DECLARE @DBDDIDataList1		varchar(8000)
	DECLARE @DBDDIDataList2		varchar(8000)
	DECLARE @DBDDIDataList3		varchar(8000)
	DECLARE @DBDDIDataList4		varchar(8000)
	DECLARE @DBDDIDataList5		varchar(8000)
	DECLARE @DBDDIDataList6		varchar(8000)
	DECLARE @DBDDIDataList7		varchar(8000)
	DECLARE @DBDDIDataList8		varchar(8000)
	DECLARE @DBDDIDataList9		varchar(8000)
	DECLARE @DBDDIDataList10	varchar(8000)
	DECLARE @DBDocumentList1	nvarchar(4000)	 /*SrNo-5*/
	DECLARE @DBDocumentList2	nvarchar(4000)	 /*SrNo-5*/
	DECLARE @DBDocumentList3	nvarchar(4000)	 /*SrNo-5*/
	DECLARE @DBDocumentList4	nvarchar(4000)	 /*SrNo-5*/
	DECLARE @DBDocumentList5	nvarchar(4000)	 /*SrNo-5*/
	DECLARE @QDTColumnList		VARCHAR(8000)
	DECLARE @QDTValueList		NVARCHAR(4000)	 /*SrNo-5*/
	DECLARE @EXTColumnList1		VARCHAR(8000)
	DECLARE @EXTColumnList2		VARCHAR(8000)
	DECLARE @EXTColumnList3		VARCHAR(8000)
	DECLARE @EXTValueList1		NVARCHAR(4000)	 /*SrNo-5*/
	DECLARE @EXTValueList2		NVARCHAR(4000)	 /*SrNo-5*/
	DECLARE @EXTValueList3		NVARCHAR(4000)	 /*SrNo-5*/
	DECLARE @RouteLogList1		NVARCHAR(4000)
	DECLARE @RouteLogList2		NVARCHAR(4000)
	DECLARE @RouteLogList3		NVARCHAR(4000)
	DECLARE @RouteLogList4		NVARCHAR(4000)
	DECLARE @RouteLogList5		NVARCHAR(4000)
	DECLARE @RouteLogList6		NVARCHAR(4000)
	DECLARE @RouteLogList7		NVARCHAR(4000)
	DECLARE @RouteLogList8		NVARCHAR(4000)
	DECLARE @quoteChar			VARCHAR(1)
	DECLARE @Prefix				VARCHAR(5)
	DECLARE @strQuery			nvarchar(4000)
	Declare @UrnDup             NVarchar(126)
	DECLARE @ISSecureFolder CHAR(1)
	DECLARE @DocumentIndexes	VARCHAR(max)
	DECLARE @v_MainCode INT
	
	SELECT  @quoteChar			= CHAR(39)
	SELECT  @Prefix				= @quoteChar + 'N'
	SELECT  @DBDDIDataList1		= CONVERT(varchar(8000), @DBDataList1)
	SELECT  @DBDDIDataList2		= CONVERT(varchar(8000), @DBDataList2)
	SELECT  @DBDDIDataList3		= CONVERT(varchar(8000), @DBDataList3)
	SELECT  @DBDDIDataList4		= CONVERT(varchar(8000), @DBDataList4)
	SELECT  @DBDDIDataList5		= CONVERT(varchar(8000), @DBDataList5)
	SELECT  @DBDDIDataList6		= CONVERT(varchar(8000), @DBDataList6)
	SELECT  @DBDDIDataList7		= CONVERT(varchar(8000), @DBDataList7)
	SELECT  @DBDDIDataList8		= CONVERT(varchar(8000), @DBDataList8)
	SELECT  @DBDDIDataList9		= CONVERT(varchar(8000), @DBDataList9)
	SELECT  @DBDDIDataList10	= CONVERT(varchar(8000), @DBDataList10)
	SELECT  @DBDocumentList1	= CONVERT(nvarchar(4000), @DBDocList1)	 /*SrNo-5*/
	SELECT  @DBDocumentList2	= CONVERT(nvarchar(4000), @DBDocList2)	 /*SrNo-5*/
	SELECT  @DBDocumentList3	= CONVERT(nvarchar(4000), @DBDocList3)	 /*SrNo-5*/
	SELECT  @DBDocumentList4	= CONVERT(nvarchar(4000), @DBDocList4)	 /*SrNo-5*/
	SELECT  @DBDocumentList5	= CONVERT(nvarchar(4000), @DBDocList5) 
		 /*SrNo-5*/
	SELECT  @QDTColumnList		= CONVERT(VARCHAR(8000), @DBQDTColumnList)
	SELECT  @QDTValueList		= CONVERT(NVARCHAR(4000), @DBQDTValueList)	 /*SrNo-5*/
	SELECT  @EXTColumnList1		= CONVERT(VARCHAR(8000), @DBEXTColumnList1)
	SELECT  @EXTColumnList2		= CONVERT(VARCHAR(8000), @DBEXTColumnList2)
	SELECT  @EXTColumnList3		= CONVERT(VARCHAR(8000), @DBEXTColumnList3)
	SELECT  @EXTValueList1		= CONVERT(NVARCHAR(4000), @DBEXTValueList1)	 /*SrNo-5*/
	SELECT  @EXTValueList2		= CONVERT(NVARCHAR(4000), @DBEXTValueList2)	 /*SrNo-5*/
	SELECT  @EXTValueList3		= CONVERT(NVARCHAR(4000), @DBEXTValueList3)	 /*SrNo-5*/
	SELECT  @RouteLogList1		= CONVERT(NVARCHAR(4000), @DBRouteLogList1)
	SELECT  @RouteLogList2		= CONVERT(NVARCHAR(4000), @DBRouteLogList2)
	SELECT  @RouteLogList3		= CONVERT(NVARCHAR(4000), @DBRouteLogList3)
	SELECT  @RouteLogList4		= CONVERT(NVARCHAR(4000), @DBRouteLogList4)
	SELECT  @RouteLogList5		= CONVERT(NVARCHAR(4000), @DBRouteLogList5)
	SELECT  @RouteLogList6		= CONVERT(NVARCHAR(4000), @DBRouteLogList6)
	SELECT  @RouteLogList7		= CONVERT(NVARCHAR(4000), @DBRouteLogList7)
	SELECT  @RouteLogList8		= CONVERT(NVARCHAR(4000), @DBRouteLogList8)
	SELECT  @RouteLogList1		= ISNULL(@RouteLogList1, '')
	SELECT  @RouteLogList2		= ISNULL(@RouteLogList2, '')
	SELECT  @RouteLogList3		= ISNULL(@RouteLogList3, '')
	SELECT  @RouteLogList4		= ISNULL(@RouteLogList4, '')
	SELECT  @RouteLogList5		= ISNULL(@RouteLogList5, '')
	SELECT  @RouteLogList6		= ISNULL(@RouteLogList6, '')
	SELECT  @RouteLogList7		= ISNULL(@RouteLogList7, '')
	SELECT  @RouteLogList8		= ISNULL(@RouteLogList8, '')
	SELECT  @InsertExtColumnStr	= ''
	SELECT  @InsertExtValueStr	= ''

	/*BUG # WFS_5_091.----------------------------End*/
	SELECT	@FolLock		= 'N'
	SELECT	@FolLockByUser		= NULL
	SELECT	@DBUserRights		= ''
	SELECT	@DBStatus              = -1
	select @UpdateFlag = 'n'

	SELECT @TempStr		= ''
	SELECT @UrnDup=''
	SELECT @DocumentIndexes = ''
	/* Check Validity of User	*/
	/*EXECUTE PRTCheckUser @DBConnectId, @DBHostName, @DBUserId OUT, @MainGroupId OUT, @DBStatus OUT
	IF (@DBStatus <> 0)
	BEGIN
		SELECT Status = @DBStatus
		RETURN
	END*/

	/*IF @ValidataionReqd IS NOT NULL
	BEGIN
		SELECT @pos1 		= CHARINDEX(CHAR(21), @ValidataionReqd)
		SELECT @TempTableName 	= SUBSTRING(@ValidataionReqd, 1, @pos1-1)
		SELECT @ValidataionReqd = STUFF(@ValidataionReqd, 1, @pos1, NULL)
		SELECT @pos1 		= CHARINDEX(CHAR(21), @ValidataionReqd)
		SELECT @TempColumnName 	= SUBSTRING(@ValidataionReqd, 1, @pos1-1)
		SELECT @ValidataionReqd = STUFF(@ValidataionReqd, 1, @pos1, NULL)
		SELECT @pos1 		= CHARINDEX(CHAR(25), @ValidataionReqd)
		SELECT @TempValue 	= RTRIM(SUBSTRING(@ValidataionReqd, 1, @pos1-1))

		SELECT 	@TempColumnType = DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
		WHERE  	TABLE_NAME 	= @TempTableName
		AND 	COLUMN_NAME 	= @TempColumnName

		IF @TempColumnType IN ('varchar', 'char', 'datetime')
			SELECT @TempValue = CHAR(39) + @TempValue + CHAR(39)

		EXECUTE (' DECLARE valcur CURSOR FAST_FORWARD FOR ' +
			' SELECT 1 FROM ' + @TempTableName +
			' WHERE ' + @TempColumnName + ' = ' + @TempValue)
		SELECT @DBStatus = @@ERROR
		IF (@DBStatus <> 0)
		BEGIN*/
			/* Added By Dinesh Parikh  */
			/* In case of any SQL Error */
			/*SELECT  Status = 15
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
	END*/

	/* ______________________________________________________________________________________
	// Changed On  : 28/02/2005
	// Changed By  : Ruhi Hira
	// Description : SrNo-1, Omniflow 6.0, Feature: Multiple Introduction,
	//			Introduction activity in use changed, if provided in input.
	// ____________________________________________________________________________________*/
	/* Changed By Varun Bhansaly On 11/04/2007 for Bugzilla Id 532 */
	/*If (@DBInitiateFromActivityId > 0)
	Begin
		SELECT	@ActivityId = ActivityId,
			@ActivityName  = ActivityName
		FROM	ActivityTable
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
	Begin*/
		/* Changed By Varun Bhansaly On 11/04/2007 for Bugzilla Id 532 */
		/*If(@DBInitiateFromActivityName IS NOT NULL AND LEN(RTRIM(@DBInitiateFromActivityName)) > 0 )
		Begin
			SELECT	@ActivityId = ActivityId,
				@ActivityName  = ActivityName
			FROM	ActivityTable
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
			FROM	ActivityTable
			WHERE	ProcessDefID = @DBProcessDefId
			AND	ActivityType = 1
			AND	PrimaryActivity = 'Y'	*/	/* Default Introduction workstep */
		/*End
	End */

	SELECT 	@TableViewName = TableName
	FROM 	ExtDBConfTable (NOLOCK)
	WHERE 	ProcessDefId = @DBProcessDefId AND ExtObjId = 1

	SELECT 	@UpdateColumnStr 		= ''
	SELECT 	@UpdateValueStr 		= ''
	IF(@Urn IS NULL)
	BEGIN
	Select @Urn=NULL
	Select @UrnDup=NULL
	END
	else
	BEGIN
	Select @UrnDup=@Urn
	Select @Urn=@quoteChar+@Urn+@quoteChar
	END
	/*IF @DataDefinitionName IS NOT NULL  AND @DataClassFlag = 'Y' */
	/*BEGIN
		SELECT 	@DBDataDefinitionIndex = DataDefIndex
		FROM 	PDBDataDefinition
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
		SELECT @DBDataDefinitionIndex  = 0 */
	/* sharepoint related changes */
	IF (@DBSharepointFlag = 'N')
     BEGIN
	  IF( @DBDataDefinitionIndex <> 0)
       BEGIN
		SELECT @WhileCounter = 1
		SELECT @ColumnList   = ''
		SELECT @ValueList    = ''

		WHILE @WhileCounter <= 10
		BEGIN
			IF @WhileCounter = 1
				SELECT @DBDDIDataList = @DBDDIDataList1
			ELSE IF @WhileCounter = 2
				SELECT @DBDDIDataList = @DBDDIDataList2
			ELSE IF @WhileCounter = 3
				SELECT @DBDDIDataList = @DBDDIDataList3
			ELSE IF @WhileCounter = 4
				SELECT @DBDDIDataList = @DBDDIDataList4
			ELSE IF @WhileCounter = 5
				SELECT @DBDDIDataList = @DBDDIDataList5
			ELSE IF @WhileCounter = 6
				SELECT @DBDDIDataList = @DBDDIDataList6
			ELSE IF @WhileCounter = 7
				SELECT @DBDDIDataList = @DBDDIDataList7
			ELSE IF @WhileCounter = 8
				SELECT @DBDDIDataList = @DBDDIDataList8
			ELSE IF @WhileCounter = 9
				SELECT @DBDDIDataList = @DBDDIDataList9
			ELSE IF @WhileCounter = 10
				SELECT @DBDDIDataList = @DBDDIDataList10


			SELECT @ParseCount = 1
			SELECT @TempStr = ''
   			WHILE LEN(@DBDDIDataList) > 0
			BEGIN
				IF(@ParseCount = 1)
				BEGIN
					SELECT @pos1 = CHARINDEX(CHAR(21), @DBDDIDataList)
					IF (@pos1 = 0)
					BEGIN
						SELECT @TempStr = SUBSTRING(@DBDDIDataList, 1, 8000)
						SELECT @DBDDIDataList = NULL
						BREAK
					END
					ELSE
					BEGIN
						SELECT @TempFieldName = RTRIM(@TempStr) + SUBSTRING(@DBDDIDataList, 1, @pos1-1)
						SELECT @DBDDIDataList = STUFF(@DBDDIDataList, 1, @pos1, NULL)
						SELECT @ParseCount = 2
						SELECT @TempStr = ' '
					END
				END
				IF(@ParseCount = 2)
				BEGIN
					SELECT @pos1 = CHARINDEX(CHAR(25), @DBDDIDataList)
					IF (@pos1 = 0)
					BEGIN
						SELECT @TempStr = SUBSTRING(@DBDDIDataList, 1, 8000)
						SELECT @DBDDIDataList = NULL
						BREAK
					END
					ELSE
					BEGIN
						SELECT @TempFieldValue	= RTRIM(@TempStr) + SUBSTRING(@DBDDIDataList, 1, @pos1-1)
						SELECT @DBDDIDataList = STUFF(@DBDDIDataList,1,@pos1,null)
						SELECT @ParseCount = 1
						SELECT @TempStr = ' '
						SELECT	@TempFieldId 		= A.DataFieldIndex,
							@TempDataFieldType	= DataFieldType
						FROM PDBGlobalIndex A (NOLOCK), PDBDataFieldsTable B (NOLOCK)
						WHERE A.DataFieldIndex = B.DataFieldIndex
						AND   B.DataDefIndex = @DBDataDefinitionIndex
						AND   A.DataFieldName = @TempFieldName

						IF @@ROWCOUNT > 0
						BEGIN
							SELECT @ColumnList =  RTRIM(@ColumnList) + ', Field_' + CONVERT(varchar(10), @TempFieldId)
							IF (LTRIM(RTRIM(@TempFieldValue)) = CHAR(181) OR DATALENGTH(LTRIM(RTRIM(@TempFieldValue))) = 0)
								SELECT @TempFieldValue = 'NULL'

							IF(@TempFieldValue = 'NULL')
							BEGIN
								IF @TempDataFieldType = 'B'
									SELECT @TempFieldValue = '0'
								SELECT @ValueList = RTRIM(@ValueList) + ',' + LTRIM(RTRIM(@TempFieldValue))
							END
							ELSE IF (@TempDataFieldType = 'S')
							BEGIN
								/* replace every single quote with two single quotes */
								SELECT @TempFieldValue = REPLACE(@TempFieldValue, CHAR(39), CHAR(39) + CHAR(39))
								SELECT @ValueList = RTRIM(@ValueList) + ',' + CHAR(39) + RTRIM(@TempFieldValue) + CHAR(39)
							END
							ELSE IF (@TempDataFieldType = 'D')
							BEGIN
								SELECT @ValueList = RTRIM(@ValueList) + ',' + CHAR(39) + RTRIM(@TempFieldValue) + CHAR(39)
							END
							ELSE IF (@TempDataFieldType	= 'I' OR
								@TempDataFieldType	= 'L' OR
								@TempDataFieldType	= 'F' OR
								@TempDataFieldType	= 'B' OR
								@TempDataFieldType	= 'X')
							BEGIN
								SELECT @ValueList = RTRIM(@ValueList) + ',' + LTRIM(RTRIM(@TempFieldValue))
							END
							EXECUTE CheckData  'F', @NewFolderIndex, @DDTTableName, @TempFieldId, @TempDataFieldType, @TempFieldValue, @DBStatus OUTPUT
							IF (@DBStatus <> 0)
							BEGIN
								SELECT Status = @DBStatus
								RETURN
							END
						END
					END
				END
			END
			SELECT @WhileCounter = @WhileCounter + 1
		END
	END

	SELECT 	@DBAccessType		= ISNULL(@DBAccessType, 'I'),
        	@DBComment		= ISNULL(@DBComment,	'Not Defined'),
		@DuplicateNameFlag	= ISNULL(@DuplicateNameFlag, 'Y')
		
	SELECT @ISSecureFolder = ISSecureFolder FROM ProcessDefTable WITH(NOLOCK) WHERE ProcessDefId = @DBProcessDefId
	IF (UPPER(ISNULL(@ISSecureFolder, 'N')) = 'N')
		SELECT @DBFolderType = 'G'
	ELSE
		SELECT @DBFolderType = 'K'

	SELECT @CurrDate = GETDATE()
	IF @DBExpiryDateTime IS NULL
	BEGIN
		/* Changed By Varun Bhansaly On 25/07/2007 for Bugzilla Id 1544 */
		SELECT @ExpiryDateTime = CONVERT(DATETIME, '2099-12-31 00:00:00.000')
	END
	ELSE
	BEGIN
		SELECT @ExpiryDateTime = CONVERT(DATETIME, @DBExpiryDateTime)
	END


	SELECT 	@UserName = UserName
	FROM 	PDBUser (NOLOCK)
	WHERE 	UserIndex = @DBUserId


	/*SELECT @DBParentFolderId = WorkFlowFolderId
	FROM   RouteFolderDefTable
	WHERE  ProcessDefId = @DBProcessDefId
	IF @@ROWCOUNT <= 0
	BEGIN
	       	EXECUTE PRTRaiseError  'PRT_ERR_Invalid_Parameter', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END */

/*
	SELECT @DataClassFlag = 'N'
	SELECT @TableViewName = TableName
	FROM ExtDBConfTable
	WHERE ProcessDefId = @DBProcessDefId
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT	@DDTTableName = TABLE_NAME
		FROM	INFORMATION_SCHEMA.VIEW_TABLE_USAGE
		WHERE	VIEW_NAME = @TableViewName
		IF @@ROWCOUNT > 0
			SELECT @DataClassFlag = 'Y'
	END
*/

	/* ______________________________________________________________________________________
	// Changed On  : 28/02/2005
	// Changed By  : Ruhi Hira
	// Description : SrNo-1, Omniflow 6.0, Feature: Multiple Introduction,
	//			ActivityId filter added to query.
	// ____________________________________________________________________________________*/
	/* changed by Tirupati srivastava on 3/5/2007 for Bugzilla Id 676 */
	/*SELECT  TOP 1 @QueueName	  = QUEUEDEFTABLE.QUEUENAME,
		@QueueId	= QUEUEDEFTABLE.QUEUEID,
		@StreamId	= QUEUESTREAMTABLE.STREAMID
	FROM 	QUEUESTREAMTABLE, QUserGroupView , ACTIVITYTABLE , QUEUEDEFTABLE
	WHERE 	ACTIVITYTABLE.PROCESSDEFID 	= @DBProcessDefId
	AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1
	AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID
	AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID
	AND 	ACTIVITYTABLE.ACTIVITYID	= @ActivityId
	AND 	QUEUESTREAMTABLE.QUEUEID 	= QUserGroupView.QUEUEID
	AND 	QUEUEDEFTABLE.QUEUEID 		= QUserGroupView.QUEUEID
	AND 	QUEUETYPE 			= 'I'
	AND 	USERID 				= @DBUserId

	IF @@ROWCOUNT <= 0
	BEGIN
		SELECT @DBStatus = 300	*//*WFS_7.1_033*/
		/*SELECT 	Status   = @DBStatus
		RETURN
	END */

	/*BEGIN TRANSACTION TranWorkItem
	UPDATE 	ProcessDefTable
	SET 	RegStartingNo 	= RegStartingNo + 1
	WHERE 	ProcessDefID 	= @DBProcessDefId

	SELECT	@ProcessState	= ProcessState,
		@RegPrefix	= RegPrefix,
		@RegSuffix	= RegSuffix,
		@RegStartingNo	= RegStartingNo,
		@RegSeqLength	= RegSeqLength,
		@ProcessName	= ProcessName,
		@ProcessVersion = VersionNo
	FROM	ProcessDefTable
	WHERE	ProcessDefID	= @DBProcessDefId
	COMMIT TRANSACTION TranWorkItem*/

	/*IF @ProcessState <> 'Enabled'
	BEGIN
		SELECT @DBStatus = 2
		SELECT 	Status   = @DBStatus
		RETURN
	END

	SELECT @RegStartingNo	= @RegStartingNo
	SELECT @RegPrefix	= @RegPrefix + '-'
	SELECT @RegSuffix	= '-' + @RegSuffix


	IF LEN(@RegStartingNo) > @RegSeqLength - LEN(@RegPrefix) - LEN(@RegSuffix)
	BEGIN
		SELECT @DBStatus = 19
		SELECT 	Status   = @DBStatus
		RETURN
	END

	SELECT	@Length			= @RegSeqLength - LEN(@RegPrefix) - LEN(@RegSuffix)
	SELECT	@ProcessInstanceId	= REPLICATE('0', @Length)
	SELECT 	@ProcessInstanceId	= @RegPrefix + SUBSTRING(@ProcessInstanceId,1, LEN(@ProcessInstanceId) - LEN(@RegStartingNo)) + CONVERT(varchar(10), @RegStartingNo) + @RegSuffix */
	SELECT 	@DBFolderName		= @ProcessInstanceId

/*	BEGIN TRANSACTION TranWorkItem	*/

	SELECT 	@FolderLock		= FolderLock,
		@FinalizedFlag 		= FinalizedFlag,
		@DBLocation 		= Location,
		@ParentFolderType	= FolderType,
		@DBImageVolumeIndex	= ISNULL(@DBImageVolumeIndex, ImageVolumeIndex),
		@TempUser 		= Owner,
		@AccessType 		= AccessType,
		@ACLMore 		= ACLMoreFlag,
		@ACLstr			= ACL,
		@EnableVersion		= EnableVersion,
		@ParentEnableFTS	= EnableFTS,
		@MainGroupId		= MainGroupId,
		@LockMessage		= LockMessage,
		@LockByUser		= LockByUser,
		@FolderLevel		= FolderLevel,
		@Hierarchy		= Hierarchy
	FROM PDBFolder (NOLOCK) /* (UPDLOCK) */
	WHERE FolderIndex 		= @DBParentFolderId
	AND (@MainGroupId = 0 OR MainGroupId = @MainGroupId)

	IF @@ROWCOUNT <= 0
	BEGIN
/*		ROLLBACK TRANSACTION TranWorkItem	*/
	       	EXECUTE PRTRaiseError  'PRT_ERR_Folder_Not_Exist', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END
	ELSE
	IF (NOT(@DBLocation IN ('R','G','A','K') and @DBFolderType IN ('G','A','K')))
	BEGIN
/*		ROLLBACK TRANSACTION TranWorkItem	*/
		EXECUTE PRTRaiseError  'PRT_ERR_Cannot_AddFolder', @DBStatus OUT
		SELECT Status = @DBStatus
		RETURN
	END
	ELSE
	IF @ParentFolderType <> @DBFolderType
	BEGIN
/*		ROLLBACK TRANSACTION TranWorkItem	*/
		EXECUTE PRTRaiseError  'PRT_ERR_Cannot_AddFolder', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END
	ELSE
	IF (@FolderLock = 'Y')
	BEGIN
		/* Fetch effective lock by user and lock message */
		EXECUTE CheckLock	'F', @DBParentFolderId, @LockByUser, @FolderLock, @EffectiveLockByUser OUT,
					@LockMessage OUT, @LockedObject OUT, @DBStatus OUT
		IF @EffectiveLockByUser <> @DBUserId
		BEGIN
/*			ROLLBACK TRANSACTION TranWorkItem */
			EXECUTE PRTRaiseError 'PRT_ERR_Folder_Locked', @DBStatus OUT
			SELECT 	Status = @DBStatus
			RETURN
		END
		SELECT	@FolLock		= 'Y'
		SELECT	@FolLockByUser		= @LockByUser
	END
	ELSE IF (@FinalizedFlag = 'Y')
	BEGIN
/*		ROLLBACK TRANSACTION TranWorkItem	*/
		EXECUTE PRTRaiseError 'PRT_ERR_Finalised_Folder', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END
	ELSE
	BEGIN
		SELECT @DBStatus = 0
	END

	IF @Folderlevel >= 255
	BEGIN
/*		ROLLBACK TRANSACTION TranWorkItem	*/
		EXECUTE PRTRaiseError 'PRT_ERR_Max_Level_Count_Reached', @DBStatus OUT
		SELECT 	Status = @DBStatus
		RETURN
	END

	IF @LimitCount IS NOT NULL
	BEGIN
		IF ((SELECT COUNT(*) FROM PDBFolder (NOLOCK)
			WHERE ParentFolderIndex = @DBParentFolderId
			AND AccessType = @DBAccessType) >= @LimitCount)
		BEGIN
/*			ROLLBACK TRANSACTION TranWorkItem	*/
			EXECUTE PRTRaiseError 'PRT_ERR_Max_Folder_Count_Reached', @DBStatus OUT
			SELECT 	Status = @DBStatus
			RETURN
		END
	END

	/* Generate the name of the folder if the foldername given is NULL*/
	IF @DBFolderName IS NULL 
	BEGIN
		EXECUTE PRTGenerateDefaultName 'F',@DBParentFolderId, NULL, NULL, @MainGroupId, @DBFolderName OUT,
						@DBStatus OUT
		IF (@DBStatus <> 0)
		BEGIN
/*			ROLLBACK TRANSACTION TranWorkItem	*/
			SELECT 	Status = @DBStatus
			RETURN
		END
	END

	ELSE	/* Check for the uniqueness of the folder	*/
	BEGIN
	/* ______________________________________________________________________________________
	// Changed On  : 12/05/2005
	// Changed By  : Rahul Mehta
	// Description : SrNo-2, GENERATENAME SP previously had 10 parameters but currently it has 12 parameters
	//		(Parameter values added are for 9th and 10th parameter)
	// ____________________________________________________________________________________*/
		EXECUTE GenerateName	'F' , @DBFolderName, @DBParentFolderId, NULL, NULL, @NameLength, @MainGroupId,
					@DuplicateNameFlag,NULL,'N', @TMPDBFolderName OUT, @DBStatus OUT
		IF @DBStatus <> 0
		BEGIN
/*			ROLLBACK TRANSACTION TranWorkItem	*/
			SELECT 	Status = 	@DBStatus
			RETURN
		END
	END


	SELECT @Hierarchy = ISNULL(RTRIM(@Hierarchy), '') + RTRIM(CONVERT(varchar(10), @DBParentFolderId)) + '.'
	
	/* Changed By Varun Bhansaly On 25/07/2007 for Bugzilla Id 1544 */
	--BEGIN TRANSACTION TranWorkItem
	INSERT INTO PDBFolder(ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
		AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
		FolderType, FolderLock, LockByUser, Location, DeletedDateTime,
		EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag,
		FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage,
		Folderlevel, Hierarchy)
	VALUES ( @DBParentFolderId, @TMPDBFolderName, @DBUserId, @CurrDate, @CurrDate,
		@CurrDate, @DBDataDefinitionIndex, @DBAccessType, @DBImageVolumeIndex,
		@DBFolderType, @FolLock, @FolLockByUser, @ParentFolderType, CONVERT(DATETIME, '2099-12-31 00:00:00.000'),
		ISNULL(@DBVersionFlag, @EnableVersion), @ExpiryDateTime, ISNULL(@DBComment,''), NULL, NULL, 'N',
		CONVERT(datetime,'2099-12-31 00:00:00.000'), 0, 'N', @MainGroupId, ISNULL(@DBEnableFTS, @ParentEnableFTS),
		@LockMessage, @Folderlevel + 1, @Hierarchy)
	SELECT @NewFolderIndex = @@IDENTITY

	IF( @DBDataDefinitionIndex > 0)
	BEGIN
		IF LEN(@ColumnList) > 0
		BEGIN
			SELECT @ColumnList   = ' FoldDocIndex, FoldDocFlag' + @ColumnList
			SELECT @ValueList    = CONVERT(varchar(10), @NewFolderIndex) + ',' + CHAR(39) + 'F' + CHAR(39) + @ValueList
			EXECUTE ('INSERT INTO ' + @DDTTableName + ' ( ' + @ColumnList + ' ) VALUES ( ' +
				@ValueList + ')')
			IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)  /* WFS_5_169 */
			BEGIN
				--ROLLBACK TRANSACTION TranWorkItem
				SELECT 	Status = 15
				RETURN
			END
		END
		EXECUTE PRTBuildUseFulDataString @NewFolderIndex, 'F', @DBDataDefinitionIndex, @DBStatus OUT
	END

	SELECT @WhileCounter = 1
	SELECT @NextOrder = 0
	SELECT @UniqueNameString = ';'
	SELECT @TempStr = ''
	WHILE  @WhileCounter <= 5
	BEGIN
		IF @WhileCounter = 1
			SELECT @DBDocumentList = @DBDocumentList1
		ELSE IF @WhileCounter = 2
			SELECT @DBDocumentList = @DBDocumentList2
		ELSE IF @WhileCounter = 3
			SELECT @DBDocumentList = @DBDocumentList3
		ELSE IF @WhileCounter = 4
			SELECT @DBDocumentList = @DBDocumentList4
		ELSE IF @WhileCounter = 5
			SELECT @DBDocumentList = @DBDocumentList5
		--SELECT @TempStr = ''
		WHILE LEN(@DBDocumentList) > 0
		BEGIN
			SELECT @DocumentType = NULL
			SELECT @pos1 = CHARINDEX(CHAR(25), @DBDocumentList)
			IF @pos1 = 0
			BEGIN
				SELECT @TempStr = SUBSTRING(@DBDocumentList, 1, 4000) /*Bugzilla bug 10941*/
				SELECT @DBDDIDataList = NULL
				BREAK
			END
			ELSE
			BEGIN
				/** Sample Format - 
				  *   Select Name,DocumentIndex,ImageIndex,VolumeId,NoOfPages,DocumentSize,AppName,DocumentType,Comment from *   Pdbdocument where documentindex = <DocumentIndex for document>
				  *
				  *	  Name+((char)21) + ImageIndex#VolumeId + ((char)21) +NoOfPages + (char(21)) +  DocumentSize + ((char(21)) 
				  *		+ AppName + (char(21))  + DocumentType + ((char21)) +  comment    +  ((char)25)
				  *	IDProof1880#11100071jpgIIDProof[CHAR25--EM]
				  *	 Added by Mohnish Chopra
				 **/
				SELECT @TempStr 	= RTRIM(@TempStr) + RTRIM(SUBSTRING(@DBDocumentList, 1, @pos1-1))
				SELECT @DBDocumentList 	= STUFF(@DBDocumentList, 1, @pos1, NULL)
				
				IF RTRIM(SUBSTRING(@TempStr, LEN(@TempStr), 1)) = CHAR(21)
				BEGIN
					SELECT @TempStr = RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr) -1))
				END
				
				SELECT @pos1 		= CHARINDEX(CHAR(21), @TempStr)
				SELECT @DocumentName 	= RTRIM(SUBSTRING(@TempStr, 1, @pos1-1))
				SELECT @TempStr 	= STUFF(@TempStr, 1, @pos1, NULL)

				SELECT @pos1 		= CHARINDEX(CHAR(21), @TempStr)
				SELECT @ISIndexStr 	= RTRIM(SUBSTRING(@TempStr, 1, @pos1-1))
				SELECT @TempStr 	= STUFF(@TempStr, 1, @pos1, NULL)

				SELECT @pos1 		= CHARINDEX(CHAR(21), @TempStr)
				SELECT @NoOfPage 	= CONVERT(int, RTRIM(SUBSTRING(@TempStr, 1, @pos1-1)))
				SELECT @TempStr 		= STUFF(@TempStr, 1, @pos1, NULL) 

				SELECT @pos1 			= CHARINDEX(CHAR(21), @TempStr)				
				IF @pos1 > 1 
			        BEGIN 
					
					SELECT @DocumentSize 	= CONVERT(int, RTRIM(SUBSTRING(@TempStr, 1, @pos1-1)))

					SELECT @TempStr		=  STUFF(@TempStr, 1, @pos1, NULL)
					SELECT @pos1 		= CHARINDEX(CHAR(21), @TempStr)
					/*WFS_8.0_013*/
					IF @pos1 > 1 --Document contains AppTYpe also
					BEGIN
						SELECT @AppType		= RTRIM(SUBSTRING(@TempStr, 1, @pos1-1))
						SELECT @TempStr		=  STUFF(@TempStr, 1, @pos1, NULL)
						SELECT @pos1 		= CHARINDEX(CHAR(21), @TempStr)
						IF @pos1 = 2 --It seems DocumentType is also sent,Ncomment_str, pos for CHAR(21) = 2 if DocType is also sent 
						BEGIN
							SELECT @DocumentType = RTRIM(SUBSTRING(@TempStr,1, @pos1-1))
							SELECT @Comment 	= RTRIM(SUBSTRING(@TempStr, @pos1+1,LEN(@TempStr)-2))--Excluding first two and last one NAK character
						END
						ELSE --No DocumnetType is sent in Documents tag
						BEGIN
							IF ( LEN(@TempStr) = 1 AND (@TempStr='N' or @TempStr='I'))
							BEGIN
								SELECT @DocumentType = RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr)))
								SELECT @Comment = ''
							END
							ELSE
							BEGIN
								SELECT @Comment = RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr)))
							END
						END
					END
					ELSE
					BEGIN
						SELECT @AppType		= STUFF(@TempStr, 1, @pos1, NULL)
						SELECT @Comment		= ''
					END
					/*WFS_8.0_013*/
				END
				ELSE
				BEGIN
					SELECT @DocumentSize 	= CONVERT(int, RTRIM(STUFF(@TempStr, 1, @pos1, NULL))) 
					SELECT @AppType		= 'TIF'
					SELECT @Comment		= ''
				END

				/* Bug No WFS_6.1.2_059 hash symbol replaced by chr(35) - Ruhi Hira */
				SELECT @pos1 		= CHARINDEX(char(35), @ISIndexStr)
				SELECT @ImageIndex 	= CONVERT(int, LTRIM(RTRIM(SUBSTRING(@ISIndexStr, 1, @pos1-1))))
				SELECT @VolumeIndex 	= CONVERT(int, LTRIM(RTRIM(STUFF(@ISIndexStr, 1, @pos1, null))))
				
				SELECT @TempStr = ''
				IF @DocumentType IS NULL OR @DocumentType = NULL
				BEGIN
					IF(@AppType = 'tif' OR @AppType = 'tiff' OR @AppType = 'bmp' OR @AppType = 'jpeg' OR @AppType = 'jpg' OR @AppType = 'jif' OR @AppType = 'gif')
						--Removing 'PNG' for bugzilla bugID - 88867
						SELECT  @DocumentType = 'I'
					ELSE 
						SELECT @DocumentType = 'N'
				END
				/* ______________________________________________________________________________________
				// Changed On  : 12/05/2005
				// Changed By  : Rahul Mehta
				// Description : SrNo-2, GENERATENAME SP previously had 10 parameters but currently it has 12 parameters
				//		(Parameter values added are for 9th and 10th parameter)
				// ____________________________________________________________________________________*/
				SELECT @pos1 = CHARINDEX(';' + @DocumentName + '.' + @AppType + ';', @UniqueNameString)
				IF(@pos1 > 0)
				BEGIN
					EXECUTE GenerateName 'D', @DocumentName, @NewFolderIndex, @DocumentType, @AppType, 255, @MainGroupId, 'Y',NULL,'N', @DocumentName OUT, @DBStatus OUT
					IF @DBStatus <> 0
					BEGIN
						--ROLLBACK TRANSACTION TranWorkItem
						SELECT 	Status = 	@DBStatus
						RETURN
					END
				END
				ELSE
				BEGIN
					SELECT @UniqueNameString = @UniqueNameString + @DocumentName + '.' + @AppType + ';'
				END

				/* Changed By Varun Bhansaly On 25/07/2007 for Bugzilla Id 1544 */
				INSERT INTO PDBDocument(VersionNumber, VersionComment,
					Name, Owner, CreatedDateTime, RevisedDateTime,
					AccessedDateTime, DataDefinitionIndex,
					Versioning, AccessType, DocumentType,
					CreatedbyApplication, CreatedbyUser,
					ImageIndex, VolumeId, NoOfPages, DocumentSize,
					FTSDocumentIndex, ODMADocumentIndex,
					HistoryEnableFlag, DocumentLock, LockByUser,
					Comment, Author, TextImageIndex, TextVolumeId,
					FTSFlag, DocStatus, ExpiryDateTime,
					FinalizedFlag, FinalizedDateTime, FinalizedBy,
					CheckOutstatus, CheckOutbyUser,	UseFulData,
					ACL, PhysicalLocation, ACLMoreFlag, AppName,
					MainGroupId, PullPrintFlag, ThumbNailFlag,
					LockMessage)
				 VALUES ( 1.0,	'Original',
					@DocumentName, @DBUserId, @CurrDate, @CurrDate,
					@CurrDate, 0,
					@EnableVersion, 'I', @DocumentType,
					0, @DBUserId,
					@ImageIndex, @VolumeIndex, @NoOfPage, @DocumentSize,
					0, 'not defined',
					'N', 'N', NULL,
					@Comment, @UserName, 0, 0, 
					'XX', 'A', convert(datetime, '2099-12-12 00:00:00.000'),
					'N', convert(datetime, '2099-12-12 00:00:00.000'), 0,
					'N', 0, NULL,
					NULL, 'not defined', 'N', @AppType,
					@MainGroupId, 'N', 'N', NULL)
				SELECT @DBStatus = @@ERROR
				IF (@DBStatus <> 0)
				BEGIN
					--ROLLBACK TRANSACTION TranWorkItem
					SELECT 	Status = 	15
					RETURN
				END

				SELECT 	@NewDocumentIndex = @@IDENTITY
				SELECT  @NextOrder = @NextOrder + 1
				INSERT INTO PDBDocumentContent(
					ParentFolderIndex, DocumentIndex,
					FiledBy, FiledDatetime,
					DocumentOrderNo, RefereceFlag)
				 VALUES(@NewFolderIndex, @NewDocumentindex,
					@DBUserId, @CurrDate, @NextOrder , 'O')
				Select @DBStatus = @@ERROR
				IF (@DBStatus <> 0)
				BEGIN
					--ROLLBACK TRANSACTION TranWorkItem
					SELECT 	Status = 	15
					RETURN
				END
				Select @DocumentIndexes = ISNULL(@DocumentIndexes,'') + ISNULL(@DocumentName,'') + char(21) + CONVERT(varchar(30),@NewDocumentIndex) + CHAR(21) + CONVERT(varchar(30),@ImageIndex) + CHAR(35) + CONVERT(varchar(30),@VolumeIndex) + char(25)
                /*WFS_8.0_037*/
                IF(@Comment = '')
                BEGIN
                    SELECT @FieldName = @DocumentName
                END
                ELSE
                BEGIN
                    SELECT @FieldName = @DocumentName + '(' + @Comment+ '.' + @AppType + ')'
                END
                /*Insert Into WFMessageTable (message, status,ActionDateTime)
                values('<Message><ActionId>18</ActionId><UserId>' + convert(varchar,@DBUserId) +
                '</UserId><ProcessDefId>' + convert(varchar,@DBProcessDefId) +
                '</ProcessDefId><ActivityId>' + convert(varchar,@ActivityId) +
                '</ActivityId><QueueId>'+ convert(varchar, @QueueId) +
                '</QueueId><UserName>' + @UserName +
                '</UserName><ActivityName>' + @ActivityName +
                '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ProcessInstance>' + @ProcessInstanceId +
                '</ProcessInstance><FieldId>' + convert(varchar,@QueueId) +
                '</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag><FieldName>' +
                @FieldName + '</FieldName></Message>',
                N'N', GETDATE())*/
				EXECUTE WFGenerateLog 18, @DBUserId, @DBProcessDefId, @ActivityId, @QueueId, @UserName, @ActivityName, 0, @ProcessInstanceId, @QueueId, @FieldName, 1,  0, 0, null, @DBProcessVariantId, 0 ,0, @UrnDup,NULL, @v_MainCode OUT
			END
		END
		SELECT @WhileCounter = @WhileCounter + 1
	END
	END --END OF Sharepoint IF
	
	
	
	DECLARE sysattrcur CURSOR FAST_FORWARD FOR
		SELECT 	A.UserDefinedName, A.SystemDefinedName, A.VariableType
		FROM 	VarMappingTable A (NOLOCK), RecordMappingTable B (NOLOCK)
		WHERE 	A.ProcessDefId 	= @DBProcessDefId
		AND 	A.ProcessDefId 	= B.ProcessDefId
		AND 	VariableScope 	= 'M'
		AND 	(A.UserDefinedName = B.REC1 OR A.UserDefinedName = B.REC2 OR A.UserDefinedName = B.REC3 OR A.UserDefinedName = B.REC4 OR A.UserDefinedName = B.REC5)
	OPEN sysattrcur
	FETCH NEXT FROM sysattrcur INTO @UserDefinedName, @SystemDefinedName, @VariableType
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @UserDefinedName = 'ItemIndex'
		BEGIN
			IF @DBSharepointFlag = 'N'
				SELECT @Var_Rec_1 	= CONVERT(varchar(10), @NewFolderIndex)
			ELSE
				SELECT @Var_Rec_1 	= CONVERT(varchar(255), @DBFolderIdSP)
			
			IF @UpdateFlag = 'Y'
			BEGIN
				SELECT @UpdateColumnStr	= RTRIM(@UpdateColumnStr) + ',' + @SystemDefinedName
				SELECT @UpdateValueStr = @UpdateValueStr + ',' + CHAR(39) + RTRIM(@Var_Rec_1) + CHAR(39)
				
			END
			ELSE
			BEGIN
				SELECT @UpdateFlag = 'Y'
				SELECT @UpdateColumnStr	= RTRIM(@SystemDefinedName)
				SELECT @UpdateValueStr = CHAR(39) + RTRIM(@Var_Rec_1) + CHAR(39)
			
			END
		END
		ELSE IF @UserDefinedName = 'ItemType'
		BEGIN
			SELECT @Var_Rec_1 	= CHAR(39) + 'F' + CHAR(39)
			IF @UpdateFlag = 'Y'
			BEGIN
				SELECT @UpdateColumnStr	= RTRIM(@UpdateColumnStr) + ',' + @SystemDefinedName
				SELECT @UpdateValueStr = @UpdateValueStr + ','  + RTRIM(@Var_Rec_1)
			
			END
			ELSE
			BEGIN
				SELECT @UpdateFlag = 'Y'
				SELECT @UpdateColumnStr	= RTRIM(@SystemDefinedName)
				SELECT @UpdateValueStr = RTRIM(@Var_Rec_1)
				
			END
		END
		ELSE
		BEGIN
			SELECT @Var_Rec_1 = ' NULL '
		END
		SELECT @InsertExtColumnStr = @InsertExtColumnStr + ',' + @UserDefinedName
		SELECT @InsertExtValueStr  = @InsertExtValueStr + ',' + @Var_Rec_1
		FETCH NEXT FROM sysattrcur INTO @UserDefinedName, @SystemDefinedName, @VariableType
	END
	CLOSE 		sysattrcur
	DEALLOCATE 	sysattrcur
	/* Changed By : Varun Bhansaly On 02/02/2007 */
	/*
	SELECT  @ProcessTurnAroundTime  =  ProcessTurnAroundTime
	FROM PROCESSDEFTABLE A, ACTIVITYTABLE B
	WHERE 	A.ProcessDefId = B.ProcessDefId
	AND 	B.ProcessDefId = @DBProcessDefId
	AND	ActivityId = @ActivityId */ /* Bugzilla Bug 270 - For multiple introduction worksteps */
	
	/* ______________________________________________________________________________________
	// Changed On  : 12/05/2005
	// Changed By  : Rahul Mehta
	// Description : SrNo-2, Intially "ValidTill" is always null
	// ____________________________________________________________________________________*/

	Select @ValidTill = null
	IF @QDTColumnList is null 
	BEGIN
		SELECT @QDTColumnList = ''
	END	

	/* ______________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-3, ExpectedProcessDelay is set as 1900-01-01 00:00:00.000 in uploadWorkitem;
	                         it should be ProcessTurnAroundTime + currentDate rather than 0
	// ____________________________________________________________________________________*/

	/* Changed By : Varun Bhansaly On 02/02/2007 */
	/* ______________________________________________________________________________________
		// Changed On  : 26/05/2009
		// Changed By  : Saurabh Kamal
		// Description : WFS_8.0_010, IF-ELSE added.Inserting ProcessInstanceState as 1 and 
		//		 IntroducedByID, IntroducedBy,IntroductionDatetime as NULL	
		// ____________________________________________________________________________________*/
	
	IF @DBInitiateAlso = N'Y' AND @DBSynchronousRouting != N'Y'
		BEGIN
			SELECT @strQuery = 'Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID,Createdby,CreatedDatetime,ProcessinstanceState, 
				CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay,IntroducedAt,WorkItemId, ProcessName,ProcessVersion,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,
				CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,WorkItemState,Statename,
				ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,
				RoutingStatus,ProcessVariantId,SaveStage, InstrumentStatus, CheckListCompleteFlag'+@QDTColumnList+','+ @UpdateColumnStr+', Locale )
			Values (N'+ISNULL(@Urn,'''''')+',N'+@quoteChar+ @ProcessInstanceId +@quoteChar+', '+CONVERT(VARCHAR,@DBProcessDefId)+', '+CONVERT(VARCHAR,@DBUserId)+', GETDATE(),2, N'+@quoteChar+ @UserName +@quoteChar+','+CONVERT(VARCHAR,@DBUserId)+',N'+@quoteChar+ @UserName +@quoteChar+',GETDATE(),'+CONVERT(VARCHAR,ISNULL('NULL',@DBExpectedProcessDelay))+',N'+@quoteChar+@ActivityName +@quoteChar+' ,1,N'+@quoteChar+ @ProcessName +@quoteChar+','+CONVERT(VARCHAR,@ProcessVersion)+' , '+CONVERT(VARCHAR,@DBUserId)+',N'+@quoteChar+@UserName +@quoteChar+', N'+@quoteChar+@ActivityName +@quoteChar+', '+CONVERT(VARCHAR,@ActivityId)+',1, GETDATE(),N'+@quoteChar+ 'Y' +@quoteChar+',N'+@quoteChar+ 'N' +@quoteChar+','+CONVERT(VARCHAR,@DBPriorityLevel)+','+CONVERT(VARCHAR,ISNULL('NULL',@ValidTill))+',0,0,NULL,NULL,NULL,6,N'+@quoteChar+ 'COMPLETED' +@quoteChar+',NULL,N'+@quoteChar+@ActivityName +@quoteChar+',NULL, N'+@quoteChar+ 'N' +@quoteChar+',GETDATE(),NULL,NULL,NULL, N'+@quoteChar+ 'Y' +@quoteChar+', '+CONVERT(VARCHAR,@DBProcessVariantId)+', N'+@quoteChar+ @ActivityName +@quoteChar+' , N'+@quoteChar+ 'N' +@quoteChar+', N'+@quoteChar+ 'N' + @quoteChar +ISNULL(@QDTValueList,'')+'  ,'+@UpdateValueStr+ ', N'+@quoteChar+@DBLocale+@quoteChar+')'
			
		END
	ELSE
		BEGIN
			SELECT @strQuery = 'Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID, Createdby, CreatedDatetime,ProcessinstanceState,CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay, IntroducedAt,WorkItemId, ProcessName,ProcessVersion,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,WorkItemState,Statename, ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,				RoutingStatus,ProcessVariantId,SaveStage, InstrumentStatus, CheckListCompleteFlag '+@QDTColumnList+','+ @UpdateColumnStr+' , Locale )
			Values 
			(N'+ISNULL(@Urn,'''''')+',N'+@quoteChar+ @ProcessInstanceId +@quoteChar+', '+CONVERT(VARCHAR,@DBProcessDefId)+', '+CONVERT(VARCHAR,@DBUserId)+', GETDATE(),1, N'+@quoteChar+ @UserName +@quoteChar+',NULL,NULL,NULL,'+CONVERT(VARCHAR,ISNULL('NULL',@DBExpectedProcessDelay))+',N'+@quoteChar+ @ActivityName +@quoteChar+' ,1,N'+@quoteChar+ @ProcessName +@quoteChar+','+CONVERT(VARCHAR,@ProcessVersion)+','+CONVERT(VARCHAR,@DBUserId)+',N'+@quoteChar+ @UserName +@quoteChar+', N'+@quoteChar+ @ActivityName +@quoteChar+', '+CONVERT(VARCHAR,@ActivityId)+',1, GETDATE(),N''S'', N''N'','+CONVERT(VARCHAR,@DBPriorityLevel)+','+CONVERT(VARCHAR,ISNULL('NULL',@ValidTill))+','+CONVERT(VARCHAR,@StreamId)+','+CONVERT(VARCHAR,@QueueId)+',NULL,NULL,NULL,1,N''NOTSTARTED'',NULL,N'+@quoteChar+ @ActivityName +@quoteChar+',NULL,N''N'',NULL,N'+@quoteChar+ @QueueName +@quoteChar+', N''I'',NULL, N''N'','+CONVERT(VARCHAR,@DBProcessVariantId)+', N'+@quoteChar+ @ActivityName +@quoteChar+' , N''N'', N'+@quoteChar+ 'N' +@quoteChar +ISNULL(@QDTValueList,'')+'  ,'+@UpdateValueStr+' , N'+@quoteChar+@DBLocale+@quoteChar+')'
				
				
			--commit
			
		END
	Execute(@strQuery)	
	IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)  /* WFS_5_169 */
	BEGIN
		--ROLLBACK TRANSACTION TranWorkItem
		SELECT 	Status = 15
		RETURN
	END

	/* ______________________________________________________________________________________
		// Changed On  : 25/07/2007
		// Changed By  : Tirupati Srivastava
		// Description : IF-ELSE added.Bugzilla Id 1447
		// ____________________________________________________________________________________*/
	/* ______________________________________________________________________________________
		// Changed On  : 26/05/2009
		// Changed By  : Saurabh Kamal
		// Description : WFS_8.0_010, IF InitiateAlso != Y Insert AssignmentType = 'S'				 
		// ____________________________________________________________________________________*/

	/*IF @DBInitiateAlso = N'Y'
		BEGIN
			Insert Into workdonetable
			(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,
			ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,
			CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,
			FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,
			LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus, ProcessVariantId)
			Values(@ProcessInstanceId, 1, @ProcessName, @ProcessVersion, @DBProcessDefId, @DBUserId,
			@UserName, @ActivityName, @ActivityId, @CurrDate, 0,'Y','N',@DBPriorityLevel,@ValidTill,
			@StreamId,@QueueId,NULL,NULL,NULL,@CurrDate,6,'COMPLETED',NULL,@ActivityName,NULL,'N',@CurrDate,
			@QueueName, 'I',NULL, @DBProcessVariantId)
		END
	ELSE
		BEGIN
			Insert Into WorkListTable  
			(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy, 
			ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType, 
			CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser, 
			FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, 
			LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus, ProcessVariantId) 
			Values(@ProcessInstanceId, 1, @ProcessName, @ProcessVersion, @DBProcessDefId, @DBUserId, 
			@UserName, @ActivityName, @ActivityId, @CurrDate, 0,'S','N',@DBPriorityLevel,@ValidTill,
			@StreamId,@QueueId,NULL,NULL,NULL,@CurrDate,1,'NOTSTARTED',NULL,@ActivityName,NULL,'N',NULL, 
			@QueueName, 'I',NULL, @DBProcessVariantId) 
		END

	IF(@@ERROR <> 0 OR @@ROWCOUNT = 0) 
	BEGIN
		--ROLLBACK TRANSACTION TranWorkItem
		SELECT 	Status = 15
		RETURN
	END
	Execute('INSERT INTO QueueDataTable (ProcessInstanceID, WorkItemID, SaveStage, InstrumentStatus, CheckListCompleteFlag' + @QDTColumnList + ', ' + @UpdateColumnStr + ') VALUES (N' + @quoteChar +  @ProcessInstanceId + @quoteChar + ', 1, N' + @quoteChar + @ActivityName + @quoteChar + ', N' + @quoteChar + 'N' + @quoteChar + ', N' + @quoteChar + 'N' + @quoteChar + @QDTValueList + ',' + @UpdateValueStr + ')')
	IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)  
	BEGIN
		--ROLLBACK TRANSACTION TranWorkItem
		SELECT 	Status = 15
		RETURN
	END*/
	IF LEN(@InsertExtColumnStr) > 0 AND LEN(@TableViewName) > 0
	BEGIN TRY
		IF @EXTColumnList1 IS NULL /** This check is sufficient as its not possible that @EXTColumnList1 is null and @EXTColumnList2 is not null. */
		BEGIN
			SELECT @InsertExtColumnStr = SUBSTRING(@InsertExtColumnStr,2, 1024)
			SELECT @InsertExtValueStr  = SUBSTRING(@InsertExtValueStr, 2, 1024)
		END
		EXECUTE('INSERT INTO ' + @TableViewName + ' ( ' + @EXTColumnList1 + @EXTColumnList2 + @EXTColumnList3 + @InsertExtColumnStr + ' ) VALUES ( ' + @EXTValueList1 + @EXTValueList2 + @EXTValueList3 + @InsertExtValueStr + ' ) ')
	END TRY
	BEGIN CATCH
		BEGIN
			select status = 4012,
			DBMsg = ERROR_MESSAGE(),
			DBTblNm =@TableViewName
			RETURN
		END
	END CATCH


	/* ______________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-4, Optimizations in UploadWorkitem to add messages in place
	                 of insert record in CurrentRouteLogTable and SummaryTable
	// ____________________________________________________________________________________*/
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	/*Changes for Bug 50438 - WI properties showing 2 start Events--ActivityId should not be 0 in Message xml*/
		/*Changes for Bug 50438 - WI properties showing 2 start Events--ActivityId should not be 0 here*/
	EXECUTE WFGenerateLog 1, @DBUserId, @DBProcessDefId, @ActivityId, @QueueId, @UserName, @ActivityName, 0, @ProcessInstanceId, @QueueId, null, 1,  0, 0, null, @DBProcessVariantId, 0 , 0, @UrnDup,NULL, @v_MainCode OUT
	IF(@v_MainCode <> 0) /* WFS_5_169 */
	BEGIN
		--ROLLBACK TRANSACTION TranWorkItem
		SELECT 	Status = @v_MainCode
		RETURN
	END
	/*Insert Data into WFCurrentRouteLogTable For ActionId = 75 and WFAttributeMessageTable for the actual data being set*/
	IF(@DBSetAttributeLoggingEnabled = 'Y' AND @DBRouteLogList1 IS NOT NULL )
	BEGIN
		--Insert data into WFAttributeMessageTable
		Insert into WFAttriButeMessageTable (ProcessDefId,ProcessInstanceId,WorkitemId,message, status, ActionDateTime) Values (@DBProcessDefId,@ProcessInstanceId,1,
		@RouteLogList1 + @RouteLogList2 + @RouteLogList3 + @RouteLogList4 + @RouteLogList5 + @RouteLogList6 + @RouteLogList7 + @RouteLogList8,N'N',GETDATE())
		
		SELECT @fieldId = @@IDENTITY
		
		EXECUTE WFGenerateLog 75, @DBUserId, @DBProcessDefId, @ActivityId, 0, @UserName, @ActivityName, 0, @ProcessInstanceId, @fieldId, null, 1,  0, 0, null, 0, 0, 0 , @UrnDup,NULL, @v_MainCode OUT
	END
	/*INSERT INTO WFMessageTable (message, status, ActionDateTime) VALUES ('<Message><ActionId>16</ActionId><UserId>' + convert(varchar,@DBUserId) +	'</UserId><ProcessDefId>' + convert(varchar,@DBProcessDefId) + '</ProcessDefId><ActivityId>' + convert(varchar,@ActivityId) + '</ActivityId><QueueId>0</QueueId><UserName>' + @UserName + '</UserName><ActivityName>' + @ActivityName + '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'	+ convert(varchar(22), getDate(), 20) + '</ActionDateTime><EngineName></EngineName><ProcessInstance>' + @ProcessInstanceId + '</ProcessInstance><FieldId>0</FieldId><FieldName><Attributes>' + @RouteLogList1 + 
	@RouteLogList2 + @RouteLogList3 + @RouteLogList4 + @RouteLogList5 + @RouteLogList6 + @RouteLogList7 + @RouteLogList8 + '</Attributes></FieldName><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>', N'N', GETDATE())*/

      /* ______________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-4, Optimizations in UploadWorkitem to add messages in place
	                 of insert record in CurrentRouteLogTable and SummaryTable
	// ____________________________________________________________________________________*/
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	/* ______________________________________________________________________________________
		// Changed On  : 25/07/2007
		// Changed By  : Tirupati Srivastava
		// Description : IF-ELSE added.Bugzilla Id 1447
		// ____________________________________________________________________________________*/
	IF @DBInitiateAlso = N'Y' AND @DBSynchronousRouting != N'Y'
	BEGIN
		Select @DBTotalDuration = Datediff(ss, createdDateTime, getDate()),@DBTotalPrTime = Datediff(ss, lockedTime, getDate())
		from WFINSTRUMENTTABLE (NOLOCK)
		where processInstanceId = @ProcessInstanceId
		AND RoutingStatus = 'Y' 
		AND LockStatus = 'N'
		
		EXECUTE WFGenerateLog 2, @DBUserId, @DBProcessDefId, @ActivityId, @QueueId, @UserName, @ActivityName, 0, @ProcessInstanceId, @QueueId, null, 1,  0, 0, null, @DBProcessVariantId, 0 , 0, @UrnDup, NULL,@v_MainCode OUT

		IF(@v_MainCode <> 0) /* WFS_5_169 */
		BEGIN
			--ROLLBACK TRANSACTION TranWorkItem
			SELECT 	Status = @v_MainCode
			RETURN
		END
	END
	SELECT @DBStatus = 0
	IF (@ValidataionReqd IS NOT NULL AND @ValidateQuery IS NOT NULL AND LEN(@ValidateQuery) > 0 )
	BEGIN
		EXECUTE ( @ValidateQuery)
		SELECT @DBStatus = @@ERROR
		IF @DBStatus <> 0
		BEGIN
			--ROLLBACK TRANSACTION TranWorkItem
			SELECT 	Status = 15
			RETURN
		END
	END 

--	COMMIT TRANSACTION TranWorkItem
	SELECT 	Status 		= @DBStatus,
		DBFolderName 	= @DBFolderName,
		CurrDate	= @CurrDate,
		FolderIndex = @NewFolderIndex, /* Bugzilla Bug 265 - FolderIndex returned */
		DocumentIndexes = @DocumentIndexes
~

Print 'Stored Procedure WFUploadWorkItem compiled successfully ........'
