/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application �Products
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
 07/11/2005	Harmeet Kaur		Bug WFS_5_078- SP Written 
16/12/2005	Ruhi Hira		Bug # WFS_5_089.
19/12/2005	Harmeet Kaur		Bug # WFS_5_090.
06/04/2006	Harmeet Kaur		Bug # WFS_5_115.
10/04/2006	Harmeet Kaur		Bug # WFS_5_116.
14/04/2006	Harmeet Kaur		WFS_5_113 Optimization for PCS.
15/05/2006	Harmeet Kaur		WFS_5_121 - Open WI's in modify mode in search for WI's having filteroption=1
26/07/2006	Harmeet	Kaur		WFS_5_127 Support for QueryFilter
01/08/2006	Harmeet Kaur		WFS_5_131 Sorting order changed for FIFO Queue
03/10/2006	Harmeet Kaur		WFS_5_136 ActionDateTime not coming properly in routelogtable for GetWorkitem in oracle
12/10/2006	Umesh			Bug # WFS_5_139 wokitem in Noassignment type queue not opening
22/11/2006	Ruhi Hira		Bug # WFS_5_148.
27/12/2006	Ruhi Hira		Bug # WFS_5_149.
06/06/2007 	Varun Bhansaly		Bugzilla Bug 758 (refer/revoke)
					Bugzilla Bug 773 (main code is coming 6 in place of 16 in getworkitemdataext)
					Bugzilla Bug 856 (unable to view workitem even if user has user has view rights)
					Bugzilla Bug 825 (A error message does not comes that you are not authorized to perform this operation.)
20/06/2007	Ashish Mangla		Bugzilla Bug 1200 (In case of FIFO also, IF WI is not locked, try lock it also)
22/06/2007	Varun Bhansaly		Bugzilla Ig 1187 (Invalid Date Format For Tags in the Output XML for WFGetWorkItemDataExt [SP -> WFGetWorkItem.sql])
17/09/2007	Varun Bhansaly		SrNo-1, Support for Complex filters and Generic Queue Filter.
08/01/2008	Ashish Mangla		Bugzilla Bug 1681 (UserName Marco support required)
18/01/2008	Ruhi Hira		Bugzilla Bug 3549, RowCount was not initialized.
21/01/2008	Ruhi Hira		Bugzilla Bug 1721, error code 810.
22/01/2008	Ruhi Hira		Bugzilla Bug 3580, Unable to open fixed assigned workitems from search.
25/01/2008	Varun Bhansaly	Bugzilla Id 3584, orderby filter in fifo queue is not working properly
25/02/2008	Varun Bhansaly	Performance Optimization - Inherited from PRD Bug Solution WFS_5_212
19/03/2008	Varun Bhansaly	To prevent Bug WFS_5_189 (Ref Cursor invalid)- Close cursors in Exception block only if they are open.
17/03/2008	Ashish Mangla		Bugzilla Bug 3962 (In case of FIFO, UpdLock should be applied when selecting from workListtable)
30/04/2008	Sirish Gupta	Bugzilla Bug 4651.
16/12/2008	Ruhi Hira		Bugzilla Bug 7199, 7472 MainCode changed to Invalid_Workitem.
08/09/2009	Vikas Saraswat	WFS_8.0_031	Option  provided to view the workitem of a queue as read-only based on the rights of the queue for non-associated user instead of Query workstep rights.
06/10/2009	Preeti Awasthi	WFS_8.0_040 Support for filter using queue variables/aliases on Queue is 'No Assignment' Type.	
29/10/2009	Saurabh Kamal	WFS_8.0_046 (In case user is member of multiple groups which are added to Queue, One group having no filter, then user should be able to view workitems considering 'no filter')
04/08/2010	Indraneel		WFS_8.0_121: Filter criteria applied by using query workstep should give the preference to the associated users rather than associated group.
11/08/2010	Saurabh Kamal	LTRIM rempoved on column name for every table.
17/09/2010	Preeti Awasthi	WFS_8.0_133: Error in workitem openingif filter string is very large
11/11/2010	Preeti Awasthi	WFS_8.0_143: Error in opening workitem through search when aliases are present on queue for external variables
05/04/2010	Saurabh Kamal	WFS_8.0_153 Support of FUNCTION in QueryFilter
01/07/2011	Saurabh Kamal	Bug 27393, In case of FIFO Queue, if a user is working on a workitem then it should get permanently assigned to the same user(Fixed Assignment).
17/05/2013	Shweta Singhal	Process Variant Support Changes
24/01/2014	Shweta Singhal	External table filter support merged from OF 9.0
27-05-2014	Sajid Khan		Bug 45689 - User able to open workitem even when user is not associated with queue/ query workstep and some group is associated with query 
03/06/2014	Anwar Danish		PRD Bug 42698 merged - "java.sql.SQLException: ORA-06502: character string buffer too small" error returned from wfParseQueryFilter SP which is called from WFFetchWorklist and WFGetWorkitem SP due to small size of input v_ParsedQueryFilter variable then v_QueryFilter variable.
05/06/2014  Kanika Manik        PRD Bug 42185 - [Replicated]RTRIM should be removed
13/06/2014  Anwar Ali Danish    PRD Bug 38828 merged - Changes done for diversion requirement. CQRId CSCQR-00000000050705-Process  
20/08/2015	Mohnish Chopra		Changes for Case management -Returning error code 32 (By Pass Lock) for all tasks. By passing lock requirement in Task View 
06/11/2015	Mohnish Chopra		Changes for Case management -Can Initiate requirement 
27/11/2015	Mohnish Chopra		Bug 57980 - Jboss EAP : "Case modified by other user" message showing while changing value in case data 
14/02/2017  Mayank Agarwal 	    Bug 61919 - For Update not getting applied in some cases in WFGetWorkitem SP	
17/02/2017  RishiRam Meel		Changes done Handling for restricting FIFO workitem from opening in modify mode if fetched through advanced search by supplying queue name
22/04/2017	Sajid Khan			Bug 64878 - Error in opening Workitem when length of query filter is longer than 100 characters
22/04/2017	Sajid Khan			Bug 63042 - Requested filter invalid issue coming while opening of a worktiem or clicking on a queue where query filter length is more than 265
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
03/08/2017		Kumar Kimil     	Bug 70043 - Entry for action id 200 is getting inserted while performing the reassign operation from webdesktop
03/08/2017	Sajid Khan			Bug 70870 - Unable to Temporary Unhold a workitme which was temporarily holded from FIFO type of Queue
16-08-2017	Mohnish Chopra		Changes for Case Management - Queue variable header alias should allow spaces
17/10/2017	Mohnish Chopra		Case registeration Name changes requirement- Added URN in output of WFGetWorkItemDataExt API
02-11-2017	Shubhankur Manuja	Bug Merging - 70858
16-01-18	Ambuj Tripathi		Bug 73224 - The variable size which is used to hold user name should be sufficient
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
16/05/2018	Sajid Ali Khan		Bug 77183 : Previous-Next Functionality to be implemented on ORACLE and POSTGRES SQL 
								Database and Complete merging from OF 10 latest fixes including Filters and managing the changes done over iBPS.
12/09/2018	Ambuj Tripathi		PRDP merging - Bug 80103 - WFGetWorkitem procedure gets hang if function filter returns null
10/09/2018	Mohnish Chopra		Bug 80087 - iBPS 4.0+Oracle : Unable to open any workitem in Oracle
20/09/2018	Mohnish Chopra		Bug 80485 - Ibps 3.0 sp1 + Oracle : Unable to open workitem after searching from "In History" 
29/03/2019 Ravi Ranjan Kumar   Bug 83885 - When workitem is present in myqueue and locked by me then other user able to open in read only mode if user does not have any rights
25/04/2019	Ravi Ranjan Kumar	PRDP Bug Merging - Bug 84241 - WMGetWorkitem API is returning main code 300 instead of 16
09/07/2019	Mohnish Chopra		Bug 85547 - Not able to open workitem in case external table's data migrated to SecondaryDB and alias is defined on Extended Queue variable				
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
14/08/2019	Ravi Ranjan Kumar	Bug 85956 - Clicking on FIFO Queue and open the workitem , its open only in read only mode (Oracle) 
26/09/2019	Ravi Ranjan Kumar	Bug 86858 - Unable to complete/save Task from My Calendar getting error " case has been modified by some other user"
26/11/2019	Ravi Ranjan Kumar	Bug 88613 - Unable to done task, getting error "No Authorization".
20/12/2019  Shubham Singla      Bug 89018 - iBPS 4.0:Advance search opened workitem is showing error if function filter is used on the queue. 
20/12/2019  Shubham Singla      Bug 87781 - iBPS 4.0+Oracle:Function filter on external variable alias are not working.  
18/02/2020		Ravi Ranjan Kumar	Bug 90769 - Query Queue Filter is not calculated in WFGetWorkitem API when user opeing the workitem.
20/03/2020 Sourabh Tantuway     Bug 91401 - iBPS 4.0 + oracle : 'Order by' clause is not working in user filter. Also when order by clause used with filter on queue then opening workitem is giving error.
09/04/2020 Sourabh Tantuway     Bug 91625 - iBPS 4.0 + Oracle : When Queue filter is applied on a queue and workitem is opened and closed it through windows close button, it goes to MyQueue in locked state. On opening workitem again from MyQueue, it is giving Error.
25/06/2020	Mohnish Chopra		Bug 92936 - Workitem not opening if space is there in Alias . Also reverting PRDP Bug Merging - Bug 84241
10/07/2020	Ravi Ranjan Kumar	Bug 93261 - Unable to see WI in Read Only mode getting error "The Requested filter is invalid" if WI is locked with other user and both user have rights 
31/07/2020 Shubham Singla       Bug 93241 - iBPS 4.0+Oracle:Issue is coming while opening the locked workitem for the case when the user has both preview and edit rights on the queue .
17/10/2020 Shubham Singla       Bug 95417 - iBPS 4.0:-Issue is coming while using next bring next workitem functionality when queue is opened after sorting it on the basis of InstrumentStatus.
04/12/2020 Ravi raj Mewara      Bug 96327 - iBPS 5.0 SP 1: On searching Workitems which not satisfy filter, are opening in editable mode 
30/04/2021 Shubham Singla       Bug 99267 - iBPS 5.0 SP1+Oracle: Issue is coming while opening the workitem when the workitem is assigned to the user having special characters in it.
26/05/2021  Ravi Raj Mewara    Bug 99548 - iBPS 5.0 SP2: If a workitem is temporary hold by any user then only that user can open it in editable mode and only badmin or that particular user can unhold the workitem.
05/10/2021  Ravi Raj Mewara    Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
18/06/2023 Satyanarayan Sharma Bug 130596 - Getting error in WfGetworkitemdataExt when Userfilter contains alias on external table.
----------------------------------------------------------------------------------------------------*/


