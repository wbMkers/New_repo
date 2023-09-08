/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group				: Application � Products
	Product / Project		: WorkFlow 7.0
	Module				: WorkFlow Server
	File Name			: WFFetchWorkList.sql [MSSQL]
	Author				: Tirupati Swaroop Srivastava
	Date written (DD/MM/YYYY)	: 04/03/2007
	Description			: Stored procedure for Dynamic queue for 
					  WFFetchWorkList API.[for SQL SERVER]
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By	Change Description (Bug No. (If Any))
19/05/2007		Varun Bhansaly	In Case Row Count being less than equal to 0, 
							resultset is being returned as NULL. 
							Hence Incorrect Error Message
22/05/2007		Varun Bhansaly	Bugzilla Id 890 (WFFetchWorkList Fails in Case of Dynamic/ 
								WIP Queue and String function being used)
24/05/2007		Ruhi Hira	Bugzilla Bug 945.
05/06/2007		Varun Bhansaly	Bugzilla Bug 1016 (Query on QUserGroupView returns 
							multiple result sets causes exception in Oracle)
13/07/2007		Ruhi Hira	Bugzilla Bug 1390.
18/07/2007		Ashish Mangla	Bugzilla Bug 1297  (RowCount should be the written immediately in the next statement for whic rowcount is to be checked )
06/09/2007		Varun Bhansaly	Added for Support for Complex Query Filters and Generic Queue Filters.
28/09/2007              Shilpi S        Bugzilla Bug 1680 , new parameter is returned for number of workitems returned
19/10/2007		Vikram Kumbhar	Bugzilla Bug 1703, Support for showing 'only unlocked' or 'both locked and unlocked' workitems in worklist
08/01/2008		Ashish Mangla	Bugzilla Bug 1681 (UserName Marco support required)
08/01/2008		Varun Bhansaly	Bugzilla Id 3310
18/12/2008		Ruhi Hira		Bugzilla Bug 7374, variable length issue.
08/09/2009		Harmeet Kaur	WFS_8.0_030 Queue filter not working at a particulat queue.
14/10/09		Ashish Mangla	WFS_8.0_044 TurnAroundTime support in FetchWorklist and SearchWorkitem
27/10/2009		Saurabh Kamal	WFS_8.0_046 (In case user is member of multiple groups which are added to Queue, One group having no filter, then user should be able to view workitems considering 'no filter')
29/10/2009		Indraneel	WFS_8.0_047 Support for sorting on queue variables in fetch worklist.
04/11/2009		Saurabh Kamal	WFS_8.0_052 Return ProcessedBy in FetchWorklist
04/12/2009		Ashish Mangla	WFS_8.0_061 Process Specific Alias Support on MyQueue
23/12/2009		Saurabh Kamal	WFS_8.0_072 Error in Fetchworklist in case of SetFilter on MyQueue
03/08/2010		Vikas Saraswat	WFS_8.0_120 Order by is not working in Queue-User-Assoc Filter and in case of 	 webdesktop FilterString
29/09/2010		Ashish/Abhishek WFS_8.0_136	Support of process specific queue and alias on external table variables.
15/03/2010		Saurabh Kamal	WFS_8.0_153 Support of FUNCTION in QueryFilter
23/05/2011      Vikas Saraswat  Bug 27083 : Order By is not working if inner order is set in queuefilter or user filter
09/06/2011		Saurabh Kamal	Bug 27241 ,New QueueType Introduced on which we need not add Q_Queueid = ? criteria, just we need to consider filters only. No worksteps can be added to this type of queue.
24/06/2011		Saurabh Kamal	Bug 27310, Page batching support in FetchWorklist
03/08/2011      Gaurav Rana     Bug 27833, Support of workitem count in searchworkitem [In queue] and restricting sql injection in input xml.
11/06/2012		Saurabh Kamal	Bug 31397 - Error if alias on CreatedDateTime is defined.
26/09/2012		Shweta Singhal	Bug 35181 - Error code changed for insufficient rights from no more records.
15/01/2013		Preeti Awasthi	Bug 37793 - If username length is exceeding 63 character, workitems not opening if fixed assigned.
07/02/2013		Shweta Singhal	Bug 38263 - Error code changed for No association with Queue.
17/05 2013 		Shweta Singhal	Process Variant Support Changes
29/07/2013		Shweta Singhal	Bug 41579- requested operation failed on newly created queue
30/12/2013    Mohnish Chopra  Changed for Code Optimization 
10/02/2014		Shweta Singhal	Paging will be provided on the basis of pagingFlag
10/06/2014		Kanika Manik	PRD Bug 44140 - Batching not working correctly when filter contains order by on a DATE type field.  
12/06/2014 	    Anwar Danish    PRD Bug 40412 and 40412 merged - WMFetchWorkList API throws exception when FUNCTION filter is available on "No Assignment" Queue  
13/06/2014    Anwar Ali Danish  PRD Bug 38828 merged - Changes done for diversion requirement. CQRId 				CSCQR-00000000050705-Process  
17-06-2014	  Sajid Khan		Bug 46318 - Arabic: Defined Process Variable mapping for any queue, now unable to open the queue.
03/07/2014	  Anwar Danish	    Bug 42138 - PRD Issue in WFFetchWorklist Call: Due to insufficient size of DBUserFilterStr field in WFFetchWorklist filter string was getting truncated.  
11/08/2015	   Mohnish Chopra	Changes for Data Locking issue in Case Management -Returning ActivityType from Call 
10/03/2016	   Kirti Wadhwa		Changes for Bug 59472 - RHEL-7 + Weblogic 12.1.2C + Oracle 11g : Requested filter is invalid on sorting through column. 
15/02/2017		Mohnish Chopra		Merged Changes for Optimization in OF10/OF9 by Sajid/Sanal
24/04/2017		Sajid Khan			Error in WFFetchWorkList.sql [MS SQL] if length of string query returned from Function Filter is larger than 1000 length
30/04/2017		Sajid Khan			Verious Bugs regarding Queue Filter and Query Filter solved.
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
02-08-2017	Shubhankur Manuja	Bug 70876 - The requested filter is invalid.Incorrect syntax near the keyword 'Where'. 
16-08-2017	Mohnish Chopra		Changes for Case Management - Queue variable header alias should allow spaces
09/19/2017		Mohnish Chopra	Changes for Case management - QueueFilter required on Case workstep queue.
17/10/2017	Ambuj Tripathi		Changes for Case Registration requirements, fetch URN in output
1/11/2017   Kumar Kimil         Bug 72917 - WBL+Oracle: Getting error in fetch worklist of My queue if alias has been added on My Queue
02-11-2017	Shubhankur Manuja	Bug Merging - 70858
16-01-2018	Sajid Khan			Bug Merging - 70209 - In embedded view when click on refresh button, open Workitem is disappeared from the list
17-05-2018	Ambuj Tripathi		Bug 77455 - WMFetchWorkList is getting failed if too many alias are defined 
12/09/2018	Ambuj Tripathi		PRDP merging - Bug 80103 - WFGetWorkitem procedure gets hang if function filter returns null
27/03/2019	Ravi Ranjan Kumar	Bug 83660 - Providing support to Global Queue 
03/05/2019	Mohnish Chopra		Need to return SecondaryDBFlag in WFFetchWorkItems api.
16/10/2019	Ambuj Tripathi		Bug 87384 - IBPS 4.0 :: SQL - Variables lengths are not sufficient to contain the query formed in two stored procedures : WFFetchWorkList and WFGetWorkitem
23/01/2020	Ravi Ranjan Kumar	Bug 89725 - Arabic: Batching is not working in WI list.
16/01/2020 Sourabh Tantuway    Bug 90086 - iBPS 4.0 + mssql + oracle + postgres: Support for returning CalendarName in the output of WFFetchWorkItems API, so that Calendar based TAT can be calculated in the post hook.
14/02/2020	Ravi Ranjan Kumar	Bug 90701 - initiating WI from global queue does not move to swimlane and wrong error is shown on Oracle + weblogic 
14/02/2020	Ravi Ranjan Kumar	Bug 90641 - "The requested filter is invalid." error shown on swimlane click 
13/08/2020  Shubham Singla		Bug 94075 - iBPS 4.0 SP1+MSSQL:Sort on Extended Queue Var not working when used with spaces in Alias Name.
18/11/2020 Shubham Singla    Bug 94649 - iBPS 4.0:Issue is coming on clicking the queue when the name length of logged in user is long. 
22/02/2021 Sourabh Tantuway  Bug 98276 - iBPS 5.0 SP1 + mssql : When going to the next page for Work In Progress Queue, getting "Requested Filter is Invalid Error". It is happening when order by clause is applied in user filter
05/10/2021  Ravi Raj Mewara    Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
12/11/2021  Ravi Raj Mewara   Bug 102318 - TATRemaining and TatConsumed feature not working not able to see on WI list.
____________________________________________________________________________________________*/


