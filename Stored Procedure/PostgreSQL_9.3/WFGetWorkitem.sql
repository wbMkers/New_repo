/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: WFGetWorkItem.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 12 May 2016
	Description					: To lock the workitem and return the data
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
07/19/2016      RishiRam Meel	Changes done for the following case reported during UT On postgresql .
                                1.Case Worker is not able to open the case file view : error User is not authorized.
                                2.If click on completed Workitem of Export process. It shows error.
28/07/2016      RishiRam Meel   Changes done for Bug 63130 -IBPS3.0 (with CM)||start workitem|| navigate to swimlane||Invalid filter
27/12/2016		Mohnish Chopra	Changes for Bug 66435 (Workitem is not opening when filter CreatedByName=UserName is applied on Start event queue)
06/04/2017		Sajid Khan 		Bug 66305 - Handling for restricting FIFO workitem from opening in modify mode if fetched through advanced
								search by supplying queue name[Bug Merging]
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
03/08/2017		Kumar Kimil     	Bug 70043 - Entry for action id 200 is getting inserted while performing the reassign operation from webdesktop
3/08/2017	Sajid Khan		Bug 70870 - Unable to Temporary Unhold a workitme which was temporarily holded from FIFO type of Queue
16-08-2017	Mohnish Chopra		Changes for Case Management - Queue variable header alias should allow spaces
21/08/2017		Sajid Khan		A Very specific case where workitem was getting assigned to the user opening it.
17/10/2017	Mohnish Chopra		Case registeration Name changes requirement- Added URN in output of WFGetWorkItemDataExt API
27/10/2017	Ambuj Tripathi		Bug#72932 User-desktop:: Getting error message while creating new work-item, Changes in query
16-01-18	Ambuj Tripathi		Bug 73224 - The variable size which is used to hold user name should be sufficient
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
19-05-2018	Sajid Khan			Bug 77183	Previous-Next Functionality to be implemented on ORACLE and POSTGRES SQL Database
28-01-2019    Shubham Singla    Bug 82669 - Ibps 3.0 sp1+ Postgres: When function is used in query filter,error is coming while 	fetching workitems
29/03/2019 Ravi Ranjan Kumar   Bug 83885 - When workitem is present in myqueue and locked by me then other user able to open in read only mode if user does not have any rights
09/07/2019	Mohnish Chopra		Bug 85547 - Not able to open workitem in case external table's data migrated to SecondaryDB and alias is defined on Extended Queue variable
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
26/11/2019	Ravi Ranjan Kumar	Bug 88613 - Unable to done task, getting error "No Authorization".
18/02/2020		Ravi Ranjan Kumar	Bug 90769 - Query Queue Filter is not calculated in WFGetWorkitem API when user opeing the workitem.
22/02/2020		Ravi Rnjan Kumar	Bug 90873 - Exception raised on execution of the rule definition 
22/12/2020     Ravi Raj Mewara      Bug 96606 - Aurora+iBPS 5.0 SP-1:- Prev Next Funcationality not working on WI.
02/02/2021      Ravi raj mewara     Bug 97563 - iBPS 5.0 SP1 : Locked workitem is opening in editable mode when user other than lockedByUser trying to open it 
26/05/2021  Ravi Raj Mewara    Bug 99548 - iBPS 5.0 SP2: If a workitem is temporary hold by any user then only that user can open it in editable mode and only badmin or that particular user can unhold the workitem.
05/10/2021  Ravi Raj Mewara    Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp
07/03/2022	Vardaan Arora			Bug 106170 - iBPS 5.0 SP2 + PostgreSQL : Error in opening work-items post searching when a queue filter based on &UserIndex& is applied. 
12/04/2023	Aqsa hashmi			Bug 126665 - The issue is happening in applying function filter for group in postgres.
_______________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFGetWorkItem
(	
	DBSessionId				INTEGER,
	DBProcessInstanceId		VARCHAR,
	DBWorkItemId			INTEGER,
	DBQueueId				INTEGER,
	DBQueueType				VARCHAR,		/* ' -> Search; F -> FIFO; D, S, N -> WIP */
	DBLastProcessInstanceId	VARCHAR,
	DBLastWorkitemId		INTEGER,
	DBGenerateLog			VARCHAR,
	DBAssignMe				VARCHAR,
	DBTaskId				INTEGER,
	DBUtilityFlag 			VARCHAR,
	DBOrderBy				INTEGER,
	DBSortOrder				VARCHAR,
	DBLastValue				VARCHAR,
	DBClientOrderFlag		VARCHAR,
	DBuserFilterStr			VARCHAR,
	DBExternalTableName			VARCHAR,
	DBHistoryTableName			VARCHAR	
)
RETURNS REFCURSOR AS $$
DECLARE 
	
	/* Declare workitem data common in five tables and QueueHistoryTable */
	v_ProcessInstanceId		VARCHAR(63);
	v_WorkItemId			INTEGER;
	v_ProcessName 			VARCHAR(30);
	v_ProcessVersion  		INTEGER;
	v_ProcessDefID 			INTEGER;
	v_LastProcessedBy 		INTEGER;
	v_ProcessedBy			VARCHAR(63);
	v_ActivityName 			VARCHAR(30);
	v_ActivityId 			INTEGER;
	v_EntryDateTime 		VARCHAR(50);
	v_ParentWorkItemId		INTEGER;
	v_AssignmentType		VARCHAR(1);
	v_CollectFlag			VARCHAR(1);
	v_PriorityLevel			INTEGER;
	v_ValidTill				VARCHAR(50);
	v_Q_StreamId			INTEGER;
	v_Q_QueueId				INTEGER;
	v_Q_UserId				INTEGER;
	v_AssignedUser			VARCHAR(63);
	v_FilterValue			INTEGER;
	v_CreatedDatetime		VARCHAR(50);
	v_WorkItemState			INTEGER;
	v_Statename 			VARCHAR(255);
	v_ExpectedWorkitemDelay	VARCHAR(50);
	v_PreviousStage			VARCHAR(30);
	v_LockedByName			VARCHAR(63);
	v_LockStatus			VARCHAR(1);
	v_LockedTime			VARCHAR(50);
	v_IntroductionDateTime	VARCHAR(50);
	v_Queuename 			VARCHAR(63);
	v_Queuetype 			VARCHAR(1);
	v_NotifyStatus			VARCHAR(1); 
	v_QueryPreview			VARCHAR(1);
	v_LastModifiedTime		VARCHAR(50);
	v_URN					VARCHAR(63);
	/* Declare intermmediate variables */
	v_DBStatus				INTEGER;
	v_rowCount				INTEGER;
	v_userIndex				INTEGER;
	v_qdt_filterOption		INTEGER;
	v_orderByPos			INTEGER;	
	v_counterInt			INTEGER; 	
	v_QueryActivityId       INTEGER;
	v_iOrder				INTEGER;
	v_iFirstOrder			INTEGER;
	v_len					INTEGER;
	v_groupId				INTEGER;
	v_mainCode				INTEGER;
	v_found					VARCHAR(1);
	v_canLock				VARCHAR(1);
	v_userName				VARCHAR(63);
	v_status				VARCHAR(1);
	v_queryStr				TEXT;
	v_queryFilterStr		VARCHAR(4000);
	v_queryFilterStr2		VARCHAR(4000);
	v_orderByStr			VARCHAR(200);
	v_quoteChar 			VARCHAR(1);
	v_toSearchStr			VARCHAR(20);
	v_QueryFilter			VARCHAR(2000);
	v_tempFilter			VARCHAR(2000);
	v_tableStr				VARCHAR(200);
	v_QueueDataTableStr		VARCHAR(30);
	v_tableName				VARCHAR(256);
	v_CheckQueryWSFlag      VARCHAR(1);
	v_bInQueue				VARCHAR(1);
	v_orderBy				VARCHAR(200);
	v_sortFieldStr			VARCHAR(2000);
	v_tempOrderStr			VARCHAR(2000);
	v_ParsedQueryFilter		VARCHAR(1000);
	v_QueueFilter			VARCHAR(1000);
	v_TempQueryFilter		VARCHAR(1000);
	v_lockFlag				VARCHAR(1);
	v_macro					VARCHAR(16);
	v_macroUserName			VARCHAR(16);
	v_funcMacro				VARCHAR(16);
	v_FunctionPos			INTEGER;
	v_FunLength				INTEGER;
	v_funPos1				INTEGER;
	v_funPos2				INTEGER;
	v_FunValue				VARCHAR(8000);
	queryFunStr				VARCHAR(8000);
	v_functionFlag			VARCHAR(1);
	v_prevFilter			VARCHAR(2000);
	v_funFilter				VARCHAR(2000);
	v_postFilter			VARCHAR(1000);
	v_tempFunStr  			VARCHAR(100);
	v_emptyString			VARCHAR(2);
	v_tableNameReturn		VARCHAR(30);
	v_QDTColStr				TEXT; 
	v_WLTColStr				TEXT; 
	v_WLTColStr1			TEXT;
	v_CursorAlias			REFCURSOR; 
	v_AliasStr				VARCHAR(2000); 
	v_PARAM1				VARCHAR(64); 
	v_ALIAS					VARCHAR(64); 
	v_ToReturn				VARCHAR(1); 
	ResultSet				REFCURSOR;
	FilterCur				REFCURSOR;
	ProcessInstCur			REFCURSOR;
	WorkItem_Cur			REFCURSOR;
	v_Record				RECORD;
	v_editableOnQuery 		VARCHAR(2);
	V_queryStr2				TEXT;
	v_tableName1			VARCHAR(256);
	v_exists 				INT;
	
	v_AssignQ_QueueId		INTEGER;	
	v_AssignWIState			INTEGER;
	v_AssignQueueType		VARCHAR(1);	
	v_AssignQueueName		VARCHAR(100);
	ProcessInstanceIdFilter	INTEGER;
	v_Q_DivertedByUserId    INT;
	v_RoutingStatus			VARCHAR(256);
	v_VariableId1			INT;
	v_ExtTableFilterUsed	VARCHAR(1);
	v_ExtTableStr			VARCHAR(400);
	v_ExtTableStrCondition	VARCHAR(256);
	v_AssignFilterVal		INTEGER;
	existflag				INT;
	v_queryStr1				TEXT;
	existsflag				INT;
	v_ProcessVarinatId 	INTEGER;
	v_ActivityType		INTEGER;
	v_CanInitiate		VARCHAR(1);
	v_showCaseVisual	VARCHAR(1);
	v_tempQ_UserId			INT;
	v_seqRootLogId			INTEGER;
	CursorLastValue			REFCURSOR;
	LockCur					REFCURSOR;
	v_LastValue				VARCHAR(500);
	v_sortFieldStrCol		VARCHAR(2000);
	v_lastValueStr			VARCHAR(1000);
	v_reverseOrder			INT;
	v_op					CHAR(1);
	v_sortStr				VARCHAR(6);
	v_innerOrderBy			VARCHAR(200);
	v_TempColumnVal			VARCHAR(500);
	v_innerOrderByCol1		VARCHAR(64); 
	v_innerOrderByCol2		VARCHAR(64); 
	v_innerOrderByCol3		VARCHAR(64);
	v_innerOrderByCol4		VARCHAR(64); 
	v_innerOrderByCol5		VARCHAR(64); 
	v_innerOrderBySort1		VARCHAR(6); 
	v_innerOrderBySort2		VARCHAR(6); 
	v_innerOrderBySort3		VARCHAR(6); 
	v_innerOrderBySort4		VARCHAR(6); 
	v_innerOrderBySort5		VARCHAR(6); 
	v_innerOrderByVal1		VARCHAR(256); 
	v_innerOrderByVal2		VARCHAR(256); 
	v_innerOrderByVal3		VARCHAR(256); 
	v_innerOrderByVal4		VARCHAR(256); 
	v_innerOrderByVal5		VARCHAR(256); 
	v_innerOrderByType1		VARCHAR(50); 
	v_innerOrderByType2		VARCHAR(50); 
	v_innerOrderByType3		VARCHAR(50); 
	v_innerOrderByType4		VARCHAR(50); 
	v_innerOrderByType5		VARCHAR(50); 
	v_innerOrderByCount		INT;
	v_PositionComma			INT;
	v_TempColumnName		VARCHAR(64);
	v_TempSortOrder			VARCHAR(6);
	v_innerLastValueStr		VARCHAR(1000);
	v_TemplastValueStr		VARCHAR(1000);
	v_counter				INT;
	v_counter1				INT;
	v_tempDataType			VARCHAR(100);
	v_counterCondition		INT;
	v_sortFieldStrValue		VARCHAR(2000);
	v_DATEFMT 				VARCHAR(25);
	v_indexOfSeprator 		INT ;
	v_genLog   				Varchar(2);
	v_WorkStartedLoggingEnabled   Varchar(2);
	v_record1 record;
	v_record2 wfinstrumenttable%rowtype;
	v_HistoryTableName 		VARCHAR(50);
	v_insertTarStr				VARCHAR(50);
	v_QueryFilterQueue	Varchar(8000);
	v_QueryFilterUG   Varchar(8000);
	v_ExpiryFlag		Varchar(2); 
	tempProcInstanceId		VARCHAR(100) ;
	v_OrderBy_FIFO			INTEGER;
	v_OrderBy_FIFOSet		INTEGER;
	v_sortOrder_FIFO		VARCHAR(10);
	v_NullFlag				VARCHAR(2);
	v_nullSortStr		    VARCHAR(40);
	v_extObjId INT;
	v_fieldName VARCHAR(1000);
	v_externalTaleJoin VARCHAR(1);
	v_finalColumnStr VARCHAR(2000);
	v_query1 VARCHAR(8000);
	v_extTableNameHistory		VARCHAR(50);
	v_extTableName	VARCHAR(50);
	v_queryQueueId		INT;
	v_tempCount		INT;
	v_systemDefinedName		VARCHAR(50);
    v_genLog_mainCode				INTEGER;		

