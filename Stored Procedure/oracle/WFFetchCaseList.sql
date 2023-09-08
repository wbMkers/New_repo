/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS 
	Module				: Transaction Server
	File Name			: WFFetchCaseList.sql (Oracle)
	Author				: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 29/10/2015
	Description			: Stored procedure to fetch my Cases.
						  My cases for User A will include :
							    1. Cases that are owned by Case Manager A 
   								2. Cases in which task are assigned to Case Worker A or Case Participant A
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
06/11/2015	Mohnish Chopra		Changes for Case management -Can Initiate requirement 
30/11/2015	Mohnish Chopra		Bug 57931 - Jboss EAP : Error message while changing priority of WI
								Sending LastModifiedTime in WFFetchCaseWorkItems
02/12/2015	Mohnish Chopra		Bug 58014 - show case visualization check box during assigning a task is not working according to specification
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
14/09/2017	Mohnish Chopra		Changes for Searching ,sorting and filtering in FetchCaseList
24/10/2017	AMbuj Tripathi		Case registration changes for Adding URN in the output of WFFetchCaseWorkItems API
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
____________________________________________________________________________________________________*/
create or replace
PROCEDURE WFFetchCaseList ( 
	DBsessionId			INT, 
	in_sortOrder			NVARCHAR2, 
	in_orderBy			INT, 
	in_batchSize			INT, 
	in_lastWorkItem			INT, 
	temp_in_lastProcessInstance		NVARCHAR2, 
	temp_in_lastValue			NVARCHAR2, 
	in_caseManager			NVARCHAR2, 
	temp_in_searchFilter			NVARCHAR2, 
	in_returnParam                  INT, /*0 -> only list, if 1 -> only count, if 2 -> both count and list*/
	out_mainCode			OUT	INT, 
	out_subCode			OUT	INT, 
	out_returnCount                 OUT     INT, /* returns number of workitems in a queue*/
	RefCursor			OUT ORACONSTPKG.DBLIST) 
AS 
	v_DBStatus		INT; 
	v_rowCount		INT; 	
	v_filterStr		NVARCHAR2(100); 
	v_filterOption		INT; 
	v_QueryStr1		VARCHAR2(16000); 
	v_groupByClause VARCHAR2(16000); 
	v_CountStr              VARCHAR2(8000);
    v_tempCount             INT;
	v_UserId		INT; 
	v_UserName		NVARCHAR2(63); 
	v_innerOrderBy		NVARCHAR2(200); 
	v_counter		INT; 
	v_noOfCounters		INT;
	v_counterCondition	INT; 
	v_CursorAlias		INT;
	v_OrderByStr		NVARCHAR2(100); 
	v_sortStr		NVARCHAR2(6); 
	v_op			CHAR(1); 
	v_sortFieldStr		NVARCHAR2(50); 
	v_quoteChar 		CHAR(1); 
	v_DATEFMT 		NVARCHAR2(21); 
	v_tempDataType		NVARCHAR2(50); 
	v_TempColumnName	NVARCHAR2(64); 
	v_TempColumnVal		NVARCHAR2(64); 
	v_lastValueStr		NVARCHAR2(1000); 
	v_reverseOrder		INT; 
	v_Suffix		NVARCHAR2(50);
	in_lastProcessInstance		NVARCHAR2(128); 
	in_lastValue			NVARCHAR2(8000);
	in_searchFilter			NVARCHAR2(8000);