/* Algorithm :
	1. Check of user session validity 
	2. Prepare filterString to be appended for (the case like loggedin userindex = (!= ) VAR_INT1	[FILTER WI] 
	3. Prepare the QueryFilter to be appended (User Queue asdsociation filter)			[FILTER WI] 
		-> While getting QueryFiler, Also prepare the the order by string for innerOrderBy.
		-> QueryFilter may contain Complex Filters of Type &<UserIndex.*>&/ &<GroupIndex.*>&
		-> Use SP WFParseQueryFilter for complex Query Filter Parsing.
	4. If Query Filter is empty for either of User or Group, for NO Assignment Type Queues only, consider Generic Queue Filter.
	5. if data flag is Y, prepare the alias string  
		-> Also check if the sorting is to be done on Alias, get the order by string for that also 
 
CASES :- 
	1. '&<UserIndex>&' should have a space after it. 
	2. Queue-User-Assoc Filter can contain Order By maximxum upto 5 levels. 
	3. If User member of multiple groups, QuerryFilter will be ORed AND Order By of last (that is having order by) group coming is considered. 
*/ 
/* Bugzilla Id 1680
   a new input parameter is added in WFFetchWorklist-SP returnParam, if 0 -> only list, if 1 -> only count, if 2 -> both count and list
   sp will return count value as out parameter
   MSSQL will fire a count(*) query will similar conditions as for fetching worklist for case returnParam value 1 & 2
*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFFetchWorkList')
BEGIN
	EXECUTE('DROP PROCEDURE WFFetchWorkList')
	PRINT 'PROCEDURE WFFetchWorkList ALREADY EXISTS HENCE OLDER ONE DROPPED'
END

~

CREATE PROCEDURE WFFetchWorkList
(  
		@DBsessionId			INT,  
		@DBqueueId				INT ,  
		@DBsortOrder			NVARCHAR(1) ,  
		@DBorderBy				INT , 
		@DBbatchSize			INT , 
		@DBlastWorkItem			INT , 
		@DBdataFlag				NVARCHAR(1) , 
		@DBFetchLockedFlag		NVARCHAR(1) , /* Bugzilla Bug 1703 */
		@DBlastProcessInstance	NVARCHAR(63) , 
		@DBlastValue			NVARCHAR(2000) , 
		@DBuserFilterStr		NVARCHAR(MAX)  ,
		@DBreturnParam          INT, /* 0 -> only list, if 1 -> only count, if 2 -> both count and list*/
		@DBProcessAlias			NVARCHAR(1) , 
		@DBProcessDefId			INT,
		@DBClientOrderFlag		NVARCHAR(1),
		@DBStartingRecNo		INT,
		@DBPagingFlag			NVARCHAR(1)
) 
AS 

Set NoCount On
	 
DECLARE		@v_DBStatus			INT 
DECLARE		@v_rowCount			INT 	
DECLARE		@v_filterStr			NVARCHAR(100) 
DECLARE		@v_filterOption			INT 
DECLARE		@v_QueryStr			NVARCHAR(max) 
DECLARE		@v_QueryStr1			NVARCHAR(max) 
DECLARE		@v_QueryStr2			VARCHAR(max) 
DECLARE		@v_QueryStr3			VARCHAR(max) 
DECLARE		@v_CountStr			NVARCHAR(MAX) 
DECLARE		@v_CountStr1			NVARCHAR(MAX) 
DECLARE		@v_CountStr2			VARCHAR(8000) 
DECLARE		@v_CountStr3			VARCHAR(8000) 
DECLARE		@v_QDTColStr			VARCHAR(8000) 
DECLARE		@v_WLTColStr			VARCHAR(8000) 
DECLARE		@v_WLTColStr1			VARCHAR(8000) 
DECLARE		@v_UserId			INT 
DECLARE		@v_UserName			NVARCHAR(63) 
DECLARE		@v_queueFilterStr		NVARCHAR(max) 
DECLARE		@v_queueFilterStr1		NVARCHAR(max) 
DECLARE		@v_existsFlag			INT
DECLARE		@v_retval				INT 
DECLARE		@v_QueryFilter			NVARCHAR(max) 
DECLARE		@v_QueryFilterUG		VARCHAR(max) 
DECLARE		@v_QueryFilterQueue		VARCHAR(max) 
DECLARE		@v_CursorQueryFilter	INT 
DECLARE		@v_innerOrderBy			NVARChar(200) 
DECLARE		@v_orderByPos			INT 
DECLARE		@v_tempFilter			NVARCHAR(max) 
DECLARE		@v_counter			INT 
DECLARE		@v_counter1			INT 
DECLARE		@v_noOfCounters			INT /* Bugzilla Bug 1703 */
DECLARE		@v_counterCondition		INT 
DECLARE		@v_CursorAlias			INT 
DECLARE		@v_AliasStr			NVARCHAR(max) 
DECLARE		@v_ExtAlias			NVARCHAR(max)
DECLARE		@v_Param1ExtAlias   NVARCHAR(max)
DECLARE		@v_PARAM1			NVARCHAR(255) 
DECLARE		@v_ALIAS			NVARCHAR(255) 
DECLARE		@v_ToReturn			NVARCHAR(1) 
DECLARE		@v_OrderByStr			NVARChar(2000) 
DECLARE		@v_sortStr			NVARCHAR(6) 
DECLARE		@v_op				CHAR(1) 
DECLARE		@v_sortFieldStr			NVARCHAR(50) 
DECLARE		@v_quoteChar 			CHAR(1) 
DECLARE		@v_tempDataType			NVARCHAR(50) 
DECLARE		@v_TempColumnName		NVARCHAR(256) 
DECLARE		@v_TempColumnVal		NVARCHAR(1000) 
DECLARE		@v_TempSortOrder		NVARCHAR(6) 
DECLARE		@v_TempOperator			NVARCHAR(3) 
DECLARE		@v_lastValueStr			NVARCHAR(1000) 
DECLARE		@v_TemplastValueStr		NVARCHAR(1000) 
DECLARE 	@DBmainCode			INT 
DECLARE 	@DBsubCode				INT 
DECLARE		@v_returnCount                  INT
DECLARE		@v_TempCount			INT
DECLARE		@v_innerOrderByCol1		NVARCHAR(64) 
DECLARE		@v_innerOrderByCol2		NVARCHAR(64) 
DECLARE		@v_innerOrderByCol3		NVARCHAR(64) 
DECLARE		@v_innerOrderByCol4		NVARCHAR(64) 
DECLARE		@v_innerOrderByCol5		NVARCHAR(64) 
DECLARE		@v_innerOrderBySort1		NVARCHAR(6) 
DECLARE		@v_innerOrderBySort2		NVARCHAR(6) 
DECLARE		@v_innerOrderBySort3		NVARCHAR(6) 
DECLARE		@v_innerOrderBySort4		NVARCHAR(6) 
DECLARE		@v_innerOrderBySort5		NVARCHAR(6) 
DECLARE		@v_innerOrderByVal1		NVARCHAR(256) 
DECLARE		@v_innerOrderByVal2		NVARCHAR(256) 
DECLARE		@v_innerOrderByVal3		NVARCHAR(256) 
DECLARE		@v_innerOrderByVal4		NVARCHAR(256) 
DECLARE		@v_innerOrderByVal5		NVARCHAR(256) 
DECLARE		@v_innerOrderByType1		NVARCHAR(50) 
DECLARE		@v_innerOrderByType2		NVARCHAR(50) 
DECLARE		@v_innerOrderByType3		NVARCHAR(50) 
DECLARE		@v_innerOrderByType4		NVARCHAR(50) 
DECLARE		@v_innerOrderByType5		NVARCHAR(50) 
DECLARE		@v_innerOrderByCount		INT 
DECLARE		@v_innerLastValueStr		NVARCHAR(1000) 
DECLARE		@v_CursorLastValue		INT 
DECLARE		@v_reverseOrder			INT 
DECLARE		@v_PositionComma		INT 
DECLARE		@v_prefix			NVARCHAR(50) 
DECLARE		@v_ProcessInstanceId		NVARCHAR(63) 
DECLARE		@v_ProcessdefId			INT 
DECLARE		@v_ProcessName			NVARCHAR(30) 
DECLARE		@v_ActivityId			INT 
DECLARE		@v_ActivityName			NVARCHAR(30) 
DECLARE		@v_PriorityLevel		SMALLINT 
DECLARE		@v_InstrumentStatus		NVARCHAR(1) 
DECLARE		@v_LockStatus			NVARCHAR(1) 
DECLARE		@v_LockedByName			NVARCHAR(63)  
DECLARE		@v_ValidTill			DATETIME 
DECLARE		@v_CreatedByName		NVARCHAR(63) 
DECLARE		@v_CreatedDateTime		DATETIME 
DECLARE		@v_StateName			NVARCHAR(255) 
DECLARE		@v_CheckListCompleteFlag	NVARCHAR(1) 
DECLARE		@v_EntryDateTime		DATETIME 
DECLARE		@v_LockedTime			DATETIME 
DECLARE		@v_IntroductionDateTime		DATETIME 
DECLARE		@v_IntroducedBy			NVARCHAR(63) 
DECLARE		@v_AssignedUser			NVARCHAR(70) 
DECLARE		@v_WorkitemId			INT 
DECLARE		@v_QueueName			NVARCHAR(63)  
DECLARE		@v_AssignmentType		NVARCHAR(1) 
DECLARE		@v_ProcessInstanceState		INT 
DECLARE		@v_QueueType			NVARCHAR(1) 
DECLARE		@v_Status			NVARCHAR(255) 
DECLARE		@v_Q_QueueId			INT 
DECLARE		@v_ReferredByName		NVARCHAR(63) 
DECLARE		@v_ReferredTo			INT 
DECLARE		@v_Q_UserId			INT 
DECLARE		@v_FilterValue			NVARCHAR(max)	/*WFS_8.0_030*/ 
DECLARE		@v_Q_StreamId			INT 
DECLARE		@v_Collectflag			NVARCHAR(1) 
DECLARE		@v_ParentWorkitemId		INT 
DECLARE		@v_ProcessedBy			NVARCHAR(63) 
DECLARE		@v_LastProcessedBy		INT 
DECLARE		@v_ProcessVersion		SMALLINT 
DECLARE		@v_WorkItemState		INT 
DECLARE		@v_PreviousStage		NVARCHAR(30) 
DECLARE		@v_ExpectedWorkItemDelay	DATETIME 
DECLARE		@v_VAR_INT1			SMALLINT 
DECLARE		@v_VAR_INT2			SMALLINT 
DECLARE		@v_VAR_INT3			SMALLINT 
DECLARE		@v_VAR_INT4			SMALLINT 
DECLARE		@v_VAR_INT5			SMALLINT 
DECLARE		@v_VAR_INT6			SMALLINT 
DECLARE		@v_VAR_INT7			SMALLINT 
DECLARE		@v_VAR_INT8			SMALLINT 
DECLARE		@v_VAR_FLOAT1			NUMERIC(15,2)   
DECLARE		@v_VAR_FLOAT2			NUMERIC(15,2)  
DECLARE		@v_VAR_DATE1			DATETIME 
DECLARE		@v_VAR_DATE2			DATETIME 
DECLARE		@v_VAR_DATE3			DATETIME 
DECLARE		@v_VAR_DATE4			DATETIME 
DECLARE		@v_VAR_DATE5			DATETIME
DECLARE		@v_VAR_DATE6			DATETIME 
DECLARE		@v_VAR_LONG1			INT 
DECLARE		@v_VAR_LONG2			INT 
DECLARE		@v_VAR_LONG3			INT 
DECLARE		@v_VAR_LONG4			INT 
DECLARE		@v_VAR_LONG5			INT
DECLARE		@v_VAR_LONG6			INT 
DECLARE		@v_VAR_STR1			NVARCHAR(255) 
DECLARE		@v_VAR_STR2			NVARCHAR(255) 
DECLARE		@v_VAR_STR3			NVARCHAR(255) 
DECLARE		@v_VAR_STR4			NVARCHAR(255) 
DECLARE		@v_VAR_STR5			NVARCHAR(255) 
DECLARE		@v_VAR_STR6			NVARCHAR(255) 
DECLARE		@v_VAR_STR7			NVARCHAR(255) 
DECLARE		@v_VAR_STR8			NVARCHAR(255)
DECLARE		@v_VAR_STR9			NVARCHAR(255)
DECLARE		@v_VAR_STR10		NVARCHAR(255)
DECLARE		@v_VAR_STR11 		NVARCHAR(255)
DECLARE		@v_VAR_STR12		NVARCHAR(255)
DECLARE		@v_VAR_STR13		NVARCHAR(255)
DECLARE		@v_VAR_STR14		NVARCHAR(255)
DECLARE		@v_VAR_STR15		NVARCHAR(255)
DECLARE		@v_VAR_STR16		NVARCHAR(255)
DECLARE		@v_VAR_STR17		NVARCHAR(255)
DECLARE		@v_VAR_STR18		NVARCHAR(255)
DECLARE		@v_VAR_STR19		NVARCHAR(255)
DECLARE		@v_VAR_STR20		NVARCHAR(255)  
DECLARE		@v_ParsedQueryFilter NVARCHAR(max)
DECLARE		@v_groupID			INT 
DECLARE		@v_QueueFilter			NVARCHAR(max) 
DECLARE		@v_TempQueryFilter		NVARCHAR(max)
DECLARE		@v_AliasProcessFilter	NVARCHAR(max)
DECLARE		@v_ProcessFilter	NVARCHAR(max)
DECLARE		@v_CommonProcessQuery	NVARCHAR(255)
DECLARE		@v_CommonTempId			INT
DECLARE		@v_CommonTableCount		INT
DECLARE		@v_CommonProcessDefId 	INT
DECLARE     @v_outAliasProcessDefId        INT
DECLARE		@v_CommonProcessCounter	INT
DECLARE		@v_tableName      NVARCHAR(50)
DECLARE		@v_CountCursor                 INT
DECLARE		@v_VariableId1			INT
DECLARE		@v_JoinExtTable			INT
DECLARE		@v_extTableName		NVARCHAR(50)
DECLARE		@v_extTable_QDT_JoinStr		NVARCHAR(256)
DECLARE		@v_SearchQueueType		NVARCHAR(1)
DECLARE		@v_RowIdQuery			NVARCHAR(50)
DECLARE		@v_extTable_WFI_JoinStr	    NVARCHAR(2000)

