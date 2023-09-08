/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFGetWorkItem.sql
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 13/12/2007
	Description					: To lock the workitem and return the data
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
08/01/2008		Ashish Mangla		Bugzilla Bug 1681 (UserName Marco support required)
21/01/2008		Ruhi Hira		Bugzilla Bug 1721, error code 810.
22/01/2008		Ruhi Hira		Bugzilla Bug 3580, Unable to open fixed assigned workitems from search.
25/02/2008		Varun Bhansaly		Performance Optimization - Inherited from PRD Bug Solution WFS_5_212
30/04/2008		Siish Gupta		Bugzilla Bug 4651.
16/12/2008		Ruhi Hira		Bugzilla Bug 7199, MainCode changed to Invalid_Workitem.
10/09/2010		Saurabh Kamal	OF 9.0 support on Postgres DB
01/07/2011		Saurabh Kamal	Bug 27393, In case of FIFO Queue, if a user is working on a workitem then it should get permanently assigned to the same user(Fixed Assignment).

_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFGetWorkItem(INTEGER, VARCHAR, INTEGER, INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR) RETURNS REFCURSOR AS '
DECLARE 
	DBSessionId				ALIAS FOR $1;
	DBProcessInstanceId		ALIAS FOR $2;
	DBWorkItemId			ALIAS FOR $3;
	DBQueueId				ALIAS FOR $4;
	DBQueueType				ALIAS FOR $5;		/* '' -> Search; F -> FIFO; D, S, N -> WIP */
	DBLastProcessInstanceId	ALIAS FOR $6;
	DBLastWorkitemId		ALIAS FOR $7;
	DBGenerateLog			ALIAS FOR $8;
	DBAssignMe				ALIAS FOR $9;

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
	v_EntryDateTime 		TIMESTAMP;
	v_ParentWorkItemId		INTEGER;
	v_AssignmentType		VARCHAR(1);
	v_CollectFlag			VARCHAR(1);
	v_PriorityLevel			INTEGER;
	v_ValidTill				TIMESTAMP;
	v_Q_StreamId			INTEGER;
	v_Q_QueueId				INTEGER;
	v_Q_UserId				INTEGER;
	v_AssignedUser			VARCHAR(63);
	v_FilterValue			INTEGER;
	v_CreatedDatetime		TIMESTAMP;
	v_WorkItemState			INTEGER;
	v_Statename 			VARCHAR(255);
	v_ExpectedWorkitemDelay	TIMESTAMP;
	v_PreviousStage			VARCHAR(30);
	v_LockedByName			VARCHAR(63);
	v_LockStatus			VARCHAR(1);
	v_LockedTime			TIMESTAMP;
	v_Queuename 			VARCHAR(63);
	v_Queuetype 			VARCHAR(1);
	v_NotifyStatus			VARCHAR(1); 
	v_QueryPreview			VARCHAR(1);

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
	v_userName				VARCHAR(30);
	v_status				VARCHAR(1);
	v_queryStr				TEXT;
	v_queryFilterStr		VARCHAR(800);
	v_queryFilterStr2		VARCHAR(800);
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
	v_emptyString			VARCHAR(2);
	v_tableNameReturn		VARCHAR(30);
	v_QDTColStr				TEXT; 
	v_WLTColStr				TEXT; 
	v_WLTColStr1			TEXT;
	v_CursorAlias			REFCURSOR; 
	v_AliasStr				VARCHAR(1000); 
	v_PARAM1				VARCHAR(64); 
	v_ALIAS					VARCHAR(64); 
	v_ToReturn				VARCHAR(1); 
	ResultSet				REFCURSOR;
	FilterCur				REFCURSOR;
	ProcessInstCur			REFCURSOR;
	WorkItem_Cur			REFCURSOR;
	v_Record				RECORD;
	v_AssignQ_QueueId		INTEGER;	
	v_AssignWIState			INTEGER;
	v_AssignQueueType		VARCHAR(1);	
	v_AssignQueueName		VARCHAR(100);
	
