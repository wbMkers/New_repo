/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application �Products
	Product / Project		: WorkFlow 5.0.1
	Module				: Transaction Server
	File Name			: WFGetWorkitemData.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 02/09/2005
	Description			: Returns the workitem data [Bug # WFS_5_066].
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
 29/09/2005	Ruhi Hira		Bug # WFS_5_069.
 20/10/2005	Harmeet Kaur		WFS_5_074 - Sr No. 1 - Document Order and Sort Order for GetDocumentList 						configurable
 24/10/2005	Harmeet Kaur		WFS_5_075 - Sr No. 2 - Object Type in Preferences configurable
 16/02/2006	Sumit Aggarwal		WFS_5_104	Comment Field is required from pdbdocument table in wfgetworkitemdataext call
 13/04/2006	Harmeet Kaur		WFS_5_117 - Document Size to be fetched in GetDocumentList
 30/01/2007	Umesh Sehgal		WFS_5_157 Opening workitem on custom workstep gives error:"numeric value error"
 24/05/2007	Ruhi Hira		    Bugzilla Bug 945.
 13/09/2007	Varun Bhansaly		SrNo-1, All data related to Comments 
 14/12/2007	Varun Bhansaly		(NOLOCK) added to Query on WFCommentsTable and Ordering of operands in Where condition changed
 17/03/2008	Shweta Tyagi		Bugzilla bug 3919 return new tag ownerindex in WFGetWorkitemDataExt
 14/06/2008	Ishu Saraf		    Bugzilla bug 5091 returning more than one rows because of complex type structure
 03/07/2008	Ishu Saraf		    Bugzilla Bug 5426, 5493
 26/08/2008	Varun Bhansaly		SrNo-2, Complex type support. Donot query QueueDataTable/ QueueHistoryTable/ External Table
 05/11/2008	Ashish Mangla		Bugzilla Bug 6893 (1 less resultset returns in case var_rec_1 is null, bean treats resultset6 as resultset5 and so on)
 19/04/2010	Saurabh Kamal		Bugzilla Bug 12114, Exception Sequence should be in order of ActionDateTime instead of ActionId
 10/11/2010  Saurabh Sinha      Bug #815 : Support for Previous Next in Introduction,FIFO and WIP
 18/07/2012	Abhishek Gupta		Bug 33200 and 30984 : RevisedDateTime returned in Document information.
 22/12/2013 Kahkeshan			Code Optimization Changes
 05/05/2015	Mohnish Chopra		Changes for Case Management - New parameters DBTaskId and DBSubTaskId added and 
								returning task specific data in ResultSet 8
11/08/2015	Mohnish Chopra		Changes for Data Locking issue in Case Management -Returning ActivityType and LastModifiedTime
18/08/2015	Mohnish Chopra		Changes for Case View in Case Management -Returning InitiatedBy and InitiatedOn 
05-05-2017	Sajid Khan			Merging Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
02-08-2017	Shubhankur Manuja		Merging Bug - 70260 - NOLOCK Missing with WFCommentsTable in a query while opening workitem
18/09/2017    Kumar Kimil       Tasktype and TaskMode added in Output of WFGetWorkitemDataExt
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
---------------------------------------------------------------------------------------------------*/


If Exists (Select * from SysObjects (NOLOCK) Where xType = 'P' and name = 'WFGetWorkitemData')
Begin
	Execute('DROP PROCEDURE WFGetWorkitemData')
	Print 'Procedure WFGetWorkitemData already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFGetWorkitemData(
	@DBProcessInstanceId		NVarchar(64),
	@DBWorkItemId			Integer,
	@DBProcessDefId			Integer,
	@DBActivityId			Integer,
	@DBUserIndex			Integer,
	@DBDocumentOrderBy		NVarchar(510) = 'Name',		/* Sr No. 1 */
	@DBDocumentSortOrder		Char(4)	= 'ASC',		/* Sr No. 1 */
	@DBObjectPreferenceList		NVarchar(25) = '''W'' , ''D''',	/* Sr No. 2 */
	@DBISSharePoint			NVarchar(1),
	@DBTaskId				Integer,
	@DBSubTaskId			Integer
)
AS
Begin
	/* Declaration of queue variables */

	SET NOCOUNT ON

	Declare @extTableName		NVarchar(256)	  /* Bugzilla Bug 5426, 5493 */
	
	Declare @ReferByName		NVarchar(30)
	Declare @ReferTo		INT
	Declare @CheckListCompleteFlag	NVarchar(1)
	Declare @HoldStatus		INT
	Declare @InstrumentStatus	NVarchar(1)
	Declare @ParentWorkItemID	INT
	Declare @ProcessInstanceId	NVARCHAR(63)
	Declare @SaveStage		NVARCHAR(30)
	Declare @Status			NVARCHAR(255)
	Declare @VAR_DATE1		DATETIME /* Bug #815 */
	Declare @VAR_DATE2 		DATETIME
	Declare @VAR_DATE3 		DATETIME
	Declare @VAR_DATE4 		DATETIME
	Declare @VAR_DATE5 		DATETIME
	Declare @VAR_DATE6 		DATETIME
	Declare @VAR_FLOAT1		NUMERIC(15, 2)
	Declare @VAR_FLOAT2		NUMERIC(15, 2)
	Declare @VAR_INT1		Smallint 
	Declare @VAR_INT2		Smallint 
	Declare @VAR_INT3		Smallint 
	Declare @VAR_INT4		Smallint 
	Declare @VAR_INT5		Smallint 
	Declare @VAR_INT6		Smallint 
	Declare @VAR_INT7		Smallint 
	Declare @VAR_INT8		Smallint 
	Declare @VAR_LONG1		INT
	Declare @VAR_LONG2		INT
	Declare @VAR_LONG3		INT
	Declare @VAR_LONG4		INT
	Declare @VAR_LONG5		INT
	Declare @VAR_LONG6		INT
	Declare @VAR_REC_1		NVARCHAR(255)
	Declare @VAR_REC_2		NVARCHAR(255)
	Declare @VAR_REC_3		NVARCHAR(255)
	Declare @VAR_REC_4		NVARCHAR(255)
	Declare @VAR_REC_5		NVARCHAR(255)
	Declare @VAR_STR1		NVARCHAR(255)
	Declare @VAR_STR2		NVARCHAR(255)
	Declare @VAR_STR3		NVARCHAR(255)
	Declare @VAR_STR4		NVARCHAR(255)
	Declare @VAR_STR5		NVARCHAR(255)
	Declare @VAR_STR6		NVARCHAR(255)
	Declare @VAR_STR7		NVARCHAR(255)
	Declare @VAR_STR8		NVARCHAR(255)
	Declare @VAR_STR9		NVARCHAR(255)
	Declare @VAR_STR10		NVARCHAR(255)
	Declare @VAR_STR11		NVARCHAR(255)
	Declare @VAR_STR12		NVARCHAR(255)
	Declare @VAR_STR13		NVARCHAR(255)
	Declare @VAR_STR14		NVARCHAR(255)
	Declare @VAR_STR15		NVARCHAR(255)
	Declare @VAR_STR16		NVARCHAR(255)
	Declare @VAR_STR17		NVARCHAR(255)
	Declare @VAR_STR18		NVARCHAR(255)
	Declare @VAR_STR19		NVARCHAR(255)
	Declare @VAR_STR20		NVARCHAR(255)
	Declare @v_ImageCabName	NVARCHAR(100)

	Declare @queryStr		NVARCHAR(1000)

	/* Declaration of process variables */

	Declare @CreatedByName		NVARCHAR(63)
	Declare @CreatedDatetime	DATETIME
	Declare @Introducedby		NVARCHAR(63)
	Declare @IntroductionDateTime	DATETIME
	Declare @ProcessInstanceState 	INT
	Declare @ExpectedProcessDelay   DATETIME
	Declare	@ActivityType 			INT
	Declare	@LastModifiedTime		DATETIME


	/*Document Order supported only on fields - Name, RevisedDateTime, DocumentSize, CreatedByApplication, Name, NoOfPages, Owner, DocumentOrderNo) */
	/* Begin Sr No. 1 */
	IF NOT ((UPPER(@DBDocumentOrderBy) = UPPER('Name')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('RevisedDateTime')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('DocumentSize')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('CreatedByApplication')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('NoOfPages')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('Owner')) OR (UPPER(LTRIM(RTRIM(@DBDocumentOrderBy))) = UPPER('DocumentOrderNo')))
	BEGIN	
		SELECT @DBDocumentOrderBy = 'Name'		
	END


	/* End Sr No. 1 */

	/* For inermmediate results */
	/*WFS_5_157*/
	Declare @objectName		NVarchar(255)
	IF (@DBTaskId >0) 
	BEGIN
	Select	@objectName	= convert(NVarchar(4), @DBProcessDefId) + '@' + convert(NVarchar(4), @DBActivityId)+'#'+ convert(NVarchar(4), @DBTaskId)
	END
	ELSE
	BEGIN
	Select	@objectName	= convert(NVarchar(4), @DBProcessDefId) + '@' + convert(NVarchar(4), @DBActivityId)
	END 
	/* OUTPUT : ResultSet1 -> User Preferences */
	

