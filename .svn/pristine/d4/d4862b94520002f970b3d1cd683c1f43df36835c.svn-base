/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application –Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFGetWorkitem.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 03/09/2005
	Description			: To lock the workitem and return the data [Bug # WFS_5_066].
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
26/09/2005	Ruhi Hira			Bug # WFS_5_067.
27/09/2005	Dinesh PArikh		Bug # WFS_5_068
16/11/2005	Ruhi Hira			Bug # WFS_5_077.
05/04/2006	Harmeet Kaur		Bug # WFS_5_115
10/04/2006	Harmeet Kaur		Bug # WFS_5_116
14/04/2006	Harmeet Kaur		WFS_5_113 Optimization for PCS
15/05/2006	Harmeet Kaur		WFS_5_121 - Open WIs in modify mode in search for WIs having filteroption=1
26/07/2006	Harmeet Kaur		WFS_5_127 Support for QueryFilter
01/08/2006	Harmeet Kaur		WFS_5_131 Sorting order changed for FIFO Queue
22/11/2006	Ruhi Hira			Bug # WFS_5_148.
27/12/2006	Ruhi Hira			Bug # WFS_5_149.
23/05/2007	Ashish Mangla		Bugzilla Bug 758, Bugzilla Bug 773, Bugzilla Bug 856, Bugzilla Bug 825
24/05/2007	Ruhi Hira			Bugzilla Bug 945.
20/06/2007	Ashish Mangla		Bugzilla Bug 1200 (In case of FIFO also, IF WI is not locked, try lock it also)
19/07/2007	Varun Bhansaly		Bugzilla Id 74 (Inconsistency in date-time)
17/09/2007	Varun Bhansaly		SrNo-1, Support for Complex filters and Generic Queue Filter.
08/01/2008	Ashish Mangla		Bugzilla Bug 1681 (UserName Marco support required)
16/01/2008	Varun Bhansaly		Support for Order By in Filters.
21/01/2008	Ruhi Hira			Bugzilla Bug 1721, error code 810.
22/01/2008	Ruhi Hira			Bugzilla Bug 3580, Unable to open fixed assigned workitems from search.
24/01/2008	Varun Bhansaly		Bugzilla Id 3584, orderby filter in fifo queue is not working properly
25/02/2008	Varun Bhansaly		Performance Optimization - Inherited from PRD Bug Solution WFS_5_212
17/03/2008	Ashish Mangla		Bugzilla Bug 3962 (In case of FIFO, UpdLock should be applied when selecting from workListtable)
30/04/2008	Sirish Gupta		Bugzilla Bug 4651.
16/12/2008	Ruhi Hira			Bugzilla Bug 7199, MainCode changed to Invalid_Workitem.
08/09/2009	Vikas Saraswat		WFS_8.0_031	Option  provided to view the workitem of a queue as read-only based on the rights of the queue for non-associated user instead of Query workstep rights.
06/10/2009	Preeti Awasthi		WFS_8.0_040 Support for filter using queue variables/aliases on Queue is No Assignment Type.	
28/10/2009	Saurabh Kamal		WFS_8.0_046 (In case user is member of multiple groups which are added to Queue, One group having no filter, then user should be able to view workitems considering no filter)
30/11/2009	Vikas Saraswat		WFS_8.0_066 LoggingFlag should be used in message for ActionID=200
11/12/2009	Preeti Awasthi		WFS_8.0_069 Workitem gets locked even user does not have rights on queue and workitem is opened from search in readonly mode.
27/01/2010	Preeti Awasthi		WFS_8.0_079 Participant tag is not coming in WFGetWorkitem API
10/11/2010  Saurabh Sinha       Bug #815 : Support for Previous Next in Introduction,FIFO and WIP
11/05/2010	Preeti Awasthi		WFS_8.0_101 Error “User not authorized to view workitem” in case user do not have rights on queue and group filter is set on queue
04/08/2010	Indraneel			WFS_8.0_121: Filter criteria applied by using query workstep should give the preference to the associated users rather than associated group.
11/11/2010	Preeti Awasthi		WFS_8.0_143: Error in opening workitem through search when aliases are present on queue for external variables
08/03/2010	Saurabh Kamal		WFS_8.0_153 Support of FUNCTION in QueryFilter
04/01/2011	Abhishek Gupta		WFS_8.0_147: User filter overridden by group filter if user filter blank.
01/07/2011	Saurabh Kamal		Bug 27393, In case of FIFO Queue, if a user is working on a workitem then it should get permanently assigned to the same user(Fixed Assignment).
11/01/2012	Preeti Awasthi		Bug 30420 - Issue in Getting next workitem in case of FIFO type queue
21/03/2012	Vikas Saraswat		Bug 30800 - sorting is not working on Prev next click after opening the workitem
10/04/2012	Preeti Awasthi		Bug 31025 - Filter on external variables is not working while opening workitems.
19/04/2012  Shweta Singhal		Bug 30894, Error while opening workitem.
04/01/2011	Abhishek Gupta		Bug 34307 - properties can not be verified because some data in property tab is incorrect[LockedTime not set in WorkInProcessTable].
17/05/2013	Shweta Singhal		Process Variant Support Changes	
23/12/2013	Sajid Khan			Message Agent Optiization.
31/12/2013	Kahkeshan			Code Optimization Changes
27/01/2014	Shweta Singhal		Left Outer Join is replaced with Inner Join	
28/01/2014	Shweta Singhal		UPDLock replaced with UPDLock, READPAST
02/06/2014	Anwar Danish		PRD Bug 43293 merged - Invalid column name ExpectedWorkItemDelay was displayed while clicking next button in webdesktop on a Queue at which a Filter on System variable ExpectedWorkItemDelay Alias is set. 
13/06/2014  Anwar Ali Danish    PRD Bug 38828 merged - Changes done for diversion requirement. CQRId CSCQR-00000000050705-Process  
20/08/2015	Mohnish Chopra		Changes for Case management -Returning error code 32 (By Pass Lock) for all tasks. By passing lock requirement in Task View 
06/11/2015	Mohnish Chopra		Changes for Case management -Can Initiate requirement 
27/11/2015	Mohnish Chopra		Bug 57980 - Jboss EAP : "Case modified by other user" message showing while changing value in case data
02/12/2015	Mohnish Chopra		Bug 58014 - show case visualization check box during assigning a task is not working according to specification
17/02/2017  RishiRam Meel		Changes done Handling for restricting FIFO workitem from opening in modify mode if fetched through advanced search by supplying queue name 	
05/04/2017	Sajid Khan			Bug 68080 - Error in execution of WFGetWorkitem if a function filter is applied in the queue filter provided no User or Group 	filter is applied.[MS SQL]
30/04/2017	Sajid Khan			Verious Bugs regarding Queue Filter and Query Filter solved.
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
03/08/2017		Kumar Kimil     	Bug 70043 - Entry for action id 200 is getting inserted while performing the reassign operation from webdesktop
03/08/2017	Sajid Khan			Bug 70870 - Unable to Temporary Unhold a workitme which was temporarily holded from FIFO type of Queue
16-08-2017	Mohnish Chopra		Changes for Case Management - Queue variable header alias should allow spaces
17/10/2017	Mohnish Chopra		Case registeration Name changes requirement- Added URN in output of WFGetWorkItemDataExt API
02-11-2017	Shubhankur Manuja	Bug Merging - 70858
16-01-18	Ambuj Tripathi		Bug 73224 - The variable size which is used to hold user name should be sufficient
28-01-18	Sajid Khan			Bug 75488 -Arabic ibps 4: Getting error on creating new WI or while opening existing WI after creating aliases in Arabic 
06/04/2018  Kumar Kimil         Prev-Next Unlock Fixes
23/04/2018	Ambuj Tripathi		Bug 76864 - Getting error in WFGetWorkitem if filter length is too large - increased the variables lengths to max.
12/09/2018	Ambuj Tripathi		PRDP merging - Bug 80103 - WFGetWorkitem procedure gets hang if function filter returns null
29/03/2019 Ravi Ranjan Kumar   Bug 83885 - When workitem is present in myqueue and locked by me then other user able to open in read only mode if user does not have any rights
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
09/07/2019	Mohnish Chopra		Bug 85547 - Not able to open workitem in case external table's data migrated to SecondaryDB and alias is defined on Extended Queue variable
09/08/2019 Sourabh Tantuway     Bug 85912 - iBPS 4.0 + mssql: In case of reassignment of workitem, if function filter is applied on queue then WFGetWorkitem procedure is giving error.
12/08/2019	Ravi Ranjan Kumar	Bug 85923 - On Any queue ,queue filter is set on queue then wmgetworkitem API with utilityflag='Y' not able to lock the workitem
16/10/2019	Ambuj Tripathi		Bug 87384 - IBPS 4.0 :: SQL - Variables lengths are not sufficient to contain the query formed in two stored procedures : WFFetchWorkList and WFGetWorkitem
26/11/2019	Ravi Ranjan Kumar	Bug 88613 - Unable to done task, getting error "No Authorization".
18/02/2020		Ravi Ranjan Kumar	Bug 90769 - Query Queue Filter is not calculated in WFGetWorkitem API when user opeing the workitem.
04/03/2020	Ravi Ranjan Kumar	Bug 91184 - WAS : WI showing error after reassign/Refer and Save click 
24/06/2020  Shubham Singla      Bug 92966 - iBPS 5.0+SQL :Check needs to be added in SQL case while fetching the alias defined when opening the workitem
05/12/2020  Sourabh Tantuway    Bug 96460 - iBPS 5.0 SP1 + mssql : When trying to complete a workitem from any queue where worklist sorted by EntryDateTime, Requested filter Invalid Error is coming.
22/02/2021  Shubham Singla     Bug 97415 - iBPS 5.0 SP1: Username is coming as null in WFCurrentroutelogtable for actionid =7
05/02/2021  Shubham Singla     Bug 97403 - iBPS 5.0 SP1 :Issue is coming while opening the workitem when filter is applied on query workstep queue.
01/02/2021  Sourabh Tantuway   Bug 97798 - iBPS 4.0 SP1 + msssql : Error coming while opening the workitem
01/06/2021  Sourabh Tantuway   Bug 99639 - iBPS 5.0 SP2+mssql : Bring next workitem functionality not working properly, if some queue variable is used in sorting criteria of the workitems
26/05/2021  Ravi Raj Mewara    Bug 99548 - iBPS 5.0 SP2: If a workitem is temporary hold by any user then only that user can open it in editable mode and only badmin or that particular user can unhold the workitem.
12/06/2021  Sourabh Tantuway   Bug 99844 - iBPS 5.0 SP2+mssql : Prev next functionality is not working if worklist is sorted by 'IntroducedBy' or any other user defined queue variable alias. Issue is also coming if the alias is having space in it.
16/06/2021  Shubham Singla      Bug 99895 - iBPS 5.0 SP0+MSSQL:Issue is coming while opening the workitem when multiple filters(more than 6-7) are applied on the user as the length of the final query is exceeding the max length declared. 
05/10/2021  Ravi Raj Mewara    Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
----------------------------------------------------------------------------------------------------*/

If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFGetWorkitem')
Begin
	Execute('DROP PROCEDURE WFGetWorkitem')
	Print 'Procedure WFGetWorkitem already exists, hence older one dropped ..... '
End

~


CREATE PROCEDURE WFGetWorkitem(
	@DBSessionId			Integer,
	@DBProcessInstanceId		NVarchar(64),
	@DBWorkItemId			Integer,
	@DBQueueId			Integer,
	@DBQueueType			NVarchar(1),		/* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
	@DBLastProcessInstanceId	NVarchar(64),
	@DBLastWorkitemId		Integer,
	@DBGenerateLog			NVarchar(1),
	@DBOrderBy			Integer, /*Bug #815*/
	@DBSortOrder			NVarchar(64),
	@DBLastValue			NVarchar(1000),
	@DBAssignMe			NVarchar(1),
	@DBClientOrderFlag	NVarchar(1),
	@DBTaskId			INTEGER,
	@v_UtilityFlag 		NVARCHAR(1),
	@DBuserFilterStr		VARCHAR(MAX),
	@DBExternalTableName			NVARCHAR(50),
	@DBHistoryTableName			NVARCHAR(50)	
)
AS
Begin


	SET NOCOUNT ON

	/* Declare workitem data common in five tables and queueHistoryTable */
	Declare @ProcessInstanceId	NVARCHAR (63)
	Declare @WorkItemId		INT
	Declare @ProcessName 		NVARCHAR(30)
	Declare @ProcessVersion  	SMALLINT
	Declare @ProcessDefID 		INT
	Declare @LastProcessedBy 	INT
	Declare @ProcessedBy		NVARCHAR(63)
	DECLARE	@v_QueryStr			VARCHAR(MAX) 
	DECLARE	@v_counterCondition	INT 
	Declare @ActivityName 		NVARCHAR(30)
	DECLARE	@v_PositionComma	INT 
	Declare @ActivityId 		INT
	Declare @EntryDateTime 		DATETIME
	Declare @IntroductionDate 		DATETIME
	DECLARE @v_ProcessName		NVARCHAR(30)
	Declare @ParentWorkItemId	INT
	DECLARE	@v_TempColumnName	NVARCHAR(64) 
	DECLARE	@v_TempSortOrder	NVARCHAR(6) 	
	DECLARE	@v_orderByPos		INT 
	Declare @AssignmentType		NVARCHAR(1)
	Declare @CollectFlag		NVARCHAR(1)
	Declare @PriorityLevel		SMALLINT
	Declare @ValidTill		DATETIME
	Declare @Q_StreamId		INT
	Declare @Q_QueueId		INT
	Declare @Q_UserId		INT
	Declare @AssignedUser		NVARCHAR(63)
	Declare @FilterValue		INT
	Declare @CreatedDatetime	DATETIME
	Declare @WorkItemState		INT
	Declare @Statename 		NVARCHAR(255)
	Declare @ExpectedWorkitemDelay	DATETIME
	Declare @PreviousStage		NVARCHAR(30)
	Declare @LockedByName		NVARCHAR(63)
	Declare @LockStatus		NVARCHAR(1)
	Declare @LockedTime		DATETIME
	Declare @Queuename 		NVARCHAR(63)
	Declare @Queuetype 		NVARCHAR(1)
	Declare @NotifyStatus		NVARCHAR(1)
	Declare @RoutingStatus		NVARCHAR(1)
	Declare @v_QueryPreview		NVARCHAR(1)	/*WFS_8.0_031*/
	Declare @Q_DivertedByUserId INT 
	Declare @LastModifiedTime DATETIME
	Declare @v_URN			NVARCHAR (63)
	Declare @IntroducedBy 		NVARCHAR(255)
	/* Declare output variables */
	Declare @lockFlag		NVARCHAR(1)
	Declare @MainCode		INT
	Declare @GenLogMainCode		INT
	/*Bug #815*/
	Declare @DBSubCode		INT		
	DECLARE	@v_returnCount  INT

	/* Declare intermmediate variables */
	Declare @rowCount		INT
	Declare @found			NVARCHAR(1)
	Declare @canLock		NVARCHAR(1)
	Declare @userIndex		INT
	Declare @userName		NVARCHAR(63)
	Declare	@status			NVARCHAR(1)
	Declare @qdt_filterOption	INT

	Declare @queryStr		NVarchar(max)	/*WFS_8.0_040*/ 
	Declare @queryFilterStr		NVarchar(4000) 
	Declare @queryFilterStrInner	NVarchar(800) /*Bug #815*/
	Declare @queryFilterStr2	NVarchar(4000)
	Declare @orderByStr		NVarchar(200)
	Declare @toSearchStr		NVarchar(20)
	Declare @QueryFilter		Nvarchar(max)
	Declare @orderByPos		INT	
	Declare @counterInt		INT 	
	Declare @tempFilter		NVarchar(4000)
	Declare @tableStr		NVarchar(200)

	/*Query WorkStep Handling */
	Declare @QueueDataTableStr	NVarchar(50)
	Declare @tableName              NVarchar(256)
	Declare @CheckQueryWSFlag       NVarchar(1)
	Declare @bInQueue		NVarchar(1)
	Declare @QueryActivityId        INT
	/*Query WorkStep Handling */
	
	DECLARE	@v_FunctionPos		INT
	DECLARE	@v_funPos1			INT
	DECLARE	@v_funPos2			INT
	DECLARE	@v_FunValue			NVARCHAR(max)
	DECLARE	@queryFunStr		NVARCHAR(4000)
	DECLARE	@v_functionFlag		NVARCHAR(1)
	DECLARE	@v_prevFilter		NVARCHAR(4000)
	DECLARE	@v_funFilter		NVARCHAR(255)
	DECLARE	@v_postFilter		NVARCHAR(4000)
	DECLARE	@v_tempFunStr  		NVARCHAR(64)
	DECLARE	@v_FunLength		INT
	
	DECLARE	@v_AssignQ_QueueId	INT	
	DECLARE	@v_AssignFilterVal	INT
	DECLARE	@v_AssignWIState	INT
	DECLARE	@v_AssignQueueType	NVARCHAR(1)
	DECLARE	@v_AssignedUser		NVARCHAR(63)
	DECLARE	@v_AssignQueueName	NVARCHAR(100)


	/* WFS_5_131 */
	Declare @orderBy		NVarchar(200)
	Declare	@sortOrder    		NVarchar(1) /*Bug #815*/
	Declare @iOrder			INT
	Declare	@sortFieldStr		NVarchar(2000)
	Declare	@sortFieldStrCol	NVarchar(2000)
	Declare	@sortFieldStrValue	NVarchar(2000)
	DECLARE	@v_reverseOrder		INT 
	DECLARE	@v_innerOrderBy		NVARChar(200) 
	Declare @iFirstOrder		INT
	Declare @len			INT
	Declare @tempOrderStr		NVarchar(2000)
	/*Bug #815*/
	Declare @v_lastValueStr			NVarchar(1000)
	DECLARE	@v_TemplastValueStr		NVARCHAR(1000) 
	DECLARE	@v_innerLastValueStr	NVARCHAR(1000) 
	DECLARE	@v_innerOrderByCol1		NVARCHAR(64) 
	DECLARE	@v_innerOrderByCol2		NVARCHAR(64) 
	DECLARE	@v_innerOrderByCol3		NVARCHAR(64) 
	DECLARE	@v_innerOrderByCol4		NVARCHAR(64) 
	DECLARE	@v_innerOrderByCol5		NVARCHAR(64) 
	DECLARE	@v_innerOrderBySort1	NVARCHAR(6) 
	DECLARE	@v_innerOrderBySort2	NVARCHAR(6) 
	DECLARE	@v_innerOrderBySort3	NVARCHAR(6) 
	DECLARE	@v_innerOrderBySort4	NVARCHAR(6) 
	DECLARE	@v_innerOrderBySort5	NVARCHAR(6) 
	DECLARE	@v_innerOrderByVal1		NVARCHAR(256) 
	DECLARE	@v_innerOrderByVal2		NVARCHAR(256) 
	DECLARE	@v_innerOrderByVal3		NVARCHAR(256) 
	DECLARE	@v_innerOrderByVal4		NVARCHAR(256) 
	DECLARE	@v_innerOrderByVal5		NVARCHAR(256) 
	DECLARE	@v_innerOrderByType1	NVARCHAR(50) 
	DECLARE	@v_innerOrderByType2	NVARCHAR(50) 
	DECLARE	@v_innerOrderByType3	NVARCHAR(50) 
	DECLARE	@v_innerOrderByType4	NVARCHAR(50) 
	DECLARE	@v_innerOrderByType5	NVARCHAR(50) 
	DECLARE	@v_innerOrderByCount	INT 
	DECLARE	@v_CursorLastValue		INT 
	DECLARE @v_quoteChar 			CHAR(1) 
	DECLARE @tempQueryStr			NVarchar(1000)
	DECLARE	@v_rowCount				INT 
	DECLARE @v_TempColumnVal		NVarchar(500)
	/* WFS_5_131 */

	DECLARE	@v_ParsedQueryFilter NVARCHAR(4000)
	DECLARE	@v_groupID			INT 
	DECLARE	@v_QueueFilter			NVARCHAR(MAX)
	DECLARE	@v_TempQueryFilter		NVARCHAR(MAX)
	/* WFS_8.0_040 */
	DECLARE	@v_counter			INT 
	DECLARE	@v_tempFilter		NVARCHAR(4000) 
	DECLARE @v_QDTColStr		NVARCHAR(4000)
	DECLARE @v_AliasStr			NVARCHAR(4000)
	DECLARE	@v_PARAM1			NVARCHAR(255) 
	DECLARE	@v_ALIAS			NVARCHAR(255) 
	DECLARE	@v_ExtAlias			NVARCHAR(2000)
	DECLARE	@v_ToReturn			NVARCHAR(1) 
	DECLARE	@v_sortStr			NVARCHAR(6) 
	DECLARE	@v_QueryStr1		NVARCHAR(4000) 
	DECLARE	@v_WLTColStr1		NVARCHAR(4000) 
	DECLARE	@v_WLTColStr		NVARCHAR(4000)
	DECLARE	@v_VariableId1		INT
	DECLARE	@v_JoinExtTable		INT
	DECLARE	@v_op				CHAR(1) 
	DECLARE	@v_sortFieldStr		NVARCHAR(50) 
	DECLARE	@v_extTableName		NVARCHAR(50)
	DECLARE	@v_extTable_QDT_JoinStr		NVARCHAR(256)	
	DECLARE @v_tempQ_UserId			INT
	DECLARE	@v_QueryFilterQueue	Varchar(8000)
	DECLARE	@v_QueryFilterUG   Varchar(8000)
	/*Bug #815*/
	DECLARE @QDTColStr		NVarchar(1000)
	DECLARE @WLTColStr  		NVarchar(1000)
	DECLARE @v_counter1		INT
	DECLARE @v_CursorAlias		INT
	DECLARE @v_AliasStr1	NVarchar(1000)
	DECLARE	@v_PARAM2		NVARCHAR(64) 
	DECLARE	@v_ALIAS1		NVARCHAR(64) 
	DECLARE	@v_ToReturn1		NVARCHAR(1) 
	DECLARE @DATEFMT 		NVarchar(25)
	DECLARE @v_tempDataType		NVarchar(100) 
	DECLARE @qdtColString		NVarchar(1000)
	DECLARE @processVariantId	INT/*Process Variant Support Changes*/
	DECLARE @v_CanInitiate	NVarchar(1)
	DECLARE @v_showCaseVisual NVarchar(1)
	DECLARE @v_ActivityType INT 
	Declare @prevNextCase bit
	DECLARE @v_editableOnQuery VARCHAR(2)
	Declare @queryStr1		NVarchar(MAX)
	Declare @tableName1		NVARCHAR(256)
	Declare @v_exists 	INT
	Declare @v_extObjId INT
	Declare @v_fieldName NVarChar(4000)
	Declare @v_externalTaleJoin NVarchar(1)
	Declare @v_finalColumnStr Nvarchar(MAX)
	Declare @v_query1 Nvarchar(MAX)
	DECLARE	@v_extTableNameHistory		NVARCHAR(50)
	DECLARE	@v_queryQueueId		INT
	DECLARE	@v_tempCount		INT
	DECLARE	@v_systemDefinedName		NVARCHAR(50)
	
	/* Initializations */
	SELECT @tableName1='WFINSTRUMENTTABLE'
	Select @prevNextCase = 'false'
	Select	@found			= 'N'
	Select  @canLock		= 'N'
	Select	@lockFlag		= 'N'
	Select	@MainCode		= 0
	Select  @ProcessInstanceId	= @DBProcessInstanceId
	Select  @WorkitemId		= @DBWorkitemId
	Select	@Q_QueueId		= @DBQueueId
	Select @v_CanInitiate = 'Y'
	Select @v_showCaseVisual = 'Y'

	/*Query WorkStep Handling */
	Select  @QueueDataTableStr	= ''
    Select  @CheckQueryWSFlag       = 'N'
	Select  @tableName              = ''
	/*Query WorkStep Handling */
	SELECT @LastModifiedTime = ''
	Select @QDTColStr  =''
	Select @WLTColStr =''
	Select @v_AliasStr1  =''
	Select @v_lastValueStr		= '' 
	Select @orderByStr		= ''
	SELECT @v_VariableId1 = 0
	SELECT @v_JoinExtTable = 0 /*	Default 0 means External Table join not required.*/
	SELECT @v_quoteChar = CHAR(39)
	SELECT @sortFieldStrCol=''
	SELECT @DBClientOrderFlag='N'
	DECLARE @v_indexOfSeprator INT
	DECLARE	@v_genLog   Varchar(2)
	DECLARE	@v_WorkStartedLoggingEnabled   Varchar(2)
	
	SELECT @v_extTableName=@DBExternalTableName
	SELECT @v_extTableNameHistory=@DBHistoryTableName
	
	/* Check session validity */
	Select	@userIndex	= userIndex,
		@userName	= userName,
		@status = statusFlag
	FROM	WFSessionView, WFUserView 
	WHERE	UserId		= UserIndex 
	AND	SessionID	= @DBSessionId 

	Select	@rowCount	= @@rowCount

	IF(@rowCount <= 0)
	Begin
		SELECT	@MainCode	= 11		/* Invalid Session Handle */
		Select	@MainCode	MainCode,
			@lockFlag	lockFlag
		RETURN
	End
	
	    Select @v_indexOfSeprator = CHARINDEX(',', @DBGenerateLog)
			If(@v_indexOfSeprator = 0)
			Begin
				
				Select @v_genLog = @DBGenerateLog
				Select @v_WorkStartedLoggingEnabled = @DBGenerateLog
			End
			Else
			Begin
				Select @v_genLog = SUBSTRING(@DBGenerateLog , 1, @v_indexOfSeprator-1)
				Select @v_WorkStartedLoggingEnabled = SUBSTRING(@DBGenerateLog , @v_indexOfSeprator+1 , LEN(@DBGenerateLog))
			End
	
	IF(@status = 'N')
	BEGIN
		Update WFSessionView set statusflag = 'Y' , AccessDateTime = GETDATE()
          WHERE SessionID = @DBSessionId
	END
	
	IF(@DBQueueId = 0 AND (@DBLastValue IS NOT NULL OR len(@DBLastValue)>0))/*Prev next featur will not work in case of myqueue and search*/
	BEGIN
		Select	@MainCode = 18
		Select	@MainCode	MainCode,
			@lockFlag	lockFlag
		Return
	END
	
	/* Fetch queue filter */ /* WFS_5_131 */
	If(@DBQueueId IS NOT NULL AND @DBQueueId > 0)	/*for FIFO case for getting new WorkItem append filter option also*/
	Begin
		SELECT @v_ProcessName = ProcessName	FROM QueueDeftable (NOLOCK) WHERE QueueID = @DBqueueId 
		SELECT @v_rowcount = @@ROWCOUNT 
		IF(@v_rowcount > 0 AND (@v_extTableName IS NULL OR @v_extTableName = '' ))  
		BEGIN
			IF (@v_ProcessName IS NOT NULL) 
				Select @v_extTableName = TableName from ExtDbConfTable (NOLOCK)
				where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable (NOLOCK) WHERE processName = @v_ProcessName) 
				and ExtObjId = 1
		END
	End
	/* WFS_5_131 */
	Select @queryFilterStr = ' WHERE '
	/* ProcessInstanceId will be NULL for FIFO only ..Bug #815. */