BEGIN
	/* Initializations */
	v_toSearchStr		:= ''ORDER BY'';
	v_found				:= ''N'';
	v_canLock			:= ''N'';
	v_lockFlag			:= ''N'';
	v_ProcessInstanceId	:= DBProcessInstanceId;
	v_WorkitemId		:= DBWorkitemId;
	v_Q_QueueId			:= DBQueueId;
	v_DBStatus			:= -1;
	v_quoteChar			:= CHR(39);
	v_orderByStr		:= '''';
	v_QueryFilter		:= '''';
	v_QueueDataTableStr	:= '''';
	v_emptyString		:= '''';
	v_AliasStr			:= '''';
	v_CheckQueryWSFlag  := ''N'';
	v_macro				:= ''&<UserIndex>&'';
	v_macroUserName		:= ''&<UserName>&'';
	v_DBStatus			:= 0;
	v_mainCode			:= 0;
	v_tableName			:= NULL;

	/* Check session validity */
	SELECT	INTO v_userIndex ,v_userName, v_status userIndex, userName, statusFlag
	FROM	WFSessionView, WFUserView 
	WHERE	UserId = UserIndex AND
			SessionID	= DBSessionId; 
	IF(NOT FOUND) THEN
		v_mainCode	:= 11;	/* Invalid Session Handle */
		OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
		RETURN ResultSet;
	END IF;
	
	IF(v_status = ''N'') THEN
		Update WFSessionView set statusflag = ''Y'' , AccessDateTime = CURRENT_TIMESTAMP
          WHERE SessionID = DBSessionId;
	END IF;

	/* for FIFO case for getting new WorkItem append filter option also */
	IF(DBQueueType = ''F'' AND DBQueueId IS NOT NULL AND DBQueueId > 0 AND (v_ProcessInstanceId IS NULL OR LENGTH(BTRIM(v_ProcessInstanceId)) = 0))  THEN
		SELECT	INTO v_orderBy, v_QueueFilter OrderBy, QueueFilter
		FROM	QUEUEDEFTABLE 
		WHERE	QueueID = DBQueueId;
		IF(v_orderBy IS NOT NULL AND LENGTH(BTRIM(v_orderBy)) > 0) THEN
			v_len := LENGTH(v_orderBy);
			IF(v_len > 3) THEN
				/* Extract first order by */
				v_tempOrderStr := SUBSTR(v_orderBy,1, (v_len-3));
				v_iFirstOrder := TO_NUMBER(v_tempOrderStr);

				IF v_iFirstOrder = 1 THEN
					v_sortFieldStr := '' PriorityLevel '';
					v_orderByStr := '' ORDER BY '' || v_sortFieldStr || '' DESC '';
				END IF;			
				/* Extract last three digits for second order cond */
				v_orderBy := SUBSTR(v_orderBy, LENGTH(v_tempOrderStr) + 1, v_len - LENGTH(v_tempOrderStr));
			END IF;
			v_iOrder := TO_NUMBER(v_orderBy, ''99999'');
			IF v_iOrder = 2 THEN
				v_sortFieldStr := '' ProcessInstanceId '';
			ELSIF v_iOrder = 10 THEN
				v_sortFieldStr := '' EntryDateTime '';
			ELSE
				v_sortFieldStr := '' ProcessInstanceId '';
			END IF;

			IF(v_orderByStr IS NOT NULL AND LENGTH(v_orderByStr) > 0) THEN
				v_orderByStr := v_orderByStr || '' , '' || v_sortFieldStr || '' ASC '';
			ELSE
				v_orderByStr := '' ORDER BY '' || v_sortFieldStr || '' ASC '';
			END IF;
		END IF;
	END IF;

	v_queryFilterStr := '' WHERE '';

	/* ProcessInstanceId will be NULL for FIFO only .... */
	IF(v_ProcessInstanceId IS NULL OR LENGTH(BTRIM(v_ProcessInstanceId)) = 0) THEN
		v_queryFilterStr := v_queryFilterStr || '' Q_QueueId = '' || DBQueueId;
	ELSE
		v_queryFilterStr := v_queryFilterStr || '' ProcessInstanceId = '' || v_quoteChar || v_ProcessInstanceId || v_quoteChar ||								'' AND WorkitemId = '' || v_WorkitemId;
	END IF;

	/* Filter on last value if given in input, pre fetch case for thick client */
	IF(DBLastProcessInstanceId IS NOT NULL AND LENGTH(BTRIM(DBLastProcessInstanceId)) > 0) THEN
		v_queryFilterStr := v_queryFilterStr || '' AND NOT processInstanceId = '' || v_quoteChar || DBLastProcessInstanceId || v_quoteChar ||								'' AND workitemId = '' || DBLastWorkitemId || '' ) '';
	END IF;

	/*
		Some valisdations can also be put like in case of FIFO only, processInstanceId, WorkItemItem are not sent...
		If saome validations are failing we can return Invalid paramater
		For the time being it is assumned that data will be send in proper case only......
	*/
	IF(DBQueueId < 0) THEN	/*Search case we have to find Q_QueueId for the workItem to find the QueryFilter condition*/
		SELECT INTO v_Q_QueueId , v_Queuetype , v_Q_UserId , v_tableName , v_FilterValue, v_ProcessDefID, v_Queuename, v_LockedTime, v_LockStatus, v_LockedByName, v_PreviousStage, v_ExpectedWorkitemDelay, v_Statename, v_WorkItemState, v_CreatedDateTime, v_AssignedUser, v_ValidTill,  v_PriorityLevel, v_AssignmentType, v_EntryDateTime, v_ActivityId, v_ActivityName, v_ProcessedBy, v_ProcessVersion, v_ProcessName Q_QueueId, QueueType, Q_UserId, tableName, FilterValue, ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName
		FROM (
			SELECT Q_QueueId, QueueType, Q_UserId, ''WorkListTable'' AS tableName, FilterValue , ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName FROM WORKLISTTABLE 
				WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkitemId				
			UNION ALL
			SELECT Q_QueueId, QueueType, Q_UserId, ''WorkInProcessTable'' AS tableName, FilterValue , ProcessDefId, QueueName, LockedTime, LockStatus, LockedByName, PreviousStage, ExpectedWorkitemDelay, Statename, WorkItemState, CreatedDateTime, AssignedUser, ValidTill, PriorityLevel, AssignmentType, EntryDateTime, ActivityId, ActivityName, ProcessedBy, ProcessVersion, ProcessName FROM WORKINPROCESSTABLE 
				WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkitemId
		) WorkListView;
		
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF(v_rowCount > 0) THEN
			/** 22/01/2008, Bugzilla Bug 3580, Unable to open fixed assigned workitems from search - Ruhi Hira */
			IF(v_Q_QueueId IS NOT NULL AND v_Q_QueueId > 0) THEN
				v_bInQueue := ''Y'';	

				SELECT INTO v_qdt_filterOption, v_QueueFilter QUEUEDEFTABLE.FilterOption, QUEUEDEFTABLE.QueueFilter 
				FROM	QUEUEDEFTABLE, QUserGroupView 
				WHERE	QUEUEDEFTABLE.QueueID = QUserGroupView.QueueID 
				AND	QUEUEDEFTABLE.QueueID = v_Q_QueueId
				AND	UserId = v_userIndex 
				LIMIT 1;

				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				IF(v_rowCount > 0) THEN
					IF( NOT ( (v_qdt_FilterOption = 2 AND v_FilterValue = v_userIndex) 
								OR (v_qdt_FilterOption = 3 AND v_FilterValue != v_userIndex) 
								OR (v_qdt_FilterOption = 1))) THEN
						v_canLock := ''N'';
						v_CheckQueryWSFlag := ''Y'';
					END IF;
				ELSE
					v_canLock := ''N'';
					v_CheckQueryWSFlag := ''Y'';
				END IF;
			END IF;
		ELSE
			v_Q_QueueId := -1;
			v_bInQueue := ''N'';
		END IF;
	END IF;
	
	v_QueryStr := ''SELECT PARAM1, ALIAS, ToReturn FROM VarAliasTable WHERE QueueId = '' || v_Q_QueueId || '' ORDER BY ID ASC''; 
	OPEN v_CursorAlias FOR EXECUTE v_QueryStr;
	LOOP
		FETCH v_CursorAlias INTO v_PARAM1, v_ALIAS, v_ToReturn;
		IF(NOT FOUND) THEN
				EXIT;
		END IF;
		IF (v_ToReturn = ''Y'') THEN 
			v_AliasStr :=  v_AliasStr || '', '' || v_PARAM1 || '' AS '' || v_ALIAS; 
		END IF; 
	END LOOP;
	CLOSE v_CursorAlias;

	/*
		QueueId has been fetch for the WorkItem , 
		Find QueryFilter for the following cases :- 
			1. FIFO, have to find next WI and lock it (We will be needing QueryFilter for conditions and Order by)
			2. WIP, to check if teh WI has to be opened in writable modde or in Query WorkStep read only mode
	*/

	/* check filter	*/
	IF(
		(DBQueueType = ''F'' AND DBQueueId > 0 AND (v_ProcessInstanceId IS NULL OR LENGTH(BTRIM(v_ProcessInstanceId)) = 0)) 
						OR 
		(DBQueueId < 0 AND v_bInQueue = ''Y'' AND (v_Q_UserId IS NULL OR v_userIndex != v_Q_UserId))
	)THEN
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
				v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, to_char(v_userIndex, ''99999''));
				v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
				v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
				IF(v_orderByPos > 0) THEN
					IF(DBQueueId > 0) THEN
						v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH(v_toSearchStr), LENGTH(v_QueryFilter));
					END IF;
					v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
				END IF;
				v_QueryFilter := WFParseQueryFilter(v_QueryFilter, ''U'', v_userIndex);
			END IF;
		ELSE	/* User may be added as a Group Member to the Queue, consider group filters if present */
			v_queryStr := ''Select QueryFilter, GroupId From QUserGroupView Where QueueId  = '' || v_Q_QueueId || '' AND UserId = '' || v_userIndex || '' AND GroupId IS NOT NULL '';
			OPEN FilterCur FOR EXECUTE v_queryStr;
			FETCH FilterCur INTO v_queryFilter, v_GroupId;
			IF(FOUND) THEN
				v_DBStatus := 1;
			END IF;
			v_counterInt := 1;
			WHILE(v_DBStatus  <> 0) LOOP 
				IF(v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) <> 0) THEN
					v_QueryFilter := BTRIM(v_QueryFilter);
					v_QueryFilter :=  REPLACE(v_QueryFilter , v_macro, to_char(v_userIndex, ''99999''));
					v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
					v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
					IF(v_orderByPos > 0) THEN					
						IF(DBQueueId > 0) THEN
							v_tempOrderStr := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH(v_toSearchStr), LENGTH(v_QueryFilter));
						END IF;
						v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1);
					END IF;
					v_QueryFilter := WFParseQueryFilter(v_QueryFilter, ''U'', v_userIndex);
					v_QueryFilter := WFParseQueryFilter(v_QueryFilter, ''G'', v_GroupId);
					IF(LENGTH(v_QueryFilter) > 0) THEN
						v_QueryFilter := ''('' || v_QueryFilter || '')'';
						IF v_counterInt = 1 THEN
							v_tempFilter :=  v_QueryFilter;
						ELSE
							v_tempFilter  := v_tempFilter || '' OR '' || v_QueryFilter; 
						END IF;	
						v_counterInt := v_counterInt + 1;
					END IF;
				ELSE
					v_tempFilter := '''';
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
				v_orderByStr := '' ORDER BY '' || v_tempOrderStr;
			END IF;
		END IF;


		/* Check For Queue Filter for Search Case */
		v_DBStatus := 0;		
		v_QueryFilter := BTRIM(v_QueryFilter);
		IF((v_QueryFilter IS NULL OR LENGTH(v_QueryFilter) = 0) AND (v_Queuetype = ''N'')) THEN 
			SELECT INTO v_QueueFilter QueueFilter From QueueDefTable where QueueId = v_Q_QueueId;
			IF(v_QueueFilter IS NOT NULL AND LENGTH(v_QueueFilter) > 0) THEN
				v_QueryFilter := BTRIM(v_QueueFilter);
				v_QueryFilter := REPLACE(v_QueryFilter , v_macro, to_char(v_userIndex, ''99999''));
				v_QueryFilter :=  REPLACE(v_QueryFilter , v_macroUserName, v_userName);
				v_orderByPos := STRPOS(UPPER(v_QueryFilter), v_toSearchStr);
				IF(v_orderByPos <> 0) THEN
					v_tempOrderStr := SUBSTR(v_queryFilter, v_orderByPos + LENGTH(v_toSearchStr)); 
					v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
				END IF;
				v_QueryFilter := WFParseQueryFilter(v_QueryFilter, ''U'', v_userIndex);
				v_TempQueryFilter := v_QueryFilter;
				v_QueryStr := ''SELECT GroupId FROM QUserGroupView WHERE QueueId = '' || DBqueueId || '' AND UserId = '' || v_userIndex || '' AND GroupId IS NOT NULL''; 
				OPEN FilterCur FOR EXECUTE v_queryStr;
				FETCH FilterCur INTO v_GroupId;
				IF(FOUND) THEN
					v_DBStatus := 1;
				END IF;
				v_counterInt := 1; 
				WHILE(v_DBStatus <> 0) LOOP 
					v_QueryFilter := v_TempQueryFilter;
					v_QueryFilter := WFParseQueryFilter(v_QueryFilter, ''G'', v_groupId);
					IF(LENGTH(v_QueryFilter) > 0) THEN
						v_QueryFilter := ''('' || v_QueryFilter || '')'';
						IF(v_counterInt = 1) THEN
							v_tempFilter := v_QueryFilter;
						ELSE  
							v_tempFilter := v_tempFilter || '' OR '' || v_QueryFilter;
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
					v_QueryFilter := v_tempFilter;
				END IF;
				CLOSE FilterCur;
			END IF;
		END IF;
		
		IF((v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0) OR (LENGTH(v_orderByStr) > 0))THEN