DECLARE		@v_FunctionPos		INT
DECLARE		@v_funPos1			INT
DECLARE		@v_funPos2			INT
DECLARE		@v_FunValue			VARCHAR(MAX)
DECLARE		@queryFunStr		NVARCHAR(MAX)
DECLARE		@v_functionFlag		NVARCHAR(1)
DECLARE		@v_prevFilter		VARCHAR(MAX)
DECLARE		@v_funFilter		NVARCHAR(MAX)
DECLARE		@v_postFilter		VARCHAR(MAX)
DECLARE		@v_tempFunStr  		NVARCHAR(MAX)
DECLARE		@v_FunLength		INT
DECLARE  	@v_tableNameFilter	NVARCHAR(max)
DECLARE  	@routingFilterString	NVARCHAR(max)
DECLARE  	@qdtColString 		VARCHAR(8000) 
DECLARE 	@v_NullFlag		VARCHAR(2)
DECLARE		@Params 		NVARCHAR(500)
BEGIN 
	SELECT @DBmainCode = 0 
	SELECT @DBsubCode = 0 
	SELECT @v_returnCount = 0 /*Bugzilla Id 1680*/
	SELECT @v_CommonProcessDefId = 0
	SELECT @v_AliasProcessFilter = ' AND ProcessDefId = 0 '
	SELECT @v_VariableId1 = 0
	SELECT @v_JoinExtTable = 0 /*	Default 0 means External Table join not required.*/
	SELECT @v_quoteChar = CHAR(39)  
	SELECT @v_SearchQueueType = N'T'
	SELECT @v_NullFlag ='Y'
	/* Check for session validity ... */  
	BEGIN 
		SELECT @v_UserId = UserID, @v_UserName = UserName  
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = @DBsessionId 

		SELECT @v_rowcount = @@ROWCOUNT  
		SELECT @v_DBStatus = @@ERROR 
	END 


	IF (@v_DBStatus <> 0 OR @v_rowcount <= 0) 
	BEGIN 
		SELECT @DBmainCode = 11     /* Invalid Session */
		SELECT @DBsubCode = 0 
		SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount/*Bugzilla Id 1680*/
		RETURN 
	END
	
	--SELECT @v_queueFilterStr = ' WHERE 1 = 1 '  
	/* Add filer on the basis of queue ... */  
	/* 
		For Search  @DBqueueId = -1
		For MyQueue @DBqueueId = 0
	*/
	IF (@DBqueueId > 0)  
	BEGIN 
		--SELECT @v_queueFilterStr = ' Q_QueueId = ' + CONVERT(NVarchar(10),@DBqueueId) + ' ' 

		/* Checking Whether or not the User has rights on the Queue */
		/* Changed By Varun Bhansaly On 05/06/2007 for Bugzilla Bug 1016 */
		BEGIN  
			SELECT TOP 1 @v_existsFlag = 1
			FROM QUserGroupView 
			WHERE QueueId = @DBqueueId And 
				  UserId = @v_UserId 

			SELECT @v_rowcount = @@ROWCOUNT	 
			IF (@v_rowcount <= 0) 
			BEGIN 
				SELECT @DBmainCode = 300  
				SELECT @DBsubCode = 810  
				SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount/*Bugzilla Id 1680*/
				RETURN  
			END  
		END  
		
		SELECT @v_filterOption = FilterOption, @v_FilterValue = FilterValue, @v_QueueType = QueueType, @v_QueueFilter = QueueFilter, @v_ProcessName = ProcessName	/*WFS_8.0_030*/ 
		FROM QueueDeftable (NOLOCK) 
		WHERE QueueID = @DBqueueId 

		SELECT @v_rowcount = @@ROWCOUNT 

		IF(@v_rowcount > 0)  
		BEGIN 
			IF (@v_QueueType = 'G' OR @v_QueueType = 'Q') /* Q_QueueId filter considered in case not filter Queue*/
			BEGIN
				SELECT @DBmainCode = 18  
				SELECT @DBsubCode = 0  
				SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount
				RETURN  
			END
			
			IF (@v_QueueType <> @v_SearchQueueType AND @v_QueueType <> 'G') /* Q_QueueId filter considered in case not filter Queue*/
			BEGIN
				--SELECT @v_queueFilterStr = ' Where  Q_QueueId = ' + CONVERT(NVarchar(10),@DBqueueId) + ' ' 	
				--SELECT @v_queueFilterStr1 = ' AND Q_QueueId = ' + CONVERT(NVarchar(10),@DBqueueId) + ' ' 
				SELECT @v_queueFilterStr = ' Where  Q_QueueId =  @DBqueueId '
				SELECT @v_queueFilterStr1 = ' AND Q_QueueId = @DBqueueId' 
				
			END
			IF(@v_filterOption = 2) 
			BEGIN 
				SELECT @v_filterStr = ' AND ' + @v_FilterValue  + ' = ' + CONVERT(NVarchar(10), @v_UserId)	/*WFS_8.0_030*/ 
			END 
			ELSE IF(@v_filterOption = 3) 
			BEGIN 
				SELECT @v_filterStr = ' AND ' + @v_FilterValue  + ' != ' + CONVERT(NVarchar(10), @v_UserId)	/*WFS_8.0_030*/ 
			END  
			
			
			IF (@v_ProcessName IS NOT NULL) 
				Select @v_extTableName = TableName from ExtDbConfTable (NOLOCK) 
				where ProcessDefId = 
					(Select Max(ProcessDefId) from ProcessDefTable (NOLOCK) WHERE processName = @v_ProcessName) 
				and ExtObjId = 1
						
		END 

		/* QueryFilter to be evaluated... */  
		IF (@v_QueueType <> 'D' AND @v_QueueType <> 'd')
		BEGIN
		BEGIN 
			/* Case -> Check Whether a Filter is Associated with a User */
			SELECT @v_QueryFilter = QueryFilter   
			FROM QueueUserTable (NOLOCK) 
			WHERE QueueId = @DBqueueId AND UserId = @v_UserId AND AssociationType = 0
			
			SELECT @v_rowcount = @@ROWCOUNT 
		END 
		IF(@v_rowcount > 0)  
		BEGIN 
			IF (@v_QueryFilter IS NOT NULL) 
			BEGIN 
				SELECT @v_QueryFilter = REPLACE(@v_QueryFilter, '&<UserIndex>&', @v_UserId) 
				SELECT @v_QueryFilter = REPLACE(@v_QueryFilter, '&<UserName>&', @v_UserName) 
				EXECUTE WFParseQueryFilter @v_QueryFilter, N'U', @v_UserId, @v_ParsedQueryFilter OUT
				/* As per specifications, User Filters will not contain &<GroupIndex.*>&. Hence ignored */
				SELECT @v_QueryFilter = @v_ParsedQueryFilter
				SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@v_QueryFilter)) 
				IF (@v_orderByPos <> 0)  
				BEGIN 
					IF (@DBClientOrderFlag = N'N') 
						SELECT @v_innerOrderBy = SUBSTRING(@v_queryFilter, @v_orderByPos + LEN('ORDER BY'), LEN(@v_queryFilter))
					SELECT @v_queryFilter = SUBSTRING(@v_queryFilter, 1, @v_orderByPos - 1) 
				END  
			END  
		END 
		ELSE 
		BEGIN 
			/* User is not directly associated in Queue, rather is showing like this due to some group is added in queue and user is added in that group*/  
			/* Case -> Group is Associated With the Queue and User is added in that group */
			SELECT @v_QueryStr = 'SELECT QueryFilter, GroupId FROM QUserGroupView WHERE QueueId = ' + CONVERT(NVarchar(10), @DBqueueId) + ' AND UserId = '  + CONVERT(NVarchar(10), @v_UserId) + ' AND GroupId IS NOT NULL'  
			EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
			OPEN CursorQueryFilter 

			/* Fetch next row and close cursor in case of error */  
			SELECT @v_counter = 0
			FETCH NEXT FROM CursorQueryFilter INTO @v_QueryFilter, @v_groupID
			WHILE (@@FETCH_STATUS = 0)  
			BEGIN 
				SELECT @v_QueryFilter = LTRIM(RTRIM(@v_queryFilter))
				IF (@v_QueryFilter IS NOT NULL AND LEN(@v_queryFilter) > 0) 
				BEGIN 
					SELECT @v_QueryFilter = replace(@v_QueryFilter, '&<UserIndex>&', @v_UserId) 
					SELECT @v_QueryFilter = REPLACE(@v_QueryFilter, '&<UserName>&', @v_UserName)

					SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@v_QueryFilter)) 
					IF (@v_orderByPos <> 0) 
					BEGIN 
						IF (@DBClientOrderFlag = N'N')/*WFS_8.0_120*/
						  SELECT @v_innerOrderBy = SUBSTRING(@v_queryFilter, @v_orderByPos + LEN('ORDER BY'), LEN(@v_queryFilter))
						  SELECT @v_queryFilter = SUBSTRING(@v_queryFilter, 1, @v_orderByPos - 1)  
					END  
					/* User Filters can contain &<UserIndex.*>& */
					EXECUTE WFParseQueryFilter @v_QueryFilter, N'U', @v_UserId, @v_ParsedQueryFilter OUT
					SELECT @v_QueryFilter = @v_ParsedQueryFilter

					EXECUTE WFParseQueryFilter @v_QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
					SELECT @v_QueryFilter = @v_ParsedQueryFilter

					IF (LEN(@v_queryFilter) > 0)
					BEGIN
						/* If multiple groups added to the queue and if logged in user is a member of more than 1 group, 
						 *	all such group filters to be ORed together. 
						 */
						SELECT @v_queryFilter = '(' + @v_queryFilter + ')'
						IF (@v_counter = 0) 
						BEGIN 
							SELECT @v_tempFilter = ISNULL(@v_tempFilter, '') + @v_queryFilter
						END 
						ELSE  
						BEGIN 
							SELECT @v_tempFilter = @v_tempFilter + ' OR ' + @v_queryFilter  
						END  
						SELECT @v_counter = @v_counter + 1 
					END
				END
				/* WFS_8.0_046 */
				ELSE
				BEGIN
					SELECT @v_tempFilter = ''
					BREAK
				END
				FETCH NEXT FROM CursorQueryFilter INTO @v_QueryFilter, @v_groupID  
			END 
			 
			SELECT @v_queryFilter = @v_tempFilter
			/* Close and DeAllocate the CURSOR */ 
			CLOSE CursorQueryFilter 
			DEALLOCATE CursorQueryFilter 
		END
		END
		
		SELECT @v_QueryFilterUG =''
		SELECT @v_QueryFilterUG = @v_queryFilter
		BEGIN /* Query Filter IS NULL, for No Assignment Queues, check for Queue Filter */
			IF ((@v_QueueType = N'N' OR @v_QueueType = N'T' OR @v_QueueType = N'M') AND @v_queueFilter IS NOT NULL AND LEN(@v_queueFilter) > 0)
			BEGIN
				SELECT @v_queryFilter = LTRIM(RTRIM(@v_queueFilter))
				SELECT @v_QueryFilter = REPLACE(@v_QueryFilter, '&<UserIndex>&', @v_UserId) 
				SELECT @v_QueryFilter = REPLACE(@v_QueryFilter, '&<UserName>&', @v_UserName)
				SELECT @v_orderByPos = CHARINDEX('ORDER BY', UPPER(@v_QueryFilter)) 
				IF (@v_orderByPos <> 0) 
				BEGIN 
					IF (@DBClientOrderFlag = N'N')/*WFS_8.0_120*/				
					SELECT @v_innerOrderBy = SUBSTRING(@v_queryFilter, @v_orderByPos + LEN('ORDER BY'), LEN(@v_queryFilter))
					SELECT @v_queryFilter = SUBSTRING(@v_queryFilter, 1, @v_orderByPos - 1)  
				END  
				EXECUTE WFParseQueryFilter @v_QueryFilter, N'U', @v_UserId, @v_ParsedQueryFilter OUT
				SELECT @v_QueryFilter = @v_ParsedQueryFilter
				SELECT @v_TempQueryFilter = @v_queryFilter
				SELECT @v_QueryStr = 'SELECT GroupId FROM QUserGroupView WHERE QueueId = ' + CONVERT(NVarchar(10), @DBqueueId) + ' AND UserId = '  + CONVERT(NVarchar(10), @v_UserId) + ' AND GroupId IS NOT NULL'  
				EXECUTE('DECLARE CursorQueryFilter CURSOR Fast_Forward FOR ' + @v_QueryStr) 
				OPEN CursorQueryFilter 
				/* Fetch next row and close cursor in case of error */  
				SELECT @v_counter = 0
				SELECT @v_QueryFilterQueue = ''
				SELECT @v_tempFilter = ''
				FETCH NEXT FROM CursorQueryFilter INTO @v_groupID
				WHILE (@@FETCH_STATUS = 0)  
				BEGIN
					/** User can be member of multiple groups, for each of the groups, replace &<GroupIndex.*>& with respective values.
					  * If logged in user is member of 2 groups and both of the groups have rights on the Queue.
					  * Parsed version of filter VAR_INT1 = 1000 AND VAR_STR1 = &<GroupIndex.City>& will be like
					  * ((VAR_INT1 =1000 AND VAR_STR1 = 'Pune') OR (VAR_INT1 =1000 AND VAR_STR1 = 'Kolkata'))
					  * Though it should be like ((VAR_INT1 =1000 AND (VAR_STR1 = 'Pune' OR VAR_STR1 = 'Kolkata'))
					*/
					SELECT @v_QueryFilter = @v_TempQueryFilter 
					EXECUTE WFParseQueryFilter @v_QueryFilter, N'G', @v_groupID, @v_ParsedQueryFilter OUT
					SELECT @v_QueryFilter = @v_ParsedQueryFilter
					IF (LEN(@v_queryFilter) > 0)
					BEGIN
						SELECT @v_queryFilter = '(' + @v_queryFilter + ')'
						IF (@v_counter = 0) 
						BEGIN 
							SELECT @v_tempFilter = ISNULL(@v_tempFilter, '') + @v_queryFilter
						END 
						ELSE  
						BEGIN 
							SELECT @v_tempFilter = @v_tempFilter + ' OR ' + @v_queryFilter  
						END  
						SELECT @v_counter = @v_counter + 1 
					END
					FETCH NEXT FROM CursorQueryFilter INTO @v_groupID  
				END 
				
				IF(@v_tempFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_tempFilter))) > 0 )
				BEGIN
					SELECT @v_queryFilter = @v_tempFilter 
				END
				IF (LEN(@v_queryFilter) > 0)
					--SELECT @v_queryFilter = ' AND ( ' + @v_queryFilter +')'
					SELECT @v_QueryFilterQueue = @v_queryFilter
				/* Close and DeAllocate the CURSOR */ 
				CLOSE CursorQueryFilter 
				DEALLOCATE CursorQueryFilter 
			END
		END
		IF(@v_queryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_queryFilter))) > 0)
		BEGIN
			IF((@v_QueryFilterUG IS NOT NULL AND LEN(LTRIM(RTRIM(@v_QueryFilterUG))) > 0) AND
			(@v_QueryFilterQueue IS NOT NULL AND LEN(LTRIM(RTRIM(@v_QueryFilterQueue))) > 0))
				SELECT @v_queryFilter = ' AND ( ' + @v_QueryFilterUG+ ' AND '+@v_QueryFilterQueue+')'
			ELSE IF(@v_QueryFilterUG IS NULL OR @v_QueryFilterUG = '')
				SELECT @v_queryFilter = ' AND ( ' + @v_QueryFilterQueue+')'
			ELSE IF(@v_QueryFilterQueue IS NULL OR @v_QueryFilterQueue = '')
				SELECT @v_queryFilter = ' AND ( ' + @v_QueryFilterUG+')'
		END
	END 
	ELSE 
	BEGIN 
		IF (@DBProcessAlias = N'Y' AND @DBProcessDefId = -1) 
		BEGIN
			SELECT @v_Counter = 0
			SELECT @v_CommonTableCount = 0
			WHILE (@v_Counter < 1) 
 			BEGIN /* Bugzilla Bug 1703 */
				IF (@v_Counter = 0) 
				BEGIN
					SELECT @v_tableNameFilter = ' AND RoutingStatus in ( ' +@v_quoteChar + 'N'+ @v_quoteChar + ',' + @v_quoteChar + 'R' + @v_quoteChar+ ') AND ACTIVITYTYPE!=32'
				END
				/*ELSE IF (@v_Counter = 1) 
				BEGIN
					SELECT @v_tableName = 'WorkInProcessTable'
   				END
				ELSE IF (@v_Counter = 2)
				BEGIN
					SELECT @v_tableName = 'PendingWorkListTable'
				END
				*/
				SELECT @v_Counter = @v_Counter + 1
				/*SELECT @v_CommonProcessQuery = 'SELECT DISTINCT ProcessDefId from ' + @v_tableName*/
				SELECT @v_CommonProcessQuery = 'SELECT DISTINCT ProcessDefId from WFInstrumentTable (NOLOCK) WHERE 1 = 1 ' + @v_tableNameFilter 
				IF (@DBuserFilterStr IS NOT NULL) 
				BEGIN
					SELECT @v_CommonProcessQuery = @v_CommonProcessQuery + ' AND Q_USERID = ' + CONVERT(NVarchar(10), @v_UserId)
				END
				
				EXECUTE('DECLARE CommonProcessCursor CURSOR Fast_Forward FOR ' + @v_CommonProcessQuery) 
				OPEN CommonProcessCursor 
				SELECT @v_CommonProcessCounter = 0
				
				FETCH NEXT FROM CommonProcessCursor INTO @v_CommonTempId
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_CommonProcessCounter = @v_CommonProcessCounter + 1
					if (@v_CommonProcessCounter > 1) 
					BEGIN
						BREAK
					END
					FETCH NEXT FROM CommonProcessCursor INTO @v_CommonTempId
				END 
				CLOSE CommonProcessCursor
				DEALLOCATE CommonProcessCursor

				IF (@v_CommonProcessCounter = 1)
				BEGIN
					IF (@v_CommonTableCount = 0) 
						BEGIN
						SELECT @v_CommonProcessDefId = @v_CommonTempId
						SELECT @v_CommonTableCount =  @v_CommonTableCount + 1
						END
						ELSE IF (@v_CommonProcessDefId <> @v_CommonTempId) 
						BEGIN
							SELECT @v_CommonProcessDefId = 0
							BREAK
						END
				END
				ELSE IF (@v_CommonProcessCounter > 1) 
				BEGIN
					SELECT @v_CommonProcessDefId = 0
					BREAK
				END				
			END
			SELECT @v_AliasProcessFilter = ' AND ProcessDefId = ' + CONVERT(NVarchar(10), @v_CommonProcessDefId)
			SELECT @v_outAliasProcessDefId = @v_CommonProcessDefId 
		END
		ELSE IF (@DBProcessAlias = N'Y' AND @DBProcessDefId > -1) 
		BEGIN
			IF (@DBProcessDefId > 0 ) 
			BEGIN
				SELECT @v_AliasProcessFilter = ' AND ProcessDefId = ' + CONVERT(NVarchar(10), @DBProcessDefId)
				SELECT @v_ProcessFilter = ' AND ProcessDefId = ' + CONVERT(NVarchar(10), @DBProcessDefId)
				SELECT @v_outAliasProcessDefId = @DBProcessDefId
			END
		END
		
	END

	IF (@v_queryFilter IS NOT NULL AND LEN(LTRIM(RTRIM(@v_queryFilter))) > 0)  
		BEGIN			
			SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @v_QueryFilter)
			IF(@v_FunctionPos <> 0)
			BEGIN	
			SELECT @v_FunLength = LEN('&<FUNCTION>&')
			SELECT @v_functionFlag = 'Y'
			WHILE(@v_functionFlag = 'Y')
				BEGIN					
					SELECT @v_prevFilter = SUBSTRING(@v_QueryFilter, 0, @v_FunctionPos-1)
					SELECT @v_funPos1 = CHARINDEX('{', @v_QueryFilter)			
					
					SELECT @v_tempFunStr = SUBSTRING(@v_QueryFilter, @v_FunctionPos + @v_FunLength, @v_funPos1 - (@v_FunctionPos + @v_FunLength))
					SELECT @v_tempFunStr = LTRIM(RTRIM(@v_tempFunStr))					
					
					IF (@v_tempFunStr IS NULL OR LEN(@v_tempFunStr) = 0)
					BEGIN
						SELECT @v_funPos2 = CHARINDEX('}', @v_QueryFilter)
						SELECT @v_funFilter = SUBSTRING(@v_QueryFilter, @v_funPos1 + 1, @v_funPos2 - @v_funPos1 -1)
						
						SELECT @v_postFilter = STUFF(@v_QueryFilter, 1, @v_funPos2 + 1, NULL)						
						IF(@v_postFilter IS NULL OR LEN(@v_postFilter) = 0)
						BEGIN
							IF(CHARINDEX('(', @v_prevFilter) <> 0)
							BEGIN
								SELECT @v_postFilter = ')'
							END
						END							
						SELECT @queryFunStr  = 'SELECT @v_FunValue = dbo.' + @v_funFilter				
						
						EXEC SP_EXECUTESQL
							@query = @queryFunStr, 
							@params = N'@v_FunValue NVARCHAR(MAX) OUTPUT', 
							@v_FunValue = @v_FunValue OUTPUT						

						IF(ISNULL(@v_FunValue, '') = '')
							SELECT @v_FunValue = '1 = 1'

						SELECT @v_QueryFilter = @v_prevFilter + ' ' + @v_FunValue + ' ' + @v_postFilter
					END	
					ELSE
					BEGIN
						BREAK
					END							
					SELECT @v_FunctionPos = CHARINDEX('&<FUNCTION>&', @v_QueryFilter)					
					IF(@v_FunctionPos is null OR @v_FunctionPos = 0)
					BEGIN
						SELECT @v_functionFlag = 'N'
					END					
				END				
			END
		END	

	/* Bugzilla Bug 1390, Alias on system variables not working, 13/07/2007 - Ruhi Hira */
	IF (@DBdataFlag = N'Y' OR  @DBorderBy > 100 OR @v_queryFilter is NOT NULL OR @DBreturnParam=1)  
	BEGIN  
		SELECT @v_QueryStr = 'SELECT PARAM1, ALIAS, ToReturn, VariableId1 FROM VarAliasTable (NOLOCK) WHERE QueueId = ' + CONVERT(NVarchar(10), @DBqueueId) + ISNULL(@v_AliasProcessFilter, '') + ' ORDER BY ID ASC' 
		
		EXECUTE ('DECLARE CursorAlias CURSOR Fast_Forward FOR ' + @v_QueryStr) 

		OPEN CursorAlias 

		/* Fetch next row and close cursor in case of error */  
		SELECT @v_counter = 0    
		FETCH NEXT FROM CursorAlias INTO @v_PARAM1, @v_ALIAS, @v_ToReturn, @v_VariableId1
		WHILE (@@FETCH_STATUS = 0)  
		BEGIN 
			SELECT @v_counter = @v_counter + 1 
			IF (@v_ToReturn = N'Y') 
			BEGIN 
				IF(@v_PARAM1 = Upper('CreatedDateTime')) 
				BEGIN 
					SELECT @v_PARAM1 = 'WFInstrumentTable.' + @v_PARAM1 
				END 
				IF(@v_VariableId1 < 157 OR (@v_VariableId1 > 10005 AND @v_VariableId1 < 10022) ) 
				BEGIN	 
					SELECT @v_AliasStr =  ISNULL(@v_AliasStr,'') + ', ' + @v_PARAM1 + ' AS "' + @v_ALIAS +'"'   
				END 
				ElSE IF(Upper(@v_PARAM1) = Upper('TATRemaining'))
				BEGIN
				SELECT @v_AliasStr =  ISNULL(@v_AliasStr,'') + ', ' + '''TATRemaining_' +CAST(@v_counter AS NVARCHAR(10)) +''' AS "' + @v_ALIAS +'"' 
				END
				ElSE IF(Upper(@v_PARAM1) = Upper('TATConsumed'))
				BEGIN
				SELECT @v_AliasStr =  ISNULL(@v_AliasStr,'') + ', ' + '''TATConsumed_' +CAST(@v_counter AS NVARCHAR(10)) +''' AS "' + @v_ALIAS +'"'
				END	
				SELECT @v_ExtAlias =  ISNULL(@v_ExtAlias, '') + ', ' +'"' + @v_ALIAS +'"'   
                			
				
			END  

			IF (@DBorderBy > 100) 
				IF (@v_VariableId1 = @DBorderBy) 
				BEGIN	
					IF(@DBorderBy < 157  OR (@v_VariableId1 > 10005 AND @v_VariableId1 < 10022))
					BEGIN
						SELECT @v_sortFieldStr = ' ' + @v_PARAM1 + ' ' 
					END
					ELSE
					BEGIN
						SELECT @v_sortFieldStr = ' ' + @v_ALIAS + ' ' 
					END
					IF(LEN(@DBlastValue) > 0)  
					BEGIN 
						SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar   
					END 					
				END
			IF (((@v_VariableId1 > 157 AND (@v_VariableId1 < 10001 OR @v_VariableId1 > 10023)) AND @v_extTableName IS NOT NULL) AND (UPPER(@v_PARAM1) != 'TATREMAINING' AND UPPER(@v_PARAM1) != 'TATCONSUMED'))
			BEGIN
				SELECT @v_JoinExtTable = 1
				SELECT @v_Param1ExtAlias = ISNULL(@v_Param1ExtAlias,'')  + ', ' + @v_PARAM1 + ' AS ' + @v_ALIAS
			END

			/*IF (@DBorderBy > 100) WFS_8.0_047 
			BEGIN 
				IF (@v_counter = @DBorderBy - 100)  
				BEGIN 
					SELECT @v_sortFieldStr = ' ' + @v_PARAM1 + ' '  
				END  
			END */ 
			FETCH NEXT FROM CursorAlias INTO @v_PARAM1, @v_ALIAS, @v_ToReturn, @v_VariableId1
		END  
		/* Close and DeAllocate the cursor */ 
		CLOSE CursorAlias 
		DEALLOCATE CursorAlias 
	END  
	/* Subcode assigned for Bug 41579*/
	IF (@DBorderBy > 100 AND @v_sortFieldStr IS NULL)
	BEGIN 
		SELECT @DBmainCode = 400     /* Invalid Session */
		SELECT @DBsubCode = 852
		SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount/*Bugzilla Id 1680*/
		RETURN 
	END

	IF (@v_JoinExtTable = 1)
		BEGIN
			/*SELECT @v_extTable_QDT_JoinStr = ' LEFT OUTER JOIN ' + @v_extTableName + ' ON (QUEUEDATATABLE.VAR_REC_1 = ItemIndex AND QUEUEDATATABLE.VAR_REC_2 = ItemType) '*/
			SELECT @v_extTable_QDT_JoinStr = ' INNER JOIN ' + @v_extTableName + '  WITH (NOLOCK) ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType) '
			SELECT @v_extTable_WFI_JoinStr =  'INNER JOIN (Select ItemIndex, ItemType ' + @v_Param1ExtAlias +'  from ' + @v_extTableName + ' WITH (NOLOCK))' + @v_extTableName + ' ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType)'
		END	
	ELSE	
		BEGIN
			SELECT @v_extTableName = ''
			SELECT @v_extTable_QDT_JoinStr = ''
			SELECT @v_extTable_WFI_JoinStr =  ''
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
	
	IF (@v_innerOrderBy is NULL)  
	BEGIN 
		IF(@DBorderBy = 1)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar   
			END  
			SELECT @v_sortFieldStr = ' PriorityLevel '  
			SELECT @v_NullFlag ='N'
		END  
		ElSE IF(@DBorderBy = 2)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessInstanceId ' 
			SELECT @v_NullFlag ='N'
		END  
		ElSE IF(@DBorderBy = 3)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar 
			END  
			SELECT @v_sortFieldStr = ' ActivityName ' 
			SELECT @v_NullFlag ='N'
		END 
		ElSE IF(@DBorderBy = 4)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' LockedByName ' 
		END 
		ElSE IF(@DBorderBy = 5) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar  
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
			SELECT @v_NullFlag ='N'
		END 
		ElSE IF(@DBorderBy = 9)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @DBlastValue 
			END  
			SELECT @v_sortFieldStr = ' WorkItemState ' 
			SELECT @v_NullFlag ='N'
		END 
		ElSE IF(@DBorderBy = 10) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' EntryDateTime ' 
			SELECT @v_NullFlag ='N'
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
		ElSE IF(@DBorderBy = 16) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' AssignedUser ' 
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
			SELECT @v_NullFlag ='N'
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
				SELECT @v_lastValueStr = 'N'+@v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessedBy ' 
		END 		/* Sorting On Alias */
	
		IF(@DBlastProcessInstance IS NOT NULL)  
		/*BEGIN 		
			SELECT @v_TempColumnVal = @v_lastValueStr 

			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				SELECT @v_lastValueStr = ' AND ( ( ' + @v_sortFieldStr + @v_op + @v_TempColumnVal + ') '   
				SELECT @v_lastValueStr = @v_lastValueStr + ' OR ( ' + @v_sortFieldStr + ' = ' + @v_TempColumnVal 
			END 
			ELSE 
			BEGIN 
				IF(@DBorderBy <> 2 AND @DBorderBy <> 10)
				BEGIN
					SELECT @v_lastValueStr = ' AND  ( ( ' + @v_sortFieldStr + ' IS NULL '  
				END
			END  

			SELECT @v_lastValueStr = @v_lastValueStr + ' AND (  ' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' ( Processinstanceid = ' + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ' )' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' ) '  
			
			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				IF (@DBsortOrder = N'A' ) 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE  
				BEGIN 
					IF( @DBorderBy <> 2 AND @DBorderBy <> 10 )
						SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NULL )'  
					ELSE
						SELECT @v_lastValueStr = @v_lastValueStr + ')'  
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
		END */
		BEGIN 		
			SELECT @v_TempColumnVal = @v_lastValueStr 
			/*LastValue and LastProcessInstanceId would be same so removing the unwanted condition in case of Fetch In Order of 
			is selected as ProcessInstanceName*/
			IF( @DBorderBy <> 2)
			BEGIN
				IF(@DBlastValue IS NOT NULL) 
				BEGIN 
					SELECT @v_lastValueStr = ' AND (' + @v_sortFieldStr + @v_op + @v_TempColumnVal   
					SELECT @v_lastValueStr = @v_lastValueStr + ' OR ( ' + @v_sortFieldStr + ' = ' + @v_TempColumnVal 
				END 
				ELSE 
				BEGIN 
					IF(@v_NullFlag = 'Y')
					BEGIN
						SELECT @v_lastValueStr = ' AND  ( ( ' + @v_sortFieldStr + ' IS NULL '  
					END
				END  
			END
			IF( @DBorderBy = 2)--Fetch In Order of = ProcessInstanceName
			BEGIN
				SELECT @v_lastValueStr = ' AND (  ' 
				SELECT @v_lastValueStr = @v_lastValueStr + '  Processinstanceid' + @v_op +'N'+ @v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
				SELECT @v_lastValueStr = @v_lastValueStr + ' OR  ( Processinstanceid = ' + 'N'+@v_quoteChar + @DBlastProcessInstance + @v_quoteChar + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ' )' 
				--SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
				--SELECT @v_lastValueStr = @v_lastValueStr + ' ) '  
				/*Condition To Be Appended = AND ((  ProcessInstanceId >'WFAChild-0000000007-Process')
				OR (ProcessInstanceId  = 'WFAChild-0000000007-Process' AND  WorkItemId >1 ))  ORDER BY ProcessInstanceID  ASC , WorkItemID  ASC */
			END
			ELSE
			BEGIN
				SELECT @v_lastValueStr = @v_lastValueStr + ' AND   ' 
				--SELECT @v_lastValueStr = @v_lastValueStr + ' ( Processinstanceid = ' + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ' )' 
				SELECT @v_lastValueStr = @v_lastValueStr + '  Processinstanceid' + @v_op + 'N'+@v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
				SELECT @v_lastValueStr = @v_lastValueStr + '  '  
			END	
			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				IF (@DBsortOrder = N'A' ) 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE  
				BEGIN 
					IF(@v_NullFlag = 'Y')
						SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NULL )'  
					ELSE
						SELECT @v_lastValueStr = @v_lastValueStr + ')'  
				END 
				IF( @DBorderBy <> 2)
				BEGIN
					SELECT @v_lastValueStr = @v_lastValueStr + ') ' 
				END
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
		
		
		IF (@DBorderBy = 2 OR @v_sortFieldStr IS NULL OR @v_sortFieldStr = '') 
		BEGIN 
			SELECT @v_orderByStr = ' ORDER BY ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END 
		ELSE  
		BEGIN 
			SELECT @v_orderByStr = ' ORDER BY ' + @v_sortFieldStr + @v_sortStr + ', ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END  
	END /* End Case Inner_Order_By IS NULL*/ 
	ELSE 
	BEGIN 
		SELECT @v_orderByStr = ' ORDER BY '  
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
			IF (@v_TempColumnName IS NULL) 
				SELECT @v_innerLastValueStr = @v_TempColumnName  
			ELSE
				SELECT @v_innerLastValueStr = 'CONVERT(NVARCHAR(256),'+@v_TempColumnName+',121)'  
				SELECT @v_orderByStr = @v_orderByStr + @v_TempColumnName + ' ' + @v_TempSortOrder 
			END 
			ELSE  
			BEGIN 
			IF (@v_TempColumnName IS NULL)
				SELECT @v_innerLastValueStr = @v_innerLastValueStr +  ', ' + @v_TempColumnName  
			ELSE
				SELECT @v_innerLastValueStr = @v_innerLastValueStr +  ', ' + 'CONVERT(NVARCHAR(256),'+@v_TempColumnName+',121)'
				SELECT @v_orderByStr = @v_orderByStr + ', ' + @v_TempColumnName + ' ' + @v_TempSortOrder  
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
		SELECT @v_orderByStr = @v_orderByStr + ', ' + 'ProcessInstanceID' + @v_sortStr + ', WorkItemID ' + @v_sortStr  
		
		IF(@DBlastProcessInstance IS NOT NULL)  
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
			select @qdtColString = 'ProcessInstanceId, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,InstrumentStatus ,CheckListCompleteFlag ,
    SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId ChildWorkitemId, ParentWorkItemID, CalendarName,PriorityLevel,EntryDateTime  '
 
				select @v_QueryStr = 'SELECT ' +  @v_innerLastValueStr + ' FROM (SELECT ' + @qdtColString+ ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) ' + @v_extTable_QDT_JoinStr + ' WHERE PROCESSINSTANCEID = N' + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar + ' AND WORKITEMID = ' + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ') Table0' 

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
			
			SELECT @v_lastValueStr = @v_lastValueStr + ' (  ( Processinstanceid = ' + 'N'+@v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ' )'  
			SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op +'N'+ @v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' ) )'  

			IF ( @v_counterCondition > 1 )  
			BEGIN 
				SELECT @v_lastValueStr = @v_lastValueStr + ' )'  
			END   
		END 
	END 
	
	IF(@DBStartingRecNo = 0)
		SELECT @v_RowIdQuery = ''
	ELSE
		SELECT @v_RowIdQuery = ' WHERE row_id > ' + CONVERT(NVarchar(10),@DBStartingRecNo)

	SELECT @v_WLTColStr = ' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' + ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG, calendarname'		/*WFS_8.0_030*//*Process Variant Support Changes*/

	SELECT @v_WLTColStr1 = ' ProcessInstanceId, ' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' ReferredByname, ReferredTo, Q_UserID,  Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' + ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG, calendarname'									/*WFS_8.0_030*/
	/*Process Variant Support Changes*/
	
	SELECT @v_QDTColStr = ', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,' +' VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6,' + ' VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6,'+ ' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8 , VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2 ' 

	SELECT @v_prefix = ' TOP  ' + CONVERT(NVarchar(10), @DBbatchSize + 1)