/*	Select @queryFilterStr = ' '*/
	If(@ProcessInstanceId IS NULL OR @ProcessInstanceId = ''  OR (Len(@ProcessInstanceId) <= 0))
	Begin
		/* Bug # WFS_5_067, Invalid column Name QueueId */
		Select @queryFilterStr	= @queryFilterStr + ' Q_QueueId = ' + convert(NVarchar(10), @DBQueueId)
	End
	Else
	Begin
		/* WFS_8.0_040 */
		Select @queryFilterStr	= @queryFilterStr + ' ProcessInstanceId = N''' + @ProcessInstanceId + 
						''' AND WorkitemId = ' + convert(NVarchar(10), @WorkitemId) 
	End
	IF(@DBLastValue IS NULL AND @DBLastProcessInstanceId is not null AND len(@DBLastProcessInstanceId) > 0 )
	Begin
		Select	@queryFilterStr = @queryFilterStr + ' AND NOT ( processInstanceId = N''' + @DBLastProcessInstanceId + ''' AND workitemId = ' + convert(NVarchar(4), @DBLastWorkitemId) + ' ) '
	End

	/*
		Some valisdations can also be put like in case of FIFO only, processInstanceId, WorkItemItem are not sent...
		If some validations are failing we can return Invalid paramater
		For the time being it is assumned that data will be send in proper case only......
	*/
	IF((@DBLastProcessInstanceId is not null AND len(@DBLastProcessInstanceId) > 0))
	BEGIN
		Select @prevNextCase = 'true'
	END
	
	IF(@DBQueueId < 0 OR (@prevNextCase=1))	/*Search case we have to find Q_QueueId for the workItem to find the QueryFilter condition*/
	Begin
	/*Process Variant Support Changes*/
		SELECT @Q_QueueId = Q_QueueId, @Queuetype = QueueType, @Q_UserId = Q_UserId, @RoutingStatus = RoutingStatus, @FilterValue = FilterValue, @ProcessDefID = ProcessDefId, @Queuename = QueueName, @LockedTime = LockedTime, @LockStatus = LockStatus, @LockedByName = LockedByName, @PreviousStage = PreviousStage, @ExpectedWorkitemDelay = ExpectedWorkitemDelay, @Statename = Statename, @WorkItemState = WorkItemState, @CreatedDatetime = CreatedDateTime, @AssignedUser = AssignedUser, @ValidTill = ValidTill, @PriorityLevel = PriorityLevel, @AssignmentType = AssignmentType, @EntryDateTime = EntryDateTime, @ActivityId = ActivityId, @ActivityName = ActivityName, @ProcessedBy = ProcessedBy, @ProcessVersion = ProcessVersion, @ProcessName = ProcessName,@processVariantId = ProcessVariantId, @Q_DivertedByUserId = Q_DivertedByUserId,@v_ActivityType= ActivityType,@LastModifiedTime =LastModifiedTime ,@v_URN = URN
		/*FROM (
			SELECT Q_QueueId, QueueType, Q_UserId, 'WorkListTable' tableName, FilterValue, ProcessDefId, QueueName, getdate() as LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName, ProcessVariantId FROM WorkListTable (NOLOCK) WHERE ProcessInstanceId = @ProcessInstanceId AND WorkitemId = @WorkitemId
			UNION ALL
			SELECT Q_QueueId, QueueType, Q_UserId, 'WorkInProcessTable' tableName, FilterValue, ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName, ProcessVariantId FROM WorkInProcessTable (NOLOCK) WHERE ProcessInstanceId = @ProcessInstanceId AND WorkitemId = @WorkitemId
		)  WorkListView*/
		
		From WFInstrumentTable with (NOLOCK) where RoutingStatus = 'N' AND ProcessInstanceId = @ProcessInstanceId AND WorkitemId = @WorkitemId
		SELECT @rowCount = @@rowCount
		
		If(@rowCount > 0 OR (@prevNextCase=1)) /* Workitem found in WorkList or WorkInProcessTable for Given Negative Qid from input */
		Begin
			/** 22/01/2008, Bugzilla Bug 3580, Unable to open fixed assigned workitems from search - Ruhi Hira */
			If(@Q_QueueId IS NOT NULL AND @Q_QueueId > 0)
			Begin
				SELECT @bInQueue = 'Y'	
				IF(@v_UtilityFlag='N')
				BEGIN
					SELECT TOP 1 @qdt_filterOption = QueueDefTable.FilterOption, @v_QueueFilter = QueueFilter
					FROM	QueueDefTable  WITH (NOLOCK) , QUserGroupView 
					WHERE	QueueDefTable.QueueID = QUserGroupView.QueueID 
					AND	QueueDefTable.QueueID = @Q_QueueId
					AND	UserId = @userIndex
					Select	@rowCount = @@rowCount
				END
				ELSE
				BEGIN
					SELECT TOP 1 @qdt_filterOption = QueueDefTable.FilterOption, @v_QueueFilter = QueueFilter
					FROM	QueueDefTable  WITH (NOLOCK) WHERE QueueDefTable.QueueID = @Q_QueueId
					Select	@rowCount = @@rowCount
				END
				
				If(@rowCount > 0)
				Begin
					IF(@qdt_FilterOption = 0)
					BEGIN
						Select @qdt_FilterOption = NULL
					END
					If( NOT ( (@qdt_FilterOption = 2 AND @FilterValue = @userIndex) OR 
						(@qdt_FilterOption = 3 AND @FilterValue != @userIndex) OR
						(@qdt_FilterOption = 1)))	  /* WFS_5_121 */
					Begin
						Select	@canLock = 'N'
						Select	@CheckQueryWSFlag = 'Y'
					End
				End
				ELSE
				Begin
					Select	@canLock = 'N'
					Select	@CheckQueryWSFlag = 'Y'
				End
				IF (@ProcessName IS NOT NULL AND (@v_extTableName IS NULL OR @v_extTableName = ''))
				BEGIN
					Select @v_extTableName = TableName from ExtDbConfTable (NOLOCK)
					where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable (NOLOCK) WHERE processName = @ProcessName) and ExtObjId = 1
					
				END	
			End
		End
		ELSE
		Begin
			SELECT @bInQueue = 'N'
		End
	End
	
	/*Bug 655839  Issue in opening a workitem through search (workitem lying on a queue with filters of the form &<UseerIndex>& )*/
	IF (@v_QueueFilter IS NOT NULL) 
			BEGIN 
				SELECT @v_QueueFilter = REPLACE(@v_QueueFilter, '&<UserIndex>&', @userIndex) 
				SELECT @v_QueueFilter = REPLACE(@v_QueueFilter, '&<UserName>&', @userName) 
				EXECUTE WFParseQueryFilter @v_QueueFilter, N'U', @userIndex, @v_ParsedQueryFilter OUT
				/* As per specifications, User Filters will not contain &<GroupIndex.*>&. Hence ignored */
				SELECT @v_QueueFilter = @v_ParsedQueryFilter
				SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@v_QueueFilter)) 
				IF (@v_orderByPos <> 0)  
				BEGIN 
					IF (@DBClientOrderFlag = N'N') 
						SELECT @v_innerOrderBy = SUBSTRING(@v_QueueFilter, @v_orderByPos + LEN('ORDER BY'), LEN(@v_QueueFilter))
					SELECT @v_QueueFilter = SUBSTRING(@v_QueueFilter, 1, @v_orderByPos - 1) 
				END  
			END  
			
	IF (@v_QueueFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_QueueFilter))) > 0)  
		BEGIN			
			SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @v_QueueFilter)
			IF(@v_FunctionPos <> 0)
			BEGIN	
			SELECT @v_FunLength = LEN('&<FUNCTION>&')
			SELECT @v_functionFlag = 'Y'
			WHILE(@v_functionFlag = 'Y')
				BEGIN					
					SELECT @v_prevFilter = SUBSTRING(@v_QueueFilter, 0, @v_FunctionPos-1)
					SELECT @v_funPos1 = CHARINDEX('{', @v_QueueFilter)			
					
					SELECT @v_tempFunStr = SUBSTRING(@v_QueueFilter, @v_FunctionPos + @v_FunLength, @v_funPos1 - (@v_FunctionPos + @v_FunLength))
					SELECT @v_tempFunStr = LTRIM(RTRIM(@v_tempFunStr));					
					
					IF (@v_tempFunStr IS NULL OR LEN(@v_tempFunStr) = 0)
					BEGIN
						SELECT @v_funPos2 = CHARINDEX('}', @v_QueueFilter)
						SELECT @v_funFilter = SUBSTRING(@v_QueueFilter, @v_funPos1 + 1, @v_funPos2 - @v_funPos1 -1)
						
						SELECT @v_postFilter = STUFF(@v_QueueFilter, 1, @v_funPos2 + 1, NULL)
						SELECT @queryFunStr  = 'SELECT @v_FunValue = dbo.' + @v_funFilter				
						
						EXEC SP_EXECUTESQL
							@query = @queryFunStr, 
							@params = N'@v_FunValue VARCHAR(MAX) OUTPUT', 
							@v_FunValue = @v_FunValue OUTPUT						
							
						IF(ISNULL(@v_FunValue, '') = '')
							SELECT @v_FunValue = '1 = 1'	
						
						SELECT @v_QueueFilter = @v_prevFilter + ' ' + @v_FunValue + ' ' + @v_postFilter
					END	
					ELSE
					BEGIN
						BREAK
					END							
					SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @v_QueueFilter)					
					IF(@v_FunctionPos = 0)
					BEGIN
						SELECT @v_functionFlag = 'N'
					END					
				END				
			END
		END
		
	/* End*/
	
	/* WFS_8.0_04 */
	IF (@Q_QueueId>0) 
	BEGIN
		SELECT @v_AliasStr = ''
		SELECT @queryStr = 'SELECT PARAM1, ALIAS, ToReturn, VariableId1 FROM VarAliasTable (NOLOCK) WHERE QueueId = ' + CONVERT(NVarchar(10), @Q_QueueId) + ' ORDER BY ID ASC' 
		EXECUTE ('DECLARE CursorAlias CURSOR Fast_Forward FOR ' + @queryStr) 
		OPEN CursorAlias 
		SELECT @v_counter = 0    
		FETCH NEXT FROM CursorAlias INTO @v_PARAM1, @v_ALIAS, @v_ToReturn, @v_VariableId1
		WHILE (@@FETCH_STATUS = 0)  
		BEGIN 
			SELECT @v_counter = @v_counter + 1 
			IF (@v_ToReturn = N'Y') 
			BEGIN 
				IF(UPPER(@v_PARAM1) != 'TATREMAINING' AND UPPER(@v_PARAM1) != 'TATCONSUMED')
			  BEGIN
				SELECT @v_AliasStr =  ISNULL(@v_AliasStr,'') + ', ' + @v_PARAM1 + ' AS  "' + @v_ALIAS +'"'     
				SELECT @v_ExtAlias =  ISNULL(@v_ExtAlias, '') + ', ' +'"' + @v_ALIAS +'"'  
               END	 
			END 
			IF (@DBorderBy > 100)
				IF (@v_VariableId1 = @DBorderBy) 
				BEGIN
					SELECT @v_sortFieldStr = ' "' + @v_ALIAS + '" ' 
					SELECT @sortFieldStrCol = ', "' +@v_ALIAS  + '" '
					IF(LEN(@DBlastValue) > 0)  
					BEGIN
						SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar
					END
				END
			IF (((@v_VariableId1 > 157 and @v_VariableId1 < 10001) OR ( @v_VariableId1 > 10023)) AND @v_extTableName IS NOT NULL) 
				SELECT @v_JoinExtTable = 1
				
			FETCH NEXT FROM CursorAlias INTO @v_PARAM1, @v_ALIAS, @v_ToReturn , @v_VariableId1
		END  
		CLOSE CursorAlias 
		DEALLOCATE CursorAlias 
	END
	IF (@v_JoinExtTable = 1)
	BEGIN
		SELECT @v_extTable_QDT_JoinStr = ' INNER JOIN ' + @v_extTableName + ' ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType) '
		
	END	
	ELSE	
	BEGIN
	    /* SELECT @v_extTableName = '' */ 
		SELECT @v_extTable_QDT_JoinStr = ''
	END

	/* Define sortOrder */ 
	
	IF(@DBsortOrder = 'D') 
	BEGIN 
		SELECT @v_reverseOrder = 1  
		SELECT @v_sortStr = ' DESC '  
		SELECT @v_op = '<'  
	END 
	Else /* IF(@DBsortOrder = 'A') */  
	BEGIN 
		SELECT @v_reverseOrder = 0  
		SELECT @v_sortStr = ' ASC '  
		SELECT @v_op = '>'  
	END   
	
	/*
		QueueId has been fetch for the WorkItem , 
		Find QueryFilter for the following cases :- 
			1. FIFO, have to find next WI and lock it (We will be needing QueryFilter for conditions and Order by)
			2. WIP, to check if teh WI has to be opened in writable modde or in Query WorkStep read only mode
	*/

	IF ((@DBQueueId > 0 AND (@ProcessInstanceId IS NULL OR @ProcessInstanceId = '') ) OR 
		( @DBQueueId < 0 AND @bInQueue = 'Y' AND (@Q_UserId IS NULL OR @userIndex != @Q_UserId)))
	Begin
		SELECT	@toSearchStr = 'ORDER BY'
		SELECT @tempOrderStr = ''
		SELECT @QueryFilter = QueryFilter 
		FROM QueueUserTable (NOLOCK)
		WHERE QueueId = @Q_QueueId AND UserId = @userIndex  AND AssociationType = 0
		Select	@rowCount = @@rowCount
		If(@rowCount > 0) /* WFS_8.0_147 */
		BEGIN
			If(@QueryFilter IS NOT NULL AND @QueryFilter != '') 
			BEGIN	/* As user specific filter exists so NO group filter considered. */
	/*			IF(@QueryFilter IS NOT NULL AND @QueryFilter != '')
				BEGIN*/
					SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserIndex>&',@userIndex+'')))
					SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserName>&',@userName+'')))
					SELECT @orderByPos = CHARINDEX(@toSearchStr,UPPER(@QueryFilter))
					IF(@orderByPos > 0)
					Begin
						IF (@DBClientOrderFlag = N'N') 
						BEGIN
							SELECT @v_innerOrderBy = SUBSTRING(@QueryFilter, @orderByPos + LEN('ORDER BY'), LEN(@QueryFilter))
						END
						SELECT @QueryFilter = SUBSTRING(@QueryFilter,0, @orderByPos - 1)
					End
					EXECUTE WFParseQueryFilter @QueryFilter, N'U', @userIndex, @v_ParsedQueryFilter OUT
					SELECT @QueryFilter = @v_ParsedQueryFilter
	/*			END*/
			END
		END
		ELSE /*  group filter present*/
		BEGIN
			SELECT @queryStr = ''
			SELECT @queryStr = ' Select QueryFilter, GroupId ' +
				    ' From Qusergroupview ' +
				    ' Where GroupId IS NOT NULL ' +
				    ' AND QueueId  = ' + convert(nvarchar(10),@Q_QueueId) +
				    ' AND UserId = ' +convert(nvarchar(10),@userIndex) 

			EXECUTE (' DECLARE FilterCur CURSOR FAST_FORWARD FOR ' + @queryStr) 
			OPEN FilterCur 
			FETCH NEXT FROM FilterCur INTO @QueryFilter, @v_groupID
			SELECT @counterInt = 1
			WHILE(@@FETCH_STATUS <> -1)
			BEGIN
				IF (@@FETCH_STATUS <> -2)
				BEGIN
					SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserIndex>&',@userIndex+'')))
					SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserName>&',@userName+'')))
					IF @QueryFilter != ''
					BEGIN
						SELECT @orderByPos = CHARINDEX(@toSearchStr,UPPER(@QueryFilter))
						IF (@orderByPos > 0)					
						Begin
							IF (@DBClientOrderFlag = N'N') 
								SELECT @v_innerOrderBy = SUBSTRING(@QueryFilter, @orderByPos + LEN('ORDER BY'), LEN(@QueryFilter))
								
							SELECT @QueryFilter = SUBSTRING(@QueryFilter,0, @orderByPos - 1)
						End
						EXECUTE WFParseQueryFilter @QueryFilter, N'U', @userIndex, @v_ParsedQueryFilter OUT
						SELECT @QueryFilter = @v_ParsedQueryFilter
						EXECUTE WFParseQueryFilter @QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
						SELECT @QueryFilter = @v_ParsedQueryFilter
						IF (LEN(@queryFilter) > 0)
						BEGIN
							SELECT @queryFilter = '(' + @queryFilter + ')'
							IF @counterInt = 1
								SELECT @tempFilter =  @QueryFilter 
							ELSE
								SELECT @tempFilter  = @tempFilter + ' OR ' + @QueryFilter 
							SELECT @counterInt = @counterInt + 1
						END
					END
					/*WFS_8.0_046 */
					ELSE
					BEGIN
						SELECT @tempFilter = ''
						BREAK
					END
				END
				FETCH NEXT FROM FilterCur  INTO @QueryFilter, @v_groupID 
			END
			CLOSE FilterCur  
			DEALLOCATE FilterCur  
			SELECT @QueryFilter = @tempFilter

		END

		IF ((@QueryFilter = '' OR @QueryFilter IS NULL) AND (@Queuetype = N'N')) /* Check For Queue Filter for Search Case */
		BEGIN
			SELECT @v_queueFilter = QueueFilter From QueueDefTable (NOLOCK) where QueueId = @Q_QueueId
			SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@v_queueFilter)) 
			IF (@v_orderByPos <> 0)  
			BEGIN 
				IF (@DBClientOrderFlag = N'N') 
					SELECT @v_innerOrderBy = SUBSTRING(@v_queueFilter, @v_orderByPos + LEN('ORDER BY'), LEN(@v_queueFilter))
				SELECT @v_queueFilter = SUBSTRING(@v_queueFilter, 1, @v_orderByPos - 1) 
			END 
			IF (@v_queueFilter IS NOT NULL AND LEN(@v_queueFilter) > 0)
			BEGIN
				SELECT @QueryFilter = @v_QueueFilter
				SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserIndex>&',@userIndex+'')))
				SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserName>&',@userName+'')))
				SELECT @orderByPos = CHARINDEX(@toSearchStr,UPPER(@QueryFilter))
				IF (@orderByPos > 0)					
				BEGIN
					IF (@DBClientOrderFlag = N'N') 
						SELECT @v_innerOrderBy = SUBSTRING(@QueryFilter, @orderByPos + LEN('ORDER BY'), LEN(@QueryFilter))
					SELECT @QueryFilter = SUBSTRING(@QueryFilter,0, @orderByPos - 1)
				END
				EXECUTE WFParseQueryFilter @QueryFilter, N'U', @userIndex, @v_ParsedQueryFilter OUT
				SELECT @QueryFilter = @v_ParsedQueryFilter
				SELECT @v_TempQueryFilter = @QueryFilter
				SELECT @queryStr = ' Select GroupId ' + ' From Qusergroupview ' + ' Where GroupId IS NOT NULL ' + ' AND QueueId  = ' + CONVERT(nvarchar(10),@Q_QueueId) +
					' AND UserId = ' + CONVERT(nvarchar(10),@userIndex) 
				EXECUTE (' DECLARE FilterCur CURSOR FAST_FORWARD FOR ' + @queryStr) 
				OPEN FilterCur 
				FETCH NEXT FROM FilterCur INTO @v_groupID
				SELECT @counterInt = 1
				WHILE(@@FETCH_STATUS <> -1)
				BEGIN
					IF (@@FETCH_STATUS <> -2)
					BEGIN
						SELECT @QueryFilter = @v_TempQueryFilter 
						EXECUTE WFParseQueryFilter @QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
						SELECT @QueryFilter = @v_ParsedQueryFilter
						IF (LEN(@queryFilter) > 0)
						BEGIN
							SELECT @queryFilter = '(' + @queryFilter + ')'
							IF @counterInt = 1
								SELECT @tempFilter =  @QueryFilter 
							ELSE
								SELECT @tempFilter  = @tempFilter + ' OR ' + @QueryFilter 
							SELECT @counterInt = @counterInt + 1
						END
					END
					FETCH NEXT FROM FilterCur  INTO @v_groupID 
				END
				CLOSE FilterCur  
				DEALLOCATE FilterCur  
				IF(@tempFilter IS NOT NULL 	AND LEN(LTRIM(RTRIM(@tempFilter))) > 0)
					SELECT @QueryFilter = @tempFilter
			END
		END
		
		IF (@QueryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryFilter))) > 0)  
		BEGIN			
			SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)
			IF(@v_FunctionPos <> 0)
			BEGIN	
			SELECT @v_FunLength = LEN('&<FUNCTION>&')
			SELECT @v_functionFlag = 'Y'
			WHILE(@v_functionFlag = 'Y')
				BEGIN					
					SELECT @v_prevFilter = SUBSTRING(@QueryFilter, 0, @v_FunctionPos-1)
					SELECT @v_funPos1 = CHARINDEX('{', @QueryFilter)			
					
					SELECT @v_tempFunStr = SUBSTRING(@QueryFilter, @v_FunctionPos + @v_FunLength, @v_funPos1 - (@v_FunctionPos + @v_FunLength))
					SELECT @v_tempFunStr = LTRIM(RTRIM(@v_tempFunStr));					
					
					IF (@v_tempFunStr IS NULL OR LEN(@v_tempFunStr) = 0)
					BEGIN
						SELECT @v_funPos2 = CHARINDEX('}', @QueryFilter)
						SELECT @v_funFilter = SUBSTRING(@QueryFilter, @v_funPos1 + 1, @v_funPos2 - @v_funPos1 -1)
						
						SELECT @v_postFilter = STUFF(@QueryFilter, 1, @v_funPos2 + 1, NULL)
						SELECT @queryFunStr  = 'SELECT @v_FunValue = dbo.' + @v_funFilter				
						
						EXEC SP_EXECUTESQL
							@query = @queryFunStr, 
							@params = N'@v_FunValue VARCHAR(MAX) OUTPUT', 
							@v_FunValue = @v_FunValue OUTPUT						
						
						IF(ISNULL(@v_FunValue, '') = '')
							SELECT @v_FunValue = '1 = 1'
						
						SELECT @QueryFilter = @v_prevFilter + ' ' + @v_FunValue + ' ' + @v_postFilter
					END	
					ELSE
					BEGIN
						BREAK
					END							
					SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)					
					IF(@v_FunctionPos = 0)
					BEGIN
						SELECT @v_functionFlag = 'N'
					END					
				END				
			END
		END

		IF (@QueryFilter IS NULL AND LEN(LTRIM(RTRIM(@QueryFilter))) <= 0)
		Begin
			SELECT @v_QueueFilter =''
			SELECT @queryFilterStr2 = ISNULL(@queryFilterStr2,'') + ' AND ' + @QueryFilter 
		End
	END
	
	IF ((@v_innerOrderBy is NULL) OR  (@ProcessInstanceId IS NOT NULL AND @ProcessInstanceId != ''))  
	BEGIN 
		IF(@DBorderBy = 1)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar   
			END  
			SELECT @v_sortFieldStr = ' PriorityLevel '  
		END  
		ElSE IF(@DBorderBy = 2)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0 )  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessInstanceId ' 
		END  
		ElSE IF(@DBorderBy = 3)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END  
			SELECT @v_sortFieldStr = ' ActivityName ' 
		END 
		ElSE IF(@DBorderBy = 4)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' LockedByName ' 
		END 
		ElSE IF(@DBorderBy = 5) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' IntroducedBy ' 
		END 
		ElSE IF(@DBorderBy = 6)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END 	 
			SELECT @v_sortFieldStr = ' InstrumentStatus ' 
		END 
		ElSE IF(@DBorderBy = 7)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END  
			SELECT @v_sortFieldStr = ' CheckListCompleteFlag '  
		END 
		ElSE IF(@DBorderBy = 8)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' LockStatus ' 
		END 
		ElSE IF(@DBorderBy = 9)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @DBlastValue 
			END  
			SELECT @v_sortFieldStr = ' WorkItemState ' 
		END 
		ElSE IF(@DBorderBy = 10) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' EntryDateTime ' 
		END 
		ElSE IF(@DBorderBy = 11)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ValidTill ' 
		END 
		ElSE IF(@DBorderBy = 12)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END 
			SELECT @v_sortFieldStr = ' LockedTime ' 
		END 
		ElSE IF(@DBorderBy = 13)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END 	 
			SELECT @v_sortFieldStr = ' IntroductionDateTime ' 
		END 
		ElSE IF(@DBorderBy = 17)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' Status ' 
		END 
		ElSE IF(@DBorderBy = 18) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' CreatedDateTime ' 
		END 
		ElSE IF(@DBorderBy = 19) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ExpectedWorkItemDelay ' 
		END 		/* Sorting On Alias */
		ElSE IF(@DBorderBy = 20) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessedBy ' 
		END 		/* Sorting On Alias */

		
		IF(@DBLastProcessInstanceId IS NOT NULL AND @DBLastProcessInstanceId !='')
		BEGIN 		
			SELECT @v_TempColumnVal = @v_lastValueStr 

			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				SELECT @v_lastValueStr = ' AND ( ( ' + @v_sortFieldStr + @v_op + @v_TempColumnVal + ') '   
				SELECT @v_lastValueStr = @v_lastValueStr + ' OR ( ' + @v_sortFieldStr + ' = ' + @v_TempColumnVal 
			END 
			ELSE 
			BEGIN 
				SELECT @v_lastValueStr = ' AND  ( ( ' + @v_sortFieldStr + ' IS NULL '  
			END

			SELECT @v_lastValueStr = @v_lastValueStr + ' AND (  ' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' ( Processinstanceid = N' + @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBLastWorkitemId)) + ' )' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op +'N'+ @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' ) '  

			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				IF (@DBsortOrder = N'A') 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE  
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NULL )'  
				END
				SELECT @v_lastValueStr = @v_lastValueStr + ') '
			END 
			ELSE  
			BEGIN 
				IF (@DBsortOrder = N'D') 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NOT NULL )'  
				END
				SELECT @v_lastValueStr = @v_lastValueStr + ') '
			END 
		END
		IF (@DBorderBy = 2) 
		BEGIN 
			SELECT @orderByStr = ' ORDER BY ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END 
		ELSE  
		BEGIN 
			SELECT @orderByStr = ' ORDER BY ' + @v_sortFieldStr + @v_sortStr + ', ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END  
	END
	ELSE 
	BEGIN 
		SELECT @orderByStr = ' ORDER BY '  
		SELECT @v_innerOrderBy = @v_innerOrderBy + ','  

		SELECT @v_PositionComma = CHARINDEX (',', @v_innerOrderBy)  
		SELECT @v_innerOrderByCount = 0  

		WHILE (@v_PositionComma > 0) 
		BEGIN 
			SELECT @v_innerOrderByCount = @v_innerOrderByCount + 1  
			SELECT @v_TempColumnName = SUBSTRING(@v_innerOrderBy, 1 , @v_PositionComma - 1)  

			SELECT @v_orderByPos = CHARINDEX( 'ASC',UPPER(@v_TempColumnName)) 
			IF (@v_orderByPos > 0)  
			BEGIN 
				SELECT @v_TempSortOrder = 'ASC' 
				SELECT @v_TempColumnName = RTRIM(SUBSTRING(@v_TempColumnName, 1, @v_orderByPos -1))  
			END 
			ELSE  
			BEGIN 
				SELECT @v_orderByPos = CHARINDEX( 'DESC',UPPER(@v_TempColumnName)) 
				IF (@v_orderByPos > 0) 
				BEGIN 
					SELECT @v_TempSortOrder = 'DESC' 
					SELECT @v_TempColumnName = RTRIM(SUBSTRING(@v_TempColumnName, 1, @v_orderByPos -1)) 
				END 
				ELSE  
				BEGIN 
					SELECT @v_TempSortOrder = 'ASC'  
				END  
			END  

			IF (@v_reverseOrder = 1)  
			BEGIN 
				IF (@v_TempSortOrder = 'ASC')  
				BEGIN 
					SELECT @v_TempSortOrder = 'DESC'  
				END 
				ELSE  
				BEGIN 
					SELECT @v_TempSortOrder = 'ASC' 
				END   
			END   

			IF (@v_innerOrderByCount = 1)  
			BEGIN 
				SELECT @v_innerLastValueStr = @v_TempColumnName  
				SELECT @orderByStr = @orderByStr + @v_TempColumnName + ' ' + @v_TempSortOrder 
			END 
			ELSE  
			BEGIN 
				SELECT @v_innerLastValueStr = @v_innerLastValueStr +  ', ' + @v_TempColumnName  
				SELECT @orderByStr = @orderByStr + ', ' + @v_TempColumnName + ' ' + @v_TempSortOrder  
			END  
			
			IF (@v_innerOrderByCount = 1 )  
			BEGIN 
				SELECT @v_innerOrderByCol1 = @v_TempColumnName  
				SELECT @v_innerOrderBySort1 = @v_TempSortOrder 
			END 
			ELSE IF (@v_innerOrderByCount = 2 )  
			BEGIN 
				SELECT @v_innerOrderByCol2 = @v_TempColumnName  
				SELECT @v_innerOrderBySort2 = @v_TempSortOrder 
			END 
			ELSE IF (@v_innerOrderByCount = 3 ) 
			BEGIN 
				SELECT @v_innerOrderByCol3 = @v_TempColumnName  
				SELECT @v_innerOrderBySort3 = @v_TempSortOrder 
			END 
			ELSE IF (@v_innerOrderByCount = 4 )  
			BEGIN 
				SELECT @v_innerOrderByCol4 = @v_TempColumnName  
				SELECT @v_innerOrderBySort4 = @v_TempSortOrder 
			END 
			ELSE IF (@v_innerOrderByCount = 5 )  
			BEGIN 
				SELECT @v_innerOrderByCol5 = @v_TempColumnName 
				SELECT @v_innerOrderBySort5 = @v_TempSortOrder  
			END  
			SELECT @v_innerOrderBy = SUBSTRING(@v_innerOrderBy, @v_PositionComma + 1, LEN(@v_innerOrderBy)) 
			SELECT @v_PositionComma = CHARINDEX (',',@v_innerOrderBy)  
			
		END  
		SELECT @orderByStr = @orderByStr + ', ' + 'ProcessInstanceID' + @v_sortStr + ', WorkItemID ' + @v_sortStr  	
		 
		IF(@DBLastProcessInstanceId IS NOT NULL AND len(@DBLastProcessInstanceId) > 0)  
		BEGIN 
			SELECT @v_counter = 0  

			WHILE (@v_counter < @v_innerOrderByCount)  
			BEGIN 
				SELECT @v_counter = @v_counter + 1  
				IF (@v_counter = 1 )  
				BEGIN 
					SELECT @v_sortFieldStr = @v_innerOrderByCol1 
				END 
				ELSE IF (@v_counter = 2 )  
				BEGIN 
					SELECT @v_sortFieldStr = @v_innerOrderByCol2 
				END 
				ELSE IF (@v_counter = 3 ) 
				BEGIN 
					SELECT @v_sortFieldStr = @v_innerOrderByCol3 
				END 
				ELSE IF (@v_counter = 4 )  
				BEGIN 
					SELECT @v_sortFieldStr = @v_innerOrderByCol4 
				END 
				ELSE IF (@v_counter = 5 ) 
				BEGIN 
					SELECT @v_sortFieldStr = @v_innerOrderByCol5  
				END  

				IF (@v_counter = 1 ) 
				BEGIN 
					SELECT @v_innerOrderByType1 = @v_tempDataType 
				END 
				ELSE IF (@v_counter = 2 ) 
				BEGIN 
					SELECT @v_innerOrderByType2 = @v_tempDataType 
				END 
				ELSE IF (@v_counter = 3 )  
				BEGIN 
					SELECT @v_innerOrderByType3 = @v_tempDataType 
				END 
				ELSE IF (@v_counter = 4 )  
				BEGIN 
					SELECT @v_innerOrderByType4 = @v_tempDataType 
				END 
				ELSE IF (@v_counter = 5 )  
				BEGIN 
					SELECT @v_innerOrderByType5 = @v_tempDataType  
				END  
			END  

			IF (@v_innerOrderByCount > 0 )  
			BEGIN 
				SELECT @v_counter = 5 - @v_innerOrderByCount  

				WHILE (@v_counter > 0) 
				BEGIN 
					select @v_innerLastValueStr = @v_innerLastValueStr +  ', NULL'  
					select @v_counter = @v_counter - 1 
				END  
			END  

			BEGIN 
				/*select @v_QueryStr = 'SELECT ' +  @v_innerLastValueStr + ' FROM (SELECT QUEUEDATATABLE.* ' + ISNULL(@v_AliasStr,'') + ' FROM QUEUEDATATABLE ' + @v_extTable_QDT_JoinStr + ' WHERE PROCESSINSTANCEID = ' + @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar + ' AND WORKITEMID = ' + CONVERT(NVarchar(10), (@DBLastWorkitemId)) + ') Table0' */
				
                                select @qdtColString = 'ProcessInstanceId, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, InstrumentStatus ,CheckListCompleteFlag ,
				SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId ChildWorkitemId, ParentWorkItemID, CalendarName'
				
				select @v_QueryStr = 'SELECT ' +  @v_innerLastValueStr + ' FROM (SELECT '+ @qdtColString + ISNULL(@v_AliasStr,'') + ' FROM WFINSTRUMENTTABLE  WITH (NOLOCK) ' + @v_extTable_QDT_JoinStr + ' WHERE PROCESSINSTANCEID = N' + @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar + ' AND WORKITEMID = ' + CONVERT(NVarchar(10), (@DBLastWorkitemId)) + ') Table0' 

				EXECUTE ('DECLARE CursorLastValue CURSOR Fast_Forward FOR ' + @v_QueryStr) 
				
				OPEN CursorLastValue 
				SELECT @v_counter = 0
				
				FETCH NEXT FROM CursorLastValue INTO @v_innerOrderByVal1, @v_innerOrderByVal2, @v_innerOrderByVal3, @v_innerOrderByVal4, @v_innerOrderByVal5  

				WHILE (@@FETCH_STATUS = 0)  
				BEGIN  
					FETCH NEXT FROM CursorLastValue INTO @v_innerOrderByVal1, @v_innerOrderByVal2, @v_innerOrderByVal3, @v_innerOrderByVal4, @v_innerOrderByVal5  
				END 
				/* Close and DeAllocate the cursor */  
				CLOSE CursorLastValue 
				DEALLOCATE CursorLastValue 					
			END

			SELECT @v_counter = 0 
			SELECT @v_counterCondition = 0  
			SELECT @v_lastValueStr = ' AND ( '  
			WHILE (@v_counter < @v_innerOrderByCount + 1 ) 
			BEGIN 
				SELECT @v_counter1 = 0  
				SELECT @v_TemplastValueStr = ''/*WFS_8.0_120*/
				WHILE (@v_counter1 <= @v_counter) 
				BEGIN 
					IF (@v_counter1 = 0)  
					BEGIN 
						SELECT @v_TempColumnName = @v_innerOrderByCol1  
						SELECT @v_TempSortOrder = @v_innerOrderBySort1  
						SELECT @v_TempColumnVal = @v_innerOrderByVal1  
						SELECT @v_tempDataType = @v_innerOrderByType1  
					END 
					ELSE IF (@v_counter1 = 1)  
					BEGIN 
						SELECT @v_TempColumnName = @v_innerOrderByCol2  
						SELECT @v_TempSortOrder = @v_innerOrderBySort2 
						SELECT @v_TempColumnVal = @v_innerOrderByVal2 
						SELECT @v_tempDataType = @v_innerOrderByType2 
					END 
					ELSE IF (@v_counter1 = 2) 
					BEGIN 
						SELECT @v_TempColumnName = @v_innerOrderByCol3 
						SELECT @v_TempSortOrder = @v_innerOrderBySort3 
						SELECT @v_TempColumnVal = @v_innerOrderByVal3 
						SELECT @v_tempDataType = @v_innerOrderByType3 
					END 
					ELSE IF (@v_counter1 = 3) 
					BEGIN 
						SELECT @v_TempColumnName = @v_innerOrderByCol4 
						SELECT @v_TempSortOrder = @v_innerOrderBySort4 
						SELECT @v_TempColumnVal = @v_innerOrderByVal4 
						SELECT @v_tempDataType = @v_innerOrderByType4 
					END 
					ELSE IF (@v_counter1 = 4) 
					BEGIN 
						SELECT @v_TempColumnName = @v_innerOrderByCol5 
						SELECT @v_TempSortOrder = @v_innerOrderBySort5 
						SELECT @v_TempColumnVal = @v_innerOrderByVal5 
						SELECT @v_tempDataType = @v_innerOrderByType5 
					END  

					IF (@v_counter = @v_innerOrderByCount ) 
					BEGIN 
						IF (@v_counter1 < @v_counter) 
						BEGIN 
							IF (@v_TempColumnVal IS NULL) 
							BEGIN 
								SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' IS NULL ' 
							END 
							ELSE  
							BEGIN 
								SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' = ' + @v_quoteChar + @v_TempColumnVal + @v_quoteChar 
							END  
							SELECT @v_TemplastValueStr = @v_TemplastValueStr + ' AND '  
						END 
					END 
					ELSE 
					BEGIN 
						IF (@v_counter1 = @v_counter) 
						BEGIN 
							IF (@v_TempSortOrder = 'ASC') 
							BEGIN 
								IF (@v_TempColumnVal IS NOT NULL) 
								BEGIN 
									SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' > ' + @v_quoteChar + @v_TempColumnVal + @v_quoteChar 
								END 
								ELSE 
								BEGIN 
									SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' IS NOT NULL ' 
								END  
							END 
							ELSE  
							BEGIN 
								IF (@v_TempColumnVal IS NOT NULL)  
								BEGIN 
									SELECT @v_TemplastValueStr = @v_TemplastValueStr + '( '  
									SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' < ' + @v_quoteChar + @v_TempColumnVal + @v_quoteChar 
									SELECT @v_TemplastValueStr = @v_TemplastValueStr + ' OR ' +  @v_TempColumnName + ' IS NULL )'  
								END 
								ELSE  
								BEGIN 
									SELECT @v_TemplastValueStr = NULL
								END 	
							END 
						END 
						ELSE  
						BEGIN 
							IF (@v_TempColumnVal IS NOT NULL)  
							BEGIN 
								SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' = ' + @v_quoteChar + @v_TempColumnVal + @v_quoteChar 
							END 
							ELSE  
							BEGIN 
								SELECT @v_TemplastValueStr = @v_TemplastValueStr + @v_TempColumnName + ' IS NULL '  
							END   

							SELECT @v_TemplastValueStr = @v_TemplastValueStr + ' AND '  
						END  
					END 
					SELECT @v_counter1 = @v_counter1 + 1 
				END 

				IF (@v_TemplastValueStr IS NOT NULL) 
				BEGIN 
					IF (@v_counterCondition > 0) 
					BEGIN 
						SELECT @v_lastValueStr = @v_lastValueStr + ' OR ( ' 
					END  
					SELECT @v_lastValueStr = @v_lastValueStr + @v_TemplastValueStr 
					IF (@v_counterCondition > 0 AND @v_counter < @v_innerOrderByCount ) 
					BEGIN 
						SELECT @v_lastValueStr = @v_lastValueStr + ' )'  
					END  
					SELECT @v_counterCondition = @v_counterCondition + 1 
				END  
				SELECT @v_counter = @v_counter + 1  
			END  
			
			SELECT @v_lastValueStr = @v_lastValueStr + ' (  ( Processinstanceid = N' + @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBLastWorkitemId)) + ' )'  
			SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op +'N'+ @v_quoteChar + @DBLastProcessInstanceId + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' ) )'  
			
			IF ( @v_counterCondition > 1 )  
			BEGIN 
				SELECT @v_lastValueStr = @v_lastValueStr + ' )'  
			END   
		END 
	END

	/*Todo Also check if DBQueueId < 0, and bINQueue = 'Y' then if tableName was not WorkInProcessTable...*/


	IF((@DBQueueId > 0 AND (@ProcessInstanceId IS NOT NULL OR @ProcessInstanceId != '')) OR @DBQueueId <=0)
		SELECT @canLock  = 'Y'
	IF((@canLock  = 'Y' AND (@ProcessInstanceId is not null AND len(@ProcessInstanceId) > 0 )) OR 
		(@ProcessInstanceId is null OR @ProcessInstanceId = ''))
	Begin
		/* WFS_8.0_04 */
		/* SELECT @v_WLTColStr = ' QueueDataTable.ProcessInstanceId, QueueDataTable.ProcessInstanceId as ProcessInstanceName,' + ' ProcessInstanceTable.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime,  getdate() as LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, FilterValue, ' + ' QueueDataTable.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, NotifyStatus, Status, Q_QueueID,' + ' ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, QueueDataTable.ParentWorkItemId, ProcessedBy, LastProcessedBy,' + ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessInstanceTable.ProcessVariantId'/*Process Variant Support Changes*/ */

		SELECT @v_WLTColStr = ' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime,  getdate() as LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, FilterValue, ' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, NotifyStatus, Status, Q_QueueID,' + ' ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' + ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,LastModifiedTime,URN'/*Process Variant Support Changes*/
		SELECT @v_WLTColStr1 = ' ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefId,  LastProcessedBy, ProcessedBy, ActivityName, ActivityId,  EntryDateTime,IntroductionDateTime,  ParentWorkItemId, AssignmentType,  CollectFlag, PriorityLevel, ValidTill,  Q_StreamId, Q_QueueID, Q_UserID,  AssignedUser, FilterValue, CreatedDateTime, WORKITEMSTATE,  Statename, ExpectedWorkItemDelay, PREVIOUSSTAGE,  LockedByName, LockStatus, LockedTime, QueueName, QueueType, NotifyStatus, ProcessVariantId, Q_DivertedByUserId,ActivityType,LastModifiedTime ,URN,IntroducedBy ' /*Process Variant Support Changes*/

		SELECT @v_QDTColStr = ', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,' +' VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6,' + ' VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6,'+ ' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20' 

		
		IF((@ProcessInstanceId is null OR @ProcessInstanceId = '') AND @DBQueueType = N'F')
		Begin
			SELECT @queryStr = @queryStr + ' WITH (UPDLOCK,READPAST) '
		End
	   
	    IF (((@QueryFilter IS NULL OR @QueryFilter = '' ) AND (@v_QueueFilter IS NULL OR @v_QueueFilter = '') AND (@DBorderBy < 3)) 
		AND (@DBuserFilterStr IS NULL OR @DBuserFilterStr = ''))
		BEGIN
			/*Process Variant Support Changes*/
			/*SELECT @queryStr = 'Select TOP 1 ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,ActivityId, EntryDateTime, WorkListTable.ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 	Q_UserId, AssignedUser, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, 		LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId From WorkListTable ' */
			
			SELECT @queryStr = 'Select TOP 1 ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,ActivityId, EntryDateTime,IntroductionDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 	Q_UserId, AssignedUser, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, 		LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId, Q_DivertedByUserId,ActivityType,LastModifiedTime,URN,IntroducedBy From WFINSTRUMENTTABLE  '
			
			IF((@ProcessInstanceId is null OR @ProcessInstanceId = '') AND @DBQueueType = N'F') 
			Begin 
				SELECT @queryStr = @queryStr + ' WITH (UPDLOCK,READPAST) ' 
			End 
			ELSE
			BEGIN
				SELECT @queryStr = @queryStr + ' WITH (UPDLOCK,ROWLOCK)  ' 
			END
			 /*Bug #815 */
			/*SELECT @queryStr = @queryStr + @queryFilterStr + ISNULL(@v_lastValueStr,'')+ @orderByStr */
			/*SELECT @queryStr = @queryStr + @queryFilterStr + ISNULL(@v_lastValueStr,'')+ @orderByStr */
			IF(@DBTaskId > 0) 
			BEGIN
				SELECT @queryStr = @queryStr + @queryFilterStr + ' AND 1=2 And RoutingStatus = ''N'' AND Lockstatus = ''N''' +ISNULL(@v_lastValueStr,'')+ @orderByStr
			END
			ELSE
			BEGIN	
			SELECT @queryStr = @queryStr + @queryFilterStr + ' And RoutingStatus = ''N'' AND Lockstatus = ''N''' +ISNULL(@v_lastValueStr,'')+ @orderByStr
			END
		END
		ELSE 
		BEGIN
			/*IF(@DBOrderBy > 100 AND (@v_sortFieldStr IS NOT NULL OR @v_sortFieldStr != ''))
				SELECT @queryStr = 'SELECT TOP 1 '+ @v_WLTColStr1 + @sortFieldStrCol + ' FROM ( SELECT TOP 1 * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM Worklisttable '
			ELSE
				SELECT @queryStr = 'SELECT TOP 1 '+ @v_WLTColStr1 + ' FROM ( SELECT TOP 1 * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM Worklisttable '*/
			
			IF(@DBOrderBy > 100 AND (@v_sortFieldStr IS NOT NULL OR @v_sortFieldStr != ''))
				SELECT @queryStr = 'SELECT TOP 1 '+ @v_WLTColStr1 + @sortFieldStrCol + ' FROM ( SELECT TOP 1 * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFINSTRUMENTTABLE  '
			ELSE
				SELECT @queryStr = 'SELECT TOP 1 '+ @v_WLTColStr1 + ' FROM ( SELECT TOP 1 * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFINSTRUMENTTABLE '

			IF((@QueryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryFilter))) > 0) AND (@v_QueueFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_QueueFilter))) > 0 ))
			BEGIN
				SELECT @v_QueueFilter = ' AND (' +@QueryFilter+')'
			END
			ELSE IF(@QueryFilter IS NULL OR @QueryFilter = '' )
			BEGIN
				IF(@v_QueueFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_QueueFilter))) > 0 )  
					SELECT @v_QueueFilter = ' AND ' + @v_QueueFilter 
			END
			ELSE
			BEGIN
				SELECT @queryFilterStr2 = ISNULL(@queryFilterStr2,'') + ' AND ' + '('+@QueryFilter+')'
				SELECT @v_QueueFilter = ''
			END
			IF((@ProcessInstanceId is null OR @ProcessInstanceId = '') AND @DBQueueType = N'F')
			Begin
				SELECT @queryStr = @queryStr + ' WITH (UPDLOCK,READPAST) '
			End
			ELSE
			BEGIN
				SELECT @queryStr = @queryStr + ' WITH (UPDLOCK,ROWLOCK) ' 
			
			END
			/*SELECT @queryStr = @queryStr + ', ProcessInstanceTable, QueueDatatable '+ @v_extTable_QDT_JoinStr +' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND Worklisttable.Workitemid =QueueDatatable.Workitemid ) Table1 ' + ISNULL(@queryFilterStr,'')+ ISNULL(@v_lastValueStr,'') + ISNULL(@queryFilterStr2,'') + ISNULL(@v_QueueFilter,'') + ISNULL(@orderByStr,'') + ') Table2' 	*/
			
			IF(@DBTaskId > 0)
			BEGIN 
			SELECT @queryStr = @queryStr + @v_extTable_QDT_JoinStr +' WHERE 1=2 AND RoutingStatus = ''N'' AND LockStatus = ''N'') Table1 ' + ISNULL(@queryFilterStr,'')+ ISNULL(@v_lastValueStr,'') + ISNULL(@queryFilterStr2,'') + ISNULL(@v_QueueFilter,'') + ISNULL(@orderByStr,'') + ') Table2' 
			END
			ELSE IF(@v_UtilityFlag='Y')
			BEGIN
			SELECT @queryStr = @queryStr + @v_extTable_QDT_JoinStr +' WHERE RoutingStatus = ''N'' AND LockStatus = ''N'') Table1 ' + ISNULL(@queryFilterStr,'')+ ISNULL(@v_lastValueStr,'') + ISNULL(@queryFilterStr2,'') +ISNULL(@DBuserFilterStr,'')+ ISNULL(@orderByStr,'') + ') Table2' 
			END
			ELSE
			BEGIN
			SELECT @queryStr = @queryStr + @v_extTable_QDT_JoinStr +' WHERE RoutingStatus = ''N'' AND LockStatus = ''N'') Table1 ' + ISNULL(@queryFilterStr,'')+ ISNULL(@v_lastValueStr,'') + ISNULL(@queryFilterStr2,'') + ISNULL(@v_QueueFilter,'') +ISNULL(@DBuserFilterStr,'')+ ISNULL(@orderByStr,'') + ') Table2' 
			END

		END

		Begin Transaction LockWI

		EXECUTE (' DECLARE LockCur CURSOR FAST_FORWARD FOR ' + @queryStr ) 
		OPEN LockCur
		IF(@DBOrderBy > 100 AND (@v_sortFieldStr IS NOT NULL OR @v_sortFieldStr != ''))
		FETCH NEXT FROM LockCur INTO 
			@ProcessInstanceId, @WorkItemId, @ProcessName, @ProcessVersion,
			@ProcessDefID, @LastProcessedBy, @ProcessedBy, @ActivityName,
			@ActivityId, @EntryDateTime,@IntroductionDate, @ParentWorkItemId, @AssignmentType,
			@CollectFlag, @PriorityLevel, @ValidTill, @Q_StreamId,
			@Q_QueueId, @Q_UserId, @AssignedUser, @FilterValue,
			@CreatedDateTime, @WorkItemState, @Statename, @ExpectedWorkitemDelay,
			@PreviousStage, @LockedByName, @LockStatus, @LockedTime,
			@Queuename, @Queuetype, @NotifyStatus, @processVariantId, @Q_DivertedByUserId,@v_ActivityType,@LastModifiedTime,@v_URN,@IntroducedBy,@sortFieldStrValue/*Process Variant Support Changes*/
		ELSE
		FETCH NEXT FROM LockCur INTO 
			@ProcessInstanceId, @WorkItemId, @ProcessName, @ProcessVersion,
			@ProcessDefID, @LastProcessedBy, @ProcessedBy, @ActivityName,
			@ActivityId, @EntryDateTime,@IntroductionDate, @ParentWorkItemId, @AssignmentType,
			@CollectFlag, @PriorityLevel, @ValidTill, @Q_StreamId,
			@Q_QueueId, @Q_UserId, @AssignedUser, @FilterValue,
			@CreatedDateTime, @WorkItemState, @Statename, @ExpectedWorkitemDelay,
			@PreviousStage, @LockedByName, @LockStatus, @LockedTime,
			@Queuename, @Queuetype, @NotifyStatus, @processVariantId, @Q_DivertedByUserId,@v_ActivityType,@LastModifiedTime,@v_URN,@IntroducedBy  /*Process Variant Support Changes*/
		SELECT @v_tempQ_UserId = @Q_UserId
		IF(@@Fetch_Status = 0)
		Begin

			Select	@found	= 'Y'
			IF (@CheckQueryWSFlag = 'N')
				Select	@canLock = 'Y'
			ELSE
				Select	@canLock = 'N'  /*WFS_8.0_069*/
			/* TODO - should we check for workitem state to make canLock -> Y 
				  change maincode to no authorization - when workitem state is not valid */
			BEGIN
			IF(@DBorderBy = 1)  
			BEGIN  
				SELECT @sortFieldStrValue =@PriorityLevel
			END  
			ElSE IF(@DBorderBy = 2)  
			BEGIN  
					SELECT @sortFieldStrValue =@ProcessInstanceId  
			END  
			ElSE IF(@DBorderBy = 3)  
			BEGIN  
					SELECT @sortFieldStrValue =@ActivityName 
			END 
			ElSE IF(@DBorderBy = 4)  
			BEGIN 
					SELECT @sortFieldStrValue =@LockedByName  
			END
			ElSE IF(@DBorderBy = 5)   
			BEGIN  
					SELECT @sortFieldStrValue =@IntroducedBy   
			END 
			ElSE IF(@DBorderBy = 8)  
			BEGIN 
					SELECT @sortFieldStrValue = @LockStatus  
			END 
			ElSE IF(@DBorderBy = 9)  
			BEGIN 
					SELECT @sortFieldStrValue = @WorkItemState 
			END 
			ElSE IF(@DBorderBy = 10) 
			BEGIN 