/*			IF(v_Queuetype = ''N'' AND (v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0)) THEN
				v_queryStr := '' SELECT ProcessInstanceId FROM '' || '' WFWorklistView_'' || v_Q_QueueId || '' WHERE ProcessInstanceId = '' || quote_literal(v_ProcessInstanceId) || '' AND WorkItemId = '' || v_WorkitemId ||	'' AND ('' || v_QueryFilter || '')'';
				OPEN ProcessInstCur FOR EXECUTE v_queryStr;
				FETCH ProcessInstCur INTO v_Record;
				IF(FOUND) THEN
					v_canLock := ''Y'';
				ELSE
					v_canLock := ''N'';					
					v_CheckQueryWSFlag := ''Y'';
				END IF;*/
				/* Close and DeAllocate the CURSOR */ 
				/*CLOSE ProcessInstCur;
			ELSIF(DBQueueType = ''F'' OR v_Queuetype = ''F'') THEN
				v_QueueDataTableStr := '', QueueDataTable '';
				v_queryFilterStr := v_queryFilterStr || '' AND WorkListTable.ProcessInstanceId = QueueDataTable.ProcessInstanceId'';
				v_queryFilterStr := v_queryFilterStr || '' AND WorkListTable.WorkItemId = QueueDataTable.WorkItemId'';*/
				IF(v_QueryFilter IS NOT NULL AND LENGTH(BTRIM(v_QueryFilter)) > 0) THEN
					v_queryFilterStr := v_queryFilterStr || '' AND ('' || v_QueryFilter || '') '';
				END IF;
				RAISE NOTICE ''v_QueryFilter >> % '', v_QueryFilter;
			--END IF;
		END IF;
	END IF;
	v_DBStatus := 0;
	IF((LENGTH(v_ProcessInstanceId) > 0) OR ((LENGTH(v_ProcessInstanceId) = 0 OR v_ProcessInstanceId IS NULL) AND DBQueueType = ''F'')) THEN
	
		v_WLTColStr := '' QueueDataTable.ProcessInstanceId, QueueDataTable.ProcessInstanceId as ProcessInstanceName, ProcessInstanceTable.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, FilterValue, QueueDataTable.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, NotifyStatus, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, Q_StreamId, CollectFlag, QueueDataTable.ParentWorkItemId, ProcessedBy, LastProcessedBy,ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay '';
		
		v_WLTColStr1 := '' ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefId,  LastProcessedBy, ProcessedBy, ActivityName, ActivityId,  EntryDateTime,  ParentWorkItemId, AssignmentType,  CollectFlag, PriorityLevel, ValidTill,  Q_StreamId, Q_QueueID, Q_UserID,  AssignedUser, FilterValue, CreatedDateTime, WORKITEMSTATE,  Statename, ExpectedWorkItemDelay, PREVIOUSSTAGE,  LockedByName, LockStatus, LockedTime, QueueName, QueueType, NotifyStatus''; 
		
		v_QDTColStr := '', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8''; 
		
		IF (v_QueryFilter IS NOT NULL AND LENGTH(v_QueryFilter) > 0 ) THEN
			v_queryStr := ''SELECT '' || v_WLTColStr1 || '' FROM  (  SELECT * FROM (SELECT '' || v_WLTColStr || v_QDTColStr || v_AliasStr || '' FROM Worklisttable '';	
			
		v_queryStr := v_queryStr || '', ProcessInstanceTable, QueueDatatable WHERE '' || 
				'' QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId'' || 
				'' AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId'' || 
				'' AND Worklisttable.Workitemid =QueueDatatable.Workitemid'' || 
				'' ) aa'' || v_queryFilterStr || v_orderByStr || '') aa'' || 
				'' LIMIT 1 ''; 
		
				IF ((v_ProcessInstanceId IS NULL OR LENGTH(v_ProcessInstanceId) = 0) AND DBQueueType = ''F'') THEN		
						v_queryStr := v_queryStr || '' FOR UPDATE '';		
				END IF;	
		ELSE
			v_queryStr := ''Select ''|| v_WLTColStr1 || '' FROM WORKLISTTABLE '' || v_queryFilterStr || v_orderByStr || ''  LIMIT 1 '' ;			
		END IF;	
		IF ((v_ProcessInstanceId IS NULL OR LENGTH(v_ProcessInstanceId) = 0) AND DBQueueType = ''F'') THEN		
				v_queryStr := v_queryStr || '' FOR UPDATE '';		
		END IF;	

