/*____________________________________________________________________________________________
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
    Group                				: Genesis.
    Product / Project    				: iBPS 
    Module               				: WorkFlow Server
    File Name            				: WFFetchCaseList.sql [Postgres]
    Author               				: Mohnish Chopra
    Date written (DD/MM/YYYY)   : 05-05-2016
    Description            			: Stored procedure for fetching Case list
______________________________________________________________________________________________
                CHANGE HISTORY
______________________________________________________________________________________________
Date            Change By        Change Description (Bug No. (If Any))
______________________________________________________________________________________________
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
14/09/2017	Mohnish Chopra		Changes for Searching ,sorting and filtering in FetchCaseList
24/10/2017	AMbuj Tripathi		Case registration changes for Adding URN in the output of WFFetchCaseWorkItems API
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
______________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFFetchCaseList ( 
    DBsessionId                INTEGER, 
    in_sortOrder            VARCHAR, 
    in_orderBy                INTEGER, 
    in_batchSize            INTEGER, 
    in_lastWorkItem            INTEGER, 
    in_lastProcessInstance    VARCHAR, 
    in_lastValue            VARCHAR, 
	in_caseManager			VARCHAR, 
	in_searchFilter			VARCHAR, 
    in_returnParam          INTEGER /*0 -> only list, if 1 -> only count, if 2 -> both count and list*/
) RETURNS SETOF REFCURSOR AS $$

DECLARE    
    v_DBStatus            INTEGER; 
    v_rowCount            INTEGER;     
    v_filterStr            VARCHAR(100); 
    v_filterOption        INTEGER; 
	v_QueryStr1		VARCHAR(16000); 
    v_groupByClause VARCHAR(16000); 
    v_CountStr          VARCHAR(8000);
    v_tempCount         INTEGER;
    v_UserId            INTEGER; 
    v_UserName            VARCHAR(63); 
	v_counter            INTEGER; 
    v_counter1            INTEGER; 
    v_noOfCounters        INTEGER; 
    v_counterCondition    INTEGER; 
	v_CursorAlias		INT;
    v_OrderByStr        VARCHAR(100); 
    v_sortStr            VARCHAR(6); 
    v_op                CHAR(1); 
    v_sortFieldStr        VARCHAR(50); 
    v_quoteChar         CHAR(1); 
    v_DATEFMT             VARCHAR(21); 
    v_tempDataType        VARCHAR(50); 
    v_TempColumnName    VARCHAR(64); 
    v_TempColumnVal        VARCHAR(64); 
	v_lastValueStr        VARCHAR(1000); 
	v_reverseOrder        INTEGER; 
	v_Suffix            VARCHAR(50);
	ResultSet0                        REFCURSOR;
	ResultSet                        REFCURSOR;
    out_mainCode                    INTEGER;
    out_subCode                        INTEGER;
    out_returnCount                 INTEGER;
    out_AliasProcessDefId            INTEGER;
	v_innerOrderBy		VARCHAR(200); 