/*	Select ObjectId, ObjectName, ObjectType, NotifyByEmail, Data 
	From	UserPreferencesTable (NOLOCK)
	Where	userId	= @DBUserIndex 
	AND	ObjectName = @objectName 
	AND	ObjectType in (@DBObjectPreferenceList) */
	
	/* For intermmediate results */

	/* Begin Sr No. 2 */	
	Declare @tempUserIndex		NVarchar(10)

	Select @tempUserIndex = convert(NVarchar(10), @DBUserIndex)

	Select @queryStr = ' Select ObjectId, ObjectName, ObjectType, NotifyByEmail, Data ' +
			' From	UserPreferencesTable (NOLOCK) ' +
			' Where	userId	= ' + @tempUserIndex +
			' AND	ObjectName =  ''' + @objectName +
			''' AND	ObjectType in ( ' + @DBObjectPreferenceList + ' )' 

	Execute (@queryStr)
	/* End Sr No. 2 */	

	Select  @ReferByName		= ReferredByName,
		@ReferTo		= ReferredTo,
		@CheckListCompleteFlag	= CheckListCompleteFlag, 
		@HoldStatus		= HoldStatus, 
		@InstrumentStatus	= InstrumentStatus, 
		@ParentWorkItemID	= ParentWorkItemID,
		@ProcessInstanceId	= ProcessInstanceId, 
		@SaveStage		= SaveStage, 
		@Status			= Status,
		@VAR_DATE1		= VAR_DATE1, /* Bug #815 */
		@VAR_DATE2		= VAR_DATE2, 
		@VAR_DATE3		= VAR_DATE3, 
		@VAR_DATE4		= VAR_DATE4,
		@VAR_DATE5		= VAR_DATE5,
		@VAR_DATE6		= VAR_DATE6,
		@VAR_FLOAT1		= VAR_FLOAT1,
		@VAR_FLOAT2		= VAR_FLOAT2, 
		@VAR_INT1		= VAR_INT1, 
		@VAR_INT2		= VAR_INT2, 
		@VAR_INT3		= VAR_INT3,
		@VAR_INT4		= VAR_INT4, 
		@VAR_INT5		= VAR_INT5, 
		@VAR_INT6		= VAR_INT6, 
		@VAR_INT7		= VAR_INT7,
		@VAR_INT8		= VAR_INT8, 
		@VAR_LONG1		= VAR_LONG1, 
		@VAR_LONG2		= VAR_LONG2, 
		@VAR_LONG3		= VAR_LONG3,
		@VAR_LONG4		= VAR_LONG4,
		@VAR_LONG5		= VAR_LONG5,
		@VAR_LONG6		= VAR_LONG6,
		@VAR_REC_1		= VAR_REC_1, 
		@VAR_REC_2		= VAR_REC_2, 
		@VAR_REC_3		= VAR_REC_3,
		@VAR_REC_4		= VAR_REC_4, 
		@VAR_REC_5		= VAR_REC_5, 
		@VAR_STR1		= VAR_STR1, 
		@VAR_STR2		= VAR_STR2,
		@VAR_STR3		= VAR_STR3, 
		@VAR_STR4		= VAR_STR4, 
		@VAR_STR5		= VAR_STR5, 
		@VAR_STR6		= VAR_STR6,
		@VAR_STR7		= VAR_STR7, 
		@VAR_STR8		= VAR_STR8,
		@VAR_STR9		= VAR_STR9,
		@VAR_STR10		= VAR_STR10,
		@VAR_STR11		= VAR_STR11,
		@VAR_STR12		= VAR_STR12,
		@VAR_STR13		= VAR_STR13,
		@VAR_STR14		= VAR_STR14,
		@VAR_STR15		= VAR_STR15,
		@VAR_STR16		= VAR_STR16,
		@VAR_STR17		= VAR_STR17,
		@VAR_STR18		= VAR_STR18,
		@VAR_STR19		= VAR_STR19,
		@VAR_STR20		= VAR_STR20,
		@CreatedByName		= CreatedByName, 
		@Createddatetime	= Createddatetime, 
		@ExpectedProcessDelay	= ExpectedProcessDelay, 
		@Introducedby		= Introducedby, 
		@IntroductionDatetime	= IntroductionDatetime, 
		@ProcessInstanceState	= ProcessInstanceState,
		@ActivityType 			= ActivityType,
		@LastModifiedTime		= LastModifiedTime
	From	WFInstrumentTable (NOLOCK)
	Where	ProcessInstanceId	= @DBProcessInstanceId
	And	WorkitemId		= @DBWorkitemId
	
	
	If (@@rowcount <= 0)
	Begin
		Select  @ReferByName		= ReferredByName,
			@ReferTo		= ReferredTo,
			@CheckListCompleteFlag	= CheckListCompleteFlag, 
			@HoldStatus		= HoldStatus, 
			@InstrumentStatus	= InstrumentStatus, 
			@ParentWorkItemID	= ParentWorkItemID,
			@ProcessInstanceId	= ProcessInstanceId, 
			@SaveStage		= SaveStage, 
			@Status			= Status, 
			@VAR_DATE1		= VAR_DATE1, /* Bug #815 */
			@VAR_DATE2		= VAR_DATE2, 
			@VAR_DATE3		= VAR_DATE3, 
			@VAR_DATE4		= VAR_DATE4,
			@VAR_DATE5		= VAR_DATE5,
			@VAR_DATE6		= VAR_DATE6,
			@VAR_FLOAT1		= VAR_FLOAT1,
			@VAR_FLOAT2		= VAR_FLOAT2, 
			@VAR_INT1		= VAR_INT1, 
			@VAR_INT2		= VAR_INT2, 
			@VAR_INT3		= VAR_INT3,
			@VAR_INT4		= VAR_INT4, 
			@VAR_INT5		= VAR_INT5, 
			@VAR_INT6		= VAR_INT6, 
			@VAR_INT7		= VAR_INT7,
			@VAR_INT8		= VAR_INT8, 
			@VAR_LONG1		= VAR_LONG1, 
			@VAR_LONG2		= VAR_LONG2, 
			@VAR_LONG3		= VAR_LONG3,
			@VAR_LONG4		= VAR_LONG4,
			@VAR_LONG5		= VAR_LONG5,
			@VAR_LONG6		= VAR_LONG6,			
			@VAR_REC_1		= VAR_REC_1, 
			@VAR_REC_2		= VAR_REC_2, 
			@VAR_REC_3		= VAR_REC_3,
			@VAR_REC_4		= VAR_REC_4, 
			@VAR_REC_5		= VAR_REC_5, 
			@VAR_STR1		= VAR_STR1, 
			@VAR_STR2		= VAR_STR2,
			@VAR_STR3		= VAR_STR3, 
			@VAR_STR4		= VAR_STR4, 
			@VAR_STR5		= VAR_STR5, 
			@VAR_STR6		= VAR_STR6,
			@VAR_STR7		= VAR_STR7, 
			@VAR_STR8		= VAR_STR8,
			@VAR_STR9		= VAR_STR9,
			@VAR_STR10		= VAR_STR10,
			@VAR_STR11		= VAR_STR11,
			@VAR_STR12		= VAR_STR12,
			@VAR_STR13		= VAR_STR13,
			@VAR_STR14		= VAR_STR14,
			@VAR_STR15		= VAR_STR15,
			@VAR_STR16		= VAR_STR16,
			@VAR_STR17		= VAR_STR17,
			@VAR_STR18		= VAR_STR18,
			@VAR_STR19		= VAR_STR19,
			@VAR_STR20		= VAR_STR20,
			@CreatedByName		= CreatedByName, 
			@Createddatetime	= Createddatetime, 
			@ExpectedProcessDelay	= NULL, 
			@Introducedby		= Introducedby, 
			@IntroductionDatetime	= IntroductionDatetime, 
			@ProcessInstanceState	= ProcessInstanceState,
			@ActivityType 			= ActivityType,
			@LastModifiedTime		= LastModifiedTime,
			@v_ImageCabName			= ImageCabName
		From	QueueHistoryTable (NOLOCK)
		Where	ProcessInstanceId	= @DBProcessInstanceId
		And	WorkitemId		= @DBWorkitemId 	

		/* OUTPUT : ResultSet2 -> Process variables */

		/*Select  @CreatedByName		  CreatedByName, 
			@ExpectedProcessDelay	  ExpectedProcessDelay, 
			@Introducedby		  Introducedby, 
			@IntroductionDatetime	  IntroductionDatetime, 
			@ProcessInstanceState	  ProcessInstanceState */

	End
	/* Else
	Begin
		OUTPUT : ResultSet2 -> Process variables 
		
		Select	CreatedByName, ExpectedProcessDelay, Introducedby, IntroductionDatetime, ProcessInstanceState
		From	ProcessInstanceTable (NOLOCK) 
		Where	processInstanceId	= @DBProcessInstanceId 
	End */
	
	/* Process variables fetched from WFInstrumentTable / QueueHistory Table */
	Select  @CreatedByName		  CreatedByName, 
			@ExpectedProcessDelay	  ExpectedProcessDelay, 
			@Introducedby		  Introducedby, 
			@IntroductionDatetime	  IntroductionDatetime, 
			@ProcessInstanceState	  ProcessInstanceState,
			@v_ImageCabName			ImageCabName
	
	/* OUTPUT : ResultSet3 -> Queue Variables FROM WFInstrumentTable / QueueHistoryTable */

	Select	@ReferByName	 ReferredByName,
		@ReferTo	  ReferredTo,
		@CheckListCompleteFlag	 CheckListCompleteFlag, 
		@HoldStatus		  HoldStatus, 
		@InstrumentStatus	  InstrumentStatus, 
		@ParentWorkItemID	  ParentWorkItemID,
		@ProcessInstanceId	  ProcessInstanceId, 
		@SaveStage		  SaveStage, 
		@Status			  Status, 
		@ActivityType 	  ActivityType,
		@LastModifiedTime LastModifiedTime,
		@VAR_DATE1		  VAR_DATE1, /* Bug #815 */
		@VAR_DATE2		  VAR_DATE2, 
		@VAR_DATE3		  VAR_DATE3,	
		@VAR_DATE4		  VAR_DATE4,
		@VAR_DATE5		  VAR_DATE5,
		@VAR_DATE6		  VAR_DATE6,
		@VAR_FLOAT1		  VAR_FLOAT1,
		@VAR_FLOAT2		  VAR_FLOAT2, 
		@VAR_INT1		  VAR_INT1, 
		@VAR_INT2		  VAR_INT2, 
		@VAR_INT3		  VAR_INT3,
		@VAR_INT4		  VAR_INT4, 
		@VAR_INT5		  VAR_INT5, 
		@VAR_INT6		  VAR_INT6, 
		@VAR_INT7		  VAR_INT7,
		@VAR_INT8		  VAR_INT8, 
		@VAR_LONG1		  VAR_LONG1, 
		@VAR_LONG2		  VAR_LONG2, 
		@VAR_LONG3		  VAR_LONG3,
		@VAR_LONG4		  VAR_LONG4,
		@VAR_LONG5		  VAR_LONG5,
		@VAR_LONG6		  VAR_LONG6,
		@VAR_REC_1		  VAR_REC_1, 
		@VAR_REC_2		  VAR_REC_2, 
		@VAR_REC_3		  VAR_REC_3,
		@VAR_REC_4		  VAR_REC_4, 
		@VAR_REC_5		  VAR_REC_5, 
		@VAR_STR1		  VAR_STR1, 
		@VAR_STR2		  VAR_STR2,
		@VAR_STR3		  VAR_STR3, 
		@VAR_STR4		  VAR_STR4, 
		@VAR_STR5		  VAR_STR5, 
		@VAR_STR6		  VAR_STR6,
		@VAR_STR7		  VAR_STR7, 
		@VAR_STR8		  VAR_STR8,
		@VAR_STR9		  VAR_STR9,
		@VAR_STR10		  VAR_STR10,
		@VAR_STR11		  VAR_STR11,
		@VAR_STR12		  VAR_STR12,
		@VAR_STR13		  VAR_STR13,
		@VAR_STR14		  VAR_STR14,
		@VAR_STR15		  VAR_STR15,
		@VAR_STR16		  VAR_STR16,
		@VAR_STR17		  VAR_STR17,
		@VAR_STR18		  VAR_STR18,
		@VAR_STR19		  VAR_STR19,
		@VAR_STR20		  VAR_STR20
	/* OUTPUT : ResultSet4 -> Documents */

	/* Bug # WFS_5_069, Case specific to IGATE, when processInstance is not having any folder 
			that time ItemIndex contains processInstanceId and ItemType = 'N' inplace of 'F' - Ruhi Hira */
	
	IF(@DBISSharePoint = N'N')
	BEGIN
		Select @queryStr = ' ' 	
		Select @queryStr = 'Select PDBDocument.DocumentIndex DocumentIndex, VersionNumber, Name, Owner, ' + /*bug 3919*/
				' CreatedDateTime, Comment, AppName CreatedByApplication, ImageIndex, ' +
				' VolumeId, DocumentType, CheckoutStatus, ' +
				' CheckoutByUser, NoOfPages, DocumentSize, RevisedDateTime' + /* WFS_5_117 */
				' From PDBDocument (NOLOCK) Inner Join PDBDocumentContent (NOLOCK) ' +
				' ON PDBDocument.documentIndex	= PDBDocumentContent.documentIndex ' +
				' AND parentFolderIndex	= ' + ISNULL(@VAR_REC_1, '-9999') +			 
				' AND ''' + @VAR_REC_2 + ''' = ''F''' +
				' ORDER BY ' + @DBDocumentOrderBy +
				' ' + @DBDocumentSortOrder			/* Sr No. 1 */

		EXEC (@queryStr)
	END