/*		v_queryStr := 
					'' SELECT WorkListTable.ProcessInstanceId, WorkListTable.WorkItemId, ProcessName, ProcessVersion, '' || 
					'' ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,'' || 
					'' ActivityId, EntryDateTime, WorkListTable.ParentWorkItemId, AssignmentType,'' ||
					'' CollectFlag, PriorityLevel, ValidTill, Q_StreamId,'' || 
					'' Q_QueueId, Q_UserId, AssignedUser, FilterValue,'' || 
					'' CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, '' || 
					'' PreviousStage, LockedByName, LockStatus, LockedTime, '' || 
					'' Queuename, Queuetype, NotifyStatus From WorkListTable '' ||
					   COALESCE(v_QueueDataTableStr, '' '') || COALESCE(v_queryFilterStr, '' '') || COALESCE(v_orderByStr, '' '') || '' LIMIT 1 '';	*/
					   
		OPEN WorkItem_Cur FOR EXECUTE v_queryStr;
		FETCH WorkItem_Cur INTO v_Record;
		IF(FOUND) THEN
			RAISE NOTICE ''FOUND'';
			v_DBStatus				:= 1;
			v_processInstanceId		:= v_Record.processInstanceId; 
			v_workItemId			:= v_Record.workItemId; 
			v_ProcessName			:= v_Record.ProcessName; 
			v_ProcessVersion		:= v_Record.ProcessVersion; 
			v_ProcessDefID			:= v_Record.ProcessDefID; 
			v_LastProcessedBy		:= v_Record.LastProcessedBy; 
			v_ProcessedBy			:= v_Record.ProcessedBy; 
			v_ActivityName			:= v_Record.ActivityName; 
			v_ActivityId			:= v_Record.ActivityId; 
			v_EntryDateTime			:= v_Record.EntryDateTime; 
			v_ParentWorkItemId		:= v_Record.ParentWorkItemId; 
			v_AssignmentType		:= v_Record.AssignmentType; 
			v_CollectFlag			:= v_Record.CollectFlag; 
			v_PriorityLevel			:= v_Record.PriorityLevel; 
			v_ValidTill				:= v_Record.ValidTill; 
			v_Q_StreamId			:= v_Record.Q_StreamId; 
			v_Q_QueueId				:= v_Record.Q_QueueId; 
			v_Q_UserId				:= v_Record.Q_UserId; 
			v_AssignedUser			:= v_Record.AssignedUser; 
			v_FilterValue			:= v_Record.FilterValue; 
			v_CreatedDateTime		:= v_Record.CreatedDateTime; 
			v_WorkItemState			:= v_Record.WorkItemState; 
			v_Statename				:= v_Record.StateName; 
			v_ExpectedWorkitemDelay := v_Record.ExpectedWorkitemDelay;
			v_PreviousStage			:= v_Record.PreviousStage; 
			v_LockedByName			:= v_Record.LockedByName; 
			v_LockStatus			:= v_Record.LockStatus; 
			v_LockedTime			:= v_Record.LockedTime; 
			v_Queuename				:= v_Record.QueueName; 
			v_Queuetype				:= v_Record.QueueType; 
			v_NotifyStatus			:= v_Record.NotifyStatus;
		END IF;
		IF(v_DBStatus <> 0) THEN
			v_found	:= ''Y'';
			IF(v_CheckQueryWSFlag = ''N'') THEN
				v_canLock := ''Y'';
			END IF;
		END IF;
		IF(NOT FOUND) THEN
			IF (v_bInQueue = ''Y'' AND v_tableName = ''WorkListTable'') THEN
				v_CheckQueryWSFlag := ''Y'';
				v_canLock := ''N'';
			END IF;
		END IF;
		CLOSE WorkItem_Cur;
	END IF;

	IF(v_found = ''Y'') THEN
		IF(v_canLock= ''Y'' AND (v_AssignmentType IS NULL OR LENGTH(v_AssignmentType) = 0 
				OR 
			NOT (v_AssignmentType = ''F'' OR v_AssignmentType = ''E'' OR v_AssignmentType = ''A''))) THEN
			IF(DBQueueId >= 0 AND DBQueueId != v_Q_QueueId) THEN
				v_mainCode := 810; /* Workitem not in the queue specified. */
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
				RETURN ResultSet;
			END IF;
		ELSE
			IF(v_userIndex = v_Q_UserId) THEN
				v_canLock := ''Y'';
			ELSE 
				v_canLock := ''N'';
			END IF;
		END IF;

		IF(v_canLock = ''Y'') THEN
			IF(v_AssignmentType IS NULL) THEN
				v_AssignmentType := ''S'';
			END IF;
			v_Q_UserId := v_userIndex;
			v_AssignedUser	:= v_userName;
			v_WorkItemState	:= 2;
			v_StateName := ''RUNNING'';
			v_LockedByName	:= v_userName;
			v_LockStatus := ''Y'';
			v_LockedTime := CURRENT_TIMESTAMP;
			
			IF(DBQueueType = ''F'' AND DBAssignMe = ''Y'') THEN
				v_AssignmentType := ''F'';
				v_AssignQ_QueueId := 0;
				v_AssignQueueType := ''U'';
				v_AssignQueueName := @v_userName + ''''''s MyQueue'';
				
				INSERT INTO WORKINPROCESSTABLE 
				SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
					ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
					ActivityId, EntryDateTime, ParentWorkItemId, v_AssignmentType,
					CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
					v_AssignQ_QueueId, v_Q_Userid, v_AssignedUser, NULL,
					CreatedDateTime, v_WorkItemState, v_StateName, ExpectedWorkitemDelay,
					PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,
					v_AssignQueueName, v_AssignQueueType, NotifyStatus, NULL
				FROM	WORKLISTTABLE
				WHERE	ProcessInstanceID = v_ProcessInstanceId
				AND		WorkItemID = v_WorkitemId;	
			ELSE
				INSERT INTO WORKINPROCESSTABLE 
					SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
					ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
					ActivityId, EntryDateTime, ParentWorkItemId, v_AssignmentType,
					CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
					Q_QueueId, v_Q_Userid, v_AssignedUser, FilterValue,
					CreatedDateTime, v_WorkItemState, v_StateName, ExpectedWorkitemDelay,
					PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,
					Queuename, Queuetype, NotifyStatus, NULL
				FROM	WORKLISTTABLE
				WHERE	ProcessInstanceID = v_ProcessInstanceId
				AND		WorkItemID = v_WorkitemId;
			END IF;

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;

			IF(v_rowCount > 0) THEN 
				DELETE	FROM WORKLISTTABLE
				WHERE	ProcessInstanceID = v_ProcessInstanceId
				AND	WorkItemID = v_WorkitemId;
	
				v_lockFlag := ''Y'';
			ELSE
				v_mainCode := 16;		/* WorkItem might be locked by some other user while this user is trying to lock */
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
				RETURN ResultSet;
			END IF;

			IF(v_lockFlag = ''Y'' AND DBGenerateLog = ''Y'') THEN
				/* Logging for Locking workitem */
				INSERT INTO WFMESSAGETABLE(message, status, ActionDateTime) /*WFS_5_136 */
				VALUES	(''<Message><ActionId>7</ActionId><UserId>'' || v_userIndex || 
						''</UserId><ProcessDefId>'' || v_ProcessDefId || 
						''</ProcessDefId><ActivityId>'' || v_ActivityId || 
						''</ActivityId><QueueId>0</QueueId><UserName>'' || v_userName ||
						''</UserName><ActivityName>'' || v_ActivityName || 
						''</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'' ||
						TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || ''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' || 
						v_ProcessInstanceId || ''</ProcessInstance><FieldId>'' || v_Q_QueueId || 
						''</FieldId><FieldName>'' || v_Queuename || ''</FieldName><WorkitemId>'' || v_WorkitemId || 
						''</WorkitemId><TotalPrTime>0</TotalPrTime>'' ||
						''<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>'', 
					''N'', CURRENT_TIMESTAMP);
				
				/* Logging for work started */
				INSERT INTO WFMESSAGETABLE(message, status, ActionDateTime)
				VALUES	(''<Message><ActionId>200</ActionId><UserId>'' || v_userIndex || 
						''</UserId><ProcessDefId>'' || v_ProcessDefId ||
						''</ProcessDefId><ActivityId>'' || v_ActivityId || ''</ActivityId><QueueId>'' ||
						v_Q_QueueId ||	''</QueueId><UserName>'' || v_userName ||
						''</UserName><ActivityName>'' || v_ActivityName || 
						''</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'' ||
						TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || ''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' ||
						v_ProcessInstanceId || ''</ProcessInstance><FieldId></FieldId><WorkitemId>'' || 
						v_WorkitemId || ''</WorkitemId><TotalPrTime>0</TotalPrTime>'' ||
						''<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>'', 
					''N'', CURRENT_TIMESTAMP);
			END IF;
		ELSE
			v_CheckQueryWSFlag := ''Y'';
			v_mainCode := 300;	/* no authorization */
		END IF;