BEGIN 
    out_mainCode := 0; 
    out_subCode := 0;
    out_returnCount := 0;
    v_orderByStr := '';

    /* Check for validity of session ... */ 
    
    SELECT UserID, UserName INTO v_UserId , v_UserName  
    FROM WFSessionView, WFUserView 
    WHERE UserId = UserIndex AND SessionID = DBsessionId; 
    
    IF (NOT FOUND) THEN
        v_DBStatus := 11; 
        OPEN ResultSet0 FOR SELECT v_DBStatus AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
        v_rowcount := 0;
        RETURN NEXT ResultSet0;
        RETURN;
    ELSE
        GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    END IF;        
    

    IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN 
        out_mainCode := 11; 
        out_subCode := 0; 
        OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
        RETURN NEXT ResultSet0;
            RETURN;
    END IF;

    v_quoteChar := CHR(39);  
    v_DATEFMT := 'YYYY-MM-DD HH24:MI:SS'; 

    /* Define sortOrder */ 
    IF (in_sortOrder = 'D') THEN 
        v_reverseOrder := 1; 
        v_sortStr := ' DESC '; 
        v_op := '<'; 
    ELSE /* IF (in_sortOrder = 'A') */ 
        v_reverseOrder := 0; 
        v_sortStr := ' ASC '; 
        v_op := '>'; 
    END IF; 
	v_lastValueStr := COALESCE(v_lastValueStr,'');
    IF (v_innerOrderBy IS NULL) THEN 
        IF (in_orderBy = 1) THEN 
            v_lastValueStr := in_lastValue; 
            v_sortFieldStr := ' PriorityLevel '; 
        ELSIF (in_orderBy = 2) THEN 
            Begin
                IF (LENGTH(in_lastValue) > 0) THEN 
                    v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
                END IF; 
                v_sortFieldStr := ' ProcessInstanceId '; 
            End;
        ELSIF (in_orderBy = 3) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' ActivityName '; 
            End;
        ELSIF (in_orderBy = 4) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' LockedByName '; 
            End;
        ELSIF (in_orderBy = 5) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' IntroducedBy '; 
            End;
        ELSIF (in_orderBy = 6) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF;     
            v_sortFieldStr := ' InstrumentStatus '; 
            End;
        ELSIF (in_orderBy = 7) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' CheckListCompleteFlag '; 
            End;
        ELSIF (in_orderBy = 8) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' LockStatus '; 
            End;
        ELSIF (in_orderBy = 9) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := in_lastValue; 
            END IF; 
            v_sortFieldStr := ' WorkItemState '; 
            End;
        ELSIF (in_orderBy = 10) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' EntryDateTime '; 
            End;
        ELSIF (in_orderBy = 11) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' ValidTill '; 
            End;
        ELSIF (in_orderBy = 12) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			 	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' LockedTime '; 
            End;
        ELSIF (in_orderBy = 13) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			   	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF;     
            v_sortFieldStr := ' IntroductionDateTime '; 
            End;
		ELSIF(in_orderBy = 16) THEN  
		BEGIN  
			IF(LENGTH(in_lastValue) > 0) THEN  
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar;  
			END IF;  
			v_sortFieldStr := ' AssignedUser ';  
		END; 		
        ELSIF (in_orderBy = 17) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' Status '; 
            End;
        ELSIF (in_orderBy = 18) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			     	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' CreatedDateTime '; 
            End;
        ELSIF (in_orderBy = 19) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			     	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' ExpectedWorkItemDelay '; 
            End;
        ELSIF (in_orderBy = 20) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar ; 
            END IF; 
            v_sortFieldStr := ' ProcessedBy '; 
            End;
        ELSIF (in_orderBy > 100) THEN 
            Begin
                IF (LENGTH(in_lastValue) > 0) THEN 
                        IF (v_tempDataType = 'TIMESTAMP') THEN 
                            Begin
                                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								  v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19)  || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
                            End;
                        ELSE 
                            v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
                        END IF; 
                END IF; 
				IF (NOT FOUND) THEN 
					out_mainCode := 400; 
					out_subCode := 802; 
					OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
					RETURN NEXT ResultSet0;
					RETURN;
				END IF;
            End;
        END IF;
       
        IF (in_lastProcessInstance IS NOT NULL AND in_lastProcessInstance <> '') THEN 
            v_TempColumnVal := v_lastValueStr; 

            IF (in_lastValue IS NOT NULL AND in_lastValue <> '') THEN 
				--RAISE NOTICE 'lin @@266>>>in_lastValue is not blank(%)',in_lastValue;
                v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ' ; 
                v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
            ELSE 
				--RAISE NOTICE 'lin @@271>>>in_lastValue is blank(%)',in_lastValue;
                v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
            END IF; 

            v_lastValueStr := v_lastValueStr || ' AND (  '; 
            v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
            v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
            v_lastValueStr := v_lastValueStr || ' ) '; 

            IF (in_lastValue IS NOT NULL AND in_lastValue <>'') THEN 
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
        END IF; 

        IF (in_orderBy = 2) THEN 
            v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
        ELSE 
            v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr || ', ProcessInstanceID ' || v_sortStr 
                    || ', WorkItemID ' || v_sortStr; 
        END IF; 
	END IF; 

    --DELETE FROM GTempWorkListTable; 
    --In Postgres Temporary tables need to be created in every transaction and on commit data is delteed .
   v_Suffix := 'LIMIT ' || (in_batchSize + 1); 
	IF(in_caseManager = 'A') THEN
	BEGIN
		v_queryStr1 := ' SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,a.ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,URN,
		max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,N''Y''::text as CanInitiate,''Y''::text as CaseManager,N''Y''::text as ShowCaseVisual FROM  WFInstrumentTable a WHERE  1 = 1 and (Q_UserID = '|| v_UserId||' or Q_DivertedByUserId ='|| v_UserId||') and ActivityType =32  union SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N'' as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||COALESCE(v_UserName,'') || v_quoteChar || ' and b.taskstatus=2 and ActivityType =32 )a where 1=1 '|| COALESCE(in_searchFilter,'')||COALESCE(v_lastValueStr,'') ;
	  
		v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5,VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16,VAR_STR17,VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
		
	END;
	ELSIF(in_caseManager = 'Y') THEN
	BEGIN
		v_queryStr1 := ' SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,a.ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,URN,
		max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,N''Y''::text as CanInitiate,''Y''::text as CaseManager,N''Y''::text as ShowCaseVisual FROM  WFInstrumentTable a WHERE  1 = 1 and (Q_UserID = '|| v_UserId||' or Q_DivertedByUserId ='|| v_UserId||') and ActivityType =32 )a where 1=1 '|| COALESCE(in_searchFilter,'')||COALESCE(v_lastValueStr,'') ;
	  
		v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5,VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16,VAR_STR17,VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
			
	END;
	ELSIF(in_caseManager = 'N') THEN
	BEGIN
		v_queryStr1:= ' SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName	, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,a.ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,
		max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager,max(ShowCaseVisual) AS ShowCaseVisual 
		from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4,a.VAR_LONG5,a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16,a.VAR_STR17,a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N''::text as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||COALESCE(v_UserName,'') || v_quoteChar || ' and b.taskstatus=2 and ActivityType=32 and a.processinstanceid in (SELECT  a.ProcessInstanceId FROM  WFInstrumentTable a inner join WFTaskStatusTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '|| v_quoteChar  ||v_UserName || v_quoteChar || ' and b.taskstatus =2 and ActivityType =32
		Except Select a.ProcessInstanceId FROM  WFInstrumentTable a WHERE 1 = 1 AND Q_UserID = '||v_UserId|| ' and ActivityType =32)	 )a where 1=1 '|| COALESCE(in_searchFilter,'')||COALESCE(v_lastValueStr,'') ;
	  
		v_groupByClause:= 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5,VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16,VAR_STR17,VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
		
	END;
	END IF;	
	v_queryStr1:=v_queryStr1 || v_groupByClause;
	
	v_queryStr1 := v_queryStr1 || v_orderByStr;
	
	v_queryStr1:='Select * from ('||v_queryStr1||') alias '||COALESCE(v_Suffix,'');

	/*RAISE NOTICE 'lin @@308>>>v_UserName(%)',v_UserName;
	   RAISE NOTICE 'lin @@309>>>v_lastValueStr(%)',v_lastValueStr;
	   RAISE NOTICE 'lin @@310>>>v_orderByStr(%)',v_orderByStr;
	   RAISE NOTICE 'lin @@311>>>v_groupByClause(%)',v_groupByClause;
	   RAISE NOTICE 'lin @@312>>>v_queryStr1(%)',v_queryStr1; */
		   
    IF (in_returnParam > 0) THEN 
        v_Counter := 0;
	v_noOfCounters:=1;
	v_CountStr := 'SELECT COUNT(*) FROM (' ||v_QueryStr1 || ' )'; 
    EXECUTE  v_CountStr INTO v_tempCount;
      out_returnCount := out_returnCount + v_tempCount;
	END IF;

    OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId; 
    
    RETURN NEXT  ResultSet0; 
    IF ((in_returnParam = 0) OR  (in_returnParam = 2)) THEN 
		OPEN  ResultSet FOR EXECUTE v_QueryStr1; 
        RETURN NEXT  ResultSet; 
    END IF;
    
    
END;
$$LANGUAGE plpgsql;