BEGIN
	/* Initializations */
	v_toSearchStr		:= 'ORDER BY';
	v_found				:= 'N';
	v_canLock			:= 'N';
	v_lockFlag			:= 'N';
	v_ProcessInstanceId	:= DBProcessInstanceId;
	v_WorkitemId		:= DBWorkitemId;
	v_Q_QueueId			:= DBQueueId;
	v_DBStatus			:= -1;
	v_quoteChar			:= CHR(39);
	v_ExtTableFilterUsed := 'N';

	v_orderByStr		:= '';
	v_QueryFilter		:= '';
	v_QueueDataTableStr	:= '';
	
	v_emptyString		:= '';
	v_AliasStr			:= '';
	v_CheckQueryWSFlag  := 'N';
ProcessInstanceIdFilter	:=	-1;
	v_macro				:= '&<UserIndex>&';
	v_macroUserName		:= '&<UserName>&';
	v_DBStatus			:= 0;
	v_mainCode			:= 0;
	v_tableName			:= NULL;
	v_funcMacro         :='&<FUNCTION>&';
	v_functionFlag 		:='';
	v_prevFilter		:='';
	v_funFilter			:='';
	v_postFilter		:='';
	v_tempFilter 		:='';

	v_LastValue			:= DBLastValue;
	v_DATEFMT 			:= 'YYYY-MM-DD HH24:MI:SS.US';
	
	v_HistoryTableName := 'CURRENTROUTELOGTABLE';
	v_insertTarStr := '';
	v_ExpiryFlag   := 'N';
	tempProcInstanceId := '';
	v_OrderBy_FIFO := 0;
	v_sortOrder_FIFO := 'A';
	v_OrderBy_FIFOSet := 0;
	v_ExtTableStrCondition := '';
	v_lastValueStr := '';
	v_queryFilterStr2 := '';
	v_QueueFilter := '';
	v_NullFlag  := 'Y';	
	v_tableName1 := 'WFINSTRUMENTTABLE';
	v_extTableName:=DBExternalTableName;
	v_extTableNameHistory:=DBHistoryTableName;
	/* Check session validity */
	IF(v_LastValue is NOT NULL) THEN
		v_LastValue:=REPLACE(v_LastValue,v_quoteChar,v_quoteChar||v_quoteChar);
	END IF;
	SELECT	INTO v_userIndex ,v_userName, v_status userIndex, userName, statusFlag
	FROM	WFSessionView, WFUserView 
	WHERE	UserId = UserIndex AND
			SessionID	= DBSessionId; 
	IF(NOT FOUND) THEN
		v_mainCode	:= 11;	/* Invalid Session Handle */
		OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
		RETURN ResultSet;
	END IF;
	
	v_indexOfSeprator := POSITION(',' in DBGenerateLog);
	If(v_indexOfSeprator = 0) THEN 
		BEGIN
			v_genLog := DBGenerateLog;
			v_WorkStartedLoggingEnabled := DBGenerateLog;
		END;
	Else
		BEGIN
			v_genLog := SUBSTRING(DBGenerateLog , 1, v_indexOfSeprator-1);
			v_WorkStartedLoggingEnabled := SUBSTRING(DBGenerateLog , v_indexOfSeprator+1 , 1);
		END;
	END IF;
	
	
	IF(v_status = 'N') THEN
		Update WFSessionView set statusflag = 'Y' , AccessDateTime = CURRENT_TIMESTAMP
		  WHERE SessionID = DBSessionId;
	END IF;

	/* for FIFO case for getting new WorkItem append filter option also */
	--IF(DBQueueType = 'F' AND DBQueueId IS NOT NULL AND DBQueueId > 0 AND (v_ProcessInstanceId IS NULL OR LENGTH(BTRIM(v_ProcessInstanceId)) = 0))  THEN
	IF(DBQueueId = 0 AND NOT(v_LastValue IS NULL OR v_LastValue ='')) THEN /* NEXT WORKITEM FEATURE NOT AVAILABLE FOR MYQUEUE and SEARCH*/
		v_mainCode := 18;
		OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
		RETURN ResultSet;
	END IF;
	--END IF;
		Select ProcessInstanceId INTO tempProcInstanceId from WFInstrumentTable  where ProcessInstanceId = v_ProcessInstanceId and LockStatus = 'N' And WorkItemId =1 and validTill < now();
			IF (Not Found) then 
				v_rowCount := 0;
			End if;
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		If(v_rowCount > 0) THEN
		
			--Set the ExpiredFlag = Y
			v_ExpiryFlag := 'Y';
			v_rowCount := 0;
			--At the End of this SP if ExpiredFLag = Y  then return the 401 in WMGetWorkItem and WFGetWorkItemDataExt thorugh this SP
			--In both API if returned code = 401 Then
				--Set MainCode = 400 and SubCode = 27  from API to be returned to Web thorugh WMGetWorkItem API
					--[To throw error while excution of Complete API as before Complete WMGetWorkItem API will be executed and if the worktiem is expired then actual error message of expired workitem will be thrown]
				--Set a ExpiryFlag = Y thorugh WFGetWorkItemDataExt then Set MainCOde = 16 in WFGetWorktitemDataExt API after execution of WFGetWorkItem SP.
		
		END IF;
	
	--End Of Check if the workitemis expired 	
		
	
	IF(DBQueueId IS NOT NULL AND DBQueueId > 0)	THEN
		
		SELECT ProcessName, OrderBy, SortOrder INTO v_ProcessName,v_OrderBy_FIFO, v_sortOrder_FIFO FROM QueueDeftable WHERE QueueID = DBqueueId;
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF(v_rowCount > 0) THEN  
			IF (v_ProcessName IS NOT NULL) THEN
				Select TableName INTO v_ExtTableStr from ExtDbConfTable
				where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
				and ExtObjId = 1;
			END IF;
		END IF;
	END IF;
	v_queryFilterStr := ' WHERE ';

	/* ProcessInstanceId will be NULL for FIFO only .... */
	IF(v_ProcessInstanceId IS NULL OR LENGTH(BTRIM(v_ProcessInstanceId)) = 0) THEN
		v_queryFilterStr := v_queryFilterStr || ' Q_QueueId = ' || DBQueueId;
		IF(DBLastProcessInstanceId IS NULL AND LENGTH(DBLastProcessInstanceId) > 0) THEN
			v_LastValue := NULL; /*Last Value not needed when a user compltes the workitem and next workitem is to be brought based on order by*/
		END IF;
	ELSE
		v_queryFilterStr := v_queryFilterStr || ' ProcessInstanceId = ' || v_quoteChar || v_ProcessInstanceId || v_quoteChar ||' AND WorkitemId = ' || v_WorkitemId;
		ProcessInstanceIdFilter	:=	1;
	END IF;

	/* Filter on last value if given in input, pre fetch case for thick client */
	IF(v_LastValue IS  NULL AND DBLastProcessInstanceId IS NOT NULL AND LENGTH(BTRIM(DBLastProcessInstanceId)) > 0) THEN
		v_queryFilterStr := v_queryFilterStr || ' AND NOT (processInstanceId = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar ||' AND workitemId = ' || DBLastWorkitemId || ' ) ';
	END IF;

	/*
		Some valisdations can also be put like in case of FIFO only, processInstanceId, WorkItemItem are not sent...
		If saome validations are failing we can return Invalid paramater
		For the time being it is assumned that data will be send in proper case only......
	*/
	
	IF(DBQueueId < 0) THEN	
	
		/*Search case we have to find Q_QueueId for the workItem to find the QueryFilter condition*/
		SELECT INTO v_Q_QueueId , v_Queuetype , v_Q_UserId , v_RoutingStatus , v_FilterValue, v_ProcessDefID, v_Queuename, v_LockedTime, v_LockStatus, v_LockedByName, v_PreviousStage, v_ExpectedWorkitemDelay, v_Statename, v_WorkItemState, v_CreatedDateTime, v_AssignedUser, v_ValidTill,  v_PriorityLevel, v_AssignmentType, v_EntryDateTime, v_ActivityId, v_ActivityName, v_ProcessedBy, v_ProcessVersion, v_ProcessName,v_Q_DivertedByUserId Q_QueueId, QueueType, Q_UserId, RoutingStatus, FilterValue, ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName,Q_DivertedByUserId
		FROM WFInstrumentTable where RoutingStatus = 'N' and ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkitemId;
		
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF(v_rowCount > 0) THEN
			/** 22/01/2008, Bugzilla Bug 3580, Unable to open fixed assigned workitems from search - Ruhi Hira */
			IF(v_Q_QueueId IS NOT NULL AND v_Q_QueueId > 0) THEN
				v_bInQueue := 'Y';	
				IF(DBUtilityFlag = 'N') THEN	
					SELECT INTO v_qdt_filterOption, v_QueueFilter QUEUEDEFTABLE.FilterOption, QUEUEDEFTABLE.QueueFilter 
					FROM	QUEUEDEFTABLE, QUserGroupView 
					WHERE	QUEUEDEFTABLE.QueueID = QUserGroupView.QueueID 
					AND	QUEUEDEFTABLE.QueueID = v_Q_QueueId
					AND	UserId = v_userIndex 
					LIMIT 1;
					GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				ELSE	
					SELECT  INTO v_qdt_filterOption, v_QueueFilter QUEUEDEFTABLE.FilterOption, QUEUEDEFTABLE.QueueFilter
					FROM	QUEUEDEFTABLE
					WHERE	QUEUEDEFTABLE.QueueID = v_Q_QueueId LIMIT 1;					
					GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				END IF;		
				IF(v_rowCount > 0) THEN
					IF(v_qdt_FilterOption = 0) THEN
						v_qdt_FilterOption = NULL;
					END IF;
					IF( NOT ( (v_qdt_FilterOption = 2 AND v_FilterValue = v_userIndex) 
								OR (v_qdt_FilterOption = 3 AND v_FilterValue != v_userIndex) 
								OR (v_qdt_FilterOption = 1))) THEN
						v_canLock := 'N';
						v_CheckQueryWSFlag := 'Y';
					END IF;
				ELSE
					v_canLock := 'N';
					v_CheckQueryWSFlag := 'Y';
				END IF;
				
				IF(v_ProcessName IS NOT NULL) THEN
					Select TableName INTO v_ExtTableStr from ExtDbConfTable
					where ProcessDefId = (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
					and ExtObjId = 1;
				END IF;
			END IF;
		ELSE
			v_Q_QueueId := -1;
			v_bInQueue := 'N';
		END IF;
	END IF;
		
IF (v_Q_QueueId > 0) THEN
	v_QueryStr := 'SELECT PARAM1, ALIAS, ToReturn, VARIABLEID1 FROM VarAliasTable WHERE QueueId = ' || COALESCE(v_Q_QueueId,0) || ' ORDER BY ID ASC'; 
	OPEN v_CursorAlias FOR EXECUTE v_QueryStr;
	LOOP
		FETCH v_CursorAlias INTO v_PARAM1, v_ALIAS, v_ToReturn,v_VariableId1;
		IF(NOT FOUND) THEN
				EXIT;
		END IF;
		IF ((v_VariableId1 > 157 and v_VariableId1<10001) or (v_VariableId1>10023))  THEN 
			v_ExtTableFilterUsed := 'Y';
		END IF;
		IF (v_ToReturn = 'Y') THEN 
		    IF(UPPER(v_PARAM1) != 'TATREMAINING' AND UPPER(v_PARAM1) != 'TATCONSUMED') THEN
			v_AliasStr :=  v_AliasStr || ', ' || v_PARAM1 || ' AS "' || v_ALIAS||'"'; 
			END IF;
		END IF; 
		IF (DBorderBy > 100) THEN
			IF (v_VariableId1 = DBorderBy) THEN
				v_sortFieldStr := ' "' || v_ALIAS || '" ';
				v_sortFieldStrCol := ',"' || v_ALIAS||'" ';
				IF(LENGTH(v_LastValue) > 0) THEN 
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
			END IF;
		END IF;
	END LOOP;
	CLOSE v_CursorAlias;
	END IF;


	IF (v_ExtTableFilterUsed = 'Y') THEN
		SELECT INTO v_ExtTableStr TableName from EXTDBConfTable where processdefid = v_ProcessDefID and extobjid = 1;
			IF(NOT FOUND) THEN
				v_ExtTableStr := '';
				v_ExtTableStrCondition := '';
			ELSE
				--v_ExtTableStrCondition := ' AND ' || v_ExtTableStr || '.ITEMINDEX = WFInstrumentTable.VAR_REC_1 AND ' || v_ExtTableStr || '.ITEMTYPE = WFInstrumentTable.VAR_REC_2';
				v_ExtTableStrCondition := ' Inner JOIN ' || v_ExtTableStr || ' ON (WFINSTRUMENTTABLE.VAR_REC_1 = ItemIndex AND WFINSTRUMENTTABLE.VAR_REC_2 = ItemType) ';
				v_ExtTableStr := ', ' || v_ExtTableStr;
			END IF;	
	End IF;
	
	IF(DBSortOrder = 'D') THEN 
		v_reverseOrder := 1;
		v_sortStr := ' DESC ';  
		v_op := '<';  
		v_nullSortStr := ' NULLS LAST ';
	ELSE 
		v_reverseOrder := 0;
		v_sortStr := ' ASC ';  
		v_op := '>'; 
		v_nullSortStr := ' NULLS FIRST ';
	END IF;

	IF(v_sortOrder_FIFO = 'D') THEN 
		v_sortOrder_FIFO := ' DESC ';  
		 
	ELSE 
		v_sortOrder_FIFO := ' ASC ';  
		
	END IF;
	
	/*
		QueueId has been fetch for the WorkItem , 
		Find QueryFilter for the following cases :- 
			1. FIFO, have to find next WI and lock it (We will be needing QueryFilter for conditions and Order by)
			2. WIP, to check if teh WI has to be opened in writable modde or in Query WorkStep read only mode
	*/

	/* check filter	*/
	
	IF (( DBQueueId > 0 AND (v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') ) 
	OR ( DBQueueId < 0 AND v_bInQueue = 'Y' AND (v_Q_UserId IS NULL OR v_userIndex != v_Q_UserId)) )THEN
		SELECT INTO v_QueryFilter QueryFilter 
			FROM  QueueUserTable
			WHERE QueueId = v_Q_QueueId
			AND userId = v_userIndex 
			AND AssociationType = 0;

		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		
		IF(v_rowCount > 0) THEN
			/* Only user specific filter exists and no group filter considered. */
			IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) > 0) THEN
				v_QueryFilter := BTRIM(v_QueryFilter);
				v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
				v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
				v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
				IF(v_orderByPos > 0) THEN
					--IF(DBQueueId > 0) THEN
						--v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH(v_toSearchStr), LENGTH(v_QueryFilter));
					--END IF;
					IF (DBClientOrderFlag = 'N') THEN
						v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
					END IF;
					v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
				END IF;
				v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
			END IF;
		ELSE	/* User may be added as a Group Member to the Queue, consider group filters if present */
			v_queryStr := 'Select QueryFilter, GroupId From QUserGroupView Where QueueId  = ' || v_Q_QueueId || ' AND UserId = ' || v_userIndex || ' AND GroupId IS NOT NULL ';
			OPEN FilterCur FOR EXECUTE v_queryStr;
			FETCH FilterCur INTO v_queryFilter, v_GroupId;
			IF(FOUND) THEN
				v_DBStatus := 1;
			END IF;
			v_counterInt := 1;
			WHILE(v_DBStatus  <> 0) LOOP 
				IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) <> 0) THEN
					v_QueryFilter := BTRIM(v_QueryFilter);
					v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
					v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
					v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
					IF(v_orderByPos > 0) THEN					
						--IF(DBQueueId > 0) THEN
						--	v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH(v_toSearchStr), LENGTH(v_QueryFilter));
						--END IF;
						IF (DBClientOrderFlag = 'N') THEN
							v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueryFilter));
						END IF;
						v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
					END IF;
					v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
					v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'G', v_GroupId);
					IF(LENGTH(v_QueryFilter) > 0) THEN
						-- v_QueryFilter := '(' || v_QueryFilter || ')';
						IF v_counterInt = 1 THEN
							v_tempFilter :=  v_QueryFilter;
						ELSE
							v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
						END IF;	
						v_counterInt := v_counterInt + 1;
					END IF;
				ELSE
					v_tempFilter := '';
				END IF;
				IF(LENGTH(v_tempFilter) = 0) THEN
					EXIT;
				END IF;
				v_DBStatus := 0;
				FETCH FilterCur INTO v_queryFilter, v_GroupId;
				IF(FOUND) THEN
					v_DBStatus := 1;
				END IF;
			END LOOP; 
			CLOSE FilterCur;
			v_QueryFilter := v_tempFilter;
		END IF;
		
		IF(LENGTH(v_tempOrderStr) <> 0) THEN
			IF(LENGTH(BTRIM(v_orderByStr)) = 0) THEN
				v_orderByStr := ' ORDER BY ' || v_tempOrderStr;
			END IF;
		END IF;


		/* Check For Queue Filter for Search Case */
		v_DBStatus := 0;		
		v_QueryFilter := BTRIM(v_QueryFilter);
		IF((v_QueryFilter IS NULL OR LENGTH(v_QueryFilter) = 0) AND ((DBQueueType = 'N')or DBQueueType= '')) THEN 
			SELECT INTO v_QueueFilter QueueFilter From QueueDefTable where QueueId = v_Q_QueueId;

			IF(v_QueueFilter IS NOT NULL AND LENGTH(v_QueueFilter) > 0) THEN
				--v_QueryFilter := BTRIM(v_QueueFilter);
				v_QueueFilter := REPLACE(v_QueueFilter , v_macro, CAST(v_userIndex AS VARCHAR));
				v_QueueFilter :=  REPLACE(v_QueueFilter , v_macroUserName, v_userName);
				v_orderByPos := STRPOS(UPPER(v_QueueFilter), v_toSearchStr);
				IF(v_orderByPos <> 0) THEN
						--IF (DBQueueId > 0) THEN
							--v_tempOrderStr := SUBSTR(v_queryFilter, v_orderByPos + LENGTH(v_toSearchStr)); 
						--END IF; 
					IF (DBClientOrderFlag = 'N') THEN
						v_innerOrderBy := SUBSTR(v_QueueFilter, v_orderByPos + LENGTH('ORDER BY'), LENGTH(v_QueueFilter));
					END IF;
					v_QueueFilter := SUBSTR(v_QueueFilter, 1, v_orderByPos - 1); 
				END IF;
				v_QueueFilter := WFParseQueryFilter(v_QueueFilter, 'U', v_userIndex);
				v_TempQueryFilter := v_QueueFilter;
				v_QueryStr := 'SELECT GroupId FROM QUserGroupView WHERE QueueId = ' || DBqueueId || ' AND UserId = ' || v_userIndex || ' AND GroupId IS NOT NULL'; 
				OPEN FilterCur FOR EXECUTE v_queryStr;
				FETCH FilterCur INTO v_GroupId;
				IF(FOUND) THEN
					v_DBStatus := 1;
				END IF;
				v_counterInt := 1; 
				WHILE(v_DBStatus <> 0) LOOP 
					v_QueueFilter := v_TempQueryFilter;
					v_QueueFilter := WFParseQueryFilter(v_QueueFilter, 'G', v_groupId);
					IF(LENGTH(v_QueueFilter) > 0) THEN
						v_QueueFilter := '(' || v_QueueFilter || ')';
						IF(v_counterInt = 1) THEN
							v_tempFilter := v_QueueFilter;
						ELSE  
							v_tempFilter := v_tempFilter || ' OR ' || v_QueueFilter;
						END IF;
						v_counterInt := v_counterInt + 1;
					END IF;
					v_DBStatus := 0;
					FETCH FilterCur INTO v_GroupId;
					IF(FOUND) THEN
						v_DBStatus := 1;
					END IF;
				END LOOP;
				IF(v_tempFilter IS NOT NULL AND LENGTH(v_tempFilter) > 0) THEN
					v_QueueFilter := v_tempFilter;
				END IF;
				CLOSE FilterCur;
			END IF;
		END IF;
		
		IF (v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0 ) THEN
			v_FunctionPos := STRPOS(v_QueryFilter, v_funcMacro);	
			IF(v_FunctionPos != 0) THEN
				v_FunLength := LENGTH(v_funcMacro);
				v_functionFlag := 'Y';		
				WHILE(v_functionFlag = 'Y') LOOP
						v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
						v_funPos1 := STRPOS(v_QueryFilter, chr(123));				
						v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
						v_tempFunStr := BTRIM(v_tempFunStr);						
						
						IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
							v_funPos2 := STRPOS(v_QueryFilter, chr(125));
							v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
							v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
							queryFunStr := 'SELECT ' || v_funFilter;							
							Execute queryFunStr INTO v_FunValue; /* Check whether execute is required or select is required */ 
							
							IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 )THEN
									v_FunValue := '1 = 1';
							END IF;
							
							v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
						ELSE
							EXIT;
						END IF;							
						v_FunctionPos := STRPOS(v_QueryFilter, '&<FUNCTION>&');
						IF(v_FunctionPos = 0) THEN
							v_functionFlag := 'N';
						END IF;					
					END LOOP;				
			END IF;
			IF (v_QueryFilter IS NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) <= 0) THEN
				v_QueueFilter := '';
				v_queryFilterStr2 := COALESCE(v_queryFilterStr2,'') || ' AND ' || v_QueryFilter; 
			END IF;
		END IF;
		/* v_tempOrderStr already added in v_orderByStr above --Mohnish */
		/*IF((v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0) OR (LENGTH(v_orderByStr) > 0))THEN
			IF(v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0) THEN
					v_queryFilterStr := v_queryFilterStr || ' AND (' || v_QueryFilter || ') ';
				END IF;
				RAISE NOTICE 'v_QueryFilter >> % ', v_QueryFilter;
			--END IF;
		END IF;*/
	END IF;
	
	IF (v_QueueFilter IS NOT NULL AND LENGTH(BTRIM(v_QueueFilter)) > 0 ) THEN
		v_FunctionPos := STRPOS(v_QueueFilter, v_funcMacro);	
		IF(v_FunctionPos != 0) THEN
			v_FunLength := LENGTH(v_funcMacro);
			v_functionFlag := 'Y';		
			WHILE(v_functionFlag = 'Y') LOOP
				v_prevFilter := SUBSTR(v_QueueFilter, 0, v_FunctionPos-1);
				v_funPos1 := STRPOS(v_QueueFilter, chr(123));			
				v_tempFunStr := SUBSTR(v_QueueFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
				v_tempFunStr := BTRIM(v_tempFunStr);							
				
				IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
					v_funPos2 := STRPOS(v_QueueFilter, chr(125));
					v_funFilter := SUBSTR(v_QueueFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
					v_postFilter := SUBSTR(v_QueueFilter, v_funPos2 + 1);
					queryFunStr := 'SELECT ' || v_funFilter;							
					Execute queryFunStr INTO v_FunValue; 
					
					IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 )THEN
							v_FunValue := '1 = 1';
					END IF;
					v_QueueFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
				ELSE
					EXIT;
				END IF;							
				v_FunctionPos := STRPOS(v_QueueFilter, '&<FUNCTION>&');
				IF(v_FunctionPos = 0) THEN
					v_functionFlag := 'N';
				END IF;					
			END LOOP;				
		END IF;
	END IF;
	
				IF (v_innerOrderBy is NULL AND DBQueueType = 'F') THEN 
					BEGIN  
						 
						IF(v_OrderBy_FIFO = 1) THEN 
						BEGIN   
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' PriorityLevel '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 2) THEN  
						BEGIN   
							IF(LENGTH(DBlastValue) > 0 ) THEN    
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar;   
							END; 
							END IF; 
							v_sortFieldStr := ' ProcessInstanceId '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 3) THEN 
						BEGIN   
							IF(LENGTH(DBlastValue) > 0) THEN  
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar;  
							END; 
							END IF;			 
							v_sortFieldStr := ' ActivityName ';  
						END; 
						ElSIF(v_OrderBy_FIFO = 4) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' LockedByName ' ; 
						END;  
						ElSIF(v_OrderBy_FIFO = 5) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF;			 
							v_sortFieldStr := ' IntroducedBy ';  
						END; 
						ElSIF(v_OrderBy_FIFO = 6) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 	  
							END IF; 
							v_sortFieldStr := ' InstrumentStatus '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 7) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN  
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF;			 
							v_sortFieldStr := ' CheckListCompleteFlag '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 8) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' LockStatus '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 9) THEN   
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := DBlastValue; 
							END; 
							END IF; 
							v_sortFieldStr := ' WorkItemState ';  
						END; 
						ElSIF(v_OrderBy_FIFO = 10) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := --' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF;			 
							v_sortFieldStr := ' EntryDateTime ';  
						END;  
						ElSIF(v_OrderBy_FIFO = 11) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr :=-- ' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') '; 
								v_quoteChar || DBlastValue || v_quoteChar; 
							END ; 
							END IF; 
							v_sortFieldStr := ' ValidTill '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 12) THEN   
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN  
							BEGIN  
								v_lastValueStr := --' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') '; 
								v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' LockedTime '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 13) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') '; 
								--v_quoteChar || DBlastValue || v_quoteChar; 
							END; 	  
							END IF; 
							v_sortFieldStr := ' IntroductionDateTime '; 
						END;  
						ElSIF(v_OrderBy_FIFO = 17) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;  
							END IF; 
							v_sortFieldStr := ' Status '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 18) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := --' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') '; 
								v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' CreatedDateTime '; 
						END; 
						ElSIF(v_OrderBy_FIFO = 19) THEN  
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN  
							BEGIN  
								v_lastValueStr := --' TO_DATE(' || v_quoteChar || SUBSTR(DBlastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') '; 
								v_quoteChar || DBlastValue || v_quoteChar; 
							END; 
							END IF; 
							v_sortFieldStr := ' ExpectedWorkItemDelay '; 
						END; 		/* Sorting On Alias */ 
						ElSIF(v_OrderBy_FIFO = 20) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' ProcessedBy '; 
						END;		/* Sorting On Alias */
						ElSIF(v_OrderBy_FIFO = 101) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT1 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 102) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT2 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 103) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT3 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 104) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT4 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 105) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT5 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 106) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT6 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 107) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT7 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 108) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_INT8 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 109) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_FLOAT1 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 110) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_FLOAT2 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 111) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_DATE1 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 112) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_DATE2 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 113) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_DATE3 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 114) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_DATE4 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 115) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_LONG1 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 116) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_LONG2 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 117) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_LONG3 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 118) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_LONG4 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 119) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR1 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 120) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR2 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 121) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR3 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 122) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR4 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 123) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR5 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 124) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR6 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 125) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR7 '; 
						END;
						ElSIF(v_OrderBy_FIFO = 126) THEN 
						BEGIN  
							IF(LENGTH(DBlastValue) > 0) THEN 
							BEGIN  
								v_lastValueStr := v_quoteChar || DBlastValue || v_quoteChar; 
							END;   
							END IF; 
							v_sortFieldStr := ' VAR_STR8 '; 
						END;
						END IF;
						IF(v_OrderBy_FIFO > 0) THEN
							v_orderByStr := ' ORDER BY ' || v_sortFieldStr || ' ' || v_sortOrder_FIFO ||', ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
							
						END IF;
						v_OrderBy_FIFOSet := 1;
					END;
				END IF;
				
	
	IF ((v_innerOrderBy is NULL)  ) THEN
		IF(v_OrderBy_FIFOSet = 0 )THEN
			IF(DBorderBy = 1) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' PriorityLevel ';
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 2) THEN 
				IF(LENGTH(v_LastValue) > 0 ) THEN   
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;  
				END IF;
				v_sortFieldStr := ' ProcessInstanceId ';
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 3) THEN
					IF(LENGTH(v_LastValue) > 0) THEN 
						v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar; 
					END IF;			
					v_sortFieldStr := ' ActivityName '; 
					v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 4) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' LockedByName ' ;
			ElSIF(DBorderBy = 5) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;			
				v_sortFieldStr := ' IntroducedBy '; 
			ElSIF(DBorderBy = 6) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' InstrumentStatus ';
			ElSIF(DBorderBy = 7) THEN
				IF(LENGTH(v_LastValue) > 0) THEN 
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;			
				v_sortFieldStr := ' CheckListCompleteFlag ';
			ElSIF(DBorderBy = 8) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' LockStatus ';
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 9) THEN  
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_LastValue;
				END IF;
				v_sortFieldStr := ' WorkItemState '; 
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 10) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ;
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;			
				v_sortFieldStr := ' EntryDateTime '; 
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 11) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' ValidTill ';
			ElSIF(DBorderBy = 12) THEN  
				IF(LENGTH(v_LastValue) > 0) THEN 
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' LockedTime ';
			ElSIF(DBorderBy = 13) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' IntroductionDateTime ';
			ElSIF(DBorderBy = 17) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' Status ';
			ElSIF(DBorderBy = 18) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' CreatedDateTime ';
				v_NullFlag  := 'N';	
			ElSIF(DBorderBy = 19) THEN 
				IF(LENGTH(v_LastValue) > 0) THEN 
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_LastValue, 1, 26) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ';
					--v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' ExpectedWorkItemDelay ';
				/* Sorting On Alias */
			ElSIF(DBorderBy = 20) THEN
				IF(LENGTH(v_LastValue) > 0) THEN
					v_lastValueStr := v_quoteChar || v_LastValue || v_quoteChar;
				END IF;
				v_sortFieldStr := ' ProcessedBy ';
			END IF;
		END IF;
		
		IF(DBLastProcessInstanceId IS NOT NULL) THEN
				v_TempColumnVal := v_lastValueStr;
				IF(v_LastValue IS NOT NULL AND LENGTH(v_LastValue) > 0) THEN
						v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ';
						v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
				ELSE 
						IF(v_NullFlag = 'Y') THEN
							v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL ';
						ELSE--Its the case when workiten is introduced and prev-Next flag is true and LastValue is blank
							v_lastValueStr := ' AND  ( (  1= 1 ' ;
						END IF;
				END IF;
					
				v_lastValueStr := v_lastValueStr || ' AND (  ';
				v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar || ' AND  WorkItemId ' || v_op || CAST(DBLastWorkitemId AS VARCHAR) || ' )'; 
				v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;
				v_lastValueStr := v_lastValueStr || ' ) ';  
				IF(v_LastValue IS NOT NULL AND LENGTH(v_LastValue) > 0 ) THEN 
					RAISE NOTICE 'lastvalue not null case >> % ', v_LastValue;
					IF (DBsortOrder = 'A') THEN 
						v_lastValueStr := v_lastValueStr || ') ' ; 
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
				ELSE
					RAISE NOTICE 'lastvalue null case >> % ', v_LastValue;
					IF (DBsortOrder = N'D') THEN 
						BEGIN 
							v_lastValueStr := v_lastValueStr || ') ';
						END; 
					ELSE 
						BEGIN
							v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )';  
						END;
					END IF;	
					--v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )';  
					v_lastValueStr := v_lastValueStr || ') ';
				END IF;
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
		IF (DBorderBy = 2 AND v_OrderBy_FIFOSet=0) THEN
				v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
		ELSIF (v_OrderBy_FIFOSet=1) THEN  
				v_orderByStr := ' ORDER BY ' || v_sortFieldStr || ' ' || v_sortOrder_FIFO ||', ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr;
		ELSE
				v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr ||v_nullSortStr||', ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr;
		END IF;
	ELSE 
			v_orderByStr := ' ORDER BY ';  
			v_innerOrderBy := v_innerOrderBy || ',';  

			v_PositionComma := STRPOS(v_innerOrderBy,','); 
			v_innerOrderByCount := 0;  

		WHILE (v_PositionComma > 0) LOOP
			v_innerOrderByCount := v_innerOrderByCount + 1;  
			v_TempColumnName := SUBSTR(v_innerOrderBy, 1 , v_PositionComma - 1);  
			v_orderByPos := STRPOS(UPPER(v_TempColumnName),'ASC'); 
			IF (v_orderByPos > 0) THEN  
				v_TempSortOrder := 'ASC'; 
				v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1));  
			ELSE  
				v_orderByPos := STRPOS(UPPER(v_TempColumnName),'DESC');
				IF (v_orderByPos > 0) THEN 
					v_TempSortOrder := 'DESC'; 
					v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
				ELSE  
					v_TempSortOrder := 'ASC';  
				END IF;
			END IF;
			IF (v_reverseOrder = 1) THEN
				IF (v_TempSortOrder = 'ASC') THEN  
					v_TempSortOrder := 'DESC';  
				ELSE  
					v_TempSortOrder := 'ASC'; 
				END IF;					
			END IF;
		  
		   IF (v_innerOrderByCount = 1) THEN  
				v_innerLastValueStr := v_TempColumnName;  
				v_orderByStr := v_orderByStr || v_TempColumnName || ' ' || v_TempSortOrder; 
		   ELSE  
				v_innerLastValueStr := v_innerLastValueStr ||  ', ' || v_TempColumnName;  
				v_orderByStr := v_orderByStr || ', ' || v_TempColumnName || ' ' || v_TempSortOrder;  
		   END IF;
			
			IF (v_innerOrderByCount = 1 ) THEN
				v_innerOrderByCol1 := v_TempColumnName;  
				v_innerOrderBySort1 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 2 ) THEN  
				v_innerOrderByCol2 := v_TempColumnName;  
				v_innerOrderBySort2 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 3 ) THEN 
				v_innerOrderByCol3 := v_TempColumnName;  
				v_innerOrderBySort3 := v_TempSortOrder ;
			ELSIF (v_innerOrderByCount = 4 ) THEN 
				v_innerOrderByCol4 := v_TempColumnName;
				v_innerOrderBySort4 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 5 ) THEN
				v_innerOrderByCol5 := v_TempColumnName; 
				v_innerOrderBySort5 := v_TempSortOrder; 
			END IF;
			v_innerOrderBy := SUBSTR(v_innerOrderBy, v_PositionComma + 1, LENGTH(v_innerOrderBy)); 
			v_PositionComma := STRPOS (v_innerOrderBy,',');  
		END LOOP;
		v_orderByStr := v_orderByStr || ', ' || 'ProcessInstanceID' || v_sortStr || ', WorkItemID ' || v_sortStr; 
		
		IF(DBLastProcessInstanceId IS NOT NULL AND LENGTH(DBLastProcessInstanceId) > 0) THEN  
			v_counter := 0;  
			WHILE (v_counter < v_innerOrderByCount) LOOP  
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
			END LOOP;

			IF (v_innerOrderByCount > 0 ) THEN  
				v_counter := 5 - v_innerOrderByCount;  
				WHILE (v_counter > 0) LOOP
						v_innerLastValueStr := v_innerLastValueStr ||  ', NULL';  
						v_counter := v_counter - 1; 
				END LOOP;
			END IF;
		END IF;
		
		v_QueryStr := 'SELECT ' ||  v_innerLastValueStr || ' FROM (SELECT QUEUEDATATABLE.* ' || COALESCE(v_AliasStr,'') || ' FROM QUEUEDATATABLE ' || v_ExtTableStrCondition || ' WHERE PROCESSINSTANCEID = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar || ' AND WORKITEMID = ' || CAST(DBLastWorkitemId AS VARCHAR) || ') Table0';

		OPEN CursorLastValue FOR EXECUTE v_QueryStr;
		LOOP
			FETCH CursorLastValue INTO v_innerOrderByVal1, v_innerOrderByVal2, v_innerOrderByVal3, v_innerOrderByVal4, v_innerOrderByVal5;
			EXIT WHEN NOT FOUND;
		END LOOP;
		CLOSE CursorLastValue;

		v_counter := 0; 
		v_counterCondition := 0;  
		v_lastValueStr := ' AND ( ';  

		WHILE (v_counter < v_innerOrderByCount + 1 ) LOOP
			v_counter1 := 0;  
			v_TemplastValueStr := '';
				WHILE (v_counter1 <= v_counter) LOOP 
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
						IF (v_counter1 < v_counter) THEN
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
						END IF;
					ELSE 
						IF (v_counter1 = v_counter) THEN 
							IF (v_TempSortOrder = 'ASC') THEN 
									IF (v_TempColumnVal IS NOT NULL) THEN 
										BEGIN 
											v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || v_quoteChar || v_TempColumnVal || v_quoteChar;
										END; 
									ELSE 
										BEGIN 
											v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NOT NULL '; 
										END; 
									END IF; 
							ELSE  
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
							END IF;
						ELSE  
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
						END IF;
					END IF;
					v_counter1 := v_counter1 + 1; 
				END LOOP;
				
				IF (v_TemplastValueStr IS NOT NULL) THEN
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
				END IF;
				v_counter := v_counter + 1;  
			END LOOP;
			
			v_lastValueStr := v_lastValueStr || ' (  ( Processinstanceid = ' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;
			v_lastValueStr := v_lastValueStr || ' AND  WorkItemId ' || v_op || CAST(DBLastWorkitemId AS VARCHAR) || ' )';  
			v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || DBLastProcessInstanceId || v_quoteChar;  
			v_lastValueStr := v_lastValueStr || ' ) )';  

			IF ( v_counterCondition > 1 ) THEN 
				BEGIN 
					v_lastValueStr := v_lastValueStr || ' )';  
				END;
			END IF;
	END IF;

	IF(DBLastProcessInstanceId IS NULL OR LENGTH(DBLastProcessInstanceId) <= 0) THEN
		v_lastValueStr := '';
	END IF;
	
	v_DBStatus := 0;
	IF((DBQueueId > 0 AND (v_ProcessInstanceId IS NOT NULL OR v_ProcessInstanceId != '')) OR DBQueueId <=0) THEN
					v_canLock  := 'Y';
	END IF;	
	
	IF((v_canLock  = 'Y' AND (v_ProcessInstanceId is not null AND LENGTH(v_ProcessInstanceId) > 0 )) OR (v_ProcessInstanceId is null OR v_ProcessInstanceId = '')) THEN
		
			v_WLTColStr := ' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus,RoutingStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, FilterValue, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, NotifyStatus, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,LastModifiedTime,URN';

			v_WLTColStr1 := ' ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefId,  LastProcessedBy, ProcessedBy, ActivityName, ActivityId,  EntryDateTime,  ParentWorkItemId, AssignmentType,  CollectFlag, PriorityLevel, ValidTill,  Q_StreamId, Q_QueueID, Q_UserID,  AssignedUser, FilterValue, CreatedDateTime, WORKITEMSTATE,  Statename, ExpectedWorkItemDelay, PREVIOUSSTAGE,  LockedByName, LockStatus, LockedTime,IntroductionDateTime, QueueName, QueueType, NotifyStatus, ProcessVariantId, Q_DivertedByUserId,ActivityType,LastModifiedTime,URN'; 

			v_QDTColStr := ', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6 ,VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20'; 

			IF (((v_QueryFilter IS NULL OR v_QueryFilter = '' ) AND (v_QueueFilter IS NULL OR v_QueueFilter = '') AND (DBorderBy < 3  AND v_OrderBy_FIFO <= 100)) AND (DBuserFilterStr IS NULL OR DBuserFilterStr = '')) THEN
				
				v_queryStr := 'Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,ActivityId,  TO_CHAR(EntryDateTime,''YYYY-MM-DD HH24:MI:SS'') AS EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, TO_CHAR(ValidTill,''YYYY-MM-DD HH24:MI:SS'') AS ValidTill, Q_StreamId, Q_QueueId, 	Q_UserId, AssignedUser, FilterValue,TO_CHAR(CreatedDateTime,''YYYY-MM-DD HH24:MI:SS'') AS CreatedDateTime, WorkItemState, Statename,TO_CHAR(ExpectedWorkitemDelay,''YYYY-MM-DD HH24:MI:SS'') AS ExpectedWorkitemDelay , PreviousStage, LockedByName, LockStatus, TO_CHAR(LockedTime,''YYYY-MM-DD HH24:MI:SS'') AS LockedTime, TO_CHAR(IntroductionDateTime,''YYYY-MM-DD HH24:MI:SS'') AS IntroductionDateTime,Queuename, Queuetype, NotifyStatus , ProcessVariantId, Q_DivertedByUserId,ActivityType,TO_CHAR(LastModifiedTime,''YYYY-MM-DD HH24:MI:SS'') AS LastModifiedTime,URN From WFInstrumentTable'; 
				 
				v_queryStr := v_queryStr || v_queryFilterStr ||  ' AND  RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||'
				AND (( LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar ||' ) 
				OR (LockStatus = ' || v_quoteChar || 'Y'|| v_quoteChar|| ' AND Q_UserID = ' || v_userIndex || '))'		
				||  COALESCE(v_lastValueStr,'') ||COALESCE(v_orderByStr,'')  || ' FOR UPDATE';
				
			ELSE 
				IF(DBOrderBy > 100 AND (v_sortFieldStr IS NOT NULL OR v_sortFieldStr != '')) THEN
					v_queryStr := 'SELECT ' || v_WLTColStr1 || v_sortFieldStrCol || ' FROM ( SELECT * FROM (SELECT ' || v_WLTColStr ||v_QDTColStr || COALESCE(v_AliasStr,'') || ' FROM WFInstrumentTable ';
				ELSE
					v_queryStr := 'SELECT '|| v_WLTColStr1 || ' FROM ( SELECT * FROM (SELECT ' || v_WLTColStr || v_QDTColStr || COALESCE(v_AliasStr,'') || ' FROM WFInstrumentTable ';
				END IF;

				/*IF((v_QueryFilter IS NULL OR v_QueryFilter = '') AND v_QueueFilter IS NOT NULL ) THEN
					v_QueueFilter := ' AND ' || v_QueueFilter; 
				ELSIF (v_QueryFilter IS NOT NULL) THEN
					v_queryFilterStr2 := COALESCE(v_queryFilterStr2,'') || ' AND ' || '('||v_QueryFilter||')';
					v_QueueFilter := '';
				END IF;*/

				IF((v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0 ) AND (v_QueueFilter IS NOT NULL AND LENGTH(BTRIM(v_QueueFilter))>0))THEN
					v_QueueFilter := ' AND (' || v_QueueFilter || ' AND '||v_QueryFilter||') '; 
				ELSIF (v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0) THEN
					v_queryFilterStr2 := COALESCE(v_queryFilterStr2,'') || ' AND ' || '('||v_QueryFilter||')';
					v_QueueFilter := '';
				ELSIF (v_QueueFilter IS NOT NULL AND LENGTH(BTRIM(v_QueueFilter)) > 0) THEN
					v_queryFilterStr2 := COALESCE(v_queryFilterStr2,'') || ' AND ' || '('||v_QueueFilter||')';
					v_QueueFilter := '';
				END IF;
				
				v_queryStr := 'select * from (' ||v_queryStr || v_ExtTableStrCondition ||' ) Table1 ' || COALESCE(v_queryFilterStr,'') || ' AND  RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' AND ((LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar ||')
				OR (LockStatus = ' || v_quoteChar || 'Y'|| v_quoteChar|| ' AND Q_UserID = ' || v_userIndex || '))'
				|| COALESCE(v_lastValueStr,'') || COALESCE(v_queryFilterStr2,'') || COALESCE(v_QueueFilter,'') || COALESCE(DBuserFilterStr,'')|| COALESCE(v_orderByStr,'') || ') Table2 )ABC  LIMIT 1 FOR UPDATE';	
				RAISE NOTICE 'v_queryStr >> % ', v_queryStr;
			END IF;
			

			IF ( ((v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') AND DBQueueType = N'F') OR ((v_ProcessInstanceId IS NOT NULL ) AND (DBQueueType = '' OR DBQueueType IS NULL ) ) ) THEN
				v_queryStr := v_queryStr ;
			END IF;
			
			
				/* IF(v_ExpiryFlag ='N') THEN
					SAVEPOINT LockWI;
				END IF; */
				
				IF (v_queryStr IS NOT NULL or v_queryStr != '' ) THEN
					EXECUTE v_queryStr;
					RAISE NOTICE 'v_queryStr >> % ', v_queryStr;
					GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				END IF;
		
				IF (v_rowCount > 0) then
					OPEN LockCur FOR EXECUTE v_queryStr;
			  
					IF(DBOrderBy > 100 AND (v_sortFieldStr IS NOT NULL AND v_sortFieldStr != '' AND DBQueueType != 'F')) THEN
						FETCH LockCur INTO 
							v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId,
							v_Q_QueueId, v_Q_UserId, v_AssignedUser, v_FilterValue,
							v_CreatedDateTime, v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay,
							v_PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,v_IntroductionDateTime,
							v_Queuename, v_Queuetype, v_NotifyStatus, v_ProcessVarinatId, v_Q_DivertedByUserId,v_ActivityType,v_LastModifiedTime,v_URN, v_sortFieldStrValue;
							
					ELSE
						FETCH LockCur INTO 
							v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId,
							v_Q_QueueId, v_Q_UserId, v_AssignedUser, v_FilterValue,
							v_CreatedDateTime, v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay,v_PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,v_IntroductionDateTime,v_Queuename, v_Queuetype, v_NotifyStatus,v_ProcessVarinatId, v_Q_DivertedByUserId,v_ActivityType,v_LastModifiedTime,v_URN;
					END IF;
					GET DIAGNOSTICS v_rowCount = ROW_COUNT;
					CLOSE LockCur;	
				END IF;
			
				v_tempQ_UserId := v_Q_UserId;
			
						/* IF(v_processInstanceId = NULL AND DBProcessInstanceId != NULL) THEN
							v_processInstanceId := DBProcessInstanceId;
						END IF;
						
						IF(v_WorkitemId = NULL AND DBWorkitemId != NULL) THEN
							v_WorkitemId		:= DBWorkitemId;
						END IF; */
			
				IF(v_rowCount > 0) THEN
					
					v_found	:= 'Y';
				IF(DBTaskId > 0) then
					v_found	:= 'N';
				ELSIF(v_CheckQueryWSFlag = 'N') THEN
					v_canLock := 'Y';
					ELSE
						v_canLock := 'N';
				END IF;
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
						v_sortFieldStrValue := v_IntroductionDateTime; --TO_DATE(v_LockedTime,'YYYY-MM-DD HH24:MI:SS');
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
				ELSIF (v_bInQueue = 'Y' ) THEN 
					BEGIN
						v_CheckQueryWSFlag := 'Y';
						v_canLock := 'N';
						/* IF(v_ExpiryFlag ='N') THEN
							ROLLBACK TO SAVEPOINT LockWI;
						END IF; */
					END;
				ELSE
					BEGIN
						/* IF(v_ExpiryFlag ='N') THEN
							ROLLBACK TO SAVEPOINT LockWI;
						END IF; */	
					END;
				END IF;
				
				
		END IF;
	
		
		IF(v_found = 'Y') THEN
			/* Condition modified as assignmentType can be null - Ruhi Hira */
			IF(v_canLock= 'Y' AND (v_AssignmentType IS NULL OR v_AssignmentType = '' OR 
				NOT (v_AssignmentType = 'F' OR v_AssignmentType = 'E' OR v_AssignmentType = 'A' OR (v_AssignmentType = 'H' AND v_WorkItemState = 8)))) THEN
				IF(DBQueueId >= 0 AND DBQueueId != v_Q_QueueId) THEN
				
					/* IF(v_ExpiryFlag ='N') THEN
						ROLLBACK TO SAVEPOINT LockWI;
					END IF; */
					/* Bug # WFS_5_116, so that WI is not available to any user in a dynamic queue after one user has performed done operation */
					v_mainCode := 810; /* Workitem not in the queue specified. */
					OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
					
					RETURN ResultSet;
			/*Workitem is 	assigned to some user but AssignMentType is not Updated through PS	
				due to whcih another User trying to open the 	workitem after searching it, its getting assigned to the same on*/	
				ELSIF(v_Q_QueueId = 0 AND v_Q_UserId > 0) THEN
					IF(v_userIndex = v_Q_UserId  OR v_userIndex = v_Q_DivertedByUserId OR DBUtilityFlag = 'Y' ) THEN
						v_canLock := 'Y';
					ELSE 
						v_canLock := 'N';
					END IF;
				END IF;
			ELSE
				IF (v_userIndex = v_Q_UserId OR v_userIndex = v_Q_DivertedByUserId OR DBUtilityFlag = 'Y') THEN
					v_canLock := 'Y';
				ELSE 
					v_canLock := 'N';
				END IF;
			END IF;

			IF(v_canLock = 'Y') THEN
			
			IF(v_AssignmentType IS NULL) THEN
				v_AssignmentType := 'S';
			END IF;
			v_Q_UserId := v_userIndex;
			v_AssignedUser	:= v_userName;
			v_WorkItemState	:= 2;
			v_StateName := 'RUNNING';
			v_LockedByName	:= v_userName;
				v_LockStatus := 'Y';
				v_LockedTime := TO_CHAR(Current_timestamp,'YYYY-MM-DD HH24:MI:SS');
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
	
			/*Row count check to be added --Mohnish --Check if v_found condition can be used instead of row count in oracle*/
			v_rowCount := 0;
			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			v_Queuename:=replace(v_Queuename,'''','''''' );
			--IF(v_found ='Y') THEN
			IF(v_rowCount > 0) THEN
					--insert into testData values('v_Queuetype>>>'||v_Queuetype||'>>DBQueueId>>'||CAST(DBQueueId AS VARCHAR)||'>>>>DBProcessInstanceId>>>'||DBProcessInstanceId||'>>>>v_rowCount>>'||CAST(v_rowCount AS VARCHAR));
					IF(v_Queuetype != 'F' OR (v_Queuetype = 'F' AND v_Q_QueueId > 0 AND v_tempQ_UserId = v_userIndex) OR (v_Queuetype = 'F' AND v_Q_QueueId > 0 AND DBProcessInstanceId IS NULL OR DBProcessInstanceId = '')
					OR(v_Queuetype = 'F' AND v_AssignmentType = 'H') ) THEN 
					BEGIN
						Update WFInstrumentTable set ASSIGNMENTTYPE = v_AssignmentType , Q_USERID = v_Q_UserId,
						ASSIGNEDUSER = v_AssignedUser, WORKITEMSTATE = v_WorkItemState , STATENAME = v_Statename ,
						LOCKEDBYNAME = v_LockedByName ,LOCKSTATUS = v_LockStatus , LOCKEDTIME = TO_TIMESTAMP(v_LockedTime,'YYYY-MM-DD HH24:MI:SS')  ,
						Q_QUEUEID = v_AssignQ_QueueId , FILTERVALUE = v_AssignFilterVal ,QUEUETYPE = v_AssignQueueType,QUEUENAME = v_AssignQueueName ,Q_DivertedByUserId =  v_Q_DivertedByUserId WHERE ProcessInstanceId = v_ProcessInstanceId and WorkItemId = v_WorkItemId;
						GET DIAGNOSTICS v_rowCount = ROW_COUNT;
					END;	
					ELSE
					BEGIN
						v_rowCount := 0;
					END;
					END IF;
					IF(v_rowCount > 0) THEN 
						--commit;		
						v_lockFlag := 'Y';
					ELSE
						v_mainCode := 16;		/* WorkItem might be locked by some other user while this user is trying to lock */
						--OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;/*Rollback to savepoint --Mohnish*/
						--RETURN ResultSet;
					END IF;
			END IF;	
					
			
				IF(v_lockFlag = 'Y' AND v_genLog = 'Y' AND v_ExpiryFlag = 'N') THEN
				/* Logging for Locking workitem --Mohnish*/
				v_genLog_mainCode :=WFGenerateLog(7, COALESCE(v_userIndex,0),COALESCE(v_ProcessDefId,0),COALESCE(v_ActivityId,0), COALESCE(v_Q_QueueId,0), COALESCE(v_userName,''),  COALESCE(v_ActivityName,''), 0, COALESCE(v_ProcessInstanceId,''), 0 ,COALESCE(v_Queuename,'') , COALESCE(v_WorkitemId,0) , 0 , 0 , NULL , v_ProcessVarinatId , 0 , 0, COALESCE(v_URN,'') ,NULL);
			ELSIF (v_lockFlag = 'N') THEN
				v_mainCode := 16;		/* WorkItem might be locked by some other user while this user is trying to lock */
			END IF;
		ELSE
			v_CheckQueryWSFlag := 'Y';
			v_mainCode := 300;	/* no authorization */
		END IF;
--	ELSIF (v_bInQueue = 'Y' OR v_canLock = 'N') THEN 
	ELSIF (v_CheckQueryWSFlag = 'N') THEN 
		IF (DBTaskId >0) THEN
			SELECT	INTO 
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus,v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN 
				
                ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus,ProcessVariantId,ActivityType,LastModifiedTime  ,URN
		
			FROM WFINSTRUMENTTABLE
			WHERE	ProcessInstanceID = v_ProcessInstanceId 
			AND	WorkItemID = v_WorkitemId
			AND RoutingStatus = 'N';
			
			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			
			IF(v_ActivityType = 32) THEN
				SELECT	INTO v_CanInitiate,v_showCaseVisual max(CanInitiate),max(ShowCaseVisual) 
				FROM WFTaskStatusTable WHERE ProcessInstanceID = v_ProcessInstanceId AND	WorkItemID = v_WorkitemId AND	ActivityId = v_ActivityId  AND ASSIGNEDTO = v_userName 
				AND TASKSTATUS != 4 ;
				IF(NOT FOUND) THEN
					v_CanInitiate := 'N';
					v_showCaseVisual := 'N';
				END IF;
			END IF;
			
		ELSIF(v_ProcessInstanceId IS NOT NULL AND LENGTH(v_ProcessInstanceId) > 0) THEN
			SELECT	INTO
			    v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus,v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN 

			     ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus ,ProcessVariantId,ActivityType,LastModifiedTime ,URN
		
			FROM WFINSTRUMENTTABLE
			WHERE	ProcessInstanceID = v_ProcessInstanceId 
			AND	WorkItemID = v_WorkitemId
			AND RoutingStatus = 'N'
			AND LockStatus = 'Y'; 

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			
			IF(v_ActivityType = 32) THEN
				SELECT	INTO v_CanInitiate,v_showCaseVisual max(CanInitiate),max(ShowCaseVisual) 
				FROM WFTaskStatusTable WHERE ProcessInstanceID = v_ProcessInstanceId AND	WorkItemID = v_WorkitemId AND	ActivityId = v_ActivityId  AND ASSIGNEDTO = v_userName 
				AND TASKSTATUS != 4 ;
				IF(NOT FOUND) THEN
					v_CanInitiate := 'N';
					v_showCaseVisual := 'N';
				END IF;
			END IF;
		ELSE	/* For FIFO when workitem not in WorkListTable and some workitem is locked in WorkInProcessTable */
			SELECT	INTO 
			v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion, 
			v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
			v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
			v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
			v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
			v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
			v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus ,v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN 
			
			ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
			LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
			ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
			Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
			WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
			LockStatus, LockedTime, Queuename, Queuetype,NotifyStatus ,ProcessVariantId,ActivityType,LastModifiedTime ,URN
			FROM WFINSTRUMENTTABLE
			WHERE	LockedByName = v_userName 
			AND		Q_QueueId = DBQueueId 
			AND	NOT (processInstanceId = DBLastProcessInstanceId AND workitemId	= DBLastWorkitemId)
			AND RoutingStatus = 'N'
			AND LockStatus = 'Y'
			LIMIT 1;

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		END IF;
		IF(v_rowCount > 0) THEN
			IF(DBTaskId>0) THEN
				v_mainCode := 32;		/* Workitem locked, when workitem locked by some other user */
				v_CheckQueryWSFlag :='N';
			ELSIF(NOT(v_LockedByName = v_userName)) THEN
				IF(v_Q_QueueId = 0 ) THEN
					v_mainCode := 300;
					v_CheckQueryWSFlag :='Y';
				ELSE
					v_mainCode := 16;		/* Workitem locked, when workitem locked by some other user */
					v_CheckQueryWSFlag :='N';
				END IF;
			ELSE
				IF(DBQueueType = 'F' AND DBAssignMe = 'Y' AND NOT(v_AssignmentType = 'F')) THEN
					v_AssignQueueName := v_userName + '''s MyQueue';
					Update WFINSTRUMENTTABLE Set AssignmentType = N'F', QueueType = N'U', Q_QueueId = 0, QueueName = v_AssignQueueName, FilterValue = NULL
					WHERE	LockedByName = v_userName 
					AND		Q_QueueId = DBQueueId
					AND processInstanceId = v_ProcessInstanceId 
					AND workitemId = v_WorkitemId;
				END IF;	
			END IF;
		ELSE
			IF(v_rowCount < 1) THEN
				IF(v_ProcessInstanceId IS NOT NULL AND LENGTH(v_ProcessInstanceId) > 0) THEN
					v_CheckQueryWSFlag := 'Y';
					v_mainCode := 300;		/* NO Authorization */
					SELECT INTO
						v_ProcessName, v_ProcessVersion, 
						v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
						v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
						v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
						v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, 
						v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, 
						v_LockedByName, v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, 
						v_NotifyStatus,v_ProcessVarinatId,v_LastModifiedTime,v_URN/*, v_tableNameReturn--Commented --Mohnish */
						
					     ProcessName, ProcessVersion, ProcessDefID,
						LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
						ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
						Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, NULL, CreatedDateTime,
						WorkItemState, Statename, NULL, PreviousStage, LockedByName, 
						LockStatus, LockedTime, Queuename, Queuetype, NULL,ProcessVariantId,LastModifiedTime,urn/*, 'QueueHistoryTable'--Commented --Mohnish */
					FROM	QUEUEHISTORYTABLE 
					WHERE	ProcessInstanceID = v_ProcessInstanceId
					AND	WorkItemID = v_WorkitemId;

					GET DIAGNOSTICS v_rowCount = ROW_COUNT;
					IF(v_rowCount >=1) THEN
						BEGIN
							v_tableName1 := 'QUEUEHISTORYTABLE';
						END;
					END IF;

					IF(v_rowCount < 1) THEN
						SELECT INTO
							v_ProcessName, v_ProcessVersion, 
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
							v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
							v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
							v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus,v_RoutingStatus,v_ProcessVarinatId,v_ActivityType,v_LastModifiedTime,v_URN 
						
							ProcessName, ProcessVersion, ProcessDefID,
							LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
							ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
							Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
							WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
							LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus,RoutingStatus ,ProcessVariantId,ActivityType,LastModifiedTime,URN  
							/*FROM	PENDINGWORKLISTTABLE */
							FROM WFINSTRUMENTTABLE	
							WHERE ProcessInstanceID = v_ProcessInstanceId
							AND	WorkItemID = v_WorkitemId;
						GET DIAGNOSTICS v_rowCount = ROW_COUNT;
						
						IF(v_rowcount > 0) THEN
							IF(v_RoutingStatus = 'R' AND  v_ActivityType!=2) THEN
								IF(v_Q_UserId = v_userIndex) THEN
									v_CheckQueryWSFlag := 'N';
									v_mainCode := 16;		/* Open WorkItem in Read only mode */
								END IF;
							END IF;
						ELSE
							IF(v_rowCount < 1) THEN
								v_mainCode := 22; /* Bugzilla Bug 7199, MainCode changed to Invalid_Workitem. */
								OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
								RETURN ResultSet;
							END IF;
						END IF;
					END IF;		
				ELSE
					v_mainCode := 18;			/* NO more data for FIFO when only queueId is given */
					OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
					RETURN ResultSet;
				END IF;
			END IF;
			/* Else workitem found in WorkInProcessTable */
		END IF;
	END IF;
	/*
	Need to check if this can be uncommented --Mohnish
	IF (strpos(v_Queuename,v_quoteChar) >0 )THEN
		v_Queuename := REPLACE(v_Queuename,v_quoteChar,'''''');
	END IF; 
	
	*/
	IF(v_CheckQueryWSFlag = 'Y' ) THEN	/* Query WorkStep Handling */
		/* 21/01/2008, Bugzilla Bug 1721, error code 810 - Ruhi Hira */
			IF(DBQueueId >= 0 AND ( (v_Q_QueueId IS NULL) OR (DBQueueId != v_Q_QueueId) ) ) THEN
				v_mainCode := 810; /* Workitem not in the queue specified. */
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
				RETURN ResultSet;
			END IF;
			IF(DBUtilityFlag = 'N') THEN
				SELECT INTO v_QueryActivityId, v_QueryPreview, v_editableOnQuery, v_queryQueueId  ActivityId, QueryPreview, EditableonQuery ,QueueId FROM (
				SELECT ACTIVITYTABLE.ActivityId , QUSERGROUPVIEW.QueryPreview ,QUSERGROUPVIEW.EditableonQuery ,QueueStreamTable.QueueId FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUSERGROUPVIEW
				WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
				AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
				AND QUSERGROUPVIEW.QueueId = QUEUESTREAMTABLE.QueueId
				AND ACTIVITYTABLE.ActivityType = 11
				AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
				AND QUSERGROUPVIEW.UserId = v_userIndex
				ORDER BY QUSERGROUPVIEW.GroupId DESC
				) A LIMIT 1;
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount <= 0) THEN
					SELECT INTO v_QueryActivityId, v_QueryPreview, v_editableOnQuery, v_queryQueueId ActivityId, QueryPreview, EditableonQuery,QueueId FROM (
					SELECT ACTIVITYTABLE.ActivityId , QUEUEUSERTABLE.QueryPreview ,QUEUEUSERTABLE.EditableonQuery,QueueStreamTable.QueueId  FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUEUEUSERTABLE,wfgroupmemberview
						WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
						AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
						AND QUEUEUSERTABLE.QueueId = QUEUESTREAMTABLE.QueueId
						AND ACTIVITYTABLE.ActivityType = 11
						AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
						AND QUEUEUSERTABLE.UserId = wfgroupmemberview.groupindex
						AND wfgroupmemberview.userindex = v_userIndex
						AND associationtype=1
						ORDER BY QUEUEUSERTABLE.UserId DESC
						)  A LIMIT 1;
						GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				
						IF(v_rowCount <= 0) THEN
							IF(v_ActivityType = 32) THEN
								SELECT	INTO v_CanInitiate,v_showCaseVisual max(CanInitiate),max(ShowCaseVisual) 
								FROM WFTaskStatusTable WHERE ProcessInstanceID = v_ProcessInstanceId AND	WorkItemID = v_WorkitemId AND	ActivityId = v_ActivityId  AND ASSIGNEDTO = v_userName AND TASKSTATUS != 4 ;
								IF(NOT FOUND) THEN
									v_rowCount := 0;
								ELSE 
								GET DIAGNOSTICS v_rowCount = ROW_COUNT;
								END IF;
								IF(v_rowCount <= 0) THEN
									  v_mainCode := 300; /*No Authorization*/
									  OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
									  RETURN ResultSet;
							    ELSE
									v_mainCode := 16; /*Read Only mode*/
								END IF;	
							ELSE
								v_mainCode := 300; /*No Authorization*/
								OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
								RETURN ResultSet;
							END IF;
						ELSE
							v_mainCode := 16; /*To be shown in Read only mode*/
							
							
							
					/*Need to check filter on query workstep queue */
					
							BEGIN
								SELECT INTO v_QueryFilter QueryFilter FROM  QueueUserTable WHERE QueueId = v_queryQueueId AND userId = v_userIndex AND AssociationType = 0;
								GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
							END;
							IF(v_rowCount > 0) THEN
								IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) > 0) THEN
									v_QueryFilter := BTRIM(v_QueryFilter);
									v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
									v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
									v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
									IF(v_orderByPos > 0) THEN
										v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
									END IF;
									v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
								END IF;
							ELSE
								v_queryStr := 'Select QueryFilter, GroupId From QUserGroupView Where QueueId  = ' || v_queryQueueId || ' AND UserId = ' || v_userIndex || ' AND GroupId IS NOT NULL ';
								OPEN FilterCur FOR EXECUTE v_queryStr;
								FETCH FilterCur INTO v_queryFilter, v_GroupId;
								IF(FOUND) THEN
									v_DBStatus := 1;
								END IF;
								v_counterInt := 1;
								WHILE(v_DBStatus  <> 0) LOOP 
									IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) <> 0) THEN
										v_QueryFilter := BTRIM(v_QueryFilter);
										v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
										v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
										v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
										IF(v_orderByPos > 0) THEN					
											v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
										END IF;
										v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
										v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'G', v_GroupId);
										IF(LENGTH(v_QueryFilter) > 0) THEN
											IF v_counterInt = 1 THEN
												v_tempFilter :=  v_QueryFilter;
											ELSE
												v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
											END IF;	
											v_counterInt := v_counterInt + 1;
										END IF;
									ELSE
										v_tempFilter := '';
									END IF;
									IF(LENGTH(v_tempFilter) = 0) THEN
										EXIT;
									END IF;
									v_DBStatus := 0;
									FETCH FilterCur INTO v_queryFilter, v_GroupId;
									IF(FOUND) THEN
										v_DBStatus := 1;
									END IF;
								END LOOP; 
								CLOSE FilterCur;
								v_QueryFilter := v_tempFilter;
							END IF;
							
							IF (v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0 ) THEN
								v_FunctionPos := STRPOS(v_QueryFilter, v_funcMacro);	
								IF(v_FunctionPos != 0) THEN
									v_FunLength := LENGTH(v_funcMacro);
									v_functionFlag := 'Y';		
									WHILE(v_functionFlag = 'Y') LOOP
											v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
											v_funPos1 := STRPOS(v_QueryFilter, chr(123));				
											v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
											v_tempFunStr := BTRIM(v_tempFunStr);						
						
											IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
													v_funPos2 := STRPOS(v_QueryFilter, chr(125));
													v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
													v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
													queryFunStr := 'SELECT ' || v_funFilter;							
													Execute queryFunStr INTO v_FunValue;
													
													IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
														v_FunValue := '1 = 1';
													END IF;
													v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
											ELSE
												EXIT;
											END IF;							
											v_FunctionPos := STRPOS(v_QueryFilter, '&<FUNCTION>&');
											IF(v_FunctionPos = 0) THEN
												v_functionFlag := 'N';
											END IF;					
									END LOOP;				
								END IF;
							END IF;
				
							IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
								BEGIN
									v_queryStr := 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable left outer join VarMappingTable  on 	WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='|| CAST(v_ProcessDefID AS VARCHAR)||' and WFSearchVariableTable.activityID ='||CAST(v_QueryActivityId AS VARCHAR)||' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C''';
									v_finalColumnStr:='';
									OPEN FilterCur FOR EXECUTE v_queryStr;
									FETCH FilterCur INTO v_fieldName,v_extObjId,v_systemDefinedName;
									IF(FOUND) THEN
										v_DBStatus := 1;
									END IF;
									WHILE(v_DBStatus <> 0) LOOP 
										BEGIN
											IF (v_fieldName IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_fieldName))) > 0)THEN
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
											v_DBStatus := 0;
											FETCH FilterCur INTO v_fieldName,v_extObjId,v_systemDefinedName;
											IF(FOUND) THEN
												v_DBStatus := 1;
											END IF;
										END;
									END LOOP;
									CLOSE FilterCur;
								END;
					
								/*Checkin user is eligible to open the workitem or not */
								BEGIN
									v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
					
									v_query1:=' FROM WFINSTRUMENTTABLE   ';
					
									IF v_externalTaleJoin='Y' THEN
										BEGIN
											v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
						
											v_query1:=' FROM WFINSTRUMENTTABLE  INNER JOIN '||DBExternalTableName ||'    ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
						
										END;
									END IF;
					
					
									IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
										BEGIN
											v_queryStr:=v_queryStr||v_finalColumnStr;
										END;
									END IF;
					
									v_query1:=v_query1|| ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID='''|| v_ProcessInstanceId||''' AND WFINSTRUMENTTABLE.WorkItemID='|| v_WorkitemId;
					
									v_query1:='SELECT  * from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
									EXECUTE  v_query1;
									GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
									If(v_rowCount <= 0) THEN
										BEGIN 
											v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
						
											v_query1:=' FROM QueueHistoryTable ';
					
											IF v_externalTaleJoin='Y' THEN
												BEGIN
													v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
													If (v_extTableNameHistory IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0) THEN
														BEGIN
														v_query1:=' FROM QueueHistoryTable  INNER JOIN '||v_extTableNameHistory ||' ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
														END;
													ELSE
														BEGIN
															v_query1:=' FROM QueueHistoryTable INNER JOIN '||DBExternalTableName ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
														END;
													END IF;
												END;
											END IF;
									
											IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
												BEGIN
													v_queryStr:=v_queryStr||v_finalColumnStr;
												END;
											END IF;
											v_query1:=v_query1|| ' WHERE QueueHistoryTable.ProcessInstanceID='''|| v_ProcessInstanceId||''' AND QueueHistoryTable.WorkItemID='|| v_WorkitemId;
											v_query1:='SELECT * from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
											EXECUTE  v_query1 ;
											GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
											If(v_rowCount <= 0) THEN
												BEGIN
													v_mainCode	:= 300;	
													OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
													RETURN ResultSet;
												END;
											END IF;
										END;
									END IF;
								END;
							END IF;
							/*filter Check END HERE */
							
							IF (v_editableOnQuery= 'Y' AND v_QueryPreview='Y') THEN
							BEGIN
								V_queryStr2 :=' SELECT  processdefid FROM '||v_tableName1||' WHERE PROCESSINSTANCEID= '''||v_ProcessInstanceId||''' AND WORKITEMID= '||v_WorkitemId||'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''||v_userName||''')) LIMIT 1 FOR UPDATE';
								Execute  V_queryStr2 into v_exists ;
								IF(NOT FOUND) THEN
									v_rowCount := 0;
								ELSE 
									GET DIAGNOSTICS v_rowCount = ROW_COUNT;
								END IF;
								IF(v_RowCount > 0) THEN
								BEGIN
									v_Q_UserId := v_userIndex;
									v_AssignedUser	:= v_userName;
									v_LockedByName	:= v_userName;
									v_LockStatus := 'Y';
									v_LockedTime := TO_CHAR(Current_timestamp,'YYYY-MM-DD HH24:MI:SS');
									V_queryStr2 :='Update '||v_tableName1||' Set Q_UserId = '||v_Q_UserId||' ,LockedByName = '''||v_LockedByName ||''', LockStatus ='''||v_LockStatus||''' ,LockedTime = TO_DATE('''||v_LockedTime||''',''YYYY-MM-DD HH24:MI:SS'')   where ProcessInstanceId = '''||v_ProcessInstanceId||''' and WorkItemId = '||v_WorkItemId;  
									EXECUTE  V_queryStr2 ;
									GET DIAGNOSTICS v_rowCount = ROW_COUNT;
									IF(v_rowCount > 0) THEN
									BEGIN
										v_mainCode := 0;
										v_lockFlag :='Y';
									END;
									ELSE
									BEGIN
										v_mainCode := 16;
										v_lockFlag :='N';
									END;
									END IF;
								END;
								END IF;
							END;
							END IF;
							
							IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
								v_ActivityId := v_QueryActivityId;
							END IF;	
				END IF;
				ELSE
					v_mainCode := 16; /*To be shown in Read only mode*/
					
					
					/*Need to check filter on query workstep queue */
					
							BEGIN
								SELECT INTO v_QueryFilter QueryFilter FROM  QueueUserTable WHERE QueueId = v_queryQueueId AND userId = v_userIndex AND AssociationType = 0;
								GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
							END;
							IF(v_rowCount > 0) THEN
								IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) > 0) THEN
									v_QueryFilter := BTRIM(v_QueryFilter);
									v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
									v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
									v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
									IF(v_orderByPos > 0) THEN
										v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
									END IF;
									v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
								END IF;
							ELSE
								v_queryStr := 'Select QueryFilter, GroupId From QUserGroupView Where QueueId  = ' || v_queryQueueId || ' AND UserId = ' || v_userIndex || ' AND GroupId IS NOT NULL ';
								OPEN FilterCur FOR EXECUTE v_queryStr;
								FETCH FilterCur INTO v_queryFilter, v_GroupId;
								IF(FOUND) THEN
									v_DBStatus := 1;
								END IF;
								v_counterInt := 1;
								WHILE(v_DBStatus  <> 0) LOOP 
									IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) <> 0) THEN
										v_QueryFilter := BTRIM(v_QueryFilter);
										v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, CAST(v_userIndex AS VARCHAR));
										v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
										v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
										IF(v_orderByPos > 0) THEN					
											v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
										END IF;
										v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'U', v_userIndex);
										v_QueryFilter := WFParseQueryFilter(v_QueryFilter, 'G', v_GroupId);
										IF(LENGTH(v_QueryFilter) > 0) THEN
											IF v_counterInt = 1 THEN
												v_tempFilter :=  v_QueryFilter;
											ELSE
												v_tempFilter  := v_tempFilter || ' OR ' || v_QueryFilter; 
											END IF;	
											v_counterInt := v_counterInt + 1;
										END IF;
									ELSE
										v_tempFilter := '';
									END IF;
									IF(LENGTH(v_tempFilter) = 0) THEN
										EXIT;
									END IF;
									v_DBStatus := 0;
									FETCH FilterCur INTO v_queryFilter, v_GroupId;
									IF(FOUND) THEN
										v_DBStatus := 1;
									END IF;
								END LOOP; 
								CLOSE FilterCur;
								v_QueryFilter := v_tempFilter;
							END IF;
							
							IF (v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0 ) THEN
								v_FunctionPos := STRPOS(v_QueryFilter, v_funcMacro);	
								IF(v_FunctionPos != 0) THEN
									v_FunLength := LENGTH(v_funcMacro);
									v_functionFlag := 'Y';		
									WHILE(v_functionFlag = 'Y') LOOP
											v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
											v_funPos1 := STRPOS(v_QueryFilter, chr(123));				
											v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
											v_tempFunStr := BTRIM(v_tempFunStr);						
						
											IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
													v_funPos2 := STRPOS(v_QueryFilter, chr(125));
													v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
													v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
													queryFunStr := 'SELECT ' || v_funFilter;							
													Execute queryFunStr INTO v_FunValue;
													
													IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
														v_FunValue := '1 = 1';
													END IF;
													v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
											ELSE
												EXIT;
											END IF;							
											v_FunctionPos := STRPOS(v_QueryFilter, '&<FUNCTION>&');
											IF(v_FunctionPos = 0) THEN
												v_functionFlag := 'N';
											END IF;					
									END LOOP;				
								END IF;
							END IF;
				
							IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
								BEGIN
									v_queryStr := 'Select FieldName, ExtObjID,SystemDefinedName from WFSearchVariableTable left outer join VarMappingTable  on 	WFSearchVariableTable.FieldName = VarMappingTable.UserDefinedName where WFSearchVariableTable.ProcessDefID ='|| CAST(v_ProcessDefID AS VARCHAR)||' and WFSearchVariableTable.activityID ='||CAST(v_QueryActivityId AS VARCHAR)||' and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) and scope=''C''';
									v_finalColumnStr:='';
									OPEN FilterCur FOR EXECUTE v_queryStr;
									FETCH FilterCur INTO v_fieldName,v_extObjId,v_systemDefinedName;
									IF(FOUND) THEN
										v_DBStatus := 1;
									END IF;
									WHILE(v_DBStatus <> 0) LOOP 
										BEGIN
											IF (v_fieldName IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_fieldName))) > 0)THEN
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
											v_DBStatus := 0;
											FETCH FilterCur INTO v_fieldName,v_extObjId,v_systemDefinedName;
											IF(FOUND) THEN
												v_DBStatus := 1;
											END IF;
										END;
									END LOOP;
									CLOSE FilterCur;
								END;
					
								/*Checkin user is eligible to open the workitem or not */
								BEGIN
									v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
					
									v_query1:=' FROM WFINSTRUMENTTABLE   ';
					
									IF v_externalTaleJoin='Y' THEN
										BEGIN
											v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
						
											v_query1:=' FROM WFINSTRUMENTTABLE  INNER JOIN '||DBExternalTableName ||'    ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
						
										END;
									END IF;
					
					
									IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
										BEGIN
											v_queryStr:=v_queryStr||v_finalColumnStr;
										END;
									END IF;
					
									v_query1:=v_query1|| ' WHERE WFINSTRUMENTTABLE.ProcessInstanceID='''|| v_ProcessInstanceId||''' AND WFINSTRUMENTTABLE.WorkItemID='|| v_WorkitemId;
					
									v_query1:='SELECT  * from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
									EXECUTE  v_query1;
									GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
									If(v_rowCount <= 0) THEN
										BEGIN 
											v_queryStr:='Select  processInstanceId, queueName, processName, processVersion, activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill, workitemId, priorityLevel,  parentWorkitemId, processDefId, activityId, instrumentStatus, lockStatus, lockedByName, createdByName, createdDateTime, lockedTime, introductionDateTime, introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId, NULL as turnAroundTime, referredBy, referredTo,   expectedProcessDelayTime,   expectedWorkitemDelayTime, processedBy, q_userId, workitemState, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,URN ';
						
											v_query1:=' FROM QueueHistoryTable ';
					
											IF v_externalTaleJoin='Y' THEN
												BEGIN
													v_queryStr:=v_queryStr||' , ItemIndex,ItemType ';
													If (v_extTableNameHistory IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0) THEN
														BEGIN
														v_query1:=' FROM QueueHistoryTable  INNER JOIN '||v_extTableNameHistory ||' ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
														END;
													ELSE
														BEGIN
															v_query1:=' FROM QueueHistoryTable INNER JOIN '||DBExternalTableName ||'  ON Var_Rec_1 = ItemIndex AND Var_Rec_2 = ItemType ';
														END;
													END IF;
												END;
											END IF;
									
											IF (v_finalColumnStr IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_finalColumnStr))) > 0 ) THEN
												BEGIN
													v_queryStr:=v_queryStr||v_finalColumnStr;
												END;
											END IF;
											v_query1:=v_query1|| ' WHERE QueueHistoryTable.ProcessInstanceID='''|| v_ProcessInstanceId||''' AND QueueHistoryTable.WorkItemID='|| v_WorkitemId;
											v_query1:='SELECT * from ( '||v_QueryStr||v_query1||' ) QUERYTABLE1 WHERE '||v_QueryFilter;
											EXECUTE  v_query1 ;
											GET DIAGNOSTICS v_rowCount = ROW_COUNT; 
											If(v_rowCount <= 0) THEN
												BEGIN
													v_mainCode	:= 300;	
													OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
													RETURN ResultSet;
												END;
											END IF;
										END;
									END IF;
								END;
							END IF;
							/*filter Check END HERE */
					
					IF (v_editableOnQuery= 'Y' AND v_QueryPreview='Y') THEN
							BEGIN
								V_queryStr2 :=' SELECT  processdefid FROM '||v_tableName1||' WHERE PROCESSINSTANCEID= '''||v_ProcessInstanceId||''' AND WORKITEMID= '||v_WorkitemId||'  AND ACTIVITYTYPE=2 AND ROUTINGSTATUS=''R'' AND ( LOCKSTATUS=''N'' OR (LOCKSTATUS=''Y'' AND LOCKEDBYNAME= '''||v_userName||''')) LIMIT 1 FOR UPDATE';
								Execute  V_queryStr2 into v_exists ;
								IF(NOT FOUND) THEN
									v_rowCount := 0;
								ELSE 
									GET DIAGNOSTICS v_rowCount = ROW_COUNT;
								END IF;
								IF(v_RowCount > 0) THEN
								BEGIN
									v_Q_UserId := v_userIndex;
									v_AssignedUser	:= v_userName;
									v_LockedByName	:= v_userName;
									v_LockStatus := 'Y';
									v_LockedTime := TO_CHAR(Current_timestamp,'YYYY-MM-DD HH24:MI:SS');
									V_queryStr2 :='Update '||v_tableName1||' Set Q_UserId = '||v_Q_UserId||' ,LockedByName = '''||v_LockedByName ||''', LockStatus ='''||v_LockStatus||''' ,LockedTime = TO_DATE('''||v_LockedTime||''',''YYYY-MM-DD HH24:MI:SS'')   where ProcessInstanceId = '''||v_ProcessInstanceId||''' and WorkItemId = '||v_WorkItemId;  
									EXECUTE  V_queryStr2 ;
									GET DIAGNOSTICS v_rowCount = ROW_COUNT;
									IF(v_rowCount > 0) THEN
									BEGIN
										v_mainCode := 0;
										v_lockFlag :='Y';
									END;
									ELSE
									BEGIN
										v_mainCode := 16;
										v_lockFlag :='N';
									END;
									END IF;
								END;
								END IF;
							END;
							END IF;
					
					IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
						v_ActivityId := v_QueryActivityId;
					END IF;	
				END IF;
			END IF;
		END IF;
	
	IF((v_LockedByName = v_userName) AND (v_ActivityType=32)) THEN
		v_showCaseVisual :='Y';
		v_CanInitiate :='Y';
	END IF;  
		/* Logging for work started */
	IF(v_lockFlag = 'Y' AND v_genLog = 'Y' AND v_exists <> 0) THEN
		v_genLog_mainCode := WFGenerateLog(7, COALESCE(v_userIndex,0),COALESCE(v_ProcessDefId,0),COALESCE(v_ActivityId,0), COALESCE(v_Q_QueueId,0), COALESCE(v_userName,''),  COALESCE(v_ActivityName,''), 0, COALESCE(v_ProcessInstanceId,''), 0 ,COALESCE(v_Queuename,'') , COALESCE(v_WorkitemId,0) , 0 , 0 , NULL , v_ProcessVarinatId , 0 , 0 , COALESCE(v_URN,''),NULL);
	END IF;
	IF((v_mainCode = 0 OR v_mainCode = 16 OR v_mainCode = 401)  AND v_genLog = 'Y' AND v_WorkStartedLoggingEnabled = 'Y') THEN
	BEGIN
		v_genLog_mainCode :=WFGenerateLog(200, COALESCE(v_userIndex,0),COALESCE(v_ProcessDefId,0),COALESCE(v_ActivityId,0), COALESCE(v_Q_QueueId,0), COALESCE(v_userName,''), COALESCE(v_ActivityName,''), 0, COALESCE(v_ProcessInstanceId,''), 0 ,NULL , COALESCE(v_WorkitemId,0) , 0 , 0 , NULL , 0 , 0 , 0 ,COALESCE(v_URN,''),NULL);
	END;
	END IF;
			
	OPEN ResultSet FOR SELECT 
		v_mainCode				AS MainCode,
		v_lockFlag				AS lockFlag,
		v_userIndex				AS UserIndex,
		CURRENT_TIMESTAMP		AS CurrentDateTime,
		v_ProcessInstanceId		AS ProcessInstanceId,
		v_WorkItemId			AS WorkItemId,
		v_ProcessName			AS ProcessName,
		v_ProcessVersion		AS ProcessVersion,
		v_ProcessDefID			AS ProcessDefID,
		v_ProcessedBy			AS ProcessedBy,
		v_ActivityName			AS ActivityName,
		v_ActivityId			AS ActivityId,
		v_EntryDateTime			AS EntryDateTime,
		v_AssignmentType		AS AssignmentType,
		v_PriorityLevel			AS PriorityLevel,
		v_ValidTill				AS ValidTill,
		v_Q_QueueId				AS Q_QueueId,
		v_Q_UserId				AS Q_UserId,
		v_AssignedUser			AS AssignedUser,
		v_CreatedDateTime		AS CreatedDateTime,
		v_WorkItemState			AS WorkItemState,
		v_Statename				AS Statename,
		v_ExpectedWorkitemDelay	AS ExpectedWorkitemDelay,
		v_PreviousStage			AS PreviousStage,
		v_LockedByName			AS LockedByName,
		v_LockStatus			AS LockStatus,
		v_LockedTime			AS LockedTime,
		v_Queuename				AS Queuename,
		v_Queuetype				AS Queuetype,
		/*v_tableNameReturn		AS TableName,*/
		v_userName				AS UserName,
		v_ProcessVarinatId      AS ProcessVariantId,
		v_CanInitiate			AS CanInitiate,
		v_showCaseVisual		AS ShowCaseVisual,
		v_LastModifiedTime		AS LastModifiedTime,
		v_URN 					AS URN,
		v_sortFieldStrValue			As SortedOn;
	RETURN ResultSet;
END;

$$LANGUAGE plpgsql;