/*	SELECT @v_QueryStr1 = 'SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' +' SELECT ' + ' row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id, Table9.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM Worklisttable, ProcessInstanceTable, QueueDatatable ' + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND Worklisttable.Workitemid =QueueDatatable.Workitemid '  + ' ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '')  + ISNULL(@v_lastValueStr ,'') + ') Table2'+ ISNULL(@v_orderByStr,'') + ISNULL(@v_RowIdQuery ,'') 
	*/
	
/* Commented for Code optimization 	
	SELECT @v_QueryStr1 = 'SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' +' SELECT ' + ' row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id, Table9.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable ' + @v_extTable_QDT_JoinStr + ' WHERE '  + ' ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '')  + ISNULL(@v_lastValueStr ,'') + ') Table2'+ ISNULL(@v_orderByStr,'') + ISNULL(@v_RowIdQuery ,'') 
	SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM Worklisttable, ProcessInstanceTable, QueueDatatable '   + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatableQueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND Worklisttable.Workitemid =QueueDatatable.Workitemid'  + ' ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2' 

	SELECT @v_QueryStr2 = ' '
	
	SELECT @v_QueryStr2 = ' UNION ALL SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' + ' SELECT ' + '  row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id, Table3.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WorkInProcesstable, ProcessInstanceTable, QueueDatatable '  + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND WorkInProcesstable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND WorkInProcesstable.Workitemid =QueueDatatable.Workitemid'  + ' ) Table3 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '') + ISNULL(@DBuserFilterStr, '') + ISNULL(@v_filterStr, '') + ISNULL(@v_queryFilter, '') + ISNULL(@v_lastValueStr,'') + ') Table4' + ISNULL(@v_orderByStr,'') + ISNULL(@v_RowIdQuery ,'') 
	
	SELECT @v_CountStr2 = 'SELECT COUNT(*) FROM ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WorkInProcessTable Worklisttable, ProcessInstanceTable, QueueDatatable '  + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND Worklisttable.Workitemid =QueueDatatable.Workitemid '  + ' ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2' 
*/

	SELECT @v_noOfCounters = 1 /* Bugzilla Bug 1703 */