--					SELECT @sortFieldStrValue =@EntryDateTime
				SELECT @sortFieldStrValue =CONVERT(VARCHAR, @EntryDateTime,21)					
			END 
			ElSE IF(@DBorderBy = 11)  
			BEGIN 
					SELECT @sortFieldStrValue = CONVERT(VARCHAR, @ValidTill,21)
			END 
			ElSE IF(@DBorderBy = 12)  
			BEGIN 
					SELECT @sortFieldStrValue = CONVERT(VARCHAR, @LockedTime,21)
			END
			ElSE IF(@DBorderBy = 13)  
			BEGIN 
					SELECT @sortFieldStrValue = CONVERT(VARCHAR, @IntroductionDate,21)
			END
			ElSE IF(@DBorderBy = 17)  
			BEGIN 
				SELECT @sortFieldStrValue =@Status  
			END 
			ElSE IF(@DBorderBy = 18) 
			BEGIN 
				SELECT @sortFieldStrValue = CONVERT(VARCHAR, @CreatedDateTime,21)
			END 
			ElSE IF(@DBorderBy = 19) 
			BEGIN 
				SELECT @sortFieldStrValue = CONVERT(VARCHAR, @ExpectedWorkItemDelay,21)
			END 		/* Sorting On Alias */
			ElSE IF(@DBorderBy = 20) 
			BEGIN
					SELECT @sortFieldStrValue = @ProcessedBy
			END
		END	
		End
		/*Else IF (@bInQueue = 'Y' AND @tableName = 'WorkListTable') */
		Else IF (@bInQueue = 'Y' AND @RoutingStatus = 'N' and @LockStatus = 'N')
		BEGIN
			Select @CheckQueryWSFlag = 'Y'
			Select @canLock = 'N'
			Rollback Transaction LockWI
		END
		ELSE
			Rollback Transaction LockWI
		CLOSE LockCur
		DEALLOCATE LockCur
	End
	IF(@DBTaskId > 0) 
	BEGIN
		Select @found	= 'N'
	END		
	IF(@found = 'Y')
	Begin

		/* Condition modified as assignmentType can be null - Ruhi Hira */
		If(@canLock = 'Y' AND (@AssignmentType IS NULL OR @AssignmentType = '' OR 
			NOT (@AssignmentType = 'F' OR @AssignmentType = 'E' OR @AssignmentType = 'A'OR (@AssignmentType = 'H' AND @WorkItemState = 8))))
		Begin

			IF(@DBQueueId >= 0 AND @DBQueueId != @Q_QueueId)
			Begin
				Rollback Transaction LockWI
				/* Bug # WFS_5_116, so that WI is not available to any user in a dynamic queue after one user has performed done operation */
				Select	@MainCode = 810 /* Workitem not in the queue specified. */
				Select	@MainCode	MainCode,
					@lockFlag	lockFlag
				Return
			End
		END
		Else
		Begin
			/* Bug # WFS_5_068 */
			/* Modified on : 27/12/2006, Bug # WFS_5_149 - Ruhi Hira */			
			IF (@userIndex = @Q_UserId OR @v_UtilityFlag='Y')
				Select	@canLock = 'Y'
			ELSE 
			Begin
				Rollback Transaction LockWI
				Select	@canLock = 'N'
			End
		End

		If(@canLock = 'Y')
		Begin
				If(@AssignmentType IS NULL)
				Begin
					Select	@AssignmentType = 'S'
				End
				Select	@Q_UserId	= @userIndex
				Select	@AssignedUser	= @userName
				Select	@WorkitemState	= 2
				Select	@StateName	= 'RUNNING'
				Select	@LockedByName	= @userName
				Select	@LockStatus	= 'Y'
				Select	@LockedTime	= getDate()
				Select @v_AssignQ_QueueId = @Q_QueueId				
				Select @v_AssignFilterVal = @FilterValue				
				Select @v_AssignQueueType = @Queuetype
				Select @v_AssignedUser = @AssignedUser
				Select 	@v_AssignQueueName = @Queuename
				
				If(@DBQueueType = N'F' AND @DBAssignMe = 'Y')				
				BEGIN
					Select @AssignmentType = 'F'				
					Select @v_AssignQ_QueueId = 0					
					Select @v_AssignFilterVal = NULL				
					Select @v_AssignQueueType = 'U'
					Select @v_AssignQueueName = @userName + '''s MyQueue'
					
				END	

				/*Delete	From WorkListTable
				Where	ProcessInstanceID = @ProcessInstanceId
				AND	WorkItemID = @WorkitemId*/
				
				/*Select	@rowCount = @@rowCount */

					/*Insert Into WorkInProcessTable 
					Select @ProcessInstanceId, @WorkItemId, @ProcessName, @ProcessVersion,
						@ProcessDefID, @LastProcessedBy, @ProcessedBy, @ActivityName,
						@ActivityId, @EntryDateTime, @ParentWorkItemId, @AssignmentType,
						@CollectFlag, @PriorityLevel, @ValidTill, @Q_StreamId,
						@v_AssignQ_QueueId, @Q_UserId, @AssignedUser, @v_AssignFilterVal,
						@CreatedDateTime, @WorkItemState, @Statename, @ExpectedWorkitemDelay,
						@PreviousStage, @LockedByName, @LockStatus, @LockedTime,
						@v_AssignQueueName, @v_AssignQueueType, @NotifyStatus, NULL, @processVariantId //Process Variant Support Changes */
				If(@Queuetype != 'F' OR(@Queuetype = 'F' AND @DBQueueId > 0 AND @v_tempQ_UserId = @userIndex) OR (@Queuetype = 'F' AND @DBQueueId > 0 AND (@DBProcessInstanceId IS NULL OR @DBProcessInstanceId = ''  OR (Len(@DBProcessInstanceId) <= 0))) OR 
				(@Queuetype = 'F' AND @AssignmentType = 'H') )
				BEGIN
					Select	@rowCount = 1
				END
				Else
				BEGIN
					Select	@rowCount = 0
				END	
				If(@rowcount > 0)
				BEGIN
					Update WFInstrumentTable Set AssignmentType = @AssignmentType , Q_QueueId = @v_AssignQ_QueueId,
					Q_UserId = @Q_UserId, AssignedUser = @AssignedUser , FilterValue = @v_AssignFilterVal ,
					WorkItemState = @WorkItemState,Statename = @Statename,LockedByName = @LockedByName , LockStatus =
					@LockStatus,LockedTime = @LockedTime, Queuename = @v_AssignQueueName,Queuetype = @v_AssignQueueType ,Guid = null , Q_DivertedByUserId = @Q_DivertedByUserId where ProcessInstanceId = @ProcessInstanceId and WorkItemId = @WorkItemId  
					Select	@rowCount = @@rowCount

					If(@rowcount > 0)
					Begin
						Commit Transaction LockWI
						Select	@lockFlag = 'Y'
					End
					Else
					Begin
						Rollback Transaction LockWI
					End
				END
				ELSE
				BEGIN
					Rollback Transaction LockWI
				END
				
			Select @v_indexOfSeprator = CHARINDEX(',', @DBGenerateLog)
			If(@v_indexOfSeprator = 0)
			Begin
				
				Select @v_genLog = @DBGenerateLog
				Select @v_WorkStartedLoggingEnabled = @DBGenerateLog
			End
			Else
			Begin
				Select @v_genLog = SUBSTRING(@DBGenerateLog , 1, @v_indexOfSeprator-1)
				Select @v_WorkStartedLoggingEnabled = SUBSTRING(@DBGenerateLog , @v_indexOfSeprator+1 , LEN(@DBGenerateLog))
			End
			
			If(@lockFlag = 'Y' AND @v_genLog = 'Y' )
			Begin
			
				/* Logging for Locking workitem */
				/* Bug # WFS_5_077, Logging for Lock workitem */
				/* Changed By Varun Bhansaly 0n 19/07/2007 for Bugzilla Bug 74 */
				/*Insert Into WFMessageTable(message, status, ActionDateTime)
				VALUES	('<Message><ActionId>7</ActionId><UserId>' + convert(varchar, @userIndex) + 
						'</UserId><ProcessDefId>' + convert(varchar, @ProcessDefId) + 
						'</ProcessDefId><ActivityId>' + convert(varchar, @ActivityId) + 
						'</ActivityId><QueueId>0</QueueId><UserName>' + @userName + '</UserName><ActivityName>' + @ActivityName + 
						'</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' +
						convert(varchar(22), getDate(), 20) + '</ActionDateTime><EngineName></EngineName><ProcessInstance>' + 
						@ProcessInstanceId + '</ProcessInstance><FieldId>' + convert(varchar, @Q_QueueId) + 
						'</FieldId><FieldName>' + @Queuename + '</FieldName><WorkitemId>' + convert(varchar, @WorkitemId) + 
						'</WorkitemId><TotalPrTime>0</TotalPrTime>' +
						'<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>',	
					N'N', GETDATE())*/
					EXECUTE WFGenerateLog 7, @userIndex, @processDefId, @activityId, 0, @userName, @ActivityName, 0, @ProcessInstanceId, @Q_QueueId, @Queuename, @WorkitemId,  0, 0, null, @processVariantId, 0 ,0, @v_URN,NULL, @GenLogMainCode OUT
				/* Logging for work started */
				/* Changed By Varun Bhansaly 0n 19/07/2007 for Bugzilla Bug 74 */
				/*Insert Into WFMessageTable(message, status, ActionDateTime)
				VALUES	('<Message><ActionId>200</ActionId><UserId>' + convert(varchar, @userIndex) + 
						'</UserId><ProcessDefId>' + convert(varchar, @ProcessDefId) + 
						'</ProcessDefId><ActivityId>' + convert(varchar, @ActivityId) + '</ActivityId><QueueId>' + convert(varchar, @Q_QueueId) + 
						'</QueueId><UserName>' + @userName + '</UserName><ActivityName>' + @ActivityName + 
						'</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' +
						convert(varchar(22), getDate(), 20) + '</ActionDateTime><EngineName></EngineName><ProcessInstance>' + 
						@ProcessInstanceId + '</ProcessInstance><FiledId></FiledId><WorkitemId>' + convert(varchar, @WorkitemId) + 
						'</WorkitemId><TotalPrTime>0</TotalPrTime>' +
						'<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>', 
					N'N', GETDATE())*/
					-- Insert into WFCurrentRouteLogTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName, NewValue, QueueId, ProcessVariantId) 
					-- values(@ProcessDefId,@ActivityId,@ProcessInstanceId,@WorkitemId,@userIndex,200,getDate(),null,0,null, @ActivityName,@userName,null,@Q_QueueId,
					-- @processVariantId) 
			End
			Else If (@lockFlag = 'N')
			Begin
				SELECT	@MainCode	= 16		/* WorkItem was locked by some other unlucky user who will worko it. */
			End
		End
		ELSE IF (@userIndex = @Q_DivertedByUserId)
		BEGIN
			Select	@MainCode = 16
		END
		Else
		Begin
			Select	@CheckQueryWSFlag = 'Y'
			Select	@MainCode = 300	/* no authorization */
		End
	End
	Else IF (@CheckQueryWSFlag = 'N')
	Begin
		If(@DBTaskId > 0)
			Begin
			Select	@ProcessInstanceId	= ProcessInstanceId,
				@WorkItemId		= WorkItemId,
				@ProcessName		= ProcessName,
				@ProcessVersion		= ProcessVersion,
				@ProcessDefID		= ProcessDefID,
				@LastProcessedBy	= LastProcessedBy,
				@ProcessedBy		= ProcessedBy,
				@ActivityName		= ActivityName,
				@ActivityId		= ActivityId,
				@EntryDateTime		= EntryDateTime,
				@ParentWorkItemId	= ParentWorkItemId,
				@AssignmentType		= AssignmentType,
				@CollectFlag		= CollectFlag,
				@PriorityLevel		= PriorityLevel,
				@ValidTill		= ValidTill,
				@Q_StreamId		= Q_StreamId,
				@Q_QueueId		= Q_QueueId,
				@Q_UserId		= Q_UserId,
				@AssignedUser		= AssignedUser,
				@FilterValue		= FilterValue,
				@CreatedDateTime	= CreatedDateTime,
				@WorkItemState		= WorkItemState,
				@Statename		= Statename,
				@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
				@PreviousStage		= PreviousStage,
				@LockedByName		= LockedByName,
				@LockStatus		= LockStatus,
				@LockedTime		= LockedTime,
				@Queuename		= Queuename,
				@Queuetype		= Queuetype,
				@NotifyStatus		= NotifyStatus,
				@processVariantId = ProcessVariantId,
				@LastModifiedTime =LastModifiedTime,
				@v_URN = URN
			/*FROM	WorkInProcessTable (NOLOCK) */
			From WFInstrumentTable (NOLOCK) 
			WHERE	ProcessInstanceID = @ProcessInstanceId
			AND	WorkItemID = @WorkitemId
			AND RoutingStatus = 'N'
			
			Select	@rowcount = @@rowcount
			IF(@v_ActivityType=32) 
			 BEGIN
				Select @v_CanInitiate= max(CanInitiate) ,@v_showCaseVisual = max(ShowCaseVisual)
				FROM    WFTaskStatusTable (NOLOCK)
				WHERE    ProcessInstanceID = @ProcessInstanceId
				AND    WorkItemID = @WorkitemId
				AND ActivityId = @ActivityId   
				AND AssignedTo =@userName
				AND TASKSTATUS!=4
			END
		End
		ELSE If(@processInstanceId is not null AND len(@processInstanceId) > 0)
		Begin
			Select	@ProcessInstanceId	= ProcessInstanceId,
				@WorkItemId		= WorkItemId,
				@ProcessName		= ProcessName,
				@ProcessVersion		= ProcessVersion,
				@ProcessDefID		= ProcessDefID,
				@LastProcessedBy	= LastProcessedBy,
				@ProcessedBy		= ProcessedBy,
				@ActivityName		= ActivityName,
				@ActivityId		= ActivityId,
				@EntryDateTime		= EntryDateTime,
				@ParentWorkItemId	= ParentWorkItemId,
				@AssignmentType		= AssignmentType,
				@CollectFlag		= CollectFlag,
				@PriorityLevel		= PriorityLevel,
				@ValidTill		= ValidTill,
				@Q_StreamId		= Q_StreamId,
				@Q_QueueId		= Q_QueueId,
				@Q_UserId		= Q_UserId,
				@AssignedUser		= AssignedUser,
				@FilterValue		= FilterValue,
				@CreatedDateTime	= CreatedDateTime,
				@WorkItemState		= WorkItemState,
				@Statename		= Statename,
				@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
				@PreviousStage		= PreviousStage,
				@LockedByName		= LockedByName,
				@LockStatus		= LockStatus,
				@LockedTime		= LockedTime,
				@Queuename		= Queuename,
				@Queuetype		= Queuetype,
				@NotifyStatus		= NotifyStatus,
				@processVariantId = ProcessVariantId,
				@LastModifiedTime =LastModifiedTime,
				@v_URN = URN
			/*FROM	WorkInProcessTable (NOLOCK) */
			From WFInstrumentTable (NOLOCK) 
			WHERE	ProcessInstanceID = @ProcessInstanceId
			AND	WorkItemID = @WorkitemId
			AND RoutingStatus = 'N'
			AND LockStatus = 'Y'
			
			Select	@rowcount = @@rowcount
			
			IF(@v_ActivityType=32) 
			 BEGIN
				Select @v_CanInitiate= max(CanInitiate) ,@v_showCaseVisual = max(ShowCaseVisual)
				FROM    WFTaskStatusTable (NOLOCK)
				WHERE    ProcessInstanceID = @ProcessInstanceId
				AND    WorkItemID = @WorkitemId
				AND ActivityId = @ActivityId   
				AND AssignedTo =@userName
				AND TASKSTATUS!=4
			END
		End
		Else	/* For FIFO when workitem not in WorkListTable and some workitem is locked in WorkInProcessTable */
		Begin

			Select	TOP 1 
				@ProcessInstanceId	= ProcessInstanceId,
				@WorkItemId		= WorkItemId,
				@ProcessName		= ProcessName,
				@ProcessVersion		= ProcessVersion,
				@ProcessDefID		= ProcessDefID,
				@LastProcessedBy	= LastProcessedBy,
				@ProcessedBy		= ProcessedBy,
				@ActivityName		= ActivityName,
				@ActivityId		= ActivityId,
				@EntryDateTime		= EntryDateTime,
				@ParentWorkItemId	= ParentWorkItemId,
				@AssignmentType		= AssignmentType,
				@CollectFlag		= CollectFlag,
				@PriorityLevel		= PriorityLevel,
				@ValidTill		= ValidTill,
				@Q_StreamId		= Q_StreamId,
				@Q_QueueId		= Q_QueueId,
				@Q_UserId		= Q_UserId,
				@AssignedUser		= AssignedUser,
				@FilterValue		= FilterValue,
				@CreatedDateTime	= CreatedDateTime,
				@WorkItemState		= WorkItemState,
				@Statename		= Statename,
				@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
				@PreviousStage		= PreviousStage,
				@LockedByName		= LockedByName,
				@LockStatus		= LockStatus,
				@LockedTime		= LockedTime,
				@Queuename		= Queuename,
				@Queuetype		= Queuetype,
				@NotifyStatus		= NotifyStatus,
				@processVariantId = ProcessVariantId,/*Process Variant Support Changes*/
				@LastModifiedTime =LastModifiedTime,
				@v_URN = URN
			/*FROM	WorkInProcessTable (NOLOCK)*/
			FROM	WFInstrumentTable (NOLOCK)
			/*WHERE	LockedByName		= @userName*/
			WHERE RoutingStatus =' N' 
			AND LockStatus = 'Y'
			AND LockedByName		= @userName
			AND	Q_QueueId		= @DBQueueId
			AND	NOT ( processInstanceId = @DBLastProcessInstanceId 
					AND workitemId	= @DBLastWorkitemId )
		Select	@rowcount = @@rowcount
			
		End

--		Select	@rowcount = @@rowcount
		IF (@rowcount > 0)
		Begin
			IF(@DBTaskId>0)
			BEGIN
				Select @MainCode = 32			/* Workitem locked, when workitem locked by some other user */
				Select @CheckQueryWSFlag ='N'
			END;
			ELSE If(NOT (@LockedByName = @userName))
			Begin
				IF( @Q_QueueId = 0)
				BEGIN
					Select @CheckQueryWSFlag = 'Y'
					Select	@MainCode = 300
				END
				ELSE
				BEGIN
					Select	@MainCode = 16		/* Workitem locked, when workitem locked by some other user */
					Select @CheckQueryWSFlag = 'N'
				END
			End
			ELSE
			Begin
				If(@DBQueueType = N'F' AND @DBAssignMe = 'Y' AND NOT(@AssignmentType = 'F'))
				Begin
					Select @v_AssignQueueName = @userName + '''s MyQueue'
					/*Update WorkInProcessTable Set AssignmentType = N'F', QueueType = N'U', Q_QueueId = 0, QueueName = @v_AssignQueueName, FilterValue = NULL*/
					Update WFInstrumentTable Set AssignmentType = N'F', QueueType = N'U', Q_QueueId = 0, QueueName = @v_AssignQueueName, FilterValue = NULL
					WHERE	LockedByName		= @userName
					AND	Q_QueueId = @DBQueueId
					AND processInstanceId = @ProcessInstanceId 
							AND workitemId	= @WorkItemId 
				End			
			End
		End
		ELSE
		Begin
			IF(@processInstanceId is not null AND len(@processInstanceId) > 0)
			Begin
				Select @CheckQueryWSFlag = 'Y'
				Select	@MainCode = 300		/* NO Authorization */

				Select	@ProcessInstanceId	= ProcessInstanceId,
					@WorkItemId		= WorkItemId,
					@ProcessName		= ProcessName,
					@ProcessVersion		= ProcessVersion,
					@ProcessDefID		= ProcessDefID,
					@LastProcessedBy	= LastProcessedBy,
					@ProcessedBy		= ProcessedBy,
					@ActivityName		= ActivityName,
					@ActivityId		= ActivityId,
					@EntryDateTime		= EntryDateTime,
					@ParentWorkItemId	= ParentWorkItemId,
					@AssignmentType		= AssignmentType,
					@CollectFlag		= CollectFlag,
					@PriorityLevel		= PriorityLevel,
					@ValidTill		= ValidTill,
					@Q_StreamId		= Q_StreamId,
					@Q_QueueId		= Q_QueueId,
					@Q_UserId		= Q_UserId,
					@AssignedUser		= AssignedUser,
					@FilterValue		= NULL,
					@CreatedDateTime	= CreatedDateTime,
					@WorkItemState		= WorkItemState,
					@Statename		= Statename,
					@ExpectedWorkitemDelay	= NULL,
					@PreviousStage		= PreviousStage,
					@LockedByName		= LockedByName,
					@LockStatus		= LockStatus,
					@LockedTime		= LockedTime,
					@Queuename		= Queuename,
					@Queuetype		= Queuetype,
					@NotifyStatus		= NULL,
					@processVariantId = ProcessVariantId,
					@LastModifiedTime =LastModifiedTime,
					@v_URN = URN/*Process Variant Support Changes*/
				FROM	QueueHistoryTable (NOLOCK)
				WHERE	ProcessInstanceID = @ProcessInstanceId
				AND	WorkItemID = @WorkitemId

				Select	@rowCount = @@rowCount
				IF(@rowCount >=1)
				BEGIN
					SELECT @tableName1='QUEUEHISTORYTABLE'
				END

				IF(@rowcount < 1)
				Begin
					Select	@ProcessInstanceId	= ProcessInstanceId,
						@WorkItemId		= WorkItemId,
						@ProcessName		= ProcessName,
						@ProcessVersion		= ProcessVersion,
						@ProcessDefID		= ProcessDefID,
						@LastProcessedBy	= LastProcessedBy,
						@ProcessedBy		= ProcessedBy,
						@ActivityName		= ActivityName,
						@ActivityId		= ActivityId,
						@EntryDateTime		= EntryDateTime,
						@ParentWorkItemId	= ParentWorkItemId,
						@AssignmentType		= AssignmentType,
						@CollectFlag		= CollectFlag,
						@PriorityLevel		= PriorityLevel,
						@ValidTill		= ValidTill,
						@Q_StreamId		= Q_StreamId,
						@Q_QueueId		= Q_QueueId,
						@Q_UserId		= Q_UserId,
						@AssignedUser		= AssignedUser,
						@FilterValue		= FilterValue,
						@CreatedDateTime	= CreatedDateTime,
						@WorkItemState		= WorkItemState,
						@Statename		= Statename,
						@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
						@PreviousStage		= PreviousStage,
						@LockedByName		= LockedByName,
						@LockStatus		= LockStatus,
						@LockedTime		= LockedTime,
						@Queuename		= Queuename,
						@Queuetype		= Queuetype,
						@NotifyStatus		= NotifyStatus,
						@RoutingStatus  = RoutingStatus,
						@processVariantId = ProcessVariantId,/*Process Variant Support Changes*/
						@v_ActivityType	=ActivityType,
						@LastModifiedTime = LastModifiedTime,
						@v_URN = URN
					/*FROM	PendingWorkListTable (NOLOCK)*/
					FROM WFINSTRUMENTTABLE (NOLOCK)
					WHERE	ProcessInstanceID = @ProcessInstanceId
					AND	WorkItemID = @WorkitemId

					Select	@rowCount = @@rowCount

					IF(@rowcount > 0 ) 
					Begin
						IF(@RoutingStatus = 'R' AND @v_ActivityType <> 2)
						Begin
							If(@Q_UserId = @userIndex)
							Begin
								Select @CheckQueryWSFlag = 'N'
								Select	@MainCode = 16		/* Open WorkItem in Read only mode */
							End
						End
					End
					Else 
					Begin
						IF(@rowcount < 1)
							Begin
								Select	@MainCode = 22 /* Bugzilla Bug 7199, MainCode changed to Invalid_Workitem. */
								Select	@MainCode	MainCode,
									@lockFlag	lockFlag
								Return
							End
					End
					/*IF(@rowcount > 0)
					Begin
						If(@Q_UserId = @userIndex)
						Begin
							Select @CheckQueryWSFlag = 'N'
							Select	@MainCode = 16		// Open WorkItem in Read only mode 
						End 
					End */
					/*ELSE
					Begin
						Select	@ProcessInstanceId	= ProcessInstanceId,
							@WorkItemId		= WorkItemId,
							@ProcessName		= ProcessName,
							@ProcessVersion		= ProcessVersion,
							@ProcessDefID		= ProcessDefID,
							@LastProcessedBy	= LastProcessedBy,
							@ProcessedBy		= ProcessedBy,
							@ActivityName		= ActivityName,
							@ActivityId		= ActivityId,
							@EntryDateTime		= EntryDateTime,
							@ParentWorkItemId	= ParentWorkItemId,
							@AssignmentType		= AssignmentType,
							@CollectFlag		= CollectFlag,
							@PriorityLevel		= PriorityLevel,
							@ValidTill		= ValidTill,
							@Q_StreamId		= Q_StreamId,
							@Q_QueueId		= Q_QueueId,
							@Q_UserId		= Q_UserId,
							@AssignedUser		= AssignedUser,
							@FilterValue		= FilterValue,
							@CreatedDateTime	= CreatedDateTime,
							@WorkItemState		= WorkItemState,
							@Statename		= Statename,
							@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
							@PreviousStage		= PreviousStage,
							@LockedByName		= LockedByName,
							@LockStatus		= LockStatus,
							@LockedTime		= LockedTime,
							@Queuename		= Queuename,
							@Queuetype		= Queuetype,
							@NotifyStatus		= NotifyStatus,
							@processVariantId = ProcessVariantId //Process Variant Support Changes
						FROM	WorkDonetable (NOLOCK)
						WHERE	ProcessInstanceID = @ProcessInstanceId
						AND	WorkItemID = @WorkitemId

						Select	@rowCount = @@rowCount

						IF(@rowcount < 1)
						Begin
							Select	@ProcessInstanceId	= ProcessInstanceId,
								@WorkItemId		= WorkItemId,
								@ProcessName		= ProcessName,
								@ProcessVersion		= ProcessVersion,
								@ProcessDefID		= ProcessDefID,
								@LastProcessedBy	= LastProcessedBy,
								@ProcessedBy		= ProcessedBy,
								@ActivityName		= ActivityName,
								@ActivityId		= ActivityId,
								@EntryDateTime		= EntryDateTime,
								@ParentWorkItemId	= ParentWorkItemId,
								@AssignmentType		= AssignmentType,
								@CollectFlag		= CollectFlag,
								@PriorityLevel		= PriorityLevel,
								@ValidTill		= ValidTill,
								@Q_StreamId		= Q_StreamId,
								@Q_QueueId		= Q_QueueId,
								@Q_UserId		= Q_UserId,
								@AssignedUser		= AssignedUser,
								@FilterValue		= FilterValue,
								@CreatedDateTime	= CreatedDateTime,
								@WorkItemState		= WorkItemState,
								@Statename		= Statename,
								@ExpectedWorkitemDelay	= ExpectedWorkitemDelay,
								@PreviousStage		= PreviousStage,
								@LockedByName		= LockedByName,
								@LockStatus		= LockStatus,
								@LockedTime		= LockedTime,
								@Queuename		= Queuename,
								@Queuetype		= Queuetype,
								@NotifyStatus		= NotifyStatus,
								@processVariantId = ProcessVariantId //Process Variant Support Changes
							FROM	WorkWithPSTable (NOLOCK)
							WHERE	ProcessInstanceID = @ProcessInstanceId
							AND	WorkItemID = @WorkitemId

							Select	@rowCount = @@rowCount

							// Modified on : 22/11/2006, Bug # WFS_5_148 - Ruhi Hira 
							IF(@rowcount < 1)
							Begin
								Select	@MainCode = 22 // Bugzilla Bug 7199, MainCode changed to Invalid_Workitem. 
								Select	@MainCode	MainCode,
									@lockFlag	lockFlag
								Return
							End
						End 
					End */
				End
			End 
			Else
			Begin
				Select	@MainCode = 18			/* NO more data for FIFO when only queueId is given */
				Select	@MainCode	MainCode,
					@lockFlag	lockFlag
				Return
			End
		End /* Else workitem found in WorkInProcessTable */
	End

	IF(@CheckQueryWSFlag = 'Y' )	/*Query WorkStep Handling */
	BEGIN
		/* 21/01/2008, Bugzilla Bug 1721, error code 810 - Ruhi Hira */
		IF(@DBQueueId >= 0 AND ( (@Q_QueueId IS NULL) OR (@DBQueueId != @Q_QueueId)) )
		Begin
			Select	@MainCode = 810 /* Workitem not in the queue specified. */
			Select	@MainCode	MainCode,
				@lockFlag	lockFlag
			Return
		End
		/* ActivityType 11 is for query workstep */
		/*WFS_8.0_031,WFS_8.0_121*/
		IF(@v_UtilityFlag = 'N')	
		BEGIN
			Select Top 1 @QueryActivityId = ActivityTable.ActivityId,
			@v_QueryPreview = QUSERGROUPVIEW.QueryPreview , @v_editableOnQuery=QUSERGROUPVIEW.EditableonQuery,@v_queryQueueId=QueueStreamTable.QueueId
			FROM ActivityTable (NOLOCK), QueueStreamTable (NOLOCK), QUSERGROUPVIEW (NOLOCK)
			WHERE ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId
			AND ActivityTable.ActivityId = QueueStreamTable.ActivityId
			AND QUSERGROUPVIEW.QueueId = QueueStreamTable.QueueId
			AND ActivityTable.ActivityType = 11
			AND ActivityTable.ProcessDefId = @ProcessDefID
			AND QUSERGROUPVIEW.UserId = @userIndex
			ORDER BY QUSERGROUPVIEW.UserId DESC
			Select @rowCount = @@rowCount
			If(@rowCount <= 0)
			Begin
				Select Top 1 @QueryActivityId = ActivityTable.ActivityId,
				@v_QueryPreview = QUSERGROUPVIEW.QueryPreview , @v_editableOnQuery=QUSERGROUPVIEW.EditableonQuery,@v_queryQueueId=QueueStreamTable.QueueId
				FROM ActivityTable (NOLOCK), QueueStreamTable (NOLOCK), QUSERGROUPVIEW (NOLOCK)
				WHERE ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId
				AND ActivityTable.ActivityId = QueueStreamTable.ActivityId
				AND QUSERGROUPVIEW.QueueId = QueueStreamTable.QueueId
				AND ActivityTable.ActivityType = 11
				AND ActivityTable.ProcessDefId = @ProcessDefID
				AND QUSERGROUPVIEW.UserId = @userIndex
				AND QUSERGROUPVIEW.groupid IS NOT NULL
				ORDER BY QUSERGROUPVIEW.UserId DESC
			Select @rowCount = @@rowCount
			If(@rowCount <= 0)	
				Begin
				
					IF(@v_ActivityType = 32)
						BEGIN
							Select @v_CanInitiate= max(CanInitiate)	,@v_showCaseVisual = max(ShowCaseVisual)
							FROM	WFTaskStatusTable (NOLOCK)
							WHERE	ProcessInstanceID = @ProcessInstanceId
							AND	WorkItemID = @WorkitemId
							AND ActivityId = @ActivityId	
							AND AssignedTo =@userName 
							AND TASKSTATUS!=4
							Select @rowCount = @@rowCount
							if(@rowCount <= 0)
								begin
									Select @MainCode = 300 /*No Authorization*/
									Select @MainCode	MainCode,
										   @lockFlag	LockFlag
									Return
								end
							else 
								begin
									Select @MainCode = 16 /*No Authorization*/
								end	
							

						END
					ELSE
						BEGIN
							Select @MainCode = 300 /*No Authorization*/
							Select @MainCode	MainCode,
									@lockFlag	LockFlag
							Return
						END	
				End
				Else
				Begin
					/*WFS_8.0_031*/
					Select @MainCode = 16
					
					/*Need to check filter on query workstep queue */
					SELECT @QueryFilter=QueryFilter FROM QueueUserTable  WITH (NOLOCK)   WHERE QueueId = @v_queryQueueId AND userId = @userIndex AND AssociationType = 0
					SELECT @rowCount = @@rowCount
					IF @rowCount >0
					BEGIN
						IF (@QueryFilter IS NOT NULL)
						BEGIN
							SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserIndex>&',@userIndex+'')))
							SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserName>&',@userName+'')))
							EXECUTE WFParseQueryFilter @QueryFilter, N'U',  @userIndex, @v_ParsedQueryFilter OUT
							SELECT @QueryFilter = @v_ParsedQueryFilter
							SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@QueryFilter)) 
							IF (@v_orderByPos <> 0)  
							BEGIN 
								SELECT @QueryFilter = SUBSTRING(@QueryFilter, 1, @v_orderByPos - 1) 
							END  
						END
					END
					ELSE
					BEGIN
						SELECT @v_QueryStr = 'SELECT QueryFilter, GroupId FROM QUserGroupView WITH (NOLOCK)  WHERE QueueId = ' + CONVERT(NVarchar(10), @v_queryQueueId) + ' AND UserId = '  + CONVERT(NVarchar(10), @userIndex) + ' AND GroupId IS NOT NULL'
						EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
						OPEN CursorQueryFilter
						SELECT @v_counter = 0
						FETCH NEXT FROM CursorQueryFilter INTO @QueryFilter, @v_groupID
						WHILE (@@FETCH_STATUS = 0)
						BEGIN
							SELECT @QueryFilter = LTRIM(RTRIM(@QueryFilter))
							IF (@QueryFilter IS NOT NULL AND LEN(@QueryFilter) > 0)
							BEGIN 
								SELECT @QueryFilter = replace(@QueryFilter, '&<UserIndex>&', @userIndex+'') 
								SELECT @QueryFilter = REPLACE(@QueryFilter, '&<UserName>&', @userName+'')
	
								SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@QueryFilter)) 
								IF (@v_orderByPos <> 0) 
								BEGIN 
									SELECT @QueryFilter = SUBSTRING(@QueryFilter, 1, @v_orderByPos - 1)  
								END
								EXECUTE WFParseQueryFilter @QueryFilter, N'U',  @userIndex, @v_ParsedQueryFilter OUT
								SELECT @QueryFilter = @v_ParsedQueryFilter

								EXECUTE WFParseQueryFilter @QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
								SELECT @QueryFilter = @v_ParsedQueryFilter

								IF (LEN(@QueryFilter) > 0)
								BEGIN
									SELECT @QueryFilter = '(' + @QueryFilter + ')'
									IF (@v_counter = 0) 
									BEGIN 
										SELECT @v_tempFilter = ISNULL(@v_tempFilter, '') + @QueryFilter
									END 
								ELSE  
								BEGIN 
									SELECT @v_tempFilter = @v_tempFilter + ' OR ' + @QueryFilter  
								END  
								SELECT @v_counter = @v_counter + 1 
							END
						END
						ELSE
						BEGIN
							SELECT @v_tempFilter = ''
							BREAK
						END
						FETCH NEXT FROM CursorQueryFilter INTO @QueryFilter, @v_groupID  
					END
					SELECT @QueryFilter = @v_tempFilter
					CLOSE CursorQueryFilter 
					DEALLOCATE CursorQueryFilter 
				END
				
				IF (@QueryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryFilter))) > 0)  
				BEGIN			
					SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)
					IF(@v_FunctionPos <> 0)
					BEGIN	
						SELECT @v_FunLength = LEN('&<FUNCTION>&')
						SELECT @v_functionFlag = 'Y'
						WHILE(@v_functionFlag = 'Y')
						BEGIN					
							SELECT @v_prevFilter = SUBSTRING(@QueryFilter, 0, @v_FunctionPos-1)
							SELECT @v_funPos1 = CHARINDEX('{', @QueryFilter)			
					
							SELECT @v_tempFunStr = SUBSTRING(@QueryFilter, @v_FunctionPos + @v_FunLength, @v_funPos1 - (@v_FunctionPos + @v_FunLength))
							SELECT @v_tempFunStr = LTRIM(RTRIM(@v_tempFunStr));					
					
							IF (@v_tempFunStr IS NULL OR LEN(@v_tempFunStr) = 0)
							BEGIN
								SELECT @v_funPos2 = CHARINDEX('}', @QueryFilter)
								SELECT @v_funFilter = SUBSTRING(@QueryFilter, @v_funPos1 + 1, @v_funPos2 - @v_funPos1 -1)
						
								SELECT @v_postFilter = STUFF(@QueryFilter, 1, @v_funPos2 + 1, NULL)
								SELECT @queryFunStr  = 'SELECT @v_FunValue = dbo.' + @v_funFilter				
						
								EXEC SP_EXECUTESQL
									@query = @queryFunStr, 
									@params = N'@v_FunValue VARCHAR(MAX) OUTPUT', 
									@v_FunValue = @v_FunValue OUTPUT						
										
								IF(ISNULL(@v_FunValue, '') = '')
									SELECT @v_FunValue = '1 = 1'		
						
								SELECT @QueryFilter = @v_prevFilter + ' ' + @v_FunValue + ' ' + @v_postFilter
							END	
							ELSE
							BEGIN
								BREAK
							END							
							SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)					
							IF(@v_FunctionPos = 0)
							BEGIN
								SELECT @v_functionFlag = 'N'
							END					
						END				
					END
				END
				
				IF (@QueryFilter IS NOT NULL AND LEN(@QueryFilter) > 0)
				BEGIN
					SELECT @v_QueryStr = 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable  WITH (NOLOCK)   left outer join VarMappingTable  WITH (NOLOCK)  on WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='+CONVERT(NVarchar(10), @ProcessDefID)+' and WFSearchVariableTable.activityID ='+CONVERT(NVarchar(10), @QueryActivityId)+' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C'' '
					EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
					OPEN CursorQueryFilter
					SELECT @v_finalColumnStr = ''
					SELECT @v_externalTaleJoin='N'
					FETCH NEXT FROM CursorQueryFilter INTO @v_fieldName, @v_extObjId,@v_systemDefinedName
					WHILE (@@FETCH_STATUS = 0)
					BEGIN	
						IF (@v_fieldName IS NOT NULL AND LEN(@v_fieldName) > 0)
						BEGIN
							IF @v_extObjId=1
							BEGIN
								SELECT @v_externalTaleJoin='Y'
								SELECT @v_finalColumnStr=@v_finalColumnStr+' , '+@v_fieldName
							END
							ELSE
							BEGIN
								SELECT @v_finalColumnStr=@v_finalColumnStr+' , '+@v_systemDefinedName+' AS '+@v_fieldName
							END
						END
						FETCH NEXT FROM CursorQueryFilter INTO @v_fieldName, @v_extObjId,@v_systemDefinedName
					END
					CLOSE CursorQueryFilter 
					DEALLOCATE CursorQueryFilter 
					
					/*Checkin user is eligible to open the workitem or not */
					
					SELECT @v_QueryStr='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN '
					
					SELECT @v_query1=' FROM WFINSTRUMENTTABLE WITH (NOLOCK)  '
					
					IF @v_externalTaleJoin='Y'
					BEGIN
						SELECT @v_QueryStr=@v_QueryStr+' , ItemIndex,ItemType '
						
						SELECT @v_query1=' FROM WFINSTRUMENTTABLE WITH (NOLOCK)  INNER JOIN '+@v_extTableName +' WITH (NOLOCK)   ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
						
					END
					
					
					IF (@v_finalColumnStr IS NOT NULL AND LEN(@v_finalColumnStr) > 0)
					BEGIN
						SELECT @v_QueryStr=@v_QueryStr+@v_finalColumnStr
					END
					
					SELECT @v_query1=@v_query1+ ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID= N'''+@ProcessInstanceId+''' AND WFINSTRUMENTTABLE.WorkItemID='+CONVERT(NVarchar(10), @WorkitemId)
					
					SELECT @v_query1='SELECT  @v_tempCount=processdefid from ( '+@v_QueryStr+@v_query1+' ) QUERYTABLE1 WHERE '+@QueryFilter
					
					EXECUTE sp_executesql @v_query1, N'@v_tempCount INT OUTPUT', @v_tempCount = @v_tempCount  OUTPUT
					Select	@rowCount	= @@rowCount
					If(@rowcount <= 0)
					BEGIN 
						
						SELECT @v_QueryStr='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN '
						
						SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) '
					
						IF @v_externalTaleJoin='Y'
						BEGIN
							
							SELECT @v_QueryStr=@v_QueryStr+' , ItemIndex,ItemType '
							
							If @v_extTableNameHistory IS NOT NULL AND LEN(@v_extTableNameHistory) >0
							BEGIN
								SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) INNER JOIN '+@v_extTableNameHistory +' WITH (NOLOCK) ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
							END
							ELSE
							BEGIN
								SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) INNER JOIN '+@v_extTableName +' WITH (NOLOCK) ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
							END
						END
							
						IF (@v_finalColumnStr IS NOT NULL AND LEN(@v_finalColumnStr) > 0)
						BEGIN
							SELECT @v_QueryStr=@v_QueryStr+@v_finalColumnStr
						END
							
						SELECT @v_query1=@v_query1+ ' WHERE QueueHistoryTable.ProcessInstanceID= N'''+@ProcessInstanceId+''' AND QueueHistoryTable.WorkItemID='+CONVERT(NVarchar(10), @WorkitemId)
						SELECT @v_query1='SELECT @v_tempCount=processdefid from ( '+@v_QueryStr+@v_query1+' ) QUERYTABLE1 WHERE '+@QueryFilter
						EXECUTE sp_executesql @v_query1, N'@v_tempCount INT OUTPUT', @v_tempCount = @v_tempCount  OUTPUT
						Select	@rowCount	= @@rowCount
						If(@rowcount <= 0)
						BEGIN
							SELECT MainCode = 300,lockFlag = 'N'
							Return
						END
					END	
				END
				
				
				
				/*filter Check END HERE */
					
					IF @v_editableOnQuery = 'Y' AND @v_QueryPreview='Y'
					BEGIN
						Set @queryStr1=' SELECT TOP 1  @v_exists=processdefid FROM '+@tableName1+' WITH (UPDLOCK,ROWLOCK) WHERE PROCESSINSTANCEID= '''+@ProcessInstanceId +''' AND WORKITEMID= '+@WorkitemId+'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''+ @userName	+'''))'
						Begin Transaction LockWI1
						EXECUTE sp_executesql @queryStr1, N'@v_exists INT OUTPUT', @v_exists = @v_exists  OUTPUT
						Select	@rowCount	= @@rowCount
						If(@rowcount > 0)
						BEGIN
							Select	@Q_UserId	= @userIndex
							Select	@AssignedUser	= @userName
							Select	@LockedByName	= @userName
							Select	@LockStatus	= 'Y'
							Select	@LockedTime	= getDate()
							IF(@tableName1 = 'QUEUEHISTORYTABLE')
							BEGIN
								Update QUEUEHISTORYTABLE Set Q_UserId = @Q_UserId,LockedByName = @LockedByName , LockStatus =@LockStatus,LockedTime = @LockedTime  where ProcessInstanceId = @ProcessInstanceId and WorkItemId = @WorkItemId 
							END
							ELSE
								BEGIN
								Update WFINSTRUMENTTABLE Set Q_UserId = @Q_UserId,LockedByName = @LockedByName , LockStatus =@LockStatus,LockedTime = @LockedTime  where ProcessInstanceId = @ProcessInstanceId and WorkItemId = @WorkItemId 
							END
							

							Select	@rowCount = @@rowCount
							If(@rowcount > 0)
							BEGIN
								Commit Transaction LockWI1
								Select @MainCode = 0
								SELECT @lockFlag='Y'
							END
							ELSE
							BEGIN
								Rollback Transaction LockWI1
								Select @MainCode = 16
							END
						END
						ELSE 
						BEGIN 
							Rollback Transaction LockWI1 
							Select @MainCode = 16 
						END
					END
					
					IF(@v_QueryPreview = 'Y' OR @v_QueryPreview IS NULL)
					BEGIN
						Select @ActivityId = @QueryActivityId
					END
				End
			END
			ELSE
			BEGIN
				Select @MainCode = 16 /*To be shown in Read only mode*/
				
				
				/*Need to check filter on query workstep queue */
					SELECT @QueryFilter=QueryFilter FROM QueueUserTable  WITH (NOLOCK)   WHERE QueueId = @v_queryQueueId AND userId = @userIndex AND AssociationType = 0
					SELECT @rowCount = @@rowCount
					IF @rowCount >0
					BEGIN
						IF (@QueryFilter IS NOT NULL)
						BEGIN
							SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserIndex>&',@userIndex+'')))
							SELECT @QueryFilter =  Ltrim(Rtrim(REPLACE(@QueryFilter ,'&<UserName>&',@userName+'')))
							EXECUTE WFParseQueryFilter @QueryFilter, N'U',  @userIndex, @v_ParsedQueryFilter OUT
							SELECT @QueryFilter = @v_ParsedQueryFilter
							SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@QueryFilter)) 
							IF (@v_orderByPos <> 0)  
							BEGIN 
								SELECT @QueryFilter = SUBSTRING(@QueryFilter, 1, @v_orderByPos - 1) 
							END  
						END
					END
					ELSE
					BEGIN
						SELECT @v_QueryStr = 'SELECT QueryFilter, GroupId FROM QUserGroupView WITH (NOLOCK)  WHERE QueueId = ' + CONVERT(NVarchar(10), @v_queryQueueId) + ' AND UserId = '  + CONVERT(NVarchar(10), @userIndex) + ' AND GroupId IS NOT NULL'
						EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
						OPEN CursorQueryFilter
						SELECT @v_counter = 0
						FETCH NEXT FROM CursorQueryFilter INTO @QueryFilter, @v_groupID
						WHILE (@@FETCH_STATUS = 0)
						BEGIN
							SELECT @QueryFilter = LTRIM(RTRIM(@QueryFilter))
							IF (@QueryFilter IS NOT NULL AND LEN(@QueryFilter) > 0)
							BEGIN 
								SELECT @QueryFilter = replace(@QueryFilter, '&<UserIndex>&', @userIndex+'') 
								SELECT @QueryFilter = REPLACE(@QueryFilter, '&<UserName>&', @userName+'')
	
								SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@QueryFilter)) 
								IF (@v_orderByPos <> 0) 
								BEGIN 
									SELECT @QueryFilter = SUBSTRING(@QueryFilter, 1, @v_orderByPos - 1)  
								END
								EXECUTE WFParseQueryFilter @QueryFilter, N'U',  @userIndex, @v_ParsedQueryFilter OUT
								SELECT @QueryFilter = @v_ParsedQueryFilter

								EXECUTE WFParseQueryFilter @QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
								SELECT @QueryFilter = @v_ParsedQueryFilter

								IF (LEN(@QueryFilter) > 0)
								BEGIN
									SELECT @QueryFilter = '(' + @QueryFilter + ')'
									IF (@v_counter = 0) 
									BEGIN 
										SELECT @v_tempFilter = ISNULL(@v_tempFilter, '') + @QueryFilter
									END 
								ELSE  
								BEGIN 
									SELECT @v_tempFilter = @v_tempFilter + ' OR ' + @QueryFilter  
								END  
								SELECT @v_counter = @v_counter + 1 
							END
						END
						ELSE
						BEGIN
							SELECT @v_tempFilter = ''
							BREAK
						END
						FETCH NEXT FROM CursorQueryFilter INTO @QueryFilter, @v_groupID  
					END
					SELECT @QueryFilter = @v_tempFilter
					CLOSE CursorQueryFilter 
					DEALLOCATE CursorQueryFilter 
				END
				
				IF (@QueryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryFilter))) > 0)  
				BEGIN			
					SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)
					IF(@v_FunctionPos <> 0)
					BEGIN	
						SELECT @v_FunLength = LEN('&<FUNCTION>&')
						SELECT @v_functionFlag = 'Y'
						WHILE(@v_functionFlag = 'Y')
						BEGIN					
							SELECT @v_prevFilter = SUBSTRING(@QueryFilter, 0, @v_FunctionPos-1)
							SELECT @v_funPos1 = CHARINDEX('{', @QueryFilter)			
					
							SELECT @v_tempFunStr = SUBSTRING(@QueryFilter, @v_FunctionPos + @v_FunLength, @v_funPos1 - (@v_FunctionPos + @v_FunLength))
							SELECT @v_tempFunStr = LTRIM(RTRIM(@v_tempFunStr));					
					
							IF (@v_tempFunStr IS NULL OR LEN(@v_tempFunStr) = 0)
							BEGIN
								SELECT @v_funPos2 = CHARINDEX('}', @QueryFilter)
								SELECT @v_funFilter = SUBSTRING(@QueryFilter, @v_funPos1 + 1, @v_funPos2 - @v_funPos1 -1)
						
								SELECT @v_postFilter = STUFF(@QueryFilter, 1, @v_funPos2 + 1, NULL)
								SELECT @queryFunStr  = 'SELECT @v_FunValue = dbo.' + @v_funFilter				
						
								EXEC SP_EXECUTESQL
									@query = @queryFunStr, 
									@params = N'@v_FunValue VARCHAR(MAX) OUTPUT', 
									@v_FunValue = @v_FunValue OUTPUT	

								IF(ISNULL(@v_FunValue, '') = '')
									SELECT @v_FunValue = '1 = 1'
						
								SELECT @QueryFilter = @v_prevFilter + ' ' + @v_FunValue + ' ' + @v_postFilter
							END	
							ELSE
							BEGIN
								BREAK
							END							
							SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @QueryFilter)					
							IF(@v_FunctionPos = 0)
							BEGIN
								SELECT @v_functionFlag = 'N'
							END					
						END				
					END
				END
				
				IF (@QueryFilter IS NOT NULL AND LEN(@QueryFilter) > 0)
				BEGIN
					SELECT @v_QueryStr = 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable  WITH (NOLOCK)   left outer join VarMappingTable  WITH (NOLOCK)  on WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='+CONVERT(NVarchar(10), @ProcessDefID)+' and WFSearchVariableTable.activityID ='+CONVERT(NVarchar(10), @QueryActivityId)+' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C'' '
					EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
					OPEN CursorQueryFilter
					SELECT @v_finalColumnStr = ''
					SELECT @v_externalTaleJoin='N'
					FETCH NEXT FROM CursorQueryFilter INTO @v_fieldName, @v_extObjId,@v_systemDefinedName
					WHILE (@@FETCH_STATUS = 0)
					BEGIN	
						IF (@v_fieldName IS NOT NULL AND LEN(@v_fieldName) > 0)
						BEGIN
							IF @v_extObjId=1
							BEGIN
								SELECT @v_externalTaleJoin='Y'
								SELECT @v_finalColumnStr=@v_finalColumnStr+' , '+@v_fieldName
							END
							ELSE
							BEGIN
								SELECT @v_finalColumnStr=@v_finalColumnStr+' , '+@v_systemDefinedName+' AS '+@v_fieldName
							END
						END
						FETCH NEXT FROM CursorQueryFilter INTO @v_fieldName, @v_extObjId,@v_systemDefinedName
					END
					CLOSE CursorQueryFilter 
					DEALLOCATE CursorQueryFilter 
					
					/*Checkin user is eligible to open the workitem or not */
					
					SELECT @v_QueryStr='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN '
					
					SELECT @v_query1=' FROM WFINSTRUMENTTABLE WITH (NOLOCK)  '
					
					IF @v_externalTaleJoin='Y'
					BEGIN
						SELECT @v_QueryStr=@v_QueryStr+' , ItemIndex,ItemType '
						
						SELECT @v_query1=' FROM WFINSTRUMENTTABLE WITH (NOLOCK)  INNER JOIN '+@v_extTableName+' WITH (NOLOCK)   ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
						
					END
					
					
					IF (@v_finalColumnStr IS NOT NULL AND LEN(@v_finalColumnStr) > 0)
					BEGIN
						SELECT @v_QueryStr=@v_QueryStr+@v_finalColumnStr
					END
					
					SELECT @v_query1=@v_query1+ ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID= N'''+@ProcessInstanceId+''' AND WFINSTRUMENTTABLE.WorkItemID='+CONVERT(NVarchar(10), @WorkitemId)
					
					SELECT @v_query1='SELECT  @v_tempCount=processdefid from ( '+@v_QueryStr+@v_query1+' ) QUERYTABLE1 WHERE '+@QueryFilter
					
					EXECUTE sp_executesql @v_query1, N'@v_tempCount INT OUTPUT', @v_tempCount = @v_tempCount  OUTPUT
					Select	@rowCount	= @@rowCount
					If(@rowcount <= 0)
					BEGIN 
						
						SELECT @v_QueryStr='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN '
						
						SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) '
					
						IF @v_externalTaleJoin='Y'
						BEGIN
							
							SELECT @v_QueryStr=@v_QueryStr+' , ItemIndex,ItemType '
							
							If @v_extTableNameHistory IS NOT NULL AND LEN(@v_extTableNameHistory) >0
							BEGIN
								SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) INNER JOIN '+@v_extTableNameHistory +' WITH (NOLOCK) ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
							END
							ELSE
							BEGIN
								SELECT @v_query1=' FROM QueueHistoryTable WITH (NOLOCK) INNER JOIN '+@v_extTableName +' WITH (NOLOCK) ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType '
							END
						END
							
						IF (@v_finalColumnStr IS NOT NULL AND LEN(@v_finalColumnStr) > 0)
						BEGIN
							SELECT @v_QueryStr=@v_QueryStr+@v_finalColumnStr
						END
							
						SELECT @v_query1=@v_query1+ ' WHERE QueueHistoryTable.ProcessInstanceID= N'''+@ProcessInstanceId+''' AND QueueHistoryTable.WorkItemID='+CONVERT(NVarchar(10), @WorkitemId)
						SELECT @v_query1='SELECT @v_tempCount=processdefid from ( '+@v_QueryStr+@v_query1+' ) QUERYTABLE1 WHERE '+@QueryFilter
						EXECUTE sp_executesql @v_query1, N'@v_tempCount INT OUTPUT', @v_tempCount = @v_tempCount  OUTPUT
						Select	@rowCount	= @@rowCount
						If(@rowcount <= 0)
						BEGIN
							SELECT MainCode = 300,lockFlag = 'N'
							Return
						END
					END	
				END
				
				
				
				/*filter Check END HERE */
				
				IF @v_editableOnQuery = 'Y' AND @v_QueryPreview='Y'
					BEGIN
						Set @queryStr1=' SELECT  TOP 1 @v_exists=processdefid FROM '+@tableName1+' WITH (UPDLOCK,ROWLOCK) WHERE PROCESSINSTANCEID= '''+@ProcessInstanceId +''' AND WORKITEMID= '+convert(NVarchar(10), @WorkitemId)+'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''+ @userName	+'''))'
						Begin Transaction LockWI1
						EXECUTE sp_executesql @queryStr1, N'@v_exists INT OUTPUT', @v_exists = @v_exists  OUTPUT
						Select	@rowCount	= @@rowCount
						If(@rowcount > 0)
						BEGIN
							
							Select	@Q_UserId	= @userIndex
							Select	@AssignedUser	= @userName
							Select	@LockedByName	= @userName
							Select	@LockStatus	= 'Y'
							Select	@LockedTime	= getDate()

							IF(@tableName1 = 'QUEUEHISTORYTABLE')
							BEGIN
								Update QUEUEHISTORYTABLE Set Q_UserId = @Q_UserId,LockedByName = @LockedByName , LockStatus =@LockStatus,LockedTime = @LockedTime  where ProcessInstanceId = @ProcessInstanceId and WorkItemId = @WorkItemId 
							END
							ELSE
								BEGIN
								Update WFINSTRUMENTTABLE Set Q_UserId = @Q_UserId,LockedByName = @LockedByName , LockStatus =@LockStatus,LockedTime = @LockedTime  where ProcessInstanceId = @ProcessInstanceId and WorkItemId = @WorkItemId 
							END 
							
							Select	@rowCount = @@rowCount
							If(@rowcount > 0)
							BEGIN
								Commit Transaction LockWI1
								Select @MainCode = 0
								SELECT @lockFlag='Y'
							END
							ELSE
							BEGIN
								--Rollback Transaction LockWI1
								Select @MainCode = 16
							END
						END
						ELSE 
						BEGIN 
							Rollback Transaction LockWI1 
							Select @MainCode = 16 
						END
					END
				IF(@v_QueryPreview = 'Y' OR @v_QueryPreview IS NULL)
				BEGIN
					Select @ActivityId = @QueryActivityId
				END
			END	
		END
		END
		
		IF(@v_exists ! = 0 AND @lockFlag='Y')
		BEGIN
			Select @v_indexOfSeprator = CHARINDEX(',', @DBGenerateLog)
			If(@v_indexOfSeprator = 0)
			Begin
				
				Select @v_genLog = @DBGenerateLog
				Select @v_WorkStartedLoggingEnabled = @DBGenerateLog
			End
			Else
			Begin
				Select @v_genLog = SUBSTRING(@DBGenerateLog , 1, @v_indexOfSeprator-1)
				Select @v_WorkStartedLoggingEnabled = SUBSTRING(@DBGenerateLog , @v_indexOfSeprator+1 , LEN(@DBGenerateLog))
			End
			
			If(@v_genLog = 'Y' )
			Begin
			
				
				EXECUTE WFGenerateLog 7, @userIndex, @processDefId, @activityId, 0,  @userName, @ActivityName, 0, @ProcessInstanceId, @Q_QueueId, @Queuename, @WorkitemId,  0, 0, null, @processVariantId, 0 , 0 , @v_URN,NULL, @GenLogMainCode OUT
				
			End
		END

		If((@LockedByName = @userName) AND @v_ActivityType=32)
			Begin
				Select @v_CanInitiate = 'Y'		
				Select @v_showCaseVisual = 'Y'
			End
		IF((@MainCode = 0 OR @MainCode = 16 OR @MainCode = 401)  AND @v_genLog = 'Y' AND @v_WorkStartedLoggingEnabled = 'Y')

		BEGIN		
			EXECUTE WFGenerateLog 200, @userIndex, @processDefId, @activityId, 0,  @userName, @ActivityName, 0, @ProcessInstanceId, 0, null, @WorkitemId,  0, 0, null, 0, 0 ,0, @v_URN,NULL, @GenLogMainCode OUT
		END
	
	/* OUTPUT ResultSet1 -> MainCode, lockFlag */
	Select	@MainCode	MainCode, 
		@lockFlag	LockFlag

	/* OUTPUT ResultSet2 -> WorkitemData */
	Select	@userIndex		UserIndex,
		getDate()		CurrentDateTime,
		@ProcessInstanceId	ProcessInstanceId,
		@WorkItemId		WorkItemId,
		@ProcessName		ProcessName,
		@ProcessVersion		ProcessVersion,
		@ProcessDefID		ProcessDefID,
		@ProcessedBy		ProcessedBy,
		@ActivityName		ActivityName,
		@ActivityId		ActivityId,
		@EntryDateTime		EntryDateTime,
		@AssignmentType		AssignmentType,
		@PriorityLevel		PriorityLevel,
		@ValidTill		ValidTill,
		@Q_QueueId		Q_QueueId,
		@Q_UserId		Q_UserId,
		@AssignedUser		AssignedUser,
		@CreatedDateTime	CreatedDateTime,
		@WorkItemState		WorkItemState,
		@Statename		Statename,
		@ExpectedWorkitemDelay	ExpectedWorkitemDelay,
		@PreviousStage		PreviousStage,
		@LockedByName		LockedByName,
		@LockStatus		LockStatus,
		@LockedTime		LockedTime,
		@Queuename		Queuename,
		@Queuetype		Queuetype,
		@userName		UserName,
		@sortFieldStrValue         SortedOn,
		@processVariantId	ProcessVariantId,/*Process Variant Support Changes*/
		@v_CanInitiate CanInitiate,
		@v_showCaseVisual ShowCaseVisual,
		@LastModifiedTime LastModifiedTime,
		@v_URN URN
End

~

Print 'Stored Procedure WFGetWorkitem compiled successfully ........'