--	ELSIF (v_bInQueue = ''Y'' OR v_canLock = ''N'') THEN 
	ELSIF (v_CheckQueryWSFlag = ''N'') THEN 
		IF(v_ProcessInstanceId IS NOT NULL AND LENGTH(v_ProcessInstanceId) > 0) THEN
--			v_ProcessInstanceId	:= DBProcessInstanceId;			
--			v_WorkitemId		:= DBWorkitemId;
			SELECT	INTO
				/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus

				/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus 
			FROM	WORKINPROCESSTABLE 
			WHERE	ProcessInstanceID = v_ProcessInstanceId 
			AND	WorkItemID = v_WorkitemId;

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		ELSE	/* For FIFO when workitem not in WorkListTable and some workitem is locked in WorkInProcessTable */
--			v_ProcessInstanceId	:= DBProcessInstanceId;			
--			v_WorkitemId		:= DBWorkitemId;
			SELECT	INTO
				/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
			
				/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus 
			FROM	WORKINPROCESSTABLE 
			WHERE	Q_QueueId = DBQueueId 
			AND		LockedByName = v_userName
			AND	NOT (processInstanceId = DBLastProcessInstanceId AND workitemId	= DBLastWorkitemId)
			LIMIT 1;

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		END IF;
		IF(v_rowCount > 0) THEN
			IF(NOT(v_LockedByName = v_userName)) THEN
				v_mainCode := 16;		/* Workitem locked, when workitem locked by some other user */
				v_CheckQueryWSFlag :=''N'';
			ELSE
				IF(DBQueueType = ''F'' AND DBAssignMe = ''Y'' AND NOT(v_AssignmentType = ''F'')) THEN
					v_AssignQueueName := v_userName + ''''''s MyQueue'';
					Update WorkInProcessTable Set AssignmentType = ''F'', QueueType = ''U'', Q_QueueId = 0, QueueName = v_AssignQueueName, FilterValue = NULL  
					WHERE	Q_QueueId = DBQueueId 
					AND		LockedByName = v_userName
					AND	processInstanceId = v_ProcessInstanceId AND workitemId	= v_WorkitemId;					
				END IF;	
			END IF;
		ELSE