--	SELECT @v_queryStr = @v_QueryStr1  

	SELECT @v_QueryStr3 = ' '
	IF (@DBqueueId = 0) 
	BEGIN 
--		SELECT @v_queryStr = @v_QueryStr + ' UNION ALL ' +  @v_QueryStr2 

	/*	SELECT @v_QueryStr3 = ' UNION ALL SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' + ' SELECT '+ ' row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id, Table5.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM PendingWorkListTable, ProcessInstanceTable, QueueDatatable ' + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND PendingWorkListTable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND PendingWorkListTable.Workitemid =QueueDatatable.Workitemid ' + 	' ) Table5 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '')+ ISNULL(@DBuserFilterStr, '') + ISNULL(@v_filterStr, '') + ISNULL(@v_queryFilter, '') + ISNULL(@v_lastValueStr,'') + ') Table6' + ISNULL(@v_orderByStr,'')+ ISNULL(@v_RowIdQuery ,'') 
		SELECT @v_CountStr3 = 'SELECT COUNT(*) FROM ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM PendingWorkListTable Worklisttable, ProcessInstanceTable, QueueDatatable '   + @v_extTable_QDT_JoinStr + ' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' + ' AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' + ' AND Worklisttable.Workitemid =QueueDatatable.Workitemid ' + ' ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2' */
		