BEGIN 
	out_mainCode := 0; 
	out_subCode := 0;
	out_returnCount := 0;
	v_orderByStr := '';
	v_quoteChar := CHR(39);  


	/* Check for validity of session ... */ 
	BEGIN 
		SELECT UserID, UserName INTO v_UserId , v_UserName  
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = DBsessionId; 
		v_rowcount := SQL%ROWCOUNT;  
		v_DBStatus := SQLCODE;
		v_UserName:=REPLACE(v_UserName,v_quoteChar,v_quoteChar||v_quoteChar);
	EXCEPTION  
		WHEN NO_DATA_FOUND THEN 
		v_rowcount := 0; 		
	END; 

	IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN 
		out_mainCode := 11; 
		out_subCode := 0; 
		RETURN; 
	END IF;
	if(temp_in_searchFilter is NOT NULL) THEN
	--	in_searchFilter:=REPLACE(temp_in_searchFilter,v_quoteChar,v_quoteChar||v_quoteChar);
	--	in_searchFilter:=REPLACE(in_searchFilter,v_quoteChar||v_quoteChar,v_quoteChar);
		SELECT sys.DBMS_ASSERT.noop(temp_in_searchFilter) into in_searchFilter FROM dual;
	END IF;
	if(temp_in_lastValue is NOT NULL) THEN
	--	in_lastValue:=REPLACE(temp_in_lastValue,v_quoteChar,v_quoteChar||v_quoteChar);	
		SELECT sys.DBMS_ASSERT.noop(temp_in_lastValue) into in_lastValue FROM dual;
	END IF;
	
	v_DATEFMT := 'YYYY-MM-DD HH24:MI:SS'; 

	/* Define sortOrder */ 
	IF(in_sortOrder = 'D') THEN 
		v_reverseOrder := 1; 
		v_sortStr := ' DESC '; 
		v_op := '<'; 
	ELSE /* IF(in_sortOrder = 'A') */ 
		v_reverseOrder := 0; 
		v_sortStr := ' ASC '; 
		v_op := '>'; 
	END IF; 

	IF (v_innerOrderBy IS NULL) THEN 
		IF(in_orderBy = 1) THEN 
		BEGIN 
			v_lastValueStr := in_lastValue; 
			v_sortFieldStr := ' PriorityLevel '; 
		END; 
		ELSIF(in_orderBy = 2) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' ProcessInstanceId '; 
		END; 
		ELSIF(in_orderBy = 3) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' ActivityName '; 
		END; 
		ELSIF(in_orderBy = 4) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' LockedByName '; 
		END; 
		ELSIF(in_orderBy = 5) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' IntroducedBy '; 
		END; 
		ELSIF(in_orderBy = 6) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF;	 
			v_sortFieldStr := ' InstrumentStatus '; 
		END; 
		ELSIF(in_orderBy = 7) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' CheckListCompleteFlag '; 
		END; 
		ELSIF(in_orderBy = 8) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' LockStatus '; 
		END; 
		ELSIF(in_orderBy = 9) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := in_lastValue; 
			END IF; 
			v_sortFieldStr := ' WorkItemState '; 
		END; 
		ELSIF(in_orderBy = 10) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' EntryDateTime '; 
		END; 
		ELSIF(in_orderBy = 11) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' ValidTill '; 
		END; 
		ELSIF(in_orderBy = 12) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' LockedTime '; 
		END; 
		ELSIF(in_orderBy = 13) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF;	 
			v_sortFieldStr := ' IntroductionDateTime '; 
		END; 		
		ELSIF(in_orderBy = 16) THEN  
		BEGIN  
			IF(LENGTH(in_lastValue) > 0) THEN  
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar;  
			END IF;  
			v_sortFieldStr := ' AssignedUser ';  
		END; 		
		ELSIF(in_orderBy = 17) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' Status '; 
		END; 
		ELSIF(in_orderBy = 18) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' CreatedDateTime '; 
		ELSIF(in_orderBy = 19) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' ExpectedWorkItemDelay '; 
		ELSIF(in_orderBy = 20) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar ; 
			END IF; 
			v_sortFieldStr := ' ProcessedBy '; 
		ELSIF(in_orderBy > 100) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				IF (v_tempDataType = 'DATE') THEN 
					v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				ELSE 
					v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
				END IF; 
			END IF; 

		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			out_mainCode := 400; 
			out_subCode := 802; 
			RETURN; 
		END; 
		END IF; 
		IF(temp_in_lastProcessInstance IS NOT NULL) THEN 
		SELECT sys.DBMS_ASSERT.noop(temp_in_lastProcessInstance) into in_lastProcessInstance FROM dual;
		--in_lastProcessInstance:=REPLACE(temp_in_lastProcessInstance,v_quoteChar,v_quoteChar||v_quoteChar);
		BEGIN 
			v_TempColumnVal := v_lastValueStr; 

			IF(in_lastValue IS NOT NULL) THEN 
				v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ' ; 
				v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
			ELSE 
				v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
			END IF; 

			v_lastValueStr := v_lastValueStr || ' AND (  '; 
			v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
			v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
			v_lastValueStr := v_lastValueStr || ' ) '; 

			IF(in_lastValue IS NOT NULL) THEN 
				IF (in_sortOrder = 'A') THEN 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NULL )' ; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') ' ; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			ELSE 
				IF (in_sortOrder = 'D') THEN 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )'; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') ' ; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			END IF; 
		END; 
		END IF; 

		IF (in_orderBy = 2) THEN 
			v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
		ELSE 
			v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr || ', ProcessInstanceID ' || v_sortStr 
					|| ', WorkItemID ' || v_sortStr; 
		END IF; 

	END IF;	

	v_Suffix := ' where ROWNUM <= ' || (in_batchSize + 1); 

	IF(in_caseManager='A')THEN
	
	v_queryStr1 := ' SELECT  ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14,a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18,a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,N''Y'' as CanInitiate,''Y'' as CaseManager,N''Y'' as ShowCaseVisual FROM  WFInstrumentTable a WHERE  1 = 1 and (Q_UserID = '|| v_UserId||' or Q_DivertedByUserId ='|| v_UserId||') and ActivityType =32  union SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14,a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18,a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N'' as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||v_UserName || v_quoteChar || ' and b.taskstatus=2 and ActivityType =32 ) where 1=1 '||in_searchFilter||v_lastValueStr ;
	v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
	
	
	v_queryStr1:=v_queryStr1 || v_groupByClause;
	
	v_queryStr1 := v_queryStr1 || v_orderByStr;
	
	v_queryStr1:='Select * from ('||v_queryStr1||')'||v_Suffix;
	ELSIF(in_caseManager= 'Y') THEN

	v_queryStr1 := ' SELECT  ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14,a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18,a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,N''Y'' as CanInitiate,''Y'' as CaseManager,N''Y'' as ShowCaseVisual FROM  WFInstrumentTable a WHERE  1 = 1 and (Q_UserID = '|| v_UserId||' or Q_DivertedByUserId ='|| v_UserId||') and ActivityType =32 ) where 1=1 '||in_searchFilter||v_lastValueStr ;
	v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
	
	
	v_queryStr1:=v_queryStr1 || v_groupByClause;
	
	v_queryStr1 := v_queryStr1 || v_orderByStr;
	
	v_queryStr1:='Select * from ('||v_queryStr1||')'||v_Suffix;

	ELSIF(in_caseManager= 'N') THEN
	v_queryStr1 := ' SELECT  ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual from ( SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14,a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18,a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N'' as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||v_UserName || v_quoteChar || ' and b.taskstatus=2 and ActivityType =32 and a.processinstanceid in  (SELECT  a.ProcessInstanceId FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||v_UserName || v_quoteChar || ' and b.taskstatus =2 and ActivityType =32
		Minus Select a.ProcessInstanceId FROM  WFInstrumentTable a WHERE 1 = 1 AND Q_UserID = '||v_UserId|| ' and ActivityType =32)) where 1=1 '||in_searchFilter||v_lastValueStr ;
	v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
	
	
	v_queryStr1:=v_queryStr1 || v_groupByClause;
	
	v_queryStr1 := v_queryStr1 || v_orderByStr;
	
	v_queryStr1:='Select * from ('||v_queryStr1||')'||v_Suffix;
	
	END IF;
	IF (in_returnParam > 0) THEN 
		v_Counter := 0;
		v_noOfCounters:=1;
				v_CountStr := 'SELECT COUNT(*) FROM (' ||v_QueryStr1 || ' )'; 
		
			EXECUTE IMMEDIATE v_CountStr INTO v_tempCount;
			out_returnCount := out_returnCount + v_tempCount;
	END IF;

	IF (in_returnParam = 0 OR  in_returnParam = 2) THEN 
		OPEN RefCursor FOR v_queryStr1; 
	END IF;
	
	RETURN; 
END; 