--			v_ProcessInstanceId	:= DBProcessInstanceId;
--			v_WorkitemId		:= DBWorkitemId;
			IF(v_rowCount < 1) THEN
				IF(v_ProcessInstanceId IS NOT NULL AND LENGTH(v_ProcessInstanceId) > 0) THEN
					v_CheckQueryWSFlag := ''Y'';
					v_mainCode := 300;		/* NO Authorization */
					SELECT INTO
						/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
						v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
						v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
						v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
						v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, 
						v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, 
						v_LockedByName, v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, 
						v_NotifyStatus, v_tableNameReturn 
						
						/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
						LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
						ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
						Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, NULL, CreatedDateTime,
						WorkItemState, Statename, NULL, PreviousStage, LockedByName, 
						LockStatus, LockedTime, Queuename, Queuetype, NULL, ''QueueHistoryTable''
					FROM	QUEUEHISTORYTABLE 
					WHERE	ProcessInstanceID = v_ProcessInstanceId
					AND	WorkItemID = v_WorkitemId;

					GET DIAGNOSTICS v_rowCount = ROW_COUNT;

					IF(v_rowCount < 1) THEN
--						v_ProcessInstanceId	:= DBProcessInstanceId;
--						v_WorkitemId		:= DBWorkitemId;
						SELECT INTO
							/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
							v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
							v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
							v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
						
							/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
							LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
							ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
							Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
							WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
							LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus 
						FROM PENDINGWORKLISTTABLE
						WHERE ProcessInstanceID = v_ProcessInstanceId
						AND	WorkItemID = v_WorkitemId;

						GET DIAGNOSTICS v_rowCount = ROW_COUNT;
						
						IF(v_rowcount > 0) THEN
							IF(v_Q_UserId = v_userIndex) THEN
								v_CheckQueryWSFlag := ''N'';
								v_mainCode := 16;		/* Open WorkItem in Read only mode */
							END IF;
						ELSE