--		SELECT @v_queryStr = @v_queryStr + ' UNION ALL ' +  @v_QueryStr3 
		
	/*	SELECT @v_noOfCounters = 3 *//* Bugzilla Bug 1703 */
		
		Select @routingFilterString = '   '
		
		
		/* Fetch from ROUTING STATUS AS 'r' or 'n' AND locked status as 'N' AS WELL */
	END
	ELSE IF (@DBFetchLockedFlag = N'Y')
	BEGIN
--		SELECT @v_queryStr = @v_QueryStr + ' UNION ALL ' +  @v_QueryStr2
		SELECT @v_noOfCounters = 2 /* Bugzilla Bug 1703 */
		/* Fetch from ROUTING STATUS AS 'n'  */
		--Select @routingFilterString = ' RoutingStatus = ' + @v_quoteChar + 'N'+ @v_quoteChar
		Select @routingFilterString = '   '
	END
	ELSE 
	BEGIN
		SELECT @v_QueryStr2 = ' '
		--Select @routingFilterString = ' AND LockStatus = ' + @v_quoteChar + 'N'+ @v_quoteChar 
		Select @routingFilterString = ' AND (LockStatus = ' + @v_quoteChar + 'N'+ @v_quoteChar + ' OR (LockStatus = ' + @v_quoteChar + 'Y' + @v_quoteChar + ' AND LockedByName = ' + @v_quoteChar + @v_UserName + @v_quoteChar + ')) '
	END

	/*SELECT @v_QueryStr1 = ' SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' + ' SELECT ' + '  row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id, Table3.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable '  + @v_extTable_QDT_JoinStr + ' WHERE '  +  @routingFilterString +' ) Table3 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '') + ISNULL(@DBuserFilterStr, '') + ISNULL(@v_filterStr, '') + ISNULL(@v_queryFilter, '') + ISNULL(@v_lastValueStr,'') + ') Table4' + ISNULL(@v_orderByStr,'') + ISNULL(@v_RowIdQuery ,'') */
	SELECT @v_QueryStr1 = ' SELECT ' + ISNULL(@v_prefix,'') + @v_WLTColStr1 + @v_QDTColStr + ISNULL(@v_ExtAlias,'') + ' FROM (' + ' SELECT '

	IF (@DBPagingFlag = N'Y')
	BEGIN
		SELECT @v_QueryStr1 = @v_QueryStr1 + ' row_number() over ( ' + ISNULL(@v_orderByStr,'') + ' ) as row_id,'
	END

	/*SELECT @v_QueryStr1 = @v_QueryStr1 + ' Table3.* FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) '  + @v_extTable_QDT_JoinStr + ' WHERE 1=1 '  +  @routingFilterString +' ) Table3 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@v_ProcessFilter, '') + ISNULL(@DBuserFilterStr, '') + ISNULL(@v_filterStr, '') + ISNULL(@v_queryFilter, '') + ISNULL(@v_lastValueStr,'') + ') Table4' + ISNULL(@v_RowIdQuery ,'')  + ISNULL(@v_orderByStr,'') */
	
	/*SELECT @v_QueryStr1 = @v_QueryStr1 + ' Table3.* FROM  ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) WHERE 1= 1 ' + @routingFilterString  
	SELECT @v_QueryStr1 = @v_QueryStr1 + ' ) WFInstrumentTable ' 

	IF(@v_queueFilterStr IS NULL OR @v_queueFilterStr = '')
	BEGIN
		SELECT @v_QueryStr1 = @v_QueryStr1+' WHERE 1=1 '+ ISNULL(@v_ProcessFilter, '') 
	END
	ELSE
	BEGIN
		SELECT @v_QueryStr1 = @v_QueryStr1 + ISNULL(@v_queueFilterStr,'')   + ISNULL(@v_ProcessFilter, '') 
	END*/
	SELECT @v_QueryStr1 = @v_QueryStr1 + ' Table3.* FROM  ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) WHERE 1= 1 ' + @routingFilterString  
	SELECT @v_QueryStr1 = @v_QueryStr1 + ISNULL(@v_queueFilterStr1,'') +  ISNULL(@v_ProcessFilter, '')
	
	IF(@DBorderBy < 157 )BEGIN
		SELECT @v_QueryStr1 = @v_QueryStr1 + ISNULL(@v_lastValueStr,'') 
	END
	
	SELECT @v_QueryStr1 = @v_QueryStr1 + ' ) WFInstrumentTable '
	
	SELECT @v_QueryStr1 = @v_QueryStr1 +  ISNULL(@v_extTable_WFI_JoinStr,'') + ' ) Table3 WHERE 1=1 ' + ISNULL(@DBuserFilterStr, '') + ISNULL(@v_filterStr, '') + ISNULL(@v_queryFilter, '') 

	IF(@DBorderBy > 157 )BEGIN
		SELECT @v_QueryStr1 = @v_QueryStr1 + ISNULL(@v_lastValueStr,'') 
	END
	
	SELECT @v_QueryStr1 = @v_QueryStr1  + ') Table4' + ISNULL(@v_RowIdQuery ,'')  + ISNULL(@v_orderByStr,'') 
	
	--insert into testDebug values(1,@v_QueryStr1)
	/*SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM ( SELECT * FROM (SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) '  + @v_extTable_QDT_JoinStr + ' WHERE  1=1 '+ @routingFilterString  + '  ) Table9 WHERE ' + ISNULL(@v_queueFilterStr,'') + ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2' */
	
	/*Bugzilla Id 70876*/