/*	 OUTPUT : ResultSet5 -> ToDo items*/

	Select	ToDoValue 
	FROM	ToDoStatusView (NOLOCK) 
	WHERE	ProcessInstanceid = @DBProcessInstanceId

	/* OUTPUT : ResultSet6 -> ToDo items*/

	SELECT	ExceptionId, excpseqid, ActionId, 
		activitytable.ActivityName ActivityName, UserName, ActionDateTime, 
		ExceptionName, ExceptionComments, FinalizationStatus
	FROM	exceptionview (NOLOCK) , activitytable (NOLOCK) 
	WHERE	exceptionview.processdefid	= @DBProcessDefId
	AND	activitytable.activityId	= exceptionview.activityId
	AND	activitytable.ProcessDefId	= exceptionview.ProcessDefId
	AND	processinstanceid		= @DBProcessInstanceId
	ORDER BY exceptionid, excpseqid, ActionDateTime ASC

	/* OUTPUT : ResultSet7 -> Comments Data */
	/*Execute ('Select Comments, CommentsBy, CommentsByName, CommentsTo, CommentsToName, CommentsType, ActionDateTime From WFCommentsTable (NOLOCK) Where ProcessInstanceId = N''' +  @DBProcessInstanceId + ''' and ActivityId = ' + @DBActivityId + ' Order By CommentsId DESC')*/
	
	Execute ('Select WFCOMMENTSVIEW.Comments, WFCOMMENTSVIEW.CommentsBy, WFCOMMENTSVIEW.CommentsByName, WFCOMMENTSVIEW.CommentsTo, WFCOMMENTSVIEW.CommentsToName, WFCOMMENTSVIEW.CommentsType, WFCOMMENTSVIEW.ActionDateTime, ActivityTable.ActivityName From WFCOMMENTSVIEW (NOLOCK) , ActivityTable (NOLOCK) Where WFCOMMENTSVIEW.ProcessDefId = ActivityTable.ProcessDefId AND WFCOMMENTSVIEW.ActivityId = ActivityTable.ActivityId AND WFCOMMENTSVIEW.ProcessInstanceId = N''' +  @DBProcessInstanceId + ''' Order By WFCOMMENTSVIEW.CommentsId DESC')
	/* OUTPUT : ResultSet8 -> Task Data */
	IF (@DBTaskId >0) 
	BEGIN
		Select AssignedBy,ActionDateTime,AssignedTo, duedate,TaskType,TaskMode
		from WFTaskStatusTable S(NOLOCK) INNER JOIN WFTaskDefTable T (NOLOCK) 
		on processinstanceid		= @DBProcessInstanceId
		and workitemid = @DBWorkItemId
		and activityid= @DBActivityId
		and S.taskid = @DBTaskId
		and subtaskid = @DBSubTaskId
		and T.taskid=S.Taskid
		and T.ProcessDefId=S.ProcessDefId
	END 
	
End
~

Print 'Stored Procedure WFGetWorkitemData compiled successfully ........'