--							v_ProcessInstanceId	:= DBProcessInstanceId;
--							v_WorkitemId		:= DBWorkitemId;
							SELECT INTO
								/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
								v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
								v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
								v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
								v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
								v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
								v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
							
								/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
								LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
								ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
								Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
								WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
								LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus 
							FROM	WORKDONETABLE 
							WHERE	ProcessInstanceID = v_ProcessInstanceId 
							AND	WorkItemID = v_WorkitemId;

							GET DIAGNOSTICS v_rowCount = ROW_COUNT;

							IF(v_rowCount < 1) THEN
--								v_ProcessInstanceId	:= DBProcessInstanceId;
--								v_WorkitemId		:= DBWorkitemId;
								SELECT INTO
									/*v_ProcessInstanceId, v_WorkItemId,*/ v_ProcessName, v_ProcessVersion, 
									v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName, 
									v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType, 
									v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId, 
									v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState, 
									v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName, 
									v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
								
									/*ProcessInstanceId, WorkItemId,*/ ProcessName, ProcessVersion, ProcessDefID,
									LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
									ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, 
									Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
									WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, 
									LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus 
								FROM	WORKWITHPSTABLE 
								WHERE	ProcessInstanceID = v_ProcessInstanceId 
								AND	WorkItemID = v_WorkitemId;

								GET DIAGNOSTICS v_rowCount = ROW_COUNT;
								IF(v_rowCount < 1) THEN
									v_mainCode := 22; /* Bugzilla Bug 7199, MainCode changed to Invalid_Workitem. */
									OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
									RETURN ResultSet;
								END IF;
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
	IF(v_CheckQueryWSFlag = ''Y'' ) THEN	/* Query WorkStep Handling */
		/* 21/01/2008, Bugzilla Bug 1721, error code 810 - Ruhi Hira */
		IF(DBQueueId >= 0 AND ( (v_Q_QueueId IS NULL) OR (DBQueueId != v_Q_QueueId) ) ) THEN
			v_mainCode := 810; /* Workitem not in the queue specified. */
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
			RETURN ResultSet;
		END IF;
		SELECT INTO v_QueryActivityId, v_QueryPreview ActivityId, QueryPreview FROM (
			SELECT ACTIVITYTABLE.ActivityId , QUSERGROUPVIEW.QueryPreview 
			FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUSERGROUPVIEW
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
			v_mainCode := 300; /*No Authorization*/
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_lockFlag AS lockFlag;
			RETURN ResultSet;
		ELSE
			v_mainCode := 16; /*To be shown in Read only mode*/
			IF(v_QueryPreview = ''Y'' OR v_QueryPreview IS NULL) THEN
				v_ActivityId := v_QueryActivityId;
			END IF;	
		END IF;
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
		v_tableNameReturn		AS TableName,
		v_userName				AS UserName;
		RAISE NOTICE ''v_mainCode >> %'', v_mainCode;
	RETURN ResultSet;
END;
'
LANGUAGE 'plpgsql';