/*
	SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM ( SELECT * FROM ( SELECT * FROM ( SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) WHERE 1=1 ' + @routingFilterString +  ISNULL(@v_queueFilterStr,'')  + ' ) WFInstrumentTable ' +  ISNULL(@v_extTable_WFI_JoinStr,'')  + '  ) Table9 WHERE 1=1 '+ ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2' 
*/
	IF(@v_queueFilterStr IS NULL OR @v_queueFilterStr = '')

        BEGIN

            SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM ( SELECT * FROM ( SELECT * FROM ( SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK) WHERE 1=1 ' + @routingFilterString + ' ) WFInstrumentTable ' +  ISNULL(@v_extTable_WFI_JoinStr,'')  + '  ) Table9 WHERE 1=1 '+ ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2'                  

        END

    ELSE

        BEGIN

            SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM ( SELECT * FROM ( SELECT * FROM ( SELECT ' + @v_WLTColStr + @v_QDTColStr + ISNULL(@v_AliasStr,'') + ' FROM WFInstrumentTable (NOLOCK)  ' +@v_queueFilterStr + @routingFilterString + ' ) WFInstrumentTable ' +  ISNULL(@v_extTable_WFI_JoinStr,'')  + '  ) Table9 WHERE 1=1 '+ ISNULL(@DBuserFilterStr,'') + ISNULL(@v_filterStr,'') + ISNULL(@v_queryFilter, '') + ') Table2'   
			
			SELECT @v_CountStr1 = 'DECLARE CountCursor CURSOR Fast_Forward FOR ' + @v_CountStr1

        END

 

	/*Bugzilla Id 1680*/
	IF(@DBreturnParam = 1 OR @DBreturnParam = 2)
	BEGIN
		SELECT @v_counter = 0
		Select @v_noOfCounters = 1
		SELECT @v_returnCount = 0
		WHILE (@v_counter < @v_noOfCounters)
		BEGIN 
			SELECT @v_CountStr = @v_CountStr1
			/* Bugzilla Bug 1703 */
			/*IF (@v_counter = 0)
				SELECT @v_CountStr = @v_CountStr1
			ELSE IF (@v_counter = 1)
				SELECT @v_CountStr = @v_CountStr2
			ELSE IF (@v_counter = 2)
				SELECT @v_CountStr = @v_CountStr3			
			*/
			
			IF(@v_queueFilterStr IS NULL OR @v_queueFilterStr = '')
				BEGIN
					EXECUTE('DECLARE CountCursor CURSOR Fast_Forward FOR ' + @v_CountStr )
					
				END
			ELSE	
				BEGIN
					SET @Params = '@DBqueueId INTEGER'
					EXECUTE SP_EXECUTESQL @v_CountStr ,@Params , @DBqueueId = @DBqueueId
					
				END
			
			OPEN CountCursor
			FETCH NEXT FROM CountCursor INTO @v_TempCount
			IF (@@FETCH_STATUS < 0) 
			BEGIN 
				SELECT @DBmainCode = 15 
				SELECT @DBsubCode = 802 
				SELECT @v_returnCount = 0
			END
			ELSE
			BEGIN
				SELECT @DBmainCode = 0 
				SELECT @DBsubCode = 0 
			END
			CLOSE CountCursor
			DEALLOCATE CountCursor

			SELECT @v_counter = @v_counter + 1
			SELECT @v_returnCount = @v_returnCount + @v_TempCount
		END
		SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount , AliasProcessDefId = @v_outAliasProcessDefId
	END
        ELSE
	BEGIN
		SELECT MainCode = 0, SubCode = 0, ReturnCount = 0 , AliasProcessDefId = @v_outAliasProcessDefId
	END
	
	
	IF(@DBreturnParam = 0 OR @DBreturnParam = 2)
	BEGIN
		
		IF(@v_ExtAlias IS NULL)
			SELECT @v_ExtAlias = ''
		
		
		/* 18/12/2008, Bugzilla Bug 7374, query length was greater than 8000 hence truncated. - Ruhi Hira */
		
		/*EXECUTE(
		'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG, calendarname ' + @v_ExtAlias + ' FROM ( ' 
		+ @v_QueryStr1 + ' ) Table7 ')*/
		
		SET @v_QueryStr1 = 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG, calendarname ' + @v_ExtAlias + ' FROM ( ' 
		+ @v_QueryStr1 + ' ) Table7 '
				
		SET @Params = '@DBqueueId INTEGER'
		
		EXECUTE SP_EXECUTESQL @v_QueryStr1 ,@Params , @DBqueueId = @DBqueueId;
		END 
	RETURN 
END  