CREATE OR REPLACE PROCEDURE Wfgetworkitem(
	DBSessionId			INTEGER,
	DBProcessInstanceId		NVARCHAR2,
	DBWorkItemId			INTEGER,
	DBQueueId			INTEGER,
	DBQueueType			NVARCHAR2,	/* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
	DBLastProcessInstanceId		NVARCHAR2,
	DBLastWorkitemId		INTEGER,
	DBGenerateLog			NVARCHAR2,
	DBAssignMe			NVARCHAR2,
	out_mainCode			OUT	INT,
	out_lockFlag			OUT NVARCHAR2,
	RefCursor			IN OUT Oraconstpkg.DBLIST,
	DBTaskId			INTEGER,
	v_UtilityFlag           NVARCHAR2,
	DBOrderBy				INTEGER,
	DBSortOrder				NVARCHAR2,
	DBLastValue				NVARCHAR2,
	DBClientOrderFlag		NVARCHAR2,
	DBuserFilterStr		NVARCHAR2 ,
	DBExternalTableName			NVARCHAR2,
	DBHistoryTableName			NVARCHAR2,
	v_tarHisLog				NVARCHAR2,
	v_targetCabinet			VARCHAR2	
)
AS
	/* Declare workitem' data common in five tables and queueHistoryTable */
	TYPE DynamicCursor		IS REF CURSOR;
	v_ProcessInstanceId		NVARCHAR2(63);
	v_WorkItemId			INT;
	v_ProcessName 			NVARCHAR2(30);
	v_ProcessVersion  		INT;
	v_ProcessDefID 			INT;
	v_LastProcessedBy 		INT;
	v_ProcessedBy			NVARCHAR2(63);
	v_ActivityName 			NVARCHAR2(30);
	v_ActivityId 			INT;
	v_EntryDateTime 		NVARCHAR2(50);
	v_ParentWorkItemId		INT;
	v_AssignmentType		NVARCHAR2(1);
	v_CollectFlag			NVARCHAR2(1);
	v_PriorityLevel			INT;
	v_ValidTill				NVARCHAR2(50);
	v_Q_StreamId			INT;
	v_Q_QueueId			INT;
	v_Q_UserId			INT;
	v_AssignedUser			NVARCHAR2(63);
	v_FilterValue			INT;
	v_CreatedDatetime		NVARCHAR2(50);
	v_WorkItemState			INT;
	v_Statename 			NVARCHAR2(255);
	v_ExpectedWorkitemDelay	NVARCHAR2(50);
	v_PreviousStage			NVARCHAR2(30);
	v_LockedByName			NVARCHAR2(63);
	v_LockedByNameTemp		NVARCHAR2(63);
	v_LockStatus			NVARCHAR2(1);
	v_LockedTime			NVARCHAR2(50);
	v_IntroductionDateTime			NVARCHAR2(50);
	v_Queuename 			NVARCHAR2(63);
	v_Queuetype 			NVARCHAR2(1);
	v_NotifyStatus			NVARCHAR2(1);
	v_QueryPreview			NVARCHAR2(1);	/*WFS_8.0_031*/
	v_Q_DivertedByUserId    INT;
	v_LastModifiedTime		NVARCHAR2(50);
	v_URN					NVARCHAR2(63);

	/* Declare intermmediate variables */
	v_rowCount			INT;
	v_found				NVARCHAR2(1);
	v_canLock			NVARCHAR2(1);
	v_userIndex			INT;
	v_userName			NVARCHAR2(100);
	v_status			NVARCHAR2(1);
	v_qdt_filterOption		INT;
	v_queryStr			VARCHAR2(32000);
	v_cursorQueryStr		NVARCHAR2(2000);
	v_queryFilterStr		NVARCHAR2(4000);
	v_queryFilterStr2		NVARCHAR2(4000);
	v_orderByStr			NVARCHAR2(200);
	v_DBStatus			INT;
	v_quoteChar 			CHAR(1);
	WorkItem_Cur			INT;
	v_retval			INT;
	messageId			INT;
	logId				INT;
	v_toSearchStr			NVARCHAR2(20);
	v_QueryFilter			VARCHAR2(8000);
	v_orderByPos			INT;	
	v_counterInt			INT; 	
	v_tempFilter			NVARCHAR2(4000);
	FilterCur			INT;
	ProcessInstCur			INT;
	v_tableStr			NVARCHAR2(200);
	v_editableOnQuery NVARCHAR2(2);
	V_queryStr2		VARCHAR2(2000);
	v_tableName1		NVARCHAR2(256);
	v_exists 	INT;

	/* Query WorkStep Handling */
	v_QueueDataTableStr		NVARCHAR2(30);
	v_ExtTableStr			NVARCHAR2(300);
	v_ExtTableFilterUsed	NVARCHAR2(1);
	v_ExtTableStrCondition	NVARCHAR2(256);
	/*v_tableName				NVARCHAR2(256);*/
	v_RoutingStatus				NVARCHAR2(256);
	v_CheckQueryWSFlag       NVARCHAR2(1);
	v_bInQueue				NVARCHAR2(1);
	v_QueryActivityId        INT;
	/* Query WorkStep Handling */


	/* WFS_5_131 */
	v_orderBy			NVARCHAR2(200);
	v_iOrder			INT;
	v_sortFieldStr			NVARCHAR2(2000);
	v_sortFieldStrCol		NVARCHAR2(2000);
	v_lastValueStr			NVARCHAR2(1000);
	v_reverseOrder			INT;
	v_op					CHAR(1);
	v_sortStr				NVARCHAR2(6);
	v_innerOrderBy			NVARCHAR2(200);
	v_TempColumnVal			NVARCHAR2(500);
	v_innerOrderByCol1		NVARCHAR2(64); 
	v_innerOrderByCol2		NVARCHAR2(64); 
	v_innerOrderByCol3		NVARCHAR2(64);
	v_innerOrderByCol4		NVARCHAR2(64); 
	v_innerOrderByCol5		NVARCHAR2(64); 
	v_innerOrderBySort1		NVARCHAR2(6); 
	v_innerOrderBySort2		NVARCHAR2(6); 
	v_innerOrderBySort3		NVARCHAR2(6); 
	v_innerOrderBySort4		NVARCHAR2(6); 
	v_innerOrderBySort5		NVARCHAR2(6); 
	v_innerOrderByVal1		NVARCHAR2(256); 
	v_innerOrderByVal2		NVARCHAR2(256); 
	v_innerOrderByVal3		NVARCHAR2(256); 
	v_innerOrderByVal4		NVARCHAR2(256); 
	v_innerOrderByVal5		NVARCHAR2(256); 
	v_innerOrderByType1		NVARCHAR2(50); 
	v_innerOrderByType2		NVARCHAR2(50); 
	v_innerOrderByType3		NVARCHAR2(50); 
	v_innerOrderByType4		NVARCHAR2(50); 
	v_innerOrderByType5		NVARCHAR2(50); 
	v_innerOrderByCount		INT;
	v_PositionComma			INT;
	v_TempColumnName		NVARCHAR2(64);
	v_TempSortOrder			NVARCHAR2(6);
	v_innerLastValueStr		NVARCHAR2(1000);
	v_TemplastValueStr		NVARCHAR2(1000);
	v_counter				INT;
	v_counter1				INT;
	v_tempDataType			NVARCHAR2(100);
	v_counterCondition		INT;
	v_sortFieldStrValue		NVARCHAR2(2000);
	v_DATEFMT 				NVARCHAR2(21);
	v_iFirstOrder			INT;
	v_len				INT;
	v_tempOrderStr			NVARCHAR2(2000);
	/* WFS_5_131 */

	v_ParsedQueryFilter NVARCHAR2(8000);
	v_groupID			INT;
	v_QueueFilter		NVARCHAR2(1000);
	v_TempQueryFilter	NVARCHAR2(2000);
	v_tempProcessInstanceId		NVARCHAR2(63);
	/* WFS_8.0_040 */
	v_QDTColStr		VARCHAR2(8000); 
	v_WLTColStr		VARCHAR2(8000); 
	v_WLTColStr1		VARCHAR2(8000);
	v_CursorAlias		INT; 
	v_AliasStr		NVARCHAR2(4000); 
	v_PARAM1		NVARCHAR2(255); 
	v_ALIAS			NVARCHAR2(255); 
	v_ToReturn		NVARCHAR2(1); 
	v_VariableId1	INT;

	v_FunctionPos		INTEGER;	
	v_funPos1			INTEGER;
	v_funPos2			INTEGER;
	v_FunValue			VARCHAR(8000);
	queryFunStr			VARCHAR(8000);
	v_functionFlag		VARCHAR(1);
	v_prevFilter		VARCHAR(2000);
	v_funFilter			VARCHAR(2000);
	v_postFilter		VARCHAR(1000);
	v_tempFunStr  		VARCHAR(100);
	v_FunLength			INTEGER;	
	v_message			VARCHAR(8000);
	v_AssignQ_QueueId	INTEGER;	
	v_AssignFilterVal	INTEGER;
	v_AssignWIState		INTEGER;
	v_AssignQueueType	NVARCHAR2(1);	
	v_AssignQueueName	NVARCHAR2(100);
	ProcessInstanceIdFilter	INTEGER;
	existsFlag				INTEGER;
	v_QueryStr1			Varchar2(8000);
	CursorLastValue			DynamicCursor;
	LockCur					DynamicCursor;
	v_LastValue			NVARCHAR2(500);
	v_insertTarStr				VARCHAR2(50);
	v_ProcessVarinatId 	INTEGER;
 	v_ActivityType		INTEGER;
	v_CanInitiate		NVARCHAR2(1);
	v_showCaseVisual	NVARCHAR2(1);
	v_tempQ_UserId			INT;
	v_QueryFilterQueue	NVarchar2(8000);
	v_QueryFilterUG   NVarchar2(8000);
	v_ExpiryFlag		NVarchar2(2); 
	tempProcInstanceId		NVARCHAR2(100) ;
	v_indexOfSeprator 	INT ;
	v_genLog   			Varchar(2);
	v_WorkStartedLoggingEnabled   Varchar(2);
	v_NullFlag				VARCHAR2(2);
	v_nullSortStr		VARCHAR2(40);	
	v_extObjId INT;
	v_fieldName NVarChar2(1000);
	v_externalTaleJoin NVarchar2(1);
	v_finalColumnStr Nvarchar2(2000);
	v_query1 varchar2(8000);
	v_extTableNameHistory		NVARCHAR2(50);
	v_extTableName	NVARCHAR2(50);
	v_queryQueueId		INT;
	v_tempCount		INT;
	v_systemDefinedName		NVARCHAR2(50);
	v_MainCode   INTEGER;
	v_GenLogMainCode INTEGER;

BEGIN
	/* Initializations */
	v_found			:= 'N';
	v_canLock		:= 'N';
	out_lockFlag		:= 'N';
	out_mainCode		:= 0;
	v_ProcessInstanceId	:= DBProcessInstanceId;
	v_WorkitemId		:= DBWorkitemId;
	v_Q_QueueId		:= DBQueueId;
	v_DBStatus		:= -1;
	v_quoteChar		:= CHR(39);
	v_LastValue		:= DBLastValue;
	v_MainCode		:= 0;
	v_GenLogMainCode:=0;
	/* Query WorkStep Handling */
	v_QueueDataTableStr	:= '';
	v_ExtTableStr := '';
	v_ExtTableFilterUsed := 'N';
	v_CheckQueryWSFlag  := 'N';
	v_RoutingStatus         := '';
	/* Query WorkStep Handling */

	v_orderByStr := '';
	ProcessInstanceIdFilter	:=	-1;
	v_DATEFMT := 'YYYY-MM-DD HH24:MI:SS';
	v_insertTarStr := '';
	v_ExpiryFlag   := 'N';
	tempProcInstanceId := '';
	v_NullFlag  := 'Y';	
	v_tableName1 := 'WFINSTRUMENTTABLE';
	v_extTableName:=DBExternalTableName;
	v_extTableNameHistory:=DBHistoryTableName;
	IF(v_LastValue is NOT NULL) THEN
		v_LastValue:=REPLACE(v_LastValue,v_quoteChar,v_quoteChar||v_quoteChar);
	END IF;
	/* Check session validity */
	BEGIN
		SELECT	userIndex , userName, statusFlag INTO v_userIndex ,	v_userName, v_status
		FROM	WFSessionView, WFUserView 
		WHERE	UserId		= UserIndex 
		AND	SessionID	= DBSessionId; 
		v_rowCount := SQL%ROWCOUNT; 
		v_DBStatus := SQLCODE;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowCount := 0;			
	END; 
	IF (INSTR(v_userName,v_quoteChar) >0 )THEN 
	BEGIN 
		v_userName := REPLACE(v_userName,v_quoteChar,''''''); 
	END;	 
	END IF;

	IF( v_DBStatus <> 0 OR v_rowCount <= 0 ) THEN
	BEGIN	
		out_mainCode	:= 11;		/* Invalid Session Handle */
		RETURN;
	END;
	END IF;
	
	v_indexOfSeprator := INSTR(DBGenerateLog , ',');
	IF(v_indexOfSeprator = 0) THEN
		BEGIN
			v_genLog := DBGenerateLog;
			v_WorkStartedLoggingEnabled := DBGenerateLog;
		END;
	ELSE
		BEGIN
			v_genLog := SUBSTR(DBGenerateLog, 1 , v_indexOfSeprator-1);
			v_WorkStartedLoggingEnabled :=  SUBSTR(DBGenerateLog , v_indexOfSeprator+1 ,1);
		END;
	END IF;
	
	IF(v_status = N'N') THEN
	BEGIN
		Update WFSessionView set statusflag = 'Y' , AccessDateTime = SYSDATE
          WHERE SessionID = DBSessionId;
	END;
	END IF;
	
	
		IF(DBQueueId = 0 AND (v_LastValue IS NOT NULL OR LENGTH(v_LastValue) > 0)) THEN /* NEXT WORKITEM FEATURE NOT AVAILABLE FOR MYQUEUE and SEARCH*/
				BEGIN
					out_mainCode := 18;
					RETURN;
				END;
			END IF;
		--Check if the workitemis expired 
		BEGIN
			BEGIN
				Select ProcessInstanceId INTO tempProcInstanceId from WFInstrumentTable  where ProcessInstanceId = v_ProcessInstanceId and LockStatus = 'N' And WorkItemId = v_WorkitemId and validTill < SYSDATE;
				v_rowCount := SQL%ROWCOUNT; 
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						v_rowCount := 0;
			END;
			If(v_rowCount > 0) THEN
			BEGIN
				--Set the ExpiredFlag = Y
				v_ExpiryFlag := 'Y';
				v_rowCount := 0;
				--At the End of this SP if ExpiredFLag = Y  then return the 401 in WMGetWorkItem and WFGetWorkItemDataExt thorugh this SP
				--In both API if returned code = 401 Then
					--Set MainCode = 400 and SubCode = 27  from API to be returned to Web thorugh WMGetWorkItem API
						--[To throw error while excution of Complete API as before Complete WMGetWorkItem API will be executed and if the worktiem is expired then actual error message of expired workitem will be thrown]
					--Set a ExpiryFlag = Y thorugh WFGetWorkItemDataExt then Set MainCOde = 16 in WFGetWorktitemDataExt API after execution of WFGetWorkItem SP.
			END	;	
			END IF;
		END;
		--End Of Check if the workitemis expired 	
		
			IF(DBQueueId IS NOT NULL AND DBQueueId > 0)	THEN
			BEGIN
				SELECT ProcessName INTO v_ProcessName FROM QueueDeftable WHERE QueueID = DBqueueId;
				v_rowCount := SQL%ROWCOUNT; 
				IF(v_rowCount > 0) THEN  
				BEGIN
					IF (v_ProcessName IS NOT NULL) THEN
						Select TableName INTO v_ExtTableStr from ExtDbConfTable
						where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
						and ExtObjId = 1;
					END IF;
				EXCEPTION 
				WHEN OTHERS THEN
					v_ExtTableStr := '';
				END;
				
				END IF;
			END;
			END IF;
	v_queryFilterStr := ' WHERE ';
	
	IF(v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') THEN
	BEGIN
		/* Bug # WFS_5_067, Invalid column Name QueueId */
		v_queryFilterStr := v_queryFilterStr || ' Q_QueueId = '|| TO_CHAR(DBQueueId);
		
		IF(DBLastProcessInstanceId IS NULL AND LENGTH(DBLastProcessInstanceId) > 0) THEN
			v_LastValue := NULL; /*Last Value not needed when a user compltes the workitem and next workitem is to be brought based on order by*/
		END IF;
	END;
	ELSE
	BEGIN
		/* WFS_8.0_040 */
		v_queryFilterStr := v_queryFilterStr || ' ProcessInstanceId = '''||v_ProcessInstanceId||''' AND WorkitemId = ' || TO_CHAR(v_WorkitemId) ;
		ProcessInstanceIdFilter	:=	1;
	END;
	END IF;

	/* Filter on last value if given in input, pre fetch case for thick client */
	IF( v_LastValue IS  NULL  AND DBLastProcessInstanceId IS NOT NULL AND LENGTH(DBLastProcessInstanceId) > 0 ) THEN
	BEGIN
		v_queryFilterStr := v_queryFilterStr || ' AND NOT ( processInstanceId =  ' ||
			v_quoteChar || DBLastProcessInstanceId || 
			v_quoteChar || ' AND workitemId = ' || TO_CHAR(DBLastWorkitemId) || ' ) ';
	END;
	END IF;
	
	IF(DBQueueId < 0) THEN	/*Search case we have to find Q_QueueId for the workItem to find the QueryFilter condition*/
	BEGIN
		BEGIN
			SELECT Q_QueueId, QueueType, Q_UserId, RoutingStatus, FilterValue, ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName, Q_DivertedByUserId INTO v_Q_QueueId , v_Queuetype , v_Q_UserId , v_RoutingStatus , v_FilterValue, v_ProcessDefID, v_Queuename, v_LockedTime, v_LockStatus, v_LockedByName, v_PreviousStage, v_ExpectedWorkitemDelay, v_Statename, v_WorkItemState, v_CreatedDateTime, v_AssignedUser, v_ValidTill,  v_PriorityLevel, v_AssignmentType, v_EntryDateTime, v_ActivityId, v_ActivityName, v_ProcessedBy, v_ProcessVersion, v_ProcessName, v_Q_DivertedByUserId
			FROM WFInstrumentTable where RoutingStatus = 'N' and ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkitemId;
			v_rowCount := SQL%ROWCOUNT; 
			v_LockedByNameTemp := v_LockedByName;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_rowCount := 0;
		END;
		IF(v_rowCount > 0) THEN
		BEGIN
			/** 22/01/2008, Bugzilla Bug 3580, Unable to open fixed assigned workitems from search - Ruhi Hira */
			IF (v_Q_QueueId IS NOT NULL AND v_Q_QueueId > 0) THEN
			BEGIN
			  v_bInQueue := 'Y';  
			  IF(v_UtilityFlag = 'N') THEN
			  BEGIN		
				SELECT QUEUEDEFTABLE.FilterOption, QUEUEDEFTABLE.QueueFilter INTO v_qdt_filterOption, v_QueueFilter 
				FROM	QUEUEDEFTABLE, QUserGroupView 
				WHERE	QUEUEDEFTABLE.QueueID = QUserGroupView.QueueID 
				AND	QUEUEDEFTABLE.QueueID = v_Q_QueueId
				AND	UserId = v_userIndex
				AND	ROWNUM <= 1;
				v_rowCount := SQL%ROWCOUNT; 
			 END;
		     ELSE
		     BEGIN
				SELECT QUEUEDEFTABLE.FilterOption, QUEUEDEFTABLE.QueueFilter INTO v_qdt_filterOption, v_QueueFilter 
				FROM	QUEUEDEFTABLE
				WHERE	QUEUEDEFTABLE.QueueID = v_Q_QueueId 
				AND	ROWNUM <= 1;
				v_rowCount := SQL%ROWCOUNT;						     
			END;
			END IF;	
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						v_rowCount := 0;	

				IF(v_rowCount > 0) THEN
					IF( NOT ( (v_qdt_FilterOption = 2 AND v_FilterValue = v_userIndex) OR 
						(v_qdt_FilterOption = 3 AND v_FilterValue != v_userIndex) OR  (v_qdt_FilterOption = 1) )) THEN /* WFS_5_121 */
					BEGIN
						v_canLock := 'N';
						v_CheckQueryWSFlag := 'Y';
					END;
					END IF;
				ELSE
					v_canLock := 'N';
					v_CheckQueryWSFlag := 'Y';
				END IF;
				
				IF(v_ProcessName IS NOT NULL) THEN
				BEGIN
						Select TableName INTO v_ExtTableStr from ExtDbConfTable
						where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
						and ExtObjId = 1;
				EXCEPTION 
						WHEN OTHERS THEN
							v_ExtTableStr := '';
				END;
				END IF;
			END;
			END IF;
		END;
		ELSE
			v_bInQueue := 'N';
		END IF;
	END;
	END IF;
	/* WFS_8.0_040, WFS_8.0_143 */
	IF (v_Q_QueueId > 0) THEN
	v_CursorAlias := DBMS_SQL.OPEN_CURSOR;
	v_QueryStr := 'SELECT PARAM1, ALIAS, ToReturn, VARIABLEID1 FROM VarAliasTable WHERE QueueId = ' || v_Q_QueueId || ' ORDER BY ID ASC'; 
	DBMS_SQL.PARSE(v_CursorAlias, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
	DBMS_SQL.DEFINE_COLUMN(v_CursorAlias, 1 , v_PARAM1, 64); 
	DBMS_SQL.DEFINE_COLUMN(v_CursorAlias, 2 , v_ALIAS, 64); 
	DBMS_SQL.DEFINE_COLUMN(v_CursorAlias, 3 , v_ToReturn, 1); 
	DBMS_SQL.DEFINE_COLUMN(v_CursorAlias, 4 , v_VariableId1); 

	v_retval := DBMS_SQL.EXECUTE(v_CursorAlias); 

	v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorAlias); 
	v_counterInt := 0; 
	WHILE (v_DBStatus <> 0) LOOP 
	BEGIN 
		v_counterInt := v_counterInt + 1; 
		DBMS_SQL.COLUMN_VALUE(v_CursorAlias, 1, v_PARAM1);  
		DBMS_SQL.COLUMN_VALUE(v_CursorAlias, 2, v_ALIAS); 
		DBMS_SQL.COLUMN_VALUE(v_CursorAlias, 3, v_ToReturn);  
		DBMS_SQL.COLUMN_VALUE(v_CursorAlias, 4, v_VariableId1);  
		IF ((v_VariableId1 > 157 AND (v_VariableId1 < 10001)) OR (v_VariableId1 >10023)) THEN 
			v_ExtTableFilterUsed := 'Y';
		END IF;
		IF (v_ToReturn = N'Y') THEN 
		    IF(UPPER(v_PARAM1) != 'TATREMAINING' AND UPPER(v_PARAM1) != 'TATCONSUMED') THEN
			     v_AliasStr :=  v_AliasStr || ', ' || v_PARAM1 || ' AS ' || v_ALIAS ;
            END IF;			
		END IF;
		IF (v_ALIAS LIKE '%'||chr(32)||'%') THEN
			v_ALIAS:=' "' || v_ALIAS || '" ';
		END IF; 
			IF (DBorderBy > 100) THEN
			BEGIN
				IF (v_VariableId1 = DBorderBy) THEN
				BEGIN
					v_sortFieldStr := v_ALIAS ;
					v_sortFieldStrCol := ', ' || v_ALIAS;
					IF(LENGTH(v_LastValue) > 0) THEN 
					BEGIN
						v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
					END;
					END IF;
				END;
				END IF;
			END;
			END IF;
		v_DBStatus := DBMS_SQL.fetch_rows(v_CursorAlias); 
	END; 
	END LOOP; 
		dbms_sql.close_cursor(v_CursorAlias);
	END IF;
	 
	IF (v_ExtTableFilterUsed = 'Y') THEN
		BEGIN
			BEGIN
				SELECT ProcessName INTO v_ProcessName FROM QueueDeftable WHERE QueueID = v_Q_QueueId;
				v_rowCount := SQL%ROWCOUNT; 
				IF(v_rowCount > 0) THEN  
				BEGIN
					IF (v_ProcessName IS NOT NULL) THEN
						Select TableName INTO v_ExtTableStr from ExtDbConfTable
						where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
						and ExtObjId = 1;
					END IF;
				EXCEPTION 
				WHEN OTHERS THEN
					v_ExtTableStr := '';
				END;
				
				END IF;
			END;
		
		/*SELECT TableName INTO v_ExtTableStr from EXTDBConfTable where processdefid = v_ProcessDefID and extobjid = 1;*/
			v_ExtTableStrCondition := ' LEFT OUTER JOIN ' || v_ExtTableStr || ' ON (WFINSTRUMENTTABLE.VAR_REC_1 = ItemIndex AND WFINSTRUMENTTABLE.VAR_REC_2 = ItemType) ';
			v_ExtTableStr := ', ' || v_ExtTableStr;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_ExtTableStr := '';
					v_ExtTableStrCondition := '';
		END;
	End IF;
	
	
	IF(DBSortOrder = 'D') THEN 
		BEGIN 
			v_reverseOrder := 1;
			v_sortStr := ' DESC ';  
			v_nullSortStr := ' NULLS LAST ';
			v_op := '<';  
		END; 
	ELSE 
		BEGIN 
			v_reverseOrder := 0;
			v_sortStr := ' ASC ';  
			v_nullSortStr := ' NULLS FIRST ';
			v_op := '>'; 
		END;
	END IF;
	
	
	
	IF (( DBQueueId > 0 AND (v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') ) 
	OR ( DBQueueId < 0 AND v_bInQueue = 'Y' AND (v_Q_UserId IS NULL OR v_userIndex != v_Q_UserId)) )THEN
	BEGIN
		v_toSearchStr := 'ORDER BY';
		BEGIN			
			SELECT QueryFilter INTO v_QueryFilter
			FROM  QueueUserTable
			WHERE QueueId = v_Q_QueueId
			AND userId = v_userIndex 
			AND AssociationType = 0;

			v_rowCount := SQL%ROWCOUNT; 
			v_DBStatus := SQLCODE;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				v_rowCount := 0;			
		END; 
		
		IF (v_rowCount > 0) THEN
		BEGIN
			/* Only user specific filter exists and no group filter considered. */
			v_QueryFilter := LTRIM(RTRIM(v_QueryFilter));
			IF (v_QueryFilter != '' OR v_QueryFilter IS NOT NULL) THEN
			BEGIN
				v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter ,'&<UserIndex>&', v_userIndex || '')));
				v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter ,'&<UserName>&', v_userName)));
				v_orderByPos := INSTR(UPPER(v_QueryFilter),v_toSearchStr);
				IF (v_orderByPos > 0) THEN
					--IF DBQueueId > 0 THEN
						--v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
						IF (DBClientOrderFlag = N'N') THEN
							BEGIN
								v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
							END;
						END IF;
					--END IF;
					v_QueryFilter := SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
				END IF;
				Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
				v_QueryFilter := v_ParsedQueryFilter;
			END;
			END IF;
		END;
		ELSE /*  group filter present*/
		BEGIN
			v_queryStr := '';
			v_queryStr := 
				' Select QueryFilter, GroupId ' ||
				' From Qusergroupview ' ||
				' Where GroupId IS NOT NULL ' ||
				' AND QueueId  = ' || TO_CHAR(v_Q_QueueId) ||
				' AND UserId = ' || TO_CHAR(v_userIndex);

			FilterCur := dbms_sql.open_cursor; /* cursor id */
			DBMS_SQL.PARSE(FilterCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
			
			/* Columns to be fetched */
			DBMS_SQL.define_column(FilterCur,1,v_QueryFilter,2000); 
			DBMS_SQL.DEFINE_COLUMN(FilterCur, 2 , v_GroupId); 

			/* Execute the cursor */
			v_retval := dbms_sql.EXECUTE(FilterCur); 

			/* Fetch next row and close cursor in case of error */
			v_DBStatus := DBMS_SQL.fetch_rows(FilterCur); 

			v_counterInt := 1;
			WHILE(v_DBStatus  <> 0) LOOP 
			BEGIN
				DBMS_SQL.column_value(FilterCur,1,v_QueryFilter);
				DBMS_SQL.column_value(FilterCur, 2, v_GroupId); 
				v_QueryFilter := LTRIM(RTRIM(v_QueryFilter));
				IF (v_QueryFilter IS NOT NULL) THEN
				BEGIN
					v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter , '&<UserIndex>&', v_userIndex || '')));
					v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter ,'&<UserName>&', v_userName)));
					v_orderByPos := INSTR(UPPER(v_QueryFilter),v_toSearchStr);
					IF (v_orderByPos > 0) THEN					
						--IF( DBQueueId > 0) THEN
							--v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
						--END IF;
						IF (DBClientOrderFlag = N'N') THEN
							BEGIN
								v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
							END;
						END IF;
						v_QueryFilter := SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
					END IF;
					Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
					v_QueryFilter := v_ParsedQueryFilter;
					Wfparsequeryfilter (v_QueryFilter, N'G', v_GroupId, v_ParsedQueryFilter);
					v_QueryFilter := v_ParsedQueryFilter;
					IF (LENGTH(v_QueryFilter) > 0) THEN
					BEGIN
						v_QueryFilter := '(' || v_QueryFilter || ')';
						IF v_counterInt = 1 THEN
							v_tempFilter :=  v_QueryFilter;
						ELSE
							v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
						END IF;	
						v_counterInt := v_counterInt + 1;
					END;
					END IF;
				END;
				/*WFS_8.0_046*/
				ELSE
				BEGIN
					v_tempFilter := '';
				END;
				END IF;
				EXIT WHEN v_tempFilter IS NULL;
				v_DBStatus :=DBMS_SQL.fetch_rows(FilterCur);
			END;
			END LOOP; 
			DBMS_SQL.CLOSE_CURSOR(FilterCur); 
			EXCEPTION 
				WHEN OTHERS THEN 
				IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
					DBMS_SQL.CLOSE_CURSOR(FilterCur);  
				END IF;
				RETURN;
				END;
			v_QueryFilter := v_tempFilter;
		END IF;
		IF ((v_QueryFilter = '' OR v_QueryFilter IS NULL) AND ((DBQueueType = N'N') OR (v_queueType= N'N'))) THEN /* Check For Queue Filter for Search Case */
		BEGIN
			SELECT QueueFilter INTO v_QueueFilter FROM QUEUEDEFTABLE WHERE QueueId = v_Q_QueueId;
			IF (v_QueueFilter IS NOT NULL AND LENGTH(v_QueueFilter) > 0) THEN
			BEGIN
				--v_QueryFilter := v_QueueFilter;
				v_QueueFilter :=  LTRIM(RTRIM(REPLACE(v_QueueFilter , '&<UserIndex>&', v_userIndex || '')));
				v_QueueFilter :=  LTRIM(RTRIM(REPLACE(v_QueueFilter ,'&<UserName>&', v_userName)));
				v_orderByPos := INSTR(UPPER(v_QueueFilter), 'ORDER BY');
				IF (v_orderByPos <> 0) THEN
				BEGIN 
					--IF DBQueueId > 0 THEN
						--v_tempOrderStr := SUBSTR(v_queryFilter, v_orderByPos + LENGTH('ORDER BY')); 
					--END IF;
					IF (DBClientOrderFlag = N'N') THEN
						BEGIN
							v_innerOrderBy := SUBSTR(v_QueueFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueueFilter));
						END;
					END IF;
					v_QueueFilter := SUBSTR(v_QueueFilter, 1, v_orderByPos - 1); 
				END;
				END IF;
				Wfparsequeryfilter (v_QueueFilter, N'U', v_userIndex, v_ParsedQueryFilter);
				v_QueueFilter := v_ParsedQueryFilter;
				v_TempQueryFilter := v_QueueFilter;
				v_QueryStr := 'SELECT GroupId FROM QUserGroupView WHERE QueueId = ' || DBqueueId || ' AND UserId = ' || v_userIndex || ' AND GroupId IS NOT NULL'; 
				FilterCur := DBMS_SQL.OPEN_CURSOR; /* cursor id */ 
				DBMS_SQL.PARSE(FilterCur, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
				DBMS_SQL.DEFINE_COLUMN(FilterCur, 1 , v_groupId); 
				v_retval := DBMS_SQL.EXECUTE(FilterCur);  

				/* Fetch next row and close cursor in case of error */ 
				v_DBStatus := DBMS_SQL.FETCH_ROWS(FilterCur);  
				v_counterInt := 0; 
				WHILE (v_DBStatus <> 0) LOOP 
				BEGIN 
					v_QueueFilter := v_TempQueryFilter;
					DBMS_SQL.COLUMN_VALUE(FilterCur, 1, v_groupId);  
					Wfparsequeryfilter (v_QueueFilter, N'G', v_groupId, v_ParsedQueryFilter);
					v_QueueFilter := v_ParsedQueryFilter;
					IF (LENGTH(v_QueueFilter) > 0) THEN
					BEGIN
						v_QueueFilter := '(' || v_QueueFilter || ')';
						IF (v_counterInt = 0) THEN
						BEGIN 
							v_tempFilter := v_QueueFilter;
						END;
						ELSE  
						BEGIN 
							v_tempFilter := v_tempFilter || ' OR ' || v_QueueFilter;
						END;
						END IF;
						v_counterInt := v_counterInt + 1;
					END;
					END IF;
					/* Fetch next row and close cursor in case of error */ 
					v_DBStatus := DBMS_SQL.FETCH_ROWS(FilterCur);  
				END;
				END LOOP;
				IF(v_tempFilter IS NOT NULL) THEN
				BEGIN
					v_QueueFilter := v_tempFilter;
				END;
				END IF;
				/* Close and DeAllocate the CURSOR */ 
				dbms_sql.close_cursor(FilterCur); 
			EXCEPTION  
				WHEN OTHERS THEN  
				BEGIN 
					IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
						DBMS_SQL.CLOSE_CURSOR(FilterCur);  
					END IF; 
					RETURN;  
				END; 
			END;
			END IF;
		END;
		END IF;
		
		IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
		BEGIN
			v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');	
			IF(v_FunctionPos != 0) THEN
			v_FunLength := LENGTH('&<FUNCTION>&');
			BEGIN	
				v_functionFlag := 'Y';		
				WHILE(v_functionFlag = 'Y') LOOP
					BEGIN
						v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
						v_funPos1 := INSTR(v_QueryFilter, chr(123));				
						
						v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
						v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));						
						
						IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
							v_funPos2 := INSTR(v_QueryFilter, chr(125));
							v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
							v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
							queryFunStr := 'SELECT ' || v_funFilter || ' FROM DUAL ';							
							EXECUTE IMMEDIATE queryFunStr INTO v_FunValue;
							
							--PRDP Bug merge - 80103
							IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
								v_FunValue := '1 = 1';
							END IF;
							
							v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
						ELSE
							EXIT;
						END IF;							
						v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');
						IF(v_FunctionPos = 0) THEN
							v_functionFlag := 'N';
						END IF;					
					END;
				END LOOP;				
			END;	
			END IF;
			END;
				IF (v_QueryFilter IS NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) <= 0) THEN
						BEGIN
							v_QueueFilter := '';
							v_queryFilterStr2 := NVL(v_queryFilterStr2,'') || ' AND ' || v_QueryFilter; 
						END;
		END IF;
			END IF;
		
		/*IF (v_tempOrderStr IS NOT NULL OR v_tempOrderStr != '') THEN
			v_orderByStr := ' ORDER BY ' || v_tempOrderStr;
		END IF;*/
		END;				
		END IF;
		
		IF (v_QueueFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueueFilter))) > 0 ) THEN
		BEGIN
		v_FunctionPos := INSTR(v_QueueFilter, '&<FUNCTION>&');	
		IF(v_FunctionPos != 0) THEN
		v_FunLength := LENGTH('&<FUNCTION>&');
		BEGIN	
			v_functionFlag := 'Y';		
			WHILE(v_functionFlag = 'Y') LOOP
			BEGIN
					v_prevFilter := SUBSTR(v_QueueFilter, 0, v_FunctionPos-1);
					v_funPos1 := INSTR(v_QueueFilter, chr(123));				
					
					v_tempFunStr := SUBSTR(v_QueueFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
					v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));						
					
					IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
						v_funPos2 := INSTR(v_QueueFilter, chr(125));
						v_funFilter := SUBSTR(v_QueueFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
						v_postFilter := SUBSTR(v_QueueFilter, v_funPos2 + 1);
						 v_funFilter := REPLACE(v_funFilter, '&<UserIndex>&', v_userIndex); 
                         v_funFilter := REPLACE(v_funFilter, '&<UserName>&', v_userName); 
         													   
						queryFunStr := 'SELECT ' || v_funFilter || ' FROM DUAL ';							
						EXECUTE IMMEDIATE queryFunStr INTO v_FunValue;
						v_QueueFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
					ELSE
						EXIT;
					END IF;							
					v_FunctionPos := INSTR(v_QueueFilter, '&<FUNCTION>&');
					IF(v_FunctionPos = 0) THEN
						v_functionFlag := 'N';
					END IF;					
				END;
				END LOOP;				
			END;	
			END IF;
		END;
		END IF;
		
			IF (v_innerOrderBy is NULL) THEN
					BEGIN 
						IF(DBorderBy = 1) THEN
						BEGIN  
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' PriorityLevel ';
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 2) THEN 
						BEGIN  
							IF(LENGTH(v_LastValue) > 0 ) THEN   
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;  
							END;
							END IF;
							v_sortFieldStr := ' ProcessInstanceId ';
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 3) THEN
						BEGIN  
							IF(LENGTH(v_LastValue) > 0) THEN 
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar; 
							END;
							END IF;			
							v_sortFieldStr := ' ActivityName '; 
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 4) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' LockedByName ' ;
						END; 
						ElSIF(DBorderBy = 5) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;			
							v_sortFieldStr := ' IntroducedBy '; 
						END;
						ElSIF(DBorderBy = 6) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END; 	 
							END IF;
							v_sortFieldStr := ' InstrumentStatus ';
						END;
						ElSIF(DBorderBy = 7) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN 
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;			
							v_sortFieldStr := ' CheckListCompleteFlag ';
						END;
						ElSIF(DBorderBy = 8) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' LockStatus ';
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 9) THEN  
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_LastValue;
							END;
							END IF;
							v_sortFieldStr := ' WorkItemState '; 
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 10) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ;
								--v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;			
							v_sortFieldStr := ' EntryDateTime ';
							v_NullFlag  := 'N';									
						END; 
						ElSIF(DBorderBy = 11) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
								--v_quoteChar || v_LastValue || v_quoteChar;
							END ;
							END IF;
							v_sortFieldStr := ' ValidTill ';
						END;
						ElSIF(DBorderBy = 12) THEN  
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN 
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
								--v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' LockedTime ';
						END;
						ElSIF(DBorderBy = 13) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
								--v_quoteChar || v_LastValue || v_quoteChar;
							END; 	 
							END IF;
							v_sortFieldStr := ' IntroductionDateTime ';
						END; 
						ElSIF(DBorderBy = 17) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END; 
							END IF;
							v_sortFieldStr := ' Status ';
						END;
						ElSIF(DBorderBy = 18) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
								--v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' CreatedDateTime ';
							v_NullFlag  := 'N';		
						END;
						ElSIF(DBorderBy = 19) THEN 
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN 
							BEGIN 
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(v_LastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
								--v_quoteChar || v_LastValue || v_quoteChar;
							END;
							END IF;
							v_sortFieldStr := ' ExpectedWorkItemDelay ';
						END; 		/* Sorting On Alias */
						ElSIF(DBorderBy = 20) THEN
						BEGIN 
							IF(LENGTH(v_LastValue) > 0) THEN
							BEGIN 
								v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
							END;  
							END IF;
							v_sortFieldStr := ' ProcessedBy ';
						END;		/* Sorting On Alias */
						END IF;
					
						
						IF(DBLastProcessInstanceId IS NOT NULL) THEN
						BEGIN 
							v_TempColumnVal := v_lastValueStr;
							IF(v_LastValue IS NOT NULL) THEN
								BEGIN 
									v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ';
									v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
								END; 
							ELSE 
								IF(v_NullFlag = 'Y') THEN
									BEGIN 
										v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL ';  
									END;
								ELSE
									BEGIN 
										v_lastValueStr := ' AND  ( (  1= 1 ' ; 
									END;
								END IF;
							END IF;
								
							v_lastValueStr := v_lastValueStr || ' AND (  ';
							v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar || ' AND  WorkItemId ' || v_op || TO_CHAR(DBLastWorkitemId) || ' )'; 
							v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;
							v_lastValueStr := v_lastValueStr || ' ) ';  
							IF(v_LastValue IS NOT NULL) THEN 
							BEGIN 
								IF (DBsortOrder = N'A') THEN 
									BEGIN 
										v_lastValueStr := v_lastValueStr || ') ' ; 
									END; 
								ELSE  
									BEGIN 
										IF(v_NullFlag = 'Y') THEN
											v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NULL )';
										ELSE
											v_lastValueStr := v_lastValueStr || ')' ;
										END IF;
									END;
								END IF;
								v_lastValueStr := v_lastValueStr || ') ';
								
							END; 
							ELSE  
							BEGIN 
								IF (DBsortOrder = N'D') THEN 
									BEGIN 
										v_lastValueStr := v_lastValueStr || ') ';
									END; 
								ELSE 
									BEGIN
										v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )';  
									END;
								END IF;
								v_lastValueStr := v_lastValueStr || ') ';
							END; 
							END IF;
						END;
						END IF;
						IF(v_NullFlag = 'N') THEN
							v_nullSortStr :='';
						ELSE
						BEGIN
							IF(DBsortOrder = 'D' and (v_LastValue = '' OR v_LastValue IS NULL)) THEN
								v_nullSortStr :='';
							END IF;	
						END;
						END IF;
						/* order by to be set irresepctive of DBLastProcessInstanceId is null or not */
						IF (DBorderBy = 2) THEN
						BEGIN 
							v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
						END; 
						ELSE  
						BEGIN 
							v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr ||v_nullSortStr||', ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr;
						END;
						END IF;
					END;
				--END IF;
				ELSE 
				BEGIN 
					
					v_orderByStr := ' ORDER BY ';  
					v_innerOrderBy := v_innerOrderBy || ',';  

					v_PositionComma := INSTR (v_innerOrderBy,','); 
					v_innerOrderByCount := 0;  

					WHILE (v_PositionComma > 0) LOOP
					BEGIN 
						v_innerOrderByCount := v_innerOrderByCount + 1;  
						v_TempColumnName := SUBSTR(v_innerOrderBy, 1 , v_PositionComma - 1);  

						v_orderByPos := INSTR(UPPER(v_TempColumnName),'ASC'); 
						IF (v_orderByPos > 0) THEN  
							BEGIN 
								v_TempSortOrder := 'ASC'; 
								v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1));  
							END;
						ELSE  
							BEGIN 
								v_orderByPos := INSTR(UPPER(v_TempColumnName),'DESC');
								IF (v_orderByPos > 0) THEN 
									BEGIN 
										v_TempSortOrder := 'DESC'; 
										v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
									END; 
								ELSE  
									BEGIN 
										v_TempSortOrder := 'ASC';  
									END; 
								END IF;
							END;  
						END IF;
						IF (v_reverseOrder = 1) THEN
							BEGIN 
								IF (v_TempSortOrder = 'ASC') THEN  
									BEGIN 
										v_TempSortOrder := 'DESC';  
									END; 
								ELSE  
									BEGIN 
										v_TempSortOrder := 'ASC'; 
									END;
								END IF;					
							END; 
						END IF;

						IF (v_innerOrderByCount = 1) THEN  
							BEGIN 
								v_innerLastValueStr := v_TempColumnName;  
								v_orderByStr := v_orderByStr || v_TempColumnName || ' ' || v_TempSortOrder; 
							END; 
						ELSE  
							BEGIN 
								v_innerLastValueStr := v_innerLastValueStr ||  ', ' || v_TempColumnName;  
								v_orderByStr := v_orderByStr || ', ' || v_TempColumnName || ' ' || v_TempSortOrder;  
							END; 
						--END;
						END IF;
						
						IF (v_innerOrderByCount = 1 ) THEN
							BEGIN 
								v_innerOrderByCol1 := v_TempColumnName;  
								v_innerOrderBySort1 := v_TempSortOrder; 
							END; 
						ELSIF (v_innerOrderByCount = 2 ) THEN  
							BEGIN 
								v_innerOrderByCol2 := v_TempColumnName;  
								v_innerOrderBySort2 := v_TempSortOrder; 
							END; 
						ELSIF (v_innerOrderByCount = 3 ) THEN 
							BEGIN 
								v_innerOrderByCol3 := v_TempColumnName;  
								v_innerOrderBySort3 := v_TempSortOrder ;
							END; 
						ELSIF (v_innerOrderByCount = 4 ) THEN 
							BEGIN 
								v_innerOrderByCol4 := v_TempColumnName;
								v_innerOrderBySort4 := v_TempSortOrder; 
							END;
						ELSIF (v_innerOrderByCount = 5 ) THEN
							BEGIN 
								v_innerOrderByCol5 := v_TempColumnName; 
								v_innerOrderBySort5 := v_TempSortOrder; 
							END;
						END IF;
						v_innerOrderBy := SUBSTR(v_innerOrderBy, v_PositionComma + 1, LENGTH(v_innerOrderBy)); 
						v_PositionComma := INSTR (v_innerOrderBy,',');  
						
					END;
					END LOOP;
					v_orderByStr := v_orderByStr || ', ' || 'ProcessInstanceID' || v_sortStr || ', WorkItemID ' || v_sortStr; 
				--END;
				
					
					IF(DBLastProcessInstanceId IS NOT NULL AND LENGTH(DBLastProcessInstanceId) > 0) THEN  
					BEGIN 
						v_counter := 0;  

						WHILE (v_counter < v_innerOrderByCount) LOOP  
						BEGIN 
							v_counter := v_counter + 1;  
							IF (v_counter = 1) THEN  
								BEGIN 
									v_sortFieldStr := v_innerOrderByCol1; 
								END; 
								ELSIF (v_counter = 2) THEN  
								BEGIN 
									v_sortFieldStr := v_innerOrderByCol2; 
								END; 
								ELSIF (v_counter = 3) THEN 
								BEGIN 
									v_sortFieldStr := v_innerOrderByCol3; 
								END; 
								ELSIF (v_counter = 4 ) THEN  
								BEGIN 
									v_sortFieldStr := v_innerOrderByCol4; 
								END; 
								ELSIF (v_counter = 5 ) THEN 
								BEGIN 
									v_sortFieldStr := v_innerOrderByCol5;  
								END;  
							END IF;
							
							IF (v_counter = 1 ) THEN 
							BEGIN 
								v_innerOrderByType1 := v_tempDataType;
							END; 
							ELSIF (v_counter = 2 ) THEN 
							BEGIN 
								v_innerOrderByType2 := v_tempDataType; 
							END; 
							ELSIF (v_counter = 3 ) THEN  
							BEGIN 
								v_innerOrderByType3 := v_tempDataType;
							END; 
							ELSIF (v_counter = 4 ) THEN  
							BEGIN 
								v_innerOrderByType4 := v_tempDataType; 
							END; 
							ELSIF (v_counter = 5 ) THEN  
							BEGIN 
								v_innerOrderByType5 := v_tempDataType; 
							END;  
							END IF;
						END;
						END LOOP;

						IF (v_innerOrderByCount > 0 ) THEN  
						BEGIN 
							v_counter := 5 - v_innerOrderByCount;  

							WHILE (v_counter > 0) LOOP
								BEGIN 
									v_innerLastValueStr := v_innerLastValueStr ||  ', NULL';  
									v_counter := v_counter - 1; 
								END;
							END LOOP;
						END;
						END IF;
					END;
					END IF;
					
				
						BEGIN 
							v_QueryStr := 'SELECT ' ||  v_innerLastValueStr || ' FROM (SELECT QUEUEDATATABLE.* ' || NVL(v_AliasStr,'') || ' FROM QUEUEDATATABLE ' || v_ExtTableStrCondition || ' WHERE PROCESSINSTANCEID = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar || ' AND WORKITEMID = ' || TO_CHAR(DBLastWorkitemId) || ') Table0';

							OPEN CursorLastValue FOR v_QueryStr;
							LOOP
								FETCH CursorLastValue INTO v_innerOrderByVal1, v_innerOrderByVal2, v_innerOrderByVal3, v_innerOrderByVal4, v_innerOrderByVal5;
								EXIT WHEN CursorLastValue%NOTFOUND;
							END LOOP;
							CLOSE CursorLastValue;
							
							EXCEPTION 
								WHEN OTHERS THEN
								CLOSE CursorLastValue;									
						END;

						v_counter := 0; 
						v_counterCondition := 0;  
						v_lastValueStr := ' AND ( ';  
						
						WHILE (v_counter < v_innerOrderByCount + 1 ) LOOP
						BEGIN 
							v_counter1 := 0;  
							v_TemplastValueStr := '';
							WHILE (v_counter1 <= v_counter) LOOP 
							BEGIN 
								IF (v_counter1 = 0) THEN  
								BEGIN 
									v_TempColumnName := v_innerOrderByCol1;
									v_TempSortOrder := v_innerOrderBySort1;  
									v_TempColumnVal := v_innerOrderByVal1;  
									v_tempDataType := v_innerOrderByType1;  
								END; 
								ELSIF (v_counter1 = 1) THEN  
								BEGIN 
									v_TempColumnName := v_innerOrderByCol2;  
									v_TempSortOrder := v_innerOrderBySort2;
									v_TempColumnVal := v_innerOrderByVal2; 
									v_tempDataType := v_innerOrderByType2; 
								END;
								ELSIF (v_counter1 = 2) THEN 
								BEGIN 
									v_TempColumnName := v_innerOrderByCol3; 
									v_TempSortOrder := v_innerOrderBySort3; 
									v_TempColumnVal := v_innerOrderByVal3; 
									v_tempDataType := v_innerOrderByType3; 
								END; 
								ELSIF (v_counter1 = 3) THEN 
								BEGIN 
									v_TempColumnName := v_innerOrderByCol4; 
									v_TempSortOrder := v_innerOrderBySort4;
									v_TempColumnVal := v_innerOrderByVal4; 
									v_tempDataType := v_innerOrderByType4; 
								END; 
								ELSIF (v_counter1 = 4) THEN 
								BEGIN 
									v_TempColumnName := v_innerOrderByCol5; 
									v_TempSortOrder := v_innerOrderBySort5; 
									v_TempColumnVal := v_innerOrderByVal5;
									v_tempDataType := v_innerOrderByType5; 
								END;
								END IF;
								
								IF (v_counter = v_innerOrderByCount ) THEN 
								BEGIN 
									IF (v_counter1 < v_counter) THEN
									BEGIN 
										IF (v_TempColumnVal IS NULL) THEN 
											BEGIN 
												v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL ';
											END; 
										ELSE  
											BEGIN 
												v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar;
											END; 
										END IF;
										v_TemplastValueStr := v_TemplastValueStr || ' AND ';  
									END;
									END IF;
								END; 
								ELSE 
								BEGIN 
								
									IF (v_counter1 = v_counter) THEN 
									BEGIN 
										IF (v_TempSortOrder = 'ASC') THEN 
											BEGIN 
												IF (v_TempColumnVal IS NOT NULL) THEN 
													BEGIN 
														v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || v_quoteChar || v_TempColumnVal || v_quoteChar;
													END; 
												ELSE 
													BEGIN 
														v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NOT NULL '; 
													END; 
												END IF; 
											END;								
										ELSE  
										BEGIN 
											IF (v_TempColumnVal IS NOT NULL) THEN
												BEGIN 
													v_TemplastValueStr := v_TemplastValueStr || '( ';  
													v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName ||' < ' || v_quoteChar || v_TempColumnVal || v_quoteChar;
													v_TemplastValueStr := v_TemplastValueStr || ' OR ' ||  v_TempColumnName || ' IS NULL )';  
												END;
											ELSE  
												BEGIN 
													--v_TemplastValueStr := NULL;
													v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NOT NULL '; 
												END; 
											END IF;
										END;
										END IF;
									END; 
									--END IF;
									ELSE  
									BEGIN 
										IF (v_TempColumnVal IS NOT NULL) THEN 
											BEGIN 
												v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar;
											END; 
										ELSE  
											BEGIN 
												v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL ';  
											END; 
										END IF;
										v_TemplastValueStr := v_TemplastValueStr || ' AND ';  
									END;
									END IF;
								END;
								END IF;
								v_counter1 := v_counter1 + 1; 
							END;
							END LOOP;
							
							IF (v_TemplastValueStr IS NOT NULL) THEN
							BEGIN 
								IF (v_counterCondition > 0) THEN 
									BEGIN 
										v_lastValueStr := v_lastValueStr || ' OR ( '; 
									END;
								END IF;
								v_lastValueStr := v_lastValueStr || v_TemplastValueStr; 
								IF (v_counterCondition > 0 AND v_counter < v_innerOrderByCount ) THEN 
									BEGIN 
										v_lastValueStr := v_lastValueStr || ' )';  
									END;
								END IF;
								v_counterCondition := v_counterCondition + 1; 
							END; 
							END IF;
							v_counter := v_counter + 1;  
						END;
						END LOOP;
						
						v_lastValueStr := v_lastValueStr || ' (  ( Processinstanceid = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;
						v_lastValueStr := v_lastValueStr || ' AND  WorkItemId ' || v_op || TO_CHAR(DBLastWorkitemId) || ' )';  
						v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;  
						v_lastValueStr := v_lastValueStr || ' ) )';  

						IF ( v_counterCondition > 1 ) THEN 
							BEGIN 
								v_lastValueStr := v_lastValueStr || ' )';  
							END;
						END IF;
					--END; 
				END;
				END IF;
			
				IF(DBLastProcessInstanceId IS NULL OR LENGTH(DBLastProcessInstanceId) <= 0) THEN
					v_lastValueStr := '';
				END IF;
			
				IF((DBQueueId > 0 AND (v_ProcessInstanceId IS NOT NULL OR v_ProcessInstanceId != '')) OR DBQueueId <=0) THEN
					v_canLock  := 'Y';
				END IF;	
	
	IF((v_canLock  = 'Y' AND (v_ProcessInstanceId is not null AND LENGTH(v_ProcessInstanceId) > 0 )) OR (v_ProcessInstanceId is null OR v_ProcessInstanceId = '')) THEN
	BEGIN
		
		v_WLTColStr := ' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, RoutingStatus,InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, FilterValue, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, NotifyStatus, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay,ProcessVariantId, Q_DivertedByUserId, ActivityType,LastModifiedTime,URN ';
		
		v_WLTColStr1 := ' ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefId,  LastProcessedBy, ProcessedBy, ActivityName, ActivityId,  TO_CHAR(EntryDateTime,''YYYY-MM-DD HH24:MI:SS'') AS EntryDateTime,  ParentWorkItemId, AssignmentType,  CollectFlag, PriorityLevel, TO_CHAR(ValidTill,''YYYY-MM-DD HH24:MI:SS'') AS ValidTill,  Q_StreamId, Q_QueueID, Q_UserID,  AssignedUser, FilterValue, TO_CHAR(CreatedDateTime,''YYYY-MM-DD HH24:MI:SS'') AS CreatedDateTime, WORKITEMSTATE,  Statename, TO_CHAR(ExpectedWorkItemDelay,''YYYY-MM-DD HH24:MI:SS'') AS ExpectedWorkItemDelay, PREVIOUSSTAGE,  LockedByName, LockStatus, TO_CHAR(LockedTime,''YYYY-MM-DD HH24:MI:SS'') AS LockedTime,TO_CHAR(IntroductionDateTime,''YYYY-MM-DD HH24:MI:SS'') AS IntroductionDateTime, QueueName, QueueType, NotifyStatus , ProcessVariantId, Q_DivertedByUserId,ActivityType,TO_CHAR(LastModifiedTime,''YYYY-MM-DD HH24:MI:SS'')  AS LastModifiedTime,URN '; 


		v_QDTColStr := ', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20'; 
		--insert into testDebug values (v_QueryFilter);
	
		IF (((v_QueryFilter IS NULL OR v_QueryFilter = '' ) AND (v_QueueFilter IS NULL OR v_QueueFilter = '') AND (DBorderBy < 3)) AND
		(DBuserFilterStr IS NULL OR DBuserFilterStr = '')) THEN
		BEGIN
			
		v_queryStr := 'Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,ActivityId,  TO_CHAR(EntryDateTime,''YYYY-MM-DD HH24:MI:SS'') AS EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, TO_CHAR(ValidTill,''YYYY-MM-DD HH24:MI:SS'') AS ValidTill, Q_StreamId, Q_QueueId, 	Q_UserId, AssignedUser, FilterValue,TO_CHAR(CreatedDateTime,''YYYY-MM-DD HH24:MI:SS'') AS CreatedDateTime, WorkItemState, Statename,TO_CHAR(ExpectedWorkitemDelay,''YYYY-MM-DD HH24:MI:SS'') AS ExpectedWorkitemDelay , PreviousStage, LockedByName, LockStatus, TO_CHAR(LockedTime,''YYYY-MM-DD HH24:MI:SS'') AS LockedTime,TO_CHAR(IntroductionDateTime,''YYYY-MM-DD HH24:MI:SS'') AS IntroductionDateTime, Queuename, Queuetype, NotifyStatus ,ProcessVariantId, Q_DivertedByUserId,ActivityType,TO_CHAR(LastModifiedTime,''YYYY-MM-DD HH24:MI:SS'')  AS LastModifiedTime,URN  From WFInstrumentTable '; 	
			
		v_queryStr := v_queryStr || v_queryFilterStr ||  ' AND  RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' 
		AND ( (LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar  ||') 
		OR (LockStatus = ' || v_quoteChar || 'Y'|| v_quoteChar|| ' AND Q_UserID = ' || v_userIndex || '))'		
		|| NVL(v_lastValueStr,'') || v_orderByStr || ' FOR UPDATE'; 
					
		END;
		ELSE 
		BEGIN
			IF(DBOrderBy > 100 AND (v_sortFieldStr IS NOT NULL OR v_sortFieldStr != '')) THEN
			v_queryStr := 'SELECT ' || v_WLTColStr1 || v_sortFieldStrCol || ' FROM ( SELECT * FROM (SELECT ' || v_WLTColStr ||v_QDTColStr || NVL(v_AliasStr,'') || ' FROM WFInstrumentTable ';
			ELSE
				v_queryStr := 'SELECT '|| v_WLTColStr1 || ' FROM ( SELECT * FROM (SELECT ' || v_WLTColStr || v_QDTColStr || NVL(v_AliasStr,'') || ' FROM WFInstrumentTable ';
			END IF;

			/*IF((v_QueryFilter IS NULL OR v_QueryFilter = '') AND v_QueueFilter IS NOT NULL ) THEN
			BEGIN
				v_QueueFilter := ' AND ' || v_QueueFilter; 
			END;
			ELSIF (v_QueryFilter IS NOT NULL) THEN
			BEGIN
				v_queryFilterStr2 := NVL(v_queryFilterStr2,'') || ' AND ' || '('||v_QueryFilter||')';
				v_QueueFilter := '';
			END;
			END IF;*/
			IF((v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0)  
			AND (v_QueueFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueueFilter))) > 0)) THEN
			BEGIN
				v_QueueFilter := ' AND (' || v_QueueFilter || ' AND '||v_QueryFilter||') '; 
			END;
			ELSIF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0) THEN
			BEGIN
				v_queryFilterStr2 := NVL(v_queryFilterStr2,'') || ' AND ' || '('||v_QueryFilter||')';
				v_QueueFilter := '';
			END;
			ELSIF (v_QueueFilter IS NOT NULL  AND LENGTH(LTRIM(RTRIM(v_QueueFilter))) > 0) THEN
			BEGIN
				v_queryFilterStr2 := NVL(v_queryFilterStr2,'') || ' AND ' || '('||v_QueueFilter||')';
				v_QueueFilter := '';
			END;
			END IF;		
			
			v_queryStr := 'select * from (' ||v_queryStr || v_ExtTableStrCondition ||' ) Table1 ' || NVL(v_queryFilterStr,'') || ' AND  RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' AND ( (LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar  ||') 
			OR (LockStatus = ' || v_quoteChar || 'Y'|| v_quoteChar|| ' AND Q_UserID = ' || v_userIndex || '))'		
			|| NVL(v_lastValueStr,'');
			
			IF( v_Q_UserId = 0) THEN
			BEGIN
			 v_queryStr := v_queryStr || NVL(v_queryFilterStr2,'') ;
			END;
			END IF;

			v_queryStr := v_queryStr || NVL(v_QueueFilter,'')|| NVL(DBuserFilterStr,'');
			
			if(v_ProcessInstanceId is null or v_ProcessInstanceId='') THEN
			BEGIN
				v_queryStr:=v_queryStr||NVL(v_orderByStr,'') ; 
			END;
			END IF;
			
			v_queryStr:=v_queryStr|| ') Table2 ) where ROWNUM <= 1 FOR UPDATE'; 
			
			/*To avoid - cannot select FOR UPDATE from view with DISTINCT, GROUP BY, etc.*/
			IF ( ((v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') AND DBQueueType = N'F') OR (v_ProcessInstanceId IS NOT NULL ) ) THEN
			BEGIN
				v_queryStr := v_queryStr || '';
			END;
			END IF;
		END;
		END IF;
		--insert into testDebug values('DBUSerFilter'||DBuserFilterStr);
		IF ( ((v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') AND DBQueueType = N'F') OR ((v_ProcessInstanceId IS NOT NULL ) AND (DBQueueType = '' OR DBQueueType IS NULL ) ) ) THEN
		BEGIN
			v_queryStr := v_queryStr;
		END;
		END IF;
			
		--insert into testGetWorkitem2 values(1,v_queryStr);commit;
		--insert into testDebug values (v_queryStr);
		IF(v_ExpiryFlag ='N') THEN
			SAVEPOINT LockWI;
		END IF;
		OPEN LockCur FOR v_queryStr;
		IF(DBOrderBy > 100 AND (v_sortFieldStr IS NOT NULL OR v_sortFieldStr != '')) THEN
		BEGIN
			FETCH LockCur INTO 
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId,
				v_Q_QueueId, v_Q_UserId, v_AssignedUser, v_FilterValue,
				v_CreatedDateTime, v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay,
				v_PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,v_IntroductionDateTime,
				v_Queuename, v_Queuetype, v_NotifyStatus,v_ProcessVarinatId, v_Q_DivertedByUserId,v_ActivityType,v_LastModifiedTime,v_URN, v_sortFieldStrValue;
		END;
		ELSE
		BEGIN	
			FETCH LockCur INTO 
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId,
				v_Q_QueueId, v_Q_UserId, v_AssignedUser, v_FilterValue,
				v_CreatedDateTime, v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay,
				v_PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,v_IntroductionDateTime,
				v_Queuename, v_Queuetype, v_NotifyStatus,v_ProcessVarinatId, v_Q_DivertedByUserId,v_ActivityType,v_LastModifiedTime,v_URN;
		END;
		END IF;
		v_tempQ_UserId := v_Q_UserId; /*to store Q_UserId original value as v_Q_UserId is modified later */
		v_rowCount := LockCur%ROWCOUNT;
		
		IF(v_rowCount > 0) THEN
		BEGIN
			v_found	:= 'Y';
			IF (v_CheckQueryWSFlag = 'N') THEN
				v_canLock := 'Y';
			ELSE
				v_canLock := 'N';
			END IF;
			BEGIN
				IF(DBorderBy = 1) THEN 
				BEGIN  
					v_sortFieldStrValue := v_PriorityLevel;
				END;  
				ElSIF(DBorderBy = 2) THEN  
				BEGIN  
					v_sortFieldStrValue := v_ProcessInstanceId;
				END;  
				ElSIF(DBorderBy = 3) THEN
				BEGIN  
					v_sortFieldStrValue := v_ActivityName; 
				END; 
				ElSIF(DBorderBy = 4) THEN
				BEGIN 
					v_sortFieldStrValue := v_LockedByName;  
				END;
				ElSIF(DBorderBy = 8) THEN
				BEGIN 
					v_sortFieldStrValue := v_LockStatus;
				END; 
				ElSIF(DBorderBy = 9) THEN
				BEGIN 
					v_sortFieldStrValue := v_WorkItemState; 
				END; 
				ElSIF(DBorderBy = 10) THEN
				BEGIN 
					v_sortFieldStrValue := v_EntryDateTime;
				END; 
				ElSIF(DBorderBy = 11) THEN
				BEGIN 
					v_sortFieldStrValue := v_ValidTill; --TO_DATE(v_ValidTill,'YYYY-MM-DD HH24:MI:SS');
				END; 
				ElSIF(DBorderBy = 12) THEN   
				BEGIN 
					v_sortFieldStrValue := v_LockedTime; --TO_DATE(v_LockedTime,'YYYY-MM-DD HH24:MI:SS');
				END;
				ElSIF(DBorderBy = 13) THEN   
				BEGIN 
					v_sortFieldStrValue := v_IntroductionDateTime; 
				END;
				ElSIF(DBorderBy = 17) THEN 
				BEGIN 
					v_sortFieldStrValue := v_Status;
				END; 
				ElSIF(DBorderBy = 18) THEN
				BEGIN 
					v_sortFieldStrValue := v_CreatedDateTime;--TO_DATE(v_CreatedDateTime,'YYYY-MM-DD HH24:MI:SS');
				END;
				ElSIF(DBorderBy = 19) THEN
				BEGIN 
					v_sortFieldStrValue := v_ExpectedWorkItemDelay; --TO_DATE(v_ExpectedWorkItemDelay,'YYYY-MM-DD HH24:MI:SS');
				END;
				ElSIF(DBorderBy = 20) THEN
				BEGIN
					v_sortFieldStrValue := v_ProcessedBy;
				END;
				END IF;
			END;
		END;
		ELSIF (v_bInQueue = 'Y' ) THEN 
		BEGIN
			--IF(v_LockedByNameTemp = NULL OR LENGTH(v_LockedByNameTemp) = 0 OR v_LockedByNameTemp = v_userName) THEN
				v_CheckQueryWSFlag := 'Y';
			--END IF;
				v_canLock := 'N';
			IF(v_ExpiryFlag ='N') THEN
				ROLLBACK TO SAVEPOINT LockWI;
			END IF;
		END;
		ELSE
		BEGIN
			IF(v_ExpiryFlag ='N') THEN
				ROLLBACK TO SAVEPOINT LockWI;
			END IF;	
		END;
		END IF;
		CLOSE LockCur;			
	END;
	END IF;
	
	IF(DBTaskId > 0) THEN
	BEGIN
		 v_found:= 'N';
	END;
	END IF;

	IF(v_found = 'Y') THEN
	BEGIN
		/* Condition modified as assignmentType can be null - Ruhi Hira */
		IF(v_canLock= 'Y' AND (v_AssignmentType IS NULL OR v_AssignmentType = '' OR 
			NOT (v_AssignmentType = 'F' OR v_AssignmentType = 'E' OR v_AssignmentType = 'A' OR (v_AssignmentType = 'H' AND v_WorkItemState = 8)))) THEN
		BEGIN
			IF(DBQueueId >= 0 AND DBQueueId != v_Q_QueueId) THEN
			BEGIN
				IF(v_ExpiryFlag ='N') THEN
					ROLLBACK TO SAVEPOINT LockWI;
				END IF;	
				/* Bug # WFS_5_116, so that WI is not available to any user in a dynamic queue after one user has performed done operation */
				out_mainCode := 810; /* Workitem not in the queue specified. */
				RETURN;
			END;
			END IF;
		END;
		ELSE
		BEGIN
			/* Bug # WFS_5_068 */
			/* Modified on : 27/12/2006, Bug # WFS_5_149 - Ruhi Hira */
			
			IF (v_userIndex = v_Q_UserId OR v_userIndex = v_Q_DivertedByUserId OR v_UtilityFlag = 'Y') THEN
				v_canLock := 'Y';
			ELSE 
				IF(v_ExpiryFlag ='N') THEN
					ROLLBACK TO SAVEPOINT LockWI;
				END IF;	
				v_canLock := 'N';
			END IF;
		END;
		END IF;

		IF(v_canLock = 'Y') THEN
		BEGIN
			IF(v_AssignmentType IS NULL) THEN
				v_AssignmentType := 'S';
			END IF;
			v_Q_UserId := v_userIndex;
			v_AssignedUser	:= v_userName;
			v_WorkItemState	:= 2;
			v_StateName := 'RUNNING';
			v_LockedByName	:= v_userName;
			v_LockStatus := 'Y';
			v_LockedTime := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
			v_AssignQ_QueueId := v_Q_QueueId;				
			v_AssignFilterVal := v_FilterValue;
			v_AssignQueueType := v_Queuetype;			
			v_AssignQueueName := v_Queuename;
				
			
			IF(DBQueueType = N'F' AND DBAssignMe = 'Y') THEN
				v_AssignmentType  := 'F';
				v_AssignQ_QueueId := 0;
				v_AssignFilterVal := NULL;
				v_AssignQueueType := 'U';
				v_AssignQueueName := v_userName + '''s MyQueue';
					
			END IF;

			/*DELETE	FROM WORKLISTTABLE
			WHERE	ProcessInstanceID = v_ProcessInstanceId
			AND	WorkItemID = v_WorkitemId;*-/

			/*v_rowCount := SQL%ROWCOUNT;
			
			IF(v_Queuetype != 'F' OR DBQueueId > 0) THEN
			BEGIN
				v_rowCount := 1;			
			END;
			ELSE
				v_rowCount := 0;
			END IF ;*/

			--IF(v_Queuetype != 'F' OR (v_Queuetype = 'F' AND DBQueueId > 0)) THEN 
			v_rowCount := 0;
			IF(v_ExpiryFlag ='N') THEN	--Start of If A
			BEGIN
				IF(v_Queuetype != 'F' OR (v_Queuetype = 'F' AND v_Q_QueueId > 0 AND v_tempQ_UserId = v_userIndex) OR  (v_Queuetype = 'F' AND v_Q_QueueId > 0 AND 
				(DBProcessInstanceId IS NULL OR DBProcessInstanceId = '')  OR (v_Queuetype = 'F' AND v_AssignmentType='H')) ) THEN 
				BEGIN
					Update WFInstrumentTable set ASSIGNMENTTYPE = v_AssignmentType , Q_USERID = v_Q_UserId,
						ASSIGNEDUSER = v_AssignedUser, WORKITEMSTATE = v_WorkItemState , STATENAME = v_Statename ,
						LOCKEDBYNAME = v_LockedByName ,LOCKSTATUS = v_LockStatus ,  LOCKEDTIME = TO_DATE(v_LockedTime,'YYYY-MM-DD HH24:MI:SS') ,
						Q_QUEUEID = v_AssignQ_QueueId , FILTERVALUE = v_AssignFilterVal ,QUEUETYPE = v_AssignQueueType,QUEUENAME = v_AssignQueueName 
						WHERE ProcessInstanceId = v_ProcessInstanceId and WorkItemId = v_WorkItemId AND (LockStatus = 'N' OR (LockStatus = 'Y' AND LockedByName = v_LockedByName));
					v_rowCount := SQL%ROWCOUNT;
				END;
				ELSE
					--ROLLBACK TO SAVEPOINT LockWI;
					v_rowCount := 0;
				END IF;
		
				IF(v_rowCount > 0) THEN 
				BEGIN
					COMMIT;
					out_lockFlag := 'Y';
				END;
				ELSE
					ROLLBACK TO SAVEPOINT LockWI;
				END IF;
			END;
			END IF;-- End of IF A
			
				IF(out_lockFlag = 'Y' AND v_genLog = 'Y' AND v_ExpiryFlag = 'N' ) THEN
				BEGIN
					WFGenerateLog(7, v_userIndex, v_ProcessDefId, v_activityId, v_Q_QueueId, v_userName, v_ActivityName, 0, v_ProcessInstanceId, 0, NULL, v_workitemId, 0, 0, v_GenLogMainCode, NULL,0,0,0,v_URN,NULL,NULL,v_tarHisLog,v_targetCabinet);
				END;
				ELSIF (out_lockFlag = 'N') THEN
						out_mainCode := 16;		/* WorkItem might be locked by some other user while this user is trying to lock */
				END IF;
			END;
			ELSE 
				v_CheckQueryWSFlag := 'Y';
				out_mainCode := 300;	/* no authorization */
			END IF;
		END;
--	ELSIF (v_bInQueue = 'Y' OR v_canLock = 'N') THEN 
	ELSIF (v_CheckQueryWSFlag = 'N') THEN 
	
	BEGIN
		IF(v_processInstanceId IS NOT NULL AND LENGTH(v_processInstanceId) > 0) THEN
		BEGIN
			SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId,ActivityType,TO_CHAR(LastModifiedTime,'YYYY-MM-DD HH24:MI:SS'),URN
			INTO
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus, v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN
			/*FROM	WORKINPROCESSTABLE */
			FROM WFINSTRUMENTTABLE
			WHERE	ProcessInstanceID = v_ProcessInstanceId
			AND	WorkItemID = v_WorkitemId/*Process Variant Support*/
			AND RoutingStatus = 'N';
			/** 18/01/2008, Bugzilla Bug 3549, RowCount was not initialized - Ruhi Hira */
			v_rowCount := SQL%ROWCOUNT; 
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_rowCount := 0;
		
				IF(v_ActivityType=32) THEN
				BEGIN
							BEGIN
							SELECT	max(CanInitiate),max(ShowCaseVisual) 
							INTO
							v_CanInitiate,v_showCaseVisual
							FROM WFTaskStatusTable
							WHERE	ProcessInstanceID = v_ProcessInstanceId
							AND	WorkItemID = v_WorkitemId
							AND	ActivityId = v_ActivityId 
							AND ASSIGNEDTO = v_userName 
							AND TASKSTATUS != 4 ;
							EXCEPTION
							WHEN NO_DATA_FOUND THEN
								v_CanInitiate := 'N';
								v_showCaseVisual := 'N';
							END;
							
				END;
				END IF;
		END;
		ELSIF(v_processInstanceId IS NOT NULL AND LENGTH(v_processInstanceId) > 0) THEN
		BEGIN
				BEGIN
				SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
					LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
					ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
					Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
					WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
					LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId,ActivityType,TO_CHAR(LastModifiedTime,'YYYY-MM-DD HH24:MI:SS') ,URN
				INTO
					v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
					v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
					v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
					v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
					v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
					v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
					v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus, v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN
				/* FROM	WORKINPROCESSTABLE */
				FROM WFINSTRUMENTTABLE
				WHERE	ProcessInstanceID = v_ProcessInstanceId
				AND	WorkItemID = v_WorkitemId/*Process Variant Support*/
				AND RoutingStatus = 'N'
				AND LockStatus = 'Y';
				/** 18/01/2008, Bugzilla Bug 3549, RowCount was not initialized - Ruhi Hira */
				v_rowCount := SQL%ROWCOUNT; 
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						v_rowCount := 0;
				END;

				IF(v_ActivityType=32) THEN
				BEGIN
							BEGIN
							SELECT	max(CanInitiate),max(ShowCaseVisual) 
							INTO
							v_CanInitiate,v_showCaseVisual
							FROM WFTaskStatusTable
							WHERE	ProcessInstanceID = v_ProcessInstanceId
							AND	WorkItemID = v_WorkitemId
							AND	ActivityId = v_ActivityId 
							AND ASSIGNEDTO = v_userName 
							AND TASKSTATUS != 4 ;
							EXCEPTION
							WHEN NO_DATA_FOUND THEN
								v_CanInitiate := 'N';
								v_showCaseVisual := 'N';
							END;
							
				END;
				END IF;
				
		END;
		ELSE	/* For FIFO when workitem not in WorkListTable and some workitem is locked in WorkInProcessTable */
		BEGIN
			SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId,TO_CHAR(LastModifiedTime,'YYYY-MM-DD HH24:MI:SS'),URN 
			INTO
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus, v_ProcessVarinatId,v_LastModifiedTime,v_URN
			/*FROM	WORKINPROCESSTABLE */
			FROM WFINSTRUMENTTABLE
			WHERE	LockedByName =v_userName
			AND	Q_QueueId = DBQueueId
			AND	NOT ( processInstanceId = DBLastProcessInstanceId 
			AND	workitemId	= DBLastWorkitemId )
			AND RoutingStatus = 'N'
			AND LockStatus = 'Y'
			AND	ROWNUM <= 1;/*Process Variant Support*/

			v_rowCount := SQL%ROWCOUNT; 
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_rowCount := 0;
		END;
		END IF;

		IF(v_rowCount > 0) THEN
		BEGIN
			IF(DBTaskId>0) THEN
			BEGIN
				out_mainCode := 32;		/* Workitem locked, when workitem locked by some other user */
				v_CheckQueryWSFlag :='N';
			END;
			ELSIF(NOT (v_LockedByName = v_userName)) THEN
			BEGIN
				IF(v_Q_QueueId = 0) THEN
				BEGIN
					out_mainCode := 300;		
					v_CheckQueryWSFlag :='Y';
				END;
				ELSE
				BEGIN
					out_mainCode := 16;		/* Workitem locked, when workitem locked by some other user */
					v_CheckQueryWSFlag :='N';
				END;
				END IF;
			END;
			ELSE
			BEGIN
				IF(DBQueueType = N'F' AND DBAssignMe = 'Y' AND NOT (v_AssignmentType = 'F') AND v_ExpiryFlag = 'N' ) THEN
				BEGIN
					v_AssignQueueName := v_userName + '''s MyQueue';
					/*Update WorkInProcessTable Set AssignmentType = N'F', QueueType = N'U', Q_QueueId = 0, QueueName = v_AssignQueueName, FilterValue = NULL */
					Update WFINSTRUMENTTABLE Set AssignmentType = N'F', QueueType = N'U', Q_QueueId = 0, QueueName = v_AssignQueueName, FilterValue = NULL
					WHERE	UPPER(LTRIM(LockedByName)) = UPPER(LTRIM(v_userName))
					AND	Q_QueueId = DBQueueId
					AND	processInstanceId = v_ProcessInstanceId 
					AND	workitemId	= v_WorkItemId;
				END;				
				END IF;				
			END;
			END IF;
		END;
		ELSE
		BEGIN
			IF(v_rowCount < 1) THEN
			BEGIN
				IF(v_processInstanceId IS NOT NULL AND LENGTH(v_processInstanceId) > 0) THEN
				BEGIN
					v_CheckQueryWSFlag := 'Y';
					out_mainCode := 300;		/* NO Authorization */
					BEGIN
						SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
							LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
							ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
							Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, NULL, CreatedDateTime,
							WorkItemState, Statename, NULL, PreviousStage, LockedByName, 
							LockStatus, LockedTime, Queuename, Queuetype, NULL, ProcessVariantId,TO_CHAR(LastModifiedTime,'YYYY-MM-DD HH24:MI:SS'),URN
						INTO
							v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
							v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, 
							v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, 
							v_LockedByName, v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, 
							v_NotifyStatus, v_ProcessVarinatId,v_LastModifiedTime,v_URN
						FROM	QUEUEHISTORYTABLE 
						WHERE	ProcessInstanceID = v_ProcessInstanceId
						AND	WorkItemID = v_WorkitemId;/*Process Variant Support*/
						v_rowCount := SQL%ROWCOUNT; 			
						EXCEPTION
							WHEN NO_DATA_FOUND THEN
								v_rowCount := 0;
						IF(v_rowCount >=1) THEN
						BEGIN
							v_tableName1 := 'QUEUEHISTORYTABLE';
						END;
						END IF;
					END;				

					IF(v_rowCount < 1) THEN
					BEGIN
						BEGIN
							SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
								LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
								ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
								Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
								WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
								LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus,RoutingStatus, ProcessVariantId,ActivityType,TO_CHAR(LastModifiedTime,'YYYY-MM-DD HH24:MI:SS'),URN  
							INTO
								v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
								v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
								v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
								v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
								v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
								v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
								v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus, v_RoutingStatus,v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN
							/* FROM	PENDINGWORKLISTTABLE */
							FROM WFINSTRUMENTTABLE
							WHERE	ProcessInstanceID = v_ProcessInstanceId
							AND	WorkItemID = v_WorkitemId;/*Process Variant Support*/
							v_rowCount := SQL%ROWCOUNT; 
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_rowCount := 0;
						END;	
						
						IF(v_rowcount > 0) THEN
						BEGIN
							IF(v_RoutingStatus = 'R' AND v_ActivityType != 2 ) THEN
							BEGIN
								IF(v_Q_UserId = v_userIndex ) THEN
								BEGIN
									v_CheckQueryWSFlag := 'N';
									out_mainCode := 16;		/* Open WorkItem in Read only mode */
								END;
								END IF;			
							END;
							END IF;
						END;
						
						ELSIF(v_rowCount < 1) THEN
						BEGIN
								out_mainCode := 22; /* Bugzilla Bug 7199, MainCode changed to Invalid_Workitem. */
								RETURN;
						END;
						
						END IF;	
					END;
					END IF;		
				END; 
				ELSE
				BEGIN
					out_mainCode := 18;			/* NO more data for FIFO when only queueId is given */
					RETURN;
				END;
				END IF;
			END; 
			END IF;
		END; /* Else workitem found in WorkInProcessTable */
		END IF;
	END;	
	END IF;
	IF (INSTR(v_Queuename,v_quoteChar) >0 )THEN
	BEGIN
		v_Queuename := REPLACE(v_Queuename,v_quoteChar,'''''');
	END;	
	END IF;
	
	IF (INSTR(v_AssignedUser,v_quoteChar) >0 )THEN 
	BEGIN 
		v_AssignedUser := REPLACE(v_AssignedUser,v_quoteChar,''''''); 
	END;	 
	END IF;
	
	IF (INSTR(v_ProcessedBy,v_quoteChar) >0 )THEN 
	BEGIN 
		v_ProcessedBy := REPLACE(v_ProcessedBy,v_quoteChar,''''''); 
	END;	 
	END IF; 
	IF (INSTR(v_LockedByName,v_quoteChar) >0 )THEN 
	BEGIN 
		v_LockedByName := REPLACE(v_LockedByName,v_quoteChar,''''''); 
	END;	 
	END IF;
	
	IF(v_CheckQueryWSFlag = 'Y' ) THEN	/* Query WorkStep Handling */
	BEGIN
		/* 21/01/2008, Bugzilla Bug 1721, error code 810 - Ruhi Hira */
		IF(DBQueueId >= 0 AND ( (v_Q_QueueId IS NULL) OR (DBQueueId != v_Q_QueueId) ) )THEN
		BEGIN
			out_mainCode := 810; /* Workitem not in the queue specified. */
			RETURN;
		END;
		END IF;
		IF(v_UtilityFlag = 'N') THEN
		BEGIN		
			BEGIN
			/*WFS_8.0_031*/
					SELECT ActivityId, QueryPreview ,EditableonQuery,QueueId INTO v_QueryActivityId ,v_QueryPreview, v_editableOnQuery ,v_queryQueueId FROM (
					SELECT ACTIVITYTABLE.ActivityId , QUSERGROUPVIEW.QueryPreview ,QUSERGROUPVIEW.EditableonQuery,QueueStreamTable.QueueId
					FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUSERGROUPVIEW
					WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
					AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
					AND QUSERGROUPVIEW.QueueId = QUEUESTREAMTABLE.QueueId
					AND ACTIVITYTABLE.ActivityType = 11
					AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
					AND QUSERGROUPVIEW.UserId = v_userIndex
					ORDER BY QUSERGROUPVIEW.GroupId DESC
					)WHERE ROWNUM <= 1;

					v_rowCount := SQL%ROWCOUNT; 
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						v_rowCount := 0;
			END;
			IF(v_rowCount <= 0) THEN
				BEGIN
					SELECT ActivityId, QueryPreview, EditableonQuery,QueueId INTO v_QueryActivityId ,v_QueryPreview , v_editableOnQuery,v_queryQueueId FROM (
						SELECT ACTIVITYTABLE.ActivityId , QUEUEUSERTABLE.QueryPreview , QUEUEUSERTABLE.EditableonQuery,QueueStreamTable.QueueId
						FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUEUEUSERTABLE,wfgroupmemberview
						WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
						AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
						AND QUEUEUSERTABLE.QueueId = QUEUESTREAMTABLE.QueueId
						AND ACTIVITYTABLE.ActivityType = 11
						AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
						AND QUEUEUSERTABLE.UserId = wfgroupmemberview.groupindex
						AND wfgroupmemberview.userindex = v_userIndex
						AND associationtype=1
						ORDER BY QUEUEUSERTABLE.UserId DESC
						)WHERE ROWNUM <= 1;
						
						v_rowCount := SQL%ROWCOUNT; 
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							v_rowCount := 0;
				END;
				IF(v_rowCount <= 0) THEN
					BEGIN
					/* If activity type is case workstep i.e 32, we have to check if workitem is being opened for a case worker 
					   or case participant . In that case, we have to return main code 16 (Read only mode ) in place of no authorization */
					  IF(v_activitytype=32) then
						  BEGIN
							  BEGIN						
								SELECT	max(CanInitiate),max(ShowCaseVisual) 
								INTO
								v_CanInitiate,v_showCaseVisual
								FROM WFTaskStatusTable
								WHERE	ProcessInstanceID = v_ProcessInstanceId
								AND	WorkItemID = v_WorkitemId
								AND	ActivityId = v_ActivityId 
								AND ASSIGNEDTO = v_userName 
								AND TASKSTATUS != 4;
								v_rowCount := SQL%ROWCOUNT; 
								EXCEPTION
								  WHEN NO_DATA_FOUND THEN
									v_rowCount := 0;
								END;	
								IF(v_rowCount <= 0) THEN
								  BEGIN
								  out_mainCode := 300; /*No Authorization*/
								  RETURN;
								  END;
								  ELSE
								  BEGIN
									out_mainCode := 16; /*Read Only mode*/
								  END;
								END IF;
								--dbms_output.put_line ('Hello');
							END;
					  ELSE 
					  BEGIN
						  out_mainCode := 300; /*No Authorization*/
						  RETURN;
					  END;
					  END IF;
					END;
				ELSE
				BEGIN
					out_mainCode := 16; /*To be shown in Read only mode*/
					
					/*Need to check filter on query workstep queue */
					
					BEGIN 
						SELECT QueryFilter INTO v_QueryFilter FROM QueueUserTable  WHERE QueueId = v_queryQueueId AND UserId = v_userIndex AND AssociationType = 0; 
						v_rowCount := SQL%ROWCOUNT; 
					EXCEPTION  
						WHEN NO_DATA_FOUND THEN 
						v_rowCount := 0;  
					END;
					IF(v_rowCount > 0) THEN 
						BEGIN 
							IF (v_QueryFilter IS NOT NULL) THEN 
								v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', v_userIndex); 
								v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_userName); 
								v_orderByPos := INSTR(UPPER(v_QueryFilter), 'ORDER BY'); 
								IF (v_orderByPos != 0) THEN
									v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
								END IF; 
								Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
								v_QueryFilter := v_ParsedQueryFilter;
							END IF; 
						END;
					ELSE /*  group filter present*/
						BEGIN
							v_queryStr := '';
							v_queryStr := ' Select QueryFilter, GroupId ' ||' From Qusergroupview ' ||' Where GroupId IS NOT NULL ' ||' AND QueueId  = ' || TO_CHAR(v_queryQueueId) ||' AND UserId = ' || TO_CHAR(v_userIndex);

							FilterCur := dbms_sql.open_cursor; /* cursor id */
							DBMS_SQL.PARSE(FilterCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
			
							/* Columns to be fetched */
							DBMS_SQL.define_column(FilterCur,1,v_QueryFilter,2000); 
							DBMS_SQL.DEFINE_COLUMN(FilterCur, 2 , v_GroupId); 

							/* Execute the cursor */
							v_retval := dbms_sql.EXECUTE(FilterCur); 

							/* Fetch next row and close cursor in case of error */
							v_DBStatus := DBMS_SQL.fetch_rows(FilterCur); 

							v_counterInt := 1;
							WHILE(v_DBStatus  <> 0) LOOP 
								BEGIN
									DBMS_SQL.column_value(FilterCur,1,v_QueryFilter);
									DBMS_SQL.column_value(FilterCur, 2, v_GroupId); 
									v_QueryFilter := LTRIM(RTRIM(v_QueryFilter));
									IF (v_QueryFilter IS NOT NULL) THEN
										BEGIN
											v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter , '&<UserIndex>&', v_userIndex || '')));
											v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter ,'&<UserName>&', v_userName)));
											v_orderByPos := INSTR(UPPER(v_QueryFilter),v_toSearchStr);
											IF (v_orderByPos > 0) THEN					
												v_QueryFilter := SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
											END IF;
											Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
											v_QueryFilter := v_ParsedQueryFilter;
											Wfparsequeryfilter (v_QueryFilter, N'G', v_GroupId, v_ParsedQueryFilter);
											v_QueryFilter := v_ParsedQueryFilter;
											IF (LENGTH(v_QueryFilter) > 0) THEN
												BEGIN
													v_QueryFilter := '(' || v_QueryFilter || ')';
													IF v_counterInt = 1 THEN
														v_tempFilter :=  v_QueryFilter;
													ELSE
														v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
													END IF;	
													v_counterInt := v_counterInt + 1;
												END;
											END IF;
										END;
									ELSE
										BEGIN
											v_tempFilter := '';
										END;
									END IF;
									EXIT WHEN v_tempFilter IS NULL;
									v_DBStatus :=DBMS_SQL.fetch_rows(FilterCur);
								END;
							END LOOP; 
							DBMS_SQL.CLOSE_CURSOR(FilterCur); 
							EXCEPTION 
							WHEN OTHERS THEN 
								IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
									DBMS_SQL.CLOSE_CURSOR(FilterCur);  
								END IF;
								RETURN;
						END;
						v_QueryFilter := v_tempFilter;
					END IF;
					
					IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
						BEGIN
							v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');	
							IF(v_FunctionPos != 0) THEN
								v_FunLength := LENGTH('&<FUNCTION>&');
								BEGIN	
									v_functionFlag := 'Y';		
									WHILE(v_functionFlag = 'Y') LOOP
										BEGIN
											v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
											v_funPos1 := INSTR(v_QueryFilter, chr(123));				
						
											v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
											v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));						
						
											IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
												v_funPos2 := INSTR(v_QueryFilter, chr(125));
												v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
												v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
												queryFunStr := 'SELECT ' || v_funFilter || ' FROM DUAL ';							
												EXECUTE IMMEDIATE queryFunStr INTO v_FunValue;
							
												IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
													v_FunValue := '1 = 1';
												END IF;
							
												v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
											ELSE
												EXIT;
											END IF;							
											v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');
											IF(v_FunctionPos = 0) THEN
												v_functionFlag := 'N';
											END IF;					
										END;
									END LOOP;				
								END;	
							END IF;
						END;
					END IF;
				
					IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
						BEGIN
							v_queryStr := 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable left outer join VarMappingTable  on WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='||TO_CHAR(v_ProcessDefID)||' and WFSearchVariableTable.activityID ='||TO_CHAR(v_QueryActivityId)||' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C''';
							FilterCur := dbms_sql.open_cursor;
							DBMS_SQL.PARSE(FilterCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
							DBMS_SQL.define_column(FilterCur,1,v_fieldName,2000); 
							DBMS_SQL.DEFINE_COLUMN(FilterCur, 2 , v_extObjId); 
							DBMS_SQL.define_column(FilterCur,3,v_systemDefinedName,2000);
							v_retval := dbms_sql.EXECUTE(FilterCur); 
							v_DBStatus := DBMS_SQL.fetch_rows(FilterCur); 
							WHILE(v_DBStatus  <> 0) LOOP 
								BEGIN
									DBMS_SQL.column_value(FilterCur,1,v_fieldName);
									DBMS_SQL.column_value(FilterCur, 2, v_extObjId);
									DBMS_SQL.column_value(FilterCur,3,v_systemDefinedName);
									IF (v_fieldName IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0)THEN
										BEGIN
											IF v_extObjId=1 THEN
												BEGIN
													v_externalTaleJoin:='Y';
													v_finalColumnStr:=v_finalColumnStr||' , '||v_fieldName;
												END;
											ELSE
												BEGIN
													v_finalColumnStr:=v_finalColumnStr||' , '||v_systemDefinedName||' AS '||v_fieldName;
												END;
											END IF;
										END;
									END IF;
									v_DBStatus :=DBMS_SQL.fetch_rows(FilterCur);
								END;
							END LOOP;
							DBMS_SQL.CLOSE_CURSOR(FilterCur); 
							EXCEPTION 
								WHEN OTHERS THEN 
								IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
									DBMS_SQL.CLOSE_CURSOR(FilterCur);  
								END IF;
								RETURN;
						END;
					
					/*Checkin user is eligible to open the workitem or not */
						BEGIN
							v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
					
							v_query1:=' FROM WFINSTRUMENTTABLE   ';
					
							IF v_externalTaleJoin='Y' THEN
								BEGIN
									v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
					
									v_query1:=' FROM WFINSTRUMENTTABLE   INNER JOIN '||DBExternalTableName ||'   ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
						
								END;
							END IF;
					
					
							IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
								BEGIN
									v_queryStr:=v_queryStr||v_finalColumnStr;
								END;
							END IF;
					
							v_query1:=v_query1|| ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID=:PROCESSINSTANCEID  AND WFINSTRUMENTTABLE.WorkItemID=:WORKITEMID ';
					
							v_query1:='SELECT  processdefid from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
							BEGIN 
								EXECUTE IMMEDIATE v_query1 into v_tempCount USING v_ProcessInstanceId, v_WorkitemId;
								v_rowCount := SQL%ROWCOUNT; 
							EXCEPTION  
								WHEN NO_DATA_FOUND THEN 
									v_rowCount := 0;  
							END;
							If(v_RowCount <= 0) THEN
								BEGIN 
									v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
						
									v_query1:=' FROM QueueHistoryTable  ';
					
									IF v_externalTaleJoin='Y' THEN
										BEGIN
											v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
											If (v_extTableNameHistory IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_extTableNameHistory))) > 0) THEN
												BEGIN
													v_query1:=' FROM QueueHistoryTable   INNER JOIN '||v_extTableNameHistory ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
												END;
											ELSE
												BEGIN
													v_query1:=' FROM QueueHistoryTable  INNER JOIN '||DBExternalTableName ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
												END;
											END IF;
										END;
									END IF;
									
									IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
										BEGIN
											v_queryStr:=v_queryStr||v_finalColumnStr;
										END;
									END IF;
							
									v_query1:=v_query1|| ' WHERE QueueHistoryTable.ProcessInstanceID=:PROCESSINSTANCEID  AND QueueHistoryTable.WorkItemID=:WORKITEMID ';
									v_query1:='SELECT processdefid  from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
									BEGIN 
										EXECUTE IMMEDIATE v_query1 into v_tempCount USING v_ProcessInstanceId, v_WorkitemId;
										v_rowCount := SQL%ROWCOUNT; 
									EXCEPTION  
										WHEN NO_DATA_FOUND THEN 
											v_rowCount := 0;  
									END;
									If(v_RowCount <= 0) THEN
										BEGIN
											out_mainCode := 300;
											Return;
										END;
									END IF;
									
								END;
							END IF;
						END;
					END IF;
					/*filter Check END HERE */
					
					IF (v_editableOnQuery= 'Y' AND v_QueryPreview = 'Y') THEN
					BEGIN
						v_DBStatus := 0;
						V_queryStr2 :=' SELECT  processdefid FROM '||TO_CHAR(v_tableName1)||' WHERE PROCESSINSTANCEID= '''||TO_CHAR(v_ProcessInstanceId)||''' AND WORKITEMID= '||v_WorkitemId||'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''||TO_CHAR(v_userName)||''')) AND ROWNUM<=1 FOR UPDATE';
						SAVEPOINT LockWI1;
						BEGIN
							EXECUTE IMMEDIATE V_queryStr2 INTO v_exists;
							v_RowCount := SQL%ROWCOUNT;
							v_DBStatus := SQLCODE;
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_RowCount := 0;
						END;
						IF(v_DBStatus <> 0) THEN
						BEGIN
							ROLLBACK TO SAVEPOINT LockWI1;
							out_mainCode := 15;
							RETURN;
						END;
						END IF;
						IF(v_RowCount > 0) THEN
						BEGIN
							v_Q_UserId := v_userIndex;
							v_AssignedUser	:= v_userName;
							v_LockedByName	:= v_userName;
							v_LockStatus := 'Y';
							v_LockedTime := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
							V_queryStr2 :='Update '||TO_CHAR(v_tableName1)||' Set Q_UserId = '||v_Q_UserId||' ,LockedByName = '''||TO_CHAR(v_LockedByName) ||''', LockStatus ='''||TO_CHAR(v_LockStatus)||''' ,LockedTime = TO_DATE('''||v_LockedTime||''',''YYYY-MM-DD HH24:MI:SS'')   where ProcessInstanceId = '''||TO_CHAR(v_ProcessInstanceId)||''' and WorkItemId = '||v_WorkItemId;  
							EXECUTE IMMEDIATE V_queryStr2 ;
							v_rowCount := SQL%ROWCOUNT;
							v_DBStatus := SQLCODE;
							IF(v_DBStatus <> 0) THEN
							BEGIN
								ROLLBACK TO SAVEPOINT LockWI1;
								out_mainCode := 15;
								RETURN;
							END;
							END IF;
							IF(v_rowCount > 0) THEN
							BEGIN
								Commit ;
								out_mainCode := 0;
								out_lockFlag :='Y';
							END;
							ELSE
							BEGIN
								ROLLBACK TO SAVEPOINT LockWI1;
								out_mainCode := 16;
								out_lockFlag :='N';
							END;
							END IF;
						END;
						END IF;
					END;
					END IF;
					/*WFS_8.0_031*/
					IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
						v_ActivityId := v_QueryActivityId;
					END IF;
				END;
				END IF;
			ELSE
			BEGIN
				out_mainCode := 16; /*To be shown in Read only mode*/
				
				/*Need to check filter on query workstep queue */
					
					BEGIN 
						SELECT QueryFilter INTO v_QueryFilter FROM QueueUserTable  WHERE QueueId = v_queryQueueId AND UserId = v_userIndex AND AssociationType = 0; 
						v_rowCount := SQL%ROWCOUNT; 
					EXCEPTION  
						WHEN NO_DATA_FOUND THEN 
						v_rowCount := 0;  
					END;
					IF(v_rowCount > 0) THEN 
						BEGIN 
							IF (v_QueryFilter IS NOT NULL) THEN 
								v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', v_userIndex); 
								v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_userName); 
								v_orderByPos := INSTR(UPPER(v_QueryFilter), 'ORDER BY'); 
								IF (v_orderByPos != 0) THEN
									v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
								END IF; 
								Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
								v_QueryFilter := v_ParsedQueryFilter;
							END IF; 
						END;
					ELSE /*  group filter present*/
						BEGIN
							v_queryStr := '';
							v_queryStr := ' Select QueryFilter, GroupId ' ||' From Qusergroupview ' ||' Where GroupId IS NOT NULL ' ||' AND QueueId  = ' || TO_CHAR(v_queryQueueId) ||' AND UserId = ' || TO_CHAR(v_userIndex);

							FilterCur := dbms_sql.open_cursor; /* cursor id */
							DBMS_SQL.PARSE(FilterCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
			
							/* Columns to be fetched */
							DBMS_SQL.define_column(FilterCur,1,v_QueryFilter,2000); 
							DBMS_SQL.DEFINE_COLUMN(FilterCur, 2 , v_GroupId); 

							/* Execute the cursor */
							v_retval := dbms_sql.EXECUTE(FilterCur); 

							/* Fetch next row and close cursor in case of error */
							v_DBStatus := DBMS_SQL.fetch_rows(FilterCur); 

							v_counterInt := 1;
							WHILE(v_DBStatus  <> 0) LOOP 
								BEGIN
									DBMS_SQL.column_value(FilterCur,1,v_QueryFilter);
									DBMS_SQL.column_value(FilterCur, 2, v_GroupId); 
									v_QueryFilter := LTRIM(RTRIM(v_QueryFilter));
									IF (v_QueryFilter IS NOT NULL) THEN
										BEGIN
											v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter , '&<UserIndex>&', v_userIndex || '')));
											v_QueryFilter :=  LTRIM(RTRIM(REPLACE(v_QueryFilter ,'&<UserName>&', v_userName)));
											v_orderByPos := INSTR(UPPER(v_QueryFilter),v_toSearchStr);
											IF (v_orderByPos > 0) THEN					
												v_QueryFilter := SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
											END IF;
											Wfparsequeryfilter (v_QueryFilter, N'U', v_userIndex, v_ParsedQueryFilter);
											v_QueryFilter := v_ParsedQueryFilter;
											Wfparsequeryfilter (v_QueryFilter, N'G', v_GroupId, v_ParsedQueryFilter);
											v_QueryFilter := v_ParsedQueryFilter;
											IF (LENGTH(v_QueryFilter) > 0) THEN
												BEGIN
													v_QueryFilter := '(' || v_QueryFilter || ')';
													IF v_counterInt = 1 THEN
														v_tempFilter :=  v_QueryFilter;
													ELSE
														v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
													END IF;	
													v_counterInt := v_counterInt + 1;
												END;
											END IF;
										END;
									ELSE
										BEGIN
											v_tempFilter := '';
										END;
									END IF;
									EXIT WHEN v_tempFilter IS NULL;
									v_DBStatus :=DBMS_SQL.fetch_rows(FilterCur);
								END;
							END LOOP; 
							DBMS_SQL.CLOSE_CURSOR(FilterCur); 
							EXCEPTION 
							WHEN OTHERS THEN 
								IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
									DBMS_SQL.CLOSE_CURSOR(FilterCur);  
								END IF;
								RETURN;
						END;
						v_QueryFilter := v_tempFilter;
					END IF;
					
					IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
						BEGIN
							v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');	
							IF(v_FunctionPos != 0) THEN
								v_FunLength := LENGTH('&<FUNCTION>&');
								BEGIN	
									v_functionFlag := 'Y';		
									WHILE(v_functionFlag = 'Y') LOOP
										BEGIN
											v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
											v_funPos1 := INSTR(v_QueryFilter, chr(123));				
						
											v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
											v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));						
						
											IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
												v_funPos2 := INSTR(v_QueryFilter, chr(125));
												v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
												v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
												queryFunStr := 'SELECT ' || v_funFilter || ' FROM DUAL ';							
												EXECUTE IMMEDIATE queryFunStr INTO v_FunValue;
							
												IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
													v_FunValue := '1 = 1';
												END IF;
							
												v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
											ELSE
												EXIT;
											END IF;							
											v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');
											IF(v_FunctionPos = 0) THEN
												v_functionFlag := 'N';
											END IF;					
										END;
									END LOOP;				
								END;	
							END IF;
						END;
					END IF;
				
					IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
						BEGIN
							v_queryStr := 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable left outer join VarMappingTable  on WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='||TO_CHAR(v_ProcessDefID)||' and WFSearchVariableTable.activityID ='||TO_CHAR(v_QueryActivityId)||' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C''';
							FilterCur := dbms_sql.open_cursor;
							DBMS_SQL.PARSE(FilterCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
							DBMS_SQL.define_column(FilterCur,1,v_fieldName,2000); 
							DBMS_SQL.DEFINE_COLUMN(FilterCur, 2 , v_extObjId); 
							DBMS_SQL.define_column(FilterCur,3,v_systemDefinedName,2000);
							v_retval := dbms_sql.EXECUTE(FilterCur); 
							v_DBStatus := DBMS_SQL.fetch_rows(FilterCur); 
							WHILE(v_DBStatus  <> 0) LOOP 
								BEGIN
									DBMS_SQL.column_value(FilterCur,1,v_fieldName);
									DBMS_SQL.column_value(FilterCur, 2, v_extObjId);
									DBMS_SQL.column_value(FilterCur,3,v_systemDefinedName);
									IF (v_fieldName IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0)THEN
										BEGIN
											IF v_extObjId=1 THEN
												BEGIN
													v_externalTaleJoin:='Y';
													v_finalColumnStr:=v_finalColumnStr||' , '||v_fieldName;
												END;
											ELSE
												BEGIN
													v_finalColumnStr:=v_finalColumnStr||' , '||v_systemDefinedName||' AS '||v_fieldName;
												END;
											END IF;
										END;
									END IF;
									v_DBStatus :=DBMS_SQL.fetch_rows(FilterCur);
								END;
							END LOOP;
							DBMS_SQL.CLOSE_CURSOR(FilterCur); 
							EXCEPTION 
								WHEN OTHERS THEN 
								IF (DBMS_SQL.IS_OPEN(FilterCur)) THEN 
									DBMS_SQL.CLOSE_CURSOR(FilterCur);  
								END IF;
								RETURN;
						END;
					
					/*Checkin user is eligible to open the workitem or not */
						BEGIN
							v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
					
							v_query1:=' FROM WFINSTRUMENTTABLE   ';
					
							IF v_externalTaleJoin='Y' THEN
								BEGIN
									v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
					
									v_query1:=' FROM WFINSTRUMENTTABLE   INNER JOIN '||DBExternalTableName ||'   ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
						
								END;
							END IF;
					
					
							IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
								BEGIN
									v_queryStr:=v_queryStr||v_finalColumnStr;
								END;
							END IF;
					
							v_query1:=v_query1|| ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID=:PROCESSINSTANCEID  AND WFINSTRUMENTTABLE.WorkItemID=:WORKITEMID ';
					
							v_query1:='SELECT  processdefid from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
							BEGIN 
								EXECUTE IMMEDIATE v_query1 into v_tempCount USING v_ProcessInstanceId, v_WorkitemId;
								v_rowCount := SQL%ROWCOUNT; 
							EXCEPTION  
								WHEN NO_DATA_FOUND THEN 
									v_rowCount := 0;  
							END;
							If(v_RowCount <= 0) THEN
								BEGIN 
									v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
						
									v_query1:=' FROM QueueHistoryTable  ';
					
									IF v_externalTaleJoin='Y' THEN
										BEGIN
											v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
											If (v_extTableNameHistory IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_extTableNameHistory))) > 0) THEN
												BEGIN
													v_query1:=' FROM QueueHistoryTable   INNER JOIN '||v_extTableNameHistory ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
												END;
											ELSE
												BEGIN
													v_query1:=' FROM QueueHistoryTable  INNER JOIN '||DBExternalTableName ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
												END;
											END IF;
										END;
									END IF;
									
									IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
										BEGIN
											v_queryStr:=v_queryStr||v_finalColumnStr;
										END;
									END IF;
							
									v_query1:=v_query1|| ' WHERE QueueHistoryTable.ProcessInstanceID=:PROCESSINSTANCEID  AND QueueHistoryTable.WorkItemID=:WORKITEMID ';
									v_query1:='SELECT processdefid  from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
									BEGIN 
										EXECUTE IMMEDIATE v_query1 into v_tempCount USING v_ProcessInstanceId, v_WorkitemId;
										v_rowCount := SQL%ROWCOUNT; 
									EXCEPTION  
										WHEN NO_DATA_FOUND THEN 
											v_rowCount := 0;  
									END;
									If(v_RowCount <= 0) THEN
										BEGIN
											out_mainCode := 300;
											Return;
										END;
									END IF;
									
								END;
							END IF;
						END;
					END IF;
					/*filter Check END HERE */
				
				IF (v_editableOnQuery= 'Y' AND v_QueryPreview = 'Y') THEN
					BEGIN
						v_DBStatus := 0;
						V_queryStr2 :=' SELECT  processdefid FROM '||TO_CHAR(v_tableName1)||' WHERE PROCESSINSTANCEID= '''||TO_CHAR(v_ProcessInstanceId)||''' AND WORKITEMID= '||v_WorkitemId||'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''||TO_CHAR(v_userName)||''')) AND ROWNUM<=1 FOR UPDATE';
						SAVEPOINT LockWI1;
						BEGIN
							EXECUTE IMMEDIATE V_queryStr2 INTO v_exists;
							v_RowCount := SQL%ROWCOUNT;
							v_DBStatus := SQLCODE;
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_RowCount := 0;
						END;
						IF(v_DBStatus <> 0) THEN
						BEGIN
							ROLLBACK TO SAVEPOINT LockWI1;
							out_mainCode := 15;
							RETURN;
						END;
						END IF;
						IF(v_RowCount > 0) THEN
						BEGIN
							v_Q_UserId := v_userIndex;
							v_AssignedUser	:= v_userName;
							v_LockedByName	:= v_userName;
							v_LockStatus := 'Y';
							v_LockedTime := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
							V_queryStr2 :='Update '||TO_CHAR(v_tableName1)||' Set Q_UserId = '||v_Q_UserId||' ,LockedByName = '''||TO_CHAR(v_LockedByName) ||''', LockStatus ='''||TO_CHAR(v_LockStatus)||''' ,LockedTime = TO_DATE('''||v_LockedTime||''',''YYYY-MM-DD HH24:MI:SS'')   where ProcessInstanceId = '''||TO_CHAR(v_ProcessInstanceId)||''' and WorkItemId = '||v_WorkItemId;  
							EXECUTE IMMEDIATE V_queryStr2 ;
							v_rowCount := SQL%ROWCOUNT;
							v_DBStatus := SQLCODE;
							IF(v_DBStatus <> 0) THEN
							BEGIN
								ROLLBACK TO SAVEPOINT LockWI1;
								out_mainCode := 15;
								RETURN;
							END;
							END IF;
							IF(v_rowCount > 0) THEN
							BEGIN
								Commit ;
								out_mainCode := 0;
								out_lockFlag :='Y';
							END;
							ELSE
							BEGIN
								ROLLBACK TO SAVEPOINT LockWI1;
								out_mainCode := 16;
								out_lockFlag :='N';
							END;
							END IF;
						END;
						END IF;
					END;
					END IF;
				
				/*WFS_8.0_031*/
				IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
					v_ActivityId := v_QueryActivityId;
				END IF;
			END;
			END IF;
		END;
		END IF;
	END;
	END IF;
	v_queryStr := '' ;
	IF(v_ExpiryFlag = 'Y') THEN
		out_mainCode := 401; --To be shown in Read only mode that will be handled in API
	END IF;

	/* Bug # WFS_5_089, Max Open Cursor exceeded - Ruhi Hira */
	/* Changed By Varun Bhansaly On 22/06/2007 for Bugzilla Id 1187 */
	IF((v_LockedByName = v_userName)and (v_ActivityType=32)) THEN
			BEGIN
				v_showCaseVisual :='Y';
				v_CanInitiate :='Y';
			END;
	END IF;   
		
	/* Logging for work started */
	IF(v_exists <> 0 AND out_lockFlag='Y' AND v_genLog = 'Y') THEN
	BEGIN
		WFGenerateLog(7, v_userIndex, v_ProcessDefId, v_activityId, v_Q_QueueId, v_userName, v_ActivityName, 0, v_ProcessInstanceId, 0, NULL, v_workitemId, 0, 0, v_GenLogMainCode, NULL,0,0,0,v_URN,NULL,NULL,v_tarHisLog,v_targetCabinet);
	END;
	END IF;
	IF((out_mainCode = 0 OR out_mainCode = 16 OR out_mainCode = 401)  AND v_genLog = 'Y' AND v_WorkStartedLoggingEnabled = 'Y') THEN
	BEGIN
			WFGenerateLog(200, v_userIndex, v_ProcessDefId, v_activityId, v_Q_QueueId, v_userName, v_ActivityName, 0, v_ProcessInstanceId, 0, NULL, v_workitemId, 0, 0, v_GenLogMainCode, NULL,0,0,0,v_URN,NULL,NULL,v_tarHisLog,v_targetCabinet);
	END;
	END IF;
	IF(v_sortFieldStrValue is NOT NULL) THEN
		v_sortFieldStrValue:=REPLACE(v_sortFieldStrValue,v_quoteChar,v_quoteChar||v_quoteChar);
	END IF;
	/* Bug # WFS_5_089, Max Open Cursor exceeded - Ruhi Hira */
	/* Changed By Varun Bhansaly On 22/06/2007 for Bugzilla Id 1187 */
	v_queryStr := ' SELECT ' || v_userIndex || ' UserIndex, ' || v_quoteChar || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || v_quoteChar || ' CurrentDateTime, ' || 
				v_quoteChar || v_ProcessInstanceId || v_quoteChar || ' ProcessInstanceId, ' ||	v_WorkItemId || ' WorkItemId, ' ||
				v_quoteChar || v_ProcessName ||  v_quoteChar || ' ProcessName, ' || NVL(v_ProcessVersion,0) ||
				' ProcessVersion, ' || v_ProcessDefID || ' ProcessDefID, ' || v_quoteChar || v_ProcessedBy || v_quoteChar || ' ProcessedBy, ' ||
				v_quoteChar || v_ActivityName || v_quoteChar || ' ActivityName, ' || NVL(v_ActivityId,0) || ' ActivityId, ' ||  
				v_quoteChar || v_EntryDateTime || v_quoteChar || 
				' EntryDateTime, ' || v_quoteChar || v_AssignmentType || v_quoteChar || ' AssignmentType, ' || 
				NVL(v_PriorityLevel,0) || ' PriorityLevel, ' || v_quoteChar || v_ValidTill || 
				v_quoteChar || ' ValidTill, ' || NVL(v_Q_QueueId,0) || ' Q_QueueId, ' || NVL(v_Q_UserId,0) ||
				' Q_UserId, ' || v_quoteChar || v_AssignedUser || v_quoteChar || ' AssignedUser, ' || 
				v_quoteChar || v_CreatedDateTime || v_quoteChar || 
				' CreatedDateTime, ' || NVL(v_WorkItemState,0) || ' WorkItemState, ' || v_quoteChar || v_Statename || v_quoteChar || ' Statename, ' || 
				v_quoteChar || v_ExpectedWorkitemDelay || v_quoteChar || 
				' ExpectedWorkitemDelay, ' || v_quoteChar || v_PreviousStage || v_quoteChar || ' PreviousStage, ' || v_quoteChar || v_LockedByName || 
				v_quoteChar || ' LockedByName, ' || v_quoteChar || v_LockStatus || v_quoteChar || ' LockStatus, ' ||	
				v_quoteChar || v_LockedTime|| v_quoteChar || ' LockedTime, ' || v_quoteChar || 
				v_Queuename || v_quoteChar || ' Queuename,  ' || v_quoteChar || v_Queuetype || 

				v_quoteChar || ' Queuetype, '|| v_quoteChar || v_userName || v_quoteChar ||' UserName, '|| v_quoteChar || v_ProcessVarinatId || v_quoteChar ||' ProcessVariantId,
				' || v_quoteChar || v_CanInitiate || v_quoteChar || ' CanInitiate,'||v_quoteChar||v_showCaseVisual||v_quoteChar ||' ShowCaseVisual,'  ||v_quoteChar||v_LastModifiedTime||v_quoteChar ||' LastModifiedTime,' ||  v_quoteChar || v_URN || v_quoteChar || ' URN ,'|| v_quoteChar || v_sortFieldStrValue || v_quoteChar || ' SortedOn FROM DUAL';/*Process Variant Support*/
			
	OPEN RefCursor FOR TO_CHAR(v_queryStr);		
EXCEPTION
	WHEN OTHERS THEN
		/* Bug # WFS_5_089, Max Open Cursor exceeded - Ruhi Hira */
 		CLOSE RefCursor;
		RAISE